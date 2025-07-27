local monitor = peripheral.wrap("left")
local monitor_width, monitor_height = monitor.getSize()
local mid_divider = math.floor(monitor_width / 2)
local left_pane = window.create(monitor, 1, 1, mid_divider, monitor_height, false)
local right_pane = window.create(monitor, mid_divider + 1, 1, mid_divider, monitor_height, false)
local line_number = 1

left_pane.setVisible(true)
right_pane.setVisible(true)

monitor.setTextScale(0.5)
monitor.clear()
line_number = 3
monitor.setCursorPos(20, line_number)
monitor.write("Refinery & Powerplant Dashboard")
monitor.setTextScale(0.5)

while true do
    local generator_relay = peripheral.wrap("redstone_relay_2")
    local generator_relay_side = "front"
    local generator_status = generator_relay.getOutput(generator_relay_side) and "OFF" or "ON"
    
    local capacitor = peripheral.wrap("enderio:basic_capacitor_bank_0")
    local energy = capacitor.getEnergy()
    local energy_capacity = capacitor.getEnergyCapacity()
    local energy_percentage = math.floor(((energy / capacitor.getEnergyCapacity()) * 100) + 0.5)
    
    local water_tank = peripheral.wrap("dynamicValve_2")
    local water_tank_capacity = water_tank.getTankCapacity()
    local water_tank_percentage = string.format("%.1f", water_tank.getFilledPercentage() * 100)

    local pump = peripheral.wrap("redstone_relay_2")
    local pump_status = pump.getOutput("right") and "ON" or "OFF"
    
    local kerosene_tank = peripheral.wrap("dynamicValve_0")
    local kerosene_tank_capacity = kerosene_tank.getTankCapacity()
    local kerosene_tank_percentage = string.format("%.1f", kerosene_tank.getFilledPercentage() * 100)

    local oil_tank = peripheral.wrap("dynamicValve_1")
    local oil_tank_capacity = oil_tank.getTankCapacity()
    local oil_tank_percentage = string.format("%.1f", oil_tank.getFilledPercentage() * 100)

    local diesel_tank = peripheral.wrap("dynamicValve_3")
    local diesel_tank_capacity = diesel_tank.getTankCapacity()
    local diesel_tank_percentage = string.format("%.1f", diesel_tank.getFilledPercentage() * 100)

    local lpg_tank = peripheral.wrap("dynamicValve_4")
    local lpg_tank_capacity = lpg_tank.getTankCapacity()
    local lpg_tank_percentage = string.format("%.1f", lpg_tank.getFilledPercentage() * 100)

    local gasoline_tank = peripheral.wrap("dynamicValve_5")
    local gasoline_tank_capacity = gasoline_tank.getTankCapacity()
    local gasoline_tank_percentage = string.format("%.1f", gasoline_tank.getFilledPercentage() * 100)

    line_number = 6
    left_pane.setCursorPos(1, line_number)
    left_pane.clearLine()
    left_pane.write("Capacitor Charge: " .. energy_percentage .. "%")
    right_pane.setCursorPos(1, line_number)
    right_pane.clearLine()
    right_pane.write("Water Tank: " .. water_tank_percentage .. "%")
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
    left_pane.setCursorPos(1, line_number)
    left_pane.clearLine()
    left_pane.write("Oil Tank: " .. oil_tank_percentage .. "%")
    line_number = line_number + 1
    left_pane.setCursorPos(1, line_number)
    left_pane.clearLine()
    left_pane.write("Diesel Tank: " .. diesel_tank_percentage .. "%")
    line_number = line_number + 1
    left_pane.setCursorPos(1, line_number)
    left_pane.clearLine()
    left_pane.write("Gasoline Tank: " .. gasoline_tank_percentage .. "%")
    line_number = line_number + 1
    left_pane.setCursorPos(1, line_number)
    left_pane.clearLine()
    left_pane.write("LPG Tank: " .. lpg_tank_percentage .. "%")
    line_number = line_number + 1
    left_pane.setCursorPos(1, line_number)
    left_pane.clearLine()
    left_pane.write("Kerosene Tank: " .. kerosene_tank_percentage .. "%")

    sleep(0.5)
end
