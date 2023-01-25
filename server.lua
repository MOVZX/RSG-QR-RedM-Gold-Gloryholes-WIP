local config = require("config") -- import the config file
local mysql = exports.ox_mysql -- import the ox_mysql library

-- Function to connect to the rsgcoredb
function connectToDB()
    mysql:connect({
        host = config.db.host,
        user = config.db.user,
        password = config.db.password,
        database = config.db.database
    })
end

-- Function to get player data from the database
function getPlayerData(player)
    local data = {}
    mysql:query("SELECT * FROM players WHERE player_id = @player_id", {
        ['@player_id'] = player
    }, function(result)
        if #result > 0 then
            data = result[1]
        end
    end)
    return data
end

-- Function to handle the gold panning event
AddEventHandler("goldpan:use", function(player)
    local playerData = getPlayerData(player)
    if playerData.goldpan and isValidLocation(playerData.last_panning_location) and hasMovedFarEnough(playerData.last_panning_location) then
        local item = getRandomItem()
        playerData.items_found = playerData.items_found + item.count
        playerData.last_panning_location = GetEntityCoords(player)
        mysql:execute("UPDATE players SET items_found = @
items_found, last_panning_location = @last_panning_location WHERE player_id = @player_id", {
            ['@items_found'] = playerData.items_found,
            ['@last_panning_location'] = json.encode(playerData.last_panning_location),
            ['@player_id'] = player
        })
        TriggerClientEvent("goldpan:found", player, item)
    else
        -- Send a message to the client if the player is not allowed to pan for gold
    end
end)

-- Function to check if the location is valid
function isValidLocation(location)
    -- Check if the location is valid by comparing it against a list of valid locations
    -- in the config file and return true if it is a valid location, false otherwise
end

-- Function to check if the player has moved far enough
function hasMovedFarEnough(lastLocation)
    -- Check if the player has moved more than 10m away from their last panning location
    -- and return true if they have, false otherwise
end

-- Register the connectToDB function to be called on resource start
AddEventHandler("onResourceStart", connectToDB)
