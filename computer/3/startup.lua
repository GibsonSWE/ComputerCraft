term.setCursorPos(1,1)
term.clear()
print("This is GPS host for X-axis with ID " .. os.getComputerID())
shell.run("gps host 450 83 70") -- Set GPS coordinates for the GPS host
