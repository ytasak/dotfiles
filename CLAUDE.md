# CLAUDE.md

このファイルは、Claude Code (claude.ai/code) がこのリポジトリで作業する際のガイダンスを提供します。

## リポジトリ概要

zsh、開発ツールの設定を管理する個人用dotfilesリポジトリ。

## アーキテクチャ

### シェル設定

- **mise** - ツールバージョン管理（`.zshrc`で有効化）
- **Zinit** - Zshプラグインマネージャー

### Ghostty設定 (ghostty/)

- `macos-option-as-alt = true` でOptionキーをAlt/Metaとして使用

## セットアップ

シンボリックリンクで`~/.config`に配置：

```bash
ln -s ~/dotfiles/.zshrc ~
ln -s ~/dotfiles/ghostty ~/.config
ln -s ~/dotfiles/mise ~/.config
```

## タスク管理

**重要**: TODOは`README.md`のTODOセクションで管理。

- タスク発生時：チェックリスト形式で追加
- 完了時：該当行を削除（履歴は残さない）
- 具体的かつ実行可能な単位で記述
