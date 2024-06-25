local window = require("nvim-k8s.window")
local vim = vim
local cmd = vim.api.nvim_command
local k8s = {}
k8s.__index = k8s

setmetatable(k8s, {
    __call = function (cls)
        return cls.new()
    end
})

function k8s.new()
    local self = setmetatable({}, k8s)
    self.buffer = nil
    self.width = .8
    self.height = .5
    self.openned = false
    return self
end

function k8s:createBuffer(listed, scratch)
    return vim.api.nvim_create_buf(listed, scratch)
end

local function close(s)
    s.buffer = nil
    s.openned = false
end

function k8s:open()
    local bufCreated = false

    if not self.buffer then
        self.buffer = k8s:createBuffer(false, true)
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

function k8s:toggle()
    if self.openned == true then
        self:hide()
    else
        self:open()
    end
end

function k8s:hide()
    window:hide()
    self.openned = false
end

return k8s()
