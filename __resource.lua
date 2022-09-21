fx_version 'adamant'

game 'gta5'

description 'CubixLife Hochzeit by NeonCubix'

version '1.0.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/de.lua',
	'config.lua',
	'server/main.lua',
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/de.lua',
	'config.lua',
	'client/main.lua',
}

dependencies {
	'es_extended',
}