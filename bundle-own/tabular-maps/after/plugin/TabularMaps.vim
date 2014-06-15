if !exists(':Tabularize')
  finish " Tabular.vim wasn't loaded
endif

let s:save_cpo = &cpo
set cpo&vim

AddTabularPattern! eq /^[^=]*\zs=/l1
AddTabularPattern! co /^[^:]*\zs:/l1
AddTabularPattern! di /^[^:]*:\zs/l1

AddTabularPattern! eu /\ze€/l1

let &cpo = s:save_cpo
unlet s:save_cpo
