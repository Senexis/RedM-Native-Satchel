---------------------------------------------------------------------------------
--                                                                             --
--                                CONFIGURATION                                --
--                                                                             --
---------------------------------------------------------------------------------
Config = {}

-- TODO: Configuration for "Satchel" title

-- Change this in case you have another resource using the "native_satch" prefix for events
Config.eventHandlerKey = "native_satchel"

-- Enable/disable prompts for opening folders
Config.allowOpeningFolders = true

-- Enable/disable prompts for various consume actions
Config.allowDrinking = true
Config.allowEating = true
Config.allowReading = true
Config.allowUsing = true

-- Enable/disable prompts for various held actions
-- TODO: Add triggers for these (when close to campfire, allow cooking)
Config.allowBreakdown = true
Config.allowCooking = true

-- Enable/disable prompts for dropping items
Config.allowDropping = true

-- Enable/disable prompts for discarding items
Config.allowDiscarding = true

-- "Discard" by default means removing all items, but it can be anything you want
-- Useful if you want to make a selling, giving away, etc. system
Config.discardingLabel = ""
Config.discardingLabelHash = "SATCHEL_PROMPT_DISCARD_ALL"

-- Default category index to open to when opening the satchel
Config.defaultCategoryIndex = 0

-- Default category ID for items that don't specify a category
Config.defaultCategoryId = "provisions"

-- Whether to enable the item preview on items that have a valid catalog entry
-- Item previews show the before/after core states of the highlighted item
Config.enableItemPreview = true

-- The game assumes some items cannot be discarded based on their tags
-- Set this to true to ignore those tags and allow discarding any item
Config.ignoreCannotDiscardTag = false

-- When an item reaches its max count, show the count in red color
-- This doesn't affect the tip text, which will always be marked red
Config.enableRedCountOnMax = false

-- Whether to show the item value section in regular satchel mode
Config.enableItemValueInRegularSatchel = false

-- Automatically categorize items based on their tags in the item database
-- This requires the base game's categories to be present in Config.categories
-- All of them are included by default in this file
Config.enableAutoCategorization = true

-- Automatically assign folders to items based on their tags in the item database
-- This requires the base game's folders to be present in Config.folders
-- All of them are included by default in this file
Config.enableAutoFolderAssignment = true

-- Whether to include items stored in folders in the "Recent" category
-- By default, items that are inside folders will be shown in the "Recent" category
-- Use this if you don't want to have to set textures for every item in a folder
Config.enableFolderItemsInRecent = true

-- Maximum number of items to show in the "Recent" category
-- This prevents the recent category from becoming too crowded
-- Be careful when increasing this value, as it may impact performance
Config.maxRecentItems = 48

-- Minimum number of items required to show as a folder
-- If a folder contains fewer items than this threshold, items will be shown individually
-- Set to 1 to always show folders, set to 2 or higher to show individual items when below threshold
Config.minItemsForFolder = 2

-- Whether to show item count on folder icons
-- When enabled, folders will display the number of items they contain
Config.enableFolderItemCount = false

-- Items
-- This determines which items are visible in the UI by category
-- You can see this as the base inventory for any player
-- It can then be modified by using the Satchel API to add/remove items
Config.inventory = {
    {
        -- Required fields
        id = "my_custom_item",
        count = 1,

        -- Required if missing item.catalog or Config.enableAutoCategorization is disabled
        -- Optional if item.catalog is set and Config.enableAutoCategorization is enabled
        category = "provisions",

        -- Optional fields
        maxCount = 1,
        enabled = true,
        catalog = nil,
        folder = nil,

        -- Custom item fields
        label = "My Custom Item",
        description = "This is my custom item.",
        priceLabelHash = "SHOP_VALUE",
        priceValue = "Priceless",
        special = true,
        stars = 3,
        txd = "toasts_mp_generic",
        texture = "toast_mp_standalone_sp",
        effects = {
            health = { value = 11, duration = 0 },
            stamina = { value = 11, duration = 1 },
            deadeye = { value = 11, duration = 2 },
            healthCore = { value = 12, duration = 3 },
            staminaCore = { value = 12, duration = 4 },
            deadeyeCore = { value = -1, duration = 0 },
        },

        -- List-only flags
        equipped = false,

        -- Prompt flags
        droppable = false,
        discardable = false,
        breakable = false,
        cookable = false,
        usable = false,
        drinkable = false,
        edible = false,
        readable = false,
    },

    { id = "big_game_meat_cooked",           count = 5,  maxCount = nil, catalog = "CONSUMABLE_BIG_GAME_MEAT_COOKED", },
    { id = "special_tonic_crafted",          count = 10, maxCount = 10,  catalog = "CONSUMABLE_SPECIAL_TONIC_CRAFTED", },
    { id = "bird_feather_flight",            count = 7,  maxCount = 10,  catalog = "PROVISION_BIRD_FEATHER_FLIGHT", },
    { id = "necklace_gold",                  count = 8,  maxCount = nil, catalog = "PROVISION_NECKLACE_GOLD", },
    { id = "horse_reviver",                  count = 1,  maxCount = nil, catalog = "CONSUMABLE_HORSE_REVIVER", },
    { id = "prime_beef",                     count = 1,  maxCount = nil, catalog = "PROVISION_PRIME_BEEF", },
    { id = "herbivore_bait",                 count = 1,  maxCount = nil, catalog = "CONSUMABLE_HERBIVORE_BAIT", },
    { id = "salmon_can",                     count = 1,  maxCount = nil, catalog = "CONSUMABLE_SALMON_CAN", },
    { id = "rabbit_pelt_pristine",           count = 1,  maxCount = nil, catalog = "PROVISION_RABBIT_PELT_PRISTINE", },
    { id = "armadillo_skin",                 count = 1,  maxCount = nil, catalog = "PROVISION_ARMADILLO_SKIN", },
    { id = "legendary_beaver_pelt_1",        count = 1,  maxCount = nil, catalog = "PROVISION_ROLE_NATURALIST_PELT_BEAVER_LEGENDARY_01", },
    { id = "carcass_wolf_high_quality",      count = 1,  maxCount = nil, catalog = "PROVISION_ANIMAL_CARCASS_WOLF_HIGH_QUALITY", },
    { id = "buckle_silver",                  count = 1,  maxCount = nil, catalog = "PROVISION_BUCKLE_SILVER", },
    { id = "fish_smallmouth_bass",           count = 1,  maxCount = nil, catalog = "PROVISION_FISH_SMALLMOUTH_BASS", },
    { id = "carcass_deer_poor",              count = 1,  maxCount = nil, catalog = "PROVISION_ANIMAL_CARCASS_DEER_POOR", },
    { id = "tenn_whiskey",                   count = 1,  maxCount = nil, catalog = "CONSUMABLE_TENN_WHISKEY", },
    { id = "irish_whiskey",                  count = 1,  maxCount = nil, catalog = "CONSUMABLE_IRISH_WHISKEY", },
    { id = "scotch_whiskey",                 count = 1,  maxCount = nil, catalog = "CONSUMABLE_SCOTCH_WHISKEY", },
    { id = "cyprus_brandy",                  count = 1,  maxCount = nil, catalog = "CONSUMABLE_CYPRUS_BRANDY", },
    { id = "carcass_crow_perfect",           count = 1,  maxCount = nil, catalog = "PROVISION_ANIMAL_CARCASS_CROW_PERFECT", },
    { id = "skinned_carcass_pig_perfect",    count = 1,  maxCount = nil, catalog = "PROVISION_SKINNED_CARCASS_PIG_PERFECT", },
    { id = "carcass_songbird_poor",          count = 1,  maxCount = nil, catalog = "PROVISION_ANIMAL_CARCASS_SONGBIRD_POOR", },
    { id = "carcass_cormorant_high_quality", count = 1,  maxCount = nil, catalog = "PROVISION_ANIMAL_CARCASS_CORMORANT_HIGH_QUALITY", },
    { id = "wolf_fur_poor",                  count = 1,  maxCount = nil, catalog = "PROVISION_WOLF_FUR_POOR", },
    { id = "gila_skin",                      count = 1,  maxCount = nil, catalog = "PROVISION_GILA_SKIN", },
    { id = "herb_milkweed",                  count = 1,  maxCount = nil, catalog = "CONSUMABLE_HERB_MILKWEED", },
    { id = "herb_burdock_root",              count = 1,  maxCount = nil, catalog = "CONSUMABLE_HERB_BURDOCK_ROOT", },
    { id = "bread_chunk",                    count = 1,  maxCount = nil, catalog = "CONSUMABLE_BREAD_CHUNK", },
    { id = "exotic_bird_wild_mint_cooked",   count = 1,  maxCount = nil, catalog = "CONSUMABLE_EXOTIC_BIRD_WILD_MINT_COOKED", },
    { id = "gamey_bird_cooked",              count = 1,  maxCount = nil, catalog = "CONSUMABLE_GAMEY_BIRD_COOKED", },
    { id = "cocaine_chewing_gum",            count = 1,  maxCount = nil, catalog = "CONSUMABLE_COCAINE_CHEWING_GUM", },
    { id = "herb_prairie_poppy",             count = 1,  maxCount = nil, catalog = "CONSUMABLE_HERB_PRAIRIE_POPPY", },
    { id = "big_game_meat_thyme_cooked",     count = 5,  maxCount = nil, catalog = "CONSUMABLE_BIG_GAME_MEAT_THYME_COOKED", },
    { id = "medicine",                       count = 1,  maxCount = nil, catalog = "CONSUMABLE_MEDICINE", },
    { id = "moonshine",                      count = 1,  maxCount = nil, catalog = "CONSUMABLE_MOONSHINE", },
    { id = "peach",                          count = 1,  maxCount = nil, catalog = "CONSUMABLE_PEACH", },
    { id = "cigar",                          count = 1,  maxCount = nil, catalog = "CONSUMABLE_CIGAR", },
    { id = "snake_oil_used",                 count = 1,  maxCount = nil, catalog = "CONSUMABLE_SNAKE_OIL_USED", },
    { id = "card_ace_swords",                count = 1,  maxCount = nil, catalog = "DOCUMENT_CARD_ACE_SWORDS", },
    { id = "card_eight_swords",              count = 1,  maxCount = nil, catalog = "DOCUMENT_CARD_EIGHT_SWORDS", },
    { id = "card_five_swords",               count = 1,  maxCount = nil, catalog = "DOCUMENT_CARD_FIVE_SWORDS", },
    { id = "card_four_swords",               count = 1,  maxCount = nil, catalog = "DOCUMENT_CARD_FOUR_SWORDS", },
    { id = "card_king_swords",               count = 1,  maxCount = nil, catalog = "DOCUMENT_CARD_KING_SWORDS", },
    { id = "card_knight_swords",             count = 1,  maxCount = nil, catalog = "DOCUMENT_CARD_KNIGHT_SWORDS", },
    { id = "card_nine_swords",               count = 1,  maxCount = nil, catalog = "DOCUMENT_CARD_NINE_SWORDS", },
    { id = "card_page_swords",               count = 1,  maxCount = nil, catalog = "DOCUMENT_CARD_PAGE_SWORDS", },
    { id = "card_queen_swords",              count = 1,  maxCount = nil, catalog = "DOCUMENT_CARD_QUEEN_SWORDS", },
    { id = "card_seven_swords",              count = 1,  maxCount = nil, catalog = "DOCUMENT_CARD_SEVEN_SWORDS", },
    { id = "card_six_swords",                count = 1,  maxCount = nil, catalog = "DOCUMENT_CARD_SIX_SWORDS", },
    { id = "card_ten_swords",                count = 1,  maxCount = nil, catalog = "DOCUMENT_CARD_TEN_SWORDS", },
    { id = "card_three_swords",              count = 1,  maxCount = nil, catalog = "DOCUMENT_CARD_THREE_SWORDS", },
    { id = "card_two_swords",                count = 1,  maxCount = nil, catalog = "DOCUMENT_CARD_TWO_SWORDS", },
}

-- Categories
-- This determines what categories are visible in the UI
-- TODO: Triggers for enabling/disabling categories like horse/wagon?

Config.categories = {
    { id = "recent",      recent = true,  texture = "satchel_nav_all",         titleHash = 0x504364F1,     emptyLabel = nil, emptyLabelHash = 0x504364F1,     emptyDescription = nil, emptyDescriptionHash = 0x4E6F9F15,          tags = {} },
    { id = "provisions",  recent = false, texture = "satchel_nav_provisions",  titleHash = 0x3B1DCCD8,     emptyLabel = nil, emptyLabelHash = 0x3B1DCCD8,     emptyDescription = nil, emptyDescriptionHash = 0x058002A1,          tags = { "CI_TAG_CATEGORY_PROVISION" } },
    { id = "tonics",      recent = false, texture = "satchel_nav_remedies",    titleHash = 0x855B3FAE,     emptyLabel = nil, emptyLabelHash = 0x855B3FAE,     emptyDescription = nil, emptyDescriptionHash = 0x176ABFC5,          tags = { "CI_TAG_CATEGORY_REMEDY" } },
    { id = "ingredients", recent = false, texture = "satchel_nav_ingredients", titleHash = 0x3268E974,     emptyLabel = nil, emptyLabelHash = 0x3268E974,     emptyDescription = nil, emptyDescriptionHash = 0x5A0CC2DE,          tags = { "CI_TAG_CATEGORY_INGREDIENT" } },
    { id = "materials",   recent = false, texture = "satchel_nav_materials",   titleHash = 0xEB0408D2,     emptyLabel = nil, emptyLabelHash = 0xEB0408D2,     emptyDescription = nil, emptyDescriptionHash = 0x9AF912F2,          tags = { "CI_TAG_CATEGORY_MATERIAL", "CI_TAG_CATEGORY_HORSE_CARGO" } },
    { id = "kit",         recent = false, texture = "satchel_nav_kit",         titleHash = 0x7A0D8994,     emptyLabel = nil, emptyLabelHash = 0x7A0D8994,     emptyDescription = nil, emptyDescriptionHash = 0xA1DF90FC,          tags = { "CI_TAG_CATEGORY_KIT" } },
    { id = "valuables",   recent = false, texture = "satchel_nav_valuables",   titleHash = 0xFA827B50,     emptyLabel = nil, emptyLabelHash = 0xFA827B50,     emptyDescription = nil, emptyDescriptionHash = 0x3A9E6C4A,          tags = { "CI_TAG_CATEGORY_VALUABLE" } },
    { id = "documents",   recent = false, texture = "satchel_nav_documents",   titleHash = 0xFDD0A576,     emptyLabel = nil, emptyLabelHash = 0xFDD0A576,     emptyDescription = nil, emptyDescriptionHash = 0xE7055490,          tags = { "CI_TAG_CATEGORY_DOCUMENT" } },
    -- { id = "horse",       recent = false, texture = "satchel_nav_horse",       titleHash = 0x0FA40D69,     emptyLabel = nil, emptyLabelHash = 0x0FA40D69,     emptyDescription = nil, emptyDescriptionHash = 0xB8507365,          tags = { "CI_TAG_CATEGORY_HORSE_CARGO" } },
    -- { id = "wagon",       recent = false, texture = "satchel_nav_horse",       titleHash = "HWAGON_TITLE", emptyLabel = nil, emptyLabelHash = "HWAGON_TITLE", emptyDescription = nil, emptyDescriptionHash = "HWAGON_TITLE_DESC", tags = { "CI_TAG_CATEGORY_HORSE_CARGO" } },
    -- { id = "donations",   recent = false, texture = "satchel_nav_donate",      titleHash = 0x61FAAEA1,     emptyLabel = nil, emptyLabelHash = 0x61FAAEA1,     emptyDescription = nil, emptyDescriptionHash = 0x0552C91D,          tags = {} },
    -- { id = "send",        recent = false, texture = "satchel_nav_send",        titleHash = 0xBFC37FEE,     emptyLabel = nil, emptyLabelHash = 0xBFC37FEE,     emptyDescription = nil, emptyDescriptionHash = 0x3BB66DA9,          tags = {} },
    -- { id = "sell",        recent = false, texture = "satchel_nav_sell",        titleHash = 0xF6614C1F,     emptyLabel = nil, emptyLabelHash = 0xF6614C1F,     emptyDescription = nil, emptyDescriptionHash = 0x11352E60,          tags = {} },
}

-- Folders
-- This determines what folders are available in the UI

Config.folders = {
    -- General folders
    { id = "books",                               category = "documents",    titleHash = "CI_TAG_FOLDER_BOOKS",                               label = nil, labelHash = "CI_TAG_FOLDER_BOOKS",                               description = nil, descriptionHash = "CI_TAG_FOLDER_BOOKS_DESC",                               txd = "inventory_items",    texture = "folder_books",                                  tags = { "CI_TAG_FOLDER_BOOKS" } },
    { id = "bounty_posters",                      category = "documents",    titleHash = "CI_TAG_FOLDER_BOUNTY_POSTERS",                      label = nil, labelHash = "CI_TAG_FOLDER_BOUNTY_POSTERS",                      description = nil, descriptionHash = "CI_TAG_FOLDER_BOUNTY_POSTERS_DESC",                      txd = "inventory_items",    texture = "folder_bounty_posters",                         tags = { "CI_TAG_FOLDER_BOUNTY_POSTERS" } },
    { id = "business_cards",                      category = "documents",    titleHash = "CI_TAG_FOLDER_BUSINESS_CARDS",                      label = nil, labelHash = "CI_TAG_FOLDER_BUSINESS_CARDS",                      description = nil, descriptionHash = "CI_TAG_FOLDER_BUSINESS_CARDS_DESC",                      txd = "inventory_items",    texture = "folder_business_cards",                         tags = { "CI_TAG_FOLDER_BUSINESS_CARDS" } },
    { id = "collector_maps",                      category = "documents",    titleHash = "CI_TAG_FOLDER_COLLECTOR_MAPS",                      label = nil, labelHash = "CI_TAG_FOLDER_COLLECTOR_MAPS",                      description = nil, descriptionHash = "CI_TAG_FOLDER_COLLECTOR_MAPS_DESC",                      txd = "inventory_items",    texture = "folder_maps",                                   tags = { "CI_TAG_FOLDER_COLLECTOR_MAPS" } },
    { id = "dinosaur_notes",                      category = "documents",    titleHash = "CI_TAG_FOLDER_DINOSAUR_NOTES",                      label = nil, labelHash = "CI_TAG_FOLDER_DINOSAUR_NOTES",                      description = nil, descriptionHash = "CI_TAG_FOLDER_DINOSAUR_NOTES_DESC",                      txd = "inventory_items",    texture = "folder_dinosaur_notes",                         tags = { "CI_TAG_FOLDER_DINOSAUR_NOTES" } },
    { id = "drawings",                            category = "documents",    titleHash = "CI_TAG_FOLDER_DRAWINGS",                            label = nil, labelHash = "CI_TAG_FOLDER_DRAWINGS",                            description = nil, descriptionHash = "CI_TAG_FOLDER_DRAWINGS_DESC",                            txd = "inventory_items",    texture = "folder_drawings",                               tags = { "CI_TAG_FOLDER_DRAWINGS" } },
    { id = "handbills",                           category = "documents",    titleHash = "CI_TAG_FOLDER_HANDBILLS",                           label = nil, labelHash = "CI_TAG_FOLDER_HANDBILLS",                           description = nil, descriptionHash = "CI_TAG_FOLDER_HANDBILLS_DESC",                           txd = "inventory_items",    texture = "folder_handbills",                              tags = { "CI_TAG_FOLDER_HANDBILLS" } },
    { id = "invitations",                         category = "documents",    titleHash = "CI_TAG_FOLDER_INVITATIONS",                         label = nil, labelHash = "CI_TAG_FOLDER_INVITATIONS",                         description = nil, descriptionHash = "CI_TAG_FOLDER_INVITATIONS_DESC",                         txd = "inventory_items",    texture = "folder_invitations",                            tags = { "CI_TAG_FOLDER_INVITATIONS" } },
    { id = "kit_keepsakes",                       category = "documents",    titleHash = "CI_TAG_FOLDER_KIT_KEEPSAKES",                       label = nil, labelHash = "CI_TAG_FOLDER_KIT_KEEPSAKES",                       description = nil, descriptionHash = "CI_TAG_FOLDER_KIT_KEEPSAKES_DESC",                       txd = "inventory_items",    texture = "folder_kit_keepsakes",                          tags = { "CI_TAG_FOLDER_KIT_KEEPSAKES" } },
    { id = "kit_keychain",                        category = "documents",    titleHash = "CI_TAG_FOLDER_KIT_KEYCHAIN",                        label = nil, labelHash = "CI_TAG_FOLDER_KIT_KEYCHAIN",                        description = nil, descriptionHash = "CI_TAG_FOLDER_KIT_KEYCHAIN_DESC",                        txd = "inventory_items",    texture = "folder_kit_keychain",                           tags = { "CI_TAG_FOLDER_KIT_KEYCHAIN" } },
    { id = "kit_watches",                         category = "documents",    titleHash = "CI_TAG_FOLDER_KIT_WATCHES",                         label = nil, labelHash = "CI_TAG_FOLDER_KIT_WATCHES",                         description = nil, descriptionHash = "CI_TAG_FOLDER_KIT_WATCHES_DESC",                         txd = "inventory_items",    texture = "provision_folder_watches",                      tags = { "CI_TAG_FOLDER_KIT_WATCHES" } },
    { id = "letters",                             category = "documents",    titleHash = "CI_TAG_FOLDER_LETTERS",                             label = nil, labelHash = "CI_TAG_FOLDER_LETTERS",                             description = nil, descriptionHash = "CI_TAG_FOLDER_LETTERS_DESC",                             txd = "inventory_items",    texture = "folder_letters",                                tags = { "CI_TAG_FOLDER_LETTERS" } },
    { id = "maps",                                category = "documents",    titleHash = "CI_TAG_FOLDER_MAPS",                                label = nil, labelHash = "CI_TAG_FOLDER_MAPS",                                description = nil, descriptionHash = "CI_TAG_FOLDER_MAPS_DESC",                                txd = "inventory_items",    texture = "folder_maps",                                   tags = { "CI_TAG_FOLDER_MAPS" } },
    { id = "masks",                               category = "documents",    titleHash = "CI_TAG_FOLDER_MASKS",                               label = nil, labelHash = "CI_TAG_FOLDER_MASKS",                               description = nil, descriptionHash = "CI_TAG_FOLDER_MASKS_DESC",                               txd = "inventory_items",    texture = "kit_bandana",                                   tags = { "CI_TAG_FOLDER_MASKS" } },
    { id = "newspaper_scraps",                    category = "documents",    titleHash = "CI_TAG_FOLDER_NEWSPAPER_SCRAPS",                    label = nil, labelHash = "CI_TAG_FOLDER_NEWSPAPER_SCRAPS",                    description = nil, descriptionHash = "CI_TAG_FOLDER_NEWSPAPER_SCRAPS_DESC",                    txd = "inventory_items",    texture = "folder_newspaper_scraps",                       tags = { "CI_TAG_FOLDER_NEWSPAPER_SCRAPS" } },
    { id = "newspapers",                          category = "documents",    titleHash = "CI_TAG_FOLDER_NEWSPAPERS",                          label = nil, labelHash = "CI_TAG_FOLDER_NEWSPAPERS",                          description = nil, descriptionHash = "CI_TAG_FOLDER_NEWSPAPERS_DESC",                          txd = "inventory_items",    texture = "folder_newspapers",                             tags = { "CI_TAG_FOLDER_NEWSPAPERS" } },
    { id = "notes",                               category = "documents",    titleHash = "CI_TAG_FOLDER_NOTES",                               label = nil, labelHash = "CI_TAG_FOLDER_NOTES",                               description = nil, descriptionHash = "CI_TAG_FOLDER_NOTES_DESC",                               txd = "inventory_items",    texture = "folder_notes",                                  tags = { "CI_TAG_FOLDER_NOTES" } },
    { id = "photographs",                         category = "documents",    titleHash = "CI_TAG_FOLDER_PHOTOGRAPHS",                         label = nil, labelHash = "CI_TAG_FOLDER_PHOTOGRAPHS",                         description = nil, descriptionHash = "CI_TAG_FOLDER_PHOTOGRAPHS_DESC",                         txd = "inventory_items",    texture = "folder_photographs",                            tags = { "CI_TAG_FOLDER_PHOTOGRAPHS" } },
    { id = "rock_carving_notes",                  category = "documents",    titleHash = "CI_TAG_FOLDER_ROCK_CARVING_NOTES",                  label = nil, labelHash = "CI_TAG_FOLDER_ROCK_CARVING_NOTES",                  description = nil, descriptionHash = "CI_TAG_FOLDER_ROCK_CARVING_NOTES_DESC",                  txd = "inventory_items",    texture = "folder_maps",                                   tags = { "CI_TAG_FOLDER_ROCK_CARVING_NOTES" } },
    { id = "taxidermist_orders",                  category = "documents",    titleHash = "CI_TAG_FOLDER_TAXIDERMIST_ORDERS",                  label = nil, labelHash = "CI_TAG_FOLDER_TAXIDERMIST_ORDERS",                  description = nil, descriptionHash = "CI_TAG_FOLDER_TAXIDERMIST_ORDERS_DESC",                  txd = "inventory_items",    texture = "folder_taxidermist_orders",                     tags = { "CI_TAG_FOLDER_TAXIDERMIST_ORDERS" } },
    { id = "telegrams",                           category = "documents",    titleHash = "CI_TAG_MISSION_DROP_ENABLED",                       label = nil, labelHash = "CI_TAG_MISSION_DROP_ENABLED",                       description = nil, descriptionHash = "CI_TAG_MISSION_DROP_ENABLED_DESC",                       txd = "inventory_items_mp", texture = "folder_letters_cloud",                          tags = { "CI_TAG_MISSION_DROP_ENABLED" } },
    { id = "treasure_maps",                       category = "documents",    titleHash = "CI_TAG_FOLDER_TREASURE_MAPS",                       label = nil, labelHash = "CI_TAG_FOLDER_TREASURE_MAPS",                       description = nil, descriptionHash = "CI_TAG_FOLDER_TREASURE_MAPS_DESC",                       txd = "inventory_items",    texture = "folder_treasure_maps",                          tags = { "CI_TAG_FOLDER_TREASURE_MAPS" } },
    { id = "watch",                               category = "documents",    titleHash = "CI_TAG_FOLDER_WATCH",                               label = nil, labelHash = "CI_TAG_FOLDER_WATCH",                               description = nil, descriptionHash = "CI_TAG_FOLDER_WATCH_DESC",                               txd = "inventory_items",    texture = "kit_player_pocketwatch",                        tags = { "CI_TAG_FOLDER_WATCH" } },

    -- Cooked Meat folders
    { id = "big_game",                            category = "provisions",   titleHash = "CI_TAG_FOLDER_BIG_GAME",                            label = nil, labelHash = "CI_TAG_FOLDER_BIG_GAME",                            description = nil, descriptionHash = "CI_TAG_FOLDER_BIG_GAME_DESC",                            txd = "inventory_items",    texture = "consumable_meat_big_game_cooked",               tags = { "CI_TAG_FOLDER_BIG_GAME" } },
    { id = "crustacean",                          category = "provisions",   titleHash = "CI_TAG_FOLDER_CRUSTACEAN",                          label = nil, labelHash = "CI_TAG_FOLDER_CRUSTACEAN",                          description = nil, descriptionHash = "CI_TAG_FOLDER_CRUSTACEAN_DESC",                          txd = "inventory_items",    texture = "consumable_meat_crustacean_cooked",             tags = { "CI_TAG_FOLDER_CRUSTACEAN" } },
    { id = "exotic_bird",                         category = "provisions",   titleHash = "CI_TAG_FOLDER_EXOTIC_BIRD",                         label = nil, labelHash = "CI_TAG_FOLDER_EXOTIC_BIRD",                         description = nil, descriptionHash = "CI_TAG_FOLDER_EXOTIC_BIRD_DESC",                         txd = "inventory_items",    texture = "consumable_meat_exotic_bird_cooked",            tags = { "CI_TAG_FOLDER_EXOTIC_BIRD" } },
    { id = "flakey_fish",                         category = "provisions",   titleHash = "CI_TAG_FOLDER_FLAKEY_FISH",                         label = nil, labelHash = "CI_TAG_FOLDER_FLAKEY_FISH",                         description = nil, descriptionHash = "CI_TAG_FOLDER_FLAKEY_FISH_DESC",                         txd = "inventory_items",    texture = "consumable_meat_flakey_fish_cooked",            tags = { "CI_TAG_FOLDER_FLAKEY_FISH" } },
    { id = "game",                                category = "provisions",   titleHash = "CI_TAG_FOLDER_GAME",                                label = nil, labelHash = "CI_TAG_FOLDER_GAME",                                description = nil, descriptionHash = "CI_TAG_FOLDER_GAME_DESC",                                txd = "inventory_items",    texture = "consumable_meat_game_cooked",                   tags = { "CI_TAG_FOLDER_GAME" } },
    { id = "gamey_bird",                          category = "provisions",   titleHash = "CI_TAG_FOLDER_GAMEY_BIRD",                          label = nil, labelHash = "CI_TAG_FOLDER_GAMEY_BIRD",                          description = nil, descriptionHash = "CI_TAG_FOLDER_GAMEY_BIRD_DESC",                          txd = "inventory_items",    texture = "consumable_meat_gamey_bird_cooked",             tags = { "CI_TAG_FOLDER_GAMEY_BIRD" } },
    { id = "gristly_mutton",                      category = "provisions",   titleHash = "CI_TAG_FOLDER_GRISTLY_MUTTON",                      label = nil, labelHash = "CI_TAG_FOLDER_GRISTLY_MUTTON",                      description = nil, descriptionHash = "CI_TAG_FOLDER_GRISTLY_MUTTON_DESC",                      txd = "inventory_items",    texture = "consumable_meat_gristly_mutton_cooked",         tags = { "CI_TAG_FOLDER_GRISTLY_MUTTON" } },
    { id = "gritty_fish",                         category = "provisions",   titleHash = "CI_TAG_FOLDER_GRITTY_FISH",                         label = nil, labelHash = "CI_TAG_FOLDER_GRITTY_FISH",                         description = nil, descriptionHash = "CI_TAG_FOLDER_GRITTY_FISH_DESC",                         txd = "inventory_items",    texture = "consumable_meat_gritty_fish_cooked",            tags = { "CI_TAG_FOLDER_GRITTY_FISH" } },
    { id = "herptile_meat",                       category = "provisions",   titleHash = "CI_TAG_FOLDER_HERPTILE_MEAT",                       label = nil, labelHash = "CI_TAG_FOLDER_HERPTILE_MEAT",                       description = nil, descriptionHash = "CI_TAG_FOLDER_HERPTILE_MEAT_DESC",                       txd = "inventory_items",    texture = "consumable_meat_herptile_cooked",               tags = { "CI_TAG_FOLDER_HERPTILE_MEAT" } },
    { id = "mature_venison",                      category = "provisions",   titleHash = "CI_TAG_FOLDER_MATURE_VENISON",                      label = nil, labelHash = "CI_TAG_FOLDER_MATURE_VENISON",                      description = nil, descriptionHash = "CI_TAG_FOLDER_MATURE_VENISON_DESC",                      txd = "inventory_items",    texture = "consumable_meat_mature_venison_cooked",         tags = { "CI_TAG_FOLDER_MATURE_VENISON" } },
    { id = "plump_bird",                          category = "provisions",   titleHash = "CI_TAG_FOLDER_PLUMP_BIRD",                          label = nil, labelHash = "CI_TAG_FOLDER_PLUMP_BIRD",                          description = nil, descriptionHash = "CI_TAG_FOLDER_PLUMP_BIRD_DESC",                          txd = "inventory_items",    texture = "consumable_meat_plump_bird_cooked",             tags = { "CI_TAG_FOLDER_PLUMP_BIRD" } },
    { id = "prime_beef",                          category = "provisions",   titleHash = "CI_TAG_FOLDER_PRIME_BEEF",                          label = nil, labelHash = "CI_TAG_FOLDER_PRIME_BEEF",                          description = nil, descriptionHash = "CI_TAG_FOLDER_PRIME_BEEF_DESC",                          txd = "inventory_items",    texture = "consumable_meat_prime_beef_cooked",             tags = { "CI_TAG_FOLDER_PRIME_BEEF" } },
    { id = "stringy_meat",                        category = "provisions",   titleHash = "CI_TAG_FOLDER_STRINGY_MEAT",                        label = nil, labelHash = "CI_TAG_FOLDER_STRINGY_MEAT",                        description = nil, descriptionHash = "CI_TAG_FOLDER_STRINGY_MEAT_DESC",                        txd = "inventory_items",    texture = "consumable_meat_stringy_cooked",                tags = { "CI_TAG_FOLDER_STRINGY_MEAT" } },
    { id = "succulent_fish",                      category = "provisions",   titleHash = "CI_TAG_FOLDER_SUCCULENT_FISH",                      label = nil, labelHash = "CI_TAG_FOLDER_SUCCULENT_FISH",                      description = nil, descriptionHash = "CI_TAG_FOLDER_SUCCULENT_FISH_DESC",                      txd = "inventory_items",    texture = "consumable_meat_succulent_fish_cooked",         tags = { "CI_TAG_FOLDER_SUCCULENT_FISH" } },
    { id = "tender_pork",                         category = "provisions",   titleHash = "CI_TAG_FOLDER_TENDER_PORK",                         label = nil, labelHash = "CI_TAG_FOLDER_TENDER_PORK",                         description = nil, descriptionHash = "CI_TAG_FOLDER_TENDER_PORK_DESC",                         txd = "inventory_items",    texture = "consumable_meat_tender_pork_cooked",            tags = { "CI_TAG_FOLDER_TENDER_PORK" } },

    -- Pamphlet folders
    { id = "animal_pamphlets",                    category = "documents",    titleHash = "CI_TAG_FOLDER_ANIMAL_PAMPHLETS",                    label = nil, labelHash = "CI_TAG_FOLDER_ANIMAL_PAMPHLETS",                    description = nil, descriptionHash = "CI_TAG_FOLDER_ANIMAL_PAMPHLETS_DESC",                    txd = "inventory_items_mp", texture = "folder_animal_pamphlet",                        tags = { "CI_TAG_FOLDER_ANIMAL_PAMPHLETS" } },
    { id = "moonshine_recipes",                   category = "documents",    titleHash = "CI_TAG_FOLDER_MOONSHINE_RECIPES",                   label = nil, labelHash = "CI_TAG_FOLDER_MOONSHINE_RECIPES",                   description = nil, descriptionHash = "CI_TAG_FOLDER_MOONSHINE_RECIPES_DESC",                   txd = "inventory_items_mp", texture = "folder_moonshine_recipes",                      tags = { "CI_TAG_FOLDER_MOONSHINE_RECIPES" } },
    { id = "recipe_pamphlets",                    category = "documents",    titleHash = "CI_TAG_FOLDER_RECIPE_PAMPHLETS",                    label = nil, labelHash = "CI_TAG_FOLDER_RECIPE_PAMPHLETS",                    description = nil, descriptionHash = "CI_TAG_FOLDER_RECIPE_PAMPHLETS_DESC",                    txd = "inventory_items",    texture = "folder_recipe_pamphlets",                       tags = { "CI_TAG_FOLDER_RECIPE_PAMPHLETS" } },
    { id = "satchel_pamphlets",                   category = "documents",    titleHash = "CI_TAG_FOLDER_SATCHEL_PAMPHLETS",                   label = nil, labelHash = "CI_TAG_FOLDER_SATCHEL_PAMPHLETS",                   description = nil, descriptionHash = "CI_TAG_FOLDER_SATCHEL_PAMPHLETS_DESC",                   txd = "inventory_items_mp", texture = "folder_satchel_upgrades",                       tags = { "CI_TAG_FOLDER_SATCHEL_PAMPHLETS" } },
    { id = "skill_pamphlets",                     category = "documents",    titleHash = "CI_TAG_FOLDER_SKILL_PAMPHLETS",                     label = nil, labelHash = "CI_TAG_FOLDER_SKILL_PAMPHLETS",                     description = nil, descriptionHash = "CI_TAG_FOLDER_SKILL_PAMPHLETS_DESC",                     txd = "inventory_items_mp", texture = "folder_skill_pages",                            tags = { "CI_TAG_FOLDER_SKILL_PAMPHLETS" } },

    -- Collectible folders
    { id = "collector_coins",                     category = "valuables",    titleHash = "CI_TAG_FOLDER_COLLECTOR_COINS",                     label = nil, labelHash = "CI_TAG_FOLDER_COLLECTOR_COINS",                     description = nil, descriptionHash = "CI_TAG_FOLDER_COLLECTOR_COINS_DESC",                     txd = "inventory_items_mp", texture = "provision_coin_set",                            tags = { "CI_TAG_FOLDER_COLLECTOR_COINS" } },
    { id = "collector_eggs",                      category = "ingredients",  titleHash = "CI_TAG_FOLDER_COLLECTOR_EGGS",                      label = nil, labelHash = "CI_TAG_FOLDER_COLLECTOR_EGGS",                      description = nil, descriptionHash = "CI_TAG_FOLDER_COLLECTOR_EGGS_DESC",                      txd = "inventory_items_mp", texture = "provision_egg_set",                             tags = { "CI_TAG_FOLDER_COLLECTOR_EGGS" } },
    { id = "collector_bottles",                   category = "tonics",       titleHash = "CI_TAG_FOLDER_COLLECTOR_BOTTLES",                   label = nil, labelHash = "CI_TAG_FOLDER_COLLECTOR_BOTTLES",                   description = nil, descriptionHash = "CI_TAG_FOLDER_COLLECTOR_BOTTLES_DESC",                   txd = "inventory_items_mp", texture = "consumable_whiskey_set",                        tags = { "CI_TAG_FOLDER_COLLECTOR_BOTTLES" } },
    { id = "collector_arrowheads",                category = "valuables",    titleHash = "CI_TAG_FOLDER_COLLECTOR_ARROWHEADS",                label = nil, labelHash = "CI_TAG_FOLDER_COLLECTOR_ARROWHEADS",                description = nil, descriptionHash = "CI_TAG_FOLDER_COLLECTOR_ARROWHEADS_DESC",                txd = "inventory_items_mp", texture = "provision_arrowhead_set",                       tags = { "CI_TAG_FOLDER_COLLECTOR_ARROWHEADS" } },
    { id = "collector_heirlooms",                 category = "valuables",    titleHash = "CI_TAG_FOLDER_COLLECTOR_HEIRLOOMS",                 label = nil, labelHash = "CI_TAG_FOLDER_COLLECTOR_HEIRLOOMS",                 description = nil, descriptionHash = "CI_TAG_FOLDER_COLLECTOR_HEIRLOOMS_DESC",                 txd = "inventory_items_mp", texture = "provision_hrlm_set",                            tags = { "CI_TAG_FOLDER_COLLECTOR_HEIRLOOMS" } },
    { id = "collector_wildflowers",               category = "ingredients",  titleHash = "CI_TAG_FOLDER_COLLECTOR_WILDFLOWERS",               label = nil, labelHash = "CI_TAG_FOLDER_COLLECTOR_WILDFLOWERS",               description = nil, descriptionHash = "CI_TAG_FOLDER_COLLECTOR_WILDFLOWERS_DESC",               txd = "inventory_items_mp", texture = "provision_wldflwr_set",                         tags = { "CI_TAG_FOLDER_COLLECTOR_WILDFLOWERS" } },
    { id = "collector_bracelets",                 category = "valuables",    titleHash = "CI_TAG_FOLDER_COLLECTOR_BRACELETS",                 label = nil, labelHash = "CI_TAG_FOLDER_COLLECTOR_BRACELETS",                 description = nil, descriptionHash = "CI_TAG_FOLDER_COLLECTOR_BRACELETS_DESC",                 txd = "inventory_items_mp", texture = "provision_jewelry_bracelet_set",                tags = { "CI_TAG_FOLDER_COLLECTOR_BRACELETS" } },
    { id = "collector_earrings",                  category = "valuables",    titleHash = "CI_TAG_FOLDER_COLLECTOR_EARRINGS",                  label = nil, labelHash = "CI_TAG_FOLDER_COLLECTOR_EARRINGS",                  description = nil, descriptionHash = "CI_TAG_FOLDER_COLLECTOR_EARRINGS_DESC",                  txd = "inventory_items_mp", texture = "provision_jewelry_earring_set",                 tags = { "CI_TAG_FOLDER_COLLECTOR_EARRINGS" } },
    { id = "collector_necklaces",                 category = "valuables",    titleHash = "CI_TAG_FOLDER_COLLECTOR_NECKLACES",                 label = nil, labelHash = "CI_TAG_FOLDER_COLLECTOR_NECKLACES",                 description = nil, descriptionHash = "CI_TAG_FOLDER_COLLECTOR_NECKLACES_DESC",                 txd = "inventory_items_mp", texture = "provision_jewelry_necklace_set",                tags = { "CI_TAG_FOLDER_COLLECTOR_NECKLACES" } },
    { id = "collector_rings",                     category = "valuables",    titleHash = "CI_TAG_FOLDER_COLLECTOR_RINGS",                     label = nil, labelHash = "CI_TAG_FOLDER_COLLECTOR_RINGS",                     description = nil, descriptionHash = "CI_TAG_FOLDER_COLLECTOR_RINGS_DESC",                     txd = "inventory_items_mp", texture = "provision_jewelry_ring_set",                    tags = { "CI_TAG_FOLDER_COLLECTOR_RINGS" } },
    { id = "collector_card_cups",                 category = "documents",    titleHash = "CI_TAG_FOLDER_COLLECTOR_CARD_CUPS",                 label = nil, labelHash = "CI_TAG_FOLDER_COLLECTOR_CARD_CUPS",                 description = nil, descriptionHash = "CI_TAG_FOLDER_COLLECTOR_CARD_CUPS_DESC",                 txd = "inventory_items_mp", texture = "document_card_cups_set",                        tags = { "CI_TAG_FOLDER_COLLECTOR_CARD_CUPS" } },
    { id = "collector_card_pentacles",            category = "documents",    titleHash = "CI_TAG_FOLDER_COLLECTOR_CARD_PENTACLES",            label = nil, labelHash = "CI_TAG_FOLDER_COLLECTOR_CARD_PENTACLES",            description = nil, descriptionHash = "CI_TAG_FOLDER_COLLECTOR_CARD_PENTACLES_DESC",            txd = "inventory_items_mp", texture = "document_card_pentacles_set",                   tags = { "CI_TAG_FOLDER_COLLECTOR_CARD_PENTACLES" } },
    { id = "collector_card_swords",               category = "documents",    titleHash = "CI_TAG_FOLDER_COLLECTOR_CARD_SWORDS",               label = nil, labelHash = "CI_TAG_FOLDER_COLLECTOR_CARD_SWORDS",               description = nil, descriptionHash = "CI_TAG_FOLDER_COLLECTOR_CARD_SWORDS_DESC",               txd = "inventory_items_mp", texture = "document_card_swords_set",                      tags = { "CI_TAG_FOLDER_COLLECTOR_CARD_SWORDS" } },
    { id = "collector_card_wands",                category = "documents",    titleHash = "CI_TAG_FOLDER_COLLECTOR_CARD_WANDS",                label = nil, labelHash = "CI_TAG_FOLDER_COLLECTOR_CARD_WANDS",                description = nil, descriptionHash = "CI_TAG_FOLDER_COLLECTOR_CARD_WANDS_DESC",                txd = "inventory_items_mp", texture = "document_card_wands_set",                       tags = { "CI_TAG_FOLDER_COLLECTOR_CARD_WANDS" } },
    { id = "collector_fossils_common",            category = "valuables",    titleHash = "CI_TAG_FOLDER_COLLECTOR_FOSSILS_COMMON",            label = nil, labelHash = "CI_TAG_FOLDER_COLLECTOR_FOSSILS_COMMON",            description = nil, descriptionHash = "CI_TAG_FOLDER_COLLECTOR_FOSSILS_COMMON_DESC",            txd = "inventory_items_mp", texture = "provision_fossil_set_01_common",                tags = { "CI_TAG_FOLDER_COLLECTOR_FOSSILS_COMMON" } },
    { id = "collector_fossils_rare",              category = "valuables",    titleHash = "CI_TAG_FOLDER_COLLECTOR_FOSSILS_RARE",              label = nil, labelHash = "CI_TAG_FOLDER_COLLECTOR_FOSSILS_RARE",              description = nil, descriptionHash = "CI_TAG_FOLDER_COLLECTOR_FOSSILS_RARE_DESC",              txd = "inventory_items_mp", texture = "provision_fossil_set_03_rare",                  tags = { "CI_TAG_FOLDER_COLLECTOR_FOSSILS_RARE" } },
    { id = "collector_fossils_uncommon",          category = "valuables",    titleHash = "CI_TAG_FOLDER_COLLECTOR_FOSSILS_UNCOMMON",          label = nil, labelHash = "CI_TAG_FOLDER_COLLECTOR_FOSSILS_UNCOMMON",          description = nil, descriptionHash = "CI_TAG_FOLDER_COLLECTOR_FOSSILS_UNCOMMON_DESC",          txd = "inventory_items_mp", texture = "provision_fossil_set_02_uncommon",              tags = { "CI_TAG_FOLDER_COLLECTOR_FOSSILS_UNCOMMON" } },

    -- Feather folders
    { id = "plumes",                              category = "materials",    titleHash = "CI_TAG_FOLDER_PLUMES",                              label = nil, labelHash = "CI_TAG_FOLDER_PLUMES",                              description = nil, descriptionHash = "CI_TAG_FOLDER_PLUMES_DESC",                              txd = "satchel_textures",   texture = "feathers_plume",                                tags = { "CI_TAG_FOLDER_PLUMES" } },
    { id = "collectible_feathers",                category = "materials",    titleHash = "CI_TAG_FOLDER_COLLECTIBLE_FEATHERS",                label = nil, labelHash = "CI_TAG_FOLDER_COLLECTIBLE_FEATHERS",                description = nil, descriptionHash = "CI_TAG_FOLDER_COLLECTIBLE_FEATHERS_DESC",                txd = "satchel_textures",   texture = "provision_bird_feather_flight",                 tags = { "CI_TAG_FOLDER_COLLECTIBLE_FEATHERS" } },
    { id = "craft_feathers",                      category = "materials",    titleHash = "CI_TAG_FOLDER_CRAFT_FEATHERS",                      label = nil, labelHash = "CI_TAG_FOLDER_CRAFT_FEATHERS",                      description = nil, descriptionHash = "CI_TAG_FOLDER_CRAFT_FEATHERS_DESC",                      txd = "satchel_textures",   texture = "feathers_crafting",                             tags = { "CI_TAG_FOLDER_CRAFT_FEATHERS" } },

    -- Cigarette Card folders
    { id = "cig_card_act_set",                    category = "documents",    titleHash = "CI_TAG_FOLDER_CIG_CARD_ACT_SET",                    label = nil, labelHash = "CI_TAG_FOLDER_CIG_CARD_ACT_SET",                    description = nil, descriptionHash = "CI_TAG_FOLDER_CIG_CARD_ACT_SET_DESC",                    txd = "inventory_items",    texture = "folder_cig_card_act_set",                       tags = { "CI_TAG_FOLDER_CIG_CARD_ACT_SET" } },
    { id = "cig_card_aml_set",                    category = "documents",    titleHash = "CI_TAG_FOLDER_CIG_CARD_AML_SET",                    label = nil, labelHash = "CI_TAG_FOLDER_CIG_CARD_AML_SET",                    description = nil, descriptionHash = "CI_TAG_FOLDER_CIG_CARD_AML_SET_DESC",                    txd = "inventory_items",    texture = "folder_cig_card_aml_set",                       tags = { "CI_TAG_FOLDER_CIG_CARD_AML_SET" } },
    { id = "cig_card_art_set",                    category = "documents",    titleHash = "CI_TAG_FOLDER_CIG_CARD_ART_SET",                    label = nil, labelHash = "CI_TAG_FOLDER_CIG_CARD_ART_SET",                    description = nil, descriptionHash = "CI_TAG_FOLDER_CIG_CARD_ART_SET_DESC",                    txd = "inventory_items",    texture = "folder_cig_card_art_set",                       tags = { "CI_TAG_FOLDER_CIG_CARD_ART_SET" } },
    { id = "cig_card_grl_set",                    category = "documents",    titleHash = "CI_TAG_FOLDER_CIG_CARD_GRL_SET",                    label = nil, labelHash = "CI_TAG_FOLDER_CIG_CARD_GRL_SET",                    description = nil, descriptionHash = "CI_TAG_FOLDER_CIG_CARD_GRL_SET_DESC",                    txd = "inventory_items",    texture = "folder_cig_card_grl_set",                       tags = { "CI_TAG_FOLDER_CIG_CARD_GRL_SET" } },
    { id = "cig_card_gun_set",                    category = "documents",    titleHash = "CI_TAG_FOLDER_CIG_CARD_GUN_SET",                    label = nil, labelHash = "CI_TAG_FOLDER_CIG_CARD_GUN_SET",                    description = nil, descriptionHash = "CI_TAG_FOLDER_CIG_CARD_GUN_SET_DESC",                    txd = "inventory_items",    texture = "folder_cig_card_gun_set",                       tags = { "CI_TAG_FOLDER_CIG_CARD_GUN_SET" } },
    { id = "cig_card_hor_set",                    category = "documents",    titleHash = "CI_TAG_FOLDER_CIG_CARD_HOR_SET",                    label = nil, labelHash = "CI_TAG_FOLDER_CIG_CARD_HOR_SET",                    description = nil, descriptionHash = "CI_TAG_FOLDER_CIG_CARD_HOR_SET_DESC",                    txd = "inventory_items",    texture = "folder_cig_card_hor_set",                       tags = { "CI_TAG_FOLDER_CIG_CARD_HOR_SET" } },
    { id = "cig_card_inv_set",                    category = "documents",    titleHash = "CI_TAG_FOLDER_CIG_CARD_INV_SET",                    label = nil, labelHash = "CI_TAG_FOLDER_CIG_CARD_INV_SET",                    description = nil, descriptionHash = "CI_TAG_FOLDER_CIG_CARD_INV_SET_DESC",                    txd = "inventory_items",    texture = "folder_cig_card_inv_set",                       tags = { "CI_TAG_FOLDER_CIG_CARD_INV_SET" } },
    { id = "cig_card_lnd_set",                    category = "documents",    titleHash = "CI_TAG_FOLDER_CIG_CARD_LND_SET",                    label = nil, labelHash = "CI_TAG_FOLDER_CIG_CARD_LND_SET",                    description = nil, descriptionHash = "CI_TAG_FOLDER_CIG_CARD_LND_SET_DESC",                    txd = "inventory_items",    texture = "folder_cig_card_lnd_set",                       tags = { "CI_TAG_FOLDER_CIG_CARD_LND_SET" } },
    { id = "cig_card_pam_set",                    category = "documents",    titleHash = "CI_TAG_FOLDER_CIG_CARD_PAM_SET",                    label = nil, labelHash = "CI_TAG_FOLDER_CIG_CARD_PAM_SET",                    description = nil, descriptionHash = "CI_TAG_FOLDER_CIG_CARD_PAM_SET_DESC",                    txd = "inventory_items",    texture = "folder_cig_card_pam_set",                       tags = { "CI_TAG_FOLDER_CIG_CARD_PAM_SET" } },
    { id = "cig_card_plt_set",                    category = "documents",    titleHash = "CI_TAG_FOLDER_CIG_CARD_PLT_SET",                    label = nil, labelHash = "CI_TAG_FOLDER_CIG_CARD_PLT_SET",                    description = nil, descriptionHash = "CI_TAG_FOLDER_CIG_CARD_PLT_SET_DESC",                    txd = "inventory_items",    texture = "folder_cig_card_plt_set",                       tags = { "CI_TAG_FOLDER_CIG_CARD_PLT_SET" } },
    { id = "cig_card_spt_set",                    category = "documents",    titleHash = "CI_TAG_FOLDER_CIG_CARD_SPT_SET",                    label = nil, labelHash = "CI_TAG_FOLDER_CIG_CARD_SPT_SET",                    description = nil, descriptionHash = "CI_TAG_FOLDER_CIG_CARD_SPT_SET_DESC",                    txd = "inventory_items",    texture = "folder_cig_card_spt_set",                       tags = { "CI_TAG_FOLDER_CIG_CARD_SPT_SET" } },
    { id = "cig_card_veh_set",                    category = "documents",    titleHash = "CI_TAG_FOLDER_CIG_CARD_VEH_SET",                    label = nil, labelHash = "CI_TAG_FOLDER_CIG_CARD_VEH_SET",                    description = nil, descriptionHash = "CI_TAG_FOLDER_CIG_CARD_VEH_SET_DESC",                    txd = "inventory_items",    texture = "folder_cig_card_veh_set",                       tags = { "CI_TAG_FOLDER_CIG_CARD_VEH_SET" } },

    -- Animal Sample folders
    { id = "animal_samples_desert",               category = "valuables",    titleHash = "CI_TAG_FOLDER_ANIMAL_SAMPLES_DESERT",               label = nil, labelHash = "CI_TAG_FOLDER_ANIMAL_SAMPLES_DESERT",               description = nil, descriptionHash = "CI_TAG_FOLDER_ANIMAL_SAMPLES_DESERT_DESC",               txd = "inventory_items_mp", texture = "provision_role_naturalist_sample_desert",       tags = { "CI_TAG_FOLDER_ANIMAL_SAMPLES_DESERT" } },
    { id = "animal_samples_domesticated",         category = "valuables",    titleHash = "CI_TAG_FOLDER_ANIMAL_SAMPLES_DOMESTICATED",         label = nil, labelHash = "CI_TAG_FOLDER_ANIMAL_SAMPLES_DOMESTICATED",         description = nil, descriptionHash = "CI_TAG_FOLDER_ANIMAL_SAMPLES_DOMESTICATED_DESC",         txd = "inventory_items_mp", texture = "provision_role_naturalist_sample_domesticated", tags = { "CI_TAG_FOLDER_ANIMAL_SAMPLES_DOMESTICATED" } },
    { id = "animal_samples_forest",               category = "valuables",    titleHash = "CI_TAG_FOLDER_ANIMAL_SAMPLES_FOREST",               label = nil, labelHash = "CI_TAG_FOLDER_ANIMAL_SAMPLES_FOREST",               description = nil, descriptionHash = "CI_TAG_FOLDER_ANIMAL_SAMPLES_FOREST_DESC",               txd = "inventory_items_mp", texture = "provision_role_naturalist_sample_forest",       tags = { "CI_TAG_FOLDER_ANIMAL_SAMPLES_FOREST" } },
    { id = "animal_samples_legendary_albino",     category = "valuables",    titleHash = "CI_TAG_FOLDER_ANIMAL_SAMPLES_LEGENDARY_ALBINO",     label = nil, labelHash = "CI_TAG_FOLDER_ANIMAL_SAMPLES_LEGENDARY_ALBINO",     description = nil, descriptionHash = "CI_TAG_FOLDER_ANIMAL_SAMPLES_LEGENDARY_ALBINO_DESC",     txd = "inventory_items_mp", texture = "provision_role_naturalist_sample_albino",       tags = { "CI_TAG_FOLDER_ANIMAL_SAMPLES_LEGENDARY_ALBINO" } },
    { id = "animal_samples_legendary_melanistic", category = "valuables",    titleHash = "CI_TAG_FOLDER_ANIMAL_SAMPLES_LEGENDARY_MELANISTIC", label = nil, labelHash = "CI_TAG_FOLDER_ANIMAL_SAMPLES_LEGENDARY_MELANISTIC", description = nil, descriptionHash = "CI_TAG_FOLDER_ANIMAL_SAMPLES_LEGENDARY_MELANISTIC_DESC", txd = "inventory_items_mp", texture = "provision_role_naturalist_sample_melanistic",   tags = { "CI_TAG_FOLDER_ANIMAL_SAMPLES_LEGENDARY_MELANISTIC" } },
    { id = "animal_samples_legendary_patterned",  category = "valuables",    titleHash = "CI_TAG_FOLDER_ANIMAL_SAMPLES_LEGENDARY_PATTERNED",  label = nil, labelHash = "CI_TAG_FOLDER_ANIMAL_SAMPLES_LEGENDARY_PATTERNED",  description = nil, descriptionHash = "CI_TAG_FOLDER_ANIMAL_SAMPLES_LEGENDARY_PATTERNED_DESC",  txd = "inventory_items_mp", texture = "provision_role_naturalist_sample_patterned",    tags = { "CI_TAG_FOLDER_ANIMAL_SAMPLES_LEGENDARY_PATTERNED" } },
    { id = "animal_samples_legendary_red_blonde", category = "valuables",    titleHash = "CI_TAG_FOLDER_ANIMAL_SAMPLES_LEGENDARY_RED_BLONDE", label = nil, labelHash = "CI_TAG_FOLDER_ANIMAL_SAMPLES_LEGENDARY_RED_BLONDE", description = nil, descriptionHash = "CI_TAG_FOLDER_ANIMAL_SAMPLES_LEGENDARY_RED_BLONDE_DESC", txd = "inventory_items_mp", texture = "provision_role_naturalist_sample_redblonde",    tags = { "CI_TAG_FOLDER_ANIMAL_SAMPLES_LEGENDARY_RED_BLONDE" } },
    { id = "animal_samples_mountain",             category = "valuables",    titleHash = "CI_TAG_FOLDER_ANIMAL_SAMPLES_MOUNTAIN",             label = nil, labelHash = "CI_TAG_FOLDER_ANIMAL_SAMPLES_MOUNTAIN",             description = nil, descriptionHash = "CI_TAG_FOLDER_ANIMAL_SAMPLES_MOUNTAIN_DESC",             txd = "inventory_items_mp", texture = "provision_role_naturalist_sample_mountain",     tags = { "CI_TAG_FOLDER_ANIMAL_SAMPLES_MOUNTAIN" } },
    { id = "animal_samples_swamp",                category = "valuables",    titleHash = "CI_TAG_FOLDER_ANIMAL_SAMPLES_SWAMP",                label = nil, labelHash = "CI_TAG_FOLDER_ANIMAL_SAMPLES_SWAMP",                description = nil, descriptionHash = "CI_TAG_FOLDER_ANIMAL_SAMPLES_SWAMP_DESC",                txd = "inventory_items_mp", texture = "provision_role_naturalist_sample_swamp",        tags = { "CI_TAG_FOLDER_ANIMAL_SAMPLES_SWAMP" } },
}
