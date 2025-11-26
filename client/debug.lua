AddEventHandler("native_satchel:satchel_opened", function(mode)
    print("Satchel opened:", mode)
end)

AddEventHandler("native_satchel:satchel_closed", function(mode)
    print("Satchel closed:", mode)
end)

AddEventHandler("native_satchel:category_changed", function(categoryId)
    print("Category changed:", categoryId)
end)

AddEventHandler("native_satchel:item_used", function(itemId)
    print("Item used:", itemId)
end)

AddEventHandler("native_satchel:item_crafted", function(itemId)
    print("Item crafted:", itemId)
end)

AddEventHandler("native_satchel:item_dropped", function(itemId)
    print("Item dropped:", itemId)
end)

AddEventHandler("native_satchel:item_discarded", function(itemId)
    print("Item discarded:", itemId)
end)

AddEventHandler("native_satchel:item_sent_all", function(itemId)
    print("Item sent:", itemId)
end)

AddEventHandler("native_satchel:item_focused", function(itemId)
    print("Item focused:", itemId)
end)

AddEventHandler("native_satchel:folder_opened", function(folderId)
    print("Folder opened:", folderId)
end)

AddEventHandler("native_satchel:folder_focused", function(folderId)
    print("Folder focused:", folderId)
end)

-- Register commands for testing the satchel triggers

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

RegisterCommand("satchel_add", function(source, args)
    local itemId = args[1] or "test_bread"
    local count = tonumber(args[2]) or 1
    local maxCount = tonumber(args[3]) or nil

    local item = {
        id = itemId,
        count = count,
        maxCount = maxCount,
        catalog = "CONSUMABLE_BREAD_CHUNK", -- Use existing catalog item for testing
    }

    print("Adding item:", itemId, "with count:", count)
    TriggerEvent("native_satchel:add_item", item)
end, false)

RegisterCommand("satchel_increment", function(source, args)
    local itemId = args[1] or "test_bread"
    local count = tonumber(args[2]) or 1

    print("Incrementing item:", itemId, "by:", count)
    TriggerEvent("native_satchel:increment_item", itemId, count)
end, false)

RegisterCommand("satchel_decrement", function(source, args)
    local itemId = args[1] or "test_bread"
    local count = tonumber(args[2]) or 1

    print("Decrementing item:", itemId, "by:", count)
    TriggerEvent("native_satchel:decrement_item", itemId, count)
end, false)

RegisterCommand("satchel_remove", function(source, args)
    local itemId = args[1] or "test_bread"

    print("Removing item:", itemId)
    TriggerEvent("native_satchel:remove_item", itemId)
end, false)

RegisterCommand("satchel_sync", function()
    local testInventory = {
        { id = "test_bread", count = 3, maxCount = 10, catalog = "CONSUMABLE_BREAD_CHUNK" },
        { id = "test_medicine", count = 2, maxCount = 5, catalog = "CONSUMABLE_MEDICINE" },
        { id = "test_whiskey", count = 1, maxCount = nil, catalog = "CONSUMABLE_TENN_WHISKEY" },
    }

    print("Synchronizing inventory with test items...")
    TriggerEvent("native_satchel:synchronize", testInventory)
end, false)
