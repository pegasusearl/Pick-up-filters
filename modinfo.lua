name = "Pick-up Filters (Alternate)"

author = "Skrzelik"
version = "2.2.1"

forumthread = ""
description = "Lets you disable picking flowers with spacebar, prioritize chopping trees over picking wood and vice versa, add any item to blacklist/whitelist"

api_version = 10

icon_atlas = "modicon.xml"
icon = "modicon.tex"

dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false
dst_compatible = true


all_clients_require_mod = false
client_only_mod = true
server_filter_tags = {}

local keys = 
{
	{description = "None", data = 0},
	{description = "F1", data = 282},
	{description = "F2", data = 283},
	{description = "F3", data = 284},
	{description = "F4", data = 285},
	{description = "F5", data = 286},
	{description = "F6", data = 287},
	{description = "F7", data = 288},
	{description = "F8", data = 289},
	{description = "F9", data = 290},
	{description = "F10", data = 291},
	{description = "F11", data = 292},
	{description = "F12", data = 293},
	{description = "A", data = 97},
	{description = "B", data = 98},
	{description = "C", data = 99},
	{description = "D", data = 100},
	{description = "E", data = 101},
	{description = "F", data = 102},
	{description = "G", data = 103},
	{description = "H", data = 104},
	{description = "I", data = 105},
	{description = "J", data = 106},
	{description = "K", data = 107},
	{description = "L", data = 108},
	{description = "M", data = 109},
	{description = "N", data = 110},
	{description = "O", data = 111},
	{description = "P", data = 112},
	{description = "Q", data = 113},
	{description = "R", data = 114},
	{description = "S", data = 115},
	{description = "T", data = 116},
	{description = "U", data = 117},
	{description = "V", data = 118},
	{description = "W", data = 119},
	{description = "X", data = 120},
	{description = "Y", data = 121},
	{description = "Z", data = 122},
	
	{description = "Backspace", data = 8},
	{description = "Tab", data = 9},
	{description = "Shift", data = 16},
	{description = "Ctrl", data = 17},
	{description = "Alt", data = 18},
	{description = "Left Arrow", data = 37},
	{description = "Up Arrow", data = 38},
	{description = "Right Arrow", data = 39},
	{description = "Down Arrow", data = 40},
}

configuration_options = 
{
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	{
        name = "flower_pickup",
        label = "Flowers pickup",
        hover = "Disable picking flowers with spacebar?",
        options =
        {
			{description = "Default", data = 1, hover = "Flowers are picked normally"},
            {description = "No flowers", data = 0, hover = "Can no longer pick flowers with spacebar"},
        },
        default = 0,
    },
    {
        name = "winter_food_pickup",
        label = "winter feast Foods",
        hover = "Pick with spacebar?",
        options =
        {
			{description = "Pick", data = 1, hover = "Pick normally."},
            {description = "Don't pick", data = 0, hover = "Do not pick them."},
        },
        default = 0,
    },
    {
        name = "winter_ornament_pickup",
        label = "winter feast Ornaments",
        hover = "Pick with spacebar?",
        options =
        {
			{description = "Pick", data = 1, hover = "Pick normally."},
            {description = "Don't pick", data = 0, hover = "Do not pick them."},
        },
        default = 1,
    },
	{
        name = "pickup_order",
        label = "Pickup Order",
        hover = "Pick up items before attempting any other action?",
        options =
        {
			{description = "Default", data = 1, hover = ""},
            {description = "Pick up first", data = 2, hover = "Picks items before other actions"},
			{description = "Pick up last", data = 0, hover = "Picks items when no other action is available"},
        },
        default = 1,
    },
	{
        name = "meat_pickup",
        label = "Meat Priority",
        hover = "Determins whether to pickup meat first or last (can be changed in game with key binding)",
        options =
        {
			{description = "Default", data = 1, hover = ""},
            {description = "Meat first", data = 2, hover = "Picks meat before picking everything else"},
			{description = "No meat", data = 0, hover = "Can no longer pick meat with spacebar (needs to point and click)"},
        },
        default = 1,
    },
    {
        name = "lantern_last",
        label = "Pick lantern last",
        hover = "Not implemented yet",
        options =
        {
			{description = "Disabled", data = 0, hover = "Default settings"},
            {description = "Enabled", data = 1, hover = "Lantern will be picked after later."},
        },
        default = 1,
    },
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	{
        name = "change_pickup",
        label = "Change Pickup order key",
        hover = "Sets key for cycling through the pickup order options",
        options = keys,
        default = 0,
    },
	{
        name = "change_meat",
        label = "Change Meat priority key",
        hover = "Sets key for cycling through the meat picking options",
        options = keys,
        default = 0,
    },
	{
        name = "blacklist_key",
        label = "Blacklist key",
        hover = "Key to add/remove items from blacklist",
        options = keys,
        default = 0,
    },
	{
        name = "whitelist_key",
        label = "Whitelist key",
        hover = "Key to add/remove items from whitelist",
        options = keys,
        default = 0,
    },
	{
        name = "save_enabled",
        label = "Save settings",
        hover = "Should changes made to blacklist/whitelist be saved and loaded on new game?",
        options =
        {
			{description = "Yes", data = 1},
            {description = "No", data = 0},
        },
        default = 1,
    },
}
