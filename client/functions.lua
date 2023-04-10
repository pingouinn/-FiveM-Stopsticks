-- Simple function to avoids control spamming

local justUsed = false 
function GrantAccessControl(ktype, key)
	if IsControlJustPressed(ktype, key) and not justUsed then
		Citizen.SetTimeout(400, function()
			justUsed = false
		end)
		justUsed = true
		return true
	end
	return false
end

local checkAgain = true
function stopStick()
 	
	-- Give the stick to the player
	if HasPedGotWeapon(ped, stick, 0) or GetSelectedPedWeapon(ped) == stick then
        SetCurrentPedWeapon(ped, stick, 1)
    else
        GiveWeaponToPed(ped, stick, 300, 0, 1)
        SetCurrentPedWeapon(ped, stick, 1)
    end

	Wait(50)
	ClearPedTasks(ped)
	
	while GetSelectedPedWeapon(ped) == stick do
		pos = GetEntityCoords(ped)

		-- Disable harmful controls
		DisableControlAction(0,24,true) 
        DisableControlAction(0,25,true) 
	    DisableControlAction(0,263,true) 
        DisableControlAction(0,264,true)                                                   
        DisableControlAction(0,257,true) 
        DisableControlAction(0,140,true) 
        DisableControlAction(0,141,true) 
        DisableControlAction(0,142,true) 
        DisableControlAction(0,143,true) 


		-- Check for closest vehicle, every 400ms
		if checkAgain then
			veh = GetClosestVehicle(pos, 7.0, 0, 70)
			if cfg.vehs[GetEntityModel(veh)] == nil then
				veh = 0
			end

			checkAgain = false
			Citizen.SetTimeout(400, function()
				checkAgain = true
			end)
		end

		--print(veh)
		if veh ~= 0 then
			local bPos = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, 'boot'))
			if #(pos - bPos) < 1.3 then
				hintToDisplay('~y~'..cfg.lang.press.." "..cfg.keyName.." "..cfg.lang.storeStick)
				if GrantAccessControl(0, cfg.key) then
					RemoveWeaponFromPed(ped, stick)
					SyncDecorOverNet(veh, 'state', true)
					break
				end
			else 
				hintToDisplay('~y~'..cfg.lang.press.." "..cfg.keyName.." "..cfg.lang.release)
				if GrantAccessControl(0, cfg.key) then	
					createStick()  
					break
				end
			end
		else 
			hintToDisplay('~y~'..cfg.lang.press.." "..cfg.keyName.." "..cfg.lang.release)
			if GrantAccessControl(0, cfg.key) then	
				createStick()  
				break
			end
		end

		Citizen.Wait(5)
	end		
end

function createStick()
	LoadModel('w_me_gclub')	
	LoadAnim("random@domestic")
	TaskPlayAnim(ped, 'random@domestic', 'pickup_low', 8.0, 8.0, -1, 50, 0, false, false, false) 

	RemoveWeaponFromPed(ped, baton)		
	Wait(900)
	ClearPedTasks(ped)

    local spike = CreateObject(GetHashKey('w_me_gclub'), GetOffsetFromEntityInWorldCoords(ped, 0.0, 2.0, -1.0), 1, 1, 1)
    SetEntityHeading(spike, GetEntityHeading(ped))
	PlaceObjectOnGroundProperly(spike)
	SetEntityRotation(spike, 92.0, GetEntityHeading(ped), GetEntityHeading(ped), false, true)
	FreezeEntityPosition(spike, true)

	RemoveWeaponFromPed(ped, stick)
end