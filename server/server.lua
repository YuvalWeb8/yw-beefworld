local QBCore = exports['qb-core']:GetCoreObject()


-- Callbacks
lib.callback.register('yw-beefworld:getGang', function(source, GangScript)
    if GangScript == 'core-gangs' then
        return exports.core_gangs:getOrganization(QBCore.Functions.GetPlayer(source).PlayerData.citizenid)
    elseif GangScript == 'qb-core' then
        return QBCore.Functions.GetPlayer(source).PlayerData.gang
    end
end)


-- TriggerEvent
RegisterNetEvent('yw-beefworld:ChangeLobby', function(lobby)
    if Config.ClearInventory then
        exports.ox_inventory:ClearInventory(source, nil)
    end

    if lobby == "default" then
        SetPlayerRoutingBucket(source, Config.DefaultBucket)
    elseif lobby == "beefworld" then
        SetPlayerRoutingBucket(source, Config.BeefWorldBucket)
    end
end)