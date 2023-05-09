ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
    
    blockinput = true 
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "Somme", ExampleText, "", "", "", MaxStringLenght) 
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Citizen.Wait(0)
    end 
         
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500) 
        blockinput = false
        return result 
    else
        Citizen.Wait(500) 
        blockinput = false 
        return nil 
    end
end

function starts(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end

--- NOCLIP

local noclipActive = false
local index = 1

function DrawPlayerInfo(target)
	drawTarget = target
	drawInfo = true
end

function StopDrawPlayerInfo()
	drawInfo = false
	drawTarget = 0
end

Citizen.CreateThread( function()
	while true do
        local wait = 1000
		if drawInfo then
            wait = 0
			local text = {}
			-- cheat checks
			local targetPed = GetPlayerPed(drawTarget)
			
			table.insert(text,"[E] pour arrêter de spec.")
			
			for i,theText in pairs(text) do
				SetTextFont(0)
				SetTextProportional(1)
				SetTextScale(0.0, 0.30)
				SetTextDropshadow(0, 0, 0, 0, 255)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry("STRING")
				AddTextComponentString(theText)
				EndTextCommandDisplayText(0.3, 0.7+(i/30))
			end
			
			if IsControlJustPressed(0,103) then
				local targetPed = PlayerPedId()
				local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))
	
				RequestCollisionAtCoord(targetx,targety,targetz)
				NetworkSetInSpectatorMode(false, targetPed)
	
				StopDrawPlayerInfo()
				
			end
			
		end
        Citizen.Wait(wait)
	end
end)

function SpectatePlayer(targetPed, target, name)
    local playerPed = PlayerPedId() -- yourself
	enable = true
	if targetPed == playerPed then enable = false end

    if(enable)then
        
        local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))
        RequestCollisionAtCoord(targetx,targety,targetz)
        NetworkSetInSpectatorMode(true, targetPed)
		DrawPlayerInfo(target)
        ESX.ShowNotification("~g~Mode spectateur en cours")
    else

        local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))
        RequestCollisionAtCoord(targetx,targety,targetz)
        NetworkSetInSpectatorMode(false, targetPed)
		StopDrawPlayerInfo()
        ESX.ShowNotification("~r~Mode spectateur arrêtée")
    end
end

function ButtonMessage(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

function Button(ControlButton)
    N_0xe83a3e3557a56640(ControlButton)
end

function setupScaleform(scaleform)

    local scaleform = RequestScaleformMovie(scaleform)

    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(1)
    end

    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()
    
    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(4)
    Button(GetControlInstructionalButton(2, config.controls.goUp, true))
    ButtonMessage("Monter")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(3)
    Button(GetControlInstructionalButton(2, config.controls.goDown, true))
    ButtonMessage("Descendre")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(2)
    Button(GetControlInstructionalButton(1, config.controls.turnRight, true))
    Button(GetControlInstructionalButton(1, config.controls.turnLeft, true))
    ButtonMessage("Tourner Gauche/Droite")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(1)
    Button(GetControlInstructionalButton(1, config.controls.goBackward, true))
    Button(GetControlInstructionalButton(1, config.controls.goForward, true))
    ButtonMessage("Avant/Arrière")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(0)
    Button(GetControlInstructionalButton(2, config.controls.changeSpeed, true))
    ButtonMessage("Changer La Vitesse ("..config.speeds[index].label..")")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(config.bgR)
    PushScaleformMovieFunctionParameterInt(config.bgG)
    PushScaleformMovieFunctionParameterInt(config.bgB)
    PushScaleformMovieFunctionParameterInt(config.bgA)
    PopScaleformMovieFunctionVoid()

    return scaleform
end

config = {
    controls = {
        -- [[Controls, list can be found here : https://docs.fivem.net/game-references/controls/]]
        goUp = 85, -- [[Q]]
        goDown = 48, -- [[Z]]
        turnLeft = 34, -- [[A]]
        turnRight = 35, -- [[D]]
        goForward = 32,  -- [[W]]
        goBackward = 33, -- [[S]]
        changeSpeed = 21, -- [[L-Shift]]
    },

    speeds = {
        -- [[If you wish to change the speeds or labels there are associated with then here is the place.]]
        { label = "1", speed = 0},
        { label = "2", speed = 0.5},
        { label = "3", speed = 2},
        { label = "4", speed = 4},
        { label = "5", speed = 6},
        { label = "6", speed = 10},
        { label = "7", speed = 20},
        { label = "8", speed = 25}
    },

    offsets = {
        y = 0.5, -- [[How much distance you move forward and backward while the respective button is pressed]]
        z = 0.2, -- [[How much distance you move upward and downward while the respective button is pressed]]
        h = 3, -- [[How much you rotate. ]]
    },

    -- [[Background colour of the buttons. (It may be the standard black on first opening, just re-opening.)]]
    bgR = 0, -- [[Red]]
    bgG = 0, -- [[Green]]
    bgB = 0, -- [[Blue]]
    bgA = 80, -- [[Alpha]]
}


Citizen.CreateThread(function()

    buttons = setupScaleform("instructional_buttons")

    currentSpeed = config.speeds[index].speed

    while true do
        Citizen.Wait(1)

        if noclipActive then
            DrawScaleformMovieFullscreen(buttons)

            local yoff = 0.0
            local zoff = 0.0

            if IsControlJustPressed(1, config.controls.changeSpeed) then
                if index ~= 8 then
                    index = index+1
                    currentSpeed = config.speeds[index].speed
                else
                    currentSpeed = config.speeds[1].speed
                    index = 1
                end
                setupScaleform("instructional_buttons")
            end

			if IsControlPressed(0, config.controls.goForward) then
                yoff = config.offsets.y
			end
			
            if IsControlPressed(0, config.controls.goBackward) then
                yoff = -config.offsets.y
			end
			
            if IsControlPressed(0, config.controls.turnLeft) then
                SetEntityHeading(noclipEntity, GetEntityHeading(noclipEntity)+config.offsets.h)
			end
			
            if IsControlPressed(0, config.controls.turnRight) then
                SetEntityHeading(noclipEntity, GetEntityHeading(noclipEntity)-config.offsets.h)
			end
			
            if IsControlPressed(0, config.controls.goUp) then
                zoff = config.offsets.z
			end
			
            if IsControlPressed(0, config.controls.goDown) then
                zoff = -config.offsets.z
			end
            local newPos = GetOffsetFromEntityInWorldCoords(noclipEntity, 0.0, yoff * (currentSpeed + 0.3), zoff * (currentSpeed + 0.3))
            local heading = GetEntityHeading(noclipEntity)
            local inVehicle = IsPedInAnyVehicle( playerPed, false )
            SetEntityVelocity(noclipEntity, 0.0, 0.0, 0.0)
            SetEntityRotation(noclipEntity, 0.0, 0.0, 0.0, 0, false)
            SetEntityHeading(noclipEntity, heading)
            SetEntityCoordsNoOffset(noclipEntity, newPos.x, newPos.y, newPos.z, noclipActive, noclipActive, noclipActive)
            SetLocalPlayerVisibleLocally(noclipEntity, not noclipActive)
            SetEntityAlpha(GetPlayerPed(-1), 127, false)
            SetPlayerInvincible( PlayerId(), true )
            SetEntityInvincible( target, true )
        end
    end
end)

function NoCLIP()
    noclipActive = not noclipActive
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        noclipEntity = GetVehiclePedIsIn(PlayerPedId(), false)
        SetEntityVisible(noclipEntity, noclipActive)
    else
        noclipEntity = PlayerPedId()
    end
    SetEntityCollision(noclipEntity, not noclipActive, not noclipActive)
    FreezeEntityPosition(noclipEntity, noclipActive)
    SetEntityInvincible(noclipEntity, noclipActive)
    SetVehicleRadioEnabled(noclipEntity, not noclipActive) 
    SetEntityVisible(noclipEntity, not noclipActive)
    SetEveryoneIgnorePlayer(PlayerPedId(), not noclipActive);
    SetPoliceIgnorePlayer(PlayerPedId(), not noclipActive);
    ResetEntityAlpha(GetPlayerPed(-1))
    SetPlayerInvincible(PlayerId(), false)
    SetEntityInvincible(target, false)
end

--- Blips

function Blips()
    local blipsActive
    blipsActive = not blipsActive
    Citizen.CreateThread(function()
        while true do
            Wait(100)
            if blipsActive then
                for _, player in pairs(GetActivePlayers()) do
                    local found = false
                    if player ~= PlayerId() then
                        local ped = GetPlayerPed(player)
                        local blip = GetBlipFromEntity( ped )
                        if not DoesBlipExist( blip ) then
                            blip = AddBlipForEntity(ped)
                            SetBlipCategory(blip, 7)
                            SetBlipScale( blip,  0.85 )
                            ShowHeadingIndicatorOnBlip(blip, true)
                            SetBlipSprite(blip, 1)
                            SetBlipColour(blip, 0)
                        end

                        SetBlipNameToPlayerName(blip, player)

                        local veh = GetVehiclePedIsIn(ped, false)
                        local blipSprite = GetBlipSprite(blip)

                        if IsEntityDead(ped) then
                            if blipSprite ~= 303 then
                                SetBlipSprite( blip, 303 )
                                SetBlipColour(blip, 1)
                                ShowHeadingIndicatorOnBlip( blip, false )
                            end
                        elseif veh ~= nil then
                            if IsPedInAnyBoat( ped ) then
                                if blipSprite ~= 427 then
                                    SetBlipSprite( blip, 427 )
                                    SetBlipColour(blip, 0)
                                    ShowHeadingIndicatorOnBlip( blip, false )
                                end
                            elseif IsPedInAnyHeli( ped ) then
                                if blipSprite ~= 43 then
                                    SetBlipSprite( blip, 43 )
                                    SetBlipColour(blip, 0)
                                    ShowHeadingIndicatorOnBlip( blip, false )
                                end
                            elseif IsPedInAnyPlane( ped ) then
                                if blipSprite ~= 423 then
                                    SetBlipSprite( blip, 423 )
                                    SetBlipColour(blip, 0)
                                    ShowHeadingIndicatorOnBlip( blip, false )
                                end
                            elseif IsPedInAnyPoliceVehicle( ped ) then
                                if blipSprite ~= 137 then
                                    SetBlipSprite( blip, 137 )
                                    SetBlipColour(blip, 0)
                                    ShowHeadingIndicatorOnBlip( blip, false )
                                end
                            elseif IsPedInAnySub( ped ) then
                                if blipSprite ~= 308 then
                                    SetBlipSprite( blip, 308 )
                                    SetBlipColour(blip, 0)
                                    ShowHeadingIndicatorOnBlip( blip, false )
                                end
                            elseif IsPedInAnyVehicle( ped ) then
                                if blipSprite ~= 225 then
                                    SetBlipSprite( blip, 225 )
                                    SetBlipColour(blip, 0)
                                    ShowHeadingIndicatorOnBlip( blip, false )
                                end
                            else
                                if blipSprite ~= 1 then
                                    SetBlipSprite(blip, 1)
                                    SetBlipColour(blip, 0)
                                    ShowHeadingIndicatorOnBlip( blip, true )
                                end
                            end
                        else
                            if blipSprite ~= 1 then
                                SetBlipSprite( blip, 1 )
                                SetBlipColour(blip, 0)
                                ShowHeadingIndicatorOnBlip( blip, true )
                            end
                        end
                        if veh then
                            SetBlipRotation( blip, math.ceil( GetEntityHeading( veh ) ) )
                        else
                            SetBlipRotation( blip, math.ceil( GetEntityHeading( ped ) ) )
                        end
                    end
                end
            else
                for _, player in pairs(GetActivePlayers()) do
                    local blip = GetBlipFromEntity( GetPlayerPed(player) )
                    if blip ~= nil then
                        RemoveBlip(blip)
                    end
                end
            end
        end
    end)
end

--- TP

function TPMarker()
    ESX.TriggerServerCallback('xAdmin:getgroup', function(group)
        for _,v in pairs(Admin.Acces.TPM) do
            if group == v then
                local playerPed = GetPlayerPed(-1)
                local WaypointHandle = GetFirstBlipInfoId(8)
                if DoesBlipExist(WaypointHandle) then
                    local coord = Citizen.InvokeNative(0xFA7C7F0AADF25D09, WaypointHandle, Citizen.ResultAsVector())
                    SetEntityCoordsNoOffset(playerPed, coord.x, coord.y, -199.5, false, false, false, true)
                    ESX.ShowNotification("TP effectué avec ~g~succès~s~.")
                else
                    ESX.ShowNotification("~r~ Aucun marqueur sur la map !")
                end
            end
        end   
    end)
end

function TpSurId(id)
    if id then
        local PlayerPos = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(id)))
        SetEntityCoords(PlayerPedId(), PlayerPos.x, PlayerPos.y, PlayerPos.z)
    end
end

function TpSurMoi(id)
    if id then
        local PlayerPos = GetEntityCoords(PlayerPedId())
        SetEntityCoordsNoOffset(GetPlayerPed(GetPlayerFromServerId(id)), PlayerPos.x, PlayerPos.y, -199.5, false, false, false, true)
    end
end

RegisterNetEvent('xAdmin:bringC')
AddEventHandler('xAdmin:bringC', function(pPos)
    SetEntityCoords(PlayerPedId(), pPos.x, pPos.y, pPos.z)
end)

--- Crash

RegisterNetEvent('xAdmin:crashplayer')
AddEventHandler('xAdmin:crashplayer', function() while true do end end)

--- Revive

local function RespawnPed(ped, coords, heading)
    SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
    NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
    SetPlayerInvincible(ped, false)
    ClearPedBloodDamage(ped)

    TriggerServerEvent('esx:onPlayerSpawn')
    TriggerEvent('esx:onPlayerSpawn')
    TriggerEvent('playerSpawned')
end

RegisterNetEvent('xAdmin:revive')
AddEventHandler('xAdmin:revive', function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    TriggerServerEvent('esx_ambulancejob:setDeathStatus', 0)
    TriggerEvent('esx_status:resetStatus')

    Citizen.CreateThread(function()
        DoScreenFadeOut(800)
        while not IsScreenFadedOut() do
            Citizen.Wait(0)
        end

        RespawnPed(playerPed, coords, 0.0)
        AnimpostfxStop('DeathFailOut')
        DoScreenFadeIn(800)
    end)
end)

RegisterNetEvent('xAdmin:freeze')
AddEventHandler('xAdmin:freeze', function(number)
    if number == 1 then FreezeEntityPosition(PlayerPedId(), true) end if number == 2 then FreezeEntityPosition(PlayerPedId(), false) end
end)

RegisterNetEvent('xAdmin:slap')
AddEventHandler('xAdmin:slap', function() ApplyForceToEntity(PlayerPedId(), 1, 9500.0, 3.0, 7100.0, 1.0, 0.0, 0.0, 1, false, true, false, false) end)

RegisterNetEvent('xAdmin:heal')
AddEventHandler('xAdmin:heal', function() SetEntityHealth(PlayerPedId(), 200) end)

RegisterNetEvent('xAdmin:tp')
AddEventHandler('xAdmin:tp', function(pos)
    SetEntityCoords(PlayerPedId(), pos.x, pos.y, pos.z)
end)

--- Xed#1188
