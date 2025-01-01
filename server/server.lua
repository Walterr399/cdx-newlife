RegisterNetEvent('cdx-newlife:revivePlayer')
AddEventHandler('cdx-newlife:revivePlayer', function(coords)
    local player = source
    if player then
          TriggerClientEvent('esx_ambulancejob:revive', player) --  esx_ambulancejob
        --TriggerClientEvent('wasabi_ambulance:revivePlayer', player) -- Wasabi Framework revive triggera
        --TriggerClientEvent('frp-ambulance:client:staffrevive:player', player) -- Future ambulancejob
        --TriggerClientEvent('qb-ambulancejob:client:revive', player) QBCORE 
        TriggerClientEvent('cdx-newlife:teleportPlayer', player, coords)
    end
end)
