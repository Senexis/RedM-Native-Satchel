SatchelUI = {
    Builder = {},
    Events = {},
    Prompts = {},
    Index = {},
    Scene = {},
}

SatchelUI.bindings = {
    dscMain = 0,
    dscSelected = 0,
    dscSelectedEffects = 0,
    dscSatchelCategoryItems = 0,
    dscSatchelMenuItems = 0,
    dscSatchelListItems = 0,
    dsiCategoryDefault = 0,
    dsiCategoryIndex = 0,
}

SatchelUI.state = {
    entry = nil,
    indexMenuCurrent = 0,
    indexMenuTotal = 0,
    indexListCurrent = 0,
    indexListTotal = 0,
}

local VALID_EFFECTS <const> = {
    "health",
    "stamina",
    "deadeye",
    "healthCore",
    "staminaCore",
    "deadeyeCore",
    "healthHorse",
    "staminaHorse",
    "healthCoreHorse",
    "staminaCoreHorse",
}

function SatchelUI.Initialize()
    local main = DatabindingAddDataContainerFromPath("", "Satchel")

    -- Main
    DatabindingAddDataBool(main, "FolderEmpty", true)
    DatabindingAddDataHash(main, "PromptSelectLabel", 0)
    DatabindingAddDataBool(main, "PromptSelectEnabled", false)
    DatabindingAddDataBool(main, "PromptSelectVisible", false)
    DatabindingAddDataHash(main, "PromptHoldSelectLabel", 0)
    DatabindingAddDataBool(main, "PromptHoldSelectEnabled", false)
    DatabindingAddDataBool(main, "PromptHoldSelectVisible", false)
    DatabindingAddDataString(main, "PromptDiscardAllLabel", "")
    DatabindingAddDataBool(main, "PromptDiscardAllEnabled", false)
    DatabindingAddDataBool(main, "PromptDiscardAllVisible", false)
    DatabindingAddDataBool(main, "PromptDropVisibile", false)
    DatabindingAddDataBool(main, "PromptSendAllVisible", false)

    -- Selected
    local selected = DatabindingAddDataContainer(main, "Selected")
    DatabindingAddDataHash(selected, "Name", 0)
    DatabindingAddDataString(selected, "NameAsString", "")
    DatabindingAddDataHash(selected, "Description", 0)
    DatabindingAddDataString(selected, "DescriptionAsString", "")
    DatabindingAddDataHash(selected, "PriceLabel", 0)
    DatabindingAddDataString(selected, "Price", "")
    DatabindingAddDataHash(selected, "Category", 0)
    SatchelUI.bindings.dsiCategoryDefault = DatabindingAddDataInt(selected, "DefaultCategoryIndex", 0)
    SatchelUI.bindings.dsiCategoryIndex = DatabindingAddDataInt(selected, "CategoryIndex", 0)
    DatabindingAddDataInt(selected, "CategoryCount", 0)
    DatabindingAddDataString(selected, "IndexDescription", "")
    DatabindingAddDataString(selected, "Tip", "")
    DatabindingAddDataHash(selected, "Folder", 0)

    -- Selected effects
    local effects = DatabindingAddDataContainer(selected, "effects")
    for _, effect in pairs(VALID_EFFECTS) do
        DatabindingAddDataInt(effects, effect, 0)
        DatabindingAddDataHash(effects, effect .. "DurationCategory", 0)
    end

    SatchelUI.bindings.dscMain = main
    SatchelUI.bindings.dscSelected = selected
    SatchelUI.bindings.dscSelectedEffects = effects
end

function SatchelUI.CreateTextEntry(type, id, text)
    local key = string.format(
        "NSAT_%s_%s",
        tostring(type):upper(),
        tostring(id):upper()
    )

    if DoesTextLabelExist(key) ~= 1 then
        AddTextEntry(key, text)
    end

    return key
end

function SatchelUI.Open(mode, index)
    if IsUiappRunning("satchel") == 1 then
        print("[NativeSatchel] UI is already open. Please close the satchel before opening it.")
        return
    end

    if mode == "shop" then
        SatchelUI.state.entry = "shop"
    else
        SatchelUI.state.entry = "ingame"
    end

    SatchelUI.LoadResources()
    SatchelUI.SetupNavigator()
    SatchelUI.Initialize()

    if type(index) == "number" then
        SatchelNavigator:setCategory(index)
    else
        SatchelNavigator:setCategory(Config.defaultCategoryIndex or 1)
    end

    SatchelUI.Events.HandleNavigation()
    SatchelData.Startup()

    LaunchUiappWithEntry("satchel", SatchelUI.state.entry)

    TriggerEvent("native_satchel:opened", SatchelUI.state.entry)
    TriggerEvent("native_satchel:satchel_opened", SatchelUI.state.entry)

    Citizen.CreateThread(function()
        -- Only hook into the always-running event handler while the UI is open
        while IsUiappRunning("satchel") == 1 do
            Citizen.Wait(0)

            local success, error = pcall(SatchelData.MaintainEvents)

            -- If something went wrong, close the UI to prevent the user from getting stuck
            if not success then
                print("[NativeSatchel] An error occurred while processing events: ")
                print("  " .. tostring(error))

                CloseUiappImmediate("satchel")
            end
        end

        SatchelUI.OnShutdown()
    end)
end

function SatchelUI.Exit(mode)
    if IsUiappRunning("satchel") ~= 1 then return end
    if mode and SatchelUI.state.entry ~= mode then return end

    CloseUiapp("satchel")
    SatchelUI.OnShutdown()
end

function SatchelUI.OnShutdown()
    SatchelData.Shutdown()

    DatabindingRemoveDataEntry(SatchelUI.bindings.dscMain)
    SatchelUI.bindings.dscMain = 0

    DatabindingRemoveDataEntry(SatchelUI.bindings.dscSatchelCategoryItems)
    SatchelUI.bindings.dscSatchelCategoryItems = 0

    DatabindingRemoveDataEntry(SatchelUI.bindings.dscSatchelMenuItems)
    SatchelUI.bindings.dscSatchelMenuItems = 0

    DatabindingRemoveDataEntry(SatchelUI.bindings.dscSatchelListItems)
    SatchelUI.bindings.dscSatchelListItems = 0

    TriggerEvent("native_satchel:closed", SatchelUI.state.entry)
    TriggerEvent("native_satchel:satchel_closed", SatchelUI.state.entry)
end

function SatchelUI.LoadResources()
    local TEXT_BLOCKS <const> = {
        "satch",
        "shop",
    }

    for _, block in pairs(TEXT_BLOCKS) do
        TextBlockRequest(block)
        while TextBlockIsLoaded(block) ~= 1 do
            Citizen.Wait(0)
        end
    end

    local TEXTURE_DICTS <const> = {
        "satchel_textures",
        "inventory_items",
        "inventory_items_mp",
    }

    for _, dict in pairs(TEXTURE_DICTS) do
        RequestStreamedTxd(dict, false)
        while HasStreamedTxdLoaded(dict) ~= 1 do
            Citizen.Wait(0)
        end
    end
end

function SatchelUI.SetupNavigator()
    SatchelNavigator:setCategories(Config.categories)
    SatchelNavigator:setFolders(Config.folders)
    SatchelNavigator:setInventory(Config.inventory)
end

function SatchelUI.ClearListItems()
    local dscItems = SatchelUI.bindings.dscSatchelListItems
    DatabindingSetTemplatedUiItemListSize(dscItems, 0)

    SatchelData.state.hydratedList = nil
end

function SatchelUI.RefreshMenu()
    SatchelUI.Events.HandleNavigation()
    SatchelUI.Builder.AddMenuItems()
end

function SatchelUI.UpdateMenuTitle()
    local category = SatchelNavigator:getCurrentCategory()
    if not category then return end

    local dscSelected = SatchelUI.bindings.dscSelected
    if category.title and category.title ~= "" then
        local key = SatchelUI.CreateTextEntry("category_title", category.id, category.title)
        DatabindingWriteDataHashStringFromParent(dscSelected, "Category", key)
    elseif category.titleHash and category.titleHash ~= 0 then
        DatabindingWriteDataHashStringFromParent(dscSelected, "Category", category.titleHash)
    else
        DatabindingWriteDataHashStringFromParent(dscSelected, "Category", 0)
    end
end

function SatchelUI.UpdateListTitle(folderId)
    local folder = SatchelNavigator:getFolderById(folderId)
    if not folder then return end

    local dscSelected = SatchelUI.bindings.dscSelected
    if folder.title and folder.title ~= "" then
        local key = SatchelUI.CreateTextEntry("folder_title", folder.id, folder.title)
        DatabindingWriteDataHashStringFromParent(dscSelected, "Folder", key)
    elseif folder.titleHash and folder.titleHash ~= 0 then
        DatabindingWriteDataHashStringFromParent(dscSelected, "Folder", folder.titleHash)
    else
        DatabindingWriteDataHashStringFromParent(dscSelected, "Folder", 0)
    end
end

function SatchelUI.Builder.AddCategories()
    -- Game defined constants (see satchel_launcher_flow.ymt)
    local MAX_SIZE <const> = 11

    local dscItems = SatchelUI.bindings.dscSatchelCategoryItems
    DatabindingSetTemplatedUiItemListSize(dscItems, 0)

    local items = SatchelNavigator:getCategories()
    if #items > MAX_SIZE then
        print(string.format("[NativeSatchel] Warning: Building over %d categories, ignoring overflow", MAX_SIZE))
    end

    local currentIndex = SatchelNavigator:getCurrentCategoryIndex()

    local count = 0
    for index, category in ipairs(items) do
        SatchelUI.Builder.BuildCategory(dscItems, index, category, index == currentIndex)
        count += 1

        if count >= MAX_SIZE then
            break
        end
    end

    local dscSelected = SatchelUI.bindings.dscSelected
    DatabindingWriteDataIntFromParent(dscSelected, "CategoryIndex", currentIndex)
    DatabindingWriteDataIntFromParent(dscSelected, "CategoryCount", count)

    DatabindingSetTemplatedUiItemListSize(dscItems, count)
end

function SatchelUI.Builder.AddMenuItems()
    -- Game defined constants (see satchel_launcher_flow.ymt)
    local MAX_SIZE <const> = 448
    local MAX_ELEMENTS_BUILT_PER_FRAME <const> = 112

    local dscItems = SatchelUI.bindings.dscSatchelMenuItems
    DatabindingSetTemplatedUiItemListSize(dscItems, 0)

    local items = SatchelNavigator:getCurrentItems()
    if #items > MAX_SIZE then
        print(string.format("[NativeSatchel] Warning: Building over %d menu items, ignoring overflow", MAX_SIZE))
    end

    local count = 0
    for index, item in ipairs(items) do
        SatchelUI.Builder.BuildMenuItem(dscItems, index, item)
        count += 1

        if count % MAX_ELEMENTS_BUILT_PER_FRAME == 0 then
            Citizen.Wait(0)
        elseif count >= MAX_SIZE then
            break
        end
    end

    DatabindingSetTemplatedUiItemListSize(dscItems, count)
    SatchelUI.Index.SetTotal("menu", count)

    if count <= 0 then
        SatchelUI.Scene.SetCategoryEmpty()
    end
end

function SatchelUI.Builder.AddListItems(id)
    -- Game defined constants (see satchel_launcher_flow.ymt)
    local MAX_SIZE <const> = 130

    local dscMain = SatchelUI.bindings.dscMain
    local dscItems = SatchelUI.bindings.dscSatchelListItems
    DatabindingSetTemplatedUiItemListSize(dscItems, 0)

    local items = SatchelNavigator:getFolderContents(id)
    if #items > MAX_SIZE then
        print(string.format("[NativeSatchel] Warning: Building over %d list items, ignoring overflow", MAX_SIZE))
    end

    local count = 0
    for index, item in ipairs(items) do
        SatchelUI.Builder.BuildListItem(dscItems, index, item)
        count += 1

        if count >= MAX_SIZE then
            break
        end
    end

    DatabindingSetTemplatedUiItemListSize(dscItems, count)
    SatchelUI.Index.SetTotal("list", count)
    DatabindingWriteDataBoolFromParent(dscMain, "FolderEmpty", count <= 0)
end

function SatchelUI.Builder.BuildCategory(container, index, item, current)
    local texture = item.texture or "satchel_nav_all"

    local data = DatabindingGetDataContainerFromChildIndex(container, index - 1)
    while DatabindingIsEntryValid(data) ~= 1 do
        data = DatabindingGetDataContainerFromChildIndex(container, index - 1)
        Citizen.Wait(0)
    end

    DatabindingAddDataHash(data, "IconTexture", texture)
    DatabindingAddDataBool(data, "CurrentCategory", current)

    DatabindingSetTemplatedUiItemHashAlias(container, index - 1, `category_item`)
end

function SatchelUI.Builder.BuildMenuItem(container, index, item)
    local id = item.id
    local hash = joaat(id)
    local type = item.type == "folder" and "folder_item" or "inventory_item"
    local count = item.count
    local maxCount = item.maxCount
    local enabled = item.type == "folder" or item.enabled
    local txd = item.txd or "inventory_items"
    local texture = item.texture or "_placeholder"
    local special = item.special or false
    local stars = item.stars or 0
    local color = item.color or `COLOR_PURE_WHITE`

    local data = DatabindingGetDataContainerFromChildIndex(container, index - 1)
    while DatabindingIsEntryValid(data) ~= 1 do
        data = DatabindingGetDataContainerFromChildIndex(container, index - 1)
        Citizen.Wait(0)
    end

    DatabindingAddDataHash(data, "item", hash)
    DatabindingAddDataString(data, "uiItemID", id)
    DatabindingAddDataString(data, "uiItemType", type)
    DatabindingAddDataBool(data, "focusable", enabled)
    DatabindingAddDataHash(data, "color", color)
    DatabindingAddDataHash(data, "ItemTXD", txd)
    DatabindingAddDataHash(data, "ItemTexture", texture)
    DatabindingAddDataInt(data, "quality", stars)
    DatabindingAddDataBool(data, "overpowered", special)

    if not Config.enableFolderItemCount and item.type == "folder" then
        DatabindingAddDataInt(data, "count", 1)
        DatabindingAddDataBool(data, "maxCount", false)
    else
        DatabindingAddDataInt(data, "count", count)

        if Config.enableRedCountOnMax and maxCount and count >= maxCount then
            DatabindingAddDataBool(data, "maxCount", true)
        else
            DatabindingAddDataBool(data, "maxCount", false)
        end
    end

    DatabindingSetTemplatedUiItemHashAlias(container, index - 1, type)

    return data
end

function SatchelUI.Builder.BuildListItem(container, index, item)
    local id = item.id
    local hash = joaat(id)
    local count = item.count
    local maxCount = item.maxCount
    local enabled = item.enabled
    local label = item.label or id
    local color = item.color or `COLOR_PURE_WHITE`
    local isEquipped = item.equipped or false

    local data = DatabindingGetDataContainerFromChildIndex(container, index - 1)
    while DatabindingIsEntryValid(data) ~= 1 do
        data = DatabindingGetDataContainerFromChildIndex(container, index - 1)
        Citizen.Wait(0)
    end

    DatabindingAddDataHash(data, "item", hash)
    DatabindingAddDataString(data, "uiItemID", id)
    DatabindingAddDataString(data, "uiItemType", "list_item")
    DatabindingAddDataInt(data, "count", count)
    DatabindingAddDataBool(data, "focusable", enabled)
    DatabindingAddDataHash(data, "color", color)
    DatabindingAddDataBool(data, "equipped", isEquipped)

    if item.label and item.label ~= "" then
        DatabindingAddDataHash(data, "label", 0)
        DatabindingAddDataString(data, "label_as_string", item.label)
    elseif item.labelHash and item.labelHash ~= 0 then
        DatabindingAddDataHash(data, "label", item.labelHash)
        DatabindingAddDataString(data, "label_as_string", "")
    else
        DatabindingAddDataHash(data, "label", 0)
        DatabindingAddDataString(data, "label_as_string", id)
    end

    if Config.enableRedCountOnMax and maxCount and count >= maxCount then
        DatabindingAddDataBool(data, "maxCount", true)
    else
        DatabindingAddDataBool(data, "maxCount", false)
    end

    DatabindingSetTemplatedUiItemHashAlias(container, index - 1, "list_item")

    return data
end

function SatchelUI.Events.HandleFolderFocus(id)
    local folder = SatchelNavigator:getFolderById(id)
    if not folder then return end

    SatchelUI.Prompts.SetFolderPrompts()
    SatchelUI.Scene.SetFromItem(folder)

    TriggerEvent("native_satchel:folder_focused", id)
end

function SatchelUI.Events.HandleItemFocus(id)
    local item = SatchelNavigator:getItemById(id)
    if not item then return end

    SatchelUI.Prompts.SetFromItem(item)
    SatchelUI.Scene.SetFromItem(item)

    if Config.enableItemPreview == true and SatchelUI.state.entry ~= "shop" then
        if item.catalog and ItemdatabaseIsKeyValid(item.catalog, 0) then
            -- 1 for player, 2 for horse
            StartItemPreview(item.catalog, 1)
        end
    end

    TriggerEvent("native_satchel:item_focused", id)
end

function SatchelUI.Events.HandleUnfocus()
    SatchelUI.Prompts.Clear()
    SatchelUI.Scene.Clear()

    if Config.enableItemPreview == true and SatchelUI.state.entry ~= "shop" then
        StopItemPreview()
    end
end

function SatchelUI.Events.HandleNavigation()
    SatchelUI.Events.HandleUnfocus()
    SatchelUI.UpdateMenuTitle()
end

function SatchelUI.Prompts.SetFolderPrompts()
    SatchelUI.Prompts.SetSelectPrompt(`SATCHEL_PROMPT_OPEN`, Config.allowOpeningFolders, Config.allowOpeningFolders)
    SatchelUI.Prompts.SetHoldSelectPrompt()
    SatchelUI.Prompts.SetDropPrompt()
    SatchelUI.Prompts.SetDiscardPrompt()
    SatchelUI.Prompts.SetSendAllPrompt()
end

function SatchelUI.Prompts.SetFromItem(item)
    -- Regular use prompt
    -- Note: For UI events to work, both this AND the hold labels must be set
    local selectLabel, selectEnabled, selectVisible = nil, nil, nil

    if item.useLabel and item.useLabel ~= "" then
        selectLabel = SatchelUI.CreateTextEntry("select_label", item.id, item.useLabel)
        selectEnabled = Config.allowUsing or false
        selectVisible = Config.allowUsing or false
    elseif item.useLabelHash and item.useLabelHash ~= 0 then
        selectLabel = item.useLabelHash
        selectEnabled = Config.allowUsing or false
        selectVisible = Config.allowUsing or false
    elseif item.drinkable then
        selectLabel = `SATCHEL_PROMPT_DRINK`
        selectEnabled = Config.allowDrinking or false
        selectVisible = Config.allowDrinking or false
    elseif item.edible then
        selectLabel = `SATCHEL_PROMPT_EAT`
        selectEnabled = Config.allowEating or false
        selectVisible = Config.allowEating or false
    elseif item.readable then
        selectLabel = `READ`
        selectEnabled = Config.allowReading or false
        selectVisible = Config.allowReading or false
    elseif item.usable then
        selectLabel = `SATCHEL_PROMPT_USE`
        selectEnabled = Config.allowUsing or false
        selectVisible = Config.allowUsing or false
    else
        selectLabel = `SATCHEL_PROMPT_USE`
        selectEnabled = false
        selectVisible = false
    end

    -- Hold use prompt
    -- Note: For UI events to work, both this AND the select labels must be set
    local holdSelectLabel, holdSelectEnabled, holdSelectVisible = nil, nil, nil

    if item.craftLabel and item.craftLabel ~= "" then
        holdSelectLabel = SatchelUI.CreateTextEntry("hold_select_label", item.id, item.craftLabel)
        holdSelectEnabled = Config.allowUsing or false
        holdSelectVisible = Config.allowUsing or false
    elseif item.craftLabelHash and item.craftLabelHash ~= 0 then
        holdSelectLabel = item.craftLabelHash
        holdSelectEnabled = Config.allowUsing or false
        holdSelectVisible = Config.allowUsing or false
    elseif item.breakable then
        holdSelectLabel = `SATCHEL_PROMPT_BREAKDOWN`
        holdSelectEnabled = Config.allowBreakdown or false
        holdSelectVisible = Config.allowBreakdown or false
    elseif item.cookable then
        holdSelectLabel = `SATCHEL_PROMPT_COOK`
        holdSelectEnabled = Config.allowCooking or false
        holdSelectVisible = Config.allowCooking or false
    else
        holdSelectLabel = `SATCHEL_PROMPT_BREAKDOWN`
        holdSelectEnabled = false
        holdSelectVisible = false
    end

    -- The UI cannot show both prompts at once
    if selectEnabled and holdSelectEnabled then
        selectEnabled = false
        selectVisible = false
    end

    -- Drop prompt
    local dropVisible = false
    if item.droppable then
        dropVisible = Config.allowDropping or false
    end

    -- Discard prompt
    local discardLabel, discardVisible = nil, false
    if item.discardLabel and item.discardLabel ~= "" then
        discardLabel = item.discardLabel
        discardVisible = Config.allowDiscarding or false
    elseif item.discardLabelHash and item.discardLabelHash ~= 0 then
        discardLabel = GetStringFromHashKey(item.discardLabelHash)
        discardVisible = Config.allowDiscarding or false
    elseif item.discardable then
        discardLabel = GetStringFromHashKey(`SATCHEL_PROMPT_DISCARD_ALL`)
        discardVisible = Config.allowDiscarding or false
    end

    -- Folder item exclusive: Send all prompt
    local sendAllVisible = false
    if item.sendable then
        sendAllVisible = Config.allowSending or false
    end

    SatchelUI.Prompts.SetSelectPrompt(selectLabel, selectEnabled, selectVisible)
    SatchelUI.Prompts.SetHoldSelectPrompt(holdSelectLabel, holdSelectEnabled, holdSelectVisible)
    SatchelUI.Prompts.SetDropPrompt(dropVisible)
    SatchelUI.Prompts.SetDiscardPrompt(discardLabel, discardVisible, discardVisible)
    SatchelUI.Prompts.SetSendAllPrompt(sendAllVisible)
end

---@param label number|string|nil The label hash or text to show on the select prompt
---@param enabled boolean|nil Whether the prompt should be enabled (interactable)
---@param visible boolean|nil Whether the prompt should be visible
function SatchelUI.Prompts.SetSelectPrompt(label, enabled, visible)
    local dscMain = SatchelUI.bindings.dscMain
    DatabindingWriteDataHashStringFromParent(dscMain, "PromptSelectLabel", label or 0)
    DatabindingWriteDataBoolFromParent(dscMain, "PromptSelectEnabled", enabled or false)
    DatabindingWriteDataBoolFromParent(dscMain, "PromptSelectVisible", visible or false)
end

---@param label number|string|nil The label hash or text to show on the hold select prompt
---@param enabled boolean|nil Whether the prompt should be enabled (interactable)
---@param visible boolean|nil Whether the prompt should be visible
function SatchelUI.Prompts.SetHoldSelectPrompt(label, enabled, visible)
    local dscMain = SatchelUI.bindings.dscMain
    DatabindingWriteDataHashStringFromParent(dscMain, "PromptHoldSelectLabel", label or 0)
    DatabindingWriteDataBoolFromParent(dscMain, "PromptHoldSelectEnabled", enabled or false)
    DatabindingWriteDataBoolFromParent(dscMain, "PromptHoldSelectVisible", visible or false)
end

---@param visible boolean|nil Whether the drop prompt should be visible
function SatchelUI.Prompts.SetDropPrompt(visible)
    local dscMain = SatchelUI.bindings.dscMain
    DatabindingWriteDataBoolFromParent(dscMain, "PromptDropVisibile", visible or false)
end

---@param label string|nil The label hash or text to show on the discard prompt
---@param enabled boolean|nil Whether the prompt should be enabled (interactable)
---@param visible boolean|nil Whether the prompt should be visible
function SatchelUI.Prompts.SetDiscardPrompt(label, enabled, visible)
    local dscMain = SatchelUI.bindings.dscMain
    DatabindingWriteStringFromParent(dscMain, "PromptDiscardAllLabel", label or "")
    DatabindingWriteDataBoolFromParent(dscMain, "PromptDiscardAllEnabled", enabled or false)
    DatabindingWriteDataBoolFromParent(dscMain, "PromptDiscardAllVisible", visible or false)
end

---@param visible boolean|nil Whether the send all prompt should be visible
function SatchelUI.Prompts.SetSendAllPrompt(visible)
    local dscMain = SatchelUI.bindings.dscMain
    DatabindingWriteDataBoolFromParent(dscMain, "PromptSendAllVisible", visible or false)
end

function SatchelUI.Prompts.Clear()
    SatchelUI.Prompts.SetSelectPrompt()
    SatchelUI.Prompts.SetHoldSelectPrompt()
    SatchelUI.Prompts.SetDropPrompt()
    SatchelUI.Prompts.SetDiscardPrompt()
    SatchelUI.Prompts.SetSendAllPrompt()
end

function SatchelUI.Index.SetCurrent(type, index)
    if type == "menu" then
        SatchelUI.state.indexMenuCurrent = index
    else
        SatchelUI.state.indexListCurrent = index
    end

    SatchelUI.Index.Update(type)
end

function SatchelUI.Index.SetTotal(type, total)
    if type == "menu" then
        SatchelUI.state.indexMenuTotal = total
    else
        SatchelUI.state.indexListTotal = total
    end
end

function SatchelUI.Index.Update(type)
    local index, total = 0, 0
    if type == "menu" then
        index = SatchelUI.state.indexMenuCurrent
        total = SatchelUI.state.indexMenuTotal
    else
        index = SatchelUI.state.indexListCurrent
        total = SatchelUI.state.indexListTotal
    end

    if type == "menu" and total <= 16 then
        SatchelUI.Index.Clear()
        return
    elseif total <= 8 then
        SatchelUI.Index.Clear()
        return
    end

    local text = GetStringFromHashKey("ENTRY_COUNTER")
        :gsub("~1~", tostring(index + 1))
        :gsub("~2~", tostring(total))

    local dscSelected = SatchelUI.bindings.dscSelected
    DatabindingWriteStringFromParent(dscSelected, "IndexDescription", text)
end

function SatchelUI.Index.Clear()
    local dscSelected = SatchelUI.bindings.dscSelected
    DatabindingWriteStringFromParent(dscSelected, "IndexDescription", "")
end

function SatchelUI.Scene.SetCategoryEmpty()
    local category = SatchelNavigator:getCurrentCategory()
    if not category then return end

    if category.emptyLabel and category.emptyLabel ~= "" then
        SatchelUI.Scene.SetName(category.emptyLabel)
    elseif category.emptyLabelHash and category.emptyLabelHash ~= 0 then
        SatchelUI.Scene.SetName(category.emptyLabelHash, true)
    else
        SatchelUI.Scene.ClearName()
    end

    if category.emptyDescription and category.emptyDescription ~= "" then
        SatchelUI.Scene.SetDescription(category.emptyDescription)
    elseif category.emptyDescriptionHash and category.emptyDescriptionHash ~= 0 then
        SatchelUI.Scene.SetDescription(category.emptyDescriptionHash, true)
    else
        SatchelUI.Scene.ClearDescription()
    end
end

function SatchelUI.Scene.SetFromItem(item)
    if item.label and item.label ~= "" then
        SatchelUI.Scene.SetName(item.label)
    elseif item.labelHash and item.labelHash ~= 0 then
        SatchelUI.Scene.SetName(item.labelHash, true)
    else
        SatchelUI.Scene.ClearName()
    end

    if item.description and item.description ~= "" then
        SatchelUI.Scene.SetDescription(item.description)
    elseif item.descriptionHash and item.descriptionHash ~= 0 then
        SatchelUI.Scene.SetDescription(item.descriptionHash, true)
    else
        SatchelUI.Scene.ClearDescription()
    end

    if item.priceLabel and item.priceLabel ~= "" then
        local key = SatchelUI.CreateTextEntry("price_label", item.id, item.priceLabel)
        SatchelUI.Scene.SetPriceLabel(key)
    elseif item.priceLabelHash and item.priceLabelHash ~= 0 then
        SatchelUI.Scene.SetPriceLabel(item.priceLabelHash)
    else
        SatchelUI.Scene.ClearPriceLabel()
    end

    if item.priceValue and item.priceValue ~= "" then
        SatchelUI.Scene.SetPriceValue(item.priceValue)
    elseif item.priceValueHash and item.priceValueHash ~= 0 then
        local value = GetStringFromHashKey(item.priceValueHash)
        SatchelUI.Scene.SetPriceValue(value)
    else
        SatchelUI.Scene.ClearPriceValue()
    end

    if item.footer and item.footer ~= "" then
        SatchelUI.Scene.SetFooter(item.footer)
    elseif item.footerHash and item.footerHash ~= 0 then
        local value = GetStringFromHashKey(item.footerHash)
        SatchelUI.Scene.SetFooter(value)
    else
        SatchelUI.Scene.SetFooterFromItem(item)
    end

    if item.effects then
        SatchelUI.Scene.SetEffectsFromItem(item.effects)
    else
        SatchelUI.Scene.ClearEffects()
    end
end

function SatchelUI.Scene.SetName(name, hash)
    local dscSelected = SatchelUI.bindings.dscSelected
    if hash == true then
        DatabindingWriteDataHashStringFromParent(dscSelected, "Name", name)
        DatabindingWriteStringFromParent(dscSelected, "NameAsString", "")
    else
        DatabindingWriteDataHashStringFromParent(dscSelected, "Name", 0)
        DatabindingWriteStringFromParent(dscSelected, "NameAsString", name)
    end
end

function SatchelUI.Scene.SetDescription(description, hash)
    local dscSelected = SatchelUI.bindings.dscSelected
    if hash == true then
        DatabindingWriteDataHashStringFromParent(dscSelected, "Description", description)
        DatabindingWriteStringFromParent(dscSelected, "DescriptionAsString", "")
    else
        DatabindingWriteDataHashStringFromParent(dscSelected, "Description", 0)
        DatabindingWriteStringFromParent(dscSelected, "DescriptionAsString", description)
    end
end

function SatchelUI.Scene.SetPriceLabel(priceLabel)
    if Config.enableItemValueInRegularSatchel ~= true and SatchelUI.state.entry ~= "shop" then
        SatchelUI.Scene.ClearPriceLabel()
        return
    end

    local dscSelected = SatchelUI.bindings.dscSelected
    DatabindingWriteDataHashStringFromParent(dscSelected, "PriceLabel", priceLabel)
end

function SatchelUI.Scene.SetPriceValue(priceValue)
    if Config.enableItemValueInRegularSatchel ~= true and SatchelUI.state.entry ~= "shop" then
        SatchelUI.Scene.ClearPriceValue()
        return
    end

    local dscSelected = SatchelUI.bindings.dscSelected
    DatabindingWriteStringFromParent(dscSelected, "Price", priceValue)
end

function SatchelUI.Scene.SetFooter(footer)
    local dscSelected = SatchelUI.bindings.dscSelected
    DatabindingWriteStringFromParent(dscSelected, "Tip", footer)
end

function SatchelUI.Scene.SetFooterFromItem(item)
    local count = item.count
    local maxCount = item.maxCount
    local result = ""

    if count and count > 0 then
        if maxCount then
            if maxCount == 1 then
                result = GetStringFromHashKey("SATCHEL_TIP_UNIQUE")
            elseif count < maxCount then
                result = GetStringFromHashKey("SATCHEL_TIP_CAPACITY")
                    :gsub("~1~", count)
                    :gsub("~2~", maxCount)
            else
                result = GetStringFromHashKey("SATCHEL_TIP_CAPACITY_FULL")
                    :gsub("~1~", count)
                    :gsub("~2~", maxCount)
            end
        else
            result = GetStringFromHashKey("SATCHEL_TIP_INFINITE")
                :gsub("~1~", count)
        end
    end

    SatchelUI.Scene.SetFooter(result)
end

function SatchelUI.Scene.SetEffectsFromItem(effects)
    local dscEffects = SatchelUI.bindings.dscSelectedEffects

    local DURATION_HASHES <const> = {
        [0] = 0,
        [1] = 0xB65F115D,
        [2] = 0xEC9E7DDB,
        [3] = 0x22E96A70,
        [4] = 0xC912B6C4,
    }

    for _, effect in pairs(VALID_EFFECTS) do
        local effectData = effects[effect]

        if type(effectData) == "table" then
            local value = effectData.Value or effectData.value or 0
            local duration = effectData.Duration or effectData.duration or 0
            local category = DURATION_HASHES[duration] or 0

            DatabindingWriteDataIntFromParent(dscEffects, effect, value)
            DatabindingWriteDataHashStringFromParent(dscEffects, effect .. "DurationCategory", category)
        end
    end
end

function SatchelUI.Scene.Clear()
    SatchelUI.Scene.ClearName()
    SatchelUI.Scene.ClearDescription()
    SatchelUI.Scene.ClearPriceLabel()
    SatchelUI.Scene.ClearPriceValue()
    SatchelUI.Scene.ClearFooter()
    SatchelUI.Scene.ClearEffects()
end

function SatchelUI.Scene.ClearName()
    local dscSelected = SatchelUI.bindings.dscSelected
    DatabindingWriteDataHashStringFromParent(dscSelected, "Name", 0)
    DatabindingWriteStringFromParent(dscSelected, "NameAsString", "")
end

function SatchelUI.Scene.ClearDescription()
    local dscSelected = SatchelUI.bindings.dscSelected
    DatabindingWriteDataHashStringFromParent(dscSelected, "Description", 0)
    DatabindingWriteStringFromParent(dscSelected, "DescriptionAsString", "")
end

function SatchelUI.Scene.ClearPriceLabel()
    local dscSelected = SatchelUI.bindings.dscSelected
    DatabindingWriteDataHashStringFromParent(dscSelected, "PriceLabel", 0)
end

function SatchelUI.Scene.ClearPriceValue()
    local dscSelected = SatchelUI.bindings.dscSelected
    DatabindingWriteStringFromParent(dscSelected, "Price", "")
end

function SatchelUI.Scene.ClearFooter()
    local dscSelected = SatchelUI.bindings.dscSelected
    DatabindingWriteStringFromParent(dscSelected, "Tip", "")
end

function SatchelUI.Scene.ClearEffects()
    local effects = SatchelUI.bindings.dscSelectedEffects

    for _, effect in pairs(VALID_EFFECTS) do
        DatabindingWriteDataIntFromParent(effects, effect, 0)
        DatabindingWriteDataHashStringFromParent(effects, effect .. "DurationCategory", 0)
    end
end
