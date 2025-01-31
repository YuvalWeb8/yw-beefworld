local QBCore = exports['qb-core']:GetCoreObject()
local ox_target = exports['ox_target']
local inBeefWorld = false
local options
local spawnedPeds = {}

-- Functions
local function updateMenu()
    local options
    if inBeefWorld then
        options = {
            {
                title = 'Return To Default',
                description = 'Switch to the default lobby',
                onSelect = function()
                    changeLobby("default")
                end,
            }
        }
    else
        options = {
            {
                title = 'Beef World Zone',
                description = 'Switch to Beef World lobby',
                onSelect = function()
                    changeLobby("beefworld")
                end,
            }
        }
    end

    lib.registerContext({
        id = 'beefworld_menu',
        title = 'Teleport Menu',
        options = options
    })
end

function changeLobby(lobby)
    if Config.OnlyGangs then
        lib.callback('yw-beefworld:getGang', nil, function(result)
            if result then
                inBeefWorld = not inBeefWorld
                if Config.Notification == 'codem-notification' then
                	TriggerEvent('codem-notification:Create', inBeefWorld and "You are now in Beef World." or "You are now in Default Lobby.", 'info', 'Lobby Notification', 5000)
				elseif Config.Notification == 'qbcore' then
					TriggerEvent('QBCore:Notify', inBeefWorld and "You are now in Beef World." or "You are now in Default Lobby.", "info")
				end

                TriggerServerEvent('yw-beefworld:ChangeLobby', lobby)
                if lobby == "default" then
                    SetEntityCoords(PlayerPedId(), Config.DefaultWorldSpawn, false, false, false, true)
                    SetEntityHeading(PlayerPedId(), Config.Heading)
					
                elseif lobby == 'beefworld' then
                    SetEntityCoords(PlayerPedId(), Config.BeefWorldSpawn, false, false, false, true)
                    SetEntityHeading(PlayerPedId(), Config.Heading)
                end

                updateMenu()
			else
				if Config.Notification == 'codem-notification' then
                	TriggerEvent('codem-notification:Create', "You are not gang member!", 'error', 'Lobby Notification', 5000)
				elseif Config.Notification == 'qbcore' then
					TriggerEvent('QBCore:Notify', "You are not gang member!", "error")
				end
            end
        end, Config.GangScript)
    end
end

updateMenu()
 

-- Target zone
local zoneId = ox_target:addBoxZone({
	coords = Config.TargetZone,
	size = vec3(1, 1, 1),
	rotation = 0,
	options = {
		{
			name = 'open_menu',
			label = 'Open beef world menu',
			icon = 'fas fa-gun',
			onSelect = function()
				lib.showContext('beefworld_menu')
			end
		}
	}
})


-- Create peds 
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		for k,v in pairs(Config.PedList) do
			local playerCoords = GetEntityCoords(PlayerPedId())
			local distance = #(playerCoords - v.coords.xyz)

			if distance < Config.DistanceSpawn and not spawnedPeds[k] then
				local spawnedPed = NearPed(v.model, v.coords, v.gender, v.animDict, v.animName, v.scenario)
				spawnedPeds[k] = { spawnedPed = spawnedPed }
			end

			if distance >= Config.DistanceSpawn and spawnedPeds[k] then
				if Config.FadeIn then
					for i = 255, 0, -51 do
						Citizen.Wait(50)
						SetEntityAlpha(spawnedPeds[k].spawnedPed, i, false)
					end
				end
				DeletePed(spawnedPeds[k].spawnedPed)
				spawnedPeds[k] = nil
			end
		end
	end
end)

function NearPed(model, coords, gender, animDict, animName, scenario)
	RequestModel(model)
	while not HasModelLoaded(model) do
		Citizen.Wait(50)
	end

	spawnedPed = CreatePed(4, model, coords.x, coords.y, coords.z- 1.0, coords.w, false, true)
	SetEntityAlpha(spawnedPed, 0, false)
	FreezeEntityPosition(spawnedPed, true)
	SetEntityInvincible(spawnedPed, true)
	SetBlockingOfNonTemporaryEvents(spawnedPed, true)

	if animDict and animName then
		RequestAnimDict(animDict)
		while not HasAnimDictLoaded(animDict) do
			Citizen.Wait(50)
		end

		TaskPlayAnim(spawnedPed, animDict, animName, 8.0, 0, -1, 1, 0, 0, 0)
	end

    if scenario then
        TaskStartScenarioInPlace(spawnedPed, scenario, 0, true)
    end

	if Config.FadeIn then
		for i = 0, 255, 51 do
			Citizen.Wait(50)
			SetEntityAlpha(spawnedPed, i, false)
		end
	end

	return spawnedPed
end