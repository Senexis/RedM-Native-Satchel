exports("SetTitle", function(title)
    SatchelUI.SetTitleOverride(title)
end)

exports("Open", function(mode, index)
    SatchelUI.Open(mode, index)
end)

exports("Close", function(mode)
    SatchelUI.Exit(mode)
end)

exports("SetCategories", function(categories)
    SatchelNavigator:setCategories(categories)
    SatchelUI.Exit()
end)

exports("SetFolders", function(folders)
    SatchelNavigator:setFolders(folders)
    SatchelUI.RefreshMenu()
end)

exports("SetItems", function(items, inventory)
    SatchelNavigator:setInventory(items, inventory)
    SatchelUI.RefreshMenu()
end)

exports("AddItem", function(item, inventory)
    SatchelNavigator:addItem(item, inventory)
    SatchelUI.RefreshMenu()
end)

exports("IncrementItem", function(itemId, count, inventory)
    SatchelNavigator:incrementItem(itemId, count, inventory)
    SatchelUI.RefreshItemOrMenu(itemId)
end)

exports("DecrementItem", function(itemId, count, inventory)
    SatchelNavigator:decrementItem(itemId, count, inventory)
    SatchelUI.RefreshItemOrMenu(itemId)
end)

exports("RemoveItem", function(itemId, inventory)
    SatchelNavigator:removeItem(itemId, inventory)
    SatchelUI.RefreshItemOrMenu(itemId)
end)

exports("MoveItem", function(itemId, fromInventory, toInventory, count)
    SatchelNavigator:moveItem(itemId, fromInventory, toInventory, count)
    SatchelUI.RefreshItemOrMenu(itemId)
end)

exports("ActivateInventory", function(inventory)
    SatchelNavigator:activateInventory(inventory)
    SatchelUI.Exit()
end)

exports("DeactivateInventory", function(inventory)
    SatchelNavigator:deactivateInventory(inventory)
    SatchelUI.Exit()
end)

exports("ResetInventory", function()
    SatchelNavigator:resetActiveInventories()
    SatchelUI.Exit()
end)
