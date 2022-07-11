ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler("playerConnecting", function()
    local source = source
    local name = GetPlayerName(source)

    TriggerClientEvent('xAdmin:co', -1, name)
end)

CreateThread(function()
    if GetCurrentResourceName() ~= "xAdmin" then
        os.exit()
    end
end)

AddEventHandler("playerDropped", function()
    local source = source
    local name = GetPlayerName(source)

    TriggerClientEvent('xAdmin:deco', -1, name)
end)

Citizen.CreateThread(function()
    while true do
        local xPlayers = ESX.GetPlayers()
        local playerscache = {}

        for _,v in pairs(xPlayers) do
            local xPlayer = ESX.GetPlayerFromId(v)
            local playerinfo = {
                id = v,
                money = xPlayer.getMoney(),
                name = xPlayer.getName(),
                job = xPlayer.job,
                job2 = xPlayer.job2,
            }
            table.insert(playerscache, playerinfo)
        end

        for i = 1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            for k,j in pairs(Admin.Acces.General) do
                if xPlayer.getGroup() == j then TriggerClientEvent('xAdmin:listplayer', xPlayers[i], playerscache) end
            end
        end
        Citizen.Wait(1000)
    end
end)

--- Xed#1188