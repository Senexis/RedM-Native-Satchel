---------------------------------------------------------------------------------
--                            REDM NATIVE SATCHEL                              --
--                              Main Entry Point                               --
--                    Refactored for modular architecture                      --
---------------------------------------------------------------------------------

-- UI channels
local uiAppChannel = joaat("satchel")
local uiEventChannel = joaat("satchel_menu")

-- Initialize all modules with their dependencies
local function initializeModules()
    -- Initialize utility functions first
    Utils.initializeResources()

    -- Initialize player state and persistence
    PlayerState.initialize()

    -- Setup dependencies for other modules
    SatchelRenderer.init(PlayerState, Utils, UIDataBinding, ItemDatabase)
    EventHandlers.init(PlayerState, Utils, Config, SatchelRenderer, UIDataBinding)

    -- Initialize all UI databinding systems
    UIDataBinding.initializeSatchelMainData()
    UIDataBinding.initializeSatchelSelectedData()
    UIDataBinding.initializeSatchelSelectedEffects()
    UIDataBinding.initializeSatchelCollectionData()
    UIDataBinding.initializeSatchelCategories()
    UIDataBinding.initializeSatchelMenuItems()
    UIDataBinding.initializeSatchelListItems()
end

-- Initialize satchel UI system
local function initializeSatchel()
    local categoriesReloaded = false
    local menuItemsReloaded = false

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(10)

            local menuItems = PlayerState.getPersistedInt("RefMenuItems")
            local listItems = PlayerState.getPersistedInt("RefListItems")
            local mainData = PlayerState.getPersistedInt("RefMainData")
            local selectedData = PlayerState.getPersistedInt("RefSelectedData")
            local collectionData = PlayerState.getPersistedInt("RefCollectionData")
            local categoryItems = PlayerState.getPersistedInt("RefCategoryItems")

            if menuItems == 0 or DatabindingIsEntryValid(menuItems) ~= 1 then
                UIDataBinding.initializeSatchelMenuItems()
            elseif listItems == 0 or DatabindingIsEntryValid(listItems) ~= 1 then
                UIDataBinding.initializeSatchelListItems()
            elseif mainData == 0 or DatabindingIsEntryValid(mainData) ~= 1 then
                UIDataBinding.initializeSatchelMainData()
            elseif selectedData == 0 or DatabindingIsEntryValid(selectedData) ~= 1 then
                UIDataBinding.initializeSatchelSelectedData()
                UIDataBinding.initializeSatchelSelectedEffects()
            elseif collectionData == 0 or DatabindingIsEntryValid(collectionData) ~= 1 then
                UIDataBinding.initializeSatchelCollectionData()
            elseif categoryItems == 0 or DatabindingIsEntryValid(categoryItems) ~= 1 then
                UIDataBinding.initializeSatchelCategories()
            elseif categoriesReloaded ~= true then
                SatchelRenderer.reloadSatchelCategories()
                categoriesReloaded = true
            elseif menuItemsReloaded ~= true then
                SatchelRenderer.navigateSatchelMenuItems()
                menuItemsReloaded = true
            else
                break
            end
        end
    end)
end

-- Close the satchel UI
local function closeSatchel()
    local mode = "ingame"

    if PlayerState.isShopMode() then
        mode = "shop"
    end

    TriggerEvent(Config.eventHandlerKey .. ":satchel_closed", mode)
end

-- Open the satchel UI
local function openSatchel()
    if not PlayerState.areResourcesLoaded() then
        PostFeedTicker("Satchel resources are still loading, try again shortly.")
        return
    end

    local categoryIndex = PlayerState.getCategoryOverride() or Config.defaultCategoryIndex or 0
    PlayerState.setPersistedInt("CurrentCategoryIndex", categoryIndex % #Config.categories)

    local mode = "ingame"

    if PlayerState.isShopMode() then
        PlayerState.setShoppingMode(true)
        mode = "shop"
    end

    LaunchUiappByHashWithEntry(joaat("satchel"), joaat(mode))
    initializeSatchel()

    TriggerEvent(Config.eventHandlerKey .. ":satchel_opened", mode)

    Citizen.CreateThread(function()
        while IsUiappRunningByHash(uiAppChannel) == 1 do
            Citizen.Wait(0)
        end

        StopItemPreview()

        if PlayerState.isShopMode() then
            PlayerState.setShoppingMode(false)
        end

        closeSatchel()
    end)
end

-- Main system initialization
local function initialize()
    initializeModules()
end

-- Start the main system
initialize()

-- Create debouncer for ITEM_FOCUSED events
local focusEventDebouncer = Utils.createEventDebouncer(5, function(eventData)
    EventHandlers.eventItemFocused(eventData.index, eventData.parameter, eventData.datastore)
end)

-- UI event processing thread
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        -- Process debounced events
        focusEventDebouncer:process()

        if EventsUiIsPending(uiEventChannel) then
            local msg = DataView.ArrayBuffer(8 * 4)
            msg:SetInt32(0, 0)
            msg:SetInt32(8, 0)
            msg:SetInt32(16, 0)
            msg:SetInt32(24, 0)

            if Citizen.InvokeNative(0x90237103F27F7937, uiEventChannel, msg:Buffer()) ~= 0 then -- EVENTS_UI_PEEK_MESSAGE
                local event = msg:GetInt32(0)
                local index = msg:GetInt32(8)
                local parameter = msg:GetInt32(16)
                local datastore = msg:GetInt32(24)

                if event == joaat("TAB_PAGE_INCREMENT") or event == joaat("TAB_PAGE_DECREMENT") then
                    EventHandlers.handleNavigateSatchelMenuItems()
                elseif event == joaat("ITEM_SELECTED") then
                    EventHandlers.eventItemSelected(index, parameter, datastore)
                elseif event == joaat("ITEM_FOCUSED") then
                    focusEventDebouncer:queue({
                        index = index,
                        parameter = parameter,
                        datastore = datastore
                    })
                elseif event == joaat("ITEM_UNFOCUSED") then
                    -- Skip these events entirely, don't want logging for these
                else
                    print("[NativeSatchel] Unknown UI event received: " .. event)
                end
            end

            EventsUiPopMessage(uiEventChannel)
        end
    end
end)

-- Prompt handling thread
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if IsControlJustPressed(0, "INPUT_OPEN_SATCHEL_MENU") and IsUiappRunningByHash(uiAppChannel) ~= 1 then
            local prompt = 0

            -- Create prompt
            if prompt == 0 then
                prompt = PromptRegisterBegin()
                PromptSetControlAction(prompt, GetHashKey("INPUT_OPEN_SATCHEL_MENU"))
                PromptSetText(prompt, CreateVarString(10, "LITERAL_STRING", "Satchel"))
                UiPromptSetHoldMode(prompt, 750)
                UiPromptSetAttribute(prompt, 2, true)
                UiPromptSetAttribute(prompt, 4, true)
                UiPromptSetAttribute(prompt, 9, true)
                UiPromptSetAttribute(prompt, 10, true) -- kPromptAttrib_NoButtonReleaseCheck. Immediately becomes pressed
                UiPromptSetAttribute(prompt, 17, true) -- kPromptAttrib_NoGroupCheck. Allows to appear in any active group
                PromptRegisterEnd(prompt)

                Citizen.CreateThread(function()
                    Citizen.Wait(100)

                    while UiPromptGetProgress(prompt) ~= 0.0 and UiPromptGetProgress(prompt) ~= 1.0 do
                        Citizen.Wait(0)
                    end

                    if UiPromptGetProgress(prompt) == 1.0 then
                        PlayerState.setShoppingMode(false)
                        openSatchel()
                    end

                    PromptDelete(prompt)
                    prompt = 0

                    Citizen.Wait(1000)
                end)
            end
        end
    end
end)

-- Player processing thread
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if IsUiappRunningByHash(uiAppChannel) == 1 then
            UiPromptEnablePromptTypeThisFrame(0)

            local playerId = PlayerId()
            local playerPed = GetPlayerPed(playerId)
            local playerIndex = GetPlayerIndex()

            if IsPedFalling(playerPed) == 1 then
                CloseUiappByHash(uiAppChannel)
            elseif IsPedFallingOver(playerPed) == 1 then
                CloseUiappByHash(uiAppChannel)
            elseif IsPlayerBeingArrested(playerIndex, true) == 1 then
                CloseUiappByHash(uiAppChannel)
            elseif IsPedHogtied(playerPed) == 1 then
                CloseUiappByHash(uiAppChannel)
            elseif IsPedDeadOrDying(playerPed, true) == 1 then
                CloseUiappByHash(uiAppChannel)
            elseif IsEntityDead(playerPed) == 1 then
                CloseUiappByHash(uiAppChannel)
            end
        end
    end
end)

-- Resource cleanup
AddEventHandler("onResourceStart", function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end

    initialize()
end)

AddEventHandler("onResourceStop", function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end

    if IsUiappActiveByHash(uiAppChannel) then
        CloseUiappByHash(uiAppChannel)
    end
end)

-- Satchel Control Triggers
AddEventHandler(Config.eventHandlerKey .. ":open_satchel", function(mode, index)
    PlayerState.setShoppingMode(mode == "shop")
    PlayerState.setCategoryOverride(index)
    openSatchel()
end)

AddEventHandler(Config.eventHandlerKey .. ":close_satchel", function(mode)
    if PlayerState.isShopMode() and mode == "ingame" then
        return
    end

    if not PlayerState.isShopMode() and mode == "shop" then
        return
    end

    if IsUiappRunningByHash(uiAppChannel) then
        CloseUiappByHash(uiAppChannel)
    end
end)

-- Item Management Triggers
AddEventHandler(Config.eventHandlerKey .. ":synchronize", function(items)
    if type(items) ~= "table" then
        print("[Native Satchel] Can't synchronize without a valid table of items")
        return
    end

    Config.inventory = items
    SatchelRenderer.refreshSatchelAfterChange()
end)

AddEventHandler(Config.eventHandlerKey .. ":add_item", function(item)
    if type(item) ~= "table" or not item.id then
        print("[Native Satchel] Can't add an item without a valid item table with an ID")
        return
    end

    -- Check if item already exists
    local existingItem, index = Utils.findItemById(item.id)
    if existingItem then
        -- Overwrite existing item
        existingItem = item

        -- Since the item was modified, move it to the front
        table.insert(Config.inventory, 1, table.remove(Config.inventory, index))
    else
        -- Add new item
        table.insert(Config.inventory, 1, item)
    end

    SatchelRenderer.refreshSatchelAfterChange()
end)

AddEventHandler(Config.eventHandlerKey .. ":increment_item", function(itemId, count)
    if type(itemId) ~= "string" then
        print("[Native Satchel] Can't increment an item without a valid ID")
        return
    end

    if type(count) ~= "number" or count <= 0 then
        print("[Native Satchel] Can't increment an item without a positive count")
        return
    end

    local item, index = Utils.findItemById(itemId)

    if not item then
        print("[Native Satchel] Item '" .. itemId .. "' not found in the inventory")
        return
    end

    -- Increment item count
    item.count = (item.count or 0) + count

    -- Since the item was modified, move it to the front
    table.insert(Config.inventory, 1, table.remove(Config.inventory, index))

    SatchelRenderer.refreshSatchelAfterChange()
end)

AddEventHandler(Config.eventHandlerKey .. ":decrement_item", function(itemId, count)
    if type(itemId) ~= "string" then
        print("[Native Satchel] Can't decrement an item without a valid ID")
        return
    end

    if type(count) ~= "number" or count <= 0 then
        print("[Native Satchel] Can't decrement an item without a positive count")
        return
    end

    local item, index = Utils.findItemById(itemId)

    if not item then
        print("[Native Satchel] Item '" .. itemId .. "' not found in the inventory")
        return
    end

    item.count = math.max(0, (item.count or 0) - count)

    if item.count == 0 then
        -- Remove item if count reaches 0
        table.remove(Config.inventory, index)
    else
        -- Since the item was modified, move it to the front
        table.insert(Config.inventory, 1, table.remove(Config.inventory, index))
    end

    SatchelRenderer.refreshSatchelAfterChange()
end)

AddEventHandler(Config.eventHandlerKey .. ":remove_item", function(itemId)
    if type(itemId) ~= "string" then
        print("[Native Satchel] Can't remove an item without a valid ID")
        return
    end

    local item, index = Utils.findItemById(itemId)

    if not item then
        print("[Native Satchel] Item '" .. itemId .. "' not found in the inventory")
        return
    end

    table.remove(Config.inventory, index)

    SatchelRenderer.refreshSatchelAfterChange()
end)