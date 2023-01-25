-- Check if player has goldpan
RegisterServerEvent("qrp_checkInventory")
AddEventHandler("qrp_checkInventory", function(itemName)
    local _source = source
    local xPlayer = QRPlayer.get(_source)
    local item = xPlayer.getInventoryItem(itemName)
    if item.count > 0 then
        hasGoldpan = true
    else
        hasGoldpan = false
    end
end)

-- Add gold to inventory
RegisterServerEvent("qrp_addInventoryItem")
AddEventHandler("qrp_addInventoryItem", function(itemName, itemCount)
    local _source = source
    local xPlayer = QRPlayer.get(_source)
    xPlayer.addInventoryItem(itemName, itemCount)
end)

-- Track number of pans
RegisterServerEvent("qrp_goldpan")
AddEventHandler("qrp_goldpan", function()
    local _source = source
    local xPlayer = QRPlayer.get(_source)
    local pans = xPlayer.get("goldpans")
    if pans == nil then
        pans = 0
    end

    if pans >= 10 then
        -- Check distance from last panning location
        local lastPosition = xPlayer.get("lastGoldpan")
        local currentPosition = xPlayer.getCoords()
        local distance = GetDistanceBetweenCoords(lastPosition.x, lastPosition.y, lastPosition.z, currentPosition.x, currentPosition.y, currentPosition.z, true)
        if distance < 5 then
            -- Too close to last panning location
            TriggerClientEvent("qrp_goldpan:tooClose", _source)
            return
        end
    end

    pans = pans + 1
    xPlayer.set("goldpans", pans)
    xPlayer.set("lastGoldpan", xPlayer.getCoords())
end)

