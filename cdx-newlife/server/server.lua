RegisterNetEvent('cdx-newlife:revivePlayer')
AddEventHandler('cdx-newlife:revivePlayer', function(coords)
    local player = source
    if player then
        TriggerClientEvent('frp-ambulance:client:staffrevive:player', player) -- Revive trigger maak ticket aan indien je het zelf niet kan aanpassen
        TriggerClientEvent('cdx-newlife:teleportPlayer', player, coords)
    end
end)