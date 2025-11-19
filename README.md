# Native Satchel
A work-in-progress implementation of the truly native satch UI.

## Items
TODO: Write better documentation

```lua
local item = {
    -- Any string identifier you want to internally use
    id = "big_game_meat_cooked",

    -- The amount of items for that specific item
    -- Todo: Do we keep this or count in add_item?
    count = 5,

    -- Optional. The maximum amount of items for that specific item
    -- This affects the footer text depending on the count and maxCount
    maxCount = nil,

    -- Optional. Whether to mark the item as special, which gives the texture a yellow hue
    special = false,

    -- Optional. The amount of quality stars to show on the item, can be 0, 1, 2 or 3 stars
    stars = 0,

    -- The category the item belongs to, also see "Satchel.categories"
    category = "provisions",

    -- Optional. Groups the item in a folder, also see "Satchel.folders"
    folder = "big_game",

    -- Optional. When set to a string, we'll use catalog_sp and catalog_mp to fill UI data for you
    catalog = "CONSUMABLE_BIG_GAME_MEAT_COOKED",
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

-- Synchronizes the satchel to the given item table
TriggerEvent("native_satchel:synchronize", items)
```

### Item Triggers

```lua
-- Adds the item to the satchel
-- Todo: Do we keep count or item property?
TriggerEvent("native_satchel:add_item", item, count)

-- Removes an item from the satchel by ID
TriggerEvent("native_satchel:remove_item", itemId, count)

-- Removes all of an item from the satchel by ID
TriggerEvent("native_satchel:remove_item_all", itemId)
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
