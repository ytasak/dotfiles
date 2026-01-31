# Dotfiles

macOS (Apple Silicon) 専用の開発環境設定

## 構成

```
dotfiles/
├── Brewfile          # Homebrew パッケージ定義
├── .zshrc            # シェル設定
├── ghostty/          # ターミナル設定
├── helix/            # エディタ設定
├── zellij/           # マルチプレクサ設定
├── yazi/             # ファイラー設定
├── mise/             # ツールバージョン管理
├── claude/           # Claude Code設定
├── ssh/              # SSH設定
└── bin/              # カスタムスクリプト
```

### 主要ツール

| カテゴリ | ツール | 用途 |
|---------|--------|------|
| パッケージ管理 | Homebrew + mise | システムツールと開発ツールの管理 |
| シェル | Zsh + Zinit + pure | プラグイン管理とプロンプト |
| ターミナル | Ghostty | GPU accelerated terminal |
| エディタ | Helix | モーダルエディタ |
| マルチプレクサ | Zellij | ターミナル分割・セッション管理 |
| ファイラー | Yazi | ターミナルファイルマネージャー |

## セットアップ

```bash
# 1. クローン
cd ~ && git clone https://github.com/ytasak/dotfiles.git
cd dotfiles

# 2. インストール
./install.sh

# 3. (オプション) ローカル設定
cp .zshrc.local.example ~/.zshrc.local
chmod 600 ~/.zshrc.local
cp ssh/config.local.example ~/.ssh/config.local
chmod 600 ~/.ssh/config.local

# 4. シェル再起動
source ~/.zshrc
```

## 設定ファイルの役割

### Brewfile

`tap`はサードパーティリポジトリの追加。`brew`はCLIツール、`cask`はGUIアプリ。

```
tap "laishulu/homebrew"  # macism用のリポジトリ
brew "helix"             # CLIツール
cask "ghostty"           # GUIアプリ
```

### mise/config.toml

言語ランタイムとLSPサーバーのバージョン管理。Helix用のLSPもここで管理。

### helix/

- `config.toml` - テーマ、キーバインド、エディタ設定
- `languages.toml` - 言語ごとのLSP・フォーマッター設定

IME自動切り替え: `esc`押下時に`macism`で英語入力に切り替え。

### zellij/

- `config.kdl` - キーバインド設定
- `layouts/` - レイアウト定義（`ide`コマンドで使用）
