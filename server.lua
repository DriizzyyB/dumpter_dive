local QBCore = exports['qb-core']:GetCoreObject()
local playerCooldowns = {}

RegisterNetEvent('qb-dumpsterdive:server:dumpsterDive')
AddEventHandler('qb-dumpsterdive:server:dumpsterDive', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local playerId = Player.PlayerData.citizenid

    if playerCooldowns[playerId] and (os.time() - playerCooldowns[playerId]) < Config.Cooldown then
        TriggerClientEvent('QBCore:Notify', src, 'You need to wait before diving again.', 'error')
        return
    end

    playerCooldowns[playerId] = os.time()
    local loot = GetRandomLoot()
    
    if loot then
        Player.Functions.AddItem(loot, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[loot], 'add')
        TriggerClientEvent('QBCore:Notify', src, 'You found ' .. loot .. '!', 'success')
    else
        TriggerClientEvent('QBCore:Notify', src, 'You found nothing.', 'error')
    end
end)

function GetRandomLoot()
    local totalChance = 0
    for _, item in ipairs(Config.Loot) do
        totalChance = totalChance + item.chance
    end

    local randomChance = math.random(totalChance)
    local cumulativeChance = 0

    for _, item in ipairs(Config.Loot) do
        cumulativeChance = cumulativeChance + item.chance
        if randomChance <= cumulativeChance then
            return item.item
        end
    end

    return nil
end
