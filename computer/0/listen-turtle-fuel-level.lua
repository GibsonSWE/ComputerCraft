rednet.open("top")

while true do
    local sender_id, message= rednet.receive()
    print("Received message: " .. message)
end
