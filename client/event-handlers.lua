---------------------------------------------------------------------------------
--                            REDM NATIVE SATCHEL                              --
--                            Event Handlers Module                            --
--              Contains all UI event handling logic by function               --
---------------------------------------------------------------------------------

local EventHandlers = {}

-- Dependencies (will be injected)
local PlayerState = nil
local Utils = nil
local Config = nil
local SatchelRenderer = nil
local UIDataBinding = nil

-- Initialize dependencies
function EventHandlers.init(playerState, utils, config, satchelRenderer, uiDataBinding)
    PlayerState = playerState
    Utils = utils
    Config = config
    SatchelRenderer = satchelRenderer
    UIDataBinding = uiDataBinding
end

-- Handle item focused events
function EventHandlers.eventItemFocused(index, parameter, datastore)
    local selectedKey = DatabindingReadDataHashStringFromParent(datastore, "item")

    -- Sometimes the UI doesn't properly focus on an item, this is a game bug
    -- You can also see this happening by switching from first to last rapidly
    if not selectedKey or selectedKey == 0 then
        return
    end

    local itemIndex = Config.mapItemsJoaat[selectedKey]
    local item = nil
    local itemId = nil
    if itemIndex then item = Ephemeral.cacheItems[itemIndex] end
    if item then itemId = item.id end

    local folderIndex = Config.mapFoldersJoaat[selectedKey]
    local folder = nil
    local folderId = nil
    if folderIndex then folder = Config.folders[folderIndex] end
    if folder then folderId = folder.id end

    PlayerState.setPersistedInt("CurrentItemIndex", index)
    UIDataBinding.updateSatchelIndexDescription("item")

    if parameter == joaat("FOLDER_ITEM") or parameter == joaat("USABLE_ITEM") then
        SatchelRenderer.updateSatchelSelectedData(itemIndex, folderIndex)
    end

    if parameter == joaat("FOLDER_ITEM") then
        SatchelRenderer.preloadSatchelListItems(folderIndex)

        if folderId then
            TriggerEvent(Config.eventHandlerKey .. ":folder_focused", folderId)
        end
    elseif parameter == joaat("USABLE_ITEM") then
        if itemId then
            TriggerEvent(Config.eventHandlerKey .. ":item_focused", itemId)
        end
    else
        print("[NativeSatchel] EventItemFocused: Unknown focus parameter: " .. parameter)
    end
end

-- Handle item selected events
function EventHandlers.eventItemSelected(index, parameter, datastore)
    local selectedKey = DatabindingReadDataHashStringFromParent(datastore, "item")

    -- Sometimes the UI doesn't properly focus on an item, this is a game bug
    -- You can also see this happening by switching from first to last rapidly
    if not selectedKey or selectedKey == 0 then
        return
    end

    local itemIndex = Config.mapItemsJoaat[selectedKey]
    local item = nil
    local itemId = nil
    if itemIndex then item = Ephemeral.cacheItems[itemIndex] end
    if item then itemId = item.id end

    local folderIndex = Config.mapFoldersJoaat[selectedKey]
    local folder = nil
    local folderId = nil
    if folderIndex then folder = Config.folders[folderIndex] end
    if folder then folderId = folder.id end

    if parameter == joaat("FOLDER_ITEM") then
        SatchelRenderer.navigateSatchelListItems()

        if folderId then
            TriggerEvent(Config.eventHandlerKey .. ":folder_opened", folderId)
        end
    elseif parameter == joaat("USABLE_ITEM") then
        if itemId then
            TriggerEvent(Config.eventHandlerKey .. ":item_used", itemId)
        end
    elseif parameter == joaat("BREAKABLE_ITEM") then
        if itemId then
            TriggerEvent(Config.eventHandlerKey .. ":item_crafted", itemId)
        end
    elseif parameter == joaat("DROP_ITEM") then
        if itemId then
            TriggerEvent(Config.eventHandlerKey .. ":item_dropped", itemId)
        end
    elseif parameter == joaat("DISCARD_ALL") then
        if itemId then
            TriggerEvent(Config.eventHandlerKey .. ":item_discarded", itemId)
        end
    elseif parameter == joaat("SEND_ALL") then
        if itemId then
            TriggerEvent(Config.eventHandlerKey .. ":item_sent", itemId)
        end
    else
        print("[NativeSatchel] EventItemSelected: Unknown select parameter: " .. parameter)
    end
end

-- Handle navigation between menu items (tab page increment/decrement)
function EventHandlers.handleNavigateSatchelMenuItems()
    SatchelRenderer.navigateSatchelMenuItems()
end

-- Make EventHandlers globally available
_G.EventHandlers = EventHandlers