# Native Satchel

> [!IMPORTANT]
> This documentation, much like the resource, is currently in an alpha state and is not final. The data types, events, and triggers described in this documentation may change in future versions as the project evolves.

## Overview

Native Satchel is a RedM resource that provides a fully native implementation of the satchel UI for Red Dead Redemption 2 multiplayer servers. This resource allows developers to create custom inventory systems using the game's original satchel interface, complete with categories, folders, item management, and all the visual elements players expect from the authentic Red Dead experience.

Unlike traditional web-based or custom UI implementations, Native Satchel leverages the game's built-in interface systems to provide seamless integration with the player's existing UI experience.

📖 **[Jump to Documentation](#types)**

## Feature Requests

If you're missing functionality or have ideas for new features that would improve Native Satchel, please don't hesitate to open an issue on the [GitHub repository](https://github.com/Senexis/RedM-Native-Satchel/issues). Feature requests from the community are always welcome, and feedback about use cases and requirements helps shape the direction of this project!

## License & Monetization

This resource is provided free of charge and represents countless hours of development work. Like most RedM resources, it builds upon the game's existing functionality. While the RedM community is fantastic and there's certainly a space for paid resources, there's unfortunately a trend of knowledge being gatekept behind paywalls, making important development knowledge harder to access for the community. You're absolutely welcome to use Native Satchel as a base for your own projects, but please pay close attention to the license terms.

This is simply a request, not a threat or anything of that nature - since the code is open source and properly licensed, you are free to do with it what you want as long as it's permitted by the license. As stated in the GNU GPL v3 license, if you distribute modified versions of this work, you must share your changes under the same open source license. This ensures that improvements benefit the entire community rather than being locked behind paywalls. The goal is to foster collaboration and shared knowledge, not to enable profiteering from freely contributed work. Ultimately, everyone should strive to make the whole of RedM a better place for all players and developers.

Native Satchel is open-sourced software licensed under the [GNU GPL v3](https://github.com/Senexis/RedM-Native-Satchel/blob/main/LICENSE.md).

## Types

The Native Satchel system is built around three main data types that define how items, categories, and folders are structured and displayed in the satchel interface. Understanding these types is essential for implementing a custom inventory system.

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

    -- The category the item belongs to, see the category type
    category = "provisions",

    -- Optional. Groups the item in a folder, see the folder type
    folder = "big_game",

    -- Optional. Whether the item can be discarded
    discardable = false,

    -- Optional. When set to a string, we'll use catalog_sp and catalog_mp to fill UI data for you
    catalog = "CONSUMABLE_BIG_GAME_MEAT_COOKED",

    -- Optional. Sets the display label for the item
    -- TODO: Remove joaat requirement (as string is possible)
    name = joaat("POSTER_PL_ARTHUR_NAME"),

    -- Optional. Sets the description label for the item
    -- TODO: Remove joaat requirement (as string is possible)
    description = 0xC51209D8,

    -- Optional. Whether to mark the item as special, which gives the texture a yellow hue
    special = true,

    -- Optional. The amount of quality stars to show on the item, can be 0, 1, 2 or 3 stars
    stars = 3,

    -- Optional. The texture directory for the icon of this item
    txd = joaat("toasts_mp_generic"),

    -- Optional. The texture to use for the icon of this item
    texture = joaat("toast_mp_standalone_sp"),

    -- Optional. A list of effect IDs to show as icons in the description of the item
    -- TODO: Simplify by using { type = value }
    effects = { joaat("EFFECT_HEALTH_CORE_MINUS_2") },

    -- Optional. Whether the item can be dropped
    droppable = false,

    -- Optional. Whether the item can be broken down
    breakable = false,

    -- Optional. Whether the item can be cooked
    cookable = false,

    -- Optional. Whether the item can be used
    usable = false,

    -- Optional. Whether the item can be drunk
    drinkable = false,

    -- Optional. Whether the item can be eaten
    edible = false,

    -- Optional. Whether the item can be read
    readable = false,
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

Triggers are client-side events that allow you to control the satchel's behavior and manage items programmatically. These events provide the core functionality for opening/closing the satchel, synchronizing data, and performing item operations.

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

Events are fired automatically by the Native Satchel system when specific actions occur. You can listen to these events to implement custom logic, such as saving inventory changes, logging player actions, or triggering server-side operations when players interact with items.

### General Events

```lua
AddEventHandler("native_satchel:satchel_opened", function()
    print("This event is fired when the player opens the satchel")
end)

AddEventHandler("native_satchel:satchel_closed", function()
    print("This event is fired when the player closes the satchel")
end)

AddEventHandler("native_satchel:category_changed", function(categoryId)
    print("This event is fired when the player changes the category, it has ID", categoryId)
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

AddEventHandler("native_satchel:item_dropped", function(itemId)
    print("This event is fired when the player drops an item, it has ID", itemId)
end)

AddEventHandler("native_satchel:item_discarded", function(itemId)
    print("This event is fired when the player discards an item, it has ID", itemId)
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
    print("This event is fired when the player opens a folder, it has ID", folderId)
end)

AddEventHandler("native_satchel:folder_focused", function(folderId)
    print("This event is fired when the player focuses on a folder, it has ID", folderId)
end)
```

## Attribution

This project builds upon the hard work and research of many talented individuals in the RedM community. Their contributions made this native satchel implementation possible:

- [aaron1a12's Satchel Research](https://github.com/aaron1a12/wild/blob/main/wild-satchel/client/cl_satchel_native_research.lua)
- [alloc8or's Native DB](https://alloc8or.re/rdr3/nativedb/)
- [femga's RDR3 Discoveries](https://github.com/femga/rdr3_discoveries/)
- [gottfriedleibniz's Data View implementation](https://github.com/gottfriedleibniz)
- [MagnarRDC's Support](https://x.com/magnarrdc)

## Contributing

Thank you for considering contributing to Native Satchel! Please note that this project is released with a [Contributor Covenant Code of Conduct](https://github.com/Senexis/RedM-Native-Satchel/blob/main/CODE_OF_CONDUCT.md). By participating in any way in this project, you agree to abide by its terms.

Before contributing, please take a moment to read the [Contribution Guide](https://github.com/Senexis/RedM-Native-Satchel/blob/main/CONTRIBUTING.md) to understand the development process and how to contribute.
