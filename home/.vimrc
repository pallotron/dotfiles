set autoread
set ttyfast
set copyindent
set mouse=a
set paste
set lazyredraw

:syntax on

set expandtab

filetype on
filetype plugin indent on

" use control-p to show line numbers
:nmap <silent> <C-P> :set invnumber<CR>
:set invnumber
"autocmd VimEnter * set invnumber

let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

au BufRead,BufNewFile *.thrift set filetype=thrift
au! Syntax thrift source ~/.vim/thrift.vim
au BufRead,BufNewFile * set tabstop=2 shiftwidth=2
au BufRead,BufNewFile *.phpt set filetype=php wm=2 tw=80  
au BufRead,BufNewFile *.py set tabstop=4 shiftwidth=4 filetype=python wm=2 tw=80  
au BufRead,BufNewFile *.tw set tabstop=4 shiftwidth=4 filetype=python wm=2 tw=80  
au BufRead,BufNewFile *.cconf set tabstop=4 shiftwidth=4 filetype=python wm=2 tw=80  
au BufRead,BufNewFile *.cinc set tabstop=4 shiftwidth=4 filetype=python wm=2 tw=80  
au BufRead,BufNewFile TARGETS set tabstop=4 shiftwidth=4 filetype=python wm=2 tw=80 
au BufRead,BufNewFile *.rb set tabstop=2 shiftwidth=2 wm=2 tw=80  
au BufRead,BufNewFile *.php set tabstop=2 shiftwidth=2 wm=2 tw=80  
au BufRead,BufNewFile *.c set tabstop=2 shiftwidth=2 wm=2 tw=80  
au BufRead,BufNewFile *.h set tabstop=2 shiftwidth=2 wm=2 tw=80  
au BufRead,BufNewFile *.cpp set tabstop=2 shiftwidth=2 wm=2 tw=80  
au BufRead,BufNewFile *.md set filetype=markdown wm=2 tw=80  

"autocmd VimEnter * NERDTree
autocmd VimEnter * wincmd p
let g:NERDTreeWinPos = "right"
nmap <silent> <C-D> :NERDTreeToggle<CR>
nnoremap <silent> <C-L> :noh<CR><C-L>

" highlight trailing whitespace "
match Error '\s\+$\|\t'

if exists('+colorcolumn')
  set colorcolumn=80
  let s:color_column_old = 0
else
  au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif
" toggle colored right border after 80 chars

function! s:ToggleColorColumn()
    if s:color_column_old == 0
        let s:color_column_old = &colorcolumn
        windo let &colorcolumn = 0
    else
        windo let &colorcolumn=s:color_column_old
        let s:color_column_old = 0
    endif
endfunction
nnoremap <Leader>8 :call <SID>ToggleColorColumn()<cr>

" Ctrl-C/N to create new tab and jump to next tab "
" (this should roughly match the 'screen' keys Ctrl-A+C and Ctrl-A+N) "
map <C-c> :tabe<CR>
map <C-n> :tabn<CR>

" shows error window
map <C-e> :cope<CR>

" relativenumber togger
function! NumberToggle()
  if(&relativenumber == 1)
    set number
  else
    set relativenumber
  endif
endfunc
nnoremap <C-o> :call NumberToggle()<cr>

" always show status line with file name and position "
set laststatus=2 showmode
set statusline=%t\ %y\ format:\ %{&ff};\ [%c,%l]

" pretty cool interactive search (like Firefox) "
set incsearch

highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%81v.\+/
syn match tab display "\t"
hi link tab Error
" to fix run :retab

fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun
" kill any trailing whitespace on save
autocmd FileType c,cabal,cpp,haskell,javascript,php,python,readme,text
  \ autocmd BufWritePre <buffer>
  \ :call <SID>StripTrailingWhitespaces()

" highlight literal tabs
" (but don't highlight trailing whitespace; it's annoying as you type)
" actually even tabs are annoying since they are in e.g. git commit msgs
" could make it just for php but i'm not sure it's even needed
match Error '\t'

" make split windows easier to navigate
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-h> <C-w>h
map <C-l> <C-w>l
map <C-m> <C-w>_

autocmd FileType make setlocal noexpandtab

set t_Co=256
colorscheme pallotron
