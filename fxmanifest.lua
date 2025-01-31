fx_version 'cerulean'
game 'gta5'

author 'YuvalWeb'
description 'Baisc script for two diffrent lobbies'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

client_scripts {
    'client/*.lua',
}

server_scripts {
    'server/*.lua',
}
lua54 'yes'