rednet.open("back")
local status_monitor = peripheral.wrap("left")
local mon_width, mon_height = status_monitor.getSize()
term.clear()
term.setCursorPos(1, 1)
print("Running Turtle Monitor...")


-- Set up the fuel monitor
status_monitor.setTextScale(0.8)
status_monitor.clear()

status_monitor.setCursorPos(1, 1)
status_monitor.write("Status:")
status_monitor.setCursorPos(1, 5)
status_monitor.write("Fuel:")
status_monitor.setCursorPos(1, 6)
status_monitor.write("Row:")
status_monitor.setCursorPos(1, 7)
status_monitor.write("Level:")


function wrapText(text, width)
    local lines = {}
    while #text > 0 do
        if #text <= width then
            table.insert(lines, text)
            break
        end
        local line = text:sub(1, width)
        local last_space = line:match(".*()%s+")
        if last_space then
            line = text:sub(1, last_space - 1)
            table.insert(lines, line)
            text = text:sub(last_space + 1)
        else
            table.insert(lines, line)
            text = text:sub(width + 1)
        end
    end
    return lines
end

function write_status(message, start_line)
    local wrapped = wrapText(message.message, mon_width)
    for i = 1, 2 do
        local line = wrapped[i] or ""
        status_monitor.setCursorPos(1, i + start_line - 1)
        status_monitor.clearLine()
        status_monitor.write(line)
    end
end

while true do
    local sender_id, message=rednet.receive()
    if message.type == "status-update" then
        -- Update the status monitor with the received message
        write_status(message, 2)
    elseif message.type == "fuel_level" then
        -- Update the fuel monitor with the current fuel level
        status_monitor.setCursorPos(1, 5)
        status_monitor.clearLine(5)
        status_monitor.write("Fuel: " .. textutils.serialise(message.message))
    elseif message.type == "row-count" then
        -- Update the status monitor with the row count
        status_monitor.setCursorPos(1, 6)
        status_monitor.clearLine(6)
        status_monitor.write("Row: " .. textutils.serialise(message.message) .. "/60")
    elseif message.type == "level" then
        -- Update the status monitor with the current level
        status_monitor.setCursorPos(1, 7)
        status_monitor.clearLine(7)
        status_monitor.write("Level: " .. textutils.serialise(message.message))
    else
        -- Handle unexpected message types
        status_monitor.setCursorPos(1, 2)
        status_monitor.clearLine(2)
        status_monitor.clearLine(3)
        status_monitor.write("Unknown message type")
    end
end
