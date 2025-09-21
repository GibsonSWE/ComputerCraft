while true do
    local reactor = peripheral.wrap("fissionReactorLogicAdapter_1")
    local status = reactor.getStatus()
    local damage = reactor.getDamagePercent()
    local burn_rate = reactor.getBurnRate()
    local actual_burn_rate = reactor.getActualBurnRate()
    local temperature = reactor.getTemperature()
    local coolant = reactor.getCoolant()
    local coolant_level = coolant.amount
    local coolant_capacity = reactor.getCoolantCapacity()
    local coolant_percentage = math.floor((coolant_level / coolant_capacity * 100) + 0.5)
    local waste = reactor.getWaste()
    local waste_level = waste.amount
    local waste_capacity = reactor.getWasteCapacity()
    local waste_percentage = math.floor((waste_level / waste_capacity * 100) + 0.5)
    local fuel_level = reactor.getFuelFilledPercentage() * 100
    local fuel_production = peripheral.wrap("redstone_relay_6")

    local energy_level_trigger_low = 50
    local energy_level_trigger_high = 99

    local capacitor = peripheral.wrap("inductionPort_0")
    local energy = capacitor.getEnergy() / 2.5 -- Convert from Joules to RF/FE
    local energy_percentage = math.floor((capacitor.getEnergyFilledPercentage() * 100) + 0.5) -- Convert to percentage
    local energy_output = capacitor.getLastOutput() / 2.5 -- Convert from Joules to RF/FE
    local energy_input = capacitor.getLastInput() / 2.5 -- Convert from Joules to RF/FE
    local transfer_cap = capacitor.getTransferCap() / 2.5 -- Convert from Joules to RF/FE

    local water_valve = peripheral.wrap("redstone_relay_5")
    local turbine = peripheral.wrap("turbineValve_0")


    term.clear()
    term.setCursorPos(1, 2)
    print("Reactor Controller Running...")


    -- Scram control
    if coolant_percentage < 5 then
        reactor.scram()
        print("Coolant level critical!")
        print("Scramming reactor...")
        break
    elseif temperature > 700 then
        reactor.scram()
        print("Reactor overheating! Temp at " .. temperature .. "C")
        print("Scramming reactor...")
        break
    end


    -- Water valve control
    if coolant_percentage < 90 then
        water_valve.setOutput("back", false)
    elseif coolant_percentage > 99 then
        water_valve.setOutput("back", true)
    end

    -- Fuel production control
    if fuel_level < 90 then
        fuel_production.setOutput("top", true)
    elseif fuel_level > 99 then
        fuel_production.setOutput("top", false)
    end

    -- Burn rate management
    if energy_percentage > energy_level_trigger_high and actual_burn_rate and status == "online" then
        reactor.setBurnRate(0)
    elseif energy_percentage < energy_level_trigger_low and actual_burn_rate == 0 and status == "online" then
        reactor.setBurnRate(0.1)
    elseif energy_output > math.max(energy_input + 2000, 0) then
        reactor.setBurnRate(math.max(burn_rate + 0.1, 0))
    elseif energy_output < math.max(energy_input - 2000, 0) then
        reactor.setBurnRate(math.max(burn_rate - 0.1, 0))
    end

    sleep(0.5)
end

-- Keeps the terminal running after exiting the previous loop
while true do

    sleep(0.5)
end
