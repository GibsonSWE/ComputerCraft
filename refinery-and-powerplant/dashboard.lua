local monitor = peripheral.wrap("left")
local monitor_width, monitor_height = monitor.getSize()
local mid_divider = math.floor(monitor_width / 2)
local left_pane = window.create(monitor, 1, 1, mid_divider, monitor_height, false)
local right_pane = window.create(monitor, mid_divider + 1, 1, mid_divider, monitor_height, false)

local generator_relay = peripheral.wrap("redstone_relay_2")
local generator__relay_side = "front"
local generator_status = generator_relay.getOutput(generator__relay_side) and "OFF" or "ON"

local capacitor = peripheral.wrap("enderio:basic_capacitor_bank_0")
local energy = capacitor.getEnergy()
local energy_capacity = capacitor.getEnergyCapacity()
local energy_percentage = math.floor(((energy / capacitor.getEnergyCapacity()) * 100) + 0.5)

local water_tank = peripheral.wrap("railcraft:steel_tank_0").tanks()[1]
local water_tank_capacity = 4000000  -- Set the capacity of the water tank to 4,000,000 mb
local water_tank_percentage = math.floor(((water_tank["amount"] / water_tank_capacity) * 100) + 0.5)
local pump = peripheral.wrap("redstone_relay_2")
local pump_status = pump.getOutput("right") and "ON" or "OFF"

local diesel_tank = peripheral.wrap("railcraft:steel_tank_1").tanks()[1]
local diesel_tank_amount = (diesel_tank and diesel_tank.amount) or 0  -- Ensure we handle the case where the tank might not have an amount
local diesel_tank_capacity = 4000000  -- Set the capacity of the diesel tank to 4,000,000 mb
local diesel_tank_percentage = math.floor(((diesel_tank_amount / diesel_tank_capacity) * 100) + 0.5)

local lpg_tank = peripheral.wrap("railcraft:steel_tank_2").tanks()[1]
local lpg_tank_amount = (lpg_tank and lpg_tank.amount) or 0  -- Ensure we handle the case where the tank might not have an amount
local lpg_tank_capacity = 4000000  -- Set the capacity of the LPG tank to 4,000,000 mb
local lpg_tank_percentage = math.floor(((lpg_tank_amount / lpg_tank_capacity) * 100) + 0.5)


-- Dynamic Tank Methods:
getMaxPos
isFormed
getInputItem
decrementContainerEditMode
getContainerEditMode
getOutputItem
getMinPos
getWidth
getTankCapacity
getFilledPercentage
getComparatorLevel
getChemicalTankCapacity
help
getHeight
getStored
incrementContainerEditMode
getLength
setContainerEditMode



left_pane.setVisible(true)
right_pane.setVisible(true)

monitor.setTextScale(1)
monitor.clear()
monitor.setCursorPos(5, 2)
monitor.write("Refinery & Powerplant Dashboard")
monitor.setTextScale(0.5)

while true do
    left_pane.setCursorPos(1, 4)
    left_pane.clearLine()
    left_pane.write("Capacitor Charge: " .. energy_percentage .. "%")
    left_pane.setCursorPos(1, 5)
    left_pane.clearLine()
    left_pane.write("Thresholds: 20%/90%")
    left_pane.setCursorPos(1, 7)
    left_pane.clearLine()
    left_pane.write("Generator Status: " .. generator_status)

    right_pane.setCursorPos(1, 4)
    right_pane.clearLine()
    right_pane.write("Water Tank: " .. water_tank_percentage .. "%")
    right_pane.setCursorPos(1, 5)
    right_pane.write("Thresholds: 25%/75%")
    right_pane.setCursorPos(1, 7)
    right_pane.clearLine()
    right_pane.write("Pump Status: " .. pump_status)

    left_pane.setCursorPos(1, 15)
    left_pane.clearLine()
    left_pane.write("Diesel Tank: " .. diesel_tank_percentage .. "%")
    left_pane.setCursorPos(1, 16)
    left_pane.clearLine()
    left_pane.write("LPG Tank: " .. lpg_tank_percentage .. "%")

    sleep(0.5)
end
