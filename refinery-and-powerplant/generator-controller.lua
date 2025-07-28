term.clear()
term.setCursorPos(1, 2)
print("Generator Controller is running...")


while true do
    local generator  = peripheral.wrap("redstone_relay_2")
    local relay_side = "front"
    local capacitor = peripheral.wrap("inductionPort_0") -- Convert from Joules to RF/FE
    local energy = capacitor.getEnergy() / 2.5 -- Convert from Joules to RF/FE
    local energy_capacity = capacitor.getMaxEnergy() / 2.5 -- Convert from Joules to RF/FE
    local energy_percentage = math.floor((capacitor.getEnergyFilledPercentage()) + 0.5)
    local generator_status = generator.getOutput(relay_side) and "OFF" or "ON"
    term.setCursorPos(1, 4)
    term.clearLine()
    term.write("Capacitor: " .. energy_percentage .. "%")
    term.setCursorPos(1, 5)
    term.write("Thresholds: 20%/90%")
    term.setCursorPos(1, 6)
    term.clearLine()
    term.write("Generator Status: " .. generator_status)

    if energy_percentage < 20 and generator.getOutput(relay_side) then
        generator.setOutput(relay_side, false)
    elseif energy_percentage >= 90 and not generator.getOutput(relay_side) then
        generator.setOutput(relay_side, true)
    end
    sleep(0.5)
end
