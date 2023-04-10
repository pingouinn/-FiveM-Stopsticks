-------------------
-- Synced Events --
-------------------
    
	RegisterNetEvent("stopstick:server:sync")
	AddEventHandler("stopstick:server:sync", function(netId, decor, value)
		TriggerClientEvent("stopstick:client:sync", -1, netId, decor, value)
	end)

	RegisterNetEvent("stopstick:server:doors")
	AddEventHandler("stopstick:server:doors", function(owner, veh, bool)
		TriggerClientEvent("stopstick:client:doors", owner, veh, bool)
	end)

	RegisterNetEvent("stopstick:server:suppStick")
	AddEventHandler("stopstick:server:suppStick", function(entId)
		DeleteEntity(NetworkGetEntityFromNetworkId(entId))
	end)