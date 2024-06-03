-- Neovim Lua configuration

-- General settings
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.number = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.hlsearch = true
vim.cmd('syntax enable')
vim.cmd('syntax spell toplevel')
vim.o.showmatch = true
vim.o.sidescroll = 1
vim.o.sidescrolloff = 0
vim.o.autowrite = true
vim.o.cursorline = true
vim.o.listchars = 'eol:$,tab:>-,trail:~,extends:>,precedes:<'
vim.o.cursorcolumn = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.paste = false
vim.o.clipboard = 'unnamedplus'
vim.o.termguicolors = true
vim.o.expandtab = true
vim.o.laststatus = 2
vim.o.encoding = 'utf-8'
vim.cmd('set nocompatible')  -- be iMproved, required

-- Persistent undo
if vim.fn.has("persistent_undo") == 1 then
    vim.o.undodir = vim.fn.expand('~/.undodir/')
    vim.o.undofile = true
end

-- Plugin manager: vim-plug
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/autoload/plug.vim'

if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'sh', '-c', 'curl -fLo '..install_path..' --create-dirs '..
                            'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'})
    vim.cmd 'autocmd VimEnter * PlugInstall --sync | source $MYVIMRC'
end

vim.cmd [[
call plug#begin('~/.vim/plugged')
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'tpope/vim-surround'
Plug 'ycm-core/youcompleteme'
Plug 'chun-yang/auto-pairs'
Plug 'vim-airline/vim-airline'
Plug 'dense-analysis/ale'
Plug 'tpope/vim-fugitive'
Plug 'preservim/tagbar'
Plug 'godlygeek/tabular'
Plug 'cespare/vim-toml'
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'ryanoasis/vim-devicons'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
call plug#end()
]]

-- Key mappings
vim.api.nvim_set_keymap('n', '<F2>', ':TagbarToggle<CR>', { noremap = true, silent = true })

-- Plugin settings
vim.g.ymc_autoclose_preview_window_after_insertion = 1
vim.g.go_fmt_command = "goimports"
vim.g.go_auto_type_info = 1
vim.g.go_auto_same_ids = 1

vim.g.airline_theme = 'catppuccin_mocha'
vim.g.airline_powerline_fonts = 1
vim.g.airline_section_b = '%{strftime("%H:%M")}'
vim.o.colorcolumn = '80'

vim.g.ale_linters = {go = {'gometalinter', 'gofmt'}}

-- Autocmd for filetypes
vim.cmd [[
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd BufWritePre * %s/\s\+$//e
]]

vim.cmd [[colorscheme catppuccin_latte]]
