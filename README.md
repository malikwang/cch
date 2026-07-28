# cch

[中文文档](README.zh-CN.md)

`cch` is a local conversation history search tool for Claude Code, Codex CLI, and Kiro CLI.
It builds a lightweight cache from local JSONL session files, lets you fuzzy-search with `fzf`, previews matching conversations, and outputs or directly runs the correct resume command.

## Features

- Search Claude Code history from `~/.claude/projects`.
- Search Codex history from `~/.codex/sessions`.
- Search Kiro CLI history from `~/.kiro/sessions`.
- Filter by source with `--source claude`, `--source codex`, `--source kiro`, or `--source all`.
- Preview selected conversations in `fzf`.
- Resume directly with `Ctrl-R`.
- Detect Kiro sessions that are still open in another process and close the holder so the resume works instead of hanging.
- Print preview or raw JSONL paths with `Ctrl-P` and `Ctrl-J`.
- Hide noisy sessions (e.g. sub-agent prompts) whose first message matches blacklist keywords.
- Rebuild or clean the cache when needed.

## Requirements

- Bash
- Python 3
- `fzf`
- `claude` CLI for Claude session resume
- `codex` CLI for Codex session resume
- `kiro-cli` CLI for Kiro session resume

Install `fzf` first if it is missing:

```bash
brew install fzf          # macOS with Homebrew
sudo port install fzf     # macOS with MacPorts
sudo apt install fzf      # Ubuntu/Debian
```

## Install

Install from the latest GitHub release without cloning:

```bash
mkdir -p "$HOME/.local/bin"
curl -fsSL https://github.com/malikwang/cch/releases/latest/download/cch -o "$HOME/.local/bin/cch"
chmod +x "$HOME/.local/bin/cch"
```

Or use the installer script:

```bash
curl -fsSL https://github.com/malikwang/cch/releases/latest/download/install.sh | bash
```

To install from source instead, clone the repository and link the executable into your PATH:


```bash
git clone git@github.com:malikwang/cch.git "$HOME/src/cch"
mkdir -p "$HOME/bin" "$HOME/.local/bin"
ln -sf "$HOME/src/cch/cch" "$HOME/bin/cch"
ln -sf ~/bin/cch ~/.local/bin/cch
```

## Usage

```bash
cch                         # search all conversations
cch bug keyword             # search all conversations with an initial query
cch -s codex keyword        # search Codex conversations only
cch -s claude keyword       # search Claude conversations only
cch -s kiro keyword         # search Kiro conversations only
cch --rebuild               # force rebuild cache
cch --clean                 # remove cache and rebuild
cch --cache                 # print cache directory
cch --no-takeover           # refuse instead of closing a locked Kiro session
cch --no-blacklist          # show all sessions, ignoring blacklist keywords
```

## Locked Kiro sessions

`kiro-cli` takes a per-session lock while a session is open. Resuming the same
session id from a second terminal makes the TUI sit at `Initializing...`
forever: the underlying ACP layer does reject the load with
`Session is active in another process (PID N)`, but the TUI never renders that
error — it only lands in `/tmp/kiro-log/kiro-tui.log`.

Before resuming, `cch` reads the session's `.lock` file and checks whether the
recorded PID is still alive. By default it takes the session over: it asks the
holding `kiro-cli chat` process to quit (escalating to `SIGKILL` if it ignores
`SIGTERM`), removes the leftover lock, and then resumes normally. Conversation
history is flushed to the `.jsonl` store continuously, so closing the holder
does not lose anything — but any unsent input in that terminal is discarded.
Stale locks whose owner is already gone are ignored.

Pass `--no-takeover` (or set `CCH_KIRO_TAKEOVER=0`) to leave the other process
alone. `cch` then refuses, printing the holder's PID, tty and start time along
with the ways out.

## Blacklist

Automated runs (sub-agent review prompts, one-off JSON instructions, etc.) leave
behind sessions you rarely want to resume. `cch` can hide any session whose
indexed content contains a blacklist keyword.

Keywords come from two places, merged together:

- The blacklist file, one keyword per line. Lines starting with `#` are comments
  and blank lines are ignored. Default path is `~/.config/cch/blacklist`
  (override with `CCH_BLACKLIST_FILE`).
- The `CCH_BLACKLIST` environment variable, newline-separated.

Matching is a case-insensitive substring test against the session's first
message (the prompt that started it), so a keyword that merely appears later in
the conversation body will not hide an otherwise wanted session. Example
`~/.config/cch/blacklist`:

```
# hide sub-agent review sessions
Review Agent
Post-Analysis Review Agent
```

Filtering happens at display time, so editing the blacklist takes effect on the
next run without rebuilding the cache. Pass `--no-blacklist` to show everything
for a single run.

## Key Bindings

- `Enter`: print the resume command.
- `Ctrl-R`: directly resume the selected conversation.
- `Ctrl-P`: print the generated preview file path.
- `Ctrl-J`: print the raw JSONL session file path.

## Environment Variables

- `CLAUDE_DIR`: Claude history directory, default `~/.claude/projects`.
- `CODEX_DIR`: Codex history directory, default `~/.codex/sessions`.
- `KIRO_DIR`: Kiro history directory, default `~/.kiro/sessions`.
- `CCH_KIRO_BIN`: Kiro CLI binary used for resume, default `kiro-cli`.
- `CCH_CACHE_DIR`: cache directory, default `~/.cache/cch`.
- `CCH_SOURCE`: default source filter, one of `all`, `claude`, `codex`, or `kiro`.
- `CCH_KIRO_TAKEOVER`: set to `0` to refuse instead of closing a locked Kiro session, same as `--no-takeover`.
- `CCH_BLACKLIST`: newline-separated keywords; any session whose first message contains one is hidden.
- `CCH_BLACKLIST_FILE`: blacklist file path, default `~/.config/cch/blacklist`.

## Cache

`cch` stores generated index files under `~/.cache/cch` by default. These files are derived from local conversation histories and are not required in the repository.
