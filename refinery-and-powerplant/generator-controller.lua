term.clear()
term.setCursorPos(1, 2)
print("Generator Controller is running...")

while true do
    local generator  = peripheral.wrap("redstone_relay_2")
    local relay_side = "front"
    local capacitor = peripheral.wrap("enderio:basic_capacitor_bank_0")
    local energy = capacitor.getEnergy()
    local energy_capacity = capacitor.getEnergyCapacity()
    local energy_percentage = math.floor(((energy / capacitor.getEnergyCapacity()) * 100) + 0.5)
    local generator_status = generator.getOutput(relay_side) and "OFF" or "ON"
    term.setCursorPos(1, 4)
    term.clearLine()
    term.write("Capacitor: " .. energy_percentage .. "%")
    term.setCursorPos(1, 5)
    term.write("Thresholds: 20%/90%")
    term.setCursorPos(1, 6)
    term.clearLine()
    term.write("Generator Status: " .. generator_status)

    if energy < 100000 and generator.getOutput(relay_side) then
        generator.setOutput(relay_side, false)
    elseif capacitor.getEnergy() >= 450000 and not generator.getOutput(relay_side) then
        generator.setOutput(relay_side, true)
    end
    sleep(0.5)
end
