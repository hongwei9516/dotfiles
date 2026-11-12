# Functions
# Yazi
function y() {
	local tmp cwd; tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd" || builtin true
	command rm -f -- "$tmp"
}

fl() {
    local command_dir="$HOME/Documents/linux-command/command"
    local command_name
    local command_file

    local leaf_theme=arctic
    [[ "$(osascript -e 'tell application "System Events" to tell appearance preferences to get dark mode')" == "true" ]] && leaf_theme=ocean-dark

    [[ -d "$command_dir" ]] || return 1

    command_name=$(fd -t f -e md -C "$command_dir" | sed 's/\.md$//' | \
        fzf --prompt 'linux-command>' --preview "leaf --theme '$leaf_theme' --inline ansi:\$FZF_PREVIEW_COLUMNS '$command_dir'/{}.md")

    if [[ -n "$command_name" ]]; then
        command_file="$command_dir"/"${command_name}".md
        if [[ -f "$command_file" ]]; then
            leaf --theme "$leaf_theme" "$command_file"
        fi
    fi
}

bat() {
    if [[ "$(osascript -e 'tell application "System Events" to tell appearance preferences to get dark mode')" == "true" ]]; then
        command bat --theme='Catppuccin Mocha' "$@"
    else
        command bat --theme='Catppuccin Latte' "$@"
    fi
}

glow() {
    if [[ "$(osascript -e 'tell application "System Events" to tell appearance preferences to get dark mode')" == "true" ]]; then
        command glow -s dark "$@"
    else
        command glow -s light "$@"
    fi
}


kp() {
    local duration

    if [[ -z "$1" ]]; then
        open -g "keepingyouawake:///toggle"
        return
    fi

    if [[ "$1" == "m" || "$1" == "h" ]]; then
        case "$1" in
            m) duration="minutes" ;;
            h) duration="hours" ;;
        esac

        if [[ "$2" =~ '^[1-9][0-9]*$' ]]; then
            open -g "keepingyouawake:///activate?$duration=$2"
        else
            echo "Usage: keep [m|h] <positive_integer>"
            return 1
        fi

    elif [[ "$1" =~ '^[1-9][0-9]*$' ]]; then
        open -g "keepingyouawake:///activate?hours=$1"

    else
        echo "Usage: keep [m|h] <positive_integer>"
        return 1
    fi
}

desktop() {
    case "$1" in
        hide)
            defaults write com.apple.finder CreateDesktop -bool false ;;
        show)
            defaults write com.apple.finder CreateDesktop -bool true ;;
        *)
            echo "Usage: dt [hide|show]"
            return 1
            ;;
    esac
    killall Finder
}

_nof_core() {
    local change_dir="$1"
    local file selected first_dir
    local bat_theme='Catppuccin Latte'
    local -a files

    # 检测 macOS 外观模式
    if [[ "$(osascript -e 'tell application "System Events" to tell appearance preferences to get dark mode')" == "true" ]]; then
        bat_theme='Catppuccin Mocha'
    fi

    # 1. 从 Neovim 获取历史文件并过滤无效路径
    selected=$(
        nvim -u NONE --headless \
            +'lua for _, f in ipairs(vim.v.oldfiles) do io.write(vim.fn.fnamemodify(f, ":p") .. "\n") end' \
            +qa |
        while IFS= read -r file; do
            [[ -f "$file" ]] && print -r -- "$file"
        done |
        fzf --multi \
            --preview "bat --theme '$bat_theme' -n --color=always --line-range=:500 {} 2>/dev/null || echo 'Error previewing file'" \
            --height=70% \
            --layout=reverse
    )

    # 2. 未选择任何文件则退出
    [[ -n "$selected" ]] || return 0

    # 3. 转换为 zsh 数组
    files=("${(@f)selected}")

    # 4. 如果启用切换目录，则跳转到第一个选中文件所在的目录
    if [[ "$change_dir" == true ]]; then
        first_dir=${files[1]:h}
        cd -- "$first_dir" || return 1
    fi

    # 5. 在 Neovim 中打开选中的文件
    nvim "${files[@]}"
}

# 打开历史文件（切换当前目录）
nof() {
    _nof_core true
}

# 打开历史文件（不切换当前目录）
no() {
    _nof_core false
}
