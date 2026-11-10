# Completions

# Load completion menu module
zmodload -i zsh/complist

# Initialize completion system
autoload -Uz compinit
compinit

# Case-insensitive and fuzzy-like matching
zstyle ':completion:*' matcher-list \
    'm:{a-zA-Z}={A-Za-z}' \
    'r:|[._-]=* r:|=*' \
    'l:|=* r:|=*'

# Enable interactive completion menu
zstyle ':completion:*' menu select

# Use hjkl to navigate the completion menu
bindkey -M menuselect 'h' backward-char
bindkey -M menuselect 'j' down-line-or-history
bindkey -M menuselect 'k' up-line-or-history
bindkey -M menuselect 'l' forward-char
