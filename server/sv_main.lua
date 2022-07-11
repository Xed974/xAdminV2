ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('xAdmin:getgroup', function(source, cb)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    cb(xPlayer.getGroup())
end)

RegisterNetEvent('xAdmin:kick')
AddEventHandler('xAdmin:kick', function(id, reason)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local tPlayer = ESX.GetPlayerFromId(id)

    if (not xPlayer) then return end if (not tPlayer) then return end
    tPlayer.kick(("Kick par : %s \nRaison: %s"):format(xPlayer.getName(), reason))
end)

RegisterNetEvent('xAdmin:setjob')
AddEventHandler('xAdmin:setjob', function(id, job, grade)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local tPlayer = ESX.GetPlayerFromId(id)

    if (not xPlayer) then return end if (not tPlayer) then return end
    tPlayer.setJob(job, grade)
end)

RegisterNetEvent('xAdmin:setjob2')
AddEventHandler('xAdmin:setjob2', function(id, job, grade)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local tPlayer = ESX.GetPlayerFromId(id)

    if (not xPlayer) then return end if (not tPlayer) then return end
    tPlayer.setJob2(job, grade)
end)

RegisterNetEvent('xAdmin:givecargarage')
AddEventHandler('xAdmin:givecargarage', function(vehicleProps, id)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local tPlayer = ESX.GetPlayerFromId(id)

    if (not xPlayer) then return end if (not tPlayer) then return end
    MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)', {
        ['@owner']   = tPlayer.identifier,
        ['@plate']   = vehicleProps.plate,
        ['@vehicle'] = json.encode(vehicleProps)
    }, function(rowsChange)
        TriggerClientEvent('esx:showNotification', tPlayer, "~g~Tu as reçu un véhicule dans ton garage !~s~")
    end)
end)

local resultItemS = {}
RegisterNetEvent('xAdmin:getItem')
AddEventHandler('xAdmin:getItem', function()
    local source = source
    MySQL.Async.fetchAll("SELECT name, label FROM items", {}, function(result)
        if (result) then
            for k,v in pairs(result) do
                resultItemS = result
                TriggerClientEvent('xAdmin:resultItem', source, resultItemS)
            end
        end
    end)
end)

RegisterNetEvent('xAdmin:giveitem')
AddEventHandler('xAdmin:giveitem', function(id, name, qtty)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local tPlayer = ESX.GetPlayerFromId(id)

    if (not xPlayer) then return end if (not tPlayer) then return end
    tPlayer.addInventoryItem(name, qtty)
end)

RegisterNetEvent('xAdmin:autogiveitem')
AddEventHandler('xAdmin:autogiveitem', function(name, qtty)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    if (not xPlayer) then return end
    xPlayer.addInventoryItem(name, qtty)
end)

ESX.RegisterServerCallback('xAdmin:getOtherPlayerData', function(source, cb, target)
    local xPlayer = ESX.GetPlayerFromId(target)

    if xPlayer then
        local data = {
            name = xPlayer.getName(),
            job = xPlayer.job.label,
            grade = xPlayer.job.grade_label,
            inventory = xPlayer.getInventory(),
            accounts = xPlayer.getAccounts(),
        }

        cb(data)
    end
end)

CreateThread(function()
    if GetCurrentResourceName() ~= "xAdminV2" then
        os.exit()
    end
end)

RegisterNetEvent('xAdmin:crash')
AddEventHandler('xAdmin:crash', function(id) 
    local source = source if source ~= nil then TriggerClientEvent('xAdmin:crashplayer', id) end 
end)

RegisterNetEvent('xAdmin:reviveS')
AddEventHandler('xAdmin:reviveS', function(id) 
    local source = source if source ~= nil then TriggerClientEvent('xAdmin:revive', id) end 
end)

RegisterNetEvent('xAdmin:reviveall')
AddEventHandler('xAdmin:reviveall', function()
    local source = source if source ~= nil then TriggerClientEvent('xAdmin:revive', -1) end
end)

RegisterNetEvent('xAdmin:prendre_report')
AddEventHandler('xAdmin:prendre_report', function(nom)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    if (not xPlayer) then return end

    local xPlayers = ESX.GetPlayers()
    local staff = xPlayer.getName()

    for i = 1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        for _,v in pairs(Admin.Acces.General) do
            if (xPlayer.getGroup()) == v then
                TriggerClientEvent('xAdmin:reportpris', xPlayers[i], nom, staff)
            end
        end
    end
end)

RegisterNetEvent('xAdmin:givemoneybank')
AddEventHandler('xAdmin:givemoneybank', function(id, amount)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local tPlayer = ESX.GetPlayerFromId(id)
    amount = tonumber(amount)

    if (not xPlayer) then return end if (not tPlayer) then return end
    tPlayer.addAccountMoney('bank', amount)
end)

RegisterNetEvent('xAdmin:givemoneycash')
AddEventHandler('xAdmin:givemoneycash', function(id, amount)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local tPlayer = ESX.GetPlayerFromId(id)
    amount = tonumber(amount)

    if (not xPlayer) then return end if (not tPlayer) then return end
    tPlayer.addMoney(amount)
end)

RegisterNetEvent('xAdmin:givemoneysale')
AddEventHandler('xAdmin:givemoneysale', function(id, amount)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local tPlayer = ESX.GetPlayerFromId(id)
    amount = tonumber(amount)

    if (not xPlayer) then return end if (not tPlayer) then return end
    tPlayer.addAccountMoney('black_money', amount)
end)

RegisterNetEvent('xAdmin:freezeS')
AddEventHandler('xAdmin:freezeS', function(id, number) TriggerClientEvent('xAdmin:freeze', id, number) end)
RegisterNetEvent('xAdmin:slapS')
AddEventHandler('xAdmin:slapS', function(id) TriggerClientEvent('xAdmin:slap', id) end)
RegisterNetEvent('xAdmin:healS')
AddEventHandler('xAdmin:healS', function(id) TriggerClientEvent('xAdmin:heal', id) end)

RegisterNetEvent('xAdmin:spawncar')
AddEventHandler('xAdmin:spawncar', function(type)
    TriggerClientEvent('xAdmin:spwan', source, type)
end)

RegisterNetEvent('xAdmin:tpS')
AddEventHandler('xAdmin:tpS', function(id, pos)
    TriggerClientEvent('xAdmin:tp', id, pos)
end)

RegisterNetEvent('xAdmin:removeinventory')
AddEventHandler('xAdmin:removeinventory', function(id, name, amount)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local tPlayer = ESX.GetPlayerFromId(id)
    amount = tonumber(amount)

    if (not xPlayer) then return end if (not tPlayer) then return end
    if (tPlayer.getInventoryItem(name).count) >= amount then
        tPlayer.removeInventoryItem(name, amount)
        xPlayer.addInventoryItem(name, amount)
        TriggerClientEvent('esx:showNotification', source, 'Remove effectué avec ~g~succès~s~.')
    else
        TriggerClientEvent('esx:showNotification', source, '~r~Le joueur n\'a pas autant !')
    end
end)

--- Xed#1188
