term.clear()
term.setCursorPos(1, 2)
print("Water Pump Controller is running...")


while true do
    local water_tank = peripheral.wrap("dynamicValve_2")
    local pump = peripheral.wrap("redstone_relay_1")
    local water_tank_stored = water_tank.getStored() or 0
    local water_tank_capacity = water_tank.getTankCapacity() or 0
    local water_tank_percentage = water_tank.getFilledPercentage() * 100        -- Get the filled percentage as a decimal and multiply by 100 for percentage
    local pump_status = pump.getOutput("right") and "ON" or "OFF"
    term.setCursorPos(1, 4)
    term.clearLine()
    term.write("Water Tank: " .. string.format("%.1f", water_tank_percentage) .. "%")
    term.setCursorPos(1, 5)
    term.write("Thresholds: 25%/75%")
    term.setCursorPos(1, 6)
    term.clearLine()
    term.write("Pump Status: " .. pump_status)

    if water_tank_percentage < 25 and not pump.getOutput("right") then          -- Check if the water tank is less than 25% filled
        pump.setOutput("right", true)
    elseif water_tank_percentage >= 75 and pump.getOutput("right") then         -- Check if the water tank is greater than or equal to 75% filled
        pump.setOutput("right", false)
    end
    os.sleep(0.5)
end
