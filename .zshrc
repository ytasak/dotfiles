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

# ============================================================================
# Completion
# ============================================================================
# compinit は -C なしだと毎回 compaudit が走り、fpath 内の全ファイルを
# stat する。warm で 45ms、cold では数秒に達するため起動時間の主要因。
# -C はこの監査を丸ごと省略するが、fpath に第三者が書き込み可能な
# ディレクトリが混入しても検知できなくなる。そこで「たまに監査する」形にする。
autoload -Uz compinit
() {
  local dump=${ZDOTDIR:-$HOME}/.zcompdump

  # 20時間以内に更新された dump があれば -C で監査を省略、
  # 古い or 存在しない場合のみ監査付き compinit を走らせる。
  # 24時間だと「前日より少し早く作業開始した日」に監査を飛ばしてしまうため、
  # 1日1回は確実に当たる20時間にしている。
  # グロブ修飾子: N=該当なしなら空 . =通常ファイルのみ mh-20=20時間以内に更新
  # 注: (#q...) 形式は EXTENDED_GLOB 依存、かつ [[ ]] 内では
  # ファイル名生成が行われないため、配列代入で評価する必要がある。
  local -a fresh
  fresh=( ${dump}(N.mh-20) )
  if (( $#fresh )); then
    compinit -C -d $dump
  else
    compinit -d $dump
  fi
}

# 補完で大文字小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# ============================================================================
# Prompt Theme: pure
# ============================================================================
# プラグインより先に読み込み、プロンプトを最速で表示する
zinit ice pick"async.zsh" src"pure.zsh"
zinit light sindresorhus/pure

# ============================================================================
# Zsh Plugins (turbo mode)
# ============================================================================
# wait lucid = プロンプト表示後に非同期ロード。
# 同期ロードだと syntax-highlighting(3.5MB) と completions(5.2MB) の
# 読み込み完了までプロンプトが出ず、初回起動の体感待ちが大きくなる。
zinit wait lucid light-mode for \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zsh-users/zsh-autosuggestions \
    zsh-users/zsh-completions \
    chrissicool/zsh-256color \
    zdharma-continuum/history-search-multi-word \
    zsh-users/zsh-syntax-highlighting

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
# --shims なら約120ms 速いが、cd 時の .mise.toml 自動反映と [env] の
# 環境変数が効かなくなるため activate を維持する。
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
