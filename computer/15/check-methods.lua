local reactor2 = peripheral.getMethods("fissionReactorLogicAdapter_1")

for i, method in ipairs(reactor2) do
    print(method)
    if i % 10 == 0 then
        print("Press any key to continue...")
        os.pullEvent("key")
    end
end
