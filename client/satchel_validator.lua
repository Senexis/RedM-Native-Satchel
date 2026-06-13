SatchelValidator = {}

local STRUCTURES <const> = {
    Effect = {
        type = "table",
        optional = true,
        schema = {
            value = { type = "number" },
            duration = { type = "number" },
        },
    },
    Tags = {
        type = "table",
        optional = true,
        items = { type = { "string", "number" } },
    },
}

local SCHEMAS <const> = {
    Item = {
        id = { type = { "string", "number" } },
        category = { type = { "string", "number" }, optional = true },
        catalog = { type = { "string", "number" }, optional = true },
        count = { type = "number" },
        maxCount = { type = "number", optional = true },
        enabled = { type = "boolean", optional = true },
        priority = { type = "number", optional = true },
        folder = { type = "string", optional = true },
        label = { type = "string", optional = true },
        labelHash = { type = { "string", "number" }, optional = true },
        description = { type = "string", optional = true },
        descriptionHash = { type = { "string", "number" }, optional = true },
        priceLabel = { type = "string", optional = true },
        priceLabelHash = { type = { "string", "number" }, optional = true },
        priceValue = { type = "string", optional = true },
        priceValueHash = { type = { "string", "number" }, optional = true },
        footer = { type = "string", optional = true },
        footerHash = { type = { "string", "number" }, optional = true },
        special = { type = "boolean", optional = true },
        stars = { type = "number", optional = true },
        txd = { type = { "string", "number" }, optional = true },
        texture = { type = { "string", "number" }, optional = true },
        effects = {
            type = "table",
            optional = true,
            schema = {
                health = STRUCTURES.Effect,
                stamina = STRUCTURES.Effect,
                deadeye = STRUCTURES.Effect,
                healthCore = STRUCTURES.Effect,
                staminaCore = STRUCTURES.Effect,
                deadeyeCore = STRUCTURES.Effect,
                horseHealth = STRUCTURES.Effect,
                horseStamina = STRUCTURES.Effect,
                horseHealthCore = STRUCTURES.Effect,
                horseStaminaCore = STRUCTURES.Effect,
            },
        },
        useLabel = { type = "string", optional = true },
        useLabelHash = { type = { "string", "number" }, optional = true },
        craftLabel = { type = "string", optional = true },
        craftLabelHash = { type = { "string", "number" }, optional = true },
        discardLabel = { type = "string", optional = true },
        discardLabelHash = { type = { "string", "number" }, optional = true },
        droppable = { type = "boolean", optional = true },
        discardable = { type = "boolean", optional = true },
        breakable = { type = "boolean", optional = true },
        cookable = { type = "boolean", optional = true },
        usable = { type = "boolean", optional = true },
        drinkable = { type = "boolean", optional = true },
        edible = { type = "boolean", optional = true },
        readable = { type = "boolean", optional = true },
        equipped = { type = "boolean", optional = true },
        sendable = { type = "boolean", optional = true },
        metadata = { type = "table", optional = true },

        validate = function(data, label)
            if not data.category and not data.catalog then
                error(string.format("[%s] At least one of 'category' or 'catalog' must be provided", label))
            end

            if data.count <= 0 then
                error(string.format("[%s] 'count' must be greater than 0", label))
            end

            if data.maxCount and data.maxCount <= 0 then
                error(string.format("[%s] 'maxCount' must be greater than 0", label))
            end
        end,
    },
    Category = {
        id = { type = { "string", "number" } },
        inventory = { type = "string", optional = true },
        all = { type = "boolean", optional = true },
        recent = { type = "boolean", optional = true },
        slots = { type = "number", optional = true },
        texture = { type = { "string", "number" }, optional = true },
        title = { type = "string", optional = true },
        titleHash = { type = { "string", "number" }, optional = true },
        emptyLabel = { type = "string", optional = true },
        emptyLabelHash = { type = { "string", "number" }, optional = true },
        emptyDescription = { type = "string", optional = true },
        emptyDescriptionHash = { type = { "string", "number" }, optional = true },
        slotEmptyLabel = { type = "string", optional = true },
        slotEmptyLabelHash = { type = { "string", "number" }, optional = true },
        slotEmptyDescription = { type = "string", optional = true },
        slotEmptyDescriptionHash = { type = { "string", "number" }, optional = true },
        slotLockedLabel = { type = "string", optional = true },
        slotLockedLabelHash = { type = { "string", "number" }, optional = true },
        slotLockedDescription = { type = "string", optional = true },
        slotLockedDescriptionHash = { type = { "string", "number" }, optional = true },
        tags = STRUCTURES.Tags,
        metadata = { type = "table", optional = true },
    },
    Folder = {
        id = { type = { "string", "number" } },
        category = { type = { "string", "number" } },
        title = { type = "string", optional = true },
        titleHash = { type = { "string", "number" }, optional = true },
        label = { type = "string", optional = true },
        labelHash = { type = { "string", "number" }, optional = true },
        description = { type = "string", optional = true },
        descriptionHash = { type = { "string", "number" }, optional = true },
        txd = { type = { "string", "number" }, optional = true },
        texture = { type = { "string", "number" }, optional = true },
        priority = { type = "number", optional = true },
        tags = STRUCTURES.Tags,
        metadata = { type = "table", optional = true },
    },
}

local function wrap(schema, data, label)
    if type(schema) == "string" then
        local resolved = SCHEMAS[schema]
        if not resolved then
            error(string.format("[System] Schema '%s' not found", schema), 2)
        end
        schema = resolved
    elseif type(schema) == "function" then
        schema = schema()
    end

    local proxy = {}

    local function verify(key, rule, value)
        if value == nil then
            if not rule.optional then
                error(string.format("[%s] Field '%s' is required", label, key), 3)
            end
            return nil
        end

        if rule.type then
            local value_type = type(value)
            local type_match = false

            if type(rule.type) == "table" then
                for _, t in ipairs(rule.type) do
                    if value_type == t then
                        type_match = true
                        break
                    end
                end
            else
                type_match = (value_type == rule.type)
            end

            if not type_match then
                local expected = type(rule.type) == "table" and
                    table.concat(rule.type, "|") or rule.type
                error(
                    string.format(
                        "[%s] Field '%s' must be %s (got %s)",
                        label,
                        key,
                        expected,
                        value_type
                    ),
                    3
                )
            end
        end

        if rule.type == "table" and rule.items then
            for i, item in ipairs(value) do
                verify(string.format("%s[%d]", key, i), rule.items, item)
            end
        end

        if rule.type == "table" and rule.schema then
            return wrap(rule.schema, value, label .. "." .. key)
        end

        return value
    end

    local function run_cross_checks()
        if schema.validate then
            schema.validate(data, label)
        end
    end

    for k, _ in pairs(data) do
        if not schema[k] then
            error(string.format("[%s] Field '%s' is not valid. If you need extra data, use 'metadata'", label, k), 2)
        end
    end

    for k, rule in pairs(schema) do
        if k ~= "validate" then
            data[k] = verify(k, rule, data[k])
        end
    end

    run_cross_checks()

    local mt = {
        __index = data,
        __newindex = function(_, k, v)
            local rule = schema[k]
            if not rule then
                error(string.format("[%s] Field '%s' is not valid. If you need extra data, use 'metadata'", label, k), 2)
            end

            local old_val = data[k]
            data[k] = verify(k, rule, v)

            local status, err = pcall(run_cross_checks)
            if not status then
                data[k] = old_val
                error(err, 2)
            end
        end,
        __len = function()
            return #data
        end,
        __pairs = function()
            return next, data, nil
        end,
        __tostring = function()
            return string.format("<Validated %s>", label)
        end,
        __metatable = "Modify schema to change this",
    }

    return setmetatable(proxy, mt)
end

--- Creates a new Validated Item object
--- @param data table The initial data table
--- @param id string|nil An optional identifier for error messages, defaults to "Item"
function SatchelValidator.Item(data, id)
    if type(data) ~= "table" then
        error("Expected table, got " .. type(data), 2)
    end
    return wrap(SCHEMAS.Item, data or {}, id or "Item")
end

--- Creates a new Validated Category object
--- @param data table The initial data table
--- @param id string|nil An optional identifier for error messages, defaults to "Category"
function SatchelValidator.Category(data, id)
    if type(data) ~= "table" then
        error("Expected table, got " .. type(data), 2)
    end
    return wrap(SCHEMAS.Category, data or {}, id or "Category")
end

--- Creates a new Validated Folder object
--- @param data table The initial data table
--- @param id string|nil An optional identifier for error messages, defaults to "Folder"
function SatchelValidator.Folder(data, id)
    if type(data) ~= "table" then
        error("Expected table, got " .. type(data), 2)
    end
    return wrap(SCHEMAS.Folder, data or {}, id or "Folder")
end
