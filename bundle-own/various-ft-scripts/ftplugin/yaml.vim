
function! s:HideExplicitInitState()
    silent! g:^explicit_init_state:;/^\S/-1fold
    normal! gg
    nohl
endfunction

call s:HideExplicitInitState()

function! s:HideNumpyTag()
    silent! g/\w\+\s*:\s\+!np/;/\w\+\s*:\(\s\+\|$\)/-1fold
endfunction

" call s:HideNumpyTag()
