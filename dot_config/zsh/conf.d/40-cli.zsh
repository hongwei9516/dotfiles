# Cli
# Fzf
if type fzf &>/dev/null; then
source <(fzf --zsh)
fi

# Zoxide
if type zoxide &>/dev/null; then
    eval "$(zoxide init --cmd cd zsh)"
fi

# Starship
if type starship &>/dev/null; then
    eval "$(starship init zsh)"
fi

# Leaf
if type leaf &>/dev/null; then
    source "$HOME/.local/share/leaf/completions/_leaf"
fi
