fx_version 'cerulean'
game 'gta5'

description 'Custom Styled Vehicle Spawner with NUI'
author 'SpiritFramework'
version '2.0.0'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
}

server_scripts {
    'server.lua'
}

client_scripts {
    'vehicle_spawner.lua'
}
