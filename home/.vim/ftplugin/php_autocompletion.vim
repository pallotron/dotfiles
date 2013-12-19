let g:pfff_client = '/home/engshare/tools/pfff_client'

if v:version < 700
    echoerr "Php-autocomplete requires vim version 7 or greater."
    finish
endif


inoremap <silent> <buffer> <Tab> <C-R>=<SID>SetVals()<CR><C-R>=<SID>TabComplete('down')<CR><C-R>=<SID>RestoreVals()<CR>

if !exists("*s:MakeDictionaryForPhp")
function! s:MakeDictionaryForPhp()

  set showmode

  let mynbr = system('echo -ne $RANDOM')
  let fn = '/tmp/auto-complete-' . mynbr . '.php'
  let &dictionary = '/tmp/auto-complete-choices-' . mynbr . '.txt'
  let c = getpos(".")
  silent execute ':w! ' . fn
  let dumb = system('sed -i -e "' . c[1] . ' s#\(.\{'. (c[2] - 1) .'\}\)\(.*\)#\1JUJUMARKER\2#g" ' . fn)
  let dumb2 = system(g:pfff_client . ' -vim_auto_complete ' . fn . ' > ' . &dictionary)
  let dumb3 = system('rm -f ' . fn)
  return ""

endfunction
endif


if !exists("*s:TabComplete")
function! s:TabComplete(direction)

" Quelle connerie ce langage de script!
  if searchpos('[_a-zA-Z0-9>' . "'" . ':$(]\%#', 'nb') != [0, 0]
    call s:MakeDictionaryForPhp()

    let dumb5 = searchpos('[(]\%#', 'nb')

    if dumb5 != [0, 0]
       set noshowmode
       echohl Type | echo system('cat '. &dictionary . ' | { read x; echo -ne $x; }') | echohl None
       return ''
    else
      return "\<C-X>\<C-K>"
    endif
  else
      return "\<Tab>"
  endif

endfunction
endif


if !exists("*s:SetVals")
    function! s:SetVals()
        " Save and change any config values we need.

        " Temporarily change isk to treat periods and opening
        " parenthesis as part of a keyword -- so we can complete
        " python modules and functions:
"        let s:pydiction_save_isk = &iskeyword
"        setlocal iskeyword +=.,(


        " Save any current dictionaries the user has set:
        let s:pydiction_save_dictions = &dictionary

        " Save the ins-completion options the user has set:
        let s:pydiction_save_cot = &completeopt
        " Have the completion menu show up for one or more matches:
        let &completeopt = "longest,menuone"

        " Set the popup menu height:
        let s:pydiction_save_pumheight = &pumheight
        let &pumheight = 1000

        return ''
    endfunction
endif


if !exists("*s:RestoreVals")
    function! s:RestoreVals()
        " Restore the user's initial values.
        let dumb6 = system('rm -f ' . &dictionary)
        let &dictionary = s:pydiction_save_dictions
        let &completeopt = s:pydiction_save_cot
        let &pumheight = s:pydiction_save_pumheight
"        let &iskeyword = s:pydiction_save_isk
        return ''
    endfunction
endif
