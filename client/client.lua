-- Werkt met ox_lib geen specifieke framework, dus zowel QBCORE & ESX

local respawnTimer = 0
local selectedLocation = nil
local menuOpenedWhileDead = false 
local isDead = false

function DrawTextOnScreen(text, x, y, scale)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextScale(scale, scale)
    SetTextColour(255, 255, 255, 255) 
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

Citizen.CreateThread(function()
    while true do
        Wait(500) 
        isDead = IsEntityDead(PlayerPedId()) 
        if not isDead then
            menuOpenedWhileDead = false 
        end
    end
end)

function OpenNewLifeMenu()
    if not isDead then
        lib.notify({
            title = 'Actie mislukt',
            description = 'Je kunt dit commando alleen gebruiken als je dood bent!',
            type = 'error'
        })
        return
    end

    if menuOpenedWhileDead then
        lib.notify({
            title = 'Actie mislukt',
            description = 'Je hebt al een respawnlocatie gekozen!',
            type = 'error'
        })
        return
    end

    menuOpenedWhileDead = true
    local menuOptions = {}

    for _, location in pairs(Config.RespawnLocations) do
        table.insert(menuOptions, {
            title = location.name,
            description = ("Respawn over %d minuten"):format(location.time),
            icon = 'fa-solid fa-location-dot',
            event = 'cdx-newlife:selectLocation',
            args = location 
        })
    end

    lib.registerContext({
        id = 'cdx_newlife',
        title = 'Waar wil je respawnen?',
        options = menuOptions
    })

    lib.showContext('cdx_newlife')
end

RegisterNetEvent('cdx-newlife:selectLocation')
AddEventHandler('cdx-newlife:selectLocation', function(location)
    selectedLocation = location
    respawnTimer = location.time * 60 
    TriggerEvent('cdx-newlife:respawnCountdown')
end)

RegisterNetEvent('cdx-newlife:respawnCountdown')
AddEventHandler('cdx-newlife:respawnCountdown', function()
    if not selectedLocation then return end

    lib.notify({
        title = 'Actie geslaagd',
        description = ('Je respawnt bij %s over %d minuten.'):format(selectedLocation.name, respawnTimer / 60),
        type = 'success'
    })

    Citizen.CreateThread(function()
        while respawnTimer > 0 do
            Wait(1000) 
            respawnTimer = respawnTimer - 1
        end
        TriggerServerEvent('cdx-newlife:revivePlayer', selectedLocation.coords)
    end)

    Citizen.CreateThread(function()
        while respawnTimer > 0 do
            DrawTextOnScreen(("Respawnen over %d seconden..."):format(respawnTimer), 0.015, 0.85, 0.5)
            Wait(0)
        end
    end)
end)

RegisterNetEvent('cdx-newlife:teleportPlayer')
AddEventHandler('cdx-newlife:teleportPlayer', function(coords)
    if coords then
        DoScreenFadeOut(1000)
        Wait(1500)
        SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, true)
        DoScreenFadeIn(1000)
    end
end)

RegisterCommand('newlife', function()
    OpenNewLifeMenu()
end, false)