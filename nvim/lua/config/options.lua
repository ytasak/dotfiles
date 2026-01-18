local api = vim.api
local opt = vim.opt

vim.api.nvim_create_augroup("my_nvim_rc", { clear = true })

-- TrueColor対応
opt.termguicolors = true

-- 行番号の表示
opt.number = true
opt.relativenumber = true

-- タブとインデントの設定
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2

-- 折り返し設定
opt.wrap = false

-- OSのクリップボードと連携
opt.clipboard = "unnamedplus"

-- ヤンク時にハイライト
api.nvim_create_autocmd("TextYankPost", {
  group = "my_nvim_rc",
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ timeout = 300 })
  end,
})
