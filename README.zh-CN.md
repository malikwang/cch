# cch

[English](README.md)

`cch` 是一个本地对话历史搜索工具，支持搜索 Claude Code、Codex CLI 和 Kiro CLI 的历史会话。
它会从本机 JSONL 会话文件中生成轻量缓存，通过 `fzf` 提供模糊搜索、会话预览，并可以输出或直接执行对应的恢复命令。

## 功能特性

- 搜索 Claude Code 历史记录，默认来源为 `~/.claude/projects`。
- 搜索 Codex 历史记录，默认来源为 `~/.codex/sessions`。
- 搜索 Kiro CLI 历史记录，默认来源为 `~/.kiro/sessions`。
- 通过 `--source claude`、`--source codex`、`--source kiro` 或 `--source all` 按来源过滤。
- 在 `fzf` 右侧窗口预览命中的会话内容。
- 使用 `Ctrl-R` 直接恢复选中的会话。
- 恢复 Kiro 会话前检测会话锁，若仍被其他进程占用则自动关闭占用进程并接管，而不是卡在初始化。
- 使用 `Ctrl-P` 输出预览文件路径，使用 `Ctrl-J` 输出原始 JSONL 文件路径。
- 按黑名单关键词隐藏无关会话（例如子代理提示词自动生成的会话，只匹配会话首条消息）。
- 支持强制重建缓存或清理缓存后重建。

## 依赖

- Bash
- Python 3
- `fzf`
- `claude` CLI，用于恢复 Claude 会话
- `codex` CLI，用于恢复 Codex 会话
- `kiro-cli` CLI，用于恢复 Kiro 会话

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
cch -s kiro keyword         # 只搜索 Kiro 会话
cch --rebuild               # 强制重建缓存
cch --clean                 # 清理缓存并重建
cch --cache                 # 输出缓存目录
cch --no-takeover           # 会话锁被占用时直接报错，不关闭占用进程
cch --no-blacklist          # 忽略黑名单，显示全部会话
```

## Kiro 会话锁

`kiro-cli` 打开会话时会加一把按会话的锁。在第二个终端恢复同一个会话 id，TUI 会
永远停在 `Initializing...`：底层 ACP 其实已经返回了
`Session is active in another process (PID N)`，但 TUI 没有把这个错误渲染出来，
只写进了 `/tmp/kiro-log/kiro-tui.log`。

`cch` 在恢复前会读取会话对应的 `.lock` 文件，判断里面记录的 PID 是否仍然存活。
默认直接接管：先让占用的 `kiro-cli chat` 进程正常退出（忽略 `SIGTERM` 时升级为
`SIGKILL`），清掉残留的锁文件，然后照常恢复。对话历史是持续写入 `.jsonl` 的，
关闭占用进程不会丢历史，但那个终端里还没发送的输入会丢掉。占用者已经退出的
残留锁会被忽略。

加 `--no-takeover`（或设 `CCH_KIRO_TAKEOVER=0`）则不动别的进程，`cch` 会直接
报错，并打印占用进程的 PID、tty、启动时间和几种处理方式。

## 黑名单

自动化运行（子代理审查提示词、一次性 JSON 指令等）会留下一堆你几乎不会去恢复的
会话。`cch` 可以隐藏任何索引内容命中黑名单关键词的会话。

关键词来自两处，会合并使用：

- 黑名单文件，每行一个关键词。以 `#` 开头的行为注释，空行会被忽略。默认路径为
  `~/.config/cch/blacklist`（可用 `CCH_BLACKLIST_FILE` 覆盖）。
- `CCH_BLACKLIST` 环境变量，按换行分隔。

匹配为大小写不敏感的子串匹配，匹配对象仅为会话的**首条消息**（启动该会话的那条
prompt），因此只在对话正文里出现的关键词不会误伤想保留的会话。`~/.config/cch/blacklist`
示例：

```
# 隐藏子代理审查会话
Review Agent
Post-Analysis Review Agent
```

过滤发生在展示阶段，因此修改黑名单后无需重建缓存，下次运行即生效。加
`--no-blacklist` 可在单次运行中显示全部会话。

## 快捷键

- `Enter`：输出恢复会话的命令。
- `Ctrl-R`：直接恢复选中的会话。
- `Ctrl-P`：输出生成的预览文件路径。
- `Ctrl-J`：输出原始 JSONL 会话文件路径。

## 环境变量

- `CLAUDE_DIR`：Claude 历史目录，默认 `~/.claude/projects`。
- `CODEX_DIR`：Codex 历史目录，默认 `~/.codex/sessions`。
- `KIRO_DIR`：Kiro 历史目录，默认 `~/.kiro/sessions`。
- `CCH_KIRO_BIN`：用于恢复的 Kiro CLI 可执行文件，默认 `kiro-cli`。
- `CCH_CACHE_DIR`：缓存目录，默认 `~/.cache/cch`。
- `CCH_SOURCE`：默认搜索来源，可选 `all`、`claude`、`codex` 或 `kiro`。
- `CCH_KIRO_TAKEOVER`：设为 `0` 时不关闭占用进程、直接报错，等价于 `--no-takeover`。
- `CCH_BLACKLIST`：换行分隔的关键词；首条消息命中任一关键词的会话会被隐藏。
- `CCH_BLACKLIST_FILE`：黑名单文件路径，默认 `~/.config/cch/blacklist`。

## 缓存说明

`cch` 默认把生成的索引文件存放在 `~/.cache/cch` 下。这些文件都可以从本地对话历史重新生成，不需要提交到仓库。
