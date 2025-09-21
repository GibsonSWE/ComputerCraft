local peripherals = peripheral.getNames()

for i, peripheral in ipairs(peripherals) do
    print(peripheral)
    if i % 10 == 0 then
        print("Press any key to continue...")
        os.pullEvent("key")
    end
end
