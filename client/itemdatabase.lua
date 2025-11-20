-- Item database utility functions for accessing game data
-- Based on research by aaron1a12: https://github.com/aaron1a12/wild/

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
