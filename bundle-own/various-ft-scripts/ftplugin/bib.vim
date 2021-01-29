" Trick adapted from: https://johngodlee.github.io/2019/07/31/bibtex-fold.html
" Set folding function for bibtex entries
function! FoldBibtex()
  if getline(v:lnum) =~ '^@.*$'
    return ">1"
  endif
  return "="
endfunction
au BufEnter *.bib setlocal foldexpr=FoldBibtex()
au BufEnter *.bib setlocal foldmethod=expr
