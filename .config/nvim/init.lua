-- Basic Options
local opt = vim.opt
opt.ignorecase = true
opt.smartcase = true
opt.number = true
opt.splitbelow = true
opt.splitright = true
opt.hlsearch = true
opt.background = "dark"
opt.showmatch = true
opt.sidescroll = 1
opt.sidescrolloff = 0
opt.autowrite = true
opt.cursorline = true
opt.cursorcolumn = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.paste = false
opt.clipboard = "unnamedplus"
opt.expandtab = true
opt.laststatus = 2
opt.compatible = false
opt.encoding = "utf-8"
opt.colorcolumn = "80"
opt.list = true

-- Syntax
vim.cmd("syntax enable")
vim.cmd("syntax spell toplevel")

-- Persistent Undo
if vim.fn.has("persistent_undo") == 1 then
  opt.undodir = vim.fn.expand("~/.undodir/")
  opt.undofile = true
end


-- Keymaps
vim.keymap.set('n', '<F2>', ':TagbarToggle<CR>', { noremap = true, silent = true })

-- Autocmds
vim.api.nvim_create_autocmd("FileType", {
  pattern = "yaml",
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  command = [[%s/\s\+$//e]]
})

-- Plugin Manager: lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Plugins list
  { "fatih/vim-go", build = ":GoUpdateBinaries" },
  { "tpope/vim-surround" },
  { "ycm-core/youcompleteme" },
  { "chun-yang/auto-pairs" },
  { "vim-airline/vim-airline" },
  { "dense-analysis/ale" },
  { "tpope/vim-fugitive" },
  { "preservim/tagbar" },
  { "godlygeek/tabular" },
  { "cespare/vim-toml" },
  { "catppuccin/vim", name = "catppuccin" },
  { "ryanoasis/vim-devicons" },
  { "junegunn/fzf", build = function() vim.fn["fzf#install"]() end },
  { "junegunn/fzf.vim" },
  { "christoomey/vim-tmux-navigator" },
  { "NLKNguyen/papercolor-theme" },
})

-- Plugin Settings
vim.g.ymc_autoclose_preview_window_after_insertion = 1
vim.g.go_fmt_command = "goimports"
vim.g.go_auto_type_info = 1
vim.g.go_auto_same_ids = 1

vim.g.airline_theme = 'catppuccin_frappe'
vim.g.airline_powerline_fonts = 1
vim.g.airline_section_b = '%{strftime("%H:%M")}'

vim.g.ale_linters = { go = { 'gometalinter', 'gofmt' } }

