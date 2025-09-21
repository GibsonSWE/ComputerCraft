term.clear()
term.setCursorPos(1, 2)
print("Generator Controller is running...")

while true do
    local generator  = peripheral.wrap("redstone_relay_1")
    local capacitor = peripheral.wrap("enderio:basic_capacitor_bank_0")
    local energy = capacitor.getEnergy()
    local energy_capacity = capacitor.getEnergyCapacity()
    local energy_percentage = math.floor(((energy / capacitor.getEnergyCapacity()) * 100) + 0.5)
    local generator_status = generator.getOutput("right") and "ON" or "OFF"
    term.setCursorPos(1, 4)
    term.clearLine()
    term.write("Capacitor: " .. energy_percentage .. "%")
    term.setCursorPos(1, 5)
    term.clearLine()
    term.write("Generator Status: " .. generator_status)

    if energy < 100000 and not generator.getOutput("right") then
        generator.setOutput("right", true)
    elseif capacitor.getEnergy() >= 500000 and generator.getOutput("right") then
        generator.setOutput("right", false)
    end
    sleep(0.5)
end
