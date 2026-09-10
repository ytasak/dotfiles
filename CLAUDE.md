# CLAUDE.md

このファイルは、Claude Code (claude.ai/code) がこのリポジトリで作業する際のガイダンスを提供します。

## リポジトリ概要

zsh、開発ツールの設定を管理する個人用dotfilesリポジトリ。

## アーキテクチャ

### シェル設定

- **mise** - ツールバージョン管理（`.zshrc`で有効化）
- **Zinit** - Zshプラグインマネージャー

### Alacritty設定 (alacritty/)

- 配色は Tokyo Night ベースを `alacritty.toml` 内に直書き（外部テーマファイルなし）
- 太字の強調は `draw_bold_text_with_bright_colors = true` と `primary.bright_foreground` の
  組み合わせで成立している。前者を false にすると後者が一切参照されなくなり、
  太字が本文と同色になって強調が見えなくなるため、片方だけ変更しないこと
- 同様に `colors.bright` のアクセント6色も上記フラグが true のときのみ効く
- `option_as_alt = "OnlyLeft"` で左 Option のみ Alt/Meta 扱い
- `live_config_reload = true` のため、保存すると再起動なしで反映される

### Ghostty設定 (ghostty/)

- `macos-option-as-alt = true` でOptionキーをAlt/Metaとして使用

### herdr設定 (herdr/)

- herdr はAIコーディングエージェント向けのターミナルワークスペース管理ツール
- `config.toml` のみを symlink する。`~/.config/herdr` には socket・log・session.json
  などの実行時状態も置かれるため、ディレクトリ全体をリンクしてはいけない
- スキルはディスク上のファイルではなく `herdr --skill` で取得する方式。
  セッションのスキル一覧には出てこない
- herdr の pane 内で動いているかは `HERDR_ENV` で判定する。pane 外から
  herdr セッションを操作してはいけない
- Claude Code との連携は SessionStart フック
  `~/.claude/hooks/herdr-agent-state.sh` が担う（herdr が管理するファイルなので
  直接編集しない）

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
