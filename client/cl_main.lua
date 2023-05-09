ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

--

local staffmode = false
local gamerTags = {}
local selected = nil
local name
local Items = {}

local function getPlayerInv(id)
	Items = {}
	
	ESX.TriggerServerCallback('xAdmin:getOtherPlayerData', function(data)
		for i=1, #data.inventory, 1 do
			if data.inventory[i].count > 0 then
				table.insert(Items, {
					label    = data.inventory[i].label,
					right    = data.inventory[i].count,
					value    = data.inventory[i].name,
					itemType = 'item_standard',
					amount   = data.inventory[i].count
				})
			end
		end
	end, id)
end

local reportlist = {}
local function getInfoReport()
    local info = {}
    ESX.TriggerServerCallback('xAdmin:infoReport', function(info)
        reportlist = info
    end)
end

RegisterNetEvent('xAdmin:co')
AddEventHandler('xAdmin:co', function(name)
    if staffmode then
        ESX.ShowNotification(('%s s\'est ~p~connecté(e)~s~.'):format(name))
    end
end)
RegisterNetEvent('xAdmin:deco')
AddEventHandler('xAdmin:deco', function(name)
    if staffmode then
        ESX.ShowNotification(('%s s\'est ~p~déconnecté(e)~s~.'):format(name))
    end
end)

RegisterNetEvent("xAdmin:Open/CloseReport")
AddEventHandler("xAdmin:Open/CloseReport", function(type, nomdumec)
    if type == 1 then
        if staffmode then ESX.ShowNotification('Un nouveau report à été effectué !') end
    elseif type == 2 then
        if staffmode then ESX.ShowNotification(('Le report de ~b~%s~s~ à été fermé !'):format(nomdumec)) end
    end
end)

RegisterNetEvent('xAdmin:reportpris')
AddEventHandler('xAdmin:reportpris', function(nom, staff)
    if staffmode then ESX.ShowNotification(("~r~Staff~s~\nReport de ~b~%s~s~ pris par ~b~%s~s~."):format(nom, staff)) end
end)

local resultItemC = {}
RegisterNetEvent('xAdmin:resultItem')
AddEventHandler('xAdmin:resultItem', function(resultItemS) resultItemC = resultItemS end)

RegisterCommand("tpm", function()
    if Required.TPM == true then
        if staffmode then
            TPMarker()
        else
            ESX.ShowNotification("~r~→~s~ Vous devez être en mode staff.")
        end
    else TPMarker() end
end)

RegisterCommand("spec", function(source, args, rawCommand)
    if staffmode then 
        id = tonumber(args[1])
        SpectatePlayer(GetPlayerPed(GetPlayerFromServerId(id)), GetPlayerFromServerId(id), GetPlayerName(GetPlayerFromServerId(id))) 
    end
end)

RegisterCommand('pos', function()
    if staffmode then print(GetEntityCoords(PlayerPedId())) end
end)

local playerscacheC = {}
RegisterNetEvent('xAdmin:listplayer')
AddEventHandler('xAdmin:listplayer', function(playerscache) if staffmode then playerscacheC = playerscache end end)

--

RegisterCommand('openadminmenu', function()
    ESX.TriggerServerCallback('xAdmin:getgroup', function(group)
        for _,v in pairs(Admin.Acces.General) do
            if group == v then
                OpenMenuAdmin(group)
            end
        end   
    end)
end)

RegisterCommand('noclip', function()
    ESX.TriggerServerCallback('xAdmin:getgroup', function(group)
        for _,v in pairs(Admin.Acces.Noclip) do
            if group == v then
                if Required.NoClip == true then 
                    if staffmode then 
                        NoCLIP()
                    else
                        ESX.ShowNotification("~r~→~s~ Vous devez être en mode staff.")
                    end 
                else 
                    NoCLIP()
                end
            end
        end   
    end)
end)

RegisterCommand('reviveall', function()
    ESX.TriggerServerCallback('xAdmin:getgroup', function(group)
        for _,v in pairs(Admin.Acces.General) do
            if group == v then
                TriggerServerEvent('xAdmin:reviveall')
            end
        end   
    end)
end)

RegisterKeyMapping('openadminmenu', 'Ouvrir le menu admin', 'keyboard', 'f10')
RegisterKeyMapping('noclip', 'NoClip', 'keyboard', 'f9')

local open = false
local MainMenu = RageUI.CreateMenu("xAdmin", "Interaction", nil, nil, "root_cause5", "img_bleu")
local sub_menu1 = RageUI.CreateSubMenu(MainMenu, "xAdmin", "Interaction")
local sub_menu2 = RageUI.CreateSubMenu(sub_menu1, "xAdmin", "Interaction")
local sub_menu3 = RageUI.CreateSubMenu(MainMenu, "xAdmin", "Interaction")
local sub_menu4 = RageUI.CreateSubMenu(MainMenu, "xAdmin", "Interaction")
local sub_menu5 = RageUI.CreateSubMenu(MainMenu, "xAdmin", "Interaction")
local sub_menu6 = RageUI.CreateSubMenu(sub_menu3, "xAdmin", "Interaction")
local sub_menu7 = RageUI.CreateSubMenu(sub_menu2, "xAdmin", "Interaction")
local sub_menu8 = RageUI.CreateSubMenu(MainMenu, "xAdmin", "Interaction")
local sub_menu9 = RageUI.CreateSubMenu(MainMenu, "xAdmin", "Interaction")
MainMenu.Display.Header = true
MainMenu.Closed = function()
    open = false
end

local filterArray = { "Aucun", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" }
local filter = 1

local Customs = {
    List1 = 1,
    List2 = 1,
    List3 = 1, 
    List4 = 1,
    List5 = 1,
    List6 = 1,
    List7 = 1
}

function OpenMenuAdmin(group)
    if open then
        open = false
        RageUI.Visible(MainMenu, false)
    else
        open = true
        RageUI.Visible(MainMenu, true)
        Citizen.CreateThread(function()
            while open do
                Wait(0)

                RageUI.IsVisible(MainMenu, function()
                    RageUI.Checkbox("Activer/Désactiver staff mode", nil, staffmode, {RightLabel = ""}, {
                        onChecked = function()
                            staffmode = true
                        end,
                        onUnChecked = function()
                            staffmode = false
                            ShowName = false
                            godmod = false
                            invisible = false
                            for _, v in pairs(GetActivePlayers()) do
                                RemoveMpGamerTag(gamerTags[v])
                            end
                            if IsPedInAnyVehicle(PlayerPedId(), false) then
                                Vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                                SetEntityVisible(Vehicle, true)
                            else
                                SetEntityVisible(PlayerPedId(), true)
                            end
                            SetEntityInvincible(PlayerPedId(), false)
                        end
                    })
                    if not staffmode then
                        RageUI.Line()
                        RageUI.Separator(("Grade: ~b~%s~s~"):format(group))
                    end
                    if staffmode then
                        RageUI.Line()
                       RageUI.Button("~b~→~s~ Liste des joueurs", nil, {RightBadge = RageUI.BadgeStyle.Star}, true, {}, sub_menu1)
                        RageUI.Button("~b~→~s~ Liste items", nil, {RightBadge = RageUI.BadgeStyle.Star}, true, { onSelected = function() TriggerServerEvent('xAdmin:getItem') end }, sub_menu3)
                        RageUI.Button("~b~→~s~ Option personnel", nil, {RightBadge = RageUI.BadgeStyle.Star}, true, {}, sub_menu4)
                        RageUI.Button("~b~→~s~ Option véhicule", nil, {RightBadge = RageUI.BadgeStyle.Star}, true, {}, sub_menu5)
                        RageUI.Button("~b~→~s~ Gestion reports", nil, {RightBadge = RageUI.BadgeStyle.Star}, true, { onSelected = function() getInfoReport() end }, sub_menu8)
                    end
                end)

                RageUI.IsVisible(sub_menu1, function()
                    RageUI.List("Filtre:", filterArray, Customs.List3, nil, {Preview}, true, {
                        onListChange = function(i, Item)
                            Customs.List3 = i
                            filter = i
                        end,
                    })
                    RageUI.Line()
                    for _,v in pairs(playerscacheC) do
                        if Customs.List3 == 1 then
                            RageUI.Button(("[~b~%s~s~] | ~b~%s~s~"):format(v.id, v.name), nil, {RightLabel = "→"}, true, {
                                onSelected = function() selected = _ end
                            }, sub_menu2)
                        end
                        if starts(v.name:lower(), filterArray[filter]:lower()) then
                            RageUI.Button(("[~b~%s~s~] | ~b~%s~s~"):format(v.id, v.name), nil, {RightLabel = "→"}, true, {
                                onSelected = function() selected = _ end
                            }, sub_menu2)
                        end
                    end
                end)

                RageUI.IsVisible(sub_menu2, function()
                    if (selected == nil) then return else
                        if (not playerscacheC[selected]) then RageUI.GoBack() else
                            local player = playerscacheC[selected]
                            RageUI.Separator(("Id:~b~ %s~s~"):format(player.id))
                            RageUI.Separator(("Identité:~b~ %s~s~"):format(player.name))
                            RageUI.Separator(("Argent: ~b~%s$~s~"):format(player.money))
                            RageUI.Separator(("Métier: ~b~%s~s~ | Grade: ~b~%s~s~"):format(player.job.label, player.job.grade_label))
                            RageUI.Separator(("Gang: ~b~%s~s~ | Grade: ~b~%s~s~"):format(player.job2.label, player.job2.grade_label))
                            RageUI.Line()
                            RageUI.Checkbox("Freeze/Defreeze", nil, freeze, {RightLabel = ""}, {
                                onChecked = function()
                                    freeze = true
                                    TriggerServerEvent('xAdmin:freezeS', player.id, 1)
                                end,
                                onUnChecked = function()
                                    freeze = false
                                    TriggerServerEvent('xAdmin:freezeS', player.id, 2)
                                end
                            })
                            RageUI.Button("Goto", nil, {RightBadge = RageUI.BadgeStyle.Tick}, true, {
                                onSelected = function()
                                    TpSurId(player.id)
                                end
                            })
                            RageUI.Button("Bring", nil, {RightBadge = RageUI.BadgeStyle.Tick}, true, {
                                onSelected = function()
                                    TriggerServerEvent('xAdmin:bring', player.id, GetEntityCoords(PlayerPedId()))
                                end
                            })
                            RageUI.Button("Slap", nil, {RightBadge = RageUI.BadgeStyle.Tick}, true, {
                                onSelected = function()
                                    TriggerServerEvent('xAdmin:slapS', player.id)
                                end
                            })
                            RageUI.Button("Soigner", nil, {RightBadge = RageUI.BadgeStyle.Tick}, true, {
                                onSelected = function()
                                    TriggerServerEvent('xAdmin:healS', player.id)
                                    ESX.ShowNotification("Joueur soigner avec ~g~succès~s~.")
                                end
                            })
                            RageUI.Button("Revive", nil, {RightBadge = RageUI.BadgeStyle.Tick}, true, {
                                onSelected = function()
                                    TriggerServerEvent('xAdmin:reviveS', player.id)
                                end
                            })
                            RageUI.Button("Crash", nil, {RightBadge = RageUI.BadgeStyle.Tick}, true, {
                                onSelected = function()
                                    TriggerServerEvent("xAdmin:crash", player.id)
                                end
                            })
                            RageUI.Button("Spectate", nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    SpectatePlayer(GetPlayerPed(GetPlayerFromServerId(player.id)), GetPlayerFromServerId(player.id), GetPlayerName(GetPlayerFromServerId(player.id))) 
                                end
                            })
                            RageUI.Button("Envoyer un message", nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    local text = KeyboardInput("Votre message", "", 255)
                                    if text ~= "" then
                                        TriggerServerEvent("xAdmin:message", player.id, ("~r~Staff~s~\n%s"):format(text))
                                    end
                                end
                            })
                            RageUI.Button("Kick", nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    local reason = KeyboardInput("Raison", "", 255)
                                    if reason  ~= "" then
                                        if reason  ~= nil then TriggerServerEvent('xAdmin:kick', player.id, reason) end
                                    end
                                end
                            })
                            RageUI.Button("Inventaire", nil, {RightLabel = "→"}, true, { onSelected = function() getPlayerInv(player.id) pId = player.id end }, sub_menu7)
                            RageUI.List("Give money", {"Banque", "Cash", "Sale"}, Customs.List6, nil, {Preview}, true, {
                                onListChange = function(i, Item)
                                    Customs.List6 = i;
                                end,
                                onSelected = function()
                                    if Customs.List6 == 1 then
                                        local amount = KeyboardInput("Montant", "", 10)
                                        if amount ~= "" then
                                            TriggerServerEvent('xAdmin:givemoneybank', player.id, amount)
                                        end
                                    elseif Customs.List6 == 2 then
                                        local amount = KeyboardInput("Montant", "", 10)
                                        if amount ~= "" then
                                            TriggerServerEvent('xAdmin:givemoneycash', player.id, amount)
                                        end
                                    elseif Customs.List6 == 3 then
                                        local amount = KeyboardInput("Montant", "", 10)
                                        if amount ~= "" then
                                            TriggerServerEvent('xAdmin:givemoneysale', player.id, amount)
                                        end
                                    end
                                end
                            })
                            RageUI.List("Setjob", {"Job1", "Job2"}, Customs.List2, nil, {Preview}, true, {
                                onListChange = function(i, Item)
                                    Customs.List2 = i;
                                end,
                                onSelected = function()
                                    if Customs.List2 == 1 then
                                        local job = KeyboardInput("Job", "", 15)
                                        local grade = KeyboardInput("Grade", "", 15)
                                        if job ~= "" and grade ~= "" then
                                            TriggerServerEvent('xAdmin:setjob', player.id, job, grade)
                                        end
                                    elseif Customs.List2 == 2 then
                                        local job = KeyboardInput("Job", "", 15)
                                        local grade = KeyboardInput("Grade", "", 15)
                                        if job ~= "" and grade ~= "" then
                                            TriggerServerEvent('xAdmin:setjob2', player.id, job, grade)
                                        end
                                    end
                                end
                            })
                            RageUI.List("Téléporter", {"Sur un toit", "Au PC", "Hopital", "PDP", "Vetement", "Sandy Shores", "Paleto", "Epicerie"}, Customs.List4, nil, {Preview}, true, {
                                onListChange = function(i, Item)
                                    Customs.List4 = i;
                                end,

                                onSelected = function()
                                    if Customs.List4 == 1 then
                                        TriggerServerEvent('xAdmin:tpS', player.id, TP.Toit)
                                    elseif Customs.List4 == 2 then
                                        TriggerServerEvent('xAdmin:tpS', player.id, TP.PC)
                                    elseif Customs.List4 == 3 then
                                        TriggerServerEvent('xAdmin:tpS', player.id, TP.Hopital)
                                    elseif Customs.List4 == 4 then
                                        TriggerServerEvent('xAdmin:tpS', player.id, TP.PDP)
                                    elseif Customs.List4 == 5 then
                                        TriggerServerEvent('xAdmin:tpS', player.id, TP.Vetement)
                                    elseif Customs.List4 == 6 then
                                        TriggerServerEvent('xAdmin:tpS', player.id, TP.SandyShores)
                                    elseif Customs.List4 == 7 then
                                        TriggerServerEvent('xAdmin:tpS', player.id, TP.Paleto)
                                    elseif Customs.List4 == 8 then
                                        TriggerServerEvent('xAdmin:tpS', player.id, TP.Epicerie)
                                    end
                                end
                            })
                            RageUI.List("Wipe", {"Complet", "Inventaire"}, Customs.List7, nil, {Preview}, true, {
                                onListChange = function(i, Item)
                                    Customs.List7 = i;
                                end,

                                onSelected = function()
                                    if Customs.List7 == 1 then
                                        TriggerServerEvent('xAdmin:wipe', player.id)
                                    elseif Customs.List7 == 2 then
                                        ExecuteCommand(('clearinventory %s'):format(player.id))
                                    end
                                end
                            })
                            RageUI.Button("Donner un véhicule", "Dans le garage du joueur", {RightLabel = "→"}, true, {
                                onSelected = function()
                                    ESX.TriggerServerCallback('xAdmin:getgroup', function(group)
                                        for _,v in pairs(Admin.Acces.GiveCar) do
                                            if group == v then
                                                local type = KeyboardInput("Modèle du véhicule", "", 15)
                                                if type ~= "" then
                                                    if type ~= nil then
                                                        if not IsModelInCdimage(type) then return end
                                                        RequestModel(type)
                                                        while not HasModelLoaded(type) do
                                                            Citizen.Wait(10)
                                                        end
                                                        ESX.Game.SpawnVehicle(type, GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId()), function(vehicle) 
                                                            TriggerServerEvent('xAdmin:givecargarage', ESX.Game.GetVehicleProperties(vehicle), player.id)
                                                        end)
                                                    end
                                                end
                                            end
                                        end
                                    end)
                                end
                            })
                        end
                    end
                end)

                RageUI.IsVisible(sub_menu7, function()
                    for k,v  in pairs(Items) do
                        RageUI.Button(("~b~→~s~ %s"):format(v.label), nil, {RightLabel = ("~b~x%s~s~"):format(v.right)}, true, {
                            onSelected = function()
                                local amount = KeyboardInput("Quantité", "", 5)
                                if amount ~= "" then
                                    if amount ~= nil then
                                        TriggerServerEvent('xAdmin:removeinventory', pId, v.value, amount)
                                        getPlayerInv(pId)
                                    end
                                end
                            end
                        })
                    end	
                end)

                RageUI.IsVisible(sub_menu8, function()
                    if #reportlist > 0 then
                        for k,v in pairs(reportlist) do
                            RageUI.Button(('%s - Report de  ~b~%s~s~  | Id :  ~b~%s~s~ '):format(k, v.nom, v.id), nil, {RightLabel = '→→'}, true, {
                                onSelected = function()
                                    nom = v.nom
                                    nbreport = k
                                    id = v.id
                                    raison = v.args
                                end
                            }, sub_menu9)
                        end
                    else
                        RageUI.Separator("")
                        RageUI.Separator("~r~Aucun Signalement~s~")
                        RageUI.Separator("")
                    end
                end)

                RageUI.IsVisible(sub_menu9, function()
                    RageUI.Separator("")
                    RageUI.Separator(("Signalement numéro : ~b~%s~s~"):format(nbreport))
                    RageUI.Separator(("Auteur : ~b~%s~s~ [ ~b~%s~s~ ]"):format(nom, id))
                    RageUI.Separator("")

                    RageUI.Button("Raison du report", raison, {RightLabel = '→→'}, true, {})
                    RageUI.Button(('S\'occuper du report de ~b~%s~s~'):format(nom), nil, {RightLabel = '→→'}, true, {
                        onSelected = function()
                            TriggerServerEvent("xAdmin:prendre_report", nom)
                        end
                    })
                    RageUI.Button(('Se téléporter sur ~b~%s~s~'):format(nom), nil, {RightLabel = '→→'}, true, {
                        onSelected = function()
                            TpSurId(id)
                        end
                    })
                    RageUI.Button(('Téléporter ~b~%s~s~ sur moi'):format(nom), nil, {RightLabel = '→→'}, true, {
                        onSelected = function()
                            TriggerServerEvent('xAdmin:bring', id, GetEntityCoords(PlayerPedId()))
                        end
                    })
                    RageUI.Button('Répondre au report', nil, {RightLabel = '→→'}, true, {
                        onSelected = function()
                            local reponse = KeyboardInput('~c~Entrez le message ici :', nil, 30)
                            local reponseReport = GetOnscreenKeyboardResult(reponse)
                            if reponseReport == "" then
                                ESX.ShowNotification("~r~Admin\n~r~Vous n'avez pas fourni de message")
                            else
                                if reponseReport then
                                    ESX.ShowNotification(("Le message : ~b~%s~s~ a été envoyer à ~r~%s~s~"):format(reponseReport, GetPlayerName(GetPlayerFromServerId(id))) )
                                    TriggerServerEvent("xAdmin:message", id, ("~r~Staff~s~\n%s"):format(reponseReport))
                                end
                            end
                        end
                    })
                    RageUI.Button(('Fermer le report de ~b~%s~s~'):format(nom), nil, {RightLabel = '→→'}, true, {
                        onSelected = function()
                            TriggerServerEvent('xAdmin:CloseReport', nom, raison)
                            TriggerServerEvent("xAdmin:message", id, "Votre report à été fermé !")
                            RageUI.GoBack()
                        end
                    })
                end)

                RageUI.IsVisible(sub_menu3, function()
                    RageUI.List("Filtre:", filterArray, Customs.List5, nil, {Preview}, true, {
                        onListChange = function(i, Item)
                            Customs.List5 = i
                            filter = i
                        end,
                    })
                    RageUI.Line()
                    for _,v in pairs(resultItemC) do
                        if Customs.List5 == 1 then
                            RageUI.Button(v.label, nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    name = v.name
                                end
                            }, sub_menu6)
                        end
                        if starts(v.label:lower(), filterArray[filter]:lower()) then
                            RageUI.Button(v.label, nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    name = v.name
                                end
                            }, sub_menu6)
                        end
                    end
                end)

                RageUI.IsVisible(sub_menu6, function()
                    RageUI.Button("Donner l'item à un joueur", nil, {RightLabel = "→"}, true, {
                        onSelected = function()
                            local id = KeyboardInput("Id du joueur", "", 3)
                            local qtty = KeyboardInput("Quantité", "", 4)
                            if id ~= "" then
                            if qtty ~= "" then
                                TriggerServerEvent('xAdmin:giveitem', id, name, qtty)
                            end
                            end
                        end
                    })
                    RageUI.Button("Se give l'item", nil, {RightLabel = "→"}, true, {
                        onSelected = function()
                            local qtty = KeyboardInput("Quantité", "", 4)
                            if qtty ~= "" then TriggerServerEvent('xAdmin:autogiveitem', name, qtty) end
                        end
                    })
                end)

                RageUI.IsVisible(sub_menu4, function()
                    RageUI.Checkbox("NoClip", nil, check, {RightLabel = ""}, {
                        onChecked = function()
                            check = true
                            NoCLIP()
                        end,
                        onUnChecked = function()
                            check = false
                            NoCLIP()
                        end
                    })
                    RageUI.Checkbox("Afficher les noms", nil, ShowName, {RightLabel = ""}, {
                        onChecked = function()
                            ShowName = true
                            local pCoords = GetEntityCoords(GetPlayerPed(-1), false)
                            for _, v in pairs(GetActivePlayers()) do
                                local otherPed = GetPlayerPed(v)
            
                                if otherPed ~= pPed then
                                    if #(pCoords - GetEntityCoords(otherPed, false)) < 250.0 then
                                        gamerTags[v] = CreateFakeMpGamerTag(otherPed, (" [%s] %s"):format(GetPlayerServerId(v), GetPlayerName(v)), false, false, '', 0)
                                        SetMpGamerTagVisibility(gamerTags[v], 4, 1)
                                    else
                                        RemoveMpGamerTag(gamerTags[v])
                                        gamerTags[v] = nil
                                    end
                                end
                            end
                        end,
                        onUnChecked = function()
                            ShowName = false
                            for _, v in pairs(GetActivePlayers()) do
                                RemoveMpGamerTag(gamerTags[v])
                            end
                        end
                    })
                    RageUI.Checkbox("Afficher les blips", nil, blipsActive, {RightLabel = ""}, {
                        onChecked = function()
                            blipsActive = true
                            Blips()
                        end,
                        onUnChecked = function()
                            blipsActive = false
                            Blips()
                        end
                    })
                    RageUI.Checkbox("Se rendre invincible", nil, godmod, {RightLabel = ""}, {
                        onChecked = function()
                            godmod = true
                            SetEntityInvincible(PlayerPedId(), true)
                        end,
                        onUnChecked = function()
                            godmod = false
                            SetEntityInvincible(PlayerPedId(), false)
                        end
                    })
                    RageUI.Checkbox("Se rendre invisible", nil, invisible, {RightLabel = ""}, {
                        onChecked = function()
                            invisible = true
                            if IsPedInAnyVehicle(PlayerPedId(), false) then
                                local Vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                                SetEntityVisible(Vehicle, false)
                            else
                                SetEntityVisible(PlayerPedId(), false)
                            end
                        end,
                        onUnChecked = function()
                            invisible = false
                            if IsPedInAnyVehicle(PlayerPedId(), false) then
                                local Vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                                SetEntityVisible(Vehicle, true)
                            else
                                SetEntityVisible(PlayerPedId(), true)
                            end
                        end
                    })
                    RageUI.Button("Se soigner", nil, {RightBadge = RageUI.BadgeStyle.Tick}, true, {
                        onSelected = function()
                            SetEntityHealth(PlayerPedId(), 200)
                            ESX.ShowNotification("Vous vous êtes soigner avec ~g~succès~s~.")
                        end
                    })
                    RageUI.Button("Se revive", nil, {RightBadge = RageUI.BadgeStyle.Tick}, true, {
                        onSelected = function()
                            TriggerEvent('xAdmin:revive')
                        end
                    })
                    RageUI.Button("TP sur marqueur", nil, {RightBadge = RageUI.BadgeStyle.Tick}, true, {
                        onSelected = function()
                            TPMarker()
                        end
                    })
                    RageUI.Button("Obtenir sa position", nil, {RightLabel = "→"}, true, {
                        onSelected = function()
                            print(GetEntityCoords(PlayerPedId()))
                        end
                    })
                    RageUI.Button("Faire une annonce", nil, {RightLabel = "→"}, true, {
                        onSelected = function()
                            local text = KeyboardInput("Votre annonce", "", 255)
                            if text ~= "" then
                                TriggerServerEvent('xAdmin:announce', text)
                            end
                        end
                    })
                    RageUI.List("Give money", {"Banque", "Cash", "Sale"}, Customs.List6, nil, {Preview}, true, {
                        onListChange = function(i, Item)
                            Customs.List6 = i;
                        end,
                        onSelected = function()
                            if Customs.List6 == 1 then
                                local amount = KeyboardInput("Montant", "", 10)
                                if amount ~= "" then
                                    TriggerServerEvent('xAdmin:givemoneybank', GetPlayerServerId(PlayerId()), amount)
                                end
                            elseif Customs.List6 == 2 then
                                local amount = KeyboardInput("Montant", "", 10)
                                if amount ~= "" then
                                    TriggerServerEvent('xAdmin:givemoneycash', GetPlayerServerId(PlayerId()), amount)
                                end
                            elseif Customs.List6 == 3 then
                                local amount = KeyboardInput("Montant", "", 10)
                                if amount ~= "" then
                                    TriggerServerEvent('xAdmin:givemoneysale', GetPlayerServerId(PlayerId()), amount)
                                end
                            end
                        end
                    })
                end)

                RageUI.IsVisible(sub_menu5, function()
                    RageUI.Button("Faire apparaître un véhicule", nil, {RightLabel = "→"}, true, {
                        onSelected = function()
                            local type = KeyboardInput("Modèle du véhicule", "", 15)
                            if type ~= "" then ESX.Game.SpawnVehicle(type, GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId()), function()end) end
                        end
                    })
                    RageUI.Button("Supprimer le véhicule à proximité", nil, {RightBadge = RageUI.BadgeStyle.Tick}, true, {
                        onActive = function()
                            local vCoords = GetEntityCoords(GetClosestVehicle(GetEntityCoords(PlayerPedId()), 15.0, 0, 70))
                            DrawMarker(2, vCoords.x, vCoords.y, vCoords.z + 1.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 255, 255, 170, 0, 1, 2, 0, nil, nil, 0)
                        end,
                        onSelected = function()
                            DeleteEntity(GetClosestVehicle(GetEntityCoords(PlayerPedId()), 15.0, 0, 70))
                        end
                    })
                    RageUI.Line()
                    if IsPedInAnyVehicle(PlayerPedId(), false) then
                        local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
                        RageUI.Button("Changer la plaque du véhicule", nil, {RightLabel = "→"}, true, {
                            onSelected = function()
                                local plate = KeyboardInput("Nouvelle plaque", "", 8)
                                SetVehicleNumberPlateText(vehicle, plate)
                            end
                        })
                        RageUI.Button("Customiser le véhicule au maximum", nil, {RightBadge = RageUI.BadgeStyle.Tick}, true, {
                            onSelected = function()
                                ToggleVehicleMod(vehicle, 18, true)
                                ToggleVehicleMod(vehicle, 22, true)
                                SetVehicleMod(vehicle, 23, 11, false)
                                SetVehicleMod(vehicle, 24, 11, false)
                                ToggleVehicleMod(vehicle, 20, true)
                                LowerConvertibleRoof(vehicle, true)
                                SetVehicleIsStolen(vehicle, false)
                                SetVehicleIsWanted(vehicle, false)
                                SetVehicleHasBeenOwnedByPlayer(vehicle, true)
                                SetVehicleNeedsToBeHotwired(vehicle, false)
                                SetCanResprayVehicle(vehicle, true)
                                SetPlayersLastVehicle(vehicle)
                                SetVehicleFixed(vehicle)
                                SetVehicleDeformationFixed(vehicle)
                                SetVehicleTyresCanBurst(vehicle, false)
                                SetVehicleWheelsCanBreak(vehicle, false)
                                SetVehicleCanBeTargetted(vehicle, false)
                                SetVehicleExplodesOnHighExplosionDamage(vehicle, false)
                                SetVehicleHasStrongAxles(vehicle, true)
                                SetVehicleDirtLevel(vehicle, 0)
                                SetVehicleCanBeVisiblyDamaged(vehicle, false)
                                IsVehicleDriveable(vehicle, true)
                                SetVehicleEngineOn(vehicle, true, true)
                                SetVehicleStrong(vehicle, true)
                                SetPedCanBeDraggedOut(PlayerPedId(), false)
                                SetPedStayInVehicleWhenJacked(PlayerPedId(), true)
                                SetPedRagdollOnCollision(PlayerPedId(), false)
                                ResetPedVisibleDamage(PlayerPedId())
                                ClearPedDecorations(PlayerPedId())
                                SetIgnoreLowPriorityShockingEvents(PlayerPedId(), true)
                            end
                        })
                        RageUI.Button('Réparer le véhicule', nil, {RightBadge = RageUI.BadgeStyle.Tick}, true, {
                            onSelected = function()
                                SetVehicleEngineHealth(vehicle, 1000.0)
                                SetVehicleFixed(vehicle)
                                SetVehicleDeformationFixed(vehicle)
                            end
                        })
                        RageUI.Button("Retourner le véhicule", nil, {RightBadge = RageUI.BadgeStyle.Tick}, true, {
                            onSelected = function()
                                local newCoords = (GetEntityCoords(PlayerPedId())) + vector3(0.0, 2.0, 0.0)
                                SetEntityCoords(vehicle, newCoords)
                            end
                        })
                        RageUI.Button("Supprimer le véhicule", nil, {RightBadge = RageUI.BadgeStyle.Tick}, true, { onSelected = function() DeleteEntity(vehicle) end })
                        RageUI.List("Changer la couleur du véhicule", {'Rouge', 'Bleu', 'Jaune', 'Vert', 'Violet', 'Orange'}, Customs.List1, nil, {Preview}, true, {
                            onListChange = function(i, Item)
                                Customs.List1 = i;
                            end,
                            onSelected = function()
                                if Customs.List1 == 1 then SetVehicleColours(vehicle, 27, 27)
                                elseif Customs.List1 == 2 then SetVehicleColours(vehicle, 64, 64)
                                elseif Customs.List1 == 3 then SetVehicleColours(vehicle, 89, 89)
                                elseif Customs.List1 == 4 then SetVehicleColours(vehicle, 53, 53)
                                elseif Customs.List1 == 5 then SetVehicleColours(vehicle, 71, 71)
                                elseif Customs.List1 == 6 then SetVehicleColours(vehicle, 41, 41)
                                end
                            end
                        })
                    else
                        RageUI.Button("~r~→~s~ Vous devez être dans un véhicule", nil, {RightBadge = RageUI.BadgeStyle.Alert}, true, {})
                    end
                end)

            end
        end)
    end
end

--- Xed#1188
