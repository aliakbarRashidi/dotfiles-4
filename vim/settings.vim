"
" File:       settings.vim
" Author:     Jake Zimmerman <jake@zimmerman.io>
" Created:    2017-08-15
"

" ----- General settings ----------------------------------------------------

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
scriptencoding utf-8
" vint: -ProhibitSetNoCompatible
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set history=1000       " keep 1000 lines of command line history
set number             " line numbers
set ruler              " show the cursor position all the time
set showcmd            " display incomplete commands
set incsearch          " do incremental searching
if exists('&inccommand')
  set inccommand=split " like incsearch, but do it for commands (like :s)
endif
set linebreak          " wrap lines on 'word' boundaries
set scrolloff=3        " don't let the cursor touch the edge of the viewport
set splitright         " Vertical   splits  use  right  half  of screen
set splitbelow         " Horizontal splits  use  bottom half  of screen
set timeoutlen=1000    " Lower ^[ timeout
set fillchars=fold:\ , " get rid of obnoxious '-' characters in folds & diffs
set fillchars+=diff:\ ,
set tildeop            " use ~ to toggle case as an operator, not a motion
set colorcolumn=+0     " show a column whenever textwidth is set
if exists('&breakindent')
  set breakindent      " Indent wrapped lines up to the same level
endif
set foldnestmax=4      " Only fold up to one level deep
set list               " Show certain non-printing characters as printed
set listchars-=trail:- " Don't show trailing whitespace in listchars output
                       " (I use vim-better-whitespace for trailing whitespace)
set listchars-=eol:$   " Don't show trailing end-of-line characters
                       " (I use vim-better-whitespace for trailing whitespace)
set noshowmode         " Don't show "-- INSERT --" in insert mode
                       " Preseves things like echo'd messages
set cinkeys-=0#        " Let #pragma directives appear anywhere in a line

" Show potential matches above completion, complete first immediately
set wildmenu
set wildmode=full

" Tab settings
set expandtab          " Expand tabs into spaces
set tabstop=2          " default to 2 spaces for a hard tab
set softtabstop=2      " default to 2 spaces for the soft tab
set shiftwidth=2       " for when <TAB> is pressed at the beginning of a line

" Enable file type detection.
filetype plugin indent on

" ----- Convenience commands and cabbrev's ----------------------------------

" Make these commonly mistyped commands still work
command! -bang WQ wq<bang>
command! -bang Wq wq<bang>
command! -bang Wqa wqa<bang>
command! -bang W w<bang>
command! -bang Q q<bang>

" Use :C to clear hlsearch
command! C nohlsearch

" Force write readonly files using sudo
command! WS w !sudo tee %

" open help in a new tab
cabbrev help tab help

" My LaTeX Makefiles all have a `view` target which compiles and opens the PDF
" This command saves the file then runs that target
command! Wv w | make view
command! WV w | make view

" Open terminal in a split split
command! Vte vsplit | terminal
command! Ste split | terminal

" Open scratch buffer in a split on left
command! Vsnew vert new | norm <C-w>H

" Replace curly quotes with straight quotes
function! Nocurly() abort
  " vint: -ProhibitCommandWithUnintendedSideEffect
  " vint: -ProhibitCommandRelyOnUser
  silent! %s/‘/'/g
  silent! %s/’/'/g
  silent! %s/“/"/g
  silent! %s/”/"/g
  " vint: +ProhibitCommandRelyOnUser
  " vint: +ProhibitCommandWithUnintendedSideEffect
endfunction
command! Nocurly call Nocurly()

" Merge current tab with the tab to the left
noremap <C-w>m :Tabmerge<CR>

" ----- Custom keybindings --------------------------------------------------

map <space> <leader>
noremap <CR> :
noremap S <nop>

" Ideally I'd be able to specify no <M- keybindings in insert mode. For now,
" whitelist them as they come up:
inoremap <M-k> <ESC>k
inoremap <M-j> <ESC>j
inoremap <M-Enter> <ESC>:
inoremap <M-p> <ESC>p

function! ToggleKJEsc() abort
  if empty(maparg('kj', 'i'))
    inoremap kj <ESC>
    echo 'kj enabled'
  else
    iunmap kj
    echo 'kj disabled'
  end
endfunction
nnoremap <silent> <leader>kj :call ToggleKJEsc()<CR>
inoremap <silent> <C-j> <ESC>:call ToggleKJEsc()<CR>
call system('ioreg -p IOUSB | grep -iq ergodox')
if v:shell_error
  " Ergodox not connected, so probably using internal keyboard.
  silent! call ToggleKJEsc()
endif

" Make navigating long, wrapped lines behave like normal lines
noremap <silent> k gk
noremap <silent> j gj
noremap <silent> gk k
noremap <silent> gj j
noremap <silent> 0 g0
noremap <silent> g0 0
noremap <silent> $ g$
noremap <silent> g$ $
noremap <silent> ^ g^
noremap <silent> g^ ^
noremap <silent> _ g_

" use 'Y' to yank to the end of a line, instead of the whole line
nnoremap <silent> Y y$

" take first suggested spelling as correct spelling and replace
nnoremap <silent> <leader>z z=1<CR><CR>
nnoremap <silent> <leader>zf V$%zf
nnoremap <silent> zT zMzvzczO

" See WV command above
" nnoremap <silent> <leader>w :WV<CR>

" See Vte command above
nnoremap <silent> <leader>> :Vte<CR>

nnoremap <silent> <leader>c :echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')<CR>

" Easier to type on my keyboard than gt and gT
noremap <silent> gr gt
noremap <silent> gR gT

noremap <silent> <leader>y "+y
noremap <silent> <leader>Y "+Y
noremap <silent> <leader>d "+d
noremap <silent> <leader>D "+D

nnoremap <silent> <leader>= :exe "vertical resize " . (winwidth(0) * 3/2)<CR>
nnoremap <silent> <leader>- :exe "vertical resize " . (winwidth(0) * 2/3)<CR>

" Preview the current file as a Markdown file in the browser
" Requires https://github.com/joeyespo/grip
nnoremap <silent> <leader>gp :!grip -b % &> /dev/null &<CR><CR>

" * and # just highlight, don't jump
nnoremap * :keepjumps normal! *N<CR>
nnoremap # :keepjumps normal! #N<CR>

" Neovim Terminal Emulator keys
if has('nvim')
  tnoremap <M-e> <C-\><C-n>
  tnoremap <C-h> <C-\><C-n><C-w>h
  tnoremap <C-j> <C-\><C-n><C-w>j
  tnoremap <C-k> <C-\><C-n><C-w>k
  tnoremap <C-l> <C-\><C-n><C-w>l
endif

" ----- Terminal-as-GUI settings --------------------------------------------

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has('gui_running')
  syntax on
  set hlsearch
endif

if exists('+termguicolors')
  " This lets us use 24-bit "true" colors in the terminal
  set termguicolors
endif

" NeoVim and iTerm2 have support to display different cursor shapes than just
" the standard white block.
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
  \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
  \,sm:block-blinkwait175-blinkoff150-blinkon175


" ----- Not-quite-general-but-don't-belong-anywhere-else Settings -----------

augroup vimrc
  " Clear the current autocmd group, in case we're re-sourcing the file
  au!

  " Jump to the last known cursor position when opening a file.
  autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif

augroup END

