local monitor = peripheral.wrap("left")
local monitor_width, monitor_height = monitor.getSize()
local mid_divider = math.floor(monitor_width / 2)
local left_pane = window.create(monitor, 1, 1, mid_divider, monitor_height, false)
local left_pane_divider = math.floor(mid_divider / 2)
local left_pane_col1 = window.create(left_pane, 1, 1, left_pane_divider, monitor_height, false)
local left_pane_col2 = window.create(left_pane, left_pane_divider + 1, 1, left_pane_divider, monitor_height, false)
local right_pane = window.create(monitor, mid_divider + 1, 1, mid_divider, monitor_height, false)
local line_number = 1

term.setCursorPos(1, 2)
term.clear()
print("Refinery & Powerplant Dashboard is running...")

left_pane.setVisible(true)
left_pane_col1.setVisible(true)
left_pane_col2.setVisible(true)
right_pane.setVisible(true)

monitor.setTextScale(0.5)
monitor.clear()
line_number = 3
monitor.setCursorPos(20, line_number)
monitor.write("Refinery & Powerplant Dashboard")
monitor.setTextScale(0.5)

function formatNumber(num)
    if num >= 1e6 then
        return string.format("%.2fM", num / 1e6)
    elseif num >= 1e3 then
        return string.format("%.2fK", num / 1e3)
    else
        return tostring(num)
    end
end


while true do
    local generator_relay = peripheral.wrap("redstone_relay_2")
    local generator_relay_side = "front"
    local generator_status = generator_relay.getOutput(generator_relay_side) and "OFF" or "ON"
    
    local capacitor = peripheral.wrap("inductionPort_0")
    local energy = capacitor.getEnergy() / 2.5 -- Convert from Joules to RF/FE
    local energy_capacity = capacitor.getMaxEnergy() / 2.5 -- Convert from Joules to RF/FE
    local energy_percentage = math.floor((capacitor.getEnergyFilledPercentage()) + 0.5)
    local energy_output = capacitor.getLastOutput() / 2.5 -- Convert from Joules to RF/FE
    local energy_input = capacitor.getLastInput() / 2.5 -- Convert from Joules to RF/FE
    local transfer_cap = capacitor.getTransferCap() / 2.5 -- Convert from Joules to RF/FE

    local water_tank = peripheral.wrap("dynamicValve_2")
    local water_tank_stored = water_tank.getStored()
    local water_tank_capacity = water_tank.getTankCapacity()
    local water_tank_percentage = string.format("%.1f", water_tank.getFilledPercentage() * 100)

    local pump = peripheral.wrap("redstone_relay_2")
    local pump_status = pump.getOutput("right") and "ON" or "OFF"
    
    local kerosene_tank = peripheral.wrap("dynamicValve_0")
    local kerosene_tank_stored = kerosene_tank.getStored()
    local kerosene_tank_capacity = kerosene_tank.getTankCapacity()
    local kerosene_tank_percentage = string.format("%.1f", kerosene_tank.getFilledPercentage() * 100)

    local oil_tank = peripheral.wrap("dynamicValve_1")
    local oil_tank_stored = oil_tank.getStored()
    local oil_tank_capacity = oil_tank.getTankCapacity()
    local oil_tank_percentage = string.format("%.1f", oil_tank.getFilledPercentage() * 100)

    local diesel_tank = peripheral.wrap("dynamicValve_3")
    local diesel_tank_stored = diesel_tank.getStored()
    local diesel_tank_capacity = diesel_tank.getTankCapacity()
    local diesel_tank_percentage = string.format("%.1f", diesel_tank.getFilledPercentage() * 100)

    local lpg_tank = peripheral.wrap("dynamicValve_4")
    local lpg_tank_stored = lpg_tank.getStored()
    local lpg_tank_capacity = lpg_tank.getTankCapacity()
    local lpg_tank_percentage = string.format("%.1f", lpg_tank.getFilledPercentage() * 100)

    local gasoline_tank = peripheral.wrap("dynamicValve_5")
    local gasoline_tank_stored = gasoline_tank.getStored()
    local gasoline_tank_capacity = gasoline_tank.getTankCapacity()
    local gasoline_tank_percentage = string.format("%.1f", gasoline_tank.getFilledPercentage() * 100)

    line_number = 6
    left_pane.setCursorPos(1, line_number)
    left_pane.clearLine()
    left_pane.write("Capacitor Charge: " .. formatNumber(energy) .. "FE / " .. formatNumber(energy_capacity) .. "FE (" .. energy_percentage .. "%)")
    line_number = line_number + 1
    left_pane.setCursorPos(1, line_number)
    left_pane.clearLine()
    left_pane.write("Output Rate: " .. energy_output .. " FE/t")
    line_number = line_number + 1
    left_pane.setCursorPos(1, line_number)
    left_pane.clearLine()
    left_pane.write("Input Rate: " .. energy_input .. " FE/t")
    right_pane.setCursorPos(1, line_number)
    right_pane.clearLine()
    right_pane.write("Water Tank: " .. water_tank_percentage .. "% (" .. formatNumber(water_tank_stored.amount) .. "B)")
    line_number = line_number + 1
    left_pane.setCursorPos(1, line_number)
    left_pane.clearLine()
    left_pane.write("Thresholds: 20% / 90%")
    right_pane.setCursorPos(1, line_number)
    right_pane.clearLine()
    right_pane.write("Thresholds: 25% / 75%")
    line_number = line_number + 1
    left_pane.setCursorPos(1, line_number)
    left_pane.clearLine()
    left_pane.write("Generator Status: " .. generator_status)
    right_pane.setCursorPos(1, line_number)
    right_pane.clearLine()
    right_pane.write("Pump Status: " .. pump_status)

    line_number = line_number + 2
    left_pane_col1.setCursorPos(1, line_number)
    left_pane_col1.clearLine()
    left_pane_col1.write("Oil Tank:")
    left_pane_col2.setCursorPos(1, line_number)
    left_pane_col2.clearLine()
    left_pane_col2.write(oil_tank_percentage .. "% (" .. formatNumber(oil_tank_stored.amount) .. "B)")
    line_number = line_number + 1
    left_pane_col1.setCursorPos(1, line_number)
    left_pane_col1.clearLine()
    left_pane_col1.write("Diesel Tank:")
    left_pane_col2.setCursorPos(1, line_number)
    left_pane_col2.clearLine()
    left_pane_col2.write(diesel_tank_percentage .. "% (" .. formatNumber(diesel_tank_stored.amount) .. "B)")
    line_number = line_number + 1
    left_pane_col1.setCursorPos(1, line_number)
    left_pane_col1.clearLine()
    left_pane_col1.write("Gasoline Tank:")
    left_pane_col2.setCursorPos(1, line_number)
    left_pane_col2.clearLine()
    left_pane_col2.write(gasoline_tank_percentage .. "% (" .. formatNumber(gasoline_tank_stored.amount) .. "B)")
    line_number = line_number + 1
    left_pane_col1.setCursorPos(1, line_number)
    left_pane_col1.clearLine()
    left_pane_col1.write("LPG Tank:")
    left_pane_col2.setCursorPos(1, line_number)
    left_pane_col2.clearLine()
    left_pane_col2.write(lpg_tank_percentage .. "% (" .. formatNumber(lpg_tank_stored.amount) .. "B)")
    line_number = line_number + 1
    left_pane_col1.setCursorPos(1, line_number)
    left_pane_col1.clearLine()
    left_pane_col1.write("Kerosene Tank:")
    left_pane_col2.setCursorPos(1, line_number)
    left_pane_col2.clearLine()
    left_pane_col2.write(kerosene_tank_percentage .. "% (" .. formatNumber(kerosene_tank_stored.amount) .. "B)")

    sleep(0.2)
end
