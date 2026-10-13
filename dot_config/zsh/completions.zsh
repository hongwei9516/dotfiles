# ==========================================
# zsh-completions & Compinit
# ==========================================
if type brew &>/dev/null; then
  FPATH="$BREW_PREFIX/share/zsh-completions:$BREW_PREFIX/share/zsh/site-functions:$FPATH"
fi

autoload -Uz compinit
ZCOMPDUMP="${ZDOTDIR:-$HOME}/.zcompdump"
if [[ -s "$ZCOMPDUMP" && $(find "$ZCOMPDUMP" -mtime -1 2>/dev/null) ]]; then
  compinit -C
else
  compinit
  { command rm -f "$ZCOMPDUMP.zwc" && zcompile "$ZCOMPDUMP" } &!
fi

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu select

if (( $+commands[gdircolors] )); then
  eval "$(gdircolors -b)"
elif [[ -z "$LS_COLORS" ]]; then
  export LS_COLORS='di=1;34:ln=1;36:so=1;32:pi=1;33:ex=1;32:bd=1;33:cd=1;33:su=1;37;41:sg=1;37;43:tw=1;37;42:ow=1;37;44:or=1;31:mi=1;31:*.tar=1;31:*.tgz=1;31:*.gz=1;31:*.xz=1;31:*.zip=1;31:*.zst=1;31:*.bz2=1;31:*.7z=1;31:*.rar=1;31:*.jpg=1;35:*.jpeg=1;35:*.png=1;35:*.gif=1;35:*.svg=1;35:*.pdf=1;33:*.md=1;33:*.txt=1;32:*.sh=1;32:*.py=1;32:*.js=1;32:*.json=1;32:*.yml=1;32:*.yaml=1;32:*.toml=1;32:*.conf=1;32:*.mp3=1;36:*.mp4=1;36:*.mov=1;36:*.mkv=1;36'
fi
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
