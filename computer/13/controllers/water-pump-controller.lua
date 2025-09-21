term.clear()
term.setCursorPos(1, 2)
local pump = peripheral.wrap("redstone_relay_1")
pump.setOutput("right", false) -- Pump 1
pump.setOutput("back", false) -- Pump 2

print("Water Pump Controller is running...")


while true do
    local water_tank = peripheral.wrap("dynamicValve_2")
    local pump = peripheral.wrap("redstone_relay_1")
    local water_tank_stored = water_tank.getStored() or 0
    local water_tank_capacity = water_tank.getTankCapacity() or 0
    --local water_tank_percentage = math.floor(water_tank.getFilledPercentage() + 0.5) / 10
    local water_tank_percentage = water_tank.getFilledPercentage() * 100 -- Get the filled percentage as a decimal and multiply by 100 for percentage
    local pump1_status = pump.getOutput("right") and "ON" or "OFF"
    local pump2_status = pump.getOutput("back") and "ON" or "OFF"
    term.setCursorPos(1, 4)
    term.clearLine()
    term.write("Water Tank: " .. string.format("%.1f", water_tank_percentage) .. "%")
    term.setCursorPos(1, 5)
    term.write("Thresholds: 25%/75%")
    term.setCursorPos(1, 6)
    term.clearLine()
    term.write("Pump 1 Status: " .. pump1_status)
    term.setCursorPos(1, 7)
    term.clearLine()
    term.write("Pump 2 Status: " .. pump2_status)

    if water_tank_percentage < 25 and not pump.getOutput("right") and not pump.getOutput("back") then   -- Check if the water tank is less than 2,000,000 mb (50% of 4,000,000 mb)
        pump.setOutput("right", true) -- Pump 1
        pump.setOutput("back", true) -- Pump 2
    elseif water_tank_percentage >= 75 and pump.getOutput("right") and pump.getOutput("back") then  -- Check if the water tank is greater than or equal to 3,000,000 mb (75% of 4,000,000 mb)
        pump.setOutput("right", false)
        pump.setOutput("back", false)
    end
    os.sleep(0.5)
end
