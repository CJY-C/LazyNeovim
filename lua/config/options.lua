-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt
opt.wrap = true -- Disable line wrap
opt.clipboard = "unnamedplus"

-- chinese encoding
opt.encoding = "utf-8"
opt.fileencodings = "utf-8,ucs-bom,gbk,cp936,gb2312,gb18030,sjis"
