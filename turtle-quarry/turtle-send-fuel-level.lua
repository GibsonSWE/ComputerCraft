local status_monitor_ids = {4, 7} -- ID of the mining monitor system (4) and personal tablet (7)
rednet.open("left")

while true do
    -- Send the current fuel level to the fuel monitor system
    for _, id in ipairs(status_monitor_ids) do
        rednet.send(id, {type = "fuel_level", message = turtle.getFuelLevel()})
    end
    sleep(5) -- Wait for 5 seconds before sending the next update
end
