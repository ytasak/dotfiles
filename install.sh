#!/bin/bash
#
# Dotfiles セットアップスクリプト
# macOS用のシンボリックリンク作成とツールインストールを行う
#

set -e  # エラー時に即座に終了

# ============================================================================
# 色付き出力用のヘルパー関数
# ============================================================================
info()    { echo "✅ $*"; }
warn()    { echo "⚠️  $*"; }
error()   { echo "❌ $*" >&2; exit 1; }

# ============================================================================
# パス設定
# ============================================================================
HOME_DIR="$HOME"
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_DIR="$HOME_DIR/.config"
CLAUDE_DIR="$HOME_DIR/.claude"
SSH_DIR="$HOME_DIR/.ssh"
LOCAL_BIN_DIR="$HOME_DIR/.local/bin"

# ============================================================================
# シンボリックリンク作成関数
# 引数: $1 = dotfiles内のソースパス, $2 = リンク先のパス
# ============================================================================
create_symlink() {
    local src="$DOTFILES_DIR/$1"
    local dst="$2"

    # ソースファイルの存在確認
    if [[ ! -e "$src" ]]; then
        warn "$1 が存在しません、スキップします"
        return 0
    fi

    # リンク先が既に存在する場合の処理
    if [[ -L "$dst" ]]; then
        # 既にシンボリックリンクの場合
        local current_target
        current_target=$(readlink "$dst")
        if [[ "$current_target" == "$src" ]]; then
            warn "$1 のシンボリックリンク作成をスキップ: 既に正しいシンボリックリンクが存在します"
            return 0
        fi
    elif [[ -e "$dst" ]]; then
        # 通常のファイル/ディレクトリが存在する場合
        warn "$1 のシンボリックリンク作成をスキップ: 既にファイル/ディレクトリが存在します"
        return 0
    fi

    # シンボリックリンクを作成
    ln -s "$src" "$dst"
    info "$dst → $src"
}

# ============================================================================
# コマンド存在確認関数
# ============================================================================
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# ============================================================================
# メイン処理
# ============================================================================
echo "🔧 Dotfiles セットアップを開始します..."

# dotfilesディレクトリの存在確認
if [[ ! -d "$DOTFILES_DIR" ]]; then
    error "dotfilesディレクトリが見つかりません: $DOTFILES_DIR"
fi

# ----------------------------------------------------------------------------
# Homebrewのインストール
# ----------------------------------------------------------------------------
echo ""
echo "🍺 Homebrew をセットアップします..."

if ! command_exists brew; then
    echo "Homebrew をインストールしています..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    info "Homebrew のインストール完了"
else
    info "Homebrew は既にインストールされています"
fi

# Apple Silicon Mac用のPATH設定（現在のシェルセッションに適用）
if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# ----------------------------------------------------------------------------
# Brewfileからツールをインストール
# ----------------------------------------------------------------------------
echo ""
echo "📦 Brewfile からツールをインストールします..."

if [[ -f "$DOTFILES_DIR/Brewfile" ]]; then
    if brew bundle --file="$DOTFILES_DIR/Brewfile"; then
        info "Brewfile のインストール完了"
    else
        warn "brew bundle に失敗（一部のパッケージがインストールできなかった可能性があります）"
    fi
else
    warn "Brewfile が見つかりません: $DOTFILES_DIR/Brewfile"
fi

# ----------------------------------------------------------------------------
# 必要なディレクトリの作成
# ----------------------------------------------------------------------------
mkdir -p "$CONFIG_DIR"
mkdir -p "$CLAUDE_DIR"
mkdir -p "$SSH_DIR" && chmod 700 "$SSH_DIR"
mkdir -p "$LOCAL_BIN_DIR"

# ----------------------------------------------------------------------------
# シンボリックリンクの作成
# ----------------------------------------------------------------------------

# シェル設定
create_symlink ".zshrc" "$HOME_DIR/.zshrc"

# ~/.config配下のアプリケーション設定
create_symlink "ghostty" "$CONFIG_DIR/ghostty"
create_symlink "mise"    "$CONFIG_DIR/mise"
create_symlink "zellij"  "$CONFIG_DIR/zellij"
create_symlink "helix"   "$CONFIG_DIR/helix"
create_symlink "yazi"    "$CONFIG_DIR/yazi"

# Claude Code設定
create_symlink "claude/CLAUDE.md"     "$CLAUDE_DIR/CLAUDE.md"
create_symlink "claude/settings.json" "$CLAUDE_DIR/settings.json"

# SSH設定
create_symlink "ssh/config" "$SSH_DIR/config"

# カスタムスクリプト
create_symlink "bin/ide" "$LOCAL_BIN_DIR/ide"

# Hammerspoon設定
create_symlink "hammerspoon" "$HOME_DIR/.hammerspoon"

# ----------------------------------------------------------------------------
# miseによるツールインストール
# ----------------------------------------------------------------------------
echo ""
echo "📦 mise でツールをインストールします..."

if ! command_exists mise; then
    warn "mise がインストールされていません"
    echo "   インストール方法: https://mise.jdx.dev/getting-started.html"
else
    if mise install; then
        info "mise ツールのインストール完了"
    else
        warn "mise install に失敗"
    fi
fi

# ----------------------------------------------------------------------------
# Yazi Dracula flavorのインストール
# ----------------------------------------------------------------------------
echo ""
echo "🎨 Yazi Dracula テーマをインストールします..."

YAZI_FLAVORS_DIR="$CONFIG_DIR/yazi/flavors"
DRACULA_FLAVOR_DIR="$YAZI_FLAVORS_DIR/dracula.yazi"

if [[ -d "$DRACULA_FLAVOR_DIR" ]]; then
    info "Yazi Dracula flavor は既にインストールされています"
else
    mkdir -p "$YAZI_FLAVORS_DIR"
    if git clone https://github.com/dracula/yazi.git "$DRACULA_FLAVOR_DIR" 2>/dev/null; then
        info "Yazi Dracula flavor のインストール完了"
    else
        warn "Yazi Dracula flavor のインストールに失敗"
    fi
fi

# ----------------------------------------------------------------------------
# ローカル設定ファイルの案内
# ----------------------------------------------------------------------------
echo ""
echo "💡 オプション: ローカル設定ファイル"

ZSHRC_LOCAL="$HOME_DIR/.zshrc.local"
if [[ ! -f "$ZSHRC_LOCAL" ]]; then
    echo "GitHub Tokenなどの秘密情報を設定する場合:"
    echo "  cp $DOTFILES_DIR/.zshrc.local.example $ZSHRC_LOCAL"
    echo "  chmod 600 $ZSHRC_LOCAL"
    echo "  # エディタで編集してGITHUB_TOKENなどを設定"
else
    info "~/.zshrc.local が既に存在します"
fi

# ----------------------------------------------------------------------------
# 完了メッセージ
# ----------------------------------------------------------------------------
echo ""
echo "🎉 セットアップ完了！"
echo ""
echo "次のステップ:"
echo "1. ターミナルを再起動するか、\`source ~/.zshrc\` を実行"
