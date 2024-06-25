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
    local self = setmetatable({}, k9s)
    self.buffer = false
    self.width = .8
    self.height = .5
    self.openned = false
    return self
end

function k9s:createBuffer(listed, scratch)
    return vim.api.nvim_create_buf(listed, scratch)
end

local function close(s)
    s.buffer = false
    s.openned = false
end

function k9s:open()
    local bufCreated = false

    if not self.buffer then
        self.buffer = k9s:createBuffer(false, true)
        bufCreated = true
    end

    window:openWindow(self.buffer, self.width, self.height)

    if bufCreated then
        vim.fn.termopen('k9s')
    end

     window:onClose(self, close)

    cmd("startinsert")

    self.openned = true
end

function k9s:toggle()
    if self.openned == true then
        self:hide()
    else
        self:open()
    end
end

function k9s:hide()
    window:hide()
    self.openned = false
end

return k9s()
