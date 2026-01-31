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

### Zellij設定 (zellij/)

- カスタムキーバインド（vim風）
- IDEレイアウト（helix + claude）

### Helix設定 (helix/)

- `Ctrl+y` でyaziファイルピッカーを起動
- zellij連携スクリプト

## セットアップ

インストールスクリプトを実行：

```bash
./install.sh
```
