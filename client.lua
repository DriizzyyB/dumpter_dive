local QBCore = exports['qb-core']:GetCoreObject()
local diving = false

Citizen.CreateThread(function()
    for _, dumpster in ipairs(Config.Dumpsters) do
        exports['qb-target']:AddBoxZone('dumpster_' .. _, vector3(dumpster.x, dumpster.y, dumpster.z), 1, 1, {
            name = 'dumpster_' .. _,
            heading = 0,
            debugPoly = false,
            minZ = dumpster.z - 1.0,
            maxZ = dumpster.z + 1.0
        }, {
            options = {
                {
                    type = "client",
                    event = "qb-dumpsterdive:client:tryDive",
                    icon = "fas fa-dumpster",
                    label = "Dumpster Dive"
                }
            },
            distance = 2.0
        })
    end
end)

RegisterNetEvent('qb-dumpsterdive:client:tryDive', function()
    if not diving then
        diving = true
        QBCore.Functions.Progressbar("dumpster_dive", "Dumpster Diving...", 5000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true
        }, {}, {}, {}, function() -- Done
            TriggerServerEvent('qb-dumpsterdive:server:dumpsterDive')
            diving = false
        end, function() -- Cancel
            QBCore.Functions.Notify("Cancelled", "error")
            diving = false
        end)
    end
end)
