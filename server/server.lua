local QBCore = exports ['qd-core']:GetCoreObject() -- if your using QBcore framework

-- Handcufs
RegisterServerEvent('police:handcuff')
AddEventHandler('police:handcuff', function(targetId)
    TriggerClientEvent('police:handcuff', targetId)
end)

-- Put in a vehicule 
RegisterServerEvent('police:putInVehicule')
AddEventHandler('police:putInVehicule', function(targetId)
    TriggerServerEvent('police:putInVehicule', targetID)
end)

-- Search a person
RegisterServerEvent('police:search')
AddEventHandler('police:search', function(targetId)
end)

-- Impound
RegisterServerEvent('police:impound')
AddEventHandler('police:impound', function(plate)
    local src = source 
    local vehicule = GetVehiculeInPedIsIn(GetPlayerPed(src), false)
    if DoesEntityExist(vehicule) then
        -- add loginc to save inmpoud record tp sql database
        TriggerClientEven('police:impound', src, plate)
    end
end)  