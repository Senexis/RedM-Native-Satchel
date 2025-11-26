---------------------------------------------------------------------------------
--                            REDM NATIVE SATCHEL                              --
--                          Satchel Renderer Module                           --
--           Handles UI rendering, item management, and list updates          --
---------------------------------------------------------------------------------

local SatchelRenderer = {}

-- Dependencies (will be injected)
local PlayerState = nil
local Utils = nil
local UIDataBinding = nil
local ItemDatabase = nil

-- Initialize dependencies
function SatchelRenderer.init(playerState, utils, uiDataBinding, itemDatabase)
    PlayerState = playerState
    Utils = utils
    UIDataBinding = uiDataBinding
    ItemDatabase = itemDatabase
end

-- Reload categories and update UI
function SatchelRenderer.reloadSatchelCategories()
    local datastore = PlayerState.getPersistedInt("RefCategoryItems")
    local datastoreSelected = PlayerState.getPersistedInt("RefSelectedData")

    if datastore == 0 or DatabindingIsEntryValid(datastore) ~= 1 then
        print("[NativeSatchel] ReloadSatchelCategories: Category items wasn't ready in time!")
        return
    end

    if datastoreSelected == 0 or DatabindingIsEntryValid(datastoreSelected) ~= 1 then
        print("[NativeSatchel] ReloadSatchelCategories: Selected data wasn't ready in time!")
        return
    end

    local categoryIndex = 0
    local currentIndex = PlayerState.getPersistedInt("CurrentCategoryIndex")

    -- Clear existing cache
    PlayerState.clearCacheCategoryItems()

    for _, category in ipairs(Config.categories) do
        local data = SatchelRenderer.addCategory(categoryIndex, category, currentIndex)
        if data then
            PlayerState.setCacheCategoryItem(categoryIndex + 1, data)
            categoryIndex = categoryIndex + 1
        end
    end

    PlayerState.setPersistedInt("CurrentCategoryCount", categoryIndex)
    DatabindingSetTemplatedUiItemListSize(datastore, categoryIndex)

    DatabindingWriteDataIntFromParent(datastoreSelected, "CategoryIndex", currentIndex)
    DatabindingWriteDataIntFromParent(datastoreSelected, "DefaultCategoryIndex", currentIndex)
    DatabindingWriteDataIntFromParent(datastoreSelected, "CategoryCount", categoryIndex)
end

-- Update current category information
function SatchelRenderer.updateSatchelCurrentCategory()
    local datastoreSelected = PlayerState.getPersistedInt("RefSelectedData")

    if datastoreSelected == 0 or DatabindingIsEntryValid(datastoreSelected) ~= 1 then
        print("[NativeSatchel] UpdateSatchelCurrentCategory: Selected data wasn't ready in time!")
        return
    end

    local currentIndex = PlayerState.getPersistedInt("CurrentCategoryIndex")
    DatabindingWriteDataIntFromParent(datastoreSelected, "DefaultCategoryIndex", currentIndex)

    -- Update cached category items to highlight the current one
    local cacheCategoryItems = PlayerState.getCacheCategoryItems()
    for index, datastoreCategory in ipairs(cacheCategoryItems) do
        if ((index - 1) == currentIndex) then
            DatabindingWriteDataBoolFromParent(datastoreCategory, "CurrentCategory", true)
        else
            DatabindingWriteDataBoolFromParent(datastoreCategory, "CurrentCategory", false)
        end
    end
end

-- Clear menu items
function SatchelRenderer.clearSatchelMenuItems()
    local datastore = PlayerState.getPersistedInt("RefMenuItems")

    if datastore == 0 or DatabindingIsEntryValid(datastore) ~= 1 then
        print("[NativeSatchel] ClearSatchelMenuItems: Menu items wasn't ready in time!")
        return
    end

    Ephemeral.cacheMenuItems = {}
    PlayerState.setPersistedInt("CurrentItemCount", 0)
    DatabindingSetTemplatedUiItemListSize(datastore, 0)
end

-- Navigate menu items (rebuild the current category) - matches original NavigateSatchelMenuItems
function SatchelRenderer.navigateSatchelMenuItems()
    SatchelRenderer.clearSatchelSelectedData()

    if PlayerState.getPersistedInt("CurrentItemCount") > 0 then
        SatchelRenderer.clearSatchelMenuItems()
    end

    if PlayerState.getPersistedInt("CurrentListCount") > 0 then
        SatchelRenderer.clearSatchelListItems()
    end

    local datastore = PlayerState.getPersistedInt("RefMenuItems")
    local datastoreSelected = PlayerState.getPersistedInt("RefSelectedData")

    if datastore == 0 or DatabindingIsEntryValid(datastore) ~= 1 then
        print("[NativeSatchel] NavigateSatchelMenuItems: Menu items wasn't ready in time!")
        return
    end

    if datastoreSelected == 0 or DatabindingIsEntryValid(datastoreSelected) ~= 1 then
        print("[NativeSatchel] NavigateSatchelMenuItems: Selected data wasn't ready in time!")
        return
    end

    local currentCategoryIndex = DatabindingReadDataIntFromParent(datastoreSelected, "CategoryIndex")
    PlayerState.setPersistedInt("CurrentCategoryIndex", currentCategoryIndex)

    SatchelRenderer.updateSatchelCurrentCategory()

    -- Since the game is zero-based but LUA 1-based, increment
    -- Use modulo to wrap around when exceeding available categories
    local categoryKey = (currentCategoryIndex % #Config.categories) + 1
    local category = Config.categories[categoryKey]

    if not category then
        print("[NativeSatchel] NavigateSatchelMenuItems: Could not find category for index " .. currentCategoryIndex)
        return
    end

    if not category.titleHash or GetStringFromHashKey(category.titleHash) == "" then
        print("[NativeSatchel] NavigateSatchelMenuItems: Category " .. category.id .. " has an invalid title hash: " .. (category.titleHash or "nil"))
        category.titleHash = 0x69752E0D -- "Empty"
    end

    DatabindingWriteDataHashStringFromParent(datastoreSelected, "Category", category.titleHash)

    local filteredIndex = 0
    local menuEntries = {}
    local processedFolders = {}
    local recentItemCount = 0

    -- Clear existing cache
    Ephemeral.cacheMenuItems = {}

    -- Properly filter items based on category and folder logic (matching original)
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
                        -- Create a copy of folder data with the correct count
                        local folderData = {}
                        for k, v in pairs(folder) do folderData[k] = v end
                        folderData.count = folderItemCount
                        table.insert(menuEntries, { type = "folder", data = folderData })
                        processedFolders[item.folder] = { individual = false, count = folderItemCount, processed = 0 }
                    else
                        -- Mark folder as individual processing with count
                        processedFolders[item.folder] = { individual = true, count = folderItemCount, processed = 0 }
                    end
                end
            end

            -- If folder is set for individual processing, add this item
            if (processedFolders[item.folder] and processedFolders[item.folder].individual) then
                if (item.category == category.id or (not item.category and category.id == Config.defaultCategoryId)) then
                    table.insert(menuEntries, { type = "item", data = item })
                end
            end
        elseif (category.recent or item.category == category.id or (not item.category and category.id == Config.defaultCategoryId)) then
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
            added = SatchelRenderer.addMenuItem(filteredIndex, entry.data)
        elseif (entry.type == "folder") then
            added = SatchelRenderer.addMenuFolder(filteredIndex, entry.data)
        end

        if (added and added ~= 0) then
            table.insert(Ephemeral.cacheMenuItems, added)
            filteredIndex = filteredIndex + 1
        end
    end

    PlayerState.setPersistedInt("CurrentItemCount", filteredIndex)
    DatabindingSetTemplatedUiItemListSize(datastore, filteredIndex)

    UIDataBinding.updateSatchelIndexDescription("item")

    if filteredIndex < 1 then
        SatchelRenderer.emptyCategorySatchelSelectedData(category)
    end

    TriggerEvent(Config.eventHandlerKey .. ":category_changed", category.id)
end

-- Preload menu items for current category
function SatchelRenderer.preloadSatchelMenuItems()
    local datastore = PlayerState.getPersistedInt("RefMenuItems")

    if datastore == 0 or DatabindingIsEntryValid(datastore) ~= 1 then
        print("[NativeSatchel] PreloadSatchelMenuItems: Menu items wasn't ready in time!")
        return
    end

    local categoryIndex = PlayerState.getPersistedInt("CurrentCategoryIndex")
    local selectedCategory = Config.categories[categoryIndex + 1]

    if not selectedCategory then
        print("[NativeSatchel] PreloadSatchelMenuItems: Could not find category for index " .. categoryIndex)
        DatabindingSetTemplatedUiItemListSize(datastore, 0)
        PlayerState.setPersistedInt("CurrentItemCount", 0)
        return
    end

    Ephemeral.cacheMenuItems = {}
    local itemIndex = 0

    -- Add folders for this category
    for _, folder in ipairs(Config.folders) do
        if folder.category == selectedCategory.id then
            local folderCount = 0

            -- Count items in folder
            for _, item in ipairs(Ephemeral.cacheItems) do
                if item.folder == folder.id then
                    folderCount = folderCount + item.count
                end
            end

            if folderCount > 0 then
                local processedFolder = {
                    id = folder.id,
                    count = folderCount,
                    txd = folder.txd or "inventory_items",
                    texture = folder.texture or "_placeholder"
                }

                SatchelRenderer.addMenuFolder(itemIndex, processedFolder)
                table.insert(Ephemeral.cacheMenuItems, { type = "folder", data = processedFolder })
                itemIndex = itemIndex + 1
            end
        end
    end

    -- Add items for this category (not in folders)
    for _, item in ipairs(Ephemeral.cacheItems) do
        if (not item.folder or item.folder == "") and
           (item.category == selectedCategory.id or
            (not item.category and selectedCategory.id == Config.defaultCategoryId)) then

            SatchelRenderer.addMenuItem(itemIndex, item)
            table.insert(Ephemeral.cacheMenuItems, { type = "item", data = item })
            itemIndex = itemIndex + 1
        end
    end

    DatabindingSetTemplatedUiItemListSize(datastore, itemIndex)
    PlayerState.setPersistedInt("CurrentItemCount", itemIndex)

    -- Update empty category display
    if itemIndex == 0 and selectedCategory then
        SatchelRenderer.emptyCategorySatchelSelectedData(selectedCategory)
    end
end

-- Clear list items
function SatchelRenderer.clearSatchelListItems()
    local datastore = PlayerState.getPersistedInt("RefListItems")

    if datastore == 0 or DatabindingIsEntryValid(datastore) ~= 1 then
        print("[NativeSatchel] ClearSatchelListItems: List items wasn't ready in time!")
        return
    end

    PlayerState.setPersistedInt("CurrentListCount", 0)
    DatabindingSetTemplatedUiItemListSize(datastore, 0)
end

-- Preload list items for a specific folder
function SatchelRenderer.preloadSatchelListItems(folderIndex)
    if PlayerState.getPersistedInt("CurrentListCount") > 0 then
        SatchelRenderer.clearSatchelListItems()
    end

    local datastore = PlayerState.getPersistedInt("RefListItems")
    local datastoreSelected = PlayerState.getPersistedInt("RefSelectedData")

    if datastore == 0 or DatabindingIsEntryValid(datastore) ~= 1 then
        print("[NativeSatchel] PreloadSatchelListItems: List items wasn't ready in time!")
        return
    end

    if datastoreSelected == 0 or DatabindingIsEntryValid(datastoreSelected) ~= 1 then
        print("[NativeSatchel] PreloadSatchelListItems: Selected data wasn't ready in time!")
        return
    end

    if not folderIndex then
        print("[NativeSatchel] PreloadSatchelListItems: No folder index provided!")
        return
    end

    local folder = Config.folders[folderIndex]

    if not folder then
        print("[NativeSatchel] PreloadSatchelListItems: Could not find folder for index " .. folderIndex)
        return
    end

    if not folder.titleHash or GetStringFromHashKey(folder.titleHash) == "" then
        print("[NativeSatchel] PreloadSatchelListItems: Folder " .. folder.id .. " has an invalid title hash: " .. (folder.titleHash or "nil"))
        folder.titleHash = 0x69752E0D -- "Empty"
    end

    DatabindingWriteDataHashStringFromParent(datastoreSelected, "Folder", folder.titleHash)

    local listIndex = 0

    -- Clear existing cache
    Ephemeral.cacheMenuItems = {}

    for _, item in ipairs(Ephemeral.cacheItems) do
        if item.folder and item.folder == folder.id then
            local added = SatchelRenderer.addListItem(listIndex, item)

            if added and added ~= 0 then
                table.insert(Ephemeral.cacheMenuItems, added)
                listIndex = listIndex + 1
            end
        end
    end

    PlayerState.setPersistedInt("CurrentListCount", listIndex)
    DatabindingSetTemplatedUiItemListSize(datastore, listIndex)
end

-- Navigate list items (used for folder navigation)
function SatchelRenderer.navigateSatchelListItems()
    SatchelRenderer.clearSatchelSelectedData()
    UIDataBinding.updateSatchelIndexDescription("folder")
end

-- Add a category to the UI
function SatchelRenderer.addCategory(index, category, currentIndex)
    local datastoreMain = PlayerState.getPersistedInt("RefCategoryItems")

    if datastoreMain == 0 or DatabindingIsEntryValid(datastoreMain) ~= 1 then
        print("[NativeSatchel] AddCategory: Main data wasn't ready in time!")
        return
    end

    if index == nil or category == nil then
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

-- Add a menu item to the UI
function SatchelRenderer.addMenuItem(index, item)
    local datastoreMain = PlayerState.getPersistedInt("RefMenuItems")

    if datastoreMain == 0 or DatabindingIsEntryValid(datastoreMain) ~= 1 then
        print("[NativeSatchel] AddMenuItem: Main data wasn't ready in time!")
        return
    end

    if index == nil or item == nil then
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

    Utils.ensureTxdIsLoaded(txd)

    local data = DatabindingGetDataContainerFromChildIndex(datastoreMain, index)

    DatabindingAddDataHash(data, "item", hash)

    DatabindingAddDataBool(data, "focusable", enabled)
    DatabindingAddDataHash(data, "color", joaat("COLOR_PURE_WHITE")) -- Colorizes the ENTIRE item (incl count and bg)

    DatabindingAddDataHash(data, "ItemTXD", txd)
    DatabindingAddDataHash(data, "ItemTexture", texture)

    DatabindingAddDataInt(data, "count", count) -- Adds a quantity number to the item

    -- Makes the count red
    if maxCount and count >= maxCount then
        DatabindingAddDataBool(data, "maxCount", Config.enableRedCountOnMax or false)
    else
        DatabindingAddDataBool(data, "maxCount", false)
    end

    DatabindingAddDataInt(data, "quality", stars) -- Adds quality stars (0 to disable, 1-3 for stars)
    DatabindingAddDataBool(data, "overpowered", special) -- Makes the icon yellow

    DatabindingSetTemplatedUiItemHashAlias(datastoreMain, index, joaat("inventory_item"))

    return data
end

-- Add a menu folder to the UI
function SatchelRenderer.addMenuFolder(index, folder)
    local datastoreMain = PlayerState.getPersistedInt("RefMenuItems")

    if datastoreMain == 0 or DatabindingIsEntryValid(datastoreMain) ~= 1 then
        print("[NativeSatchel] AddMenuFolder: Main data wasn't ready in time!")
        return
    end

    if index == nil or folder == nil then
        print("[NativeSatchel] AddMenuFolder: No index or folder provided!")
        return
    end

    local id = folder.id
    local hash = joaat(id)
    local count = Config.enableFolderItemCount and (folder.count or 1) or 1
    local maxCount = folder.maxCount or false
    local txd = folder.txd or "inventory_items"
    local texture = folder.texture or "_placeholder"

    Utils.ensureTxdIsLoaded(txd)

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
    if maxCount and count >= maxCount then
        DatabindingAddDataBool(data, "maxCount", Config.enableRedCountOnMax or false)
    else
        DatabindingAddDataBool(data, "maxCount", false)
    end

    DatabindingSetTemplatedUiItemHashAlias(datastoreMain, index, joaat("folder_item"))

    return data
end

-- Add a list item to the UI
function SatchelRenderer.addListItem(index, item)
    local datastoreMain = PlayerState.getPersistedInt("RefListItems")

    if datastoreMain == 0 or DatabindingIsEntryValid(datastoreMain) ~= 1 then
        print("[NativeSatchel] AddListItem: Main data wasn't ready in time!")
        return
    end

    if index == nil or item == nil then
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
    if maxCount and count >= maxCount then
        DatabindingAddDataBool(data, "maxCount", Config.enableRedCountOnMax or false)
    else
        DatabindingAddDataBool(data, "maxCount", false)
    end

    DatabindingAddDataBool(data, "equipped", isEquipped) -- Adds a checkmark after the item

    DatabindingSetTemplatedUiItemHashAlias(datastoreMain, index, joaat("list_item"))

    return data
end

-- Update selected data for an item or folder
function SatchelRenderer.updateSatchelSelectedData(itemId, folderId)
    if not itemId and not folderId then
        print("[NativeSatchel] UpdateSatchelSelectedData: Could not determine item to update")
        return
    end

    local datastoreSelected = PlayerState.getPersistedInt("RefSelectedData")

    if datastoreSelected == 0 or DatabindingIsEntryValid(datastoreSelected) ~= 1 then
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

    if itemId then
        local item = Ephemeral.cacheItems[itemId]

        if not item then
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

        UIDataBinding.updateSatchelPrompts({
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

        if Config.enableItemPreview and item.catalog and not PlayerState.isShopMode() then
            local hash = joaat(item.catalog)
            if ItemdatabaseIsKeyValid(hash) ~= 0 then
                -- 1 for player, 2 for horse
                StartItemPreview(hash, 1)
            end
        end
    else
        local folder = Config.folders[folderId]

        if not folder then
            print("[NativeSatchel] UpdateSatchelSelectedData: Could not determine folder for ID " .. folderId)
            return
        end

        id = folder.id
        label = (folder.labelHash and GetStringFromHashKey(folder.labelHash)) or folder.label or ""
        description = (folder.descriptionHash and GetStringFromHashKey(folder.descriptionHash)) or folder.description or ""

        UIDataBinding.updateSatchelPrompts({ folder = true })
    end

    -- Update UI data
    DatabindingWriteDataHashStringFromParent(datastoreSelected, "Name", 0)
    DatabindingWriteStringFromParent(datastoreSelected, "NameAsString", label or "")

    DatabindingWriteDataHashStringFromParent(datastoreSelected, "Description", 0)
    DatabindingWriteStringFromParent(datastoreSelected, "DescriptionAsString", description or "")

    if Ephemeral.stateIsShopMode or Config.enableItemValueInRegularSatchel then
        DatabindingWriteStringFromParent(datastoreSelected, "PriceLabel", priceLabelHash or "")
        DatabindingWriteStringFromParent(datastoreSelected, "Price", priceValue or "")
    end

    local tipDescription = ""

    if count and count > 0 then
        if maxCount then
            if maxCount == 1 then
                tipDescription = GetStringFromHashKey("SATCHEL_TIP_UNIQUE")
            elseif count < maxCount then
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

    SatchelRenderer.updateSatchelSelectedEffects(effects)
end

-- Show empty category data
function SatchelRenderer.emptyCategorySatchelSelectedData(category)
    local datastoreSelected = PlayerState.getPersistedInt("RefSelectedData")

    if datastoreSelected == 0 or DatabindingIsEntryValid(datastoreSelected) ~= 1 then
        print("[NativeSatchel] EmptyCategorySatchelSelectedData: Selected data wasn't ready in time!")
        return
    end

    SatchelRenderer.clearSatchelSelectedData()

    local label = (category.emptyLabelHash and GetStringFromHashKey(category.emptyLabelHash)) or category.emptyLabel or ""
    local description = (category.emptyDescriptionHash and GetStringFromHashKey(category.emptyDescriptionHash)) or category.emptyDescription or ""

    DatabindingWriteDataHashStringFromParent(datastoreSelected, "Name", 0)
    DatabindingWriteStringFromParent(datastoreSelected, "NameAsString", label)
    DatabindingWriteDataHashStringFromParent(datastoreSelected, "Description", 0)
    DatabindingWriteStringFromParent(datastoreSelected, "DescriptionAsString", description)
end

-- Clear selected data
function SatchelRenderer.clearSatchelSelectedData()
    local datastoreSelected = PlayerState.getPersistedInt("RefSelectedData")

    if datastoreSelected == 0 or DatabindingIsEntryValid(datastoreSelected) ~= 1 then
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

    SatchelRenderer.clearSatchelSelectedEffects()
end

-- Update item effects display
function SatchelRenderer.updateSatchelSelectedEffects(effects)
    local datastoreEffects = PlayerState.getPersistedInt("RefSelectedEffectsData")

    if datastoreEffects == 0 or DatabindingIsEntryValid(datastoreEffects) ~= 1 then
        print("[NativeSatchel] UpdateSatchelSelectedEffects: Selected data wasn't ready in time!")
        return
    end

    SatchelRenderer.clearSatchelSelectedEffects()

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

        if key == "health" or key == "stamina" or key == "deadeye" or key == "horseHealth" or key == "horseStamina" then
            -- Tanks: -10 to -1 | 1 to 10   | 11 for overpowered
            if value ~= 11 and (value < -10 or value > 10) then
                print("[NativeSatchel] UpdateSatchelSelectedEffects: Invalid effect value for " .. key .. ": " .. value)
                value = 0
            end
        elseif key == "healthCore" or key == "staminaCore" or key == "deadeyeCore" or key == "horseHealthCore" or key == "horseStaminaCore" then
            -- Cores: -8 to -1  | 1 to 8    | 12 for overpowered
            if value ~= 12 and (value < -8 or value > 8) then
                print("[NativeSatchel] UpdateSatchelSelectedEffects: Invalid effect value for " .. key .. ": " .. value)
                value = 0
            end
        else
            print("[NativeSatchel] UpdateSatchelSelectedEffects: Unknown effect key " .. key)
            value = 0
        end

        -- Duration: 0 to 4
        if duration < 0 or duration > 4 then
            print("[NativeSatchel] UpdateSatchelSelectedEffects: Invalid effect duration for " .. key .. ": " .. duration)
            duration = 0
        end

        local durationHash = durationHashes[duration] or 0

        if key == "health" then
            DatabindingWriteDataIntFromParent(datastoreEffects, "health", value)
            DatabindingWriteDataHashStringFromParent(datastoreEffects, "healthDurationCategory", durationHash)
        elseif key == "stamina" then
            DatabindingWriteDataIntFromParent(datastoreEffects, "stamina", value)
            DatabindingWriteDataHashStringFromParent(datastoreEffects, "staminaDurationCategory", durationHash)
        elseif key == "deadeye" then
            DatabindingWriteDataIntFromParent(datastoreEffects, "deadeye", value)
            DatabindingWriteDataHashStringFromParent(datastoreEffects, "deadeyeDurationCategory", durationHash)
        elseif key == "healthCore" then
            DatabindingWriteDataIntFromParent(datastoreEffects, "healthCore", value)
            DatabindingWriteDataHashStringFromParent(datastoreEffects, "healthCoreDurationCategory", durationHash)
        elseif key == "staminaCore" then
            DatabindingWriteDataIntFromParent(datastoreEffects, "staminaCore", value)
            DatabindingWriteDataHashStringFromParent(datastoreEffects, "staminaCoreDurationCategory", durationHash)
        elseif key == "deadeyeCore" then
            DatabindingWriteDataIntFromParent(datastoreEffects, "deadeyeCore", value)
            DatabindingWriteDataHashStringFromParent(datastoreEffects, "deadeyeCoreDurationCategory", durationHash)
        elseif key == "horseHealth" then
            DatabindingWriteDataIntFromParent(datastoreEffects, "healthHorse", value)
            DatabindingWriteDataHashStringFromParent(datastoreEffects, "healthHorseDurationCategory", durationHash)
        elseif key == "horseStamina" then
            DatabindingWriteDataIntFromParent(datastoreEffects, "staminaHorse", value)
            DatabindingWriteDataHashStringFromParent(datastoreEffects, "staminaHorseDurationCategory", durationHash)
        elseif key == "horseHealthCore" then
            DatabindingWriteDataIntFromParent(datastoreEffects, "healthCoreHorse", value)
            DatabindingWriteDataHashStringFromParent(datastoreEffects, "healthCoreHorseDurationCategory", durationHash)
        elseif key == "horseStaminaCore" then
            DatabindingWriteDataIntFromParent(datastoreEffects, "staminaCoreHorse", value)
            DatabindingWriteDataHashStringFromParent(datastoreEffects, "staminaCoreHorseDurationCategory", durationHash)
        end
    end
end

-- Clear effects display
function SatchelRenderer.clearSatchelSelectedEffects()
    local datastoreSelected = PlayerState.getPersistedInt("RefSelectedEffectsData")

    if datastoreSelected == 0 or DatabindingIsEntryValid(datastoreSelected) ~= 1 then
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

-- Refresh satchel after changes
function SatchelRenderer.refreshSatchelAfterChange()
    PlayerState.refreshItems()
    PlayerState.refreshHashMaps()

    if IsUiappActiveByHash(joaat("satchel")) then
        SatchelRenderer.navigateSatchelMenuItems()
    end
end

-- Make SatchelRenderer globally available
_G.SatchelRenderer = SatchelRenderer