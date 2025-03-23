local isHandcuffed = false
local inVehicle = false
local currentVehicle = nil

-- RageUI Menu
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(0, 51) then -- Open menu with "E" key
            OpenPoliceMenu()
        end
    end
end)

function OpenPoliceMenu()
    RageUI.CloseAll()
    RageUI.Visible(RMenu:Get('police', 'main'), true)
end

RMenu.Add('police', 'main', RageUI.CreateMenu("Police Job", "Main Menu"))
RMenu.Add('police', 'handcuff', RageUI.CreateSubMenu(RMenu:Get('police', 'main'), "Handcuff", "Handcuff Options"))
RMenu.Add('police', 'vehicle', RageUI.CreateSubMenu(RMenu:Get('police', 'main'), "Vehicle", "Vehicle Options")

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        RageUI.IsVisible(RMenu:Get('police', 'main'), true, true, true, function()
            RageUI.Button("Handcuff Person", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('police:handcuff', GetPlayerServerId(PlayerId()))
                end
            end)

            RageUI.Button("Put in Vehicle", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('police:putInVehicle', GetPlayerServerId(PlayerId()))
                end
            end)

            RageUI.Button("Take out of Vehicle", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('police:takeOutOfVehicle', GetPlayerServerId(PlayerId()))
                end
            end)

            RageUI.Button("Search Person", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('police:search', GetPlayerServerId(PlayerId()))
                end
            end)

            RageUI.Button("Impound Vehicle", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('police:impound', GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false)))
                end
            end)
        end, function()
        end)
    end
end)

-- Handcuff Animation
function HandcuffAnimation()
    RequestAnimDict("mp_arresting")
    while not HasAnimDictLoaded("mp_arresting") do
        Citizen.Wait(100)
    end
    TaskPlayAnim(PlayerPedId(), "mp_arresting", "idle", 8.0, -8.0, -1, 49, 0, false, false, false)
end

-- Events
RegisterNetEvent('police:handcuff')
AddEventHandler('police:handcuff', function()
    isHandcuffed = not isHandcuffed
    if isHandcuffed then
        HandcuffAnimation()
    else
        ClearPedTasks(PlayerPedId())
    end
end)

RegisterNetEvent('police:putInVehicle')
AddEventHandler('police:putInVehicle', function()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    if DoesEntityExist(vehicle) then
        TaskWarpPedIntoVehicle(playerPed, vehicle, 2) -- Seat 2 (rear right)
    end
end)

RegisterNetEvent('police:takeOutOfVehicle')
AddEventHandler('police:takeOutOfVehicle', function()
    local playerPed = PlayerPedId()
    ClearPedTasksImmediately(playerPed)
end)

RegisterNetEvent('police:search')
AddEventHandler('police:search', function()
    -- Add search logic here
    TriggerEvent('chat:addMessage', {
        color = { 255, 0, 0},
        multiline = true,
        args = {"Police", "You have been searched."}
    })
end)

RegisterNetEvent('police:impound')
AddEventHandler('police:impound', function(plate)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if DoesEntityExist(vehicle) then
        SetEntityAsMissionEntity(vehicle, true, true)
        DeleteVehicle(vehicle)
        TriggerEvent('chat:addMessage', {
            color = { 255, 0, 0},
            multiline = true,
            args = {"Police", "Vehicle with plate " .. plate .. " has been impounded."}
        })
    end
end)