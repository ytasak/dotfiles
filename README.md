# Dotfiles

macOS (Apple Silicon) / Linux (Fedora) 向けの開発環境設定

## 構成

```
dotfiles/
├── Brewfile          # Homebrew パッケージ定義
├── .zshrc            # シェル設定
├── alacritty/        # ターミナル設定 (Alacritty)
├── herdr/            # ターミナルワークスペース管理設定
├── mise/             # ツールバージョン管理
└── ssh/              # SSH設定
```

### 主要ツール

| カテゴリ | ツール | 用途 |
|---------|--------|------|
| パッケージ管理 | Homebrew + mise | システムツールと開発ツールの管理 |
| シェル | Zsh + Zinit + pure | プラグイン管理とプロンプト |
| ターミナル | Alacritty | GPU accelerated terminal |
| ワークスペース管理 | herdr | AIエージェント向けターミナル管理 |

## セットアップ

```bash
# 1. クローン
mkdir -p ~/develop && cd ~/develop
git clone https://github.com/ytasak/dotfiles.git
cd dotfiles

# 2. インストール（Linux では dnf 実行時に sudo パスワードを求められる）
./install.sh

# 3. (オプション) ローカル設定
cp .zshrc.local.example ~/.zshrc.local
chmod 600 ~/.zshrc.local
cp ssh/config.local.example ~/.ssh/config.local
chmod 600 ~/.ssh/config.local

# 4. シェル再起動
exec zsh
```

### Fedora で手動インストールが必要なもの

Brewfile の `cask` は macOS 専用のため、以下は個別に入れる。

| ツール | インストール方法 |
|-------|----------------|
| HackGen フォント | [Releases](https://github.com/yuru7/HackGen/releases) から `HackGen_NF_*.zip` を取得し、`~/.local/share/fonts/` に展開して `fc-cache -f` |
| Claude Code | `curl -fsSL https://claude.ai/install.sh \| bash` |
| Codex | `npm install -g @openai/codex` |

## 設定ファイルの役割

### Brewfile

`brew`はCLIツール、`cask`はGUIアプリ。
macOS 専用の `tap`・`cask`・`macism` は `if OS.mac?` ブロックにまとめてあり、Linux では読み飛ばされる。

### .zshrc

Homebrew のプレフィックス（macOS: `/opt/homebrew`、Linux: `/home/linuxbrew/.linuxbrew`）を
起動時に判定して `HOMEBREW_PREFIX` に入れ、以降のパスはこれを基準にしている。

### alacritty/

- `alacritty.toml` - Alacritty 本体の設定（ウィンドウ・フォント・配色・キーバインド）

配色は Tokyo Night を `[colors.*]` に直接記述。テーマを変える場合はこのブロックを差し替える。
`option_as_alt = "OnlyLeft"` で左 Option のみ Alt/Meta 扱いにし、右 Option は記号入力用に温存（macOS のみ有効）。

### mise/config.toml

言語ランタイムとLSPサーバーのバージョン管理。

### herdr/

- `config.toml` - テーマ・UI設定
- `~/.config/herdr` には socket・log などの実行時状態も置かれるため、
  ディレクトリ全体ではなく `config.toml` 単体を symlink している

### ssh/

- `config` - 共通設定。`~/.colima/ssh_config` と `~/.ssh/config.local` を Include する
  （存在しないファイルの Include は無視されるため OS 分岐は不要）
