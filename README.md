# Native Satchel

> [!IMPORTANT]
> This documentation, much like the resource, is currently in an alpha state and is not final.

## Types
TODO: Write better documentation

### Items

```lua
local item = {
    -- Any string identifier you want to internally use
    id = "big_game_meat_cooked",

    -- The amount of items for that specific item
    count = 5,

    -- Optional. The maximum amount of items for that specific item
    -- This affects the footer text depending on the count and maxCount
    maxCount = nil,

    -- Optional. Whether to mark the item as special, which gives the texture a yellow hue
    special = false,

    -- Optional. The amount of quality stars to show on the item, can be 0, 1, 2 or 3 stars
    stars = 0,

    -- The category the item belongs to, see the category type
    category = "provisions",

    -- Optional. Groups the item in a folder, see the folder type
    folder = "big_game",

    -- Optional. When set to a string, we'll use catalog_sp and catalog_mp to fill UI data for you
    catalog = "CONSUMABLE_BIG_GAME_MEAT_COOKED",

    -- Optional. Sets the display label for the item
    -- Todo: Remove joaat requirement (as string is possible)
    name = joaat("POSTER_PL_ARTHUR_NAME"),

    -- Optional. Sets the description label for the item
    -- Todo: Remove joaat requirement (as string is possible)
    description = 0xC51209D8,

    -- Optional. When true, marks the item as special giving it a yellow hue
    special = true,

    -- Optional. When set to 1 through 3, will display quality stars on the item
    stars = 3,

    -- Optional. The texture directory for the icon of this item
    txd = joaat("toasts_mp_generic"),

    -- Optional. The texture to use for the icon of this item
    texture = joaat("toast_mp_standalone_sp"),

    -- Optional. A list of effect IDs to show as icons in the description of the item
    -- Todo: Simplify by using { type = value }
    effects = { joaat("EFFECT_HEALTH_CORE_MINUS_2") },

    -- TODO: Properties for prompts shown
}
```

### Categories

```lua
local category = { 
    -- Any string identifier you want to internally use
    id = "recent",

    -- Whether the category lists the 48 most recently added items, does not include folders
    recent = true,

    -- The hash of the texture to use
    -- Due to UI limitations it has to be in the "satchel_textures" dictionary
    texture = joaat("satchel_nav_all"),

    -- The hash of the UI label to use for the category, in this example "Recent"
    label = 0x504364F1,
}
```

### Folders

```lua
local folder = {
    -- Any string identifier you want to internally use
    id = "arrowheads",

    -- Which category the folder belongs to, see the category type
    category = "valuables",

    -- The hash of the texture dictionary to use
    txd = joaat("inventory_items_mp"),

    -- The hash of the texture to use
    texture = joaat("provision_arrowhead_set"),

    -- The hash of the UI label to use for the category
    label = joaat("CI_TAG_FOLDER_COLLECTOR_ARROWHEADS"),

    -- The hash of the UI description to use for the category
    description = joaat("CI_TAG_FOLDER_COLLECTOR_ARROWHEADS_DESC"),
}
```

## Triggers
TODO: Write better documentation

### General Triggers

```lua
-- Forces the satchel to open
TriggerEvent("native_satchel:open_satchel")

-- Forces the satchel to close
TriggerEvent("native_satchel:close_satchel")

-- Synchronizes the satchel to the given item table, see the item type above
TriggerEvent("native_satchel:synchronize", items)
```

### Item Triggers

```lua
-- Adds a new item to the satchel, see the item type above
TriggerEvent("native_satchel:add_item", item)

-- Increments an item from the satchel by count by ID
TriggerEvent("native_satchel:increment_item", itemId, count)

-- Decrements an item from the satchel by count by ID
TriggerEvent("native_satchel:decrement_item", itemId, count)

-- Removes all of an item from the satchel by ID
TriggerEvent("native_satchel:remove_item", itemId)
```

## Events
TODO: Write better documentation

### General Events

```lua
AddEventHandler("native_satchel:satchel_opened", function()
    print("This event is fired when the player opens the satchel")
end)

AddEventHandler("native_satchel:satchel_closed", function()
    print("This event is fired when the player closes the satchel")
end)
```

### Item Events

```lua
AddEventHandler("native_satchel:item_used", function(itemId)
    print("This event is fired when the player uses an item, it has ID", itemId)
end)

AddEventHandler("native_satchel:item_broken", function(itemId)
    print("This event is fired when the player breaks down an item, it has ID", itemId)
end)

AddEventHandler("native_satchel:item_discarded", function(itemId)
    print("This event is fired when the player discards an item, it has ID", itemId)
end)

AddEventHandler("native_satchel:item_discarded_all", function(itemId)
    print("This event is fired when the player discards all of an item, it has ID", itemId)
end)

AddEventHandler("native_satchel:item_sent_all", function(itemId)
    print("This event is fired when the player sends an item, it has ID", itemId)
end)

AddEventHandler("native_satchel:item_focused", function(itemId)
    print("This event is fired when the player focuses on an item, it has ID", itemId)
end)
```

### Folder Events

```lua
AddEventHandler("native_satchel:folder_opened", function(folderId)
    print("This event is fired when the player opens folder, it has ID", folderId)
end)

AddEventHandler("native_satchel:folder_focused", function(folderId)
    print("This event is fired when the player focuses on a folder, it has ID", folderId)
end)
```

## Attribution
TODO: Write proper attribution

- [aaron1a12's Satchel Research](https://github.com/aaron1a12/wild/blob/main/wild-satchel/client/cl_satchel_native_research.lua)
- [alloc8or's Native DB](https://alloc8or.re/rdr3/nativedb/)
- [femga's RDR3 Discoveries](https://github.com/femga/rdr3_discoveries/)
- [gottfriedleibniz's Data View implementation](https://github.com/gottfriedleibniz)
- [MagnarRDC's Support](https://x.com/magnarrdc)

## Contributing
Thank you for considering contributing to Native Satchel! Please note that this project is released with a [Contributor Covenant Code of Conduct](https://github.com/Senexis/RedM-Native-Satchel/blob/main/CODE_OF_CONDUCT.md). By participating in any way in this project, you agree to abide by its terms.

Before contributing, please take a moment to read the [Contribution Guide](https://github.com/Senexis/RedM-Native-Satchel/blob/main/CONTRIBUTING.md) to understand the development process and how to contribute.

## License
Native Satchel is open-sourced software licensed under the [GNU GPL v3](https://github.com/Senexis/RedM-Native-Satchel/blob/main/LICENSE.md).
