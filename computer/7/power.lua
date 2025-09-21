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
    local energy = message.energy or 0
    local energy_percentage = message.energy_percentage or 0
    local energy_capacity = message.energy_capacity or 0
    local transfer_cap = message.transfer_cap or 0
    local energy_input = message.energy_input or 0
    local energy_output = message.energy_output or 0

    term.clear()
    term.setCursorPos(1, 2)
    term.write("Power Monitor")
    term.setCursorPos(1, 5)
    print("Charge: " .. formatNumber(energy) .. "FE (" .. energy_percentage .. "%)")
    term.setCursorPos(1, 6)
    print("Capacity: " .. formatNumber(energy_capacity) .. "FE")
    term.setCursorPos(1, 7)
    print("Transf Cap: " .. formatNumber(transfer_cap) .. "FE/t")
    term.setCursorPos(1, 8)
    print("Input Rate: " .. energy_input .. " FE/t")
    term.setCursorPos(1, 9)
    print("Output Rate: " .. energy_output .. " FE/t")
    sleep(0.5)
end
