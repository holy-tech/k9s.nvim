augroup NvimK9s
    autocmd!
    autocmd VimResized * :lua require("k9s.window").onResize()
    autocmd VimEnter * :lua require("k9s").setupMapping()
augroup END
