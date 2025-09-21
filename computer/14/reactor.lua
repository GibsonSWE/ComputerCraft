local screen_width, screen_height = term.getSize()
rednet.open("back")


function formatNumber(num)
    if num >= 1e9 then
        return string.format("%.2f G", num / 1e9)
    elseif num >= 1e6 then
        return string.format("%.2f M", num / 1e6)
    elseif num >= 1e3 then
        return string.format("%.2f K", num / 1e3)
    else
        return tostring(num)
    end
end


while true do
    local sender_id, message = rednet.receive()

    if type(message) == "table" and message.damage ~= nil then
        local status = message.reactor_status or "UNKNOWN"
        local damage = message.damage or "UNKNOWN"
        local burn_rate = message.burn_rate or "UNKNOWN"
        local actual_burn_rate = message.actual_burn_rate or "UNKNOWN"
        local temperature = message.temperature or "UNKNOWN"
        local heating_rate = message.heating_rate or "UNKNOWN"
        local fuel_level = message.fuel_level or "UNKNOWN"
        local waste_percentage = message.waste_percentage or "UNKNOWN"
        local coolant_percentage = message.coolant_percentage or "UNKNOWN"
        local water_tank_percentage = message.water_tank_percentage or "UNKNOWN"
        local water_valve_status = message.water_valve_status or "UNKNOWN"
        local fuel_production = message.fuel_production or "UNKNOWN"
        
        
        term.clear()
        term.setCursorPos(1, 2)
        term.write("Reactor Monitor")
        print()
        print("Status: " .. (tostring(status) == "true" and "ONLINE" or "OFFLINE"))
        print("Temperature: " .. string.format("%.1fC", temperature))
        print("Damage: " .. damage .. "%")
        print()
        print("Set Burn Rate: " .. burn_rate .. "%")
        print("Actual Burn Rate: " .. actual_burn_rate .. "%")
        print("Heating Rate: " .. heating_rate .. " mB/t")
        print("Fuel Level: " .. fuel_level .. "%")
        print("Coolant: " .. coolant_percentage .. "%")
        print("Water Tank: " .. water_tank_percentage .. "%")
        print("Waste: " .. waste_percentage .. "%")
        print()
        print("Water Valve: " .. water_valve_status)
        print("Fuel Production: " .. fuel_production)
        sleep(0.2)
    end
end
