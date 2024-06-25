local vim = vim
local window = {}
window.__index = window

setmetatable(window, {
    __call = function (class)
        return class.new()
    end
})

function window.new()
    window.bgBuffer = nil
    window.bgWin = nil
    window.win = nil
    window.onClose = nil
    window.onCloseOrigin = nil

    window.widthPercentage = .8
    window.heightPercentage = .6
    return window
end

function RepeatText(text, times)
    local result = ""
    for _=1, times do
        result = result .. text
    end
    return result
end

function RepeatArray(arr, times)
    local result = {}
    for _=1, times do
        table.insert(result, arr)
    end
    return result
end

function window:createBuffer(listed, scratch)
    return vim.api.nvim_create_buf(listed, scratch)
end

function window:setSize(widthPercentage, heightPercentage)
    window.winWidth = widthPercentage
    window.winHeight = heightPercentage
end

function window:calculateBackgroundSizes()
    local width = vim.api.nvim_get_option("columns")
    local height = vim.api.nvim_get_option("lines")

    local bgWinHeight = math.ceil(height * window.heightPercentage - 4)
    local bgWinWidth = math.ceil(width * window.widthPercentage)

    local bgRow = math.ceil((height - bgWinHeight) / 2 - 1)
    local bgCol = math.ceil((width - bgWinWidth) / 2)

    return {
        bgWinHeight = bgWinHeight,
        bgWinWidth = bgWinWidth,
        bgRow = bgRow,
        bgCol = bgCol,
    }
end

function window:calculateWindowSizes()
    local width = vim.api.nvim_get_option("columns")
    local height = vim.api.nvim_get_option("lines")

    local winHeight = math.ceil(height * window.heightPercentage - 6)
    local winWidth = math.ceil(width * window.widthPercentage - 2)
    local row = math.ceil((height - winHeight) / 2 - 1)
    local col = math.ceil((width - winWidth) / 2)

    return {
        winHeight = winHeight,
        winWidth = winWidth,
        row = row,
        col = col
    }
end

function window:decorateBuffer(buf, width, height)
    local top = "╭" .. RepeatText("─", width - 2) .. "╮"
    local mid = RepeatArray("│" .. RepeatText(" ", width - 2) .. "│", height - 2)
    local bot = "╰" .. RepeatText("─", width - 2) .. "╯"
    local lines = {}
    table.insert(lines, top)
    for i=1, #mid do
        table.insert(lines, mid[i])
    end
    table.insert(lines, bot)

    vim.api.nvim_buf_set_lines(buf, 0, -1, true, lines)
end

function window:openWindow(buf, widthPercentage, heightPercentage)
    if widthPercentage and heightPercentage then
        window:setSize(widthPercentage, heightPercentage)
    end

    window.bgBuffer = window.bgBuffer or window:createBuffer(false, true)

    window:decorateBuffer(
        window.bgBuffer,
        window:calculateBackgroundSizes()["bgWinWidth"],
        window:calculateBackgroundSizes()["bgWinHeight"]
    )

    window.bgWin = vim.api.nvim_open_win(
        window.bgBuffer,
        true,
        {
            relative='editor',
            row=window:calculateBackgroundSizes()["bgRow"],
            col=window:calculateBackgroundSizes()["bgCol"],
            width=window:calculateBackgroundSizes()["bgWinWidth"],
            height=window:calculateBackgroundSizes()["bgWinHeight"],
            style="minimal"
        }
    )

    --if window.win and vim.api.nvim_win_is_valid(window.win) then
    --    vim.api.nvim_win_set_buf(window.win, window.buffer)
    --else
        window.win = vim.api.nvim_open_win(
            buf,
            true,
            {
                relative='editor',
                row=window:calculatewindowSizes()["row"],
                col=window:calculatewindowSizes()["col"],
                width=window:calculatewindowSizes()["winWidth"],
                height=window:calculatewindowSizes()["winHeight"],
                style="minimal"
            }
        )
    --end

    vim.api.nvim_command(
        [[au BufWipeout <buffer> exe ':lua require("k9s.window"):close()']]
    )
end

function window:close()
    print("buff wiped out")
    if window.bgWin and vim.api.nvim_win_is_valid(window.bgWin) then
        vim.api.nvim_win_close(window.bgWin, {})
    end
    window.win = nil
    window.bgWin = nil
    window.bgBuffer = nil
    if window.onClose ~= nil then
        window.onClose(window.onCloseOrigin)
    end
end

function window:hide()
    if window.win and vim.api.nvim_win_is_valid(window.win) then
        vim.api.nvim_win_hide(window.win)
    end
    if window.bgWin and vim.api.nvim_win_is_valid(window.bgWin) then
        vim.api.nvim_win_hide(window.bgWin)
    end
end

function window:onClose(origin, fun)
    if fun ~= nil then
        window.onClose = fun
        window.onCloseOrigin = origin
    end
end

function window:onResize()
    vim.api.nvim_win_set_config(window.bgBuf, {
        width = window:calculateBackgroundSizes()["bgWinWidth"],
        height = window:calculateBackgroundSizes()["bgWinHeight"],
        col = window:calculateBackgroundSizes()["bgCol"],
        row = window:calculateBackgroundSizes()["bgRow"],
    })

    window:decorateBuffer(
        window.bgBuf,
        window:calculateBackgroundSizes()["bgWinWidth"],
        window:calculateBackgroundSizes()["bgWinHeight"]
    )

    vim.api.nvim_win_set_config(window.win, {
        width = window:calculateWindowSizes()["winWidth"],
        height = window:calculateWindowSizes()["winHeight"],
        col = window:calculateWindowSizes()["col"],
        row = window:calculateWindowSizes()["row"],
    })
end

return window()
