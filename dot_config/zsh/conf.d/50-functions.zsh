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

    local glow_style=light
    [[ "$(osascript -e 'tell application "System Events" to tell appearance preferences to get dark mode')" == "true" ]] && glow_style=dark

    [[ -d "$command_dir" ]] || return 1

    command_name=$(fd -t f -e md -C "$command_dir" | sed 's/\.md$//' | \
        fzf --prompt 'linux-command>' --preview "glow -s '$glow_style' -p '$command_dir'/{}.md")

    if [[ -n "$command_name" ]]; then
        command_file="$command_dir"/"${command_name}".md
        if [[ -f "$command_file" ]]; then
            glow -s "$glow_style" -p "$command_file"
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
