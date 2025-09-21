local autopilot = require("autopilot")

local refuel_limit = 500 -- Minimum fuel level before refueling
local mining_width = 60 -- Width of the mining area in blocks
local mining_depth = -60 -- Depth of the mining area in blocks
local travel_level = 70 -- The level at which the turtle will travel to and from refuel and unload stations
local refuel_x, refuel_y, refuel_z = 540, 68, -197 -- Coordinates for the refuel station
local unload_x, unload_y, unload_z = 540, 68, -200 -- Coordinates for the unload station

local starting_x, starting_y, starting_z = gps.locate()
local x, y, z = gps.locate()
local status_monitor_ids = {4, 7} -- ID of the mining monitor system (4) and personal tablet (7)
rednet.open("left")


function send_status(msg)
    for _, id in ipairs(status_monitor_ids) do
        rednet.send(id, msg)
    end
end


function initialize()
    send_status({type = "status-update", message = "Initializing..."})
    print("Initializing...")
    shell.run("bg turtle-send-fuel-level") -- Start the fuel level sender in the background

    local x1, y1, z1 = gps.locate()
    if not x1 then
        send_status({type = "error", message = "No GPS signal"})
        error("No GPS signal")
    end

    direction = autopilot.getDirection()

    send_status({type = "status-update", message = "Turning to face south..."})
    print("Turning to face south...")
    if direction == 0 then
        turtle.turnLeft()
        turtle.turnLeft() -- Turn around from North to face South
        direction = 2 -- Set direction to South
        return
    elseif direction == 1 then
        turtle.turnRight() -- Turn from East to face South
        direction = 2 -- Set direction to South
        return
    elseif direction == 2 then
        return
    elseif direction == 3 then
        turtle.turnLeft() -- Turn from West to face South
        direction = 2 -- Set direction to South
        return
    else return "unknown" end
end

function z_movement()
    while z_count < mining_width do
        if turtle.detect() then
            if not check_inventory() then
                print("Inventory is full, moving to unload items...")
                if not unload() then
                    send_status({type = "status-update", message = "Drop-off failed, unable to unload."})
                    print("Drop-off failed, unable to unload.")
                    return false
                else
                    send_status({type = "status-update", message = "Continuing mining..."})
                    print("Continuing mining...")
                end
            end
            if not turtle.dig() then
                x, y, z = gps.locate()
                send_status({type = "status-update", message = "Failed to dig at Z: " .. x .. ", Y: " .. y .. ", Z: " .. z})
                print("Failed to dig at Z: " .. x .. ", Y: " .. y .. ", Z: " .. z)
                return false
            end
        end


        if not check_fuel() then
            if not refuel() then
                send_status({type = "status-update", message = "Refuel failed, unable to continue mining."})
                print("Refuel failed, unable to continue mining.")
                return false
            end
        end
        if turtle.forward() then
            if direction == 2 then
                z = z + 1
                z_count = z_count + 1
            elseif direction == 0 then
                z = z - 1
                z_count = z_count + 1
            end
        else
            x, y, z = gps.locate()
            send_status({type = "status-update", message = "Failed to move forward at Z: " .. x .. ", Y: " .. y .. ", Z: " .. z})
            print("Failed to move forward at Z: " .. x .. ", Y: " .. y .. ", Z: " .. z)
            return false
        end
    end
    return true
end


function check_inventory()
    for slot = 1, 16 do
        if turtle.getItemCount(slot) == 0 then
            return true -- Found empty slot
        end
    end
    return false -- All slots have something
end


function check_fuel()
    local fuel_level = turtle.getFuelLevel()
    if fuel_level < refuel_limit then return false end
    return true
end


function refuel()
    local mine_x, mine_y, mine_z = gps.locate()
    local mine_direction = direction
    send_status({type = "status-update", message = "Moving to refuel location..."})
    print("Moving to refuel location...")
    autopilot.go_to(refuel_x, refuel_y, refuel_z, travel_level)
    x, y, z = gps.locate()
    direction = autopilot.get_direction()

    -- Check if the turtle has enough inventory space before refueling
    if not check_inventory() then
        -- Attempt to unload items before refueling
        send_status({type = "status-update", message = "Inventory is full, unloading items..."})
        print("Inventory is full, unloading items...")
        if not unload() then return false end

        -- After unloading, return to refuel location
        send_status({type = "status-update", message = "Returning to refuel location..."})
        print("Returning to refuel location...")
        autopilot.go_to(refuel_x, refuel_y, refuel_z, travel_level)
        x, y, z = gps.locate()
        direction = autopilot.get_direction()
    end

    send_status({type = "status-update", message = "Loading fuel..."})
    print("Loading fuel...")
    if not turtle.suckDown() then
        send_status({type = "status-update", message = "Failed to load fuel at coordinates: " .. refuel_x .. ", " .. refuel_y .. ", " .. refuel_z})
        print("Failed to load fuel at coordinates: " .. refuel_x .. ", " .. refuel_y .. ", " .. refuel_z)
        return false
    end

    for slot = 1, 16 do
        local detail = turtle.getItemDetail(slot)
        if detail and detail.name == "minecraft:coal" then
            turtle.select(slot)
            if turtle.refuel() then
                print("Refueled from slot " .. slot)
                break -- Exit loop after refueling
            else
                send_status({type = "error", message = "Failed to refuel at coordinates: " .. refuel_x .. ", " .. refuel_y .. ", " .. refuel_z})
                error("Failed to refuel at coordinates: " .. refuel_x .. ", " .. refuel_y .. ", " .. refuel_z)
            end
        end
    end

    send_status({type = "status-update", message = "Refueled successfully. Returning to mining position..."})
    print("Refueled successfully. Returning to mining position...")
    autopilot.go_to(mine_x, mine_y, mine_z, travel_level) -- Return to the mining position
    x, y, z = gps.locate()
    autopilot.face(mine_direction)
    direction = autopilot.get_direction()
    return true
end

function unload()
    local mine_x, mine_y, mine_z = gps.locate()
    local mine_direction = direction
    send_status({type = "status-update", message = "Moving to drop-off location..."})
    print("Moving to drop-off location...")
    autopilot.go_to(unload_x, unload_y, unload_z, travel_level)
    x, y, z = gps.locate()
    direction = autopilot.get_direction()

    -- Check if there is a chest below to unload items
    local success, data = turtle.inspectDown()
    if not success or not (data and data.name == "minecraft:chest") then
        send_status({type = "status-update", message = "No chest below to unload items."})
        print("No chest below to unload items.")
        return false
    else
        send_status({type = "status-update", message = "Unloading items..."})
        print("Unloading items...")
        for slot = 1, 16 do
            if turtle.getItemCount(slot) > 0 then
                turtle.select(slot)
                if not turtle.dropDown() then
                    send_status({type = "status-update", message = "Failed to unload item from slot " .. slot})
                    print("Failed to unload item from slot " .. slot)
                    return false
                end
            end
        end
    end
    send_status({type = "status-update", message = "Unloaded successfully. Moving back to mining position..."})
    print("Unloaded successfully. Moving back to mining position...")
    autopilot.go_to(mine_x, mine_y, mine_z, travel_level) -- Return to the starting position
    x, y, z = gps.locate()
    autopilot.face(mine_direction)
    direction = autopilot.get_direction()
    return true
end


function mine_layer() 
    while true do
        send_status({type = "status-update", message = "Mining north to south..."})
        print("Mining north to south...")
        z_count = 0
        if not z_movement() then
            send_status({type = "status-update", message = "Failed to move in Z direction."})
            print("Failed to move in Z direction.")
            return false
        end
        row_count = row_count + 1
        send_status({type = "row-count", message = row_count})
        send_status({type = "level", message = y})
        print("Row count: " .. row_count)
        if row_count > mining_width then
            send_status({type = "status-update", message = "Reached the end of the layer."})
            print("Reached the end of the layer.")
            return true
        end

        send_status({type = "status-update", message = "Turning left to face north..."})
        print("Turning left to face north...")
        turtle.turnLeft()
        direction = 1 -- Set direction to East
        if turtle.detect() then
            if not check_inventory() then
                if not unload() then
                    send_status({type = "status-update", message = "Drop-off failed, unable to unload."})
                    print("Drop-off failed, unable to unload.")
                    return false
                else
                    send_status({type = "status-update", message = "Continuing mining south to north..."})
                    print("Continuing mining south to north...")
                end
            end
            if not turtle.dig() then
                x, y, z = gps.locate()
                send_status({type = "status-update", message = "Failed to dig at X: " .. x .. ", Y: " .. y .. ", Z: " .. z})
                print("Failed to dig at X: " .. x .. ", Y: " .. y .. ", Z: " .. z)
                return false
            end
        end
        
        if not check_fuel() then
            if not refuel() then return false end
        end
        if turtle.forward() then
            x = x + 1
        else
            x, y, z = gps.locate()
            send_status({type = "status-update", message = "Failed to move forward at X: " .. x .. ", Y: " .. y .. ", Z: " .. z})
            print("Failed to move forward at X: " .. x .. ", Y: " .. y .. ", Z: " .. z)
            return false
        end
        turtle.turnLeft()
        direction = 0 -- Set direction to North

        send_status({type = "status-update", message = "Mining south to north..."})
        print("Mining south to north...")
        z_count = 0
        if not z_movement() then
            send_status({type = "status-update", message = "Failed to move in Z direction."})
            print("Failed to move in Z direction.")
            return false 
        end
        row_count = row_count + 1
        send_status({type = "row-count", message = row_count})
        send_status({type = "level", message = y})
        print("Row count: " .. row_count)
        
        if row_count > mining_width then
            send_status({type = "status-update", message = "Reached the end of the layer."})
            print("Reached the end of the layer.")
            return true
        end

        send_status({type = "status-update", message = "Turning right to face south..."})
        print("Turning right to face south...")
        turtle.turnRight()
        direction = 1 -- Set direction to East
        if turtle.detect() then
            if not check_inventory() then
                if not unload() then 
                    send_status({type = "status-update", message = "Drop-off failed, unable to unload."})
                    print("Drop-off failed, unable to unload.")
                    return false
                else
                    send_status({type = "status-update", message = "Continuing mining north to south..."})
                    print("Continuing mining north to south...")
                end
            end
            if not turtle.dig() then
                x, y, z = gps.locate()
                send_status({type = "status-update", message = "Failed to dig at X: " .. x .. ", Y: " .. y .. ", Z: " .. z})
                print("Failed to dig at X: " .. x .. ", Y: " .. y .. ", Z: " .. z)
                return false
            end
        end
        
        if not check_fuel() then
            if not refuel() then return false end
        end
        
        if turtle.forward() then
            x = x + 1
        else
            x, y, z = gps.locate()
            send_status({type = "status-update", message = "Failed to move forward at X: " .. x .. ", Y: " .. y .. ", Z: " .. z})
            print("Failed to move forward at X: " .. x .. ", Y: " .. y .. ", Z: " .. z)
            return false
        end
        turtle.turnRight()
        direction = 2 -- Set direction to South
    end
end


initialize() -- Ensure the turtle is facing the correct direction
while y > mining_depth do
    row_count = 1
    z_count = 0
    send_status({type = "status-update", message = "Starting mining layer at Y: " .. y})
    send_status({type = "level", message = y})
    send_status({type = "row-count", message = row_count})
    print("Starting mining layer " .. y)
    if not mine_layer() then return false end
    send_status({type = "status-update", message = "Returning to starting corner..."})
    send_status({type = "row-count", message = 1})
    print("Returning to starting corner...")
    autopilot.go_to(starting_x, y, starting_z, y) -- Return to the starting corner after each layer
    x, y, z = gps.locate()
    autopilot.face(2) -- Face South for the next layer
    direction = autopilot.get_direction()

    -- Start digging down to the next layer
    if turtle.detectDown() then
        if not check_inventory() then
            if not unload() then return false end
        end
        if not turtle.digDown() then -- Dig down to the next layer
            x, y, z = gps.locate()
            send_status({type = "status-update", message = "Failed to dig at X: " .. x .. ", Y: " .. y .. ", Z: " .. z})
            print("Failed to dig at X: " .. x .. ", Y: " .. y .. ", Z: " .. z)
            return false
        end
    end

    if not check_fuel() then
        if not refuel() then return false end
    end
    turtle.down() -- Move down to the next layer
    y = y - 1 -- Decrease the Y coordinate for the next layer
end
send_status({type = "status-update", message = "Mining completed."})
print("Mining completed.")
