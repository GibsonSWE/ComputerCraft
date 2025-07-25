local ap_module = {}
local x, y, z = gps.locate()
direction = 0 -- Make direction a global variable

-- Helper function to get the current direction
function ap_module.getDirection()
    print("Determining initial direction...")
    local x1, y1, z1 = gps.locate()
    if not x1 then
        error("No GPS signal")
    end

    while not turtle.forward() do
        print("Failed to move forward, turning.") 
        turtle.turnRight()
    end

    local x2, y2, z2 = gps.locate()
    print("Moving back to original position...")
    turtle.back()  -- return to original position

    if z2 < z1 then return 0
    elseif x2 > x1 then return 1
    elseif z2 > z1 then return 2
    elseif x2 < x1 then return 3 
    else return "unknown" end
end

-- Getter for direction
function ap_module.get_direction()
    return direction
end

-- Helper function to face a specific direction
-- Faces the turtle in the specified cardinal direction.
-- @param targetDirection (number): 0 = North, 1 = East, 2 = South, 3 = West.
function ap_module.face(targetDirection)
    if targetDirection == 0 then
        print("Turning North")
    elseif targetDirection == 1 then
        print("Turning East")
    elseif targetDirection == 2 then
        print("Turning South")
    elseif targetDirection == 3 then
        print("Turning West")
    else
        error("Invalid target direction: " .. tostring(targetDirection))
    end

    local diff = (targetDirection - direction) % 4
    if diff == 1 then
        turtle.turnRight()
        direction = (direction + 1) % 4
    elseif diff == 2 then
        turtle.turnRight()
        turtle.turnRight()
        direction = (direction + 2) % 4
    elseif diff == 3 then
        turtle.turnLeft()
        direction = (direction + 3) % 4
    end
end

-- Basic move forward + position tracking
function ap_module.forward()
    if turtle.getFuelLevel() < 1 then
        error("Not enough fuel to move forward")
    end

    if turtle.getFuelLevel() < 1000 then
        print("Fuel level low: " .. turtle.getFuelLevel())
    end

    if turtle.detect() then
        print("Obstacle detected, cannot move forward")
        return false
    end

    if turtle.forward() then
        if direction == 0 then z = z - 1
        elseif direction == 1 then x = x + 1
        elseif direction == 2 then z = z + 1
        elseif direction == 3 then x = x - 1 end
        return true
    else
        print("Failed to move forward")
        return false
    end
end

function ap_module.lateral(lateral_direction)
    if turtle.getFuelLevel() < 1 then
        error("Not enough fuel to move " .. lateral_direction)
    end

    if turtle.getFuelLevel() < 1000 then
        print("Fuel level low: " .. turtle.getFuelLevel())
    end

    if lateral_direction == "up" then
        if turtle.detectUp() then
            if not ap_module.forward() then
                print("Obstacle detected above, cannot move up")
                return false
            end
        else
            turtle.up()
            y = y + 1
            return true
        end
    elseif lateral_direction == "down" then
        if turtle.detectDown() then
            if not ap_module.forward() then
                print("Obstacle detected below, cannot move down")
                return false
            end
        else 
            turtle.down()
            y = y - 1
            return true
        end
    end
    return false
end

-- Go to a specific (x, y, z) coordinate (horizontal movement only for now)
function ap_module.go_to(tx, ty, tz, travel_level)
    local cx, cy, cz = gps.locate()
    if not cx then
        error("No GPS signal")
    end

    -- Current position
    x, y, z = gps.locate()
    print("Current position: X=" .. x .. ", Y=" .. y .. ", Z=" .. z)

    -- Current direction
    direction = ap_module.getDirection() -- 0: North, 1: East, 2: South, 3: West
    if direction == "unknown" then
        error("Could not determine initial direction")
    elseif direction == 0 then
        print("Facing North")
    elseif direction == 1 then
        print("Facing East")
    elseif direction == 2 then
        print("Facing South")
    elseif direction == 3 then
        print("Facing West")
    else
        error("Invalid direction: " .. tostring(direction))
    end

    -- Y movement (up to travel level)
    while cy < travel_level do
        if ap_module.lateral("up") then cy = cy + 1 end
        print("Moving up to Y(" .. travel_level .. "): " .. cy)
    end
    
    -- X axis
    if tx > cx then ap_module.face(1) -- east
        while cx < tx do
            if ap_module.forward() then cx = cx + 1 end
            print("Moving east to X(" .. tx .. "): " .. cx)
        end
    elseif tx < cx then ap_module.face(3) -- west
        while cx > tx do
            if ap_module.forward() then cx = cx - 1 end
            print("Moving west to X(" .. tx .. "): " .. cx)
        end
    end
    
    -- Z axis
    if tz > cz then ap_module.face(2) -- south
        local attempts = 0
        while cz < tz do
            if ap_module.forward() then 
                cz = cz + 1 
                attempts = 0 -- Reset attempts on successful move
            else
                attempts = attempts + 1
                if attempts > 10 then
                    error("Failed to move south to Z(" .. tz .. ") after multiple attempts")
                end
            end
            print("Moving south to Z(" .. tz .. "): " .. cz)
        end
    elseif tz < cz then ap_module.face(0) -- north
        local attempts = 0
        while cz > tz do
            if ap_module.forward() then 
                cz = cz - 1 
                attempts = 0 -- Reset attempts on successful move
            else
                attempts = attempts + 1
                if attempts > 10 then
                    error("Failed to move north to Z(" .. tz .. ") after multiple attempts")
                end
            end
            print("Moving north to Z(" .. tz .. "): " .. cz)
        end
    end

    -- Y movement (down to target level)
    while cy > ty do
        if ap_module.lateral("down") then cy = cy - 1 end
        print("Moving down to Y(" .. ty .. "): " .. cy)
    end
    if cy < ty then
        error("Failed to reach target Y(" .. ty .. "), current Y: " .. cy)
    end
    print("Reached target coordinates: X=" .. cx .. ", Y=" .. cy .. ", Z=" .. cz)
end

return ap_module
