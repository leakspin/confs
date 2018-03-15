set title                          " change the terminal's title
set history=1000                   " keep 100 lines of command line history
set autoread                       " Set to auto read when a file is changed from the outside
set autowrite                      " Auto save before commands like next and make
set diffopt=foldcolumn:0,filler    " Add vertical spaces to keep right and left aligned
set diffopt+=iwhite                " Ignore whitespace changes (focus on code changes)
set esckeys                        " Allow cursor keys in insert mode.
set gdefault                       " regex /g by default
set hid                            " you can change buffers without saving
set nostartofline                  " don't jump to first character when paging
set printoptions=paper:a4,syntax:n " controls the default paper size and the printing of syntax highlighting (:n -> none)
set report=0                       " tell us when anything is changed via :...0
set switchbuf=useopen              " reveal already opened files from the quickfix window instead of opening new buffers
set ttyfast                        " smoother changes
set viminfo='20,\"80               " read/write a .viminfo file, don't store more
set virtualedit=onemore            " Allow for cursor beyond last character
" set shortmess+=filmnrxoOtT         " Abbrev. of messages (avoids 'hit enter')
set viewoptions=cursor,folds,slash,unix
" vertical/horizontal scroll off settings
if !&scrolloff
set scrolloff=1
endif
if !&sidescrolloff
set sidescrolloff=5
endif

" No bell or flash wanted
set novisualbell " No blinking
set noerrorbells " No noise.
set vb t_vb=     " disable any beeps or flashes on error

" Use the '*' register as well as the the '+' register if it's available too
set clipboard=unnamed
if has('unnamedplus')|set clipboard+=unnamedplus|endif

" Configure to primarily use utf8
if has("multi_byte")
if &termencoding == ""|let &termencoding = &encoding|endif
set encoding=utf-8
setglobal fileencoding=utf-8
endif
set fileformats=unix,dos,mac "set compatible line endings in order of preference
set cmdheight=1          " the command bar is 1 high
set equalalways          " Close a split window in Vim without resizing other windows
set guitablabel=%t
set laststatus=2         " always show statusline
set lazyredraw           " do not redraw while running macros (much faster) (Lazy Redraw)
set linespace=0          " space it out a little more (easier to read)
set number               " turn on line numbers
set showmode             " If in Insert, Replace or Visual mode put a message on the last line.
set ttimeout
set ttimeoutlen=100

" wildmode
set complete-=i
set completeopt-=preview
set wildmenu           " nice tab-completion on the command line
set wildchar=9         " tab as completion character
set wildmode=longest:full,list:full
" Disable output and VCS files
set wildignore+=*.o,*.out,*.obj,.git,*.rbc,*.rbo,*.class,.svn,*.gem
" Disable archive files
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz
" Disable temp and backup files
set wildignore+=*.swp,*~,._*

" Suffixes that get lower priority when doing tab completion for filenames
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc,.pdf,.exe

" chars to show for list
set listchars=tab:▸\ ,eol:¬,trail:⋅,extends:❯,precedes:❮
set showbreak=
set display=lastline         " don't display @ with long paragraphs
" set formatoptions=tcroql     " t=text, c=comments, q=format with gq command, o,r=autoinsert comment leader
set formatoptions=roqnl12    " How automatic formatting is to be done
set lbr                      " line break
set nojoinspaces             " Prevents inserting two spaces after punctuation on a join (J)
set wrap                   " word wrap
set linebreak
set splitbelow               " Puts new split windows to the bottom of the current
set splitright               " Puts new vsplit windows to the right of the current
set textwidth=0
let &sbr = nr2char(8618).' ' " Show ↪ at the beginning of wrapped lines

" Text, tab and indent related
set autoindent    " Keep the indent when creating a new line
set copyindent    " Copy the previous indentation on autoindent

" Search
"set hlsearch        " highlight all matches...
set ignorecase      " select case-insenitiv search
set incsearch       " ...and also during entering the pattern
set magic           " change the way backslashes are used in search patterns
set matchpairs+=<:> " these tokens belong together
set matchtime=2     " How many tenths of a second to blink
set showmatch       " jump to matches during entering the pattern
set smartcase       " No ignorecase if Uppercase chars in search
nohlsearch          " avoid highlighting when reloading vimrc

set sessionoptions=buffers,curdir,folds,tabpages,winsize
let s:sessiondir  = expand("~/.vim/sessions", 1)
let s:sessionfile = expand(s:sessiondir . "/session.vim", 1)
let s:sessionlock = expand(s:sessiondir . "/session.lock", 1)

set noswapfile
