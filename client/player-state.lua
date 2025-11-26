---------------------------------------------------------------------------------
--                            REDM NATIVE SATCHEL                              --
--                            Player State Module                              --
--              Manages satchel state, persistence, and caching               --
---------------------------------------------------------------------------------

local PlayerState = {}

-- Global state object (preserved for compatibility)
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

-- Initialize persistence layer
function PlayerState.initializePersistence()
    local datastore = DatabindingGetDataContainerFromPath("NativeSatchel")

    if datastore == 0 or DatabindingIsEntryValid(datastore) ~= 1 then
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

-- Get a persisted integer value
function PlayerState.getPersistedInt(key)
    if Ephemeral.cachePersistence[key] then
        local value = Ephemeral.cachePersistence[key]
        return tonumber(value) or 0
    end

    local datastore = DatabindingGetDataContainerFromPath("NativeSatchel")

    if datastore == 0 or DatabindingIsEntryValid(datastore) ~= 1 then
        PlayerState.initializePersistence()
    end

    local value = DatabindingReadDataIntFromParent(datastore, key)
    return tonumber(value) or 0
end

-- Set a persisted integer value
function PlayerState.setPersistedInt(key, value)
    local datastore = DatabindingGetDataContainerFromPath("NativeSatchel")

    if datastore == 0 or DatabindingIsEntryValid(datastore) ~= 1 then
        PlayerState.initializePersistence()
    end

    DatabindingWriteDataIntFromParent(datastore, key, value)
    Ephemeral.cachePersistence[key] = value
end

-- Refresh items cache from inventory
function PlayerState.refreshItems()
    -- Clear the cache
    Ephemeral.cacheItems = {}

    -- Loop through the inventory and process each item
    for index, item in ipairs(Config.inventory) do
        local database = item.catalog and ItemDatabase.getItemFromDatabase(item.catalog) or {}

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

-- Refresh hash maps for quick lookups
function PlayerState.refreshHashMaps()
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

-- Set shopping mode state
function PlayerState.setShoppingMode(enabled)
    Ephemeral.stateIsShopMode = enabled
    if enabled then
        DisplayRadar(false);
        EnableHudContext(joaat("HUD_CTX_IN_CATALOGUE_SHOP_MENU"));
        DisableControlAction(0, joaat("INPUT_OPEN_SATCHEL_MENU"), true);
    else
        DisplayRadar(true);
        DisableHudContext(joaat("HUD_CTX_IN_CATALOGUE_SHOP_MENU"));
        EnableControlAction(0, joaat("INPUT_OPEN_SATCHEL_MENU"), true);
    end
end

-- Get current shopping mode state
function PlayerState.isShopMode()
    return Ephemeral.stateIsShopMode
end

-- Set category override index
function PlayerState.setCategoryOverride(index)
    Ephemeral.stateOverrideCategoryIndex = index
end

-- Get and clear category override index
function PlayerState.getCategoryOverride()
    local index = Ephemeral.stateOverrideCategoryIndex
    Ephemeral.stateOverrideCategoryIndex = nil
    return index
end

-- Check if resources are loaded
function PlayerState.areResourcesLoaded()
    return Ephemeral.stateResourcesLoaded
end

-- Cache management functions
function PlayerState.clearCacheCategoryItems()
    Ephemeral.cacheCategoryItems = {}
end

function PlayerState.setCacheCategoryItem(index, data)
    Ephemeral.cacheCategoryItems[index] = data
end

function PlayerState.getCacheCategoryItems()
    return Ephemeral.cacheCategoryItems
end

-- Initialize all state data
function PlayerState.initialize()
    PlayerState.initializePersistence()
    PlayerState.refreshItems()
    PlayerState.refreshHashMaps()
end

-- Make PlayerState globally available
_G.PlayerState = PlayerState