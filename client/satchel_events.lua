SatchelEvents = {
    FLAG_ITEM_FOCUSED = 1 << 0,
    FLAG_ITEM_UNFOCUSED = 1 << 1,
    FLAG_ITEM_SELECTED = 1 << 2,
    FLAG_TAB_INCREMENT = 1 << 3,
    FLAG_TAB_DECREMENT = 1 << 4,
    FLAG_NEW_ACTIVITY = 1 << 5,
    FLAG_NEW_PAGE = 1 << 6,
    FLAG_STATE_CHANGED = 1 << 7,

    FLAG_ITEM_TYPE_FOLDER = 1 << 8,
    FLAG_ITEM_TYPE_USABLE = 1 << 9,
    FLAG_ITEM_TYPE_CRAFTABLE = 1 << 10,
    FLAG_ITEM_TYPE_DROP = 1 << 11,
    FLAG_ITEM_TYPE_DISCARD_ALL = 1 << 12,
    FLAG_ITEM_TYPE_SEND_ALL = 1 << 13,
}

SatchelEvents.state = {
    eventFlags = 0,
    selectedIndex = 0,
    selectedItem = 0,
    selectedDatastore = 0,
    focusedIndex = 0,
    focusedItem = 0,
    focusedDatastore = 0,
    unfocusedIndex = 0,
    unfocusedItem = 0,
    unfocusedDatastore = 0,
    pageIndex = 0,
}

function SatchelEvents.GetEventFlags()
    return SatchelEvents.state.eventFlags
end

function SatchelEvents.GetEventFlag(flag)
    return SatchelEvents.state.eventFlags & flag ~= 0
end

function SatchelEvents.SetEventFlag(flag)
    SatchelEvents.state.eventFlags = SatchelEvents.state.eventFlags | flag
    return SatchelEvents.state.eventFlags
end

function SatchelEvents.ClearEventFlag(flag)
    SatchelEvents.state.eventFlags = SatchelEvents.state.eventFlags & (~flag)
    return SatchelEvents.state.eventFlags
end

function SatchelEvents.ClearItemTypeFlags()
    SatchelEvents.ClearEventFlag(SatchelEvents.FLAG_ITEM_TYPE_FOLDER)
    SatchelEvents.ClearEventFlag(SatchelEvents.FLAG_ITEM_TYPE_USABLE)
    SatchelEvents.ClearEventFlag(SatchelEvents.FLAG_ITEM_TYPE_CRAFTABLE)
    SatchelEvents.ClearEventFlag(SatchelEvents.FLAG_ITEM_TYPE_DROP)
    SatchelEvents.ClearEventFlag(SatchelEvents.FLAG_ITEM_TYPE_DISCARD_ALL)
    SatchelEvents.ClearEventFlag(SatchelEvents.FLAG_ITEM_TYPE_SEND_ALL)
end

function SatchelEvents.GetUiEventType(id)
    local types = {
        [joaat("ITEM_FOCUSED")]       = "ITEM_FOCUSED",
        [joaat("ITEM_UNFOCUSED")]     = "ITEM_UNFOCUSED",
        [joaat("TAB_PAGE_DECREMENT")] = "TAB_PAGE_DECREMENT",
        [joaat("TAB_PAGE_INCREMENT")] = "TAB_PAGE_INCREMENT",
        [joaat("ITEM_SELECTED")]      = "ITEM_SELECTED",
        [joaat("NEW_ACTIVITY")]       = "NEW_ACTIVITY",
        [joaat("NEW_PAGE")]           = "NEW_PAGE",
    }
    return types[id]
end

function SatchelEvents.GetHashParameterType(id)
    local types = {
        [joaat("FOLDER_ITEM")]    = "FOLDER_ITEM",
        [joaat("USABLE_ITEM")]    = "USABLE_ITEM",
        [joaat("BREAKABLE_ITEM")] = "BREAKABLE_ITEM",
        [joaat("DROP_ITEM")]      = "DROP_ITEM",
        [joaat("DISCARD_ALL")]    = "DISCARD_ALL",
        [joaat("SEND_ALL")]       = "SEND_ALL",
    }
    return types[id]
end

function SatchelEvents.ReadDataString(datastore, key)
    -- _DATABINDING_READ_DATA_STRING_FROM_PARENT: Helper for this native doesn't return string
    return Citizen.InvokeNative(0x6323AD277C4A2AFB, datastore, key, Citizen.ResultAsString())
end

function SatchelEvents.GetFocusedItemId()
    return SatchelEvents.ReadDataString(SatchelEvents.state.focusedDatastore, "uiItemID")
end

function SatchelEvents.GetFocusedItemType()
    return SatchelEvents.ReadDataString(SatchelEvents.state.focusedDatastore, "uiItemType")
end

function SatchelEvents.GetUnfocusedItemId()
    return SatchelEvents.ReadDataString(SatchelEvents.state.unfocusedDatastore, "uiItemID")
end

function SatchelEvents.GetUnfocusedItemType()
    return SatchelEvents.ReadDataString(SatchelEvents.state.unfocusedDatastore, "uiItemType")
end

function SatchelEvents.GetSelectedItemId()
    return SatchelEvents.ReadDataString(SatchelEvents.state.selectedDatastore, "uiItemID")
end

function SatchelEvents.GetSelectedItemType()
    return SatchelEvents.ReadDataString(SatchelEvents.state.selectedDatastore, "uiItemType")
end

Citizen.CreateThread(function()
    while true do
        if IsUiappRunning("satchel") ~= 1 then
            Citizen.Wait(100)
            goto continue
        end

        while EventsUiIsPending(`satchel_menu`) do
            local msg = DataView.ArrayBuffer(8 * 4)
            msg:SetInt32(0, 0)
            msg:SetInt32(8, 0)
            msg:SetInt32(16, 0)
            msg:SetInt32(24, 0)

            if Citizen.InvokeNative(0x90237103F27F7937, `satchel_menu`, msg:Buffer()) ~= 0 then -- EVENTS_UI_PEEK_MESSAGE
                local eventHash = msg:GetInt32(0)
                local intParameter = msg:GetInt32(8)
                local hashParameter = msg:GetInt32(16)
                local datastoreId = msg:GetInt32(24)

                local eventType = SatchelEvents.GetUiEventType(eventHash)
                local hashParameterType = SatchelEvents.GetHashParameterType(hashParameter)

                if eventType == "TAB_PAGE_INCREMENT" or eventType == "TAB_PAGE_DECREMENT" then
                    if eventType == "TAB_PAGE_INCREMENT" then
                        SatchelEvents.SetEventFlag(SatchelEvents.FLAG_TAB_INCREMENT)
                    else
                        SatchelEvents.SetEventFlag(SatchelEvents.FLAG_TAB_DECREMENT)
                    end

                    SatchelEvents.SetEventFlag(SatchelEvents.FLAG_STATE_CHANGED)
                elseif eventType == "ITEM_FOCUSED" then
                    SatchelEvents.state.focusedDatastore = datastoreId
                    SatchelEvents.state.focusedIndex = intParameter
                    SatchelEvents.state.focusedItem = SatchelEvents.GetFocusedItemId()

                    SatchelEvents.SetEventFlag(SatchelEvents.FLAG_ITEM_FOCUSED)
                    SatchelEvents.SetEventFlag(SatchelEvents.FLAG_STATE_CHANGED)
                elseif eventType == "ITEM_UNFOCUSED" then
                    SatchelEvents.state.unfocusedDatastore = datastoreId
                    SatchelEvents.state.unfocusedIndex = intParameter
                    SatchelEvents.state.unfocusedItem = SatchelEvents.GetUnfocusedItemId()

                    SatchelEvents.SetEventFlag(SatchelEvents.FLAG_ITEM_UNFOCUSED)
                    SatchelEvents.SetEventFlag(SatchelEvents.FLAG_STATE_CHANGED)
                elseif eventType == "ITEM_SELECTED" then
                    SatchelEvents.state.selectedDatastore = datastoreId
                    SatchelEvents.state.selectedIndex = intParameter
                    SatchelEvents.state.selectedItem = SatchelEvents.GetSelectedItemId()

                    if hashParameterType == "FOLDER_ITEM" then
                        SatchelEvents.SetEventFlag(SatchelEvents.FLAG_ITEM_TYPE_FOLDER)
                    elseif hashParameterType == "USABLE_ITEM" then
                        SatchelEvents.SetEventFlag(SatchelEvents.FLAG_ITEM_TYPE_USABLE)
                    elseif hashParameterType == "BREAKABLE_ITEM" then
                        SatchelEvents.SetEventFlag(SatchelEvents.FLAG_ITEM_TYPE_CRAFTABLE)
                    elseif hashParameterType == "DROP_ITEM" then
                        SatchelEvents.SetEventFlag(SatchelEvents.FLAG_ITEM_TYPE_DROP)
                    elseif hashParameterType == "DISCARD_ALL" then
                        SatchelEvents.SetEventFlag(SatchelEvents.FLAG_ITEM_TYPE_DISCARD_ALL)
                    elseif hashParameterType == "SEND_ALL" then
                        SatchelEvents.SetEventFlag(SatchelEvents.FLAG_ITEM_TYPE_SEND_ALL)
                    else
                        print("[NativeSatchel] Received ITEM_SELECTED with unhandled type: " .. tostring(hashParameterType))
                    end

                    SatchelEvents.SetEventFlag(SatchelEvents.FLAG_ITEM_SELECTED)
                    SatchelEvents.SetEventFlag(SatchelEvents.FLAG_STATE_CHANGED)
                elseif eventType == "NEW_ACTIVITY" then
                    SatchelEvents.SetEventFlag(SatchelEvents.FLAG_NEW_ACTIVITY)
                    SatchelEvents.SetEventFlag(SatchelEvents.FLAG_STATE_CHANGED)
                elseif eventType == "NEW_PAGE" then
                    SatchelEvents.state.pageIndex = intParameter

                    SatchelEvents.SetEventFlag(SatchelEvents.FLAG_NEW_PAGE)
                    SatchelEvents.SetEventFlag(SatchelEvents.FLAG_STATE_CHANGED)
                else
                    print("[NativeSatchel] Received unhandled event type:")
                    print("  Event ID: " .. tostring(eventHash))
                    print("  Event Type: " .. tostring(eventType))
                    print("  Hash Parameter: " .. tostring(hashParameter))
                    print("  Hash Parameter Type: " .. tostring(hashParameterType))
                    print("  Int Parameter: " .. tostring(intParameter))
                    print("  Datastore ID: " .. tostring(datastoreId))
                end
            end

            EventsUiPopMessage(`satchel_menu`)
        end

        Citizen.Wait(0)
        ::continue::
    end
end)

if Config.enableDefaultOpenPrompt then
    Citizen.CreateThread(function()
        while true do
            if IsUiappRunning("satchel") == 1 then
                Citizen.Wait(250)
                goto continue
            end

            if IsControlJustPressed(0, "INPUT_OPEN_SATCHEL_MENU") and IsUiappRunning("satchel") ~= 1 then
                local prompt = 0

                -- Create prompt
                if prompt == 0 then
                    prompt = UiPromptRegisterBegin()
                    UiPromptSetControlAction(prompt, GetHashKey("INPUT_OPEN_SATCHEL_MENU"))
                    UiPromptSetText(prompt, VarString(10, "LITERAL_STRING", "Satchel"))
                    UiPromptSetHoldMode(prompt, 250)
                    UiPromptSetAttribute(prompt, 2, true)
                    UiPromptSetAttribute(prompt, 4, true)
                    UiPromptSetAttribute(prompt, 9, true)
                    UiPromptSetAttribute(prompt, 10, true) -- kPromptAttrib_NoButtonReleaseCheck. Immediately becomes pressed
                    UiPromptSetAttribute(prompt, 17, true) -- kPromptAttrib_NoGroupCheck. Allows to appear in any active group
                    UiPromptRegisterEnd(prompt)

                    Citizen.CreateThread(function()
                        Citizen.Wait(100)

                        while UiPromptGetProgress(prompt) ~= 0.0 and UiPromptGetProgress(prompt) ~= 1.0 do
                            Citizen.Wait(0)
                        end

                        if UiPromptGetProgress(prompt) == 1.0 then
                            TriggerEvent("native_satchel:open")
                        end

                        UiPromptDelete(prompt)
                        prompt = 0
                    end)
                end
            end

            Citizen.Wait(0)
            ::continue::
        end
    end)
end
