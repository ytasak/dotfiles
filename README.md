# Dotfiles

macOS (Apple Silicon) 専用

## TODO

## 初期化方法

1. リポジトリをクローン

```bash
cd ~ && git clone https://github.com/ytasak/dotfiles.git
cd dotfiles
```

2. インストールスクリプトを実行

```bash
./install.sh
```

3. （オプション）ローカル設定ファイルを作成

```bash
cp ~/dotfiles/.zshrc.local.example ~/.zshrc.local
chmod 600 ~/.zshrc.local
# GITHUB_TOKENなど、必要に応じて編集
```

4. ターミナルを再起動または`source ~/.zshrc`を実行

## IME自動切り替え

Helix + Zellij 環境で、日本語入力を使用後にモード切り替えやペイン移動をした際、IMEを自動で英語（ABC）に切り替える。

### 仕組み

| トリガー | 実装 | 設定ファイル |
|---------|------|-------------|
| Helix で `esc` を押下 | macism コマンド | `helix/config.toml` |
| Zellij で `Alt+h/j/k/l` でペイン移動 | Hammerspoon eventtap | `hammerspoon/init.lua` |
| Ghostty にフォーカス移動 | Hammerspoon app watcher | `hammerspoon/init.lua` |

### 必要なセットアップ

1. **Hammerspoon のアクセシビリティ権限を有効化**
   - システム設定 → プライバシーとセキュリティ → アクセシビリティ → Hammerspoon を追加

2. **Hammerspoon を起動**
   - ログイン時に自動起動する設定を推奨（Hammerspoon Preferences → Launch Hammerspoon at login）
