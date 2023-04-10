function SyncDecorOverNet(ent, decor, value)
	local netHandle = NetworkGetNetworkIdFromEntity(ent)
	SetNetworkIdExistsOnAllMachines(netHandle, true)
	TriggerServerEvent("stopstick:server:sync", netHandle, decor, value)
end

function DoesDecorAllow(ent, decor)
	if DecorExistOn(ent, decor) then
		if not DecorGetBool(ent, decor) then
			return false
		end
	end
	return true
end

RegisterNetEvent("stopstick:client:sync")
AddEventHandler("stopstick:client:sync",function(ent, decor, val)
	local ent = NetworkGetEntityFromNetworkId(ent)
	if DoesEntityExist(ent) then
		DecorSetBool(ent, decor, val) 
	end
end)

RegisterNetEvent('stopstick:client:doors')
AddEventHandler('stopstick:client:doors', function(veh, open)
	local veh = NetworkGetEntityFromNetworkId(veh)
	if open then
		SetVehicleDoorOpen(veh, 5, false, false)
	else 
		SetVehicleDoorShut(veh, 5, false, false)
	end
end)