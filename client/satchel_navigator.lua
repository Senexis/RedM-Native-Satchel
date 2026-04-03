---@class SatchelNavigator
SatchelNavigator = {}

-- ===================================================================
-- State & Initialization
-- ===================================================================

SatchelNavigator.inventories = {}
SatchelNavigator.allCategories = {}
SatchelNavigator.categories = {}
SatchelNavigator.categoryMap = {}
SatchelNavigator.activeInventoryIds = { ["player"] = true }
SatchelNavigator.folders = {}
SatchelNavigator.folderMap = {}
SatchelNavigator.currentItems = {}
SatchelNavigator.currentCategoryIndex = 1

SatchelNavigator.onError = function(message)
    print("[NativeSatchel] " .. tostring(message))
end

-- ===================================================================
-- Local Helper Methods
-- ===================================================================

local function shallowCopy(original)
    local copy = {}
    for k, v in pairs(original) do
        copy[k] = v
    end
    return copy
end

-- ===================================================================
-- Data Hooks
-- ===================================================================

function SatchelNavigator:processCategory(category)
    if not category.inventory then
        category.inventory = "player"
    end
end

function SatchelNavigator:processItem(item)
    if item.catalog and ItemdatabaseIsKeyValid(item.catalog, 0) then
        local helper = ItemDatabase.new(item.catalog)
        if not helper then error("ItemDatabase failed for " .. tostring(item.catalog)) end

        local txd, texture = helper:GetTexture()
        local interactions = helper:GetInteractionFlags()

        local result = {
            enabled = item.enabled ~= false,
            labelHash = helper:GetLabelHash(true),
            descriptionHash = helper:GetDescriptionHash(true),
            txd = txd,
            texture = texture,
            special = helper:IsSpecial(),
            stars = helper:GetQualityStars(),
            breakable = interactions.breakable,
            cookable = interactions.cookable,
            usable = interactions.usable,
            drinkable = interactions.drinkable,
            edible = interactions.edible,
            readable = interactions.readable,
            effects = helper:GetStats()
        }

        if Config.ignoreCannotDiscardTag ~= true then
            result.droppable = interactions.droppable
        end

        if Config.enableAutoCategorization then
            local tags = helper:GetTags()
            for _, value in pairs(tags) do
                for _, category in pairs(Config.categories) do
                    for _, tag in pairs(category.tags) do
                        if value == joaat(tag) then
                            result.category = category.id
                        end
                    end
                end

                if Config.enableAutoFolderAssignment then
                    for _, folder in pairs(Config.folders) do
                        for _, tag in pairs(folder.tags) do
                            if value == joaat(tag) then
                                result.folder = folder.id
                            end
                        end
                    end
                end
            end
        end

        -- Automatic properties should never overwrite existing properties, check each instead of merge
        -- Purpose: We want to be able to override any automatic properties in case we don't like them
        for key, value in pairs(result) do
            if not item[key] then
                item[key] = value
            end
        end
    end

    if not item.category and not item.folder and Config.defaultCategoryId then
        item.category = Config.defaultCategoryId
    end
end

function SatchelNavigator:processFolder(folder)
    -- Unused for now
end

-- ===================================================================
-- Private Helper Methods
-- ===================================================================

function SatchelNavigator:_prepareItem(raw)
    local item = shallowCopy(raw)
    local ok, error = pcall(self.processItem, self, item)
    if not ok then
        self.onError("Error processing item " .. tostring(item.id) .. ": " .. tostring(error))
    end
    return item
end

function SatchelNavigator:_prepareFolder(raw)
    local folder = shallowCopy(raw)
    local ok, error = pcall(self.processFolder, self, folder)
    if not ok then
        self.onError("Error processing folder " .. tostring(folder.id) .. ": " .. tostring(error))
    end
    return folder
end

function SatchelNavigator:_prepareCategory(raw)
    local category = shallowCopy(raw)
    local ok, error = pcall(self.processCategory, self, category)
    if not ok then
        self.onError("Error processing category " .. tostring(category.id) .. ": " .. tostring(error))
    end
    return category
end

function SatchelNavigator:_getInventoryContext(inventoryId)
    local id = inventoryId or "player"
    if not self.inventories[id] then
        self.inventories[id] = { list = {}, map = {} }
    end
    return self.inventories[id]
end

function SatchelNavigator:_rebuildVisibleCategories()
    self.categories = {}
    self.categoryMap = {}

    for _, cat in ipairs(self.allCategories) do
        if self.activeInventoryIds[cat.inventory] == true then
            table.insert(self.categories, cat)
            self.categoryMap[cat.id] = cat
        end
    end

    if self.currentCategoryIndex > #self.categories or self.currentCategoryIndex < 1 then
        self.currentCategoryIndex = 1
    end
end

function SatchelNavigator:_rebuildCurrentItems()
    if #self.categories == 0 then
        self.currentItems = {}
        return
    end

    local activeCategory = self.categories[self.currentCategoryIndex]
    if not activeCategory then
        self.currentItems = {}
        return
    end

    local targetInvId = activeCategory.inventory or "player"
    if not self.activeInventoryIds[targetInvId] then
        self.currentItems = {}
        return
    end

    local context = self:_getInventoryContext(targetInvId)
    local itemList = context.list

    local displayList = {}
    local isRecentTab = activeCategory.recent == true
    local isAllTab = activeCategory.all == true
    if isRecentTab and isAllTab then isRecentTab = false end

    local maxRecent = Config.maxRecentItems or 16
    local includeFolderItemsInRecent = Config.enableFolderItemsInRecent
    local minItemsForFolder = Config.minItemsForFolder or 2
    local enableFolderCount = Config.enableFolderItemCount

    local folderCounts = {}
    local seenRecentFolders = {}
    local seenNormalFolders = {}
    local recentCounter = 0

    for _, item in ipairs(itemList) do
        if item.folder and item.count > 0 and item.enabled ~= false then
            folderCounts[item.folder] = (folderCounts[item.folder] or 0) + 1
        end
    end

    for _, item in ipairs(itemList) do
        if item.count > 0 and item.enabled ~= false then
            if isRecentTab then
                if recentCounter < maxRecent then
                    local isRecentValid = true
                    if item.folderOnly and item.folder then
                        if not seenRecentFolders[item.folder] then
                            local folder = self.folderMap[item.folder]
                            if folder then
                                local entry = shallowCopy(folder)
                                entry.type = "folder"
                                entry.priority = tonumber(folder.priority) or 0
                                if enableFolderCount then
                                    entry.count = folderCounts[item.folder] or 0
                                end
                                entry._index = #displayList + 1
                                table.insert(displayList, entry)
                                seenRecentFolders[item.folder] = true
                                recentCounter = recentCounter + 1
                            end
                        end
                        isRecentValid = false
                    else
                        if item.folder and not includeFolderItemsInRecent then
                            isRecentValid = false
                        end
                    end
                    if isRecentValid then
                        local entry = shallowCopy(item)
                        entry.type = "item"
                        entry.priority = tonumber(item.priority) or 0
                        entry._index = #displayList + 1
                        table.insert(displayList, entry)
                        recentCounter = recentCounter + 1
                    end
                end
            elseif isAllTab or item.folder or item.category == activeCategory.id then
                if not item.folder then
                    local entry = shallowCopy(item)
                    entry.type = "item"
                    entry.priority = tonumber(item.priority) or 0
                    entry._index = #displayList + 1
                    table.insert(displayList, entry)
                else
                    local folder = self.folderMap[item.folder]
                    local folderValid = isAllTab or (folder and folder.category == activeCategory.id)

                    if folderValid and folder then
                        local fCount = folderCounts[item.folder] or 0
                        if fCount < minItemsForFolder and not item.folderOnly then
                            local entry = shallowCopy(item)
                            entry.type = "item"
                            entry.priority = tonumber(item.priority) or 0
                            entry._index = #displayList + 1
                            table.insert(displayList, entry)
                        elseif not seenNormalFolders[item.folder] then
                            local entry = shallowCopy(folder)
                            entry.type = "folder"
                            entry.priority = tonumber(folder.priority) or 0
                            if enableFolderCount then
                                entry.count = fCount
                            end
                            entry._index = #displayList + 1
                            table.insert(displayList, entry)
                            seenNormalFolders[item.folder] = true
                        end
                    end
                end
            end
        end
    end

    if not isRecentTab then
        table.sort(displayList, function(a, b)
            if a.priority ~= b.priority then
                return a.priority > b.priority
            end
            return a._index < b._index
        end)
    end

    local invItems = #displayList
    local unlockedSlots = activeCategory.slots

    if type(unlockedSlots) == "number" then
        local rowWidth = 4
        local currentFieldEnd = math.ceil(invItems / rowWidth) * rowWidth
        local fillTo = 0

        if unlockedSlots < 16 then
            fillTo = 16
        elseif invItems > 0 and invItems % rowWidth ~= 0 then
            if unlockedSlots < currentFieldEnd then
                fillTo = currentFieldEnd
            end
        end

        if fillTo > invItems then
            for index = invItems + 1, fillTo do
                if index <= unlockedSlots then
                    table.insert(displayList, {
                        id = string.format("empty_slot_%d", index),
                        type = "empty",
                    })
                else
                    table.insert(displayList, {
                        id = string.format("locked_slot_%d", index),
                        type = "locked",
                    })
                end
            end
        end
    end

    self.currentItems = displayList
end

-- ===================================================================
-- Public API: Configuration
-- ===================================================================

function SatchelNavigator:setCategories(categories)
    self.allCategories = {}
    for i, raw in ipairs(categories or {}) do
        local ok, result = pcall(SatchelValidator.Category, raw)
        if ok then
            local cat = self:_prepareCategory(result)
            table.insert(self.allCategories, cat)
        else
            self.onError("Error validating category at index " .. tostring(i) .. ": " .. tostring(result))
        end
    end

    self:_rebuildVisibleCategories()
    self:_rebuildCurrentItems()
end

function SatchelNavigator:setFolders(folders)
    self.folders = {}
    self.folderMap = {}
    for i, raw in ipairs(folders or {}) do
        local ok, result = pcall(SatchelValidator.Folder, raw)
        if ok then
            local folder = self:_prepareFolder(result)
            table.insert(self.folders, folder)
            self.folderMap[folder.id] = folder
        else
            self.onError("Error validating folder at index " .. tostring(i) .. ": " .. tostring(result))
        end
    end
end

-- ===================================================================
-- Public API: Inventory Management
-- ===================================================================

function SatchelNavigator:activateInventory(inventoryId)
    if not inventoryId then return end
    self.activeInventoryIds[inventoryId] = true
    self:_rebuildVisibleCategories()
    self:_rebuildCurrentItems()
end

function SatchelNavigator:deactivateInventory(inventoryId)
    if not inventoryId then return end
    self.activeInventoryIds[inventoryId] = nil -- nil removes key
    self:_rebuildVisibleCategories()
    self:_rebuildCurrentItems()
end

function SatchelNavigator:resetActiveInventories()
    self.activeInventoryIds = { ["player"] = true }
    self:_rebuildVisibleCategories()
    self:_rebuildCurrentItems()
end

function SatchelNavigator:hasActiveInventories()
    for _, active in pairs(self.activeInventoryIds) do
        if active then return true end
    end
    return false
end

function SatchelNavigator:setInventory(items, inventoryId)
    local targetId = inventoryId or "player"
    local context = self:_getInventoryContext(targetId)

    context.list = {}
    context.map = {}

    for i, raw in ipairs(items or {}) do
        local ok, validated = pcall(SatchelValidator.Item, raw)
        if ok then
            local item = self:_prepareItem(validated)
            item.inventoryId = targetId
            table.insert(context.list, item)
            context.map[item.id] = item
        else
            self.onError("Error validating item at index " .. tostring(i) .. " for inventory '" .. tostring(targetId) .. "': " .. tostring(validated))
        end
    end

    self:_rebuildCurrentItems()
end

-- ===================================================================
-- Public API: Item Manipulation
-- ===================================================================

function SatchelNavigator:addItem(rawItem, inventoryId)
    local targetId = inventoryId or "player"
    if not rawItem or not rawItem.id then return end

    local context = self:_getInventoryContext(targetId)

    if context.map[rawItem.id] then
        self:updateItem(rawItem.id, rawItem, targetId)
        return
    end

    local ok, validated = pcall(SatchelValidator.Item, rawItem)
    if ok then
        local item = self:_prepareItem(validated)
        item.inventoryId = targetId

        table.insert(context.list, 1, item)
        context.map[item.id] = item
        self:_rebuildCurrentItems()
    else
        self.onError("Error validating item for inventory '" .. tostring(targetId) .. "': " .. tostring(validated))
    end
end

function SatchelNavigator:incrementItem(itemId, count, inventoryId)
    local targetId = inventoryId or "player"
    local context = self:_getInventoryContext(targetId)
    local item = context.map[itemId]
    if not item then return end

    item.count = (item.count or 0) + count
    self:_rebuildCurrentItems()
end

function SatchelNavigator:decrementItem(itemId, count, inventoryId)
    local targetId = inventoryId or "player"
    local context = self:_getInventoryContext(targetId)
    local item = context.map[itemId]
    if not item then return end

    item.count = math.max((item.count or 0) - count, 0)
    if item.count <= 0 then
        self:removeItem(itemId, targetId)
        return
    end

    self:_rebuildCurrentItems()
end

function SatchelNavigator:updateItem(itemId, updates, inventoryId)
    local targetId = inventoryId or "player"
    local context = self:_getInventoryContext(targetId)
    local item = context.map[itemId]
    if not item then return end

    for k, v in pairs(updates) do
        item[k] = v
    end

    local ok, result = pcall(SatchelValidator.Item, item)
    if ok then
        self:processItem(item)
        self:_rebuildCurrentItems()
    else
        self.onError("Error validating updated item '" .. tostring(itemId) .. "' for inventory '" .. tostring(targetId) .. "': " .. tostring(result))
    end
end

function SatchelNavigator:removeItem(itemId, inventoryId)
    local targetId = inventoryId or "player"
    local context = self:_getInventoryContext(targetId)

    for i, item in ipairs(context.list) do
        if item.id == itemId then
            table.remove(context.list, i)
            context.map[itemId] = nil
            self:_rebuildCurrentItems()
            break
        end
    end
end

function SatchelNavigator:moveItem(itemId, fromInvId, toInvId, count)
    if count <= 0 then return false end

    local sourceContext = self:_getInventoryContext(fromInvId)
    local sourceItem = sourceContext.map[itemId]
    if not sourceItem or sourceItem.count < count then return false end

    local itemData = shallowCopy(sourceItem)
    itemData.count = count

    self:decrementItem(itemId, count, fromInvId)

    local targetContext = self:_getInventoryContext(toInvId)
    if targetContext.map[itemId] then
        self:incrementItem(itemId, count, toInvId)
    else
        self:addItem(itemData, toInvId)
    end

    return true
end

-- ===================================================================
-- Public API: Getters
-- ===================================================================

function SatchelNavigator:getCategories()
    return self.categories
end

function SatchelNavigator:getCurrentCategoryIndex()
    return self.currentCategoryIndex
end

function SatchelNavigator:getCurrentCategoryId()
    local category = self.categories[self.currentCategoryIndex]
    return category and category.id or nil
end

function SatchelNavigator:getCurrentCategory()
    return self.categories[self.currentCategoryIndex]
end

function SatchelNavigator:getCurrentItems()
    return self.currentItems
end

function SatchelNavigator:getActiveInventoryId()
    local category = self.categories[self.currentCategoryIndex]
    return category and category.inventory or "player"
end

-- ===================================================================
-- Public API: Retrieval Helpers
-- ===================================================================

function SatchelNavigator:isFolder(id)
    return self.folderMap[id] ~= nil
end

function SatchelNavigator:isItem(id, inventoryId)
    local targetId = inventoryId or self:getActiveInventoryId()
    local context = self:_getInventoryContext(targetId)
    return context.map[id] ~= nil
end

function SatchelNavigator:getFolderById(id)
    return self.folderMap[id]
end

function SatchelNavigator:getItemById(id, inventoryId)
    local targetId = inventoryId or self:getActiveInventoryId()
    local context = self:_getInventoryContext(targetId)
    return context.map[id]
end

function SatchelNavigator:getFolderContents(folderId, inventoryId)
    local targetId = inventoryId or self:getActiveInventoryId()
    local context = self:_getInventoryContext(targetId)
    local results = {}
    if not folderId then return results end

    for _, item in ipairs(context.list) do
        if item.folder == folderId and item.count > 0 and item.enabled ~= false then
            local entry = shallowCopy(item)
            entry.type = "item"
            entry.priority = tonumber(item.priority) or 0
            entry._index = #results + 1
            table.insert(results, entry)
        end
    end

    table.sort(results, function(a, b)
        if a.priority ~= b.priority then
            return a.priority > b.priority
        end
        return a._index < b._index
    end)

    return results
end

-- ===================================================================
-- Public API: Navigation
-- ===================================================================

function SatchelNavigator:setCategory(indexOrId)
    local newIndex = nil
    if type(indexOrId) == "number" then
        if self.categories[indexOrId] then
            newIndex = indexOrId
        else
            newIndex = 1
        end
    else
        for i, cat in ipairs(self.categories) do
            if cat.id == indexOrId then
                newIndex = i
                break
            end
        end
    end
    if newIndex then
        self.currentCategoryIndex = newIndex
        self:_rebuildCurrentItems()
        return true
    end
    return false
end

function SatchelNavigator:refresh()
    self:_rebuildVisibleCategories()
    self:_rebuildCurrentItems()
end
