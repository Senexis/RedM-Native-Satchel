-- Ref: https://github.com/aaron1a12/wild/
-- Todo: Proper attribution, rewrite slightly to make more modern sense

function ItemdatabaseGetEffectIds(item)
    local struct = DataView.ArrayBuffer(256)
    struct:SetInt32(8, 20)

    Citizen.InvokeNative(0x9379BE60DC55BBE6, item, struct:Buffer()) -- _ITEMDATABASE_FILLOUT_ITEM_EFFECT_IDS

    local effectIds = {}
    local count = struct:GetInt32(0)

    for i = 0, count - 1 do
        table.insert(effectIds, struct:GetInt32(16 + 8 * i))
    end

    return effectIds
end

function ItemdatabaseGetUiData(item)
    local struct = DataView.ArrayBuffer(2048)
    struct:SetInt32(8 * 2, 5)
    struct:SetInt32(8 * 18, 8)

    Citizen.InvokeNative(0xB86F7CC2DC67AC60, item, struct:Buffer()) -- _ITEMDATABASE_FILLOUT_UI_DATA

    local data = {
        name = struct:GetInt32(0),
        description = struct:GetInt32(8),
        textureId = 0,
        textureDict = ""
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
    if pcall(function ()
        Citizen.InvokeNative(0x2CF12F9ACF18F048, pStr, Citizen.ResultAsInteger()) 
    end) then
        ret = 0
    else
        ret = 1
    end

    if ret == 1 then return true else return false end
end

function ReadString(pStr)
    Citizen.InvokeNative(0xDFFC15AA63D04AAB, pStr) -- _SET_LAUNCH_PARAM_STRING
    return N_0xc59ab6a04333c502()
end
