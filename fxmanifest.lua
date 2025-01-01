fx_version 'cerulean'
games { 'gta5' }

lua54 'yes'

name 'cdx-newlife'
author 'Walter'

client_scripts {
    'client/client.lua'
}

server_scripts {
    'server/server.lua'
}

shared_scripts {
    'configs/config.lua',
    '@ox_lib/init.lua'
}
