term.setCursorPos(1,1)
term.clear()
print("This is GPS host North with ID " .. os.getComputerID())
shell.run("gps host 403 88 85") -- Set GPS coordinates for the GPS host
