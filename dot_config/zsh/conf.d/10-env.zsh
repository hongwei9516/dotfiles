# Env
export BREW_PREFIX="${HOMEBREW_PREFIX:-/opt/homebrew}"

# Rust
export RUSTUP_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/rustup"
export CARGO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/cargo"

# Node
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/npm/npmrc"

# Tuxedo
export TODO_DIR="$HOME/.local/share/todo"
export TODO_FILE="$TODO_DIR/todo.txt"
export DONE_FILE="$TODO_DIR/done.txt"

typeset -gUx path fpath

path=(
    "$HOME/.local/bin"(N)
    "$BREW_PREFIX/opt/rustup/bin"(N)
    "$CARGO_HOME/bin"(N)
    $path
)
fpath=(
    "$HOME/.local/zsh-completions"(N)
    "$BREW_PREFIX/share/zsh-completions"(N)
    "$BREW_PREFIX/share/zsh/site-functions"(N)
    $fpath
)

