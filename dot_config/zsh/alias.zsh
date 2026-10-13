# ==========================================
# Aliases
# ==========================================

alias ls='eza --icons=auto --color=auto --group-directories-first'
alias ll='eza -lagh --git --octal-permissions'

alias df='df -h'
alias grep='grep --color=auto'
alias nf='fastfetch'
alias lg='lazygit'
alias wget='wget --hsts-file=/dev/null'

alias cz='chezmoi'
alias cza='chezmoi add'
alias czcd='chezmoi cd'
alias czdf='chezmoi diff'
alias cze='chezmoi edit'
alias czfg='chezmoi forget'
alias czmg='chezmoi merge'
alias czp='chezmoi apply'
alias czs='chezmoi status'
alias czu='chezmoi update'

alias ez='nvim ${ZDOTDIR:-$HOME}/.zshrc'
alias sz='source ${ZDOTDIR:-$HOME}/.zshrc'
