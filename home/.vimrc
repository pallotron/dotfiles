:syntax on

execute pathogen#infect()

set ttyfast
set copyindent
set mouse=a
set expandtab

filetype on
filetype plugin indent on

" use control-p to show line numbers
:nmap <silent> <C-P> :set invnumber<CR>
:set invnumber
"autocmd VimEnter * set invnumber

au BufRead,BufNewFile * set tabstop=2 shiftwidth=2
au BufRead,BufNewFile *.phpt set filetype=php wm=2 tw=80
au BufRead,BufNewFile *.py set tabstop=4 shiftwidth=4 filetype=python wm=2 tw=80
au BufRead,BufNewFile *.tw set tabstop=4 shiftwidth=4 filetype=python wm=2 tw=80
au BufRead,BufNewFile *.cconf set tabstop=4 shiftwidth=4 filetype=python wm=2 tw=80
au BufRead,BufNewFile *.cinc set tabstop=4 shiftwidth=4 filetype=python wm=2 tw=80
au BufRead,BufNewFile *.thrift-cvalidator set tabstop=4 shiftwidth=4 filetype=python wm=2 tw=80
au BufRead,BufNewFile TARGETS set tabstop=4 shiftwidth=4 filetype=python wm=2 tw=80
au BufRead,BufNewFile *.rb set tabstop=2 shiftwidth=2 wm=2 tw=80
au BufRead,BufNewFile *.php set tabstop=2 shiftwidth=2 wm=2 tw=80
au BufRead,BufNewFile *.c set tabstop=2 shiftwidth=2 wm=2 tw=80
au BufRead,BufNewFile *.h set tabstop=2 shiftwidth=2 wm=2 tw=80
au BufRead,BufNewFile *.cpp set tabstop=2 shiftwidth=2 wm=2 tw=80
au BufRead,BufNewFile *.md set filetype=markdown wm=2 tw=80
:autocmd BufNewFile,BufRead [Mm]akefile* set noexpandtab


autocmd VimEnter * wincmd p
let g:NERDTreeWinPos = "left"
nmap <silent> <C-D> :NERDTreeToggle<CR>
nnoremap <silent> <C-L> :noh<CR><C-L>

" highlight trailing whitespace "
match Error '\s\+$\|\t'
set colorcolumn=80
let s:color_column_old = 0

" Ctrl-C/N to create new tab and jump to next tab "
" (this should roughly match the 'screen' keys Ctrl-A+C and Ctrl-A+N) "
map <C-c>c :tabe<CR>
map <C-c>o :tabp<CR>
map <C-c>p :tabn<CR>

" It's useful to show the buffer number in the status line.
set laststatus=2 showmode statusline=%02n:%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P

highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%81v.\+/
syn match tab display "\t"
hi link tab Error
" to fix run :retab

highlight ColorColumn ctermbg=235 guibg=#003541

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

autocmd FileType make setlocal noexpandtab

" ctrlp plugin
set runtimepath^=~/.vim/bundle/ctrlp.vim
:helptags ~/.vim/bundle/ctrlp.vim/doc
let g:ctrlp_working_path_mode = 'ra'
"let g:ctrlp_user_command = 'find %s -type f'

autocmd BufWritePost *.py call Flake8()

set cursorline
au BufRead,BufNewFile *.thrift set filetype=thrift
au! Syntax thrift source ~/.vim/thrift.vim

map <C-K> :pyf /mnt/vol/engshare/admin/scripts/vim/clang-format.py<CR>
imap <C-K> <ESC>:pyf /mnt/vol/engshare/admin/scripts/vim/clang-format.py<CR>i

" Mappings to access buffers (don't use "\p" because a
" delay before pressing "p" would accidentally paste).
" \l       : list buffers
" \b \f \g : go back/forward/last-used
" \1 \2 \3 : go to buffer 1/2/3 etc
nnoremap <Leader>l :ls<CR>
nnoremap <Leader>b :bp<CR>
nnoremap <Leader>f :bn<CR>
nnoremap <Leader>g :e#<CR>
nnoremap <Leader>1 :1b<CR>
nnoremap <Leader>2 :2b<CR>
nnoremap <Leader>3 :3b<CR>
nnoremap <Leader>4 :4b<CR>
nnoremap <Leader>5 :5b<CR>
nnoremap <Leader>6 :6b<CR>
nnoremap <Leader>7 :7b<CR>
nnoremap <Leader>8 :8b<CR>
nnoremap <Leader>9 :9b<CR>
nnoremap <Leader>0 :10b<CR>

nnoremap <silent> <Leader>+ :exe "resize " . (winheight(0) * 3/2)<CR>
nnoremap <silent> <Leader>- :exe "resize " . (winheight(0) * 2/3)<CR>

" Don't resize automatically.
let g:golden_ratio_autocommand = 0
" Mnemonic: - is next to =, but instead of resizing equally, all windows are
" resized to focus on the current.
nmap <C-w>- <Plug>(golden_ratio_resize)
" Fill screen with current window.
nnoremap <C-w>+ <C-w><Bar><C-w>_
let g:golden_ratio_filetypes_blacklist = ["nerdtree", "unite"]

let g:airline_theme="powerlineish"
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

let g:conoline_auto_enable = 1

augroup au_go_group
  autocmd!
  autocmd FileType go set noexpandtab
  autocmd FileType go set tabstop=2 shiftwidth=2 softtabstop=2
  match none
augroup END

let g:flake8_cmd="/usr/local/bin/flake8"
autocmd FileType python autocmd BufWritePost <buffer> call Flake8()
let g:flake8_show_in_gutter=1
let g:flake8_show_in_file=1

:setlocal foldmethod=syntax

:highlight LineNr ctermfg=white ctermbg=235

":colorscheme solarized
syntax enable
set background=dark
set t_Co=256
let g:solarized_termcolors=   256
let g:solarized_contrast  =   "normal"
":colorscheme solarized
