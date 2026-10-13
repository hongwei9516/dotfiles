# ==========================================
# Zsh Plugins
# ==========================================
if [[ -n "$BREW_PREFIX" ]]; then

  function zvm_config() {
    ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
    ZVM_VI_INSERT_ESCAPE_BINDKEY=jk
  }

  function zvm_after_init() {
    zvm_bindkey viins '^R' fzf-history-widget
  }

  typeset zsh_vi_mode="$BREW_PREFIX/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
  typeset zsh_autosuggest="$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  typeset zsh_syntax="$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  typeset zsh_forgit="$BREW_PREFIX/share/forgit/forgit.plugin.zsh"
  
  [[ -f "$zsh_vi_mode" ]] && source "$zsh_vi_mode"
  [[ -f "$zsh_autosuggest" ]] && source "$zsh_autosuggest"
  [[ -f "$zsh_syntax" ]] && source "$zsh_syntax"
  [[ -f "$zsh_forgit" ]] && source "$zsh_forgit"

fi
