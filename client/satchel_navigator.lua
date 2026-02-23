---@class SatchelNavigator
SatchelNavigator = {}

-- ===================================================================
-- State & Initialization
-- ===================================================================

SatchelNavigator.inventory = {}
SatchelNavigator.categories = {}
SatchelNavigator.folders = {}
SatchelNavigator.folderMap = {}
SatchelNavigator.categoryMap = {}
SatchelNavigator.itemMap = {}
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
    -- Unused for now
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

function SatchelNavigator:_rebuildCurrentItems()
    local activeCategory = self.categories[self.currentCategoryIndex]
    if not activeCategory then
        self.currentItems = {}
        return
    end

    local displayList = {}
    local isRecentTab = activeCategory.recent == true

    local folderCounts = {}
    for _, item in ipairs(self.inventory) do
        if item.folder and item.count > 0 and item.enabled ~= false then
            folderCounts[item.folder] = (folderCounts[item.folder] or 0) + 1
        end
    end

    if isRecentTab then
        local count = 0
        local maxItems = Config.maxRecentItems or 16
        local includeFolderItems = Config.enableFolderItemsInRecent
        local seenRecentFolders = {}

        for _, item in ipairs(self.inventory) do
            if count >= maxItems then break end
            local isValid = true

            if item.enabled == false or item.count <= 0 then isValid = false end

            if isValid then
                if item.folderOnly and item.folder then
                    if not seenRecentFolders[item.folder] then
                        local folderDef = self.folderMap[item.folder]
                        if folderDef then
                            local displayFolder = shallowCopy(folderDef)
                            displayFolder.type = "folder"

                            if Config.enableFolderItemCount then
                                displayFolder.count = folderCounts[item.folder] or 0
                            end

                            table.insert(displayList, displayFolder)
                            seenRecentFolders[item.folder] = true
                            count = count + 1
                        end
                    end
                else
                    if item.folder and not includeFolderItems then
                        isValid = false
                    end

                    if isValid then
                        local displayItem = shallowCopy(item)
                        displayItem.type = "item"
                        table.insert(displayList, displayItem)
                        count = count + 1
                    end
                end
            end
        end
    else
        local minItems = Config.minItemsForFolder or 2
        local seenFolders = {}

        for _, item in ipairs(self.inventory) do
            if item.count > 0 and item.enabled ~= false then
                if item.category == activeCategory.id and not item.folder then
                    local displayItem = shallowCopy(item)
                    displayItem.type = "item"
                    table.insert(displayList, displayItem)
                elseif item.folder then
                    local folderDef = self.folderMap[item.folder]
                    if folderDef and folderDef.category == activeCategory.id then
                        local fCount = folderCounts[item.folder] or 0
                        if fCount < minItems and not item.folderOnly then
                            local displayItem = shallowCopy(item)
                            displayItem.type = "item"
                            table.insert(displayList, displayItem)
                        elseif not seenFolders[item.folder] then
                            local displayFolder = shallowCopy(folderDef)
                            displayFolder.type = "folder"
                            if Config.enableFolderItemCount then
                                displayFolder.count = fCount
                            end
                            table.insert(displayList, displayFolder)
                            seenFolders[item.folder] = true
                        end
                    end
                end
            end
        end
    end

    self.currentItems = displayList
end

-- ===================================================================
-- Public API: Setters
-- ===================================================================

function SatchelNavigator:setCategories(categories)
    self.categories = {}
    self.categoryMap = {}
    for _, raw in ipairs(categories or {}) do
        local cat = self:_prepareCategory(raw)
        table.insert(self.categories, cat)
        self.categoryMap[cat.id] = cat
    end
    if self.currentCategoryIndex > #self.categories then self.currentCategoryIndex = 1 end
end

function SatchelNavigator:setFolders(folders)
    self.folders = {}
    self.folderMap = {}
    for _, raw in ipairs(folders or {}) do
        local folder = self:_prepareFolder(raw)
        table.insert(self.folders, folder)
        self.folderMap[folder.id] = folder
    end
end

function SatchelNavigator:setInventory(items)
    self.inventory = {}
    self.itemMap = {}
    for _, raw in ipairs(items or {}) do
        local item = self:_prepareItem(raw)
        table.insert(self.inventory, item)
        self.itemMap[item.id] = item
    end
    self:_rebuildCurrentItems()
end

-- ===================================================================
-- Public API: Item Manipulation
-- ===================================================================

function SatchelNavigator:addItem(rawItem)
    if not rawItem or not rawItem.id then return end

    if self.itemMap[rawItem.id] then
        self:updateItem(rawItem.id, rawItem)
        return
    end

    local item = self:_prepareItem(rawItem)
    table.insert(self.inventory, 1, item)
    self.itemMap[item.id] = item
    self:_rebuildCurrentItems()
end

function SatchelNavigator:incrementItem(itemId, count)
    local item = self.itemMap[itemId]
    if not item then return end
    item.count = (item.count or 0) + count
    self:_rebuildCurrentItems()
end

function SatchelNavigator:decrementItem(itemId, count)
    local item = self.itemMap[itemId]
    if not item then return end

    item.count = math.max((item.count or 0) - count, 0)
    if item.count <= 0 then
        self:removeItem(itemId)
        return
    end

    self:_rebuildCurrentItems()
end

function SatchelNavigator:updateItem(itemId, updates)
    local item = self.itemMap[itemId]
    if item then
        for k, v in pairs(updates) do item[k] = v end
        self:processItem(item)
        self:_rebuildCurrentItems()
    end
end

function SatchelNavigator:removeItem(itemId)
    for i, item in ipairs(self.inventory) do
        if item.id == itemId then
            table.remove(self.inventory, i)
            self.itemMap[itemId] = nil
            self:_rebuildCurrentItems()
            break
        end
    end
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

-- ===================================================================
-- Public API: Retrieval Helpers
-- ===================================================================

function SatchelNavigator:isFolder(id)
    return self.folderMap[id] ~= nil
end

function SatchelNavigator:isItem(id)
    return self.itemMap[id] ~= nil
end

function SatchelNavigator:getFolderById(id)
    return self.folderMap[id]
end

function SatchelNavigator:getItemById(id)
    return self.itemMap[id]
end

function SatchelNavigator:getFolderContents(folderId)
    local results = {}
    if not folderId then return results end
    for _, item in ipairs(self.inventory) do
        if item.folder == folderId and item.count > 0 and item.enabled ~= false then
            local display = shallowCopy(item)
            display.type = "item"
            table.insert(results, display)
        end
    end
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
    self:setCategories(self.categories)
    self:setFolders(self.folders)
    self:setInventory(self.inventory)
end
