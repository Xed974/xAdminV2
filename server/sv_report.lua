ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local reportTable = {}

RegisterCommand('report', function(source, args, rawCommand)
	local xPlayer = ESX.GetPlayerFromId(source)
    local NomDuMec = xPlayer.getName()
    local idDuMec = source
    local Raison = table.concat(args, " ")
    if #Raison <= 1 then
        TriggerClientEvent("esx:showNotification", source, "~r~Veuillez rentrer une raison valable.")
    elseif #Raison >= 20 then
        TriggerClientEvent("esx:showNotification", source, "~r~Veuillez rentrer une raison moins longue.")
    else
        TriggerClientEvent("esx:showNotification", source, "~g~Votre report à bien été envoyer à l'équipe de modération.")
        TriggerClientEvent("xAdmin:Open/CloseReport", -1, 1)
        table.insert(reportTable, {
            id = idDuMec,
            nom = NomDuMec,
            args = Raison,
        })
    end
end, false)

RegisterServerEvent("xAdmin:CloseReport")
AddEventHandler("xAdmin:CloseReport", function(nomMec, raisonMec)
    TriggerClientEvent("xAdmin:Open/CloseReport", -1, 2, nomMec, raisonMec)
    table.remove(reportTable, id, nom, args)
end)

CreateThread(function()
    if GetCurrentResourceName() ~= "xAdmin" then
        os.exit()
    end
end)

ESX.RegisterServerCallback('xAdmin:infoReport', function(source, cb)
    cb(reportTable)
end)

RegisterNetEvent('xAdmin:message')
AddEventHandler('xAdmin:message', function(id, msg)
    local tPlayer = ESX.GetPlayerFromId(id)

    TriggerClientEvent('esx:showNotification', tPlayer.source, msg)
end)

RegisterNetEvent('xAdmin:bring')
AddEventHandler('xAdmin:bring', function(id, pPos)
    TriggerClientEvent('xAdmin:bringC', id, pPos)
end)

--- Xed#1188