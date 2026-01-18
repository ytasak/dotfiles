# Dotfiles

## TODO

## インストールが必須なもの

- Zinit
- mise

## 初期化方法

1. リポジトリをクローン

```bash
cd ~ && git clone https://github.com/ytask/dotfiles.git
cd dotfiles
```

2. インストールスクリプトを実行（Goが必要）

```bash
go run install.go
```

3. （オプション）ローカル設定ファイルを作成

```bash
cp ~/dotfiles/.zshrc.local.example ~/.zshrc.local
chmod 600 ~/.zshrc.local
# GITHUB_TOKENなど、必要に応じて編集
```

4. ターミナルを再起動または`source ~/.zshrc`を実行
