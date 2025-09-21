term.setCursorPos(1,1)
term.clear()
print("This is GPS host for Y-axis with ID " .. os.computerID())
shell.run("gps host 445 78 70")
