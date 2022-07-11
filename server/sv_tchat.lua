CreateThread(function()
    if GetCurrentResourceName() ~= "xAdminV2" then
        os.exit()
    end
end)

RegisterCommand("staff", function(source, args, rawCommand)
	local xPlayer = ESX.GetPlayerFromId(source)

	for _,v in pairs(Admin.Acces.ChatStaff) do
		if xPlayer.getGroup() == v then
			local xPlayers = ESX.GetPlayers()
			for i = 1, #xPlayers, 1 do
				local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
				if (xPlayer.getGroup()) == v then
					TriggerClientEvent('chat:addMessage', xPlayers[i], {args = {"^1TCHAT STAFF^0 | ^1"..GetPlayerName(source).."^0  ", table.concat(args, " ")}} )
				end
			end
		end
	end
end)

RegisterNetEvent('xAdmin:announce')
AddEventHandler('xAdmin:announce', function(text)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)

	if (not xPlayer) then return end
	TriggerClientEvent('chat:addMessage', -1, ("^1ANNONCE^0 : %s"):format(text))
end)

--- Xed#1188
