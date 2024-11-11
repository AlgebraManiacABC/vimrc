set ruler
set number
set mouse=a
set ttymouse=sgr

set scrolloff=8
set nowrap
set sidescrolloff=16

set noerrorbells
set novisualbell

set expandtab "Convert tabs to spaces
set smarttab "Tab inserts spaces to the tab stop (rather than the \t char)
set smartindent "Automatically indents after opening brackets, etc.
set shiftwidth=4 "Number of spaces for each step of (auto)indent
set tabstop=4 "Tab width across a line
set backspace=eol,start,indent
set whichwrap=b,s,<,>,h,l

set showmatch "Show matching parentheses, etc.

if !isdirectory($HOME."/.vim/undodir")
    call mkdir($HOME."/.vim/undodir","p")
endif
set undofile
set undodir=~/.vim/undodir

if !isdirectory($HOME."/.vim/swapdir")
    call mkdir($HOME."/.vim/swapdir","p")
endif
set swapfile
set directory=~/.vim/swapdir

" Remember cursor position in files after closing
if has("autocmd")
   autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

set ignorecase "Ignore case in search
set smartcase "Overrides ignorecase if search pattern contains capital letters
set hlsearch "Highlight search results
set incsearch "Incremental search which also shows matches when you type

syntax on
filetype on
filetype plugin on
filetype indent on

" Commenting options
set formatoptions+=cro "Continue comments onto new lines
" Map Ctrl-/ in normal mode to toggle comments on the current line
nnoremap <C-/> :call ToggleComment()<CR>
" Map Ctrl-/ in visual mode to toggle comments on the selected lines
xnoremap <C-/> :<C-u>call ToggleVisualComment()<CR>

" Enable clipboard access for copying and pasting outside of Vim
set clipboard+=unnamedplus
" Remap Ctrl-C in normal mode to copy the current line to the system clipboard
nnoremap <C-c> "+y
" Remap Ctrl-C in visual mode to copy the visually selected text to the system clipboard
vnoremap <C-c> "+y
" Remap 'yank' commands to use the system clipboard
" Yank to system clipboard
nnoremap y "+y
" Yank whole line to system clipboard
nnoremap yy "+yy
" Yank selection in visual mode to system clipboard
vnoremap y "+y

" Enable auto-completion using a popup menu
set completeopt=menuone,noinsert,noselect

set wildmenu
set wildmode=full
set wildignorecase
set wildignore+=*.o,*.obj,*.pyc,*.pyo,*.jpg,*.jpeg,*.png,*.gif,*.zip,.git,.hg,.svn
set wildoptions=pum

set foldenable
set foldmethod=syntax

" Enable 24-bit RGB color in terminal
if has("termguicolors")
   set termguicolors
endif
set t_Co=256
colorscheme slate
set background=dark

" Function to toggle comments based on the filetype's commentstring
function! ToggleComment()
  " Get the current file's commentstring
  let l:commentstring = &commentstring
  " Remove any placeholders like '%s' from the commentstring
  let l:comment = substitute(l:commentstring, '%s', '', 'g')

  if l:comment == ''
    " If commentstring is not set, fallback to default //
    let l:comment = '//'
  endif

  " Check if the current line already starts with the comment string
  if getline('.') =~ '^\s*'.escape(l:comment, '\/')
    " Uncomment the line by removing the comment string
    execute 's/^\(\s*\)\(' . escape(l:comment, '\/') . '\)\s*/\1/'
  else
    " Comment the line by adding the comment string
    execute 's/^\(\s*\)/\1' . l:comment . ' /'
  endif
endfunction

" Function to toggle comments for visual selections
function! ToggleVisualComment()
  " Get the current file's commentstring
  let l:commentstring = &commentstring
  let l:comment = substitute(l:commentstring, '%s', '', 'g')

  if l:comment == ''
    " Fallback to //
    let l:comment = '//'
  endif

  " Save the range of the visual selection
  '<,'>s/^\(\s*\)\(.*\)\%(\( \)\?\)/\1/

  " Check if the first line in the visual range starts with the comment
  if getline("'<") =~ '^\s*'.escape(l:comment, '\/')
    " Uncomment the selected lines by removing the comment string
    execute "'<,'>s/^\(\s*\)\(" . escape(l:comment, '\/') . "\)\s*/\1/"
  else
    " Comment the selected lines by adding the comment string
    execute "'<,'>s/^\(\s*\)/\1" . l:comment . " /"
  endif
endfunction
