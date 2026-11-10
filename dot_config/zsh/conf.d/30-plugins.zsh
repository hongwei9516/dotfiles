# Plugins
function zvm_config() {
    ZVM_INIT_MODE=sourcing
    ZVM_VI_INSERT_ESCAPE_BINDKEY=jk
}

zsh_plugins=(
  "$BREW_PREFIX/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
  "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
)

for plugin in "${zsh_plugins[@]}"; do
    if [[ -f "$plugin" ]]; then
        source "$plugin"
    fi
done

unset plugin zsh_plugins

