local fuel_monitor_id = 0 -- ID of the fuel monitor system
rednet.open("left")

while true do
    -- Send the current fuel level to the fuel monitor system
    rednet.send(fuel_monitor_id, turtle.getFuelLevel())
    sleep(5) -- Wait for 5 seconds before sending the next update
end
