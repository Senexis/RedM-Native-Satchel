AddEventHandler("native_satchel:satchel_opened", function(mode)
    print("Satchel opened:", mode)
end)

AddEventHandler("native_satchel:satchel_closed", function(mode)
    print("Satchel closed:", mode)
end)

AddEventHandler("native_satchel:category_changed", function(categoryId)
    print("Category changed:", categoryId)
end)

AddEventHandler("native_satchel:item_used", function(item)
    print("Item used:", item)
end)

AddEventHandler("native_satchel:item_crafted", function(item)
    print("Item crafted:", item)
end)

AddEventHandler("native_satchel:item_dropped", function(item)
    print("Item dropped:", item)
end)

AddEventHandler("native_satchel:item_discarded", function(item)
    print("Item discarded:", item)
end)

AddEventHandler("native_satchel:item_sent_all", function(item)
    print("Item sent:", item)
end)

AddEventHandler("native_satchel:item_focused", function(item)
    print("Item focused:", item)
end)

AddEventHandler("native_satchel:folder_opened", function(folderId)
    print("Folder opened:", folderId)
end)

AddEventHandler("native_satchel:folder_focused", function(folderId)
    print("Folder focused:", folderId)
end)

-- Register commands for testing the satchel triggers

RegisterCommand("satchel_title", function(source, args)
    local title = table.concat(args, " ")
    print("Setting satchel title override to:", title)
    TriggerEvent("native_satchel:set_title", title)
end, false)

RegisterCommand("satchel_open", function(source, args)
    local index = tonumber(args[1])

    print("Opening satchel...")
    TriggerEvent("native_satchel:open_satchel", nil, index)
end, false)

RegisterCommand("satchel_open_ingame", function(source, args)
    local index = tonumber(args[1])

    print("Opening satchel...")
    TriggerEvent("native_satchel:open_satchel", "ingame", index)
end, false)

RegisterCommand("satchel_open_shop", function(source, args)
    local index = tonumber(args[1])

    print("Opening satchel in shop mode...")
    TriggerEvent("native_satchel:open_satchel", "shop", index)
end, false)

RegisterCommand("satchel_close", function()
    print("Closing satchel...")
    TriggerEvent("native_satchel:close_satchel")
end, false)

RegisterCommand("satchel_close_ingame", function()
    print("Closing satchel...")
    TriggerEvent("native_satchel:close_satchel", "ingame")
end, false)

RegisterCommand("satchel_close_shop", function()
    print("Closing satchel from shop mode...")
    TriggerEvent("native_satchel:close_satchel", "shop")
end, false)

RegisterCommand("satchel_inventory", function(source, args)
    local inventory = tostring(args[1])
    print("Activating inventory:", inventory)
    TriggerEvent("native_satchel:activate_inventory", inventory)
end, false)

RegisterCommand("satchel_inventory_close", function(source, args)
    local inventory = tostring(args[1])
    print("Deactivating inventory:", inventory)
    TriggerEvent("native_satchel:deactivate_inventory", inventory)
end, false)

RegisterCommand("satchel_inventory_reset", function()
    print("Resetting inventory")
    TriggerEvent("native_satchel:reset_inventory")
end, false)

RegisterCommand("satchel_add", function(source, args)
    local inventory = tostring(args[1]) or "player"
    local item = args[2] or "test_bread"
    local count = tonumber(args[3]) or 1
    local maxCount = tonumber(args[4]) or nil

    local item = {
        id = item,
        count = count,
        maxCount = maxCount,
        catalog = "CONSUMABLE_BREAD_CHUNK", -- Use existing catalog item for testing
    }

    print("Adding item:", item, "with count:", count)
    TriggerEvent("native_satchel:add_item", item, inventory)
end, false)

RegisterCommand("satchel_increment", function(source, args)
    local inventory = tostring(args[1]) or "player"
    local item = args[2] or "test_bread"
    local count = tonumber(args[3]) or 1

    print("Incrementing item:", item, "by:", count)
    TriggerEvent("native_satchel:increment_item", item, count, inventory)
end, false)

RegisterCommand("satchel_decrement", function(source, args)
    local inventory = tostring(args[1]) or "player"
    local item = args[2] or "test_bread"
    local count = tonumber(args[3]) or 1

    print("Decrementing item:", item, "by:", count)
    TriggerEvent("native_satchel:decrement_item", item, count, inventory)
end, false)

RegisterCommand("satchel_remove", function(source, args)
    local inventory = tostring(args[1]) or "player"
    local item = args[2] or "test_bread"

    print("Removing item:", item)
    TriggerEvent("native_satchel:remove_item", item, inventory)
end, false)

RegisterCommand("satchel_move", function(source, args)
    local fromInventory = tostring(args[1]) or "player"
    local toInventory = tostring(args[2]) or "player"
    local item = args[3] or "test_bread"
    local count = tonumber(args[4]) or 1

    print("Moving item:", item, "from:", fromInventory, "to:", toInventory, "count:", count)
    TriggerEvent("native_satchel:move_item", item, fromInventory, toInventory, count)
end, false)

RegisterCommand("satchel_sync", function(source, args)
    local inventory = tostring(args[1]) or "player"

    local items = {
        { id = "test_bread", count = 3, maxCount = 10, catalog = "CONSUMABLE_BREAD_CHUNK" },
        { id = "test_medicine", count = 2, maxCount = 5, catalog = "CONSUMABLE_MEDICINE" },
        { id = "test_whiskey", count = 1, maxCount = nil, catalog = "CONSUMABLE_TENN_WHISKEY" },
    }

    print("Synchronizing inventory with test items...")
    TriggerEvent("native_satchel:synchronize", items, inventory)
end, false)
