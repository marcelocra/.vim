" ---------
" Vim Plug.
" ---------
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Colorschemes.
Plug 'altercation/vim-colors-solarized'
Plug 'sjl/badwolf'
Plug 'tomasr/molokai'
Plug 'tpope/vim-vividchalk'

" Makes commenting easier on Vim.
Plug 'scrooloose/nerdcommenter'

" Handles Git wonderfully from within Vim.
Plug 'tpope/vim-fugitive'

" Provides a few more mappings to facilitate some tasks.
Plug 'tpope/vim-unimpaired'

" Changes Vim's status bar to a fancy one.
Plug 'bling/vim-airline'

" Allows one to easily traverse files.
Plug 'Lokaltog/vim-easymotion'

" Provides an easy way to surround text with characters.
Plug 'tpope/vim-surround'

" Plugin outside ~/.vim/plugged with post-update hook.
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" JavaScript stuff.
Plug 'dense-analysis/ale'
Plug 'leafgarland/typescript-vim'
Plug 'Quramy/tsuquyomi'
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'ternjs/tern_for_vim', { 'do': 'yarn install' }

" Initialize plugin system
call plug#end()

" ############################
" ##### general settings #####
" ############################

" When inserting a tab in the beggining of the line, it will be N spaces long
" and a <BS> will go back N spaces also (where N is the chosen number).
set smarttab
set shiftwidth=2

" Use spaces instead of tabs.
set expandtab

" 1 tab == 2 spaces.
set tabstop=2

" Automatically insert a linebreak after the selected width.
set textwidth=0   " No line breaks for me.
set wrapmargin=0  " I really don't want you to wrap, VIM.

" Indentation.
set autoindent
set nowrap  " Don't wrap lines.

" Disable annoying error noise (now it blinks).
set vb t_vb=

" Lines with number and with a particular width (no variation when
" increasing).
set number
" set numberwidth=5

" Show line and column.
set ruler

" Syntax highlighting.
syntax enable

" Highlight search matches as you type.
set hlsearch
set incsearch

" Always show the status line.
set laststatus=2

" Use utf-8 encoding.
set encoding=utf-8

" Change tab and trail characters.
set listchars=eol:$,tab:»-,trail:.,extends:>,precedes:<,nbsp:_
" set listchars=eol:¬,tab:»˽,trail:~,extends:>,precedes:<,nbsp:_

" Highlight the cursor line.
set cursorline

" Allow backspace to work like in every text editor.
set backspace=2

" Visual autocomplete for command menu.
set wildmenu

" Redraw only when needed to.
set lazyredraw

" Change VIM default splits (to bottom right).
set splitbelow
set splitright

" Set line endings. Prefer Unix, but also accept DOS.
set fileformats=unix,dos

" Set proper colors.
set t_Co=256

" Avoid folding. Note: 'za' to unfold.
set nofoldenable

try
    if has('gui_running')
        colorscheme molokai
    else
        colorscheme badwolf
    endif
catch /^Vim\%((\a\+)\)\=:E185/
    colorscheme desert
    set background=dark
endtry

" Set ruler.
" TODO: adapt for different filetypes.
set colorcolumn=79

" Set how the status line will be shown in the bottom of Vim.
set statusline=%<%F\ %m%r%h\ %=lines:%l/%L\ col:%c%V

set guicursor=n-v-c:block-Cursor-blinkon0
set guicursor+=ve:ver35-Cursor
set guicursor+=o:hor30-Cursor
set guicursor+=i-ci:ver10-Cursor
set guicursor+=r-cr:hor10-Cursor
set guicursor+=sm:block-Cursor-blinkwait175-blinkoff150-blinkon175

if empty(glob('~/.vim/tmp'))
    silent !mkdir -p ~/.vim/tmp
endif
set directory=~/.vim/tmp

"autocmd BufNewFile,BufRead *.ejs set filetype=html
"set term=xterm-256color

" ################################
" ##### GUI related settings #####
" ################################
" For NVim, check the ginit.vim.

if has('win32')
    " Windows specific settings.
    if has('gui_running')
        " Windows GUI settings.
        set guifont=Consolas:h10:cANSI
    endif
    " Yank to clipboard.
    set clipboard=unnamed
else
    let s:uname = system("uname -s")
    if s:uname == "Darwin"
        " Do Mac stuff here.
        if has('gui_running')
            set guifont=Menlo\ Regular:h10
        endif
        set clipboard=unnamed
    else
        " Do Linux stuff here.
        if has('gui_running')
            " Set font according to the list (if one is not present, the next
            " one is used).
            set guifont=JetBrains\ Mono\ 14
        endif
        " Yank to clipboard
        set clipboard=unnamedplus
    endif
endif

" General GUI specific settings.
if has('gui_running')
    " Remove menus (don't like them)
    set guioptions-=m  " remove menubar
    set guioptions-=T  " remove toolbar
    set guioptions-=r  " remove right-hand scroll bar
    set guioptions-=L  " remove left-hand scroll bar
endif

" ###########################
" ##### plugin settings #####
" ###########################

" --- Molokai ---

let g:molokai_original = 1  " Original monokai background color.
" For terminal, with 256 colors.
if !has('gui_running')
    let g:rehash256 = 1
endif

" --- Ycm ---
let g:ycm_filepath_blacklist = {}

" --- Ale Javascript ---
let g:ale_linter_aliases = {'jsx': ['css', 'javascript']}
let g:ale_linters = {'jsx': ['eslint', 'prettier']}
let g:ale_fixers = { 'javascript': ['eslint', 'prettier'] }
let g:ale_fix_on_save = 1

" --- Plugin specific mappings ---

function! LoadPluginSpecificMappings()
    if exists(':NERDTree')
        " Open current working directory in NERDTree.
        nnoremap <silent> <leader><leader>d :NERDTreeCWD<CR>
    endif
    nnoremap <a-f> :Ag<cr>
endfunction

augroup plugin_initialize
    autocmd!
    autocmd VimEnter * call LoadPluginSpecificMappings()
augroup END

" ############################
" ##### general mappings #####
" ############################

" Use normal regex.
nnoremap / /\v\c
vnoremap / /\v\c

" Simpler way to go to command mode from insert mode.
inoremap jf <esc>
inoremap fj <esc>

" Quicker window movement.
nnoremap <c-j> <c-w><c-j>
nnoremap <c-k> <c-w><c-k>
nnoremap <c-h> <c-w><c-h>
nnoremap <c-l> <c-w><c-l>

" Move vertically by visual line (not jumping long lines).
nnoremap j gj
nnoremap k gk

" Highlight last inserted text.
nnoremap gV `[v`]

" Allow fast indenting when there is a chunck of text selected.
vnoremap < <gv
vnoremap > >gv

" Easy way to change between tabs.
nnoremap <a-k> :tabnext<cr>
nnoremap <a-j> :tabprevious<cr>
nnoremap g] :tabnext<cr>
nnoremap g[ :tabprevious<cr>

" Ctrl+P pra mostrar os arquivos.
nnoremap <c-p> :Files<cr>

" ###########################
" ##### leader mappings #####
" ###########################

" Change leader.
let mapleader = ","

" Execute last macro recorded in register 'q'.
nnoremap <space> @q

" Shift the line below by one line (downwards).
"nnoremap <silent> <Leader>o :let cp=getpos('.')<CR>o<Esc>k:call cursor(cp[1],cp[2])<CR>
"nnoremap <silent> <Leader>O :let cp=getpos('.')<CR>O<Esc>j:call cursor(cp[1] + 1,cp[2]) <CR>

" Easily source my vimrc.
nnoremap <leader><leader>sv :source $MYVIMRC<cr>
" Easily edit my vimrc.
nnoremap <leader><leader>ev :tabe $MYVIMRC<cr>

" Clear last search.
nnoremap <silent> <leader><leader>cl :let @/ = ""<cr>

" Save while in insert mode without leaving insert mode.
nnoremap <leader>w :w<cr>
inoremap <leader>w <esc>:w<cr>

" Quit easily.
nnoremap <leader>q :q<cr>
inoremap <leader>q <esc>:q<cr>

" Save and quit easily.
inoremap <leader>x <esc>:x<cr>
nnoremap <leader>x :x<cr>

" Select all.
nnoremap <leader>a ggVG

