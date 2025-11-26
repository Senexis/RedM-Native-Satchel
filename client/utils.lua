---------------------------------------------------------------------------------
--                            REDM NATIVE SATCHEL                              --
--                              Utilities Module                               --
--                Contains common utility functions and helpers                --
---------------------------------------------------------------------------------

local Utils = {}

-- Find an item by its ID in the inventory
function Utils.findItemById(itemId)
    for i, item in ipairs(Config.inventory) do
        if item.id == itemId then
            return item, i
        end
    end

    return nil, nil
end

-- Ensure a texture dictionary is loaded
function Utils.ensureTxdIsLoaded(txd)
    local valid = DoesStreamedTextureDictExist(txd)

    if not valid then
        print("[NativeSatchel] EnsureTxdIsLoaded: Invalid TXD requested: " .. txd)
        return
    end

    local loaded = HasStreamedTextureDictLoaded(txd)

    if not loaded then
        RequestStreamedTextureDict(txd)
    end
end

-- Initialize required resources (textures, text blocks)
function Utils.initializeResources()
    Citizen.CreateThread(function()
        Ephemeral.stateResourcesLoaded = false

        local textBlocksToLoad = { "global", "satch", "shop" }

        for _, block in ipairs(textBlocksToLoad) do
            if TextBlockIsLoaded(block) == 0 then
                TextBlockRequest(block)

                while TextBlockIsLoaded(block) == 0 do
                    Citizen.Wait(5)
                end
            end
        end

        local textureDictsToLoad = { "satchel_textures", "inventory_items", "inventory_items_mp" }

        for _, txd in ipairs(textureDictsToLoad) do
            if HasStreamedTextureDictLoaded(txd) == 0 then
                RequestStreamedTextureDict(txd)

                while HasStreamedTextureDictLoaded(txd) == 0 do
                    Citizen.Wait(5)
                end
            end
        end

        Ephemeral.stateResourcesLoaded = true
    end)
end

-- Create an event debouncer utility
function Utils.createEventDebouncer(tickDelay, callback)
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
                if self.ticks >= self.delay then
                    self.execute(self.pendingEvent)
                    self.pendingEvent = nil
                else
                    self.ticks = self.ticks + 1
                end
            end
        end
    }
end

-- Make Utils globally available
_G.Utils = Utils