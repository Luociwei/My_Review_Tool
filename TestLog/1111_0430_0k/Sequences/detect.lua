DEVICE_TRANSPORT_URL = {
    {detectionURL = {endpoint="tcp://169.254.1.32:7801",site=1}, commURL = "group11"},
    {detectionURL = {endpoint="tcp://169.254.1.32:7802",site=2}, commURL = "group12"},
    {detectionURL = {endpoint="tcp://169.254.1.32:7803",site=3}, commURL = "group13"},
    {detectionURL = {endpoint="tcp://169.254.1.32:7804",site=4}, commURL = "group14"}
}
function initDeviceDetection()
    
    local fixtureBuilder = Atlas.loadPlugin("FixturePlugin")
    local dataChannel = fixtureBuilder.createFixtureBuilder(0)

    for _,transport in ipairs(DEVICE_TRANSPORT_URL) do
        
        local detector = fixtureBuilder.createDeviceDetector(dataChannel,transport.commURL,1)
        Detection.addDeviceDetector(detector)
    end
end

function initDeviceRouting()
    local devRoutingFunc = function(url)
        local slots = Detection.slots()
        local groups = Detection.groups()
        print("initDeviceRouting" .. tostring("slot" .. tostring(tonumber(string.sub(url,-1))-1)))
        return "slot" .. tostring(tonumber(string.sub(url,-1))-1),tonumber(string.sub(url,-2,-2))
    end
    Detection.setDeviceRoutingCallback(devRoutingFunc)
end


function main()
    -- initDeviceDetection()
    initDeviceRouting()
    Detection.addDevice("group11")
    Detection.addDevice("group12")
    Detection.addDevice("group13")
    Detection.addDevice("group14")
end

-- function main()
-- Very simple static dispatch.
    -- use number in url for group and slot: group-slot
    -- for example:
    --    xxx-1-1: group 1, slot 1
    --    xxx-1-2: group 1, slot 2
--     Detection.addDevice("uart://fake-path-1-1")
--     Detection.addDevice("uart://fake-path-1-2")
--     Detection.addDevice("uart://fake-path-1-3")
--     Detection.addDevice("uart://fake-path-1-4")

--     local routingCallback = function(url)
--         local groups = Detection.groups()
--         local groupName = groups[1]
--         pattern = '([0-9]+)-([0-9]+)$'
--         group_index, slot_index = string.match(url, pattern)
--         group_index = tonumber(group_index)
--         slot_index = tonumber(slot_index)
--         slots = Detection.slots()
--         return slots[slot_index], groups[group_index]
--     end

--     Detection.setDeviceRoutingCallback(routingCallback)
-- end

