# Env
export BREW_PREFIX="${HOMEBREW_PREFIX:-/opt/homebrew}"

# Rust
export RUSTUP_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/rustup"
export CARGO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/cargo"

# Node
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/npm/npmrc"

typeset -gUx path fpath

path=(
    "$HOME/.local/bin"(N)
    "$BREW_PREFIX/opt/rustup/bin"(N)
    $path
)
fpath=(
    "$BREW_PREFIX/share/zsh-completions"(N)
    "$BREW_PREFIX/share/zsh/site-functions"(N)
    $fpath
)

