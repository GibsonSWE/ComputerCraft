local monitor = peripheral.wrap("monitor_1")
local monitor_width, monitor_height = monitor.getSize()
local mid_divider = math.floor(monitor_width / 2)
local left_pane = window.create(monitor, 1, 1, mid_divider, monitor_height, false)
local left_pane_divider = math.floor(mid_divider / 2)
local left_pane_col1 = window.create(left_pane, 1, 1, left_pane_divider, monitor_height, false)
local left_pane_col2 = window.create(left_pane, left_pane_divider + 1, 1, left_pane_divider, monitor_height, false)
local right_pane = window.create(monitor, mid_divider + 1, 1, mid_divider, monitor_height, false)
local right_pane_divider = math.floor(mid_divider / 2)
local right_pane_col1 = window.create(right_pane, 1, 1, right_pane_divider, monitor_height, false)
local right_pane_col2 = window.create(right_pane, right_pane_divider + 1, 1, right_pane_divider, monitor_height, false)
local tablet_ids = {7, 14}

local line_number = 3

rednet.open("top")

term.setCursorPos(1, 2)
term.clear()
print("Power Dashboard is running...")

left_pane.setVisible(true)
left_pane_col1.setVisible(true)
left_pane_col2.setVisible(true)
right_pane.setVisible(true)
right_pane_col1.setVisible(true)
right_pane_col2.setVisible(true)


function formatNumber(num)
    if num >= 1e9 then
        return string.format("%.2f G", num / 1e9)
    elseif num >= 1e6 then
        return string.format("%.2f M", num / 1e6)
    elseif num >= 1e3 then
        return string.format("%.2f K", num / 1e3)
    else
        return tostring(num)
    end
end


while true do
    local capacitor = peripheral.wrap("inductionPort_0")
    local energy = capacitor.getEnergy() / 2.5 -- Convert from Joules to RF/FE
    local energy_capacity = capacitor.getMaxEnergy() / 2.5 -- Convert from Joules to RF/FE
    local energy_percentage = math.floor((capacitor.getEnergyFilledPercentage() * 100) + 0.5) -- Convert to percentage
    local energy_output = capacitor.getLastOutput() / 2.5 -- Convert from Joules to RF/FE
    local energy_input = capacitor.getLastInput() / 2.5 -- Convert from Joules to RF/FE
    local transfer_cap = capacitor.getTransferCap() / 2.5 -- Convert from Joules to RF/FE

    
    
    
    -- Helper function to write a line to a window at a given line number
    local function writeLine(win, col, line, text)
        win.setCursorPos(col, line)
        win.clearLine()
        win.write(text)
    end
    
    -- Helper function to write tank info
    local function writeColumn(col1, col2, line, key, value)
        writeLine(col1, 1, line, key .. ":")
        writeLine(col2, 1, line, value)
    end
    
    for _, id in ipairs(tablet_ids) do
        rednet.send(id, {
            energy = energy,
            energy_capacity = energy_capacity,
            energy_percentage = energy_percentage,
            energy_input = energy_input,
            energy_output = energy_output,
            transfer_cap = transfer_cap
        })
    end

    line_number = 3
    monitor.setTextScale(0.5)
    monitor.clear()
    left_pane.clear()
    right_pane.clear()
    left_pane_col1.clear()
    left_pane_col2.clear()
    right_pane_col1.clear()
    right_pane_col2.clear()
    monitor.setCursorPos(20, line_number)
    monitor.write("Power Dashboard")

    line_number = 6
    left_pane.setCursorPos(1, line_number)
    left_pane.write("Capacitor Charge: ")
    right_pane.setCursorPos(1, line_number)
    right_pane.write(formatNumber(energy) .. "FE / " .. formatNumber(energy_capacity) .. "FE (" .. energy_percentage .. "%)")
    line_number = line_number + 2
    left_pane.setCursorPos(1, line_number)
    left_pane.write("Transfer Capacity: ")
    right_pane.setCursorPos(1, line_number)
    right_pane.write(formatNumber(transfer_cap) .. "FE/t")
    line_number = line_number + 2
    left_pane.setCursorPos(1, line_number)
    left_pane.write("Input Rate: ")
    right_pane.setCursorPos(1, line_number)
    right_pane.write(energy_input .. " FE/t")
    line_number = line_number + 2
    left_pane.setCursorPos(1, line_number)
    left_pane.write("Output Rate: ")
    right_pane.setCursorPos(1, line_number)
    right_pane.write(energy_output .. " FE/t")

    sleep(0.2)
end
