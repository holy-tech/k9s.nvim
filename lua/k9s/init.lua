local k9s = require("k9s.k9s")
local vim = vim

local function setupMapping()
    local keyMap = vim.g.vim_k9s_toggle_key_map or "π"

    vim.api.nvim_set_keymap(
        't',
        keyMap,
        '<C-\\><C-n><CMD>lua require("nvim-k9s.k9s"):toggle()<CR>',
        { noremap = true, silent = true }
    )

    vim.api.nvim_set_keymap(
        'n',
        keyMap,
        '<C-\\><C-n><CMD>lua require("nvim-k9s.k9s"):toggle()<CR>',
        { noremap = true, silent = true }
    )
end

return {
    setupMapping = setupMapping
}
