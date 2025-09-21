local pump = peripheral.wrap("redstone_relay_1")
local generator = peripheral.wrap("redstone_relay_2")
local water_tank = peripheral.wrap("railcraft:steel_tank_0")
local dynamic_tank = peripheral.wrap("dynamicValve_0")
local battery = peripheral.wrap("inductionPort_0")

--for _, name in ipairs(peripheral.getNames()) do
--    print(name, peripheral.getType(name))
--end

local battery_methods = peripheral.getMethods("inductionPort_0")
print(textutils.serialise(battery_methods))

for i, method in ipairs(battery_methods) do
    print(method)
    if i % 10 == 0 then
        print("Press any key to continue...")
        os.pullEvent("key")
    end
end

local tank_width = dynamic_tank.getWidth()
local tank_height = dynamic_tank.getHeight()
local tank_length = dynamic_tank.getLength()
local internal_volume = (tank_width - 2) * (tank_height - 2) * (tank_length - 2)
local expected_capacity = internal_volume * 16000

--print("Width: " .. tank_width)
--print("Height: " .. tank_height)
--print("Length: " .. tank_length)
--print("Expected: " .. expected_capacity)
--print("Reported: " .. dynamic_tank.getTankCapacity())

--print(dynamic_tank.getFilledPercentage())
--local stored = dynamic_tank.getStored()
--print(textutils.serialise(stored))

--for _, i in ipairs(battery.getInputItem()) do
--    print(i)
--end

--while true do
--  pump.setOutput("right", true)
--  os.sleep(1)
--  pump.setOutput("right", false)
--  os.sleep(1)
--end

--local tank_size = dynamic_tank.size()
--local tank_list = dynamic_tank.list()
--local tank_tanks = dynamic_tank.tanks()
--local tank_detail = dynamic_tank.getItemDetail(2)

--print(peripheral.getType("dynamicValve_0"))
print(textutils.serialise(battery.getLastOutput()))

--print(textutils.serialise(peripheral.getMethods("mekanism:dynamic_tank_0")))
--print(tank_size)
--print(textutils.serialise(tank_list))
--print(textutils.serialise(tank_tanks))

--for i, fluid in ipairs(dynamic_tank) do
--  print("Fluid #" .. i)
--  print("Name: " .. (fluid.name or "none"))
--  print("Amount: " .. (fluid.amount or 0))
--  print("Capacity: " .. (fluid.capacity or "unknown"))
--end

--print(tank_detail)
--print(textutils.serialise(peripheral.getMethods("redstone_relay_1")))
--print(textutils.serialise(peripheral.getMethods("redstone_relay_2")))
--print(textutils.serialise(peripheral.getMethods("railcraft:steel_tank_0")))
--print(textutils.serialise(water_tank.tanks()))
