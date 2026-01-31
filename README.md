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

Helix で `esc` を押すと、IME が自動で英語（ABC）に切り替わる。

- 実装: macism コマンド
- 設定: `helix/config.toml`
