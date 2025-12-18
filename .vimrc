" ================== General Settings ==================
"
"
set nocompatible
set encoding=utf-8
set termguicolors
set background=dark

" UI
set number
set cursorline
set showmatch
set laststatus=2
set colorcolumn=79
set list
set splitbelow splitright
set signcolumn=yes

" Search
set ignorecase smartcase hlsearch

" Scrolling
set sidescroll=1 sidescrolloff=0

" Indentation & Tabs
set tabstop=4 shiftwidth=4 softtabstop=4 expandtab

" File Handling
set autowrite
set hidden

" Undo
if has('persistent_undo')
    set undodir=~/.undodir
    set undofile
endif

" Performance
set lazyredraw ttyfast synmaxcol=200
set norelativenumber
set cursorcolumn

" ================== Syntax & Theme ==================
syntax enable
syntax spell toplevel

" ================== Plugin Manager (vim-plug) ==================
call plug#begin('~/.vim/plugged')

" Essentials
Plug 'tpope/vim-surround'
Plug 'chun-yang/auto-pairs'
Plug 'latiif/syria-vim-themes'

" Go development
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" Fuzzy Finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Navigation & UI
Plug 'christoomey/vim-tmux-navigator'
Plug 'junegunn/vim-easy-align'
Plug 'luochen1990/rainbow'
Plug 'machakann/vim-highlightedyank'
Plug 'preservim/vim-indent-guides'

call plug#end()

" ================== Plugin Configurations ==================
" vim-go
let g:go_fmt_command = 'goimports'
let g:go_auto_type_info = 1
let g:go_auto_sameids = 1

" Rainbow Parentheses
let g:rainbow_active = 1

" Indent Guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2

" ================== Keymaps ==================
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
command! F :Files

" ================== Autocommands ==================
" YAML indentation
autocmd FileType yaml setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab

" Trim trailing whitespace on save
autocmd BufWritePre * %s/\s\+$//e

colorscheme syria_forest

" ================== Cursor Visibility ==================
" Make cursor position highly visible
highlight CursorLine guibg=#3a3a3a ctermbg=237 gui=NONE cterm=NONE
highlight CursorColumn guibg=#3a3a3a ctermbg=237 gui=NONE cterm=NONE

" ================== Statusline Configuration ==================
" Get current mode
function! CurrentMode()
    let l:mode = mode()
    let l:mode_map = {
        \ 'n':  'NORMAL',
        \ 'i':  'INSERT',
        \ 'R':  'REPLACE',
        \ 'v':  'VISUAL',
        \ 'V':  'V-LINE',
        \ "\<C-v>": 'V-BLOCK',
        \ 'c':  'COMMAND',
        \ 's':  'SELECT',
        \ 'S':  'S-LINE',
        \ "\<C-s>": 'S-BLOCK',
        \ 't':  'TERMINAL',
        \ }
    return get(l:mode_map, l:mode, 'UNKNOWN')
endfunction

" Get git branch
function! GitBranch()
    if !exists('*FugitiveHead') && isdirectory('.git')
        let l:branch = system("git branch --show-current 2>/dev/null | tr -d '\n'")
        return l:branch !=# '' ? ' ' . l:branch : ''
    endif
    return ''
endfunction

" File modified indicator
function! ModifiedIndicator()
    return &modified ? ' [+]' : ''
endfunction

" Read-only indicator
function! ReadOnlyIndicator()
    return &readonly ? ' ' : ''
endfunction

" Get file type with fallback
function! FileTypeInfo()
    return &filetype !=# '' ? &filetype : 'no ft'
endfunction

" Get file encoding
function! FileEncodingInfo()
    let l:encoding = &fileencoding !=# '' ? &fileencoding : &encoding
    return l:encoding
endfunction

" Get file format (unix/dos/mac)
function! FileFormatInfo()
    let l:format_map = {'unix': 'LF', 'dos': 'CRLF', 'mac': 'CR'}
    return get(l:format_map, &fileformat, &fileformat)
endfunction

" Line and column info
function! LineInfo()
    return printf('%3d:%-2d', line('.'), col('.'))
endfunction

" Percentage through file
function! PercentageThrough()
    return printf('%3d%%', (line('.') * 100) / line('$'))
endfunction

" Total lines
function! TotalLines()
    return line('$')
endfunction

" Define statusline colors (minimal, monochrome design)
function! SetStatuslineColors()
    " Mode indicator (subtle gray)
    hi User1 guifg=#f8f8f2 guibg=#3e3d32 gui=bold ctermfg=255 ctermbg=237 cterm=bold
    " File info (darker gray)
    hi User2 guifg=#75715e guibg=#272822 gui=none ctermfg=243 ctermbg=235 cterm=none
    " Modified indicator (slight emphasis)
    hi User3 guifg=#f8f8f2 guibg=#272822 gui=bold ctermfg=255 ctermbg=235 cterm=bold
    " Position info (muted)
    hi User4 guifg=#75715e guibg=#272822 gui=none ctermfg=243 ctermbg=235 cterm=none
endfunction

" Get mode highlight group (all modes use same color now)
function! ModeHighlight()
    return '%1*'
endfunction

" Set the statusline (minimal design)
set statusline=
set statusline+=%1*                         " Mode color
set statusline+=\ %{CurrentMode()}          " Current mode
set statusline+=\ %*                        " Reset highlight
set statusline+=%2*                         " File info color
set statusline+=\ %<%f                      " File path (truncate if needed)
set statusline+=%{ReadOnlyIndicator()}      " Read-only flag
set statusline+=%3*                         " Modified color
set statusline+=%{ModifiedIndicator()}      " Modified flag
set statusline+=%*                          " Reset highlight
set statusline+=%=                          " Right align
set statusline+=%4*                         " Position color
set statusline+=\ %{FileTypeInfo()}         " File type
set statusline+=\ │                         " Separator
set statusline+=\ %{LineInfo()}             " Line:Column
set statusline+=\ │                         " Separator
set statusline+=\ %{PercentageThrough()}    " Percentage
set statusline+=\ %*                        " Reset highlight

" Initialize colors
call SetStatuslineColors()

" Update colors when colorscheme changes
autocmd ColorScheme * call SetStatuslineColors()

" Initialize colors
call SetStatuslineColors()

" Update colors when colorscheme changes
autocmd ColorScheme * call SetStatuslineColors()
