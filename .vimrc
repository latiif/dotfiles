set ignorecase
set smartcase
set number
set splitbelow
set splitright
set hlsearch
syntax enable
syntax spell toplevel
set background=dark
set showmatch
set sidescroll=1
set sidescrolloff=0
set autowrite
set cursorline
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
set cursorcolumn
set tabstop=4
set shiftwidth=4    " Indents will have a width of 4
set softtabstop=4   " Sets the number of columns for a TAB

set expandtab       " Expand TABs to spaces
if has("persistent_undo")
    set undodir=~/.undodir/
    set undofile
endif

set laststatus=2


""""""""""""""""""""""""""""""""     vimrc     """"""""""""""""""""""""""""""{{{
set nocompatible              " be iMproved, required
set encoding=utf-8
"}}}

"""""""""""""""""""""""""""""""     vim-plug """"""""""""""""""""""""""""""{{{
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
"}}}

"""""""""""""""""""""""""""""""     Plugins     """""""""""""""""""""""""""""{{{
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
Plug 'catppuccin/vim', { 'as': 'catppuccin'  }
Plug 'ryanoasis/vim-devicons'
Plug 'junegunn/fzf', { 'do': { -> fzf#install()  }  }
Plug 'junegunn/fzf.vim'

call plug#end()

nmap <F2> :TagbarToggle<CR>


let g:ymc_autoclose_preview_window_after_insertion = 1
let g:go_fmt_command="goimports"
let g:go_auto_type_info = 1
let g:go_auto_same_ids = 1

let g:airline_theme = 'catppuccin_mocha'
let g:airline_powerline_fonts = 1
let g:airline_section_b = '%{strftime("%H:%M")}'
set nolist

:set colorcolumn=80

let g:ale_linters = {'go': ['gometalinter','gofmt']}



"" Autocmd for filetypes
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd BufWritePre * %s/\s\+$//e

