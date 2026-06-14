# cch

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

Clone the repository and link the executable into your PATH:

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

---

# 中文说明

`cch` 是一个本地对话历史搜索工具，支持搜索 Claude Code 和 Codex CLI 的历史会话。
它会从本机 JSONL 会话文件中生成轻量缓存，通过 `fzf` 提供模糊搜索、会话预览，并可以输出或直接执行对应的恢复命令。

## 功能特性

- 搜索 Claude Code 历史记录，默认来源为 `~/.claude/projects`。
- 搜索 Codex 历史记录，默认来源为 `~/.codex/sessions`。
- 通过 `--source claude`、`--source codex` 或 `--source all` 按来源过滤。
- 在 `fzf` 右侧窗口预览命中的会话内容。
- 使用 `Ctrl-R` 直接恢复选中的会话。
- 使用 `Ctrl-P` 输出预览文件路径，使用 `Ctrl-J` 输出原始 JSONL 文件路径。
- 支持强制重建缓存或清理缓存后重建。

## 依赖

- Bash
- Python 3
- `fzf`
- `claude` CLI，用于恢复 Claude 会话
- `codex` CLI，用于恢复 Codex 会话

## 安装

克隆仓库，并把可执行脚本链接到 PATH 中：

```bash
git clone <your-cch-repo-url> "$HOME/src/cch"
mkdir -p "$HOME/bin" "$HOME/.local/bin"
ln -sf "$HOME/src/cch/cch" "$HOME/bin/cch"
ln -sf ~/bin/cch ~/.local/bin/cch
```

## 使用方式

```bash
cch                         # 搜索全部会话
cch bug keyword             # 带初始关键词搜索全部会话
cch -s codex keyword        # 只搜索 Codex 会话
cch -s claude keyword       # 只搜索 Claude 会话
cch --rebuild               # 强制重建缓存
cch --clean                 # 清理缓存并重建
cch --cache                 # 输出缓存目录
```

## 快捷键

- `Enter`：输出恢复会话的命令。
- `Ctrl-R`：直接恢复选中的会话。
- `Ctrl-P`：输出生成的预览文件路径。
- `Ctrl-J`：输出原始 JSONL 会话文件路径。

## 环境变量

- `CLAUDE_DIR`：Claude 历史目录，默认 `~/.claude/projects`。
- `CODEX_DIR`：Codex 历史目录，默认 `~/.codex/sessions`。
- `CCH_CACHE_DIR`：缓存目录，默认 `~/.cache/cch`。
- `CCH_SOURCE`：默认搜索来源，可选 `all`、`claude` 或 `codex`。

## 缓存说明

`cch` 默认把生成的索引文件存放在 `~/.cache/cch` 下。这些文件都可以从本地对话历史重新生成，不需要提交到仓库。
