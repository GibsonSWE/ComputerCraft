term.clear()
term.setCursorPos(1, 2)
local tablet_ids = {7, 14}
rednet.open("top")

print("Wireless Reactor Monitor Running...")

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

    for _, id in ipairs(tablet_ids) do
        rednet.send(id, {
            reactor_status = status,
            damage = damage,
            burn_rate = burn_rate,
            actual_burn_rate = actual_burn_rate,
            temperature = temperature,
            heating_rate = heating_rate,
            fuel_level = fuel_level,
            waste_percentage = waste_percentage,
            coolant_percentage = coolant_percentage,
            water_tank_percentage = water_tank_percentage,
            water_valve_status = water_valve_status,
            fuel_production = fuel_production,
            energy = energy,
            energy_percentage = energy_percentage,
            energy_input = energy_input,
            energy_output = energy_output
        })
    end

    sleep(0.2)
end
