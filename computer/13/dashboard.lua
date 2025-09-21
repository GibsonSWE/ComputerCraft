local monitor = peripheral.wrap("left")
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

local line_number = 1

term.setCursorPos(1, 2)
term.clear()
print("Refinery Dashboard is running...")

left_pane.setVisible(true)
left_pane_col1.setVisible(true)
left_pane_col2.setVisible(true)
right_pane.setVisible(true)
right_pane_col1.setVisible(true)
right_pane_col2.setVisible(true)

monitor.setTextScale(0.5)
monitor.clear()
line_number = 3
monitor.setCursorPos(20, line_number)
monitor.write("Refinery Dashboard")

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
    local water_tank = peripheral.wrap("dynamicValve_2")
    local water_tank_stored = water_tank.getStored()
    local water_tank_capacity = water_tank.getTankCapacity()
    local water_tank_percentage = string.format("%.1f", water_tank.getFilledPercentage() * 100)

    local pumps = peripheral.wrap("redstone_relay_1")
    local pump1_status = pumps.getOutput("right") and "ON" or "OFF"
    local pump2_status = pumps.getOutput("back") and "ON" or "OFF"

    local kerosene_tank = peripheral.wrap("dynamicValve_0")
    local kerosene_tank_stored = kerosene_tank.getStored()
    local kerosene_tank_capacity = kerosene_tank.getTankCapacity()
    local kerosene_tank_percentage = string.format("%.1f", kerosene_tank.getFilledPercentage() * 100) .. "%"

    local oil_tank = peripheral.wrap("dynamicValve_1")
    local oil_tank_stored = oil_tank.getStored()
    local oil_tank_capacity = oil_tank.getTankCapacity()
    local oil_tank_percentage = string.format("%.1f", oil_tank.getFilledPercentage() * 100) .. "%"

    local diesel_tank = peripheral.wrap("dynamicValve_3")
    local diesel_tank_stored = diesel_tank.getStored()
    local diesel_tank_capacity = diesel_tank.getTankCapacity()
    local diesel_tank_percentage = string.format("%.1f", diesel_tank.getFilledPercentage() * 100) .. "%"


    local lpg_tank = peripheral.wrap("dynamicValve_4")
    local lpg_tank_stored = lpg_tank.getStored()
    local lpg_tank_capacity = lpg_tank.getTankCapacity()
    local lpg_tank_percentage = string.format("%.1f", lpg_tank.getFilledPercentage() * 100) .. "%"

    local gasoline_tank = peripheral.wrap("dynamicValve_5")
    local gasoline_tank_stored = gasoline_tank.getStored()
    local gasoline_tank_capacity = gasoline_tank.getTankCapacity()
    local gasoline_tank_percentage = string.format("%.1f", gasoline_tank.getFilledPercentage() * 100) .. "%"

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

    line_number = 6
    writeColumn(right_pane_col1, right_pane_col2, line_number, "Water Tank", water_tank_percentage .. "%", water_tank_stored)
    line_number = line_number + 1
    writeColumn(right_pane_col1, right_pane_col2, line_number, "Thresholds", "25% / 75%")
    line_number = line_number + 1
    writeColumn(right_pane_col1, right_pane_col2, line_number, "Pump 1 Status" .. pump1_status)
    line_number = line_number + 1
    writeColumn(right_pane_col1, right_pane_col2, line_number, "Pump 2 Status" .. pump2_status)

    line_number = line_number + 2
    writeColumn(left_pane_col1, left_pane_col2, line_number, "Oil Tank", oil_tank_percentage, oil_tank_stored)
    line_number = line_number + 1
    writeColumn(left_pane_col1, left_pane_col2, line_number, "Diesel Tank", diesel_tank_percentage, diesel_tank_stored)
    line_number = line_number + 1
    writeColumn(left_pane_col1, left_pane_col2, line_number, "Gasoline Tank", gasoline_tank_percentage, gasoline_tank_stored)
    line_number = line_number + 1
    writeColumn(left_pane_col1, left_pane_col2, line_number, "LPG Tank", lpg_tank_percentage, lpg_tank_stored)
    line_number = line_number + 1
    writeColumn(left_pane_col1, left_pane_col2, line_number, "Kerosene Tank", kerosene_tank_percentage, kerosene_tank_stored)

    sleep(0.2)
end
