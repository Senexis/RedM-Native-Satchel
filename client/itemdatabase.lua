---------------------------------------------------------------------------------
--                            REDM NATIVE SATCHEL                              --
--                           Item Database Module                              --
--           Utility functions for accessing game item data and cache          --
--     Based on research by aaron1a12: https://github.com/aaron1a12/wild/      --
--                                                                             --
--   Consolidated from original satchel.lua GetItemFromDatabase function      --
--   with attribution to original implementation and research                  --
---------------------------------------------------------------------------------

local ItemDatabase = {}

---Gets tag IDs for an item with optional filtering by tag type
---@param item number The item hash
---@param filter number|nil Optional tag type filter (0 or nil for all tags)
---@return table tagIds Array of tag IDs
function GetItemTagIds(item, filter)
    local structData = DataView.ArrayBuffer(256)
    local structCount = DataView.ArrayBuffer(8)

    Citizen.InvokeNative(0x5A11D6EEA17165B0, item, structData:Buffer(), structCount:Buffer(), 20) -- _ITEMDATABASE_FILLOUT_TAG_DATA

    local tagIds = {}
    local count = structCount:GetInt32(0)

    for i = 0, count - 1 do
        local tagId = structData:GetInt32(16 * i + 8)
        local tagType = structData:GetInt32(16 * i + 16)

        if not filter or filter == 0 or tagType == filter then
            table.insert(tagIds, tagId)
        end
    end

    return tagIds
end

---Gets effect IDs for an item
---@param item number The item hash
---@return table effectIds Array of effect IDs
function GetItemEffectIds(item)
    local struct = DataView.ArrayBuffer(256)
    struct:SetInt32(8, 20)

    Citizen.InvokeNative(0x9379BE60DC55BBE6, item, struct:Buffer()) -- _ITEMDATABASE_FILLOUT_ITEM_EFFECT_IDS

    local effectIds = {}
    local count = struct:GetInt32(0)

    for i = 0, count - 1 do
        local effectId = struct:GetInt32(16 + 8 * i)
        table.insert(effectIds, effectId)
    end

    return effectIds
end

---Gets effect data for a specific effect ID
---@param effectId number The effect ID to get data for
---@return table info Effect information including id, type, value, time, timeUnits, corePercent, and durationcategory
function GetItemEffectData(effectId)
    local struct = DataView.ArrayBuffer(256)
    Citizen.InvokeNative(0xCF2D360D27FD1ABF, effectId, struct:Buffer()) -- ITEMDATABASE_FILLOUT_ITEM_EFFECT_ID_INFO

    return {
        id = struct:GetInt32(0), -- f_0 | same as effectId
        type = struct:GetInt32(8), -- f_1 | effect kind hash. Example values: `EFFECT_HEALTH`, `EFFECT_HEALTH_CORE`, `EFFECT_HEALTH_CORE_GOLD`, `EFFECT_HEALTH_OVERPOWERED`
        value = struct:GetInt32(16), -- f_2 | converted into a float, usually divided by 1.0f or 2.0f. Possibly 2.0f when Arthur is sick
        time = struct:GetInt32(24), -- f_3 | converted into a float by scripts
        timeUnits = struct:GetInt32(32), -- f_4 | some enum, possible values: 0, 1, 2, 3
        corePercent = struct:GetFloat32(40), -- f_5 | confirmed float, usually 12.5 or 100.0
        durationcategory = struct:GetInt32(48), -- f_6 | category hash. effect_duration_category_none, effect_duration_category_1 through 4
    }
end

---Gets UI data for an item including label, description, and texture information
---@param item number The item hash
---@return table data UI data with label, description, textureId, and textureDict fields
function GetItemUiData(item)
    local struct = DataView.ArrayBuffer(2048)
    struct:SetInt32(8 * 2, 5)
    struct:SetInt32(8 * 18, 8)

    Citizen.InvokeNative(0xB86F7CC2DC67AC60, item, struct:Buffer()) -- _ITEMDATABASE_FILLOUT_UI_DATA

    local data = {
        label = struct:GetInt32(0),
        description = struct:GetInt32(8),
        textureId = nil,
        textureDict = nil
    }

    for i = 0, 4 do
        local offset = 24 + (i * 8 * 3)

        if struct:GetUint8(offset) == 0 then
            break
        end

        if not IsStringNullOrEmpty(struct:GetInt64(offset)) then
            local texture = ReadString(struct:GetInt64(offset))
            local textureDict = ReadString(struct:GetInt64(offset + 8))
            local textureType = struct:GetInt32(offset + 16)

            if textureType == joaat("inventory") then
                data.textureId = texture
                data.textureDict = textureDict
                break
            end
        else
            break
        end
    end

    return data
end

---Checks if a string pointer is null or empty
---@param stringPtr number Pointer to string
---@return boolean isNullOrEmpty True if string is null or empty
function IsStringNullOrEmpty(stringPtr)
    local success = pcall(function()
        Citizen.InvokeNative(0x2CF12F9ACF18F048, stringPtr, Citizen.ResultAsInteger()) -- IS_STRING_NULL_OR_EMPTY
    end)

    return not success
end

---Reads a string from a pointer
---@param stringPtr number Pointer to string
---@return string content The string content
function ReadString(stringPtr)
    Citizen.InvokeNative(0xDFFC15AA63D04AAB, stringPtr) -- _SET_LAUNCH_PARAM_STRING
    return N_0xc59ab6a04333c502()
end

---Gets comprehensive item data from the database with caching
---@param item string The item identifier
---@return table itemData Comprehensive item data including effects, tags, and properties
---
--- CONSOLIDATED ATTRIBUTION:
--- Originally implemented in satchel.lua as GetItemFromDatabase function
--- Combines game database queries with custom categorization and caching logic
--- Uses research and utilities from aaron1a12 for native database access
function ItemDatabase.getItemFromDatabase(item)
    local hash = joaat(item)

    if Ephemeral.cacheItemDatabase[hash] then
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

    if ItemdatabaseIsKeyValid(hash, 0) == 0 then
        return result
    end

    local uiData = GetItemUiData(hash)
    if uiData then
        result.label = GetStringFromHashKey(uiData.label)
        result.labelHash = uiData.label
        result.description = GetStringFromHashKey(uiData.description)
        result.descriptionHash = uiData.description
        result.txd = uiData.textureDict
        result.texture = uiData.textureId
    end

    local effectIds = GetItemEffectIds(hash)
    if effectIds then
        result.effectIds = effectIds

        local durations = {
            [joaat("EFFECT_DURATION_CATEGORY_NONE")] = 0,
            [joaat("EFFECT_DURATION_CATEGORY_1")]    = 1,
            [joaat("EFFECT_DURATION_CATEGORY_2")]    = 2,
            [joaat("EFFECT_DURATION_CATEGORY_3")]    = 3,
            [joaat("EFFECT_DURATION_CATEGORY_4")]    = 4,
        }

        for _, effectId in pairs(effectIds) do
            local effect = GetItemEffectData(effectId)
            if effect then
                local value = tonumber(effect.value or 0)
                local duration = durations[effect.durationcategory] or 0

                if effect.type == joaat("EFFECT_HEALTH") then
                    result.effects["health"] = { value = value, duration = duration }
                elseif effect.type == joaat("EFFECT_HEALTH_OVERPOWERED") then
                    result.effects["health"] = { value = 11, duration = duration }
                elseif effect.type == joaat("EFFECT_STAMINA") then
                    result.effects["stamina"] = { value = value, duration = duration }
                elseif effect.type == joaat("EFFECT_STAMINA_OVERPOWERED") then
                    result.effects["stamina"] = { value = 11, duration = duration }
                elseif effect.type == joaat("EFFECT_DEADEYE") then
                    result.effects["deadeye"] = { value = value, duration = duration }
                elseif effect.type == joaat("EFFECT_DEADEYE_OVERPOWERED") then
                    result.effects["deadeye"] = { value = 11, duration = duration }
                elseif effect.type == joaat("EFFECT_HEALTH_CORE") then
                    result.effects["healthCore"] = { value = value, duration = duration }
                elseif effect.type == joaat("EFFECT_HEALTH_CORE_GOLD") then
                    result.effects["healthCore"] = { value = 12, duration = duration }
                elseif effect.type == joaat("EFFECT_STAMINA_CORE") then
                    result.effects["staminaCore"] = { value = value, duration = duration }
                elseif effect.type == joaat("EFFECT_STAMINA_CORE_GOLD") then
                    result.effects["staminaCore"] = { value = 12, duration = duration }
                elseif effect.type == joaat("EFFECT_DEADEYE_CORE") then
                    result.effects["deadeyeCore"] = { value = value, duration = duration }
                elseif effect.type == joaat("EFFECT_DEADEYE_CORE_GOLD") then
                    result.effects["deadeyeCore"] = { value = 12, duration = duration }
                elseif effect.type == joaat("EFFECT_HORSE_HEALTH") then
                    result.effects["horseHealth"] = { value = value, duration = duration }
                elseif effect.type == joaat("EFFECT_HORSE_HEALTH_OVERPOWERED") then
                    result.effects["horseHealth"] = { value = 11, duration = duration }
                elseif effect.type == joaat("EFFECT_HORSE_STAMINA") then
                    result.effects["horseStamina"] = { value = value, duration = duration }
                elseif effect.type == joaat("EFFECT_HORSE_STAMINA_OVERPOWERED") then
                    result.effects["horseStamina"] = { value = 11, duration = duration }
                elseif effect.type == joaat("EFFECT_HORSE_HEALTH_CORE") then
                    result.effects["horseHealthCore"] = { value = value, duration = duration }
                elseif effect.type == joaat("EFFECT_HORSE_HEALTH_CORE_GOLD") then
                    result.effects["horseHealthCore"] = { value = 12, duration = duration }
                elseif effect.type == joaat("EFFECT_HORSE_STAMINA_CORE") then
                    result.effects["horseStaminaCore"] = { value = value, duration = duration }
                elseif effect.type == joaat("EFFECT_HORSE_STAMINA_CORE_GOLD") then
                    result.effects["horseStaminaCore"] = { value = 12, duration = duration }
                end
            end
        end
    end

    local tagIds = GetItemTagIds(hash)
    for _, value in pairs(tagIds) do
        if value == joaat("CI_TAG_ITEM_OVERPOWERED") or value == joaat("CI_TAG_ITEM_QUALITY_LEGENDARY") then
            result.special = true
        end

        if not Config.ignoreCannotDiscardTag and value == joaat("CI_TAG_ITEM_CANNOT_DISCARD") then
            result.droppable = false
        end

        if value == joaat("CI_TAG_ITEM_CAN_BREAKDOWN") then
            result.breakable = true
        end

        if hash ~= joaat("PROVISION_ROTTEN_MEAT") and hash ~= joaat("CONSUMABLE_CORNEDBEEF_CAN") then
            if value == joaat("CI_TAG_ITEM_MEAT_ANIMAL") or value == joaat("CI_TAG_ITEM_MEAT_FISH") then
                result.cookable = true
            end
        end

        if value == joaat("CI_TAG_ITEM_CONSUMABLE") then
            result.usable = true
        end

        if value == -273840653 or value == 238865292 or value == 999632878 or value == 1130235258 or value == 1177617310 then
            result.drinkable = true
        end

        if value == -1915958659 or value == -809056541 or value == 89124942 or value == 1451036371 or value == 1859991422 or value == 1891031775 then
            result.edible = true
        end

        if value == joaat("CI_TAG_ITEM_DOCUMENT") then
            result.readable = true
        end

        if Config.enableAutoCategorization then
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

    if not result.category and Config.enableAutoCategorization then
        print("[NativeSatchel] GetItemFromDatabase: Could not auto-assign category for item " .. item)
    end

    local isQualityLegendary = InventoryIsInventoryItemFlagEnabled(hash, 1 << 2)
    local isQualityPerfect = InventoryIsInventoryItemFlagEnabled(hash, 1 << 30)
    local isQualityHigh = InventoryIsInventoryItemFlagEnabled(hash, 1 << 29)
    local isQualityPoor = InventoryIsInventoryItemFlagEnabled(hash, 1 << 28)

    if isQualityLegendary == 1 then
        result.special = true
        result.stars = 3
    elseif isQualityPerfect == 1 then
        result.stars = 3
    elseif isQualityHigh == 1 then
        result.stars = 2
    elseif isQualityPoor == 1 then
        result.stars = 1
    else
        result.stars = 0
    end

    Ephemeral.cacheItemDatabase[hash] = result

    return result
end

-- Make ItemDatabase globally available
_G.ItemDatabase = ItemDatabase
