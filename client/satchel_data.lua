SatchelData = {}

SatchelData.state = {
    shuttingDown = false,
    hydratedList = nil,
    streamedSatchelCategoryItems = false,
    streamedSatchelMenuItems = false,
    streamedSatchelListItems = false,
}

function SatchelData.Startup()
    SatchelData.state.shuttingDown = false
    SatchelData.state.streamedSatchelCategoryItems = false
    SatchelData.state.streamedSatchelMenuItems = false
    SatchelData.state.streamedSatchelListItems = false
end

function SatchelData.Shutdown()
    SatchelData.state.shuttingDown = true
end

function SatchelData.MaintainEvents()
    -- These containers are streamed in on UIAPP load, so wait for them to be valid before adding categories and items
    if not SatchelData.state.shuttingDown then
        if not SatchelData.state.streamedSatchelCategoryItems then
            if SatchelUI.bindings.dscSatchelCategoryItems == 0 then
                SatchelUI.bindings.dscSatchelCategoryItems = DatabindingGetDataContainerFromPath("satchel_category_items")
            else
                SatchelData.state.streamedSatchelCategoryItems = true
                SatchelUI.Builder.AddCategories()
            end
        end

        if not SatchelData.state.streamedSatchelMenuItems or not SatchelData.state.streamedSatchelListItems then
            if SatchelUI.bindings.dscSatchelMenuItems == 0 then
                SatchelUI.bindings.dscSatchelMenuItems = DatabindingGetDataContainerFromPath("satchel_menu_items")
            elseif SatchelUI.bindings.dscSatchelListItems == 0 then
                SatchelUI.bindings.dscSatchelListItems = DatabindingGetDataContainerFromPath("satchel_list_items")
            else
                SatchelData.state.streamedSatchelMenuItems = true
                SatchelData.state.streamedSatchelListItems = true
                SatchelUI.Builder.AddMenuItems()
            end
        end
    end

    -- Early return if we don't have anything to do to prevent unnecessary flag checks
    if not SatchelEvents.GetEventFlag(SatchelEvents.FLAG_STATE_CHANGED) then
        return
    end

    if SatchelEvents.GetEventFlag(SatchelEvents.FLAG_ITEM_UNFOCUSED) then
        SatchelUI.Events.HandleUnfocus()
        SatchelEvents.ClearEventFlag(SatchelEvents.FLAG_ITEM_UNFOCUSED)
    end

    if SatchelEvents.GetEventFlag(SatchelEvents.FLAG_TAB_INCREMENT) or SatchelEvents.GetEventFlag(SatchelEvents.FLAG_TAB_DECREMENT) then
        SatchelUI.Events.HandleUnfocus()
        SatchelUI.ClearListItems()
        SatchelUI.Index.Clear()

        if DatabindingIsEntryValid(SatchelUI.bindings.dsiCategoryIndex) then
            local value = DatabindingReadInt(SatchelUI.bindings.dsiCategoryIndex)
            SatchelNavigator:setCategory(value + 1)
            DatabindingWriteDataInt(SatchelUI.bindings.dsiCategoryDefault, value)
        end

        local categoryId = SatchelNavigator:getCurrentCategoryId()
        TriggerEvent("native_satchel:category_changed", categoryId)

        SatchelEvents.ClearEventFlag(SatchelEvents.FLAG_TAB_INCREMENT)
        SatchelEvents.ClearEventFlag(SatchelEvents.FLAG_TAB_DECREMENT)
    end

    if SatchelEvents.GetEventFlag(SatchelEvents.FLAG_ITEM_FOCUSED) then
        local index = SatchelEvents.state.focusedIndex
        local itemId = SatchelEvents.GetFocusedItemId()
        local type = SatchelEvents.GetFocusedItemType()

        if itemId then
            if type == "folder_item" then
                SatchelUI.Events.HandleFolderFocus(itemId)
                if itemId ~= SatchelData.state.hydratedList then
                    SatchelUI.Builder.AddListItems(itemId)
                    SatchelData.state.hydratedList = itemId
                end
            else
                SatchelUI.Events.HandleItemFocus(itemId)
            end
        end

        if type == "list_item" then
            SatchelUI.Index.SetCurrent("list", index)
        else
            SatchelUI.Index.SetCurrent("menu", index)
        end


        SatchelEvents.ClearEventFlag(SatchelEvents.FLAG_ITEM_FOCUSED)
    end

    if SatchelEvents.GetEventFlag(SatchelEvents.FLAG_ITEM_SELECTED) then
        local itemId = SatchelEvents.GetSelectedItemId()

        if SatchelEvents.GetEventFlag(SatchelEvents.FLAG_ITEM_TYPE_FOLDER) and itemId then
            SatchelUI.UpdateListTitle(itemId)
        end

        if SatchelEvents.GetEventFlag(SatchelEvents.FLAG_ITEM_TYPE_FOLDER) then
            TriggerEvent("native_satchel:folder_opened", itemId)
        elseif SatchelEvents.GetEventFlag(SatchelEvents.FLAG_ITEM_TYPE_USABLE) then
            TriggerEvent("native_satchel:item_used", itemId)
        elseif SatchelEvents.GetEventFlag(SatchelEvents.FLAG_ITEM_TYPE_CRAFTABLE) then
            TriggerEvent("native_satchel:item_crafted", itemId)
        elseif SatchelEvents.GetEventFlag(SatchelEvents.FLAG_ITEM_TYPE_DROP) then
            TriggerEvent("native_satchel:item_dropped", itemId)
        elseif SatchelEvents.GetEventFlag(SatchelEvents.FLAG_ITEM_TYPE_DISCARD_ALL) then
            TriggerEvent("native_satchel:item_discarded", itemId)
        elseif SatchelEvents.GetEventFlag(SatchelEvents.FLAG_ITEM_TYPE_SEND_ALL) then
            TriggerEvent("native_satchel:item_sent_all", itemId)
        end

        SatchelEvents.ClearItemTypeFlags()
        SatchelEvents.ClearEventFlag(SatchelEvents.FLAG_ITEM_SELECTED)
    end

    if SatchelEvents.GetEventFlag(SatchelEvents.FLAG_NEW_ACTIVITY) then
        -- Currently unused, used in game to force direct-to-folder situations
        SatchelEvents.ClearEventFlag(SatchelEvents.FLAG_NEW_ACTIVITY)
    end

    if SatchelEvents.GetEventFlag(SatchelEvents.FLAG_NEW_PAGE) then
        -- Currently unused, used in game to force direct-to-folder situations
        SatchelEvents.ClearEventFlag(SatchelEvents.FLAG_NEW_PAGE)
    end

    SatchelEvents.ClearEventFlag(SatchelEvents.FLAG_STATE_CHANGED)
end
