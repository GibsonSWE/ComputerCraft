
function Load()
    for i = 1, 16 do
        turtle.select(i)
        turtle.suck()
    end
end

function Unload()
    for i = 1, 16 do
        turtle.select(i)
        turtle.drop()
    end
end

local distance = 10

turtle.turnLeft()
turtle.turnLeft()
for i = 1, distance do
    turtle.forward()
end
Load()
turtle.turnLeft()
turtle.turnLeft()
for i = 1, distance do
    turtle.forward()
end
Unload()
