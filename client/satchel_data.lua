SatchelData = {}

SatchelData.state = {
    eventFlags = 0,
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

function SatchelData.GetEventFlag(flag)
    return SatchelData.state.eventFlags & flag ~= 0
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

    -- Disable controls that the default satchel disables
    if Config.preventConflictingControls and not SatchelData.state.shuttingDown then
        UiPromptEnablePromptTypeThisFrame(0)
        DisableControlAction(0, `INPUT_NEXT_CAMERA`, false);
        DisableControlAction(0, `INPUT_HORSE_SPRINT`, false);
        DisableControlAction(0, `INPUT_JUMP`, false);
        DisableControlAction(0, `INPUT_SPRINT`, false);
        DisableControlAction(0, `INPUT_ENTER`, false);
        DisableControlAction(0, `INPUT_MELEE_ATTACK`, false);
        DisableControlAction(0, `INPUT_PHONE`, false);
        DisableControlAction(0, `INPUT_RADIAL_MENU_SLOT_NAV_NEXT`, false);
        DisableControlAction(0, `INPUT_RADIAL_MENU_SLOT_NAV_PREV`, false);
        DisableControlAction(0, `INPUT_COVER`, false);
        DisableControlAction(0, `INPUT_OPEN_WHEEL_MENU`, false);
    end

    -- Pop the event flags for this frame so we can react to them
    -- This prevents race conditions by flags getting cleared before we can react to them
    SatchelData.state.eventFlags = SatchelEvents.PopEventFlags()

    -- Early return if we don't have anything to do to prevent unnecessary flag checks
    if not SatchelData.GetEventFlag(SatchelEvents.FLAG_STATE_CHANGED) then
        return
    end

    if SatchelData.GetEventFlag(SatchelEvents.FLAG_ITEM_UNFOCUSED) then
        SatchelUI.Events.HandleUnfocus()
    end

    if SatchelData.GetEventFlag(SatchelEvents.FLAG_TAB_INCREMENT) or SatchelData.GetEventFlag(SatchelEvents.FLAG_TAB_DECREMENT) then
        SatchelUI.Events.HandleUnfocus()
        SatchelUI.ClearListItems()
        SatchelUI.Index.Clear()

        if DatabindingIsEntryValid(SatchelUI.bindings.dsiCategoryIndex) then
            local value = DatabindingReadInt(SatchelUI.bindings.dsiCategoryIndex)
            SatchelNavigator:setCategory(value + 1)
            DatabindingWriteDataInt(SatchelUI.bindings.dsiCategoryDefault, value)
        end

        SatchelUI.RefreshMenu()

        local categoryId = SatchelNavigator:getCurrentCategoryId()
        TriggerEvent("native_satchel:category_changed", categoryId)
    end

    if SatchelData.GetEventFlag(SatchelEvents.FLAG_ITEM_FOCUSED) then
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
    end

    if SatchelData.GetEventFlag(SatchelEvents.FLAG_ITEM_SELECTED) then
        local itemId = SatchelEvents.GetSelectedItemId()

        if SatchelData.GetEventFlag(SatchelEvents.FLAG_ITEM_TYPE_FOLDER) and itemId then
            SatchelUI.UpdateListTitle(itemId)
        end

        if SatchelData.GetEventFlag(SatchelEvents.FLAG_ITEM_TYPE_FOLDER) then
            TriggerEvent("native_satchel:folder_opened", itemId)
        elseif SatchelData.GetEventFlag(SatchelEvents.FLAG_ITEM_TYPE_USABLE) then
            TriggerEvent("native_satchel:item_used", itemId)
        elseif SatchelData.GetEventFlag(SatchelEvents.FLAG_ITEM_TYPE_CRAFTABLE) then
            TriggerEvent("native_satchel:item_crafted", itemId)
        elseif SatchelData.GetEventFlag(SatchelEvents.FLAG_ITEM_TYPE_DROP) then
            TriggerEvent("native_satchel:item_dropped", itemId)
        elseif SatchelData.GetEventFlag(SatchelEvents.FLAG_ITEM_TYPE_DISCARD_ALL) then
            TriggerEvent("native_satchel:item_discarded", itemId)
        elseif SatchelData.GetEventFlag(SatchelEvents.FLAG_ITEM_TYPE_SEND_ALL) then
            TriggerEvent("native_satchel:item_sent_all", itemId)
        end
    end

    if SatchelData.GetEventFlag(SatchelEvents.FLAG_NEW_ACTIVITY) then
        -- Currently unused, used in game to force direct-to-folder situations
    end

    if SatchelData.GetEventFlag(SatchelEvents.FLAG_NEW_PAGE) then
        -- Currently unused, used in game to force direct-to-folder situations
    end
end
