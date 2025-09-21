term.clear()
term.setCursorPos(1, 2)
print("Water Pump Controller is running...")


while true do
    local water_tank = peripheral.wrap("railcraft:steel_tank_0").tanks()[1]
    local pump = peripheral.wrap("redstone_relay_2")
    local water_tank_capacity = 4000000  -- Set the capacity of the water tank to 4,000,000 mb
    local water_tank_percentage = math.floor(((water_tank["amount"] / water_tank_capacity) * 100) + 0.5)
    local pump_status = pump.getOutput("right") and "ON" or "OFF"
    term.setCursorPos(1, 4)
    term.clearLine()
    term.write("Water Tank: " .. water_tank_percentage .. "%")
    term.setCursorPos(1, 5)
    term.clearLine()
    term.write("Pump Status: " .. pump_status)

    if water_tank_percentage < 25 and not pump.getOutput("right") then            -- Check if the water tank is less than 2,000,000 mb (50% of 4,000,000 mb)
        pump.setOutput("right", true)
    elseif water_tank_percentage >= 75 and pump.getOutput("right") then  -- Check if the water tank is greater than or equal to 3,000,000 mb (75% of 4,000,000 mb)
        pump.setOutput("right", false)
    end
    os.sleep(0.5)
end
