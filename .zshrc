# ============================================================================
# Locale
# ============================================================================
export LANG=ja_JP.UTF-8
export LC_CTYPE=ja_JP.UTF-8

# ============================================================================
# Aliases
# ============================================================================
bindkey -v
bindkey '^R' history-incremental-search-backward

# ============================================================================
# Zinit - Plugin Manager
# ============================================================================
source /opt/homebrew/share/zinit/zinit.zsh
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

autoload -Uz compinit && compinit

zinit ice pick"async.zsh" src"pure.zsh"
zinit light sindresorhus/pure

# ============================================================================
# Homebrew keg-only packages
# ============================================================================
export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"

# ============================================================================
# Tool Version Management
# ============================================================================
# mise manages: Node.js, Go, Python, Terraform, LSP servers
# Configuration: ~/.config/mise/config.toml
eval "$(mise activate zsh)"

# ============================================================================
# Local Configuration
# ============================================================================
# ローカル設定の読み込み（シークレット情報など、gitで管理しない）
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
