" Set 'background' back to the default.  The value can't always be estimated
" and is then guessed.
hi clear Normal
set bg&

" Remove all existing highlighting and set the defaults.
hi clear

" Load the syntax highlighting defaults, if it's enabled.
if exists("syntax_on")
  syntax reset
endif

let colors_name = "default"

" vim: sw=2

" underline current line
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END

hi LineNr ctermfg=102 ctermbg=235 cterm=NONE guifg=#84898c guibg=#2a343a gui=NONE
hi CursorLine ctermbg=8 cterm=NONE
hi CursorColumn ctermbg=8
hi ColorColumn ctermbg=235
hi NonText ctermfg=red
hi IncSearch ctermfg=16 ctermbg=107 cterm=NONE guifg=#182227 guibg=#8bb664 gui=NONE
hi Search ctermfg=red ctermbg=yellow cterm=NONE guifg=NONE guibg=NONE gui=underline

highlight clear SpellBad
highlight SpellBad term=standout ctermfg=1 term=underline cterm=underline
highlight clear SpellCap
highlight SpellCap term=underline cterm=underline
highlight clear SpellRare
highlight SpellRare term=underline cterm=underline
highlight clear SpellLocal
highlight SpellLocal term=underline cterm=underline
