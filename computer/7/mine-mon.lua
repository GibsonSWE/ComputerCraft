local screen_width, screen_height = term.getSize()
rednet.open("back")

term.clear()
term.setCursorPos(1, 1)
term.write("Mining Turtle Monitor")
term.setCursorPos(1, 3)
term.write("Status:")
term.setCursorPos(1, 8)
term.write("Fuel: ")
term.setCursorPos(1, 9)
term.write("Row:")
term.setCursorPos(1, 10)
term.write("Level:")

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
    local wrapped = wrapText(message.message, screen_width - 2)
    for i = 1, 3 do
        local line = wrapped[i] or ""
        term.setCursorPos(1, i + start_line - 1)
        term.clearLine()
        term.write(line)
    end
end

while true do
    local sender_id, message=rednet.receive()
    if message.type == "status-update" then
        -- Update the status monitor with the received message
        write_status(message, 4)
    elseif message.type == "fuel_level" then
        -- Update the fuel monitor with the current fuel level
        term.setCursorPos(1, 8)
        term.clearLine(8)
        term.write("Fuel: " .. textutils.serialise(message.message))
    elseif message.type == "row-count" then
        -- Update the status monitor with the row count
        term.setCursorPos(1, 9)
        term.clearLine(9)
        term.write("Row: " .. textutils.serialise(message.message) .. "/60")
    elseif message.type == "level" then
        -- Update the status monitor with the current level
        term.setCursorPos(1, 10)
        term.clearLine(10)
        term.write("Level: " .. textutils.serialise(message.message))
    else
        -- Handle unexpected message types
        term.setCursorPos(1, 4)
        term.clearLine(4)
        term.write("Unknown message type")
    end
end
