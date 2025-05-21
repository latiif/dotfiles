" ================== General Settings ==================
set nocompatible            " Use Vim defaults (required for plugins)
set encoding=utf-8          " Set encoding to UTF-8

set ignorecase              " Case-insensitive searching...
set smartcase               " ...unless capital letters are used
set number                  " Show line numbers
set splitbelow              " Horizontal splits below current window
set splitright              " Vertical splits to the right
set hlsearch                " Highlight search results
set background=dark         " Set background for colorschemes
set showmatch               " Highlight matching parentheses
set sidescroll=1
set sidescrolloff=0
set autowrite               " Auto-save before commands like :next and :make
set cursorline              " Highlight current line
set cursorcolumn            " Highlight current column
set tabstop=4               " Number of spaces a <Tab> counts for
set shiftwidth=4            " Number of spaces to use for each step of (auto)indent
set softtabstop=4           " Insert 4 spaces when <Tab> is pressed
set expandtab               " Convert tabs to spaces
set clipboard=unnamedplus   " Use system clipboard
set paste                   " Disable auto-indent when pasting (toggle manually if needed)
set laststatus=2            " Always display the status line
set colorcolumn=80          " Highlight column 80
set list                    " Show hidden characters (like tabs, EOLs)

" Persistent undo
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

" ================== Plugins ==================
call plug#begin('~/.vim/plugged')

" Essential Plugins
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'tpope/vim-surround'
Plug 'chun-yang/auto-pairs'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'


Plug 'preservim/nerdtree'

" UI Enhancements
Plug 'ryanoasis/vim-devicons'

" FZF Integration
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Terminal and Tmux Integration
Plug 'christoomey/vim-tmux-navigator'

call plug#end()

" ================== Plugin Configurations ==================
" vim-airline
let g:airline_powerline_fonts = 1
let g:airline_section_b = '%{strftime("%H:%M")}'

" vim-go
let g:go_fmt_command = 'goimports'
let g:go_auto_type_info = 1
let g:go_auto_same_ids = 1

" youcompleteme
let g:ymc_autoclose_preview_window_after_insertion = 1

" ale
let g:ale_linters = {'go': ['gometalinter', 'gofmt']}

" ================== Keymaps ==================
nnoremap <F2> :TagbarToggle<CR>

" ================== Autocommands ==================
" Colorscheme
colorscheme desert

" YAML specific settings
autocmd FileType yaml setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab

" Remove trailing whitespace on save
autocmd BufWritePre * %s/\s\+$//e
let g:airline_theme='desertink'

" Alias :Files to F
command! F :Files

nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
let g:NERDTreeFileLines = 1

