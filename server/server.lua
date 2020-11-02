RegisterServerEvent('hunterwagon:teleportentitysv')
AddEventHandler('hunterwagon:teleportentitysv', function(ent, x, y, z) 
    nent = NetworkGetEntityFromNetworkId(ent)

    TriggerClientEvent('hunterwagon:teleportentitycl', -1, ent, x, y, z)
end)