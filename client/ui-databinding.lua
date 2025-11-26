---------------------------------------------------------------------------------
--                            REDM NATIVE SATCHEL                              --
--                           UI DataBinding Module                             --
--             Handles all UI databinding initialization and updates          --
---------------------------------------------------------------------------------

local UIDataBinding = {}

-- Initialize main satchel UI datastore
function UIDataBinding.initializeSatchelMainData()
    local datastore = DatabindingGetDataContainerFromPath("Satchel")

    if datastore == 0 or DatabindingIsEntryValid(datastore) ~= 1 then
        datastore = DatabindingAddDataContainerFromPath("", "Satchel")

        DatabindingAddDataBool(datastore, "FolderEmpty", false)

        -- Regular use prompt
        DatabindingAddDataHash(datastore, "PromptSelectLabel", joaat("SATCHEL_PROMPT_USE"))
        DatabindingAddDataBool(datastore, "PromptSelectEnabled", true)
        DatabindingAddDataBool(datastore, "PromptSelectVisible", true)

        -- Hold use prompt
        DatabindingAddDataHash(datastore, "PromptHoldSelectLabel", joaat("SATCHEL_PROMPT_BREAKDOWN"))
        DatabindingAddDataBool(datastore, "PromptHoldSelectEnabled", false)
        DatabindingAddDataBool(datastore, "PromptHoldSelectVisible", false)

        -- Discard prompt
        DatabindingAddDataBool(datastore, "PromptDropVisibile", false)

        -- Discard all prompt
        local discardingPrompt = ""
        if Config.discardingLabelHash and Config.discardingLabelHash ~= "" then
            discardingPrompt = GetStringFromHashKey(Config.discardingLabelHash)
        else
            discardingPrompt = Config.discardingLabel or GetStringFromHashKey("SATCHEL_PROMPT_DISCARD_ALL")
        end

        DatabindingAddDataString(datastore, "PromptDiscardAllLabel", discardingPrompt)
        DatabindingAddDataBool(datastore, "PromptDiscardAllEnabled", false)
        DatabindingAddDataBool(datastore, "PromptDiscardAllVisible", false)

        -- Send all prompt
        DatabindingAddDataHash(datastore, "PromptSendLabel", joaat("SATCHEL_PROMPT_USE"))
        DatabindingAddDataBool(datastore, "PromptSendAllVisible", false)
    end

    PlayerState.setPersistedInt("RefMainData", datastore)
end

-- Initialize selected item data
function UIDataBinding.initializeSatchelSelectedData()
    local datastore = PlayerState.getPersistedInt("RefSelectedData")

    if datastore == 0 or DatabindingIsEntryValid(datastore) ~= 1 then
        local parent = PlayerState.getPersistedInt("RefMainData")

        if parent == 0 or DatabindingIsEntryValid(parent) ~= 1 then
            print("[NativeSatchel] InitializeSatchelSelectedData: Main data wasn't ready in time!")
            return
        end

        datastore = DatabindingAddDataContainer(parent, "Selected")

        -- Hash for category label
        DatabindingAddDataHash(datastore, "Category", 0)

        -- The current selected category
        DatabindingAddDataInt(datastore, "CategoryIndex", 0)

        -- Amount of categories
        DatabindingAddDataInt(datastore, "CategoryCount", 0)

        -- The category the menu will open to, used when navigating back from folders
        DatabindingAddDataInt(datastore, "DefaultCategoryIndex", 0)

        -- Hash for selected label
        DatabindingAddDataHash(datastore, "Name", 0)

        -- String for selected label
        DatabindingAddDataString(datastore, "NameAsString", "")

        -- Hash for description
        DatabindingAddDataHash(datastore, "Description", 0)

        -- String for description
        DatabindingAddDataString(datastore, "DescriptionAsString", "")

        -- Hash for price label (left)
        DatabindingAddDataString(datastore, "PriceLabel", "")

        -- String for price amount (right)
        DatabindingAddDataString(datastore, "Price", "")

        -- String for items counter (X of Y)
        DatabindingAddDataString(datastore, "IndexDescription", "")

        -- String for footer text
        DatabindingAddDataString(datastore, "Tip", "")

        -- Hash for list items title (Folders)
        DatabindingAddDataHash(datastore, "Folder", 0)
    end

    PlayerState.setPersistedInt("RefSelectedData", datastore)
end

-- Initialize selected item effects data
function UIDataBinding.initializeSatchelSelectedEffects()
    local datastore = PlayerState.getPersistedInt("RefSelectedEffectsData")

    if datastore == 0 or DatabindingIsEntryValid(datastore) ~= 1 then
        local parent = PlayerState.getPersistedInt("RefSelectedData")

        if parent == 0 or DatabindingIsEntryValid(parent) ~= 1 then
            print("[NativeSatchel] InitializeSatchelSelectedEffects: Selected data wasn't ready in time!")
            return
        end

        datastore = DatabindingAddDataContainer(parent, "effects")

        DatabindingAddDataInt(datastore, "health", 0)
        DatabindingAddDataHash(datastore, "healthDurationCategory", 0)

        DatabindingAddDataInt(datastore, "stamina", 0)
        DatabindingAddDataHash(datastore, "staminaDurationCategory", 0)

        DatabindingAddDataInt(datastore, "deadeye", 0)
        DatabindingAddDataHash(datastore, "deadeyeDurationCategory", 0)

        DatabindingAddDataInt(datastore, "healthCore", 0)
        DatabindingAddDataHash(datastore, "healthCoreDurationCategory", 0)

        DatabindingAddDataInt(datastore, "staminaCore", 0)
        DatabindingAddDataHash(datastore, "staminaCoreDurationCategory", 0)

        DatabindingAddDataInt(datastore, "deadeyeCore", 0)
        DatabindingAddDataHash(datastore, "deadeyeCoreDurationCategory", 0)

        DatabindingAddDataInt(datastore, "healthHorse", 0)
        DatabindingAddDataHash(datastore, "healthHorseDurationCategory", 0)

        DatabindingAddDataInt(datastore, "staminaHorse", 0)
        DatabindingAddDataHash(datastore, "staminaHorseDurationCategory", 0)

        DatabindingAddDataInt(datastore, "healthCoreHorse", 0)
        DatabindingAddDataHash(datastore, "healthCoreHorseDurationCategory", 0)

        DatabindingAddDataInt(datastore, "staminaCoreHorse", 0)
        DatabindingAddDataHash(datastore, "staminaCoreHorseDurationCategory", 0)
    end

    PlayerState.setPersistedInt("RefSelectedEffectsData", datastore)
end

-- Initialize collection data
function UIDataBinding.initializeSatchelCollectionData()
    local list = PlayerState.getPersistedInt("RefCollectionData")

    if list == 0 or DatabindingIsEntryValid(list) ~= 1 then
        local parent = PlayerState.getPersistedInt("RefMainData")

        if parent == 0 or DatabindingIsEntryValid(parent) ~= 1 then
            print("[NativeSatchel] InitializeSatchelCollectionData: Main data wasn't ready in time!")
            return
        end

        list = DatabindingAddUiItemList(parent, "Collections")

        -- Player collection datastore
        local datastore = DatabindingAddDataContainer(list, "player")

        -- Current collection label
        local refSatchelLabel = DatabindingAddDataHash(datastore, "label", joaat("IB_SELECT"))
        PlayerState.setPersistedInt("RefSatchelLabel", refSatchelLabel)

        DatabindingInsertUiItemToListFromContextHashAlias(list, -1, -1287062382, datastore)
    end

    PlayerState.setPersistedInt("RefCollectionData", list)
end

-- Initialize category items
function UIDataBinding.initializeSatchelCategories()
    local datastore = PlayerState.getPersistedInt("RefCategoryItems")

    if datastore == 0 or DatabindingIsEntryValid(datastore) ~= 1 then
        datastore = DatabindingGetDataContainerFromPath("satchel_category_items")
    end

    PlayerState.setPersistedInt("RefCategoryItems", datastore)
end

-- Initialize menu items list
function UIDataBinding.initializeSatchelMenuItems()
    local datastore = PlayerState.getPersistedInt("RefMenuItems")

    if datastore == 0 or DatabindingIsEntryValid(datastore) ~= 1 then
        datastore = DatabindingGetDataContainerFromPath("satchel_menu_items")
    end

    PlayerState.setPersistedInt("RefMenuItems", datastore)
end

-- Initialize list items
function UIDataBinding.initializeSatchelListItems()
    local datastore = PlayerState.getPersistedInt("RefListItems")

    if datastore == 0 or DatabindingIsEntryValid(datastore) ~= 1 then
        datastore = DatabindingGetDataContainerFromPath("satchel_list_items")
    end

    PlayerState.setPersistedInt("RefListItems", datastore)
end

-- Update satchel label
function UIDataBinding.updateSatchelLabel(labelHash)
    local refSatchelLabel = PlayerState.getPersistedInt("RefSatchelLabel")

    if refSatchelLabel == 0 or DatabindingIsEntryValid(refSatchelLabel) ~= 1 then
        print("[NativeSatchel] UpdateSatchelLabel: Satchel label wasn't ready in time!")
        return
    end

    DatabindingWriteDataHashString(refSatchelLabel, labelHash)
end

-- Update UI prompts based on item configuration
function UIDataBinding.updateSatchelPrompts(config)
    local datastoreMain = PlayerState.getPersistedInt("RefMainData")

    if datastoreMain == 0 or DatabindingIsEntryValid(datastoreMain) ~= 1 then
        print("[NativeSatchel] UpdateSatchelPrompts: Main data wasn't ready in time!")
        return
    end

    -- Regular use prompt
    -- Note: For UI events to work, both this AND the hold labels must be set
    local selectLabel, selectEnabled, selectVisible = nil, nil, nil

    if config.folder then
        selectLabel = joaat("SATCHEL_PROMPT_USE")
        selectEnabled = Config.allowOpeningFolders or false
        selectVisible = Config.allowOpeningFolders or false
    elseif config.drinkable then
        selectLabel = joaat("SATCHEL_PROMPT_DRINK")
        selectEnabled = Config.allowDrinking or false
        selectVisible = Config.allowDrinking or false
    elseif config.edible then
        selectLabel = joaat("SATCHEL_PROMPT_EAT")
        selectEnabled = Config.allowEating or false
        selectVisible = Config.allowEating or false
    elseif config.readable then
        selectLabel = joaat("READ")
        selectEnabled = Config.allowReading or false
        selectVisible = Config.allowReading or false
    elseif config.usable then
        selectLabel = joaat("SATCHEL_PROMPT_USE")
        selectEnabled = Config.allowUsing or false
        selectVisible = Config.allowUsing or false
    else
        selectLabel = joaat("SATCHEL_PROMPT_USE")
        selectEnabled = false
        selectVisible = false
    end

    -- Hold use prompt
    -- Note: For UI events to work, both this AND the select labels must be set
    local holdSelectLabel, holdSelectEnabled, holdSelectVisible = nil, nil, nil

    if config.breakable then
        holdSelectLabel = joaat("SATCHEL_PROMPT_BREAKDOWN")
        holdSelectEnabled = Config.allowBreakdown or false
        holdSelectVisible = Config.allowBreakdown or false
    elseif config.cookable then
        holdSelectLabel = joaat("SATCHEL_PROMPT_COOK")
        holdSelectEnabled = Config.allowCooking or false
        holdSelectVisible = Config.allowCooking or false
    else
        holdSelectLabel = joaat("SATCHEL_PROMPT_BREAKDOWN")
        holdSelectEnabled = false
        holdSelectVisible = false
    end

    -- The UI cannot show both prompts at once
    if selectEnabled and holdSelectEnabled then
        holdSelectEnabled = false
        holdSelectVisible = false
    end

    -- Drop prompt
    local dropVisible = false
    if config.droppable then
        dropVisible = Config.allowDropping or false
    end

    -- Discard prompt
    local discardVisible = false
    if config.discardable then
        discardVisible = Config.allowDiscarding or false
    end

    -- Apply all prompt settings
    DatabindingWriteDataHashStringFromParent(datastoreMain, "PromptSelectLabel", selectLabel)
    DatabindingWriteDataBoolFromParent(datastoreMain, "PromptSelectEnabled", selectEnabled)
    DatabindingWriteDataBoolFromParent(datastoreMain, "PromptSelectVisible", selectVisible)

    DatabindingWriteDataHashStringFromParent(datastoreMain, "PromptHoldSelectLabel", holdSelectLabel)
    DatabindingWriteDataBoolFromParent(datastoreMain, "PromptHoldSelectEnabled", holdSelectEnabled)
    DatabindingWriteDataBoolFromParent(datastoreMain, "PromptHoldSelectVisible", holdSelectVisible)

    DatabindingWriteDataBoolFromParent(datastoreMain, "PromptDropVisibile", dropVisible)

    DatabindingWriteDataStringFromParent(datastoreMain, "PromptDiscardAllLabel", Config.discardingLabel)
    DatabindingWriteDataBoolFromParent(datastoreMain, "PromptDiscardAllEnabled", discardVisible)
    DatabindingWriteDataBoolFromParent(datastoreMain, "PromptDiscardAllVisible", discardVisible)

    DatabindingWriteDataHashStringFromParent(datastoreMain, "PromptSendLabel", joaat("SATCHEL_PROMPT_USE"))
    DatabindingWriteDataBoolFromParent(datastoreMain, "PromptSendAllVisible", false)
end

-- Update the index description (X of Y counter)
function UIDataBinding.updateSatchelIndexDescription(type)
    local datastoreSelected = PlayerState.getPersistedInt("RefSelectedData")

    if datastoreSelected == 0 or DatabindingIsEntryValid(datastoreSelected) ~= 1 then
        print("[NativeSatchel] UpdateSatchelIndexDescription: Selected data wasn't ready in time!")
        return
    end

    local total = 0

    if type == "item" then
        total = PlayerState.getPersistedInt("CurrentItemCount")
    else
        total = PlayerState.getPersistedInt("CurrentListCount")
    end

    local indexDescription = ""

    -- If there are more than 16 items (scrolling), add a "X of Y" counter
    if total > 16 then
        indexDescription = GetStringFromHashKey("ENTRY_COUNTER")
        indexDescription = indexDescription:gsub("~1~", PlayerState.getPersistedInt("CurrentItemIndex") + 1)
        indexDescription = indexDescription:gsub("~2~", total)
    end

    DatabindingWriteStringFromParent(datastoreSelected, "IndexDescription", indexDescription)
end

-- Make UIDataBinding globally available
_G.UIDataBinding = UIDataBinding