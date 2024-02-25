fx_version("cerulean")
game("gta5")

description("Gang script initially created for Mirage Roleplay")
author("Epyi Scripts")
version("1.0.0")
lua54("yes")

shared_scripts({
	"config.lua",
	"shared/locale.lua",
	"locales/*.lua",
	"@es_extended/imports.lua"
})

client_scripts({
	"src/RMenu.lua",
	"src/menu/RageUI.lua",
	"src/menu/Menu.lua",
	"src/menu/MenuController.lua",
	"src/components/*.lua",
	"src/menu/elements/*.lua",
	"src/menu/items/*.lua",
	"src/menu/panels/*.lua",
	"src/menu/panels/*.lua",
	"src/menu/windows/*.lua",

	"client/*.lua"
})

server_scripts({
	"@oxmysql/lib/MySQL.lua",
	"server/*.lua",
})

dependencies({
	"es_extended",
	"oxmysql",
	"ox_inventory",
	-- "epyi_garage",
	"ox_target"

})