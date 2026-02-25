fx_version "cerulean"
rdr3_warning "I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships."
game "rdr3"

name "Native Satchel"
author "Senexis <https://github.com/Senexis>"
description "A full implementation of the truly native satchel UI"
version "1.0.0"
repository "https://github.com/Senexis/RedM-Native-Satchel"
license "GNU GPL v3"

client_scripts {
    "client/config.lua",
    "client/util_dataview.lua",
    "client/util_items.lua",
    "client/util_ticker.lua",
    "client/satchel_validator.lua",
    "client/satchel_events.lua",
    "client/satchel_navigator.lua",
    "client/satchel_ui.lua",
    "client/satchel_data.lua",
    "client/res_events.lua",
    "client/res_exports.lua",

    -- Remove the line below to disable debug commands and event logging
    "client/debug.lua",
}
