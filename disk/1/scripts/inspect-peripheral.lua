local machine = peripheral.wrap("back")
local tanks = machine.tanks()
local latex_tank = textutils.serialise(tanks[1])
local water_tank = textutils.serialise(tanks[2])

print(water_tank.amount)
print(latex_tank.amount)
print(textutils.serialise(tanks[1].amount))
