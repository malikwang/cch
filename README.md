# cch

[中文文档](README.zh-CN.md)

`cch` is a local conversation history search tool for Claude Code and Codex CLI.
It builds a lightweight cache from local JSONL session files, lets you fuzzy-search with `fzf`, previews matching conversations, and outputs or directly runs the correct resume command.

## Features

- Search Claude Code history from `~/.claude/projects`.
- Search Codex history from `~/.codex/sessions`.
- Filter by source with `--source claude`, `--source codex`, or `--source all`.
- Preview selected conversations in `fzf`.
- Resume directly with `Ctrl-R`.
- Print preview or raw JSONL paths with `Ctrl-P` and `Ctrl-J`.
- Rebuild or clean the cache when needed.

## Requirements

- Bash
- Python 3
- `fzf`
- `claude` CLI for Claude session resume
- `codex` CLI for Codex session resume

## Install

Install from the latest GitHub release without cloning:

```bash
mkdir -p "$HOME/.local/bin"
curl -fsSL https://github.com/<owner>/<repo>/releases/latest/download/cch -o "$HOME/.local/bin/cch"
chmod +x "$HOME/.local/bin/cch"
```

Or use the installer script:

```bash
curl -fsSL https://github.com/<owner>/<repo>/releases/latest/download/install.sh | CCH_REPO=<owner>/<repo> bash
```

To install from source instead, clone the repository and link the executable into your PATH:


```bash
git clone <your-cch-repo-url> "$HOME/src/cch"
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
cch --rebuild               # force rebuild cache
cch --clean                 # remove cache and rebuild
cch --cache                 # print cache directory
```

## Key Bindings

- `Enter`: print the resume command.
- `Ctrl-R`: directly resume the selected conversation.
- `Ctrl-P`: print the generated preview file path.
- `Ctrl-J`: print the raw JSONL session file path.

## Environment Variables

- `CLAUDE_DIR`: Claude history directory, default `~/.claude/projects`.
- `CODEX_DIR`: Codex history directory, default `~/.codex/sessions`.
- `CCH_CACHE_DIR`: cache directory, default `~/.cache/cch`.
- `CCH_SOURCE`: default source filter, one of `all`, `claude`, or `codex`.

## Cache

`cch` stores generated index files under `~/.cache/cch` by default. These files are derived from local conversation histories and are not required in the repository.
