#!/bin/bash
#
# Dotfiles セットアップスクリプト
# macOS / Linux (Fedora) 用のシンボリックリンク作成とツールインストールを行う
#

set -e  # エラー時に即座に終了

# ============================================================================
# 出力用のヘルパー関数
# ============================================================================
info()    { echo "✅ $*"; }
warn()    { echo "⚠️  $*"; }
error()   { echo "❌ $*" >&2; exit 1; }

# ============================================================================
# パス設定
# ============================================================================
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_DIR="$HOME/.config"
SSH_DIR="$HOME/.ssh"
OS="$(uname -s)"

case "$OS" in
    Darwin|Linux) ;;
    *) error "未対応のOSです: $OS" ;;
esac

# ============================================================================
# シンボリックリンク作成関数
# 引数: $1 = dotfiles内のソースパス, $2 = リンク先のパス
# ============================================================================
create_symlink() {
    local src="$DOTFILES_DIR/$1"
    local dst="$2"

    if [[ ! -e "$src" ]]; then
        warn "$1 が存在しません、スキップします"
        return 0
    fi

    if [[ -L "$dst" ]]; then
        if [[ "$(readlink "$dst")" == "$src" ]]; then
            warn "$1 のシンボリックリンク作成をスキップ: 既に正しいシンボリックリンクが存在します"
            return 0
        fi
        # 別の場所を指すリンクは張り替える。
        # -n がないと、ディレクトリへのリンクを辿ってその中にリンクを作ってしまう
        ln -sfn "$src" "$dst"
        info "${dst} → ${src}（張り替え）"
        return 0
    elif [[ -e "$dst" ]]; then
        warn "$1 のシンボリックリンク作成をスキップ: 既にファイル/ディレクトリが存在します"
        return 0
    fi

    ln -s "$src" "$dst"
    info "$dst → $src"
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

echo "🔧 Dotfiles セットアップを開始します... ($OS)"

# ----------------------------------------------------------------------------
# Linux: Homebrew の前提パッケージと zsh・alacritty (dnf)
# ----------------------------------------------------------------------------
if [[ "$OS" == "Linux" ]]; then
    echo ""
    echo "🐧 dnf でパッケージをインストールします（sudo が必要です）..."
    if command_exists dnf; then
        sudo dnf install -y @development-tools procps-ng curl file git zsh alacritty
        info "dnf パッケージのインストール完了"
    else
        warn "dnf が見つかりません。Fedora 以外では前提パッケージを手動でインストールしてください"
    fi
fi

# ----------------------------------------------------------------------------
# Homebrew
# ----------------------------------------------------------------------------
echo ""
echo "🍺 Homebrew をセットアップします..."

if ! command_exists brew; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    info "Homebrew のインストール完了"
else
    info "Homebrew は既にインストールされています"
fi

# 現在のシェルセッションに brew を通す
for prefix in /opt/homebrew /home/linuxbrew/.linuxbrew; do
    if [[ -x "$prefix/bin/brew" ]]; then
        eval "$("$prefix/bin/brew" shellenv)"
        break
    fi
done

echo ""
echo "📦 Brewfile からツールをインストールします..."
if brew bundle --file="$DOTFILES_DIR/Brewfile"; then
    info "Brewfile のインストール完了"
else
    warn "brew bundle に失敗（一部のパッケージがインストールできなかった可能性があります）"
fi

# ----------------------------------------------------------------------------
# シンボリックリンクの作成
# ----------------------------------------------------------------------------
echo ""
echo "🔗 シンボリックリンクを作成します..."
mkdir -p "$CONFIG_DIR"
mkdir -p "$SSH_DIR" && chmod 700 "$SSH_DIR"

create_symlink ".zshrc"    "$HOME/.zshrc"
create_symlink "alacritty" "$CONFIG_DIR/alacritty"
create_symlink "mise"      "$CONFIG_DIR/mise"
create_symlink "ssh/config" "$SSH_DIR/config"

# ~/.config/herdr には socket・log・session.json などの実行時状態も置かれるため、
# ディレクトリ全体ではなく config.toml 単体をリンクする
mkdir -p "$CONFIG_DIR/herdr"
create_symlink "herdr/config.toml" "$CONFIG_DIR/herdr/config.toml"

# ----------------------------------------------------------------------------
# mise によるツールインストール
# ----------------------------------------------------------------------------
echo ""
echo "📦 mise でツールをインストールします..."
if command_exists mise; then
    mise install && info "mise ツールのインストール完了" || warn "mise install に失敗"
else
    warn "mise がインストールされていません"
fi

# ----------------------------------------------------------------------------
# ログインシェルを zsh に変更（Fedora の既定は bash）
# ----------------------------------------------------------------------------
ZSH_PATH="$(command -v zsh || true)"
if [[ -n "$ZSH_PATH" && "$(basename "${SHELL:-}")" != "zsh" ]]; then
    echo ""
    echo "🐚 ログインシェルを zsh に変更します..."
    chsh -s "$ZSH_PATH" && info "ログインシェルを $ZSH_PATH に変更しました" || warn "chsh に失敗"
fi

# ----------------------------------------------------------------------------
# ローカル設定ファイルの案内
# ----------------------------------------------------------------------------
echo ""
echo "💡 オプション: ローカル設定ファイル"

if [[ ! -f "$HOME/.zshrc.local" ]]; then
    echo "GitHub Tokenなどの秘密情報を設定する場合:"
    echo "  cp $DOTFILES_DIR/.zshrc.local.example ~/.zshrc.local"
    echo "  chmod 600 ~/.zshrc.local"
else
    info "~/.zshrc.local が既に存在します"
fi

if [[ ! -f "$SSH_DIR/config.local" ]]; then
    echo "SSH のローカル設定を追加する場合:"
    echo "  cp $DOTFILES_DIR/ssh/config.local.example ~/.ssh/config.local"
    echo "  chmod 600 ~/.ssh/config.local"
else
    info "~/.ssh/config.local が既に存在します"
fi

echo ""
echo "🎉 セットアップ完了！"
echo "ターミナルを再起動するか、\`exec zsh\` を実行してください"
