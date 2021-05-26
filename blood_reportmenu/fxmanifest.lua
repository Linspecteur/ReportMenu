fx_version "adamant"
games { "gta5" };

client_scripts {
    "RageUI/RMenu.lua",
    "RageUI/menu/RageUI.lua",
    "RageUI/menu/Menu.lua",
    "RageUI/menu/MenuController.lua",
    "RageUI/components/*.lua",
    "RageUI/menu/elements/*.lua",
    "RageUI/menu/items/*.lua",
    "RageUI/menu/panels/*.lua",
    "RageUI/menu/panels/*.lua",
    "RageUI/menu/windows/*.lua",
    "RageUI/menu/Function.lua",

    "client/menu.lua",
    "client/functions.lua",
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "server.lua",
}