#!/bin/bash
#
# Arduino プロジェクト用 compile_commands.json 生成スクリプト
#
# clangd が正しく動作するために必要な compile_commands.json を生成する。
# Arduino プロジェクトディレクトリで実行すること。
#
# 使い方:
#   arduino-setup.sh [FQBN] [SKETCH_DIR]
#
# 引数:
#   FQBN       - ボード識別子 (デフォルト: esp32:esp32:esp32)
#   SKETCH_DIR - スケッチディレクトリ (デフォルト: カレントディレクトリ)
#
# 例:
#   arduino-setup.sh                           # ESP32 DevKit, カレントディレクトリ
#   arduino-setup.sh esp32:esp32:esp32s3       # ESP32-S3
#   arduino-setup.sh esp32:esp32:esp32 ./blink # 指定ディレクトリ

set -e

generate_compile_commands() {
    local fqbn="${1:-esp32:esp32:esp32}"
    local sketch_dir="${2:-.}"
    sketch_dir="$(cd "$sketch_dir" && pwd)"

    local build_dir="$sketch_dir/.build"

    echo "FQBN: $fqbn"
    echo "スケッチ: $sketch_dir"
    echo "ビルド先: $build_dir"
    echo ""

    echo "compile_commands.json を生成中..."
    arduino-cli compile \
        --fqbn "$fqbn" \
        --build-path "$build_dir" \
        --only-compilation-database \
        "$sketch_dir"

    if [[ -f "$build_dir/compile_commands.json" ]]; then
        cp "$build_dir/compile_commands.json" "$sketch_dir/compile_commands.json"
        echo "生成完了: $sketch_dir/compile_commands.json"
    else
        echo "エラー: compile_commands.json が生成されませんでした" >&2
        exit 1
    fi
}

generate_compile_commands "$@"
