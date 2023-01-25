local config = require("config") -- import the config file

-- Function to check if the player is crouched
function isCrouched()
    local player = GetPlayerPed(-1)
    return IsPedCrouching(player)
end

-- Function to check if the player is in a valid water location
function isValidWaterLocation()
    local player = GetPlayerPed(-1)
    local playerPos = GetEntityCoords(player)
    -- check if player is in a valid water location
    -- you should replace this with your own check
    return isWater(playerPos.x, playerPos.y, playerPos.z)
end

-- Function to check if another player is within 10m
function isPlayerNear()
    local player = GetPlayerPed(-1)
    local playerPos = GetEntityCoords(player)
    local players = GetPlayers()
    for _, playerId in ipairs(players) do
        if playerId ~= PlayerId() then
            local otherPlayer = GetPlayerPed(playerId)
            local otherPlayerPos = GetEntityCoords(otherPlayer)
            local distance = Vdist(playerPos.x, playerPos.y, playerPos.z, otherPlayerPos.x, otherPlayerPos.y, otherPlayerPos.z)
            if distance <= 10.0 then
                return true
            end
        end
    end
    return false
end

-- Function to start the gold panning animation
function startPanningAnimation()
    local player = GetPlayerPed(-1)
    RequestAnimDict("animation")
    while not HasAnimDictLoaded("animation") do
        Citizen.Wait(0)
    end
    TaskPlayAnim(player, "animation", "gold_panning", 8.0, -8, -1, 49, 0, 0, 0, 0)
    Citizen.Wait(config.panningTime)
    ClearPedTasks(player)
end

-- Function to get the random item
function getRandomItem()
    local totalWeight = 0
    local itemList = {}
    for item, weight in pairs(config.items) do
        totalWeight = totalWeight + weight
        itemList[totalWeight] = item
    end

    local randomWeight = math.random(1, totalWeight)
    for weight, item in pairs(itemList) do
        if weight >= randomWeight then
            return item
        end
    end
end

-- Function to handle the gold panning event
function goldPanningEvent()
    if isCrouched() and isValidWaterLocation() and not isPlayerNear() then
        startPanningAnimation()
        local item = getRandomItem()
        -- do something with the obtained item
    else
        if not isCrouched() then
            -- show notification to player that they need to crouch
        elseif not isValidWaterLocation() then
            -- show notification that the location is not valid
        else
        -- show notification that another player is too close
    end
end

-- Function to check if player needs to move
function checkMovement()
    -- check if player has found between 5 and 15 items
    -- check if player has moved at least 10m away
    -- if they haven't, show a notification and prevent them from panning
end

-- Function to check if player is in a gloryhole location
function checkGloryhole()
    -- check if player is in a gloryhole location
    -- if they are, show a notification and increase their chances of finding more than 1 item
end

-- Register the gold panning event to be triggered when the player uses the goldpan item
RegisterNetEvent("goldpan:use")
AddEventHandler("goldpan:use", goldPanningEvent)

-- Register the check movement event to be triggered periodically
Citizen.CreateThread(function()
    while true do
        checkMovement()
        checkGloryhole()
        Citizen.Wait(1000)
    end
end)
