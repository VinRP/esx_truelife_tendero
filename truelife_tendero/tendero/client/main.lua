ESX = nil

local paused = false
local isInService = false
local PlayerData = nil
local hasAlreadyEnteredMarker = false
local lastZone = nil
local CurrentAction = nil
local CurrentActionMsg = ''

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(5)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('tendero:clearjob')
AddEventHandler('tendero:clearjob', function(platenumber)
	if platenumb == platenumber then
		trashcollectionpos = nil
		bagsoftrash = nil
		work_truck = nil
		trashcollection = false
		truckdeposit = false
		CurrentAction = nil
		CollectionAction = nil
		paused = false
	end
end)

function MenuCloakRoom()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'cloakroom',
		{
			title    = _U('cloakroom'),
			elements = {
				{label = _U('job_wear'), value = 'job_wear'},
				{label = _U('citizen_wear'), value = 'citizen_wear'}
			}
		},
		function(data, menu)
			if data.current.value == 'citizen_wear' then
				isInService = false
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
					local model = nil

					if skin.sex == 0 then
						model = GetHashKey("mp_m_freemode_01")
					else
						model = GetHashKey("mp_f_freemode_01")
					end

						RequestModel(model)
					while not HasModelLoaded(model) do
						RequestModel(model)
						Citizen.Wait(1)
					end

						SetPlayerModel(PlayerId(), model)
						SetModelAsNoLongerNeeded(model)

						TriggerEvent('skinchanger:loadSkin', skin)
						TriggerEvent('esx:restoreLoadout')
			end)
		end
			if data.current.value == 'job_wear' then
				isInService = true
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
	    			if skin.sex == 0 then
	    				TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
					else
	    				TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)

					RequestModel(model)
					while not HasModelLoaded(model) do
					RequestModel(model)
					Citizen.Wait(0)
					end
						SetPlayerModel(PlayerId(), model)
						SetModelAsNoLongerNeeded(model)
					end
				end)
			end	
			menu.close()
		end,
		function(data, menu)
			menu.close()
		end
	)
end

function IsJobtendero()
	if PlayerData ~= nil then
		local IsJobtendero = false
		if PlayerData.job.name ~= nil and PlayerData.job.name == 'tendero' then
			IsJobtendero = true
		end
		return IsJobtendero
	end
end

AddEventHandler('tendero:hasEnteredMarker', function(zone)
	local playerPed = GetPlayerPed(-1)

	if zone == 'CloakRoom' or zone == 'CloakRoom2' then
		MenuCloakRoom()
	end
end)

AddEventHandler('tendero:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()    
		CurrentAction = nil
		CurrentActionMsg = ''
end)

Citizen.CreateThread(function()
	while true do
		Wait(0)
		local coords = GetEntityCoords(GetPlayerPed(-1))
		for k,v in pairs(Config.Cloakroom) do
			if(IsJobtendero() and v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
				DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(0)

		if not paused then 

			if IsJobtendero() then

				local coords      = GetEntityCoords(GetPlayerPed(-1))
				local isInMarker  = false
				local currentZone = nil

				for k,v in pairs(Config.Cloakroom) do
					if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
						isInMarker  = true
						currentZone = k
					end
				end

				if isInMarker and not hasAlreadyEnteredMarker then
					hasAlreadyEnteredMarker = true
					lastZone                = currentZone
					TriggerEvent('tendero:hasEnteredMarker', currentZone)
				end

				if not isInMarker and hasAlreadyEnteredMarker then
					hasAlreadyEnteredMarker = false
					TriggerEvent('tendero:hasExitedMarker', lastZone)
				end
			end
		end
	end  
end)