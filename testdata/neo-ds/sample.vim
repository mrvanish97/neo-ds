let s:items = ['a', 'b']

function! Demo(value) abort
  for item in s:items
    if a:value isnot v:null
      echo item
    endif
  endfor
  return v:true
endfunction

augroup DemoGroup
  autocmd!
  autocmd BufWritePost *.vim echo 'saved'
augroup END
