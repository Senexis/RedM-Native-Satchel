local uiAppChannel = joaat("satchel")
local uiEventChannel = joaat("satchel_menu")

Ephemeral = {
    cacheCategoryItems = {},
    cacheItemDatabase = {},
    cacheItems = {},
    cacheMenuItems = {},
    cachePersistence = {},
    stateIsShopMode = false,
    stateOverrideCategoryIndex = nil,
    stateResourcesLoaded = false,
}

function InitializeResources()
    Citizen.CreateThread(function()
        Ephemeral.stateResourcesLoaded = false

        local textBlocksToLoad = { "global", "satch", "shop" }

        for _, block in ipairs(textBlocksToLoad) do
            if (TextBlockIsLoaded(block) == 0) then
                TextBlockRequest(block)

                while (TextBlockIsLoaded(block) == 0) do
                    Citizen.Wait(5)
                end
            end
        end

        local textureDictsToLoad = { "satchel_textures", "inventory_items", "inventory_items_mp" }

        for _, txd in ipairs(textureDictsToLoad) do
            if (HasStreamedTextureDictLoaded(txd) == 0) then
                RequestStreamedTextureDict(txd)

                while (HasStreamedTextureDictLoaded(txd) == 0) do
                    Citizen.Wait(5)
                end
            end
        end

        Ephemeral.stateResourcesLoaded = true
    end)
end

function InitializePersistence()
    local datastore = DatabindingGetDataContainerFromPath("NativeSatchel")

    if (datastore == 0 or DatabindingIsEntryValid(datastore) ~= 1) then
        datastore = DatabindingAddDataContainerFromPath("", "NativeSatchel")

        -- For ints, the default will be 0, but we like explicit

        DatabindingAddDataInt(datastore, "CurrentCategoryIndex", 0)
        DatabindingAddDataInt(datastore, "CurrentCategoryCount", 0)
        DatabindingAddDataInt(datastore, "CurrentItemIndex", 0)
        DatabindingAddDataInt(datastore, "CurrentItemCount", 0)
        DatabindingAddDataInt(datastore, "CurrentListCount", 0)

        DatabindingAddDataInt(datastore, "RefMainData", 0)
        DatabindingAddDataInt(datastore, "RefCollectionData", 0)
        DatabindingAddDataInt(datastore, "RefSatchelLabel", 0)
        DatabindingAddDataInt(datastore, "RefSelectedData", 0)
        DatabindingAddDataInt(datastore, "RefSelectedEffectsData", 0)
        DatabindingAddDataInt(datastore, "RefCategoryItems", 0)
        DatabindingAddDataInt(datastore, "RefMenuItems", 0)
        DatabindingAddDataInt(datastore, "RefListItems", 0)
    end
end

function GetPersistedInt(key)
    if (Ephemeral.cachePersistence[key]) then
        local value = Ephemeral.cachePersistence[key]
        return tonumber(value) or 0
    end

    local datastore = DatabindingGetDataContainerFromPath("NativeSatchel")

    if (datastore == 0 or DatabindingIsEntryValid(datastore) ~= 1) then
        InitializePersistence()
    end

    local value = DatabindingReadDataIntFromParent(datastore, key)
    return tonumber(value) or 0
end

function SetPersistedInt(key, value)
    local datastore = DatabindingGetDataContainerFromPath("NativeSatchel")

    if (datastore == 0 or DatabindingIsEntryValid(datastore) ~= 1) then
        InitializePersistence()
    end

    DatabindingWriteDataIntFromParent(datastore, key, value)
    Ephemeral.cachePersistence[key] = value
end

function FindItemById(itemId)
    for i, item in ipairs(Config.inventory) do
        if item.id == itemId then
            return item, i
        end
    end

    return nil, nil
end

function RefreshItems()
    -- Clear the cache
    Ephemeral.cacheItems = {}

    -- Loop through the inventory and process each item
    for index, item in ipairs(Config.inventory) do
        local database = item.catalog and GetItemFromDatabase(item.catalog) or {}

        local cachedItem = {
            id = item.id,
            count = item.count or 1,
            maxCount = item.maxCount,
            catalog = item.catalog,
            enabled = item.enabled == nil or item.enabled == true,

            -- Fill from item first, then database, then defaults
            label = item.label or database.label or item.id,
            description = item.description or database.description or "",
            priceLabelHash = item.priceLabelHash or database.priceLabelHash or nil,
            priceValue = item.priceValue or database.priceValue or nil,
            txd = item.txd or database.txd or "inventory_items",
            texture = item.texture or database.texture or "_placeholder",
            effects = item.effects or database.effects or {},
            stars = item.stars or database.stars or 0,
            special = item.special or database.special or false,

            -- List-only flags
            equipped = item.equipped or database.equipped or false,

            -- Prompt flags (default to database values, then sensible defaults)
            droppable = item.droppable or database.droppable or false,
            discardable = item.discardable or database.discardable or false,
            breakable = item.breakable or database.breakable or false,
            cookable = item.cookable or database.cookable or false,
            usable = item.usable or database.usable or false,
            drinkable = item.drinkable or database.drinkable or false,
            edible = item.edible or database.edible or false,
            readable = item.readable or database.readable or false
        }

        -- Handle category assignment with auto-categorization check
        if item.category then
            cachedItem.category = item.category
        elseif Config.enableAutoCategorization and database.category then
            cachedItem.category = database.category
        end

        -- Handle folder assignment with auto-folder assignment check
        if item.folder then
            cachedItem.folder = item.folder
        elseif Config.enableAutoFolderAssignment and database.folder then
            cachedItem.folder = database.folder
        end

        -- Add the processed item to the cache
        table.insert(Ephemeral.cacheItems, cachedItem)
    end
end

function RefreshHashMaps()
    Config.mapCategories = {}
    Config.mapCategoriesJoaat = {}

    for index, item in ipairs(Config.categories) do
        Config.mapCategories[item.id] = index
        Config.mapCategoriesJoaat[joaat(item.id)] = index
    end

    Config.mapFolders = {}
    Config.mapFoldersJoaat = {}

    for index, item in ipairs(Config.folders) do
        Config.mapFolders[item.id] = index
        Config.mapFoldersJoaat[joaat(item.id)] = index
    end

    Config.mapItems = {}
    Config.mapItemsJoaat = {}

    for index, item in ipairs(Ephemeral.cacheItems) do
        Config.mapItems[item.id] = index
        Config.mapItemsJoaat[joaat(item.id)] = index
    end
end

function InitializeSatchelMainData()
    local datastore = DatabindingGetDataContainerFromPath("Satchel")

    if (datastore == 0 or DatabindingIsEntryValid(datastore) ~= 1) then
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

        if (Config.discardingLabelHash and Config.discardingLabelHash ~= "") then
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

    SetPersistedInt("RefMainData", datastore)
end

function InitializeSatchelSelectedData()
    local datastore = GetPersistedInt("RefSelectedData")

    if (datastore == 0 or DatabindingIsEntryValid(datastore) ~= 1) then
        local parent = GetPersistedInt("RefMainData")

        if (parent == 0 or DatabindingIsEntryValid(parent) ~= 1) then
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

    SetPersistedInt("RefSelectedData", datastore)
end

function InitializeSatchelSelectedEffects()
    local datastore = GetPersistedInt("RefSelectedEffectsData")

    if (datastore == 0 or DatabindingIsEntryValid(datastore) ~= 1) then
        local parent = GetPersistedInt("RefSelectedData")

        if (parent == 0 or DatabindingIsEntryValid(parent) ~= 1) then
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

    SetPersistedInt("RefSelectedEffectsData", datastore)
end

function InitializeSatchelCollectionData()
    local list = GetPersistedInt("RefCollectionData")

    if (list == 0 or DatabindingIsEntryValid(list) ~= 1) then
        local parent = GetPersistedInt("RefMainData")

        if (parent == 0 or DatabindingIsEntryValid(parent) ~= 1) then
            print("[NativeSatchel] InitializeSatchelCollectionData: Main data wasn't ready in time!")
            return
        end

        list = DatabindingAddUiItemList(parent, "Collections")

        -- Player collection datastore
        local datastore = DatabindingAddDataContainer(list, "player")

        -- Current collection label
        local refSatchelLabel = DatabindingAddDataHash(datastore, "label", joaat("IB_SELECT"))
        SetPersistedInt("RefSatchelLabel", refSatchelLabel)

        DatabindingInsertUiItemToListFromContextHashAlias(list, -1, -1287062382, datastore)
    end

    SetPersistedInt("RefCollectionData", list)
end

function UpdateSatchelLabel(labelHash)
    local refSatchelLabel = GetPersistedInt("RefSatchelLabel")

    if (refSatchelLabel == 0 or DatabindingIsEntryValid(refSatchelLabel) ~= 1) then
        print("[NativeSatchel] UpdateSatchelLabel: Satchel label wasn't ready in time!")
        return
    end

    DatabindingWriteDataHashString(refSatchelLabel, labelHash)
end

function InitializeSatchelCategories()
    local datastore = GetPersistedInt("RefCategoryItems")

    if (datastore == 0 or DatabindingIsEntryValid(datastore) ~= 1) then
        datastore = DatabindingGetDataContainerFromPath("satchel_category_items")
    end

    SetPersistedInt("RefCategoryItems", datastore)
end

function ReloadSatchelCategories()
    local datastore = GetPersistedInt("RefCategoryItems")
    local datastoreSelected = GetPersistedInt("RefSelectedData")

    if (datastore == 0 or DatabindingIsEntryValid(datastore) ~= 1) then
        print("[NativeSatchel] ReloadSatchelCategories: Category items wasn't ready in time!")
        return
    end

    if (datastoreSelected == 0 or DatabindingIsEntryValid(datastoreSelected) ~= 1) then
        print("[NativeSatchel] ReloadSatchelCategories: Selected data wasn't ready in time!")
        return
    end

    local categoryIndex = 0
    local currentIndex = GetPersistedInt("CurrentCategoryIndex")

    -- Clear existing cache
    Ephemeral.cacheCategoryItems = {}

    for _, category in ipairs(Config.categories) do
        local added = AddCategory(categoryIndex, category, currentIndex)

        if (added and added ~= 0) then
            table.insert(Ephemeral.cacheCategoryItems, added)
            categoryIndex = categoryIndex + 1
        end
    end

    SetPersistedInt("CurrentCategoryCount", categoryIndex)
    DatabindingSetTemplatedUiItemListSize(datastore, categoryIndex)

    DatabindingWriteDataIntFromParent(datastoreSelected, "CategoryIndex", currentIndex)
    DatabindingWriteDataIntFromParent(datastoreSelected, "DefaultCategoryIndex", currentIndex)
    DatabindingWriteDataIntFromParent(datastoreSelected, "CategoryCount", categoryIndex)
end

function UpdateSatchelCurrentCategory()
    local datastoreSelected = GetPersistedInt("RefSelectedData")

    if (datastoreSelected == 0 or DatabindingIsEntryValid(datastoreSelected) ~= 1) then
        print("[NativeSatchel] UpdateSatchelCurrentCategory: Selected data wasn't ready in time!")
        return
    end

    local currentIndex = GetPersistedInt("CurrentCategoryIndex")
    DatabindingWriteDataIntFromParent(datastoreSelected, "DefaultCategoryIndex", currentIndex)

    for index, datastoreCategory in ipairs(Ephemeral.cacheCategoryItems) do
        if ((index - 1) == currentIndex) then
            DatabindingWriteDataBoolFromParent(datastoreCategory, "CurrentCategory", true)
        else
            DatabindingWriteDataBoolFromParent(datastoreCategory, "CurrentCategory", false)
        end
    end
end

function InitializeSatchelMenuItems()
    local datastore = GetPersistedInt("RefMenuItems")

    if (datastore == 0 or DatabindingIsEntryValid(datastore) ~= 1) then
        datastore = DatabindingGetDataContainerFromPath("satchel_menu_items")
    end

    SetPersistedInt("RefMenuItems", datastore)
end

function ClearSatchelMenuItems()
    local datastore = GetPersistedInt("RefMenuItems")

    if (datastore == 0 or DatabindingIsEntryValid(datastore) ~= 1) then
        print("[NativeSatchel] ClearSatchelMenuItems: Menu items wasn't ready in time!")
        return
    end

    Ephemeral.cacheMenuItems = {}
    SetPersistedInt("CurrentItemCount", 0)
    DatabindingSetTemplatedUiItemListSize(datastore, 0)
end

function NavigateSatchelMenuItems()
    ClearSatchelSelectedData()

    if (GetPersistedInt("CurrentItemCount") > 0) then
        ClearSatchelMenuItems()
    end

    if (GetPersistedInt("CurrentListCount") > 0) then
        ClearSatchelListItems()
    end

    local datastore = GetPersistedInt("RefMenuItems")
    local datastoreSelected = GetPersistedInt("RefSelectedData")

    if (datastore == 0 or DatabindingIsEntryValid(datastore) ~= 1) then
        print("[NativeSatchel] NavigateSatchelMenuItems: Menu items wasn't ready in time!")
        return
    end

    if (datastoreSelected == 0 or DatabindingIsEntryValid(datastoreSelected) ~= 1) then
        print("[NativeSatchel] NavigateSatchelMenuItems: Selected data wasn't ready in time!")
        return
    end

    local currentCategoryIndex = DatabindingReadDataIntFromParent(datastoreSelected, "CategoryIndex")
    SetPersistedInt("CurrentCategoryIndex", currentCategoryIndex)

    UpdateSatchelCurrentCategory()

    -- Since the game is zero-based but LUA 1-based, increment
    -- Use modulo to wrap around when exceeding available categories
    local categoryKey = (currentCategoryIndex % #Config.categories) + 1
    local category = Config.categories[categoryKey]

    if (not category) then
        print("[NativeSatchel] NavigateSatchelMenuItems: Could not identify category at key " .. categoryKey)
        return
    end

    if (not category.titleHash or GetStringFromHashKey(category.titleHash) == "") then
        print("[NativeSatchel] NavigateSatchelMenuItems: Category " .. category.id .. " has an invalid title hash: " .. category.titleHash)
        category.titleHash = 0x69752E0D -- "Empty"
    end

    DatabindingWriteDataHashStringFromParent(datastoreSelected, "Category", category.titleHash)

    local filteredIndex = 0
    local menuEntries = {}
    local processedFolders = {}
    local recentItemCount = 0

    -- Clear existing cache
    Ephemeral.cacheMenuItems = {}

    -- Properly filter items based on category and folder logic
    for _, item in ipairs(Ephemeral.cacheItems) do
        if (category.recent and Config.maxRecentItems > 0 and recentItemCount >= Config.maxRecentItems) then
            -- Skip this item as we've reached the recent items limit
        elseif (not category.recent and item.folder) then
            -- Process folder items (skip folders entirely for recent category)
            if (not processedFolders[item.folder]) then
                local folderIndex = Config.mapFolders[item.folder]
                local folder = Config.folders[folderIndex]

                if (folder and folder.category == category.id) then
                    -- Count items in this folder for the current category
                    local folderItemCount = 0

                    for _, checkItem in ipairs(Ephemeral.cacheItems) do
                        if (checkItem.folder == item.folder) then
                            folderItemCount = folderItemCount + 1
                        end
                    end

                    -- Check if folder has enough items to warrant showing as folder
                    if (folderItemCount >= Config.minItemsForFolder) then
                        table.insert(menuEntries, { type = "folder", data = folder })
                        processedFolders[item.folder] = { individual = false, count = folderItemCount, processed = 0 }
                    else
                        -- Mark folder as individual processing with count
                        processedFolders[item.folder] = { individual = true, count = folderItemCount, processed = 0 }
                    end
                end
            end

            -- If folder is set for individual processing, add this item
            if (processedFolders[item.folder] and processedFolders[item.folder].individual) then
                if (item.category == category.id) then
                    table.insert(menuEntries, { type = "item", data = item })
                end
            end
        elseif (category.recent or item.category == category.id) then
            -- Add regular items to menu entries (including items from folders in recent category)
            table.insert(menuEntries, { type = "item", data = item })
            if (category.recent) then
                recentItemCount = recentItemCount + 1
            end
        end
    end

    -- Process all menu entries sequentially
    for _, entry in ipairs(menuEntries) do
        local added = nil

        if (entry.type == "item") then
            added = AddMenuItem(filteredIndex, entry.data)
        elseif (entry.type == "folder") then
            added = AddMenuFolder(filteredIndex, entry.data)
        end

        if (added and added ~= 0) then
            table.insert(Ephemeral.cacheMenuItems, added)
            filteredIndex = filteredIndex + 1
        end
    end

    SetPersistedInt("CurrentItemCount", filteredIndex)
    DatabindingSetTemplatedUiItemListSize(datastore, filteredIndex)

    UpdateSatchelIndexDescription()

    if (filteredIndex < 1) then
        EmptyCategorySatchelSelectedData(category)
    end

    TriggerEvent(Config.eventHandlerKey .. ":category_changed", category.id)
end

function RefreshSatchelAfterChange()
    RefreshItems()
    RefreshHashMaps()

    if IsUiappActiveByHash(uiAppChannel) then
        NavigateSatchelMenuItems()
    end
end

function UpdateSatchelPrompts(config)
    local datastoreMain = GetPersistedInt("RefMainData")

    if (datastoreMain == 0 or DatabindingIsEntryValid(datastoreMain) ~= 1) then
        print("[NativeSatchel] UpdateSatchelPrompts: Main data wasn't ready in time!")
        return
    end

    -- Regular use prompt
    -- Note: For UI events to work, both this AND the hold labels must be set
    local selectLabel, selectEnabled, selectVisible = nil, nil, nil

    if (config.folder) then
        selectLabel = joaat("SATCHEL_PROMPT_USE")
        selectEnabled = Config.allowOpeningFolders or false
        selectVisible = Config.allowOpeningFolders or false
    elseif (config.drinkable) then
        selectLabel = joaat("SATCHEL_PROMPT_DRINK")
        selectEnabled = Config.allowDrinking or false
        selectVisible = Config.allowDrinking or false
    elseif (config.edible) then
        selectLabel = joaat("SATCHEL_PROMPT_EAT")
        selectEnabled = Config.allowEating or false
        selectVisible = Config.allowEating or false
    elseif (config.readable) then
        selectLabel = joaat("READ")
        selectEnabled = Config.allowReading or false
        selectVisible = Config.allowReading or false
    elseif (config.usable) then
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

    if (config.breakable) then
        holdSelectLabel = joaat("SATCHEL_PROMPT_BREAKDOWN")
        holdSelectEnabled = Config.allowBreakdown or false
        holdSelectVisible = Config.allowBreakdown or false
    elseif (config.cookable) then
        holdSelectLabel = joaat("SATCHEL_PROMPT_COOK")
        holdSelectEnabled = Config.allowCooking or false
        holdSelectVisible = Config.allowCooking or false
    else
        holdSelectLabel = joaat("SATCHEL_PROMPT_BREAKDOWN")
        holdSelectEnabled = false
        holdSelectVisible = false
    end

    -- The UI cannot show both prompts at once
    if (selectEnabled and holdSelectEnabled) then
        holdSelectEnabled = false
        holdSelectVisible = false
    end

    -- Drop prompt
    local dropVisible = false

    if (config.droppable) then
        dropVisible = Config.allowDropping or false
    end

    -- Discard prompt
    local discardVisible = false

    if (config.discardable) then
        discardVisible = Config.allowDiscarding or false
    end

    -- Regular use prompt
    DatabindingWriteDataHashStringFromParent(datastoreMain, "PromptSelectLabel", selectLabel)
    DatabindingWriteDataBoolFromParent(datastoreMain, "PromptSelectEnabled", selectEnabled)
    DatabindingWriteDataBoolFromParent(datastoreMain, "PromptSelectVisible", selectVisible)

    -- Hold use prompt
    DatabindingWriteDataHashStringFromParent(datastoreMain, "PromptHoldSelectLabel", holdSelectLabel)
    DatabindingWriteDataBoolFromParent(datastoreMain, "PromptHoldSelectEnabled", holdSelectEnabled)
    DatabindingWriteDataBoolFromParent(datastoreMain, "PromptHoldSelectVisible", holdSelectVisible)

    -- Discard prompt
    DatabindingWriteDataBoolFromParent(datastoreMain, "PromptDropVisibile", dropVisible)

    -- Discard all prompt
    DatabindingWriteDataStringFromParent(datastoreMain, "PromptDiscardAllLabel", Config.discardingLabel)
    DatabindingWriteDataBoolFromParent(datastoreMain, "PromptDiscardAllEnabled", discardVisible)
    DatabindingWriteDataBoolFromParent(datastoreMain, "PromptDiscardAllVisible", discardVisible)

    -- Send all prompt
    DatabindingWriteDataHashStringFromParent(datastoreMain, "PromptSendLabel", joaat("SATCHEL_PROMPT_USE"))
    DatabindingWriteDataBoolFromParent(datastoreMain, "PromptSendAllVisible", false)
end

function UpdateSatchelIndexDescription(type)
    local datastoreSelected = GetPersistedInt("RefSelectedData")

    if (datastoreSelected == 0 or DatabindingIsEntryValid(datastoreSelected) ~= 1) then
        print("[NativeSatchel] UpdateSatchelIndexDescription: Selected data wasn't ready in time!")
        return
    end

    local total = 0

    if (type == "item") then
        total = GetPersistedInt("CurrentItemCount")
    else
        total = GetPersistedInt("CurrentListCount")
    end

    local indexDescription = ""

    -- If there are more than 16 items (scrolling), add a "X of Y" counter
    if (total > 16) then
        indexDescription = GetStringFromHashKey("ENTRY_COUNTER")
        indexDescription = indexDescription:gsub("~1~", GetPersistedInt("CurrentItemIndex") + 1)
        indexDescription = indexDescription:gsub("~2~", total)
    end

    DatabindingWriteStringFromParent(datastoreSelected, "IndexDescription", indexDescription)
end

function UpdateSatchelSelectedData(itemId, folderId)
    if (not itemId and not folderId) then
        print("[NativeSatchel] UpdateSatchelSelectedData: Could not determine item to update")
        return
    end

    local datastoreSelected = GetPersistedInt("RefSelectedData")

    if (datastoreSelected == 0 or DatabindingIsEntryValid(datastoreSelected) ~= 1) then
        print("[NativeSatchel] UpdateSatchelSelectedData: Selected data wasn't ready in time!")
        return
    end

    StopItemPreview()

    local id = nil
    local count = nil
    local maxCount = nil
    local label = nil
    local description = nil
    local priceLabelHash = nil
    local priceValue = nil
    local effects = {}
    local droppable = nil
    local discardable = nil
    local breakable = nil
    local cookable = nil
    local usable = nil
    local drinkable = nil
    local edible = nil
    local readable = nil

    if (itemId) then
        local item = Ephemeral.cacheItems[itemId]

        if (not item) then
            print("[NativeSatchel] UpdateSatchelSelectedData: Could not determine item for ID " .. itemId)
            return
        end

        id = item.id
        count = item.count
        maxCount = item.maxCount
        discardable = item.discardable or false

        label = item.label or id
        description = item.description or ""
        priceLabelHash = item.priceLabelHash or nil
        priceValue = item.priceValue or nil
        effects = item.effects or {}
        droppable = item.droppable or false
        breakable = item.breakable or false
        cookable = item.cookable or false
        usable = item.usable or false
        drinkable = item.drinkable or false
        edible = item.edible or false
        readable = item.readable or false

        UpdateSatchelPrompts({
            count = count,
            droppable = droppable,
            discardable = discardable,
            breakable = breakable,
            cookable = cookable,
            usable = usable,
            drinkable = drinkable,
            edible = edible,
            readable = readable,
        })

        if (Config.enableItemPreview and item.catalog) then
            local hash = joaat(item.catalog)
            if (ItemdatabaseIsKeyValid(hash) ~= 0) then
                -- 1 for player, 2 for horse
                StartItemPreview(hash, 1)
            end
        end
    else
        local folder = Config.folders[folderId]

        if (not folder) then
            print("[NativeSatchel] UpdateSatchelSelectedData: Could not determine folder for ID " .. folderId)
            return
        end

        id = folder.id
        label = (folder.labelHash and GetStringFromHashKey(folder.labelHash)) or folder.label or ""
        description = (folder.descriptionHash and GetStringFromHashKey(folder.descriptionHash)) or folder.description or ""

        UpdateSatchelPrompts({ folder = true })
    end

    DatabindingWriteDataHashStringFromParent(datastoreSelected, "Name", 0)
    DatabindingWriteStringFromParent(datastoreSelected, "NameAsString", label or "")

    DatabindingWriteDataHashStringFromParent(datastoreSelected, "Description", 0)
    DatabindingWriteStringFromParent(datastoreSelected, "DescriptionAsString", description or "")

    if (Ephemeral.stateIsShopMode or Config.enableItemValueInRegularSatchel) then
        DatabindingWriteStringFromParent(datastoreSelected, "PriceLabel", priceLabelHash or "")
        DatabindingWriteStringFromParent(datastoreSelected, "Price", priceValue or "")
    end

    local tipDescription = ""

    if (count and count > 0) then
        if (maxCount) then
            if (maxCount == 1) then
                tipDescription = GetStringFromHashKey("SATCHEL_TIP_UNIQUE")
            elseif (count < maxCount) then
                tipDescription = GetStringFromHashKey("SATCHEL_TIP_CAPACITY")
                tipDescription = tipDescription:gsub("~1~", count)
                tipDescription = tipDescription:gsub("~2~", maxCount)
            else
                tipDescription = GetStringFromHashKey("SATCHEL_TIP_CAPACITY_FULL")
                tipDescription = tipDescription:gsub("~1~", count)
                tipDescription = tipDescription:gsub("~2~", maxCount)
            end
        else
            tipDescription = GetStringFromHashKey("SATCHEL_TIP_INFINITE")
            tipDescription = tipDescription:gsub("~1~", count)
        end
    end

    DatabindingWriteStringFromParent(datastoreSelected, "Tip", tipDescription)

    UpdateSatchelSelectedEffects(effects)
end

function EmptyCategorySatchelSelectedData(category)
    local datastoreSelected = GetPersistedInt("RefSelectedData")

    if (datastoreSelected == 0 or DatabindingIsEntryValid(datastoreSelected) ~= 1) then
        print("[NativeSatchel] EmptyCategorySatchelSelectedData: Selected data wasn't ready in time!")
        return
    end

    ClearSatchelSelectedData()

    local label = (category.emptyLabelHash and GetStringFromHashKey(category.emptyLabelHash)) or category.emptyLabel or ""
    local description = (category.emptyDescriptionHash and GetStringFromHashKey(category.emptyDescriptionHash)) or category.emptyDescription or ""

    DatabindingWriteDataHashStringFromParent(datastoreSelected, "Name", 0)
    DatabindingWriteStringFromParent(datastoreSelected, "NameAsString", label)
    DatabindingWriteDataHashStringFromParent(datastoreSelected, "Description", 0)
    DatabindingWriteStringFromParent(datastoreSelected, "DescriptionAsString", description)
end

function ClearSatchelSelectedData()
    local datastoreSelected = GetPersistedInt("RefSelectedData")

    if (datastoreSelected == 0 or DatabindingIsEntryValid(datastoreSelected) ~= 1) then
        print("[NativeSatchel] ClearSatchelSelectedData: Selected data wasn't ready in time!")
        return
    end

    DatabindingWriteDataHashStringFromParent(datastoreSelected, "Name", 0)
    DatabindingWriteStringFromParent(datastoreSelected, "NameAsString", "")
    DatabindingWriteDataHashStringFromParent(datastoreSelected, "Description", 0)
    DatabindingWriteStringFromParent(datastoreSelected, "DescriptionAsString", "")
    DatabindingWriteStringFromParent(datastoreSelected, "PriceLabel", "")
    DatabindingWriteStringFromParent(datastoreSelected, "Price", "")
    DatabindingWriteStringFromParent(datastoreSelected, "Tip", "")

    ClearSatchelSelectedEffects()
end

function UpdateSatchelSelectedEffects(effects)
    local datastoreEffects = GetPersistedInt("RefSelectedEffectsData")

    if (datastoreEffects == 0 or DatabindingIsEntryValid(datastoreEffects) ~= 1) then
        print("[NativeSatchel] UpdateSatchelSelectedEffects: Selected data wasn't ready in time!")
        return
    end

    ClearSatchelSelectedEffects()

    local durationHashes = {
        [0] = 0,
        [1] = 0xB65F115D,
        [2] = 0xEC9E7DDB,
        [3] = 0x22E96A70,
        [4] = 0xC912B6C4,
    }

    for key, effect in pairs(effects) do
        local value = effect.value or 0
        local duration = effect.duration or 0

        if (key == "health" or key == "stamina" or key == "deadeye" or key == "horseHealth" or key == "horseStamina") then
            -- Tanks: -10 to -1 | 1 to 10   | 11 for overpowered
            if (value ~= 11 and (value < -10 or value > 10)) then
                print("[NativeSatchel] UpdateSatchelSelectedEffects: Invalid effect value for " .. key .. ": " .. value)
                value = 0
            end
        elseif (key == "healthCore" or key == "staminaCore" or key == "deadeyeCore" or key == "horseHealthCore" or key == "horseStaminaCore") then
            -- Cores: -8 to -1  | 1 to 8    | 12 for overpowered
            if (value ~= 12 and (value < -8 or value > 8)) then
                print("[NativeSatchel] UpdateSatchelSelectedEffects: Invalid effect value for " .. key .. ": " .. value)
                value = 0
            end
        else
            print("[NativeSatchel] UpdateSatchelSelectedEffects: Unknown effect key " .. key)
            value = 0
        end

        -- Duration: 0 to 4
        if (duration < 0 or duration > 4) then
            print("[NativeSatchel] UpdateSatchelSelectedEffects: Invalid effect duration for " .. key .. ": " .. duration)
            duration = 0
        end

        local durationHash = durationHashes[duration] or 0

        if (key == "health") then
            DatabindingWriteDataIntFromParent(datastoreEffects, "health", value)
            DatabindingWriteDataHashStringFromParent(datastoreEffects, "healthDurationCategory", durationHash)
        elseif (key == "stamina") then
            DatabindingWriteDataIntFromParent(datastoreEffects, "stamina", value)
            DatabindingWriteDataHashStringFromParent(datastoreEffects, "staminaDurationCategory", durationHash)
        elseif (key == "deadeye") then
            DatabindingWriteDataIntFromParent(datastoreEffects, "deadeye", value)
            DatabindingWriteDataHashStringFromParent(datastoreEffects, "deadeyeDurationCategory", durationHash)
        elseif (key == "healthCore") then
            DatabindingWriteDataIntFromParent(datastoreEffects, "healthCore", value)
            DatabindingWriteDataHashStringFromParent(datastoreEffects, "healthCoreDurationCategory", durationHash)
        elseif (key == "staminaCore") then
            DatabindingWriteDataIntFromParent(datastoreEffects, "staminaCore", value)
            DatabindingWriteDataHashStringFromParent(datastoreEffects, "staminaCoreDurationCategory", durationHash)
        elseif (key == "deadeyeCore") then
            DatabindingWriteDataIntFromParent(datastoreEffects, "deadeyeCore", value)
            DatabindingWriteDataHashStringFromParent(datastoreEffects, "deadeyeCoreDurationCategory", durationHash)
        elseif (key == "horseHealth") then
            DatabindingWriteDataIntFromParent(datastoreEffects, "healthHorse", value)
            DatabindingWriteDataHashStringFromParent(datastoreEffects, "healthHorseDurationCategory", durationHash)
        elseif (key == "horseStamina") then
            DatabindingWriteDataIntFromParent(datastoreEffects, "staminaHorse", value)
            DatabindingWriteDataHashStringFromParent(datastoreEffects, "staminaHorseDurationCategory", durationHash)
        elseif (key == "horseHealthCore") then
            DatabindingWriteDataIntFromParent(datastoreEffects, "healthCoreHorse", value)
            DatabindingWriteDataHashStringFromParent(datastoreEffects, "healthCoreHorseDurationCategory", durationHash)
        elseif (key == "horseStaminaCore") then
            DatabindingWriteDataIntFromParent(datastoreEffects, "staminaCoreHorse", value)
            DatabindingWriteDataHashStringFromParent(datastoreEffects, "staminaCoreHorseDurationCategory", durationHash)
        end
    end
end

function ClearSatchelSelectedEffects()
    local datastoreSelected = GetPersistedInt("RefSelectedEffectsData")

    if (datastoreSelected == 0 or DatabindingIsEntryValid(datastoreSelected) ~= 1) then
        print("[NativeSatchel] ClearSatchelSelectedEffects: Selected effects data wasn't ready in time!")
        return
    end

    DatabindingWriteDataIntFromParent(datastoreSelected, "health", 0)
    DatabindingWriteDataHashStringFromParent(datastoreSelected, "healthDurationCategory", 0)

    DatabindingWriteDataIntFromParent(datastoreSelected, "stamina", 0)
    DatabindingWriteDataHashStringFromParent(datastoreSelected, "staminaDurationCategory", 0)

    DatabindingWriteDataIntFromParent(datastoreSelected, "deadeye", 0)
    DatabindingWriteDataHashStringFromParent(datastoreSelected, "deadeyeDurationCategory", 0)

    DatabindingWriteDataIntFromParent(datastoreSelected, "healthCore", 0)
    DatabindingWriteDataHashStringFromParent(datastoreSelected, "healthCoreDurationCategory", 0)

    DatabindingWriteDataIntFromParent(datastoreSelected, "staminaCore", 0)
    DatabindingWriteDataHashStringFromParent(datastoreSelected, "staminaCoreDurationCategory", 0)

    DatabindingWriteDataIntFromParent(datastoreSelected, "deadeyeCore", 0)
    DatabindingWriteDataHashStringFromParent(datastoreSelected, "deadeyeCoreDurationCategory", 0)

    DatabindingWriteDataIntFromParent(datastoreSelected, "healthHorse", 0)
    DatabindingWriteDataHashStringFromParent(datastoreSelected, "healthHorseDurationCategory", 0)

    DatabindingWriteDataIntFromParent(datastoreSelected, "staminaHorse", 0)
    DatabindingWriteDataHashStringFromParent(datastoreSelected, "staminaHorseDurationCategory", 0)

    DatabindingWriteDataIntFromParent(datastoreSelected, "healthCoreHorse", 0)
    DatabindingWriteDataHashStringFromParent(datastoreSelected, "healthCoreHorseDurationCategory", 0)

    DatabindingWriteDataIntFromParent(datastoreSelected, "staminaCoreHorse", 0)
    DatabindingWriteDataHashStringFromParent(datastoreSelected, "staminaCoreHorseDurationCategory", 0)
end

function InitializeSatchelListItems()
    local datastore = GetPersistedInt("RefListItems")

    if (datastore == 0 or DatabindingIsEntryValid(datastore) ~= 1) then
        datastore = DatabindingGetDataContainerFromPath("satchel_list_items")
    end

    SetPersistedInt("RefListItems", datastore)
end

function ClearSatchelListItems()
    local datastore = GetPersistedInt("RefListItems")

    if (datastore == 0 or DatabindingIsEntryValid(datastore) ~= 1) then
        print("[NativeSatchel] ClearSatchelListItems: List items wasn't ready in time!")
        return
    end

    SetPersistedInt("CurrentListCount", 0)
    DatabindingSetTemplatedUiItemListSize(datastore, 0)
end

function PreloadSatchelListItems(folderId)
    if (GetPersistedInt("CurrentListCount") > 0) then
        ClearSatchelListItems()
    end

    local datastore = GetPersistedInt("RefListItems")
    local datastoreSelected = GetPersistedInt("RefSelectedData")

    if (datastore == 0 or DatabindingIsEntryValid(datastore) ~= 1) then
        print("[NativeSatchel] PreloadSatchelListItems: List items wasn't ready in time!")
        return
    end

    if (datastoreSelected == 0 or DatabindingIsEntryValid(datastoreSelected) ~= 1) then
        print("[NativeSatchel] PreloadSatchelListItems: Selected data wasn't ready in time!")
        return
    end

    if (not folderId) then
        print("[NativeSatchel] PreloadSatchelListItems: No folder ID provided!")
        return
    end

    local folder = Config.folders[folderId]

    if (not folder.titleHash or GetStringFromHashKey(folder.titleHash) == "") then
        print("[NativeSatchel] PreloadSatchelListItems: Folder " .. folder.id .. " has an invalid title hash: " .. folder.titleHash)
        folder.titleHash = 0x69752E0D -- "Empty"
    end

    DatabindingWriteDataHashStringFromParent(datastoreSelected, "Folder", folder.titleHash)

    local listIndex = 0

    -- Clear existing cache
    Ephemeral.cacheMenuItems = {}

    for _, item in ipairs(Ephemeral.cacheItems) do
        if (item.folder and item.folder == folder.id) then
            local added = AddListItem(listIndex, item)

            if (added and added ~= 0) then
                table.insert(Ephemeral.cacheMenuItems, added)
                listIndex = listIndex + 1
            end
        end
    end

    SetPersistedInt("CurrentListCount", listIndex)
    DatabindingSetTemplatedUiItemListSize(datastore, listIndex)
end

function NavigateSatchelListItems(folderId)
    ClearSatchelSelectedData()
    UpdateSatchelIndexDescription("folder")
end

function EventItemFocused(index, parameter, datastore)
    local selectedKey = DatabindingReadDataHashStringFromParent(datastore, "item")

    -- Sometimes the UI doesn't properly focus on an item, this is a game bug
    -- You can also see this happening by switching from first to last rapidly
    if (not selectedKey or selectedKey == 0) then
        return
    end

    local itemIndex = Config.mapItemsJoaat[selectedKey]
    local item = nil
    local itemId = nil
    if (itemIndex) then item = Ephemeral.cacheItems[itemIndex] end
    if (item) then itemId = item.id end

    local folderIndex = Config.mapFoldersJoaat[selectedKey]
    local folder = nil
    local folderId = nil
    if (folderIndex) then folder = Config.folders[folderIndex] end
    if (folder) then folderId = folder.id end

    SetPersistedInt("CurrentItemIndex", index)
    UpdateSatchelIndexDescription("item")

    if (parameter == joaat("FOLDER_ITEM") or parameter == joaat("USABLE_ITEM")) then
        UpdateSatchelSelectedData(itemIndex, folderIndex)
    end

    if (parameter == joaat("FOLDER_ITEM")) then
        PreloadSatchelListItems(folderIndex)

        if (folderId) then
            TriggerEvent(Config.eventHandlerKey .. ":folder_focused", folderId)
        end
    elseif (parameter == joaat("USABLE_ITEM")) then
        if (itemId) then
            TriggerEvent(Config.eventHandlerKey .. ":item_focused", itemId)
        end
    else
        print("[NativeSatchel] EventItemFocused: Unknown focus parameter: " .. parameter)
    end
end

function EventItemSelected(index, parameter, datastore)
    local selectedKey = DatabindingReadDataHashStringFromParent(datastore, "item")

    -- Sometimes the UI doesn't properly focus on an item, this is a game bug
    -- You can also see this happening by switching from first to last rapidly
    if (not selectedKey or selectedKey == 0) then
        return
    end

    local itemIndex = Config.mapItemsJoaat[selectedKey]
    local item = nil
    local itemId = nil
    if (itemIndex) then item = Ephemeral.cacheItems[itemIndex] end
    if (item) then itemId = item.id end

    local folderIndex = Config.mapFoldersJoaat[selectedKey]
    local folder = nil
    local folderId = nil
    if (folderIndex) then folder = Config.folders[folderIndex] end
    if (folder) then folderId = folder.id end

    if (parameter == joaat("FOLDER_ITEM")) then
        NavigateSatchelListItems()

        if (folderId) then
            TriggerEvent(Config.eventHandlerKey .. ":folder_opened", folderId)
        end
    elseif (parameter == joaat("USABLE_ITEM")) then
        if (itemId) then
            TriggerEvent(Config.eventHandlerKey .. ":item_used", itemId)
        end
    elseif (parameter == joaat("BREAKABLE_ITEM")) then
        if (itemId) then
            TriggerEvent(Config.eventHandlerKey .. ":item_crafted", itemId)
        end
    elseif (parameter == joaat("DROP_ITEM")) then
        if (itemId) then
            TriggerEvent(Config.eventHandlerKey .. ":item_dropped", itemId)
        end
    elseif (parameter == joaat("DISCARD_ALL")) then
        if (itemId) then
            TriggerEvent(Config.eventHandlerKey .. ":item_discarded", itemId)
        end
    elseif (parameter == joaat("SEND_ALL")) then
        if (itemId) then
            TriggerEvent(Config.eventHandlerKey .. ":item_sent", itemId)
        end
    else
        print("[NativeSatchel] EventItemSelected: Unknown select parameter: " .. parameter)
    end
end

function GetItemFromDatabase(item)
    local hash = joaat(item)

    if (Ephemeral.cacheItemDatabase[hash]) then
        return Ephemeral.cacheItemDatabase[hash]
    end

    local result = {
        label = "",
        labelHash = 0,
        description = "",
        descriptionHash = 0,
        txd = "",
        texture = "",
        category = nil,
        folder = nil,
        effects = {},
        effectIds = {},
        stars = 0,
        special = false,
        droppable = true,
        breakable = false,
        cookable = false,
        usable = false,
        drinkable = false,
        edible = false,
        readable = false,
    }

    if (ItemdatabaseIsKeyValid(hash, 0) == 0) then
        return result
    end

    local uiData = GetItemUiData(hash)
    if (uiData) then
        result.label = GetStringFromHashKey(uiData.label)
        result.labelHash = uiData.label
        result.description = GetStringFromHashKey(uiData.description)
        result.descriptionHash = uiData.description
        result.txd = uiData.textureDict
        result.texture = uiData.textureId
    end

    local effectIds = GetItemEffectIds(hash)
    if (effectIds) then
        result.effectIds = effectIds

        local durations =
        {
            [joaat("EFFECT_DURATION_CATEGORY_NONE")] = 0,
            [joaat("EFFECT_DURATION_CATEGORY_1")]    = 1,
            [joaat("EFFECT_DURATION_CATEGORY_2")]    = 2,
            [joaat("EFFECT_DURATION_CATEGORY_3")]    = 3,
            [joaat("EFFECT_DURATION_CATEGORY_4")]    = 4,
        }

        for _, effectId in pairs(effectIds) do
            local effect = GetItemEffectData(effectId)
            if (effect) then
                local value = tonumber(effect.value or 0)
                local duration = durations[effect.durationcategory] or 0

                if (effect.type == joaat("EFFECT_HEALTH")) then
                    result.effects["health"] = { value = value, duration = duration }
                elseif (effect.type == joaat("EFFECT_HEALTH_OVERPOWERED")) then
                    result.effects["health"] = { value = 11, duration = duration }
                elseif (effect.type == joaat("EFFECT_STAMINA")) then
                    result.effects["stamina"] = { value = value, duration = duration }
                elseif (effect.type == joaat("EFFECT_STAMINA_OVERPOWERED")) then
                    result.effects["stamina"] = { value = 11, duration = duration }
                elseif (effect.type == joaat("EFFECT_DEADEYE")) then
                    result.effects["deadeye"] = { value = value, duration = duration }
                elseif (effect.type == joaat("EFFECT_DEADEYE_OVERPOWERED")) then
                    result.effects["deadeye"] = { value = 11, duration = duration }
                elseif (effect.type == joaat("EFFECT_HEALTH_CORE")) then
                    result.effects["healthCore"] = { value = value, duration = duration }
                elseif (effect.type == joaat("EFFECT_HEALTH_CORE_GOLD")) then
                    result.effects["healthCore"] = { value = 12, duration = duration }
                elseif (effect.type == joaat("EFFECT_STAMINA_CORE")) then
                    result.effects["staminaCore"] = { value = value, duration = duration }
                elseif (effect.type == joaat("EFFECT_STAMINA_CORE_GOLD")) then
                    result.effects["staminaCore"] = { value = 12, duration = duration }
                elseif (effect.type == joaat("EFFECT_DEADEYE_CORE")) then
                    result.effects["deadeyeCore"] = { value = value, duration = duration }
                elseif (effect.type == joaat("EFFECT_DEADEYE_CORE_GOLD")) then
                    result.effects["deadeyeCore"] = { value = 12, duration = duration }
                elseif (effect.type == joaat("EFFECT_HORSE_HEALTH")) then
                    result.effects["horseHealth"] = { value = value, duration = duration }
                elseif (effect.type == joaat("EFFECT_HORSE_HEALTH_OVERPOWERED")) then
                    result.effects["horseHealth"] = { value = 11, duration = duration }
                elseif (effect.type == joaat("EFFECT_HORSE_STAMINA")) then
                    result.effects["horseStamina"] = { value = value, duration = duration }
                elseif (effect.type == joaat("EFFECT_HORSE_STAMINA_OVERPOWERED")) then
                    result.effects["horseStamina"] = { value = 11, duration = duration }
                elseif (effect.type == joaat("EFFECT_HORSE_HEALTH_CORE")) then
                    result.effects["horseHealthCore"] = { value = value, duration = duration }
                elseif (effect.type == joaat("EFFECT_HORSE_HEALTH_CORE_GOLD")) then
                    result.effects["horseHealthCore"] = { value = 12, duration = duration }
                elseif (effect.type == joaat("EFFECT_HORSE_STAMINA_CORE")) then
                    result.effects["horseStaminaCore"] = { value = value, duration = duration }
                elseif (effect.type == joaat("EFFECT_HORSE_STAMINA_CORE_GOLD")) then
                    result.effects["horseStaminaCore"] = { value = 12, duration = duration }
                end
            end
        end
    end

    local tagIds = GetItemTagIds(hash)
    for _, value in pairs(tagIds) do
        if (value == joaat("CI_TAG_ITEM_OVERPOWERED") or value == joaat("CI_TAG_ITEM_QUALITY_LEGENDARY")) then
            result.special = true
        end

        if (not Config.ignoreCannotDiscardTag and value == joaat("CI_TAG_ITEM_CANNOT_DISCARD")) then
            result.droppable = false
        end

        if (value == joaat("CI_TAG_ITEM_CAN_BREAKDOWN")) then
            result.breakable = true
        end

        if (hash ~= joaat("PROVISION_ROTTEN_MEAT") and hash ~= joaat("CONSUMABLE_CORNEDBEEF_CAN")) then
            if (value == joaat("CI_TAG_ITEM_MEAT_ANIMAL") or value == joaat("CI_TAG_ITEM_MEAT_FISH")) then
                result.cookable = true
            end
        end

        if (value == joaat("CI_TAG_ITEM_CONSUMABLE")) then
            result.usable = true
        end

        if (value == -273840653 or value == 238865292 or value == 999632878 or value == 1130235258 or value == 1177617310) then
            result.drinkable = true
        end

        if (value == -1915958659 or value == -809056541 or value == 89124942 or value == 1451036371 or value == 1859991422 or value == 1891031775) then
            result.edible = true
        end

        if (value == joaat("CI_TAG_ITEM_DOCUMENT")) then
            result.readable = true
        end

        if (Config.enableAutoCategorization) then
            for _, category in pairs(Config.categories) do
                for _, tag in pairs(category.tags) do
                    if (value == joaat(tag)) then
                        result.category = category.id
                    end
                end
            end

            if (Config.enableAutoFolderAssignment) then
                for _, folder in pairs(Config.folders) do
                    for _, tag in pairs(folder.tags) do
                        if (value == joaat(tag)) then
                            result.folder = folder.id
                        end
                    end
                end
            end
        end
    end

    if (not result.category and Config.enableAutoCategorization) then
        print("[NativeSatchel] GetItemFromDatabase: Could not auto-assign category for item " .. item)
    end

    local isQualityLegendary = InventoryIsInventoryItemFlagEnabled(hash, 1 << 2)
    local isQualityPerfect = InventoryIsInventoryItemFlagEnabled(hash, 1 << 30)
    local isQualityHigh = InventoryIsInventoryItemFlagEnabled(hash, 1 << 29)
    local isQualityPoor = InventoryIsInventoryItemFlagEnabled(hash, 1 << 28)

    if (isQualityLegendary == 1) then
        result.special = true
        result.stars = 3
    elseif (isQualityPerfect == 1) then
        result.stars = 3
    elseif (isQualityHigh == 1) then
        result.stars = 2
    elseif (isQualityPoor == 1) then
        result.stars = 1
    else
        result.stars = 0
    end

    Ephemeral.cacheItemDatabase[hash] = result

    return result
end

function EnsureTxdIsLoaded(txd)
    local valid = DoesStreamedTextureDictExist(txd)

    if (not valid) then
        print("[NativeSatchel] EnsureTxdIsLoaded: Invalid TXD requested: " .. txd)
        return
    end

    local loaded = HasStreamedTextureDictLoaded(txd)

    if (not loaded) then
        RequestStreamedTextureDict(txd)
    end
end

function AddCategory(index, category, currentIndex)
    local datastoreMain = GetPersistedInt("RefCategoryItems")

    if (datastoreMain == 0 or DatabindingIsEntryValid(datastoreMain) ~= 1) then
        print("[NativeSatchel] AddCategory: Main data wasn't ready in time!")
        return
    end

    if (index == nil or category == nil) then
        print("[NativeSatchel] AddCategory: No index or category provided!")
        return
    end

    local data = DatabindingGetDataContainerFromChildIndex(datastoreMain, index)

    -- Set the texture from the "satchel_textures" TXD (eg. satchel_nav_all)
    DatabindingAddDataHash(data, "IconTexture", category.texture)

    -- This should be set the the current category index
    DatabindingAddDataBool(data, "CurrentCategory", index == currentIndex)

    DatabindingSetTemplatedUiItemHashAlias(datastoreMain, index, joaat("category_item"))

    return data
end

function AddMenuItem(index, item)
    local datastoreMain = GetPersistedInt("RefMenuItems")

    if (datastoreMain == 0 or DatabindingIsEntryValid(datastoreMain) ~= 1) then
        print("[NativeSatchel] AddMenuItem: Main data wasn't ready in time!")
        return
    end

    if (index == nil or item == nil) then
        print("[NativeSatchel] AddMenuItem: No index or item provided!")
        return
    end

    local id = item.id
    local hash = joaat(id)
    local count = item.count
    local maxCount = item.maxCount
    local enabled = item.enabled
    local label = item.label or id
    local txd = item.txd or "inventory_items"
    local texture = item.texture or "_placeholder"
    local special = item.special or false
    local stars = item.stars or 0

    EnsureTxdIsLoaded(txd)

    local data = DatabindingGetDataContainerFromChildIndex(datastoreMain, index)

    DatabindingAddDataHash(data, "item", hash)

    DatabindingAddDataBool(data, "focusable", enabled)
    DatabindingAddDataHash(data, "color", joaat("COLOR_PURE_WHITE")) -- Colorizes the ENTIRE item (incl count and bg)

    DatabindingAddDataHash(data, "ItemTXD", txd)
    DatabindingAddDataHash(data, "ItemTexture", texture)

    DatabindingAddDataInt(data, "count", count) -- Adds a quantity number to the item

    -- Makes the count red
    if (maxCount and count >= maxCount) then
        DatabindingAddDataBool(data, "maxCount", Config.enableRedCountOnMax or false)
    else
        DatabindingAddDataBool(data, "maxCount", false)
    end

    DatabindingAddDataInt(data, "quality", stars) -- Adds quality stars (0 to disable, 1-3 for stars)
    DatabindingAddDataBool(data, "overpowered", special) -- Makes the icon yellow

    DatabindingSetTemplatedUiItemHashAlias(datastoreMain, index, joaat("inventory_item"))

    return data
end

function AddMenuFolder(index, folder)
    local datastoreMain = GetPersistedInt("RefMenuItems")

    if (datastoreMain == 0 or DatabindingIsEntryValid(datastoreMain) ~= 1) then
        print("[NativeSatchel] AddMenuFolder: Main data wasn't ready in time!")
        return
    end

    if (index == nil or folder == nil) then
        print("[NativeSatchel] AddMenuFolder: No index or folder provided!")
        return
    end

    local id = folder.id
    local hash = joaat(id)
    local count = folder.count or 1
    local maxCount = folder.maxCount or false
    local txd = folder.txd or "inventory_items"
    local texture = folder.texture or "_placeholder"

    EnsureTxdIsLoaded(txd)

    local data = DatabindingGetDataContainerFromChildIndex(datastoreMain, index)

    DatabindingAddDataHash(data, "item", hash)

    DatabindingAddDataBool(data, "focusable", true)
    DatabindingAddDataHash(data, "color", joaat("COLOR_PURE_WHITE")) -- Colorizes the ENTIRE item (incl count and bg)

    DatabindingAddDataHash(data, "ItemTXD", txd)
    DatabindingAddDataHash(data, "ItemTexture", texture)

    -- Not sure why, but folders technically support counts
    -- To prevent lingering counts (datacontainer is reused), reset to default
    DatabindingAddDataInt(data, "count", count)

    -- Makes the count red
    if (maxCount and count >= maxCount) then
        DatabindingAddDataBool(data, "maxCount", Config.enableRedCountOnMax or false)
    else
        DatabindingAddDataBool(data, "maxCount", false)
    end

    DatabindingSetTemplatedUiItemHashAlias(datastoreMain, index, joaat("folder_item"))

    return data
end

function AddListItem(index, item)
    local datastoreMain = GetPersistedInt("RefListItems")

    if (datastoreMain == 0 or DatabindingIsEntryValid(datastoreMain) ~= 1) then
        print("[NativeSatchel] AddListItem: Main data wasn't ready in time!")
        return
    end

    if (index == nil or item == nil) then
        print("[NativeSatchel] AddListItem: No index or item provided!")
        return
    end

    local id = item.id
    local hash = joaat(id)
    local count = item.count
    local maxCount = item.maxCount
    local enabled = item.enabled
    local label = item.label or id
    local isEquipped = item.equipped or false

    local data = DatabindingGetDataContainerFromChildIndex(datastoreMain, index)

    DatabindingAddDataHash(data, "item", hash)

    DatabindingAddDataBool(data, "focusable", enabled)
    DatabindingAddDataHash(data, "label", 0)
    DatabindingAddDataString(data, "label_as_string", label)
    DatabindingAddDataHash(data, "color", joaat("COLOR_PURE_WHITE")) -- Colorizes the ENTIRE item (incl count and bg)

    DatabindingAddDataInt(data, "count", count) -- Adds a quantity number to the item

    -- Makes the count red
    if (maxCount and count >= maxCount) then
        DatabindingAddDataBool(data, "maxCount", Config.enableRedCountOnMax or false)
    else
        DatabindingAddDataBool(data, "maxCount", false)
    end

    DatabindingAddDataBool(data, "equipped", isEquipped) -- Adds a checkmark after the item

    DatabindingSetTemplatedUiItemHashAlias(datastoreMain, index, joaat("list_item"))

    return data
end

function InitializeData()
    InitializeResources()
    InitializePersistence()
    RefreshItems()
    RefreshHashMaps()
end

function InitializeSatchel()
    local categoriesReloaded = false
    local menuItemsReloaded = false

    Citizen.CreateThread(function ()
        while (true) do
            Citizen.Wait(10)

            local menuItems = GetPersistedInt("RefMenuItems")
            local listItems = GetPersistedInt("RefListItems")
            local mainData = GetPersistedInt("RefMainData")
            local selectedData = GetPersistedInt("RefSelectedData")
            local collectionData = GetPersistedInt("RefCollectionData")
            local categoryItems = GetPersistedInt("RefCategoryItems")

            if (menuItems == 0 or DatabindingIsEntryValid(menuItems) ~= 1) then
                InitializeSatchelMenuItems()
            elseif (listItems == 0 or DatabindingIsEntryValid(listItems) ~= 1) then
                InitializeSatchelListItems()
            elseif (mainData == 0 or DatabindingIsEntryValid(mainData) ~= 1) then
                InitializeSatchelMainData()
            elseif (selectedData == 0 or DatabindingIsEntryValid(selectedData) ~= 1) then
                InitializeSatchelSelectedData()
                InitializeSatchelSelectedEffects()
            elseif (collectionData == 0 or DatabindingIsEntryValid(collectionData) ~= 1) then
                InitializeSatchelCollectionData()
            elseif (categoryItems == 0 or DatabindingIsEntryValid(categoryItems) ~= 1) then
                InitializeSatchelCategories()
            elseif (categoriesReloaded ~= true) then
                ReloadSatchelCategories()
                categoriesReloaded = true
            elseif (menuItemsReloaded ~= true) then
                NavigateSatchelMenuItems()
                menuItemsReloaded = true
            else
                break
            end
        end
    end)
end

function SetShoppingMode(enabled)
    if (enabled) then
        DisplayRadar(false);
        EnableHudContext(joaat("HUD_CTX_IN_CATALOGUE_SHOP_MENU"));
        DisableControlAction(0, joaat("INPUT_OPEN_SATCHEL_MENU"), true);
    else
        DisplayRadar(true);
        DisableHudContext(joaat("HUD_CTX_IN_CATALOGUE_SHOP_MENU"));
        EnableControlAction(0, joaat("INPUT_OPEN_SATCHEL_MENU"), true);
    end
end

function OpenSatchel()
    if (Ephemeral.stateResourcesLoaded ~= true) then
        PostFeedTicker("Satchel resources are still loading, try again shortly.")
        return
    end

    local categoryIndex = Ephemeral.stateOverrideCategoryIndex or Config.defaultCategoryIndex or 0
    Ephemeral.stateOverrideCategoryIndex = nil

    SetPersistedInt("CurrentCategoryIndex", categoryIndex % #Config.categories)

    local mode = "ingame"

    if (Ephemeral.stateIsShopMode) then
        SetShoppingMode(true)
        mode = "shop"
    end

    LaunchUiappByHashWithEntry(joaat("satchel"), joaat(mode))
    InitializeSatchel()

    TriggerEvent(Config.eventHandlerKey .. ":satchel_opened", mode)

    Citizen.CreateThread(function()
        while IsUiappRunningByHash(uiAppChannel) == 1 do
            Citizen.Wait(0)
        end

        StopItemPreview()

        if (Ephemeral.stateIsShopMode) then
            SetShoppingMode(false)
        end

        CloseSatchel()
    end)
end

function CloseSatchel()
    local mode = "ingame"

    if (Ephemeral.stateIsShopMode) then
        mode = "shop"
    end

    TriggerEvent(Config.eventHandlerKey .. ":satchel_closed", mode)
end

-- Event debouncing utility
function CreateEventDebouncer(tickDelay, callback)
    return {
        pendingEvent = nil,
        ticks = 0,
        delay = tickDelay,
        execute = callback,

        -- Queue an event for debounced execution
        queue = function(self, eventData)
            self.pendingEvent = eventData
            self.ticks = 0
        end,

        -- Process pending events (call this every tick)
        process = function(self)
            if self.pendingEvent then
                self.ticks = self.ticks + 1
                if self.ticks >= self.delay then
                    self.execute(self.pendingEvent)
                    self.pendingEvent = nil
                    self.ticks = 0
                end
            end
        end
    }
end

-- Create debouncer for ITEM_FOCUSED events
local focusEventDebouncer = CreateEventDebouncer(5, function(eventData)
    EventItemFocused(eventData.index, eventData.parameter, eventData.datastore)
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

            if (Citizen.InvokeNative(0x90237103F27F7937, uiEventChannel, msg:Buffer()) ~= 0) then -- EVENTS_UI_PEEK_MESSAGE
                local event = msg:GetInt32(0)
                local index = msg:GetInt32(8)
                local parameter = msg:GetInt32(16)
                local datastore = msg:GetInt32(24)

                if (event == joaat("TAB_PAGE_INCREMENT") or event == joaat("TAB_PAGE_DECREMENT")) then
                    NavigateSatchelMenuItems()
                elseif event == joaat("ITEM_SELECTED") then
                    EventItemSelected(index, parameter, datastore)
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
                        Ephemeral.stateIsShopMode = false
                        OpenSatchel()
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

        if (IsUiappRunningByHash(uiAppChannel) == 1) then
            UiPromptEnablePromptTypeThisFrame(0)

            local playerId = PlayerId()
            local playerPed = GetPlayerPed(playerId)
            local playerIndex = GetPlayerIndex()

            if (IsPedFalling(playerPed) == 1) then
                CloseUiappByHash(uiAppChannel)
            elseif (IsPedFallingOver(playerPed) == 1) then
                CloseUiappByHash(uiAppChannel)
            elseif (IsPlayerBeingArrested(playerIndex, true) == 1) then
                CloseUiappByHash(uiAppChannel)
            elseif (IsPedHogtied(playerPed) == 1) then
                CloseUiappByHash(uiAppChannel)
            elseif (IsPedDeadOrDying(playerPed, true) == 1) then
                CloseUiappByHash(uiAppChannel)
            elseif (IsEntityDead(playerPed) == 1) then
                CloseUiappByHash(uiAppChannel)
            end
        end
    end
end)

InitializeData()

AddEventHandler("onResourceStart", function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    InitializeData()
end)

AddEventHandler("onResourceStop", function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    if IsUiappActiveByHash(uiAppChannel) then
        CloseUiappByHash(uiAppChannel)
    end
end)

-- Satchel Control Triggers
AddEventHandler(Config.eventHandlerKey .. ":open_satchel", function(mode, index)
    Ephemeral.stateIsShopMode = mode == "shop"
    Ephemeral.stateOverrideCategoryIndex = index
    OpenSatchel()
end)

AddEventHandler(Config.eventHandlerKey .. ":close_satchel", function(mode)
    if (Ephemeral.stateIsShopMode and mode == "ingame") then
        return
    end

    if (not Ephemeral.stateIsShopMode and mode == "shop") then
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
    RefreshSatchelAfterChange()
end)

AddEventHandler(Config.eventHandlerKey .. ":add_item", function(item)
    if type(item) ~= "table" or not item.id then
        print("[Native Satchel] Can't add an item without a valid item table with an ID")
        return
    end

    -- Check if item already exists
    local existingItem, index = FindItemById(item.id)
    if existingItem then
        -- Overwrite existing item
        existingItem = item

        -- Since the item was modified, move it to the front
        table.insert(Config.inventory, 1, table.remove(Config.inventory, index))
    else
        -- Add new item
        table.insert(Config.inventory, 1, item)
    end

    RefreshSatchelAfterChange()
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

    local item, index = FindItemById(itemId)

    if not item then
        print("[Native Satchel] Item '" .. itemId .. "' not found in the inventory")
        return
    end

    -- Increment item count
    item.count = (item.count or 0) + count

    -- Since the item was modified, move it to the front
    table.insert(Config.inventory, 1, table.remove(Config.inventory, index))

    RefreshSatchelAfterChange()
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

    local item, index = FindItemById(itemId)

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

    RefreshSatchelAfterChange()
end)

AddEventHandler(Config.eventHandlerKey .. ":remove_item", function(itemId)
    if type(itemId) ~= "string" then
        print("[Native Satchel] Can't remove an item without a valid ID")
        return
    end

    local item, index = FindItemById(itemId)

    if not item then
        print("[Native Satchel] Item '" .. itemId .. "' not found in the inventory")
        return
    end

    table.remove(Config.inventory, index)

    RefreshSatchelAfterChange()
end)
