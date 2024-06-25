local window = require("k9s.window")
local vim = vim
local cmd = vim.api.nvim_command
local k9s = {}
k9s.__index = k9s

setmetatable(k9s, {
    __call = function (cls)
        return cls.new()
    end
})

function k9s.new()
    k9s.buffer = false
    k9s.width = .8
    k9s.height = .5
    k9s.openned = false
    return k9s
end

function k9s.createBuffer(listed, scratch)
    return vim.api.nvim_create_buf(listed, scratch)
end

local function close(s)
    s.buffer = false
    s.openned = false
end

function k9s.open()
    local bufCreated = false

    if not k9s.buffer then
        k9s.buffer = k9s.createBuffer(false, true)
        bufCreated = true
    end

    window.openWindow(k9s.buffer, k9s.width, k9s.height)

    if bufCreated then
        vim.fn.termopen('k9s')
    end

    window.onClose(k9s, close)

    cmd("startinsert")

    k9s.openned = true
end

function k9s.toggle()
    if k9s.openned == true then
        k9s.hide()
    else
        k9s.open()
    end
end

function k9s.hide()
    window.hide()
    k9s.openned = false
end

return k9s()
