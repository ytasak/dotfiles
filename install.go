package main

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
)

func main() {
	homeDir, err := os.UserHomeDir()
	if err != nil {
		fatal("ホームディレクトリの取得に失敗: %v", err)
	}

	dotfilesDir := filepath.Join(homeDir, "dotfiles")
	configDir := filepath.Join(homeDir, ".config")
	claudeDir := filepath.Join(homeDir, ".claude")

	fmt.Println("🔧 Dotfiles セットアップを開始します...")

	// dotfilesディレクトリの存在確認
	if _, err := os.Stat(dotfilesDir); os.IsNotExist(err) {
		fatal("dotfilesディレクトリが見つかりません: %s", dotfilesDir)
	}

	// ~/.configディレクトリの作成
	if err := os.MkdirAll(configDir, 0755); err != nil {
		fatal("~/.configディレクトリの作成に失敗: %v", err)
	}

	// ~/.claudeディレクトリの作成
	if err := os.MkdirAll(claudeDir, 0755); err != nil {
		fatal("~/.claudeディレクトリの作成に失敗: %v", err)
	}

	// ~/.sshディレクトリの作成
	sshDir := filepath.Join(homeDir, ".ssh")
	if err := os.MkdirAll(sshDir, 0700); err != nil {
		fatal("~/.sshディレクトリの作成に失敗: %v", err)
	}

	// シンボリックリンクの作成
	symlinks := map[string]string{
		".zshrc":               filepath.Join(homeDir, ".zshrc"),
		"ghostty":              filepath.Join(configDir, "ghostty"),
		"mise":                 filepath.Join(configDir, "mise"),
		"claude/CLAUDE.md":     filepath.Join(claudeDir, "CLAUDE.md"),
		"claude/settings.json": filepath.Join(claudeDir, "settings.json"),
		"ssh/config":           filepath.Join(sshDir, "config"),
	}

	for src, dst := range symlinks {
		srcPath := filepath.Join(dotfilesDir, src)
		if err := createSymlink(srcPath, dst); err != nil {
			fmt.Printf("⚠️  %s のシンボリックリンク作成をスキップ: %v\n", src, err)
		} else {
			fmt.Printf("✅ %s → %s\n", dst, srcPath)
		}
	}

	// miseのインストール確認
	fmt.Println("\n📦 mise でツールをインストールします...")
	if !commandExists("mise") {
		fmt.Println("⚠️  mise がインストールされていません")
		fmt.Println("   インストール方法: https://mise.jdx.dev/getting-started.html")
	} else {
		if err := runCommand("mise", "install"); err != nil {
			fmt.Printf("⚠️  mise install に失敗: %v\n", err)
		} else {
			fmt.Println("✅ mise ツールのインストール完了")
		}
	}

	// Zinitの確認
	fmt.Println("\n🔍 Zinit の確認...")
	zinitPath := filepath.Join(homeDir, ".local/share/zinit/zinit.git/zinit.zsh")
	if _, err := os.Stat(zinitPath); os.IsNotExist(err) {
		fmt.Println("⚠️  Zinit はまだインストールされていません")
		fmt.Println("   初回 zsh 起動時に自動インストールされます")
	} else {
		fmt.Println("✅ Zinit がインストール済み")
	}

	// .zshrc.local のセットアップ案内
	fmt.Println("\n💡 オプション: ローカル設定ファイル")
	zshrcLocal := filepath.Join(homeDir, ".zshrc.local")
	if _, err := os.Stat(zshrcLocal); os.IsNotExist(err) {
		fmt.Println("GitHub Tokenなどの秘密情報を設定する場合:")
		fmt.Printf("  cp %s %s\n", filepath.Join(dotfilesDir, ".zshrc.local.example"), zshrcLocal)
		fmt.Printf("  chmod 600 %s\n", zshrcLocal)
		fmt.Println("  # エディタで編集してGITHUB_TOKENなどを設定")
	} else {
		fmt.Println("✅ ~/.zshrc.local が既に存在します")
	}

	fmt.Println("\n🎉 セットアップ完了！")
	fmt.Println("\n次のステップ:")
	fmt.Println("1. ターミナルを再起動するか、`source ~/.zshrc` を実行")
}

func createSymlink(src, dst string) error {
	// リンク先が既に存在する場合はスキップ
	if info, err := os.Lstat(dst); err == nil {
		if info.Mode()&os.ModeSymlink != 0 {
			target, _ := os.Readlink(dst)
			if target == src {
				return fmt.Errorf("既に正しいシンボリックリンクが存在します")
			}
		}
		return fmt.Errorf("既にファイル/ディレクトリが存在します")
	}

	return os.Symlink(src, dst)
}

func commandExists(cmd string) bool {
	_, err := exec.LookPath(cmd)
	return err == nil
}

func runCommand(name string, args ...string) error {
	cmd := exec.Command(name, args...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	return cmd.Run()
}

func fatal(format string, args ...interface{}) {
	fmt.Fprintf(os.Stderr, "❌ "+format+"\n", args...)
	os.Exit(1)
}
