fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'

author 'Pingouin#8843'
description 'A simple ressource to use hose reels'
version '1.5.1'


escrow_ignore {
	'config.lua',
	'client/cl_utils.lua',
}

shared_scripts {
    'config.lua',
}

client_scripts {
	'client/*.lua',
}

server_scripts {
	'server/*.lua',
}