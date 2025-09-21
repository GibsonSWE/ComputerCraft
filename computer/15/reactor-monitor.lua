term.clear()
term.setCursorPos(1, 2)
local monitor = peripheral.wrap("right")

print("Reactor Monitor Running...")

while true do
    local reactor = peripheral.wrap("fissionReactorLogicAdapter_1")
    local status = reactor.getStatus()
    local damage = reactor.getDamagePercent()
    local burn_rate = reactor.getBurnRate()
    local actual_burn_rate = reactor.getActualBurnRate()
    local temperature = reactor.getTemperature() - 273.15 -- Converts from Kelvin to Celsius
    local heating_rate = reactor.getHeatingRate()
    local coolant = reactor.getCoolant()
    local coolant_level = coolant.amount
    local coolant_capacity = reactor.getCoolantCapacity()
    local coolant_percentage = math.floor((coolant_level / coolant_capacity * 100) + 0.5)
    local waste = reactor.getWaste()
    local waste_level = waste.amount
    local waste_capacity = reactor.getWasteCapacity()
    local waste_percentage = math.floor((waste_level / waste_capacity * 100) + 0.5)
    local fuel_level = string.format("%.1f", reactor.getFuelFilledPercentage() * 100)
    local fuel_production_relay = peripheral.wrap("redstone_relay_6")
    local fuel_production = fuel_production_relay.getOutput("top") and "ON" or "OFF"

    local energy_level_trigger_low = 50
    local energy_level_trigger_high = 99

    local capacitor = peripheral.wrap("inductionPort_0")
    local energy = capacitor.getEnergy() / 2.5 -- Convert from Joules to RF/FE
    local energy_percentage = math.floor((capacitor.getEnergyFilledPercentage() * 100) + 0.5) -- Convert to percentage
    local energy_output = capacitor.getLastOutput() / 2.5 -- Convert from Joules to RF/FE
    local energy_input = capacitor.getLastInput() / 2.5 -- Convert from Joules to RF/FE
    local transfer_cap = capacitor.getTransferCap() / 2.5 -- Convert from Joules to RF/FE

    local water_tank = peripheral.wrap("dynamicValve_2")
    local water_tank_stored = water_tank.getStored()
    local water_tank_capacity = water_tank.getTankCapacity()
    local water_tank_percentage = string.format("%.1f", water_tank.getFilledPercentage() * 100)

    local water_valve = peripheral.wrap("redstone_relay_5")
    local turbine = peripheral.wrap("turbineValve_0")

    if water_valve.getOutput("back") or water_valve.getInput("bottom") then
        water_valve_status = "CLOSED"
    else
        water_valve_status = "OPEN"
    end

    
    monitor.clear()

    monitor.setCursorPos(1, 2)
    monitor.write("Reactor Status: ")
    if status == true then
        monitor.write("ONLINE")
    else
        monitor.write("OFFLINE")
    end
    monitor.setCursorPos(1, 3)
    monitor.write("Reactor Damage: ")
    monitor.write(damage .. "%")

    monitor.setCursorPos(1, 5)
    monitor.write("Reactor Temperature: ")
    monitor.write(string.format("%.1fC", temperature))
    monitor.setCursorPos(1, 6)
    monitor.write("Heating Rate: ")
    monitor.write(heating_rate .. " mB/t")
    monitor.setCursorPos(1, 7)
    monitor.write("Fuel Level: ")
    monitor.write(fuel_level .. "%")
    monitor.setCursorPos(1, 8)
    monitor.write("Waste Level: ")
    monitor.write(waste_percentage .. "%")

    monitor.setCursorPos(1, 10)
    monitor.write("Reactor Coolant Level: ")
    monitor.write(coolant_percentage .. "%")
    monitor.setCursorPos(1, 11)
    monitor.write("Water Tank Level: ")
    monitor.write(water_tank_percentage .. "%")
    monitor.setCursorPos(1, 12)
    monitor.write("Water Valve Status: ")
    monitor.write(water_valve_status)

    monitor.setCursorPos(1, 14)
    monitor.write("Burn Rate (Set): ")
    monitor.write(burn_rate .. " mB/t")
    monitor.setCursorPos(1, 15)
    monitor.write("Burn Rate (Actual): ")
    monitor.write(actual_burn_rate .. " mB/t")

    monitor.setCursorPos(1, 17)
    monitor.write("Energy Stored: ")
    monitor.write(energy_percentage .. "%")
    monitor.setCursorPos(1, 18)
    monitor.write("Energy Demand: ")
    monitor.write(energy_output .. " RF/t")
    monitor.setCursorPos(1, 19)
    monitor.write("Energy Production: ")
    monitor.write(energy_input .. " RF/t")

    monitor.setCursorPos(1, 21)
    monitor.write("Fuel Production: ")
    monitor.write(fuel_production)

    sleep(0.2)
end
