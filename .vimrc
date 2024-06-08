""" Sane defaults, mostly things that should be by default already.
"
" Disable vi compatbility mode.
set nocompatible
" Encodings
set encoding=utf-8
" In this house we use \n.
set fileformat=unix
" Some filetype defaults.
filetype plugin indent on
" Enable syntax highlighting.
syntax enable
" Enable some useful runtime ftplugin features.
runtime ftplugin/man.vim
" Some helpful functions.
source ~/.vim/functions.vim

""" The start of every sane vim config.
"
" Set space as leader.
let mapleader = ' '
" Enable the use of the mouse
set mouse=a


""" Visuals & Colors.
"
" This could be optional, since we could write an environment variable to broadcast background
" color.
set background=dark
" Terminal colors.
set termguicolors
" Set colorscheme
colo retrobox
" Set cursorline
set cursorline
" Set colorcolumn, if available.
set textwidth=99
if exists('+colorcolumn')
  " Sets column colorization at `$textwidth + 1`
  set colorcolumn=+1
  hi ColorColumn term=bold ctermbg=236 guibg=#303030
endif
" Keep at least 8 screen lines.
set scrolloff=8
" Show current line number when in relative mode.
set number
" Show relative line number.
set relativenumber
" Show highlighted cursor line
" Briefly jump to a paren once it's balanced
set showmatch
" Visual hints for pesky characters
set list
set listchars=tab:▸\ ,nbsp:¬,trail:·
" Wildmenu
set wildmenu
set wildoptions="pum, fuzzy"
" Use OS clipboard at least 8 screen lines.
set clipboard=unnamed
" Cursor shenanigans.
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"


""" Tabs/Whitespace/Wraps
"
" Insert space characters whenever the tab key is pressed
set expandtab
" Copy the indentation from the previous line, when starting a new line
set autoindent
" Be smart around indentation when you can.
set smartindent
" Number of space characters that will be inserted when the tab key is pressed
set tabstop=4
" Set space as leader.
set softtabstop=4
" Number of space characters inserted for indentation
set shiftwidth=4
" When on, lines longer than the width of the window will wrap and
" displaying continues on the next line.
set wrap
" Allow specified keys that move the cursor left/right to move to the
" previous/next line when the cursor is on the first/last character in
" the line.
set whichwrap=b,s,h,l,<,>,[,]
" Allows backspacing over everything in insert mode. Each item allows a way to
" backspace over something:
"
" value   effect
" indent  allow backspacing over autoindent
" eol     allow backspacing over line breaks (join lines)
" start   allow backspacing over the start of insert; CTRL-W and CTRL-U
"               stop once at the start of insert.
set backspace=indent,eol,start


""" Searching
"
" When there is a previous search pattern, highlight all its matches. The type
" of highlighting used can be set with the 'l' occasion in the 'highlight'
" option.
set nohlsearch
nnoremap <silent> <esc> :noh<cr><esc>
" While typing a search command, show where the pattern, as it was typed so
" far, matches. The matched string is highlighted. If the pattern is invalid
" or not found, nothing is shown.
set incsearch
" If 'ignorecase' and 'smartcase' are set and the command line has no
" uppercase characters, the added character is converted to lowercase.
set ignorecase
set smartcase
" Remove included files from keyword completion.
set complete-=i

""" Misc
"
" Don't re-open already opened buffers
set switchbuf=useopen
" Avoid moving cursor to BOL when jumping around
set nostartofline
" Let cursor move past the last char
set virtualedit=block
" Watch for file changes
set autoread
" Change to the current directory of the opened file.
set autochdir
" Nicer splitting
set splitbelow
set splitright
" Required for operations modifying multiple buffers like rename.
set hidden
" Status bar
set laststatus=2
set ruler
" Disable swap, backups, bells and hell.
set noswapfile
set nobackup
set belloff=all
map q <Nop>
map Q <Nop>


""" Netrw
"
" Setup the netrw buffer to appear in the buffer list, make it non-modifiable
" and read only, these are defaults. Override to show relative line numbers.
let g:netrw_bufsettings='noma nomod nowrap ro nobl rnu'
" Sync the browsing directory with the current directory.
let g:netrw_keepdir=0
" Use a smaller window size.
let g:netrw_winsize=30
" Use a tree style listing.
let g:netrw_liststyle=3

""" Generic overpowered keymaps.
"
" Close a window, inspired by Spacemacs.
nnoremap <silent> <leader>wd :close<cr><esc>
" Alias for `:split`.
nnoremap <silent> <leader>ws :split<cr><esc>
" Alias for `:vsplit`.
nnoremap <silent> <leader>wv :vsplit<cr><esc>

" List buffers and streamline opening another buffer.
nnoremap <leader><leader> :buffers<CR>:buffer<Space>

" Nicer text navigation
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')

" Open netrw in the current working directory.
nnoremap <silent> <leader>b :Lexplore<cr><esc>
" Open netrw in the directory of the current file.
nnoremap <silent> <leader>tt :Lexplore %:p:h<cr><esc>

" Move around in insert mode
inoremap <C-h> <left>
inoremap <C-k> <up>
inoremap <C-j> <down>
inoremap <C-l> <right>

" Reselect visual block after adjusting indentation
vnoremap < <gv
vnoremap > >gv

" Move around tabs.
nnoremap <silent> <leader>tn :tabnext<cr><esc>
nnoremap <silent> <leader>tp :tabprevious<cr><esc>
nnoremap <silent> <leader>tx :tabclose<cr><esc>

" How to keep movement centered ? always `zz`.
nnoremap <silent> n nzzzv
nnoremap <silent> N Nzzzv
" Page movement, centered.
nnoremap <silent> <C-d> <C-d>zz
nnoremap <silent> <C-u> <C-u>zz
nnoremap <silent> <C-f> <C-d>zz
nnoremap <silent> <C-b> <C-u>zz

" How to move code blocks ? Use the move command.
vnoremap J :m '>+1<cr>gv=gv
vnoremap K :m '<-2<cr>gv=gv

""" Auto commands
"
" Hints for file types
autocmd! BufRead,BufNewFile gitconfig set ft=gitconfig
" Remove trailing whitespaces
autocmd! BufWritePre * call StripTrailingWhitespaces()
" Automatically format a Rust buffer on save.
autocmd! BufWritePre *.rs :RustFmt
