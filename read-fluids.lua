local monitor = peripheral.wrap("top")
local machine = peripheral.wrap("back")
monitor.setTextScale(0.8)
 
while true do
  local tanks = machine.tanks()
  local latex_tank = tanks[1]
  local water_tank = tanks[2]
  
  monitor.clear()
  monitor.setCursorPos(1, 1)
  
  monitor.write("Water:")
  monitor.setCursorPos(1, 2)
  monitor.write(textutils.serialise(water_tank.amount))
  monitor.write("/16000 mb")
  monitor.setCursorPos(1, 3)
  monitor.write(" ")
  monitor.setCursorPos(1, 4)
  monitor.write("Latex:")
  monitor.setCursorPos(1, 5)
  monitor.write(textutils.serialise(latex_tank.amount))
  monitor.write("/16000 mb")
  sleep(1)
end