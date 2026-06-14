# cch

[English](README.md)

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

如果缺少 `fzf`，请先安装：

```bash
brew install fzf          # 使用 Homebrew 的 macOS
sudo port install fzf     # 使用 MacPorts 的 macOS
sudo apt install fzf      # Ubuntu/Debian
```

## 安装

无需 clone，直接从 GitHub 最新 Release 安装：

```bash
mkdir -p "$HOME/.local/bin"
curl -fsSL https://github.com/malikwang/cch/releases/latest/download/cch -o "$HOME/.local/bin/cch"
chmod +x "$HOME/.local/bin/cch"
```

也可以使用安装脚本：

```bash
curl -fsSL https://github.com/malikwang/cch/releases/latest/download/install.sh | bash
```

如果想从源码安装，可以克隆仓库，并把可执行脚本链接到 PATH 中：


```bash
git clone git@github.com:malikwang/cch.git "$HOME/src/cch"
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
