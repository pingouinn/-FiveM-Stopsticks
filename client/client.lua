---------------
-- Variables --
---------------

-- World related variables

ped = nil
pos = nil
veh = 0
closest = 0

-- Data variables

local tires = {
	{bone = "wheel_lf", index = 0},
	{bone = "wheel_rf", index = 1},
	{bone = "wheel_lm", index = 2},
	{bone = "wheel_rm", index = 3},
	{bone = "wheel_lr", index = 4},
	{bone = "wheel_rr", index = 5}
}
stick = GetHashKey("WEAPON_GOLFCLUB")

-- State variables

newCheck2 = true
local auth = false
local newCheck = true

-- GFX Scaleform and memory load functions

LoadModel = function(model)
	while not HasModelLoaded(model) do
		RequestModel(model)
		
		Citizen.Wait(1)
	end
end

LoadAnim = function(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		
		Citizen.Wait(1)
	end
end

--------------------
-- Main functions --
--------------------

Citizen.CreateThread(function()

	-- Decorator
	DecorRegister("state", 2)

	-- Main loop
	while true do

		-- Get ped variables
		ped = PlayerPedId()
		pos = GetEntityCoords(ped)

		-- Check if player is authorized every 3s
		if newCheck then 
			auth = jobCheck()
			newCheck = false
			Citizen.SetTimeout(3000, function()
				newCheck = true
			end) 
		end

		-- Tire bursting logics
		if IsPedInAnyVehicle(ped, false) then
			threshold = 2 
			local vehicle = GetVehiclePedIsIn(ped, false)
			if GetPedInVehicleSeat(vehicle, -1) == ped then
				local vehiclePos = GetEntityCoords(vehicle, false)
				local spikes = GetClosestObjectOfType(vehiclePos.x, vehiclePos.y, vehiclePos.z, 80.0, GetHashKey('w_me_gclub'), 1, 1, 1)

				-- Check if a spike exists near
				if spikes ~= 0 then
					local spikePos = GetEntityCoords(spikes, false)

					-- Loop through spikes table
					for a = 1, #tires do
						local tirePos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, tires[a].bone))
						local distance = #(vector3(tirePos.x, tirePos.y, tirePos.z) - vector3(spikePos.x, spikePos.y, spikePos.z))
		
						if distance < 1.0 then
							if not IsVehicleTyreBurst(vehicle, tires[a].index, true) or IsVehicleTyreBurst(vehicle, tires[a].index, false) then
								SetVehicleTyreBurst(vehicle, tires[a].index, false, 1000.0)
							end
						end
					end
				end
			end
		else 
			threshold = 200
		end

		if auth then 
			if not IsPedInAnyVehicle(ped, false) then

				-- Check closest spike, closest vehicle, every 400ms
				if newCheck2 then

					closest = 0
					if GetSelectedPedWeapon(ped) ~= stick then
						closest = GetClosestObjectOfType(pos.x, pos.y, pos.z, 1.1, GetHashKey('w_me_gclub'), false, false, false)
					end 
	
					for i,_ in pairs(cfg.vehs) do
						veh = GetClosestVehicle(pos.x, pos.y, pos.z, 7.0, i, 70, 0)
						if veh ~= 0 then
							break
						end	
					end

					newCheck2 = false
					Citizen.SetTimeout(400, function()
						newCheck2 = true
					end)
				end

				-- Check is near to a spike, able to take it
				if closest ~= 0 then
					threshold = 2 
					if GetSelectedPedWeapon(ped) ~= stick then
						hintToDisplay("~y~"..cfg.lang.press..' '..cfg.keyName..' '..cfg.lang.getStick)		
						if GrantAccessControl(0, cfg.key) then
							LoadAnim("random@domestic")
							TaskPlayAnim(ped, 'random@domestic', 'pickup_low', 8.0, 8.0, -1, 50, 0, false, false, false) 
							Wait(900)
							TriggerServerEvent("stopstick:server:suppStick", ObjToNet(closest))
							stopStick()	
						end
					end
				elseif veh ~= 0 then
					threshold = 2 
					local bPos = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, 'boot'))                    
					if #(pos - bPos) < 1.3 then
						if cfg.openDoors and GetVehicleDoorAngleRatio(veh, 5) < 0.1 then
							hintToDisplay('~y~'..cfg.lang.press..' '..cfg.keyName2..' '..cfg.lang.openDoors)
							if GrantAccessControl(0, cfg.key2) then
								TriggerServerEvent('stopstick:server:doors', GetPlayerServerId(NetworkGetEntityOwner(veh)), VehToNet(veh), true)
							end
						else
							if cfg.openDoors then
								hintToDisplay('~y~'..cfg.lang.press..' '..cfg.keyName..' '..cfg.lang.getStick..'\n'..cfg.lang.press..' '..cfg.keyName2..' '..cfg.lang.closeDoors)
								if GrantAccessControl(0, cfg.key2) then 
									TriggerServerEvent('stopstick:server:doors', GetPlayerServerId(NetworkGetEntityOwner(veh)), VehToNet(veh), false)
								end
							else
								hintToDisplay('~y~'..cfg.lang.press..' '..cfg.keyName..' '..cfg.lang.getStick)
							end
							if GrantAccessControl(0, cfg.key) then 
								if DoesDecorAllow(veh, 'state') then
									SyncDecorOverNet(veh, 'state', false)
									stopStick()						
								else
									ShowNotification("~r~"..cfg.lang.noMore)
								end
							end
						end
					end
				else
					threshold = 200
				end
			end
		end
		
		Citizen.Wait(threshold)
	end
end)
