local goldpan = false
local goldpanBlip
local goldpanTimer

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local player = PlayerPedId()
        local playerCoords = GetEntityCoords(player)

        -- Check if player is in a designated gloryhole
        for i,v in ipairs(Config.Gloryholes) do
            if(Vdist(playerCoords.x, playerCoords.y, playerCoords.z, v.x, v.y, v.z) < 5.0)then
                if goldpan then
                    -- Stop panning
                    goldpan = false
                    ClearPedTasks(player)
                    goldpanBlip = nil
                    goldpanTimer = nil
                else
                    -- Check if player has goldpan
                    local hasGoldpan = false
                    TriggerServerEvent("qrp_checkInventory", "goldpan")
                    Citizen.Wait(2000)
                    if hasGoldpan then
                        goldpan = true
                        goldpanBlip = AddBlipForCoord(v.x, v.y, v.z)
                        SetBlipSprite(goldpanBlip,  501)
                        SetBlipColour(goldpanBlip,  2)
                        SetBlipAsShortRange(goldpanBlip,  true)
                        BeginTextCommandSetBlipName("STRING")
                        AddTextComponentString("Gold Mining Gloryhole")
                        EndTextCommandSetBlipName(goldpanBlip)
                        TaskStartScenarioInPlace(player, "WORLD_HUMAN_GOLD_PAN_ARMED", 0, true)
                        goldpanTimer = Config.GoldpanTime
                    else
                        exports['mythic_notify']:SendAlert('error', 'You dont have a goldpan')
                    end
                end
            end
        end

        if goldpan then
            -- Panning animation
            TaskPlayAnim(player, "anim@arena@celeb@flat@paired@no_props@", "pan_loop", 8.0, -8.0, -1, 1, 0, false, false, false)
            if goldpanTimer <= 0 then
                -- End panning
                goldpan = false
                ClearPedTasks(player)
                goldpanBlip = nil
                goldpanTimer = nil
                exports['mythic_notify']:SendAlert('inform', 'You found some gold')
                -- Add gold to inventory
                TriggerServerEvent("qrp_addInventoryItem", "gold", 1)
                -- Update chance of finding extra items
                local chance = math.random(1, 100)
                if chance <= Config.ExtraItemChance then
                    local item = Config.ExtraItems[math.random(1, #Config.ExtraItems)]
                    TriggerServerEvent("qrp_addInventoryItem", item.name, item.count)
                    exports['mythic_notify']:SendAlert('inform', 'You also found '..item.count..' '..item.name)
                end
            else
                goldpanTimer - 1
                Citizen.Wait(1000)
            end
        end
    end
end)
