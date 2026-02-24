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

exports("IncrementItem", function(item, count, inventory)
    SatchelNavigator:incrementItem(item, count, inventory)
    SatchelUI.RefreshMenu()
end)

exports("DecrementItem", function(item, count, inventory)
    SatchelNavigator:decrementItem(item, count, inventory)
    SatchelUI.RefreshMenu()
end)

exports("RemoveItem", function(item, inventory)
    SatchelNavigator:removeItem(item, inventory)
    SatchelUI.RefreshMenu()
end)

exports("MoveItem", function(item, fromInventory, toInventory, count)
    SatchelNavigator:moveItem(item, fromInventory, toInventory, count)
    SatchelUI.RefreshMenu()
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
