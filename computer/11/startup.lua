term.setCursorPos(1,1)
term.clear()
print("This is GPS host Center with ID " .. os.getComputerID())
shell.run("gps host 445 83 70") -- Set GPS coordinates for the GPS host
