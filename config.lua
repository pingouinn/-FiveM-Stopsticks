-----------------
-- Config file --
-----------------

cfg = {}

-------------------- Framework -----------------------

-- You can still use the script as standalone, without any framework !

-- Do you want to use ESX ?

cfg.ESX = false 

-- Do you want to use QBCore ?

cfg.QB = false 

-- What is the name of the job ?

cfg.jobName = 'police'


------------------- Miscellaneous --------------------

-- Vehicles to detect :
	-- You can add or remove a vehicle here 
	-- Add the model name in 'GetHashKey("......")' and "= true"

cfg.vehs = {
	[GetHashKey('police')] = true,
	[GetHashKey('buffalo')] = true,
}

-- Do you want to open the trunk when you take the stopstick ? (set to false if you already have a script to do this)

cfg.openDoors = true

-------------------- Keybinds ------------------------

-- Key to press to interact with a stopstick.
-- Key "E" (38) by default
-- Site listing controls: https://docs.fivem.net/docs/game-references/controls/#controls
-- KEY NUMBER = INDEX COLUMN

cfg.key = 38

-- Name of the key to interact with a stopstick
-- ~INPUT_CONTEXT~ ("E" key) by default
-- Site listing control names: https://docs.fivem.net/docs/game-references/controls/#controls
-- KEY NAME = NAME COLUMN

cfg.keyName = '~INPUT_CONTEXT~'


-- Key to open trunk.
-- Key "X" (73) by default
-- Site listing controls: https://docs.fivem.net/docs/game-references/controls/#controls
-- KEY NUMBER = INDEX COLUMN

cfg.key2 = 73

-- Name of the key to open trunk.
-- ~INPUT_CONTEXT~ ("X" key) by default
-- Site listing control names: https://docs.fivem.net/docs/game-references/controls/#controls
-- KEY NAME = NAME COLUMN

cfg.keyName2 = '~INPUT_VEH_DUCK~'

------------------ Languages ---------------------

cfg.lang = {
    press = "Press",
	getStick = "to take a stopstick.",
	storeStick = 'to store the stopstick.',
	release = "to place the stopstick.",
	openDoors = "to open the trunk.",
	closeDoors = "to close the trunk.",
	noMore = "You can't take more stopsticks.",
}