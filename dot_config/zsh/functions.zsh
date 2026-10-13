# ==========================================
# Custom Functions
# ==========================================

# yazi
y() {
  local tmp cwd
  tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  command yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd" || return
  fi
  command rm -f -- "$tmp"
}

fl() {
  local dir="$HOME/Documents/linux-command/command"
  local -a files
  local selected

  [[ -d $dir ]] || { print -u2 "fl: directory not found: $dir"; return 1 }

  files=( "$dir"/**/*.md(.N) )
  (( ${#files} )) || { print -u2 "fl: no markdown files in $dir"; return 1 }
  files=( ${files#"$dir"/} )   
  files=( ${files%.md} )       

  selected=$(
    export FL_DIR="$dir"
    print -rl -- $files \
      | fzf --prompt='LinuxCommands> ' \
            --preview 'glow -p "$FL_DIR"/{}.md' \
            --preview-window=right,75%
  ) || return 0   

  [[ -n $selected ]] && glow -p "$dir/$selected.md"
}

z() {
  local dir=$(
    zoxide query --list --score |
    fzf --height 40% --layout reverse --info inline \
        --nth 2.. --tac --no-sort --query "$*" \
        --bind 'enter:become:echo {2..}'
  ) && cd "$dir"
}
