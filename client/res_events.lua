AddEventHandler("native_satchel:open", function(mode, index)
    SatchelUI.Open(mode, index)
end)

AddEventHandler("native_satchel:open_satchel", function(mode, index)
    SatchelUI.Open(mode, index)
end)

AddEventHandler("native_satchel:close", function(mode)
    SatchelUI.Exit(mode)
end)

AddEventHandler("native_satchel:close_satchel", function(mode)
    SatchelUI.Exit(mode)
end)

AddEventHandler("native_satchel:category_changed", function()
    SatchelUI.RefreshMenu()
end)

AddEventHandler("native_satchel:synchronize", function(items, inventory)
    SatchelNavigator:setInventory(items, inventory)
    SatchelUI.RefreshMenu()
end)

AddEventHandler("native_satchel:add_item", function(item, inventory)
    SatchelNavigator:addItem(item, inventory)
    SatchelUI.RefreshMenu()
end)

AddEventHandler("native_satchel:increment_item", function(item, count, inventory)
    SatchelNavigator:incrementItem(item, count, inventory)
    SatchelUI.RefreshMenu()
end)

AddEventHandler("native_satchel:decrement_item", function(item, count, inventory)
    SatchelNavigator:decrementItem(item, count, inventory)
    SatchelUI.RefreshMenu()
end)

AddEventHandler("native_satchel:remove_item", function(item, inventory)
    SatchelNavigator:removeItem(item, inventory)
    SatchelUI.RefreshMenu()
end)

AddEventHandler("native_satchel:move_item", function(item, fromInventory, toInventory, count)
    SatchelNavigator:moveItem(item, fromInventory, toInventory, count)
    SatchelUI.RefreshMenu()
end)

AddEventHandler("native_shop:activate_inventory", function(inventory)
    SatchelNavigator:activateInventory(inventory)
    TriggerEvent("native_satchel:close")
end)

AddEventHandler("native_shop:deactivate_inventory", function(inventory)
    SatchelNavigator:deactivateInventory(inventory)
    TriggerEvent("native_satchel:close")
end)

AddEventHandler("native_satchel:reset_inventory", function(inventory)
    SatchelNavigator:resetActiveInventories()
    TriggerEvent("native_satchel:close")
end)

AddEventHandler("onResourceStop", function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    local success, error = pcall(SatchelUI.Exit)

    -- If something went wrong, close the UI to prevent the user from getting stuck
    if not success then
        print("[NativeSatchel] An error occurred while exiting the satchel UI on resource stop: ")
        print("  " .. tostring(error))

        CloseUiappImmediate("satchel")
    end
end)
