-- Ref: https://github.com/aaron1a12/wild/
-- Todo: Proper attribution, rewrite slightly to make more modern sense

function ItemdatabaseGetTagIds(item, filter)
    local structData = DataView.ArrayBuffer(256)
    local structCount = DataView.ArrayBuffer(8)

    Citizen.InvokeNative(0x5A11D6EEA17165B0, item, structData:Buffer(), structCount:Buffer(), 20) -- _ITEMDATABASE_FILLOUT_TAG_DATA

    local tagIds = {}
    local count = structCount:GetInt32(0)

    for i = 0, count - 1 do
        local tagId = structData:GetInt32(16 * i + 8)
        local tagType = structData:GetInt32(16 * i + 16)

        if (not filter or filter == 0) then
            table.insert(tagIds, tagId)
        elseif (tagType and tagType == filter) then
            table.insert(tagIds, tagId)
        end
    end

    return tagIds
end

function ItemdatabaseGetEffectIds(item)
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

function ItemdatabaseGetUiData(item)
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

    local i = 0
    while i < 5 do
        local offset = 24 + (i * 8 * 3)

        if struct:GetUint8(offset) == 0 then
            break
        end

        if not IsStringNullOrEmpty(struct:GetInt64(offset)) then
            local texture = ReadString(struct:GetInt64(offset))
            local dict = ReadString(struct:GetInt64(offset + 8))
            local type = struct:GetInt32(offset + 16)

            if type == joaat("inventory") then
                data.textureId = texture
                data.textureDict = dict
            end
        else
            break
        end

        i = i + 1
    end

    return data
end

function IsStringNullOrEmpty(pStr)
    local ret = 0
    if pcall(function()
        Citizen.InvokeNative(0x2CF12F9ACF18F048, pStr, Citizen.ResultAsInteger())
    end) then
        ret = 0
    else
        ret = 1
    end

    if ret == 1 then
        return true
    else
        return false
    end
end

function ReadString(pStr)
    Citizen.InvokeNative(0xDFFC15AA63D04AAB, pStr) -- _SET_LAUNCH_PARAM_STRING
    return N_0xc59ab6a04333c502()
end
