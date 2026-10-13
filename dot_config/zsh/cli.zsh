# ==========================================
# CLI Tools
# ==========================================
(( $+commands[fzf] )) && source <(fzf --zsh)
(( $+commands[zoxide] )) && eval "$(zoxide init --cmd cd zsh)"
(( $+commands[starship] )) && eval "$(starship init zsh)"
