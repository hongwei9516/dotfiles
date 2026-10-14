# ==========================================
# Options & Environment
# ==========================================
setopt inc_append_history
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups
setopt hist_expire_dups_first
setopt hist_reduce_blanks

# XDG defaults (for non-login shells that skip ~/.zprofile)
: "${XDG_CONFIG_HOME:=$HOME/.config}"
: "${XDG_DATA_HOME:=$HOME/.local/share}"
: "${XDG_CACHE_HOME:=$HOME/.cache}"

# `brew shellenv` in ~/.zprofile already exports HOMEBREW_PREFIX; reuse it
# instead of forking `brew --prefix` on every interactive shell.
BREW_PREFIX=${HOMEBREW_PREFIX:-$(brew --prefix)}

# PATH (leftmost = highest precedence)
typeset -U path   # keep PATH entries unique
path=(
  "$XDG_DATA_HOME/bin"(N-/)          # personal scripts
  "$BREW_PREFIX/bin"(N-/)            # homebrew bin
  "$BREW_PREFIX/sbin"(N-/)           # homebrew sbin
  "$BREW_PREFIX/opt/rustup/bin"(N-/) # rustup toolchain
  "$XDG_DATA_HOME/cargo/bin"(N-/)    # cargo-installed binaries
  "$path[@]"
)
export PATH

# homebrew env
export HOMEBREW_NO_INSTALL_FROM_API=1
export HOMEBREW_NO_ASK=1

# node npm
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/npm/npmrc"

# rustup cargo
export RUSTUP_HOME=$XDG_DATA_HOME/rustup
export CARGO_HOME=$XDG_DATA_HOME/cargo

# pi-coding-agent
export PI_CODING_AGENT_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/pi/agent"

# copilot
export COPILOT_HOME="$XDG_CONFIG_HOME/copilot"
