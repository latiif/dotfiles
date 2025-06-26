" ================== General Settings ==================
set nocompatible            " Use Vim defaults (required for plugins)
set encoding=utf-8          " Set encoding to UTF-8

set ignorecase              " Case-insensitive searching...
set smartcase               " ...unless capital letters are used
set hlsearch                " Highlight search results
set number                  " Show line numbers
set cursorline              " Highlight current line
set cursorcolumn            " Highlight current column
set showmatch               " Highlight matching parentheses
set laststatus=2            " Always display the status line
set colorcolumn=79          " Highlight column 80
set list                    " Show hidden characters (like tabs, EOLs)
set background=dark         " Set background for colorschemes

" Split Behavior
set splitbelow              " Horizontal splits below current window
set splitright              " Vertical splits to the right

" Scrolling
set sidescroll=1
set sidescrolloff=0

" Indentation & Tabs
set tabstop=4               " Number of spaces a <Tab> counts for
set shiftwidth=4            " Number of spaces to use for each step of (auto)indent
set softtabstop=4           " Insert 4 spaces when <Tab> is pressed
set expandtab               " Convert tabs to spaces

" File Handling
set autowrite               " Auto-save before commands like :next and :make
set clipboard=unnamedplus   " Use system clipboard
set paste                   " Disable auto-indent when pasting (toggle manually if needed)

" Persistent Undo
if has('persistent_undo')
    set undodir=~/.undodir/
    set undofile
endif

" Enable syntax highlighting and spell checking
syntax enable
syntax spell toplevel

" ================== Plugin Manager (vim-plug) ==================
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Essential Plugins
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'tpope/vim-surround'
Plug 'chun-yang/auto-pairs'

" UI & Theme
Plug 'itchyny/lightline.vim'
Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'

" Fuzzy Finding
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Terminal Integration
Plug 'christoomey/vim-tmux-navigator'

" Development
Plug 'junegunn/vim-easy-align'                     " Text alignment

" UI Improvements
Plug 'luochen1990/rainbow'                         " Rainbow parentheses
Plug 'machakann/vim-highlightedyank'               " Highlight yanked text
Plug 'preservim/vim-indent-guides'                 " Indentation guides

call plug#end()

" ================== Plugin Configurations ==================
" Lightline
let g:lightline = { 'colorscheme': 'powerline' }
" vim-go
let g:go_fmt_command = 'goimports'
let g:go_auto_type_info = 1
let g:go_auto_same_ids = 1

" YouCompleteMe
let g:ymc_autoclose_preview_window_after_insertion = 1

" ALE
let g:ale_linters = {'go': ['gometalinter', 'gofmt']}

" NERDTree
let g:NERDTreeFileLines = 1

" Coc.nvim settings
set hidden
set updatetime=300
set shortmess+=c
inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Git Gutter
set signcolumn=yes
let g:gitgutter_max_signs = 500

" Rainbow Parentheses
let g:rainbow_active = 1

" Indent Guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2

" ================== Keymaps ==================
nnoremap <F2> :TagbarToggle<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" Command Aliases
command! F :Files

" ================== Autocommands ==================
" Theme
colorscheme desert

" YAML Indentation
autocmd FileType yaml setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab

" Remove trailing whitespace on save
autocmd BufWritePre * %s/\s\+$//e

" ================== Performance ==================
set lazyredraw
set ttyfast
set nocursorcolumn        " Disable cursor column for better performance
set norelativenumber      " Disable relative numbers for better performance
set synmaxcol=200        " Don't highlight long lines
