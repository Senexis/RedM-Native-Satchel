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

AddEventHandler("native_satchel:synchronize", function(items)
    SatchelNavigator:setInventory(items)
    SatchelUI.RefreshMenu()
end)

AddEventHandler("native_satchel:add_item", function(item)
    SatchelNavigator:addItem(item)
    SatchelUI.RefreshMenu()
end)

AddEventHandler("native_satchel:increment_item", function(uiItemID, count)
    SatchelNavigator:incrementItem(uiItemID, count)
    SatchelUI.RefreshMenu()
end)

AddEventHandler("native_satchel:decrement_item", function(uiItemID, count)
    SatchelNavigator:decrementItem(uiItemID, count)
    SatchelUI.RefreshMenu()
end)

AddEventHandler("native_satchel:remove_item", function(uiItemID)
    SatchelNavigator:removeItem(uiItemID)
    SatchelUI.RefreshMenu()
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
