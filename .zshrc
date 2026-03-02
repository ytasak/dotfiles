# ============================================================================
# Locale & Terminal
# ============================================================================
export LANG=ja_JP.UTF-8
export LC_CTYPE=ja_JP.UTF-8
export COLORTERM=truecolor

# ============================================================================
# Aliases
# ============================================================================
bindkey -v
bindkey '^R' history-incremental-search-backward

# ============================================================================
# Zinit - Plugin Manager
# ============================================================================
source /opt/homebrew/opt/zinit/zinit.zsh
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# ============================================================================
# Zsh Plugins
# ============================================================================
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light chrissicool/zsh-256color
zinit light zdharma/history-search-multi-word

autoload -Uz compinit && compinit

# 補完で大文字小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Prompt Theme: typewritten (singleline layout)
export TYPEWRITTEN_PROMPT_LAYOUT="singleline"
zinit light reobin/typewritten

# ============================================================================
# PATH
# ============================================================================
export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"

# ============================================================================
# Tool Version Management
# ============================================================================
# mise manages: Node.js, Go, Python, Terraform, LSP servers
# Configuration: ~/.config/mise/config.toml
eval "$(mise activate zsh)"

# ============================================================================
# Directory Navigation
# ============================================================================
eval "$(zoxide init zsh)"

# ============================================================================
# Local Configuration
# ============================================================================
# ローカル設定の読み込み（シークレット情報など、gitで管理しない）
[ -f ~/.zshrc.local ] && source ~/.zshrc.local || true
