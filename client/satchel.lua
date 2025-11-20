local uiAppChannel = joaat("satchel")
local uiEventChannel = joaat("satchel_menu")

Satchel = {}

---------------------------------------------------------------------------------
--                                                                             --
--                                CONFIGURATION                                --
--                                                                             --
---------------------------------------------------------------------------------

-- Change this in case you have another resource using the "native_satch" prefix for events
Satchel.eventHandlerKey = "native_satchel"

-- Enable/disable prompts for various consume actions
Satchel.allowDrinking = true
Satchel.allowEating = true
Satchel.allowReading = true
Satchel.allowUsing = true

-- Enable/disable prompts for various held actions
Satchel.allowBreakdown = true
Satchel.allowCooking = true

-- Enable/disable prompts for discarding items
Satchel.allowDiscarding = true

-- The game assumes some items cannot be discarded based on their tags
-- Set this to true to ignore those tags and allow discarding any item
Satchel.ignoreCannotDiscardTag = false

-- When an item reaches its max count, show the count in red color
-- This doesn't affect the tip text, which will always be marked red
Satchel.enableRedCountOnMax = false

-- Automatically categorize items based on their tags in the item database
-- This requires the base game's categories to be present in Satchel.categories
-- All of them are included by default in this file
Satchel.enableAutoCategorization = true

-- Automatically assign folders to items based on their tags in the item database
-- This requires the base game's folders to be present in Satchel.folders
-- All of them are included by default in this file
Satchel.enableAutoFolderAssignment = true

-- Whether to include items stored in folders in the "Recent" category
-- By default, items that are inside folders will be shown in the "Recent" category
-- Use this if you don't want to have to set textures for every item in a folder
Satchel.enableFolderItemsInRecent = true

-- Items
-- This determines which items are visible in the UI by category
-- You can see this as the base inventory for any player
-- It can then be modified by using the Satchel API to add/remove items
Satchel.items = {
    {
        -- Required fields
        id = "my_custom_item",
        count = 1,

        -- Required if missing item.catalog or Satchel.enableAutoCategorization is disabled
        -- Optional if item.catalog is set and Satchel.enableAutoCategorization is enabled
        category = "provisions",

        -- Optional fields
        maxCount = 1,
        catalog = nil,
        folder = nil,

        -- Custom item fields
        label = "My Custom Item",
        description = "This is my custom item.",
        special = true,
        stars = 3,
        txd = "toasts_mp_generic",
        texture = "toast_mp_standalone_sp",
        effects = { "EFFECT_HEALTH_CORE_GOLD_1D" },

        -- Prompt flags
        discardable = false,
        breakable = false,
        cookable = false,
        consumable = false,
        drinkable = false,
        edible = false,
        readable = false,
    },

    { id = "big_game_meat_cooked",           count = 5,  maxCount = nil, category = "provisions",  folder = "big_game",     catalog = "CONSUMABLE_BIG_GAME_MEAT_COOKED", },
    { id = "special_tonic_crafted",          count = 10, maxCount = 10,  category = "tonics",      folder = nil,            catalog = "CONSUMABLE_SPECIAL_TONIC_CRAFTED", },
    { id = "bird_feather_flight",            count = 7,  maxCount = 10,  category = "materials",   folder = nil,            catalog = "PROVISION_BIRD_FEATHER_FLIGHT", },
    { id = "necklace_gold",                  count = 8,  maxCount = nil, category = "valuables",   folder = nil,            catalog = "PROVISION_NECKLACE_GOLD", },
    { id = "horse_reviver",                  count = 1,  maxCount = nil, category = "tonics",      folder = nil,            catalog = "CONSUMABLE_HORSE_REVIVER", },
    { id = "prime_beef",                     count = 1,  maxCount = nil, category = "ingredients", folder = nil,            catalog = "PROVISION_PRIME_BEEF", },
    { id = "herbivore_bait",                 count = 1,  maxCount = nil, category = "kit",         folder = nil,            catalog = "CONSUMABLE_HERBIVORE_BAIT", },
    { id = "salmon_can",                     count = 1,  maxCount = nil, category = "provisions",  folder = nil,            catalog = "CONSUMABLE_SALMON_CAN", },
    { id = "rabbit_pelt_pristine",           count = 1,  maxCount = nil, category = "provisions",  folder = nil,            catalog = "PROVISION_RABBIT_PELT_PRISTINE", },
    { id = "armadillo_skin",                 count = 1,  maxCount = nil, category = "materials",   folder = nil,            catalog = "PROVISION_ARMADILLO_SKIN", },
    { id = "legendary_beaver_pelt_1",        count = 1,  maxCount = nil, category = "materials",   folder = nil,            catalog = "PROVISION_ROLE_NATURALIST_PELT_BEAVER_LEGENDARY_01", },
    { id = "carcass_wolf_high_quality",      count = 1,  maxCount = nil, category = "materials",   folder = nil,            catalog = "PROVISION_ANIMAL_CARCASS_WOLF_HIGH_QUALITY", },
    { id = "buckle_silver",                  count = 1,  maxCount = nil, category = "valuables",   folder = nil,            catalog = "PROVISION_BUCKLE_SILVER", },
    { id = "fish_smallmouth_bass",           count = 1,  maxCount = nil, category = "materials",   folder = nil,            catalog = "PROVISION_FISH_SMALLMOUTH_BASS", },
    { id = "carcass_deer_poor",              count = 1,  maxCount = nil, category = "materials",   folder = nil,            catalog = "PROVISION_ANIMAL_CARCASS_DEER_POOR", },
    { id = "tenn_whiskey",                   count = 1,  maxCount = nil, category = "tonics",      folder = "collector_bottles", catalog = "CONSUMABLE_TENN_WHISKEY", },
    { id = "irish_whiskey",                  count = 1,  maxCount = nil, category = "tonics",      folder = "collector_bottles", catalog = "CONSUMABLE_IRISH_WHISKEY", },
    { id = "scotch_whiskey",                 count = 1,  maxCount = nil, category = "tonics",      folder = "collector_bottles", catalog = "CONSUMABLE_SCOTCH_WHISKEY", },
    { id = "cyprus_brandy",                  count = 1,  maxCount = nil, category = "tonics",      folder = "collector_bottles", catalog = "CONSUMABLE_CYPRUS_BRANDY", },
    { id = "carcass_crow_perfect",           count = 1,  maxCount = nil, category = "materials",   folder = nil,            catalog = "PROVISION_ANIMAL_CARCASS_CROW_PERFECT", },
    { id = "skinned_carcass_pig_perfect",    count = 1,  maxCount = nil, category = "materials",   folder = nil,            catalog = "PROVISION_SKINNED_CARCASS_PIG_PERFECT", },
    { id = "carcass_songbird_poor",          count = 1,  maxCount = nil, category = "materials",   folder = nil,            catalog = "PROVISION_ANIMAL_CARCASS_SONGBIRD_POOR", },
    { id = "carcass_cormorant_high_quality", count = 1,  maxCount = nil, category = "materials",   folder = nil,            catalog = "PROVISION_ANIMAL_CARCASS_CORMORANT_HIGH_QUALITY", },
    { id = "wolf_fur_poor",                  count = 1,  maxCount = nil, category = "materials",   folder = nil,            catalog = "PROVISION_WOLF_FUR_POOR", },
    { id = "gila_skin",                      count = 1,  maxCount = nil, category = "materials",   folder = nil,            catalog = "PROVISION_GILA_SKIN", },
    { id = "herb_milkweed",                  count = 1,  maxCount = nil, category = "ingredients", folder = nil,            catalog = "CONSUMABLE_HERB_MILKWEED", },
    { id = "herb_burdock_root",              count = 1,  maxCount = nil, category = "ingredients", folder = nil,            catalog = "CONSUMABLE_HERB_BURDOCK_ROOT", },
    { id = "bread_chunk",                    count = 1,  maxCount = nil, category = "provisions",  folder = nil,            catalog = "CONSUMABLE_BREAD_CHUNK", },
    { id = "exotic_bird_wild_mint_cooked",   count = 1,  maxCount = nil, category = "provisions",  folder = "exotic_bird",  catalog = "CONSUMABLE_EXOTIC_BIRD_WILD_MINT_COOKED", },
    { id = "gamey_bird_cooked",              count = 1,  maxCount = nil, category = "provisions",  folder = "gamey_bird",   catalog = "CONSUMABLE_GAMEY_BIRD_COOKED", },
    { id = "cocaine_chewing_gum",            count = 1,  maxCount = nil, category = "tonics",      folder = nil,            catalog = "CONSUMABLE_COCAINE_CHEWING_GUM", },
    { id = "herb_prairie_poppy",             count = 1,  maxCount = nil, category = "ingredients", folder = nil,            catalog = "CONSUMABLE_HERB_PRAIRIE_POPPY", },
    { id = "medicine",                       count = 1,  maxCount = nil, category = "tonics",      folder = nil,            catalog = "CONSUMABLE_MEDICINE", },
    { id = "moonshine",                      count = 1,  maxCount = nil, category = "tonics",      folder = nil,            catalog = "CONSUMABLE_MOONSHINE", },
    { id = "peach",                          count = 1,  maxCount = nil, category = "provisions",  folder = nil,            catalog = "CONSUMABLE_PEACH", },
    { id = "cigar",                          count = 1,  maxCount = nil, category = "provisions",  folder = nil,            catalog = "CONSUMABLE_CIGAR", },
    { id = "snake_oil_used",                 count = 1,  maxCount = nil, category = "tonics",      folder = nil,            catalog = "CONSUMABLE_SNAKE_OIL_USED", },
    { id = "card_ace_swords",                count = 1,  maxCount = nil, category = "documents",   folder = "collector_card_swords", catalog = "DOCUMENT_CARD_ACE_SWORDS", },
    { id = "card_eight_swords",              count = 1,  maxCount = nil, category = "documents",   folder = "collector_card_swords", catalog = "DOCUMENT_CARD_EIGHT_SWORDS", },
    { id = "card_five_swords",               count = 1,  maxCount = nil, category = "documents",   folder = "collector_card_swords", catalog = "DOCUMENT_CARD_FIVE_SWORDS", },
    { id = "card_four_swords",               count = 1,  maxCount = nil, category = "documents",   folder = "collector_card_swords", catalog = "DOCUMENT_CARD_FOUR_SWORDS", },
    { id = "card_king_swords",               count = 1,  maxCount = nil, category = "documents",   folder = "collector_card_swords", catalog = "DOCUMENT_CARD_KING_SWORDS", },
    { id = "card_knight_swords",             count = 1,  maxCount = nil, category = "documents",   folder = "collector_card_swords", catalog = "DOCUMENT_CARD_KNIGHT_SWORDS", },
    { id = "card_nine_swords",               count = 1,  maxCount = nil, category = "documents",   folder = "collector_card_swords", catalog = "DOCUMENT_CARD_NINE_SWORDS", },
    { id = "card_page_swords",               count = 1,  maxCount = nil, category = "documents",   folder = "collector_card_swords", catalog = "DOCUMENT_CARD_PAGE_SWORDS", },
    { id = "card_queen_swords",              count = 1,  maxCount = nil, category = "documents",   folder = "collector_card_swords", catalog = "DOCUMENT_CARD_QUEEN_SWORDS", },
    { id = "card_seven_swords",              count = 1,  maxCount = nil, category = "documents",   folder = "collector_card_swords", catalog = "DOCUMENT_CARD_SEVEN_SWORDS", },
    { id = "card_six_swords",                count = 1,  maxCount = nil, category = "documents",   folder = "collector_card_swords", catalog = "DOCUMENT_CARD_SIX_SWORDS", },
    { id = "card_ten_swords",                count = 1,  maxCount = nil, category = "documents",   folder = "collector_card_swords", catalog = "DOCUMENT_CARD_TEN_SWORDS", },
    { id = "card_three_swords",              count = 1,  maxCount = nil, category = "documents",   folder = "collector_card_swords", catalog = "DOCUMENT_CARD_THREE_SWORDS", },
    { id = "card_two_swords",                count = 1,  maxCount = nil, category = "documents",   folder = "collector_card_swords", catalog = "DOCUMENT_CARD_TWO_SWORDS", },
}

-- Categories
-- This determines what categories are visible in the UI

Satchel.categories = {
    { id = "recent",      recent = true,  texture = "satchel_nav_all",         title = 0x504364F1,     label = GetStringFromHashKey(0x504364F1),     description = GetStringFromHashKey(0x4E6F9F15),          tags = {} },
    { id = "provisions",  recent = false, texture = "satchel_nav_provisions",  title = 0x3B1DCCD8,     label = GetStringFromHashKey(0x3B1DCCD8),     description = GetStringFromHashKey(0x058002A1),          tags = { "CI_TAG_CATEGORY_PROVISION" } },
    { id = "tonics",      recent = false, texture = "satchel_nav_remedies",    title = 0x855B3FAE,     label = GetStringFromHashKey(0x855B3FAE),     description = GetStringFromHashKey(0x176ABFC5),          tags = { "CI_TAG_CATEGORY_REMEDY" } },
    { id = "ingredients", recent = false, texture = "satchel_nav_ingredients", title = 0x3268E974,     label = GetStringFromHashKey(0x3268E974),     description = GetStringFromHashKey(0x5A0CC2DE),          tags = { "CI_TAG_CATEGORY_INGREDIENT" } },
    { id = "materials",   recent = false, texture = "satchel_nav_materials",   title = 0xEB0408D2,     label = GetStringFromHashKey(0xEB0408D2),     description = GetStringFromHashKey(0x9AF912F2),          tags = { "CI_TAG_CATEGORY_MATERIAL", "CI_TAG_CATEGORY_HORSE_CARGO" } },
    { id = "kit",         recent = false, texture = "satchel_nav_kit",         title = 0x7A0D8994,     label = GetStringFromHashKey(0x7A0D8994),     description = GetStringFromHashKey(0xA1DF90FC),          tags = { "CI_TAG_CATEGORY_KIT" } },
    { id = "valuables",   recent = false, texture = "satchel_nav_valuables",   title = 0xFA827B50,     label = GetStringFromHashKey(0xFA827B50),     description = GetStringFromHashKey(0x3A9E6C4A),          tags = { "CI_TAG_CATEGORY_VALUABLE" } },
    { id = "documents",   recent = false, texture = "satchel_nav_documents",   title = 0xFDD0A576,     label = GetStringFromHashKey(0xFDD0A576),     description = GetStringFromHashKey(0xE7055490),          tags = { "CI_TAG_CATEGORY_DOCUMENT" } },
    -- { id = "horse",       recent = false, texture = "satchel_nav_horse",       title = 0x0FA40D69,     label = GetStringFromHashKey(0x0FA40D69),     description = GetStringFromHashKey(0xB8507365),          tags = { "CI_TAG_CATEGORY_HORSE_CARGO" } },
    -- { id = "wagon",       recent = false, texture = "satchel_nav_horse",       title = "HWAGON_TITLE", label = GetStringFromHashKey("HWAGON_TITLE"), description = GetStringFromHashKey("HWAGON_TITLE_DESC"), tags = { "CI_TAG_CATEGORY_HORSE_CARGO" } },
    -- { id = "donations",   recent = false, texture = "satchel_nav_donate",      title = 0x61FAAEA1,     label = GetStringFromHashKey(0x61FAAEA1),     description = GetStringFromHashKey(0x0552C91D),          tags = {} },
    -- { id = "send",        recent = false, texture = "satchel_nav_send",        title = 0xBFC37FEE,     label = GetStringFromHashKey(0xBFC37FEE),     description = GetStringFromHashKey(0x3BB66DA9),          tags = {} },
    -- { id = "sell",        recent = false, texture = "satchel_nav_sell",        title = 0xF6614C1F,     label = GetStringFromHashKey(0xF6614C1F),     description = GetStringFromHashKey(0x11352E60),          tags = {} },
}

-- Folders
-- This determines what folders are available in the UI

Satchel.folders = {
    -- General folders
    { id = "books",                               category = "documents",    title = joaat("CI_TAG_FOLDER_BOOKS"),                               label = GetStringFromHashKey("CI_TAG_FOLDER_BOOKS"),                               description = GetStringFromHashKey("CI_TAG_FOLDER_BOOKS_DESC"),                               txd = "inventory_items",    texture = "folder_books",                                  tags = { "CI_TAG_FOLDER_BOOKS" } },
    { id = "bounty_posters",                      category = "documents",    title = joaat("CI_TAG_FOLDER_BOUNTY_POSTERS"),                      label = GetStringFromHashKey("CI_TAG_FOLDER_BOUNTY_POSTERS"),                      description = GetStringFromHashKey("CI_TAG_FOLDER_BOUNTY_POSTERS_DESC"),                      txd = "inventory_items",    texture = "folder_bounty_posters",                         tags = { "CI_TAG_FOLDER_BOUNTY_POSTERS" } },
    { id = "business_cards",                      category = "documents",    title = joaat("CI_TAG_FOLDER_BUSINESS_CARDS"),                      label = GetStringFromHashKey("CI_TAG_FOLDER_BUSINESS_CARDS"),                      description = GetStringFromHashKey("CI_TAG_FOLDER_BUSINESS_CARDS_DESC"),                      txd = "inventory_items",    texture = "folder_business_cards",                         tags = { "CI_TAG_FOLDER_BUSINESS_CARDS" } },
    { id = "collector_maps",                      category = "documents",    title = joaat("CI_TAG_FOLDER_COLLECTOR_MAPS"),                      label = GetStringFromHashKey("CI_TAG_FOLDER_COLLECTOR_MAPS"),                      description = GetStringFromHashKey("CI_TAG_FOLDER_COLLECTOR_MAPS_DESC"),                      txd = "inventory_items",    texture = "folder_maps",                                   tags = { "CI_TAG_FOLDER_COLLECTOR_MAPS" } },
    { id = "dinosaur_notes",                      category = "documents",    title = joaat("CI_TAG_FOLDER_DINOSAUR_NOTES"),                      label = GetStringFromHashKey("CI_TAG_FOLDER_DINOSAUR_NOTES"),                      description = GetStringFromHashKey("CI_TAG_FOLDER_DINOSAUR_NOTES_DESC"),                      txd = "inventory_items",    texture = "folder_dinosaur_notes",                         tags = { "CI_TAG_FOLDER_DINOSAUR_NOTES" } },
    { id = "drawings",                            category = "documents",    title = joaat("CI_TAG_FOLDER_DRAWINGS"),                            label = GetStringFromHashKey("CI_TAG_FOLDER_DRAWINGS"),                            description = GetStringFromHashKey("CI_TAG_FOLDER_DRAWINGS_DESC"),                            txd = "inventory_items",    texture = "folder_drawings",                               tags = { "CI_TAG_FOLDER_DRAWINGS" } },
    { id = "handbills",                           category = "documents",    title = joaat("CI_TAG_FOLDER_HANDBILLS"),                           label = GetStringFromHashKey("CI_TAG_FOLDER_HANDBILLS"),                           description = GetStringFromHashKey("CI_TAG_FOLDER_HANDBILLS_DESC"),                           txd = "inventory_items",    texture = "folder_handbills",                              tags = { "CI_TAG_FOLDER_HANDBILLS" } },
    { id = "invitations",                         category = "documents",    title = joaat("CI_TAG_FOLDER_INVITATIONS"),                         label = GetStringFromHashKey("CI_TAG_FOLDER_INVITATIONS"),                         description = GetStringFromHashKey("CI_TAG_FOLDER_INVITATIONS_DESC"),                         txd = "inventory_items",    texture = "folder_invitations",                            tags = { "CI_TAG_FOLDER_INVITATIONS" } },
    { id = "kit_keepsakes",                       category = "documents",    title = joaat("CI_TAG_FOLDER_KIT_KEEPSAKES"),                       label = GetStringFromHashKey("CI_TAG_FOLDER_KIT_KEEPSAKES"),                       description = GetStringFromHashKey("CI_TAG_FOLDER_KIT_KEEPSAKES_DESC"),                       txd = "inventory_items",    texture = "folder_kit_keepsakes",                          tags = { "CI_TAG_FOLDER_KIT_KEEPSAKES" } },
    { id = "kit_keychain",                        category = "documents",    title = joaat("CI_TAG_FOLDER_KIT_KEYCHAIN"),                        label = GetStringFromHashKey("CI_TAG_FOLDER_KIT_KEYCHAIN"),                        description = GetStringFromHashKey("CI_TAG_FOLDER_KIT_KEYCHAIN_DESC"),                        txd = "inventory_items",    texture = "folder_kit_keychain",                           tags = { "CI_TAG_FOLDER_KIT_KEYCHAIN" } },
    { id = "kit_watches",                         category = "documents",    title = joaat("CI_TAG_FOLDER_KIT_WATCHES"),                         label = GetStringFromHashKey("CI_TAG_FOLDER_KIT_WATCHES"),                         description = GetStringFromHashKey("CI_TAG_FOLDER_KIT_WATCHES_DESC"),                         txd = "inventory_items",    texture = "provision_folder_watches",                      tags = { "CI_TAG_FOLDER_KIT_WATCHES" } },
    { id = "letters",                             category = "documents",    title = joaat("CI_TAG_FOLDER_LETTERS"),                             label = GetStringFromHashKey("CI_TAG_FOLDER_LETTERS"),                             description = GetStringFromHashKey("CI_TAG_FOLDER_LETTERS_DESC"),                             txd = "inventory_items",    texture = "folder_letters",                                tags = { "CI_TAG_FOLDER_LETTERS" } },
    { id = "maps",                                category = "documents",    title = joaat("CI_TAG_FOLDER_MAPS"),                                label = GetStringFromHashKey("CI_TAG_FOLDER_MAPS"),                                description = GetStringFromHashKey("CI_TAG_FOLDER_MAPS_DESC"),                                txd = "inventory_items",    texture = "folder_maps",                                   tags = { "CI_TAG_FOLDER_MAPS" } },
    { id = "masks",                               category = "documents",    title = joaat("CI_TAG_FOLDER_MASKS"),                               label = GetStringFromHashKey("CI_TAG_FOLDER_MASKS"),                               description = GetStringFromHashKey("CI_TAG_FOLDER_MASKS_DESC"),                               txd = "inventory_items",    texture = "kit_bandana",                                   tags = { "CI_TAG_FOLDER_MASKS" } },
    { id = "newspaper_scraps",                    category = "documents",    title = joaat("CI_TAG_FOLDER_NEWSPAPER_SCRAPS"),                    label = GetStringFromHashKey("CI_TAG_FOLDER_NEWSPAPER_SCRAPS"),                    description = GetStringFromHashKey("CI_TAG_FOLDER_NEWSPAPER_SCRAPS_DESC"),                    txd = "inventory_items",    texture = "folder_newspaper_scraps",                       tags = { "CI_TAG_FOLDER_NEWSPAPER_SCRAPS" } },
    { id = "newspapers",                          category = "documents",    title = joaat("CI_TAG_FOLDER_NEWSPAPERS"),                          label = GetStringFromHashKey("CI_TAG_FOLDER_NEWSPAPERS"),                          description = GetStringFromHashKey("CI_TAG_FOLDER_NEWSPAPERS_DESC"),                          txd = "inventory_items",    texture = "folder_newspapers",                             tags = { "CI_TAG_FOLDER_NEWSPAPERS" } },
    { id = "notes",                               category = "documents",    title = joaat("CI_TAG_FOLDER_NOTES"),                               label = GetStringFromHashKey("CI_TAG_FOLDER_NOTES"),                               description = GetStringFromHashKey("CI_TAG_FOLDER_NOTES_DESC"),                               txd = "inventory_items",    texture = "folder_notes",                                  tags = { "CI_TAG_FOLDER_NOTES" } },
    { id = "photographs",                         category = "documents",    title = joaat("CI_TAG_FOLDER_PHOTOGRAPHS"),                         label = GetStringFromHashKey("CI_TAG_FOLDER_PHOTOGRAPHS"),                         description = GetStringFromHashKey("CI_TAG_FOLDER_PHOTOGRAPHS_DESC"),                         txd = "inventory_items",    texture = "folder_photographs",                            tags = { "CI_TAG_FOLDER_PHOTOGRAPHS" } },
    { id = "rock_carving_notes",                  category = "documents",    title = joaat("CI_TAG_FOLDER_ROCK_CARVING_NOTES"),                  label = GetStringFromHashKey("CI_TAG_FOLDER_ROCK_CARVING_NOTES"),                  description = GetStringFromHashKey("CI_TAG_FOLDER_ROCK_CARVING_NOTES_DESC"),                  txd = "inventory_items",    texture = "folder_maps",                                   tags = { "CI_TAG_FOLDER_ROCK_CARVING_NOTES" } },
    { id = "taxidermist_orders",                  category = "documents",    title = joaat("CI_TAG_FOLDER_TAXIDERMIST_ORDERS"),                  label = GetStringFromHashKey("CI_TAG_FOLDER_TAXIDERMIST_ORDERS"),                  description = GetStringFromHashKey("CI_TAG_FOLDER_TAXIDERMIST_ORDERS_DESC"),                  txd = "inventory_items",    texture = "folder_taxidermist_orders",                     tags = { "CI_TAG_FOLDER_TAXIDERMIST_ORDERS" } },
    { id = "telegrams",                           category = "documents",    title = joaat("CI_TAG_MISSION_DROP_ENABLED"),                       label = GetStringFromHashKey("CI_TAG_MISSION_DROP_ENABLED"),                       description = GetStringFromHashKey("CI_TAG_MISSION_DROP_ENABLED_DESC"),                       txd = "inventory_items_mp", texture = "folder_letters_cloud",                          tags = { "CI_TAG_MISSION_DROP_ENABLED" } },
    { id = "treasure_maps",                       category = "documents",    title = joaat("CI_TAG_FOLDER_TREASURE_MAPS"),                       label = GetStringFromHashKey("CI_TAG_FOLDER_TREASURE_MAPS"),                       description = GetStringFromHashKey("CI_TAG_FOLDER_TREASURE_MAPS_DESC"),                       txd = "inventory_items",    texture = "folder_treasure_maps",                          tags = { "CI_TAG_FOLDER_TREASURE_MAPS" } },
    { id = "watch",                               category = "documents",    title = joaat("CI_TAG_FOLDER_WATCH"),                               label = GetStringFromHashKey("CI_TAG_FOLDER_WATCH"),                               description = GetStringFromHashKey("CI_TAG_FOLDER_WATCH_DESC"),                               txd = "inventory_items",    texture = "kit_player_pocketwatch",                        tags = { "CI_TAG_FOLDER_WATCH" } },

    -- Cooked Meat folders
    { id = "big_game",                            category = "provisions",   title = joaat("CI_TAG_FOLDER_BIG_GAME"),                            label = GetStringFromHashKey("CI_TAG_FOLDER_BIG_GAME"),                            description = GetStringFromHashKey("CI_TAG_FOLDER_BIG_GAME_DESC"),                            txd = "inventory_items",    texture = "consumable_meat_big_game_cooked",               tags = { "CI_TAG_FOLDER_BIG_GAME" } },
    { id = "crustacean",                          category = "provisions",   title = joaat("CI_TAG_FOLDER_CRUSTACEAN"),                          label = GetStringFromHashKey("CI_TAG_FOLDER_CRUSTACEAN"),                          description = GetStringFromHashKey("CI_TAG_FOLDER_CRUSTACEAN_DESC"),                          txd = "inventory_items",    texture = "consumable_meat_crustacean_cooked",             tags = { "CI_TAG_FOLDER_CRUSTACEAN" } },
    { id = "exotic_bird",                         category = "provisions",   title = joaat("CI_TAG_FOLDER_EXOTIC_BIRD"),                         label = GetStringFromHashKey("CI_TAG_FOLDER_EXOTIC_BIRD"),                         description = GetStringFromHashKey("CI_TAG_FOLDER_EXOTIC_BIRD_DESC"),                         txd = "inventory_items",    texture = "consumable_meat_exotic_bird_cooked",            tags = { "CI_TAG_FOLDER_EXOTIC_BIRD" } },
    { id = "flakey_fish",                         category = "provisions",   title = joaat("CI_TAG_FOLDER_FLAKEY_FISH"),                         label = GetStringFromHashKey("CI_TAG_FOLDER_FLAKEY_FISH"),                         description = GetStringFromHashKey("CI_TAG_FOLDER_FLAKEY_FISH_DESC"),                         txd = "inventory_items",    texture = "consumable_meat_flakey_fish_cooked",            tags = { "CI_TAG_FOLDER_FLAKEY_FISH" } },
    { id = "game",                                category = "provisions",   title = joaat("CI_TAG_FOLDER_GAME"),                                label = GetStringFromHashKey("CI_TAG_FOLDER_GAME"),                                description = GetStringFromHashKey("CI_TAG_FOLDER_GAME_DESC"),                                txd = "inventory_items",    texture = "consumable_meat_game_cooked",                   tags = { "CI_TAG_FOLDER_GAME" } },
    { id = "gamey_bird",                          category = "provisions",   title = joaat("CI_TAG_FOLDER_GAMEY_BIRD"),                          label = GetStringFromHashKey("CI_TAG_FOLDER_GAMEY_BIRD"),                          description = GetStringFromHashKey("CI_TAG_FOLDER_GAMEY_BIRD_DESC"),                          txd = "inventory_items",    texture = "consumable_meat_gamey_bird_cooked",             tags = { "CI_TAG_FOLDER_GAMEY_BIRD" } },
    { id = "gristly_mutton",                      category = "provisions",   title = joaat("CI_TAG_FOLDER_GRISTLY_MUTTON"),                      label = GetStringFromHashKey("CI_TAG_FOLDER_GRISTLY_MUTTON"),                      description = GetStringFromHashKey("CI_TAG_FOLDER_GRISTLY_MUTTON_DESC"),                      txd = "inventory_items",    texture = "consumable_meat_gristly_mutton_cooked",         tags = { "CI_TAG_FOLDER_GRISTLY_MUTTON" } },
    { id = "gritty_fish",                         category = "provisions",   title = joaat("CI_TAG_FOLDER_GRITTY_FISH"),                         label = GetStringFromHashKey("CI_TAG_FOLDER_GRITTY_FISH"),                         description = GetStringFromHashKey("CI_TAG_FOLDER_GRITTY_FISH_DESC"),                         txd = "inventory_items",    texture = "consumable_meat_gritty_fish_cooked",            tags = { "CI_TAG_FOLDER_GRITTY_FISH" } },
    { id = "herptile_meat",                       category = "provisions",   title = joaat("CI_TAG_FOLDER_HERPTILE_MEAT"),                       label = GetStringFromHashKey("CI_TAG_FOLDER_HERPTILE_MEAT"),                       description = GetStringFromHashKey("CI_TAG_FOLDER_HERPTILE_MEAT_DESC"),                       txd = "inventory_items",    texture = "consumable_meat_herptile_cooked",               tags = { "CI_TAG_FOLDER_HERPTILE_MEAT" } },
    { id = "mature_venison",                      category = "provisions",   title = joaat("CI_TAG_FOLDER_MATURE_VENISON"),                      label = GetStringFromHashKey("CI_TAG_FOLDER_MATURE_VENISON"),                      description = GetStringFromHashKey("CI_TAG_FOLDER_MATURE_VENISON_DESC"),                      txd = "inventory_items",    texture = "consumable_meat_mature_venison_cooked",         tags = { "CI_TAG_FOLDER_MATURE_VENISON" } },
    { id = "plump_bird",                          category = "provisions",   title = joaat("CI_TAG_FOLDER_PLUMP_BIRD"),                          label = GetStringFromHashKey("CI_TAG_FOLDER_PLUMP_BIRD"),                          description = GetStringFromHashKey("CI_TAG_FOLDER_PLUMP_BIRD_DESC"),                          txd = "inventory_items",    texture = "consumable_meat_plump_bird_cooked",             tags = { "CI_TAG_FOLDER_PLUMP_BIRD" } },
    { id = "prime_beef",                          category = "provisions",   title = joaat("CI_TAG_FOLDER_PRIME_BEEF"),                          label = GetStringFromHashKey("CI_TAG_FOLDER_PRIME_BEEF"),                          description = GetStringFromHashKey("CI_TAG_FOLDER_PRIME_BEEF_DESC"),                          txd = "inventory_items",    texture = "consumable_meat_prime_beef_cooked",             tags = { "CI_TAG_FOLDER_PRIME_BEEF" } },
    { id = "stringy_meat",                        category = "provisions",   title = joaat("CI_TAG_FOLDER_STRINGY_MEAT"),                        label = GetStringFromHashKey("CI_TAG_FOLDER_STRINGY_MEAT"),                        description = GetStringFromHashKey("CI_TAG_FOLDER_STRINGY_MEAT_DESC"),                        txd = "inventory_items",    texture = "consumable_meat_stringy_cooked",                tags = { "CI_TAG_FOLDER_STRINGY_MEAT" } },
    { id = "succulent_fish",                      category = "provisions",   title = joaat("CI_TAG_FOLDER_SUCCULENT_FISH"),                      label = GetStringFromHashKey("CI_TAG_FOLDER_SUCCULENT_FISH"),                      description = GetStringFromHashKey("CI_TAG_FOLDER_SUCCULENT_FISH_DESC"),                      txd = "inventory_items",    texture = "consumable_meat_succulent_fish_cooked",         tags = { "CI_TAG_FOLDER_SUCCULENT_FISH" } },
    { id = "tender_pork",                         category = "provisions",   title = joaat("CI_TAG_FOLDER_TENDER_PORK"),                         label = GetStringFromHashKey("CI_TAG_FOLDER_TENDER_PORK"),                         description = GetStringFromHashKey("CI_TAG_FOLDER_TENDER_PORK_DESC"),                         txd = "inventory_items",    texture = "consumable_meat_tender_pork_cooked",            tags = { "CI_TAG_FOLDER_TENDER_PORK" } },

    -- Pamphlet folders
    { id = "animal_pamphlets",                    category = "documents",    title = joaat("CI_TAG_FOLDER_ANIMAL_PAMPHLETS"),                    label = GetStringFromHashKey("CI_TAG_FOLDER_ANIMAL_PAMPHLETS"),                    description = GetStringFromHashKey("CI_TAG_FOLDER_ANIMAL_PAMPHLETS_DESC"),                    txd = "inventory_items_mp", texture = "folder_animal_pamphlet",                        tags = { "CI_TAG_FOLDER_ANIMAL_PAMPHLETS" } },
    { id = "moonshine_recipes",                   category = "documents",    title = joaat("CI_TAG_FOLDER_MOONSHINE_RECIPES"),                   label = GetStringFromHashKey("CI_TAG_FOLDER_MOONSHINE_RECIPES"),                   description = GetStringFromHashKey("CI_TAG_FOLDER_MOONSHINE_RECIPES_DESC"),                   txd = "inventory_items_mp", texture = "folder_moonshine_recipes",                      tags = { "CI_TAG_FOLDER_MOONSHINE_RECIPES" } },
    { id = "recipe_pamphlets",                    category = "documents",    title = joaat("CI_TAG_FOLDER_RECIPE_PAMPHLETS"),                    label = GetStringFromHashKey("CI_TAG_FOLDER_RECIPE_PAMPHLETS"),                    description = GetStringFromHashKey("CI_TAG_FOLDER_RECIPE_PAMPHLETS_DESC"),                    txd = "inventory_items",    texture = "folder_recipe_pamphlets",                       tags = { "CI_TAG_FOLDER_RECIPE_PAMPHLETS" } },
    { id = "satchel_pamphlets",                   category = "documents",    title = joaat("CI_TAG_FOLDER_SATCHEL_PAMPHLETS"),                   label = GetStringFromHashKey("CI_TAG_FOLDER_SATCHEL_PAMPHLETS"),                   description = GetStringFromHashKey("CI_TAG_FOLDER_SATCHEL_PAMPHLETS_DESC"),                   txd = "inventory_items_mp", texture = "folder_satchel_upgrades",                       tags = { "CI_TAG_FOLDER_SATCHEL_PAMPHLETS" } },
    { id = "skill_pamphlets",                     category = "documents",    title = joaat("CI_TAG_FOLDER_SKILL_PAMPHLETS"),                     label = GetStringFromHashKey("CI_TAG_FOLDER_SKILL_PAMPHLETS"),                     description = GetStringFromHashKey("CI_TAG_FOLDER_SKILL_PAMPHLETS_DESC"),                     txd = "inventory_items_mp", texture = "folder_skill_pages",                            tags = { "CI_TAG_FOLDER_SKILL_PAMPHLETS" } },

    -- Collectible folders
    { id = "collector_coins",                     category = "valuables",    title = joaat("CI_TAG_FOLDER_COLLECTOR_COINS"),                     label = GetStringFromHashKey("CI_TAG_FOLDER_COLLECTOR_COINS"),                     description = GetStringFromHashKey("CI_TAG_FOLDER_COLLECTOR_COINS_DESC"),                     txd = "inventory_items_mp", texture = "provision_coin_set",                            tags = { "CI_TAG_FOLDER_COLLECTOR_COINS" } },
    { id = "collector_eggs",                      category = "ingredients",  title = joaat("CI_TAG_FOLDER_COLLECTOR_EGGS"),                      label = GetStringFromHashKey("CI_TAG_FOLDER_COLLECTOR_EGGS"),                      description = GetStringFromHashKey("CI_TAG_FOLDER_COLLECTOR_EGGS_DESC"),                      txd = "inventory_items_mp", texture = "provision_egg_set",                             tags = { "CI_TAG_FOLDER_COLLECTOR_EGGS" } },
    { id = "collector_bottles",                   category = "tonics",       title = joaat("CI_TAG_FOLDER_COLLECTOR_BOTTLES"),                   label = GetStringFromHashKey("CI_TAG_FOLDER_COLLECTOR_BOTTLES"),                   description = GetStringFromHashKey("CI_TAG_FOLDER_COLLECTOR_BOTTLES_DESC"),                   txd = "inventory_items_mp", texture = "consumable_whiskey_set",                        tags = { "CI_TAG_FOLDER_COLLECTOR_BOTTLES" } },
    { id = "collector_arrowheads",                category = "valuables",    title = joaat("CI_TAG_FOLDER_COLLECTOR_ARROWHEADS"),                label = GetStringFromHashKey("CI_TAG_FOLDER_COLLECTOR_ARROWHEADS"),                description = GetStringFromHashKey("CI_TAG_FOLDER_COLLECTOR_ARROWHEADS_DESC"),                txd = "inventory_items_mp", texture = "provision_arrowhead_set",                       tags = { "CI_TAG_FOLDER_COLLECTOR_ARROWHEADS" } },
    { id = "collector_heirlooms",                 category = "valuables",    title = joaat("CI_TAG_FOLDER_COLLECTOR_HEIRLOOMS"),                 label = GetStringFromHashKey("CI_TAG_FOLDER_COLLECTOR_HEIRLOOMS"),                 description = GetStringFromHashKey("CI_TAG_FOLDER_COLLECTOR_HEIRLOOMS_DESC"),                 txd = "inventory_items_mp", texture = "provision_hrlm_set",                            tags = { "CI_TAG_FOLDER_COLLECTOR_HEIRLOOMS" } },
    { id = "collector_wildflowers",               category = "ingredients",  title = joaat("CI_TAG_FOLDER_COLLECTOR_WILDFLOWERS"),               label = GetStringFromHashKey("CI_TAG_FOLDER_COLLECTOR_WILDFLOWERS"),               description = GetStringFromHashKey("CI_TAG_FOLDER_COLLECTOR_WILDFLOWERS_DESC"),               txd = "inventory_items_mp", texture = "provision_wldflwr_set",                         tags = { "CI_TAG_FOLDER_COLLECTOR_WILDFLOWERS" } },
    { id = "collector_bracelets",                 category = "valuables",    title = joaat("CI_TAG_FOLDER_COLLECTOR_BRACELETS"),                 label = GetStringFromHashKey("CI_TAG_FOLDER_COLLECTOR_BRACELETS"),                 description = GetStringFromHashKey("CI_TAG_FOLDER_COLLECTOR_BRACELETS_DESC"),                 txd = "inventory_items_mp", texture = "provision_jewelry_bracelet_set",                tags = { "CI_TAG_FOLDER_COLLECTOR_BRACELETS" } },
    { id = "collector_earrings",                  category = "valuables",    title = joaat("CI_TAG_FOLDER_COLLECTOR_EARRINGS"),                  label = GetStringFromHashKey("CI_TAG_FOLDER_COLLECTOR_EARRINGS"),                  description = GetStringFromHashKey("CI_TAG_FOLDER_COLLECTOR_EARRINGS_DESC"),                  txd = "inventory_items_mp", texture = "provision_jewelry_earring_set",                 tags = { "CI_TAG_FOLDER_COLLECTOR_EARRINGS" } },
    { id = "collector_necklaces",                 category = "valuables",    title = joaat("CI_TAG_FOLDER_COLLECTOR_NECKLACES"),                 label = GetStringFromHashKey("CI_TAG_FOLDER_COLLECTOR_NECKLACES"),                 description = GetStringFromHashKey("CI_TAG_FOLDER_COLLECTOR_NECKLACES_DESC"),                 txd = "inventory_items_mp", texture = "provision_jewelry_necklace_set",                tags = { "CI_TAG_FOLDER_COLLECTOR_NECKLACES" } },
    { id = "collector_rings",                     category = "valuables",    title = joaat("CI_TAG_FOLDER_COLLECTOR_RINGS"),                     label = GetStringFromHashKey("CI_TAG_FOLDER_COLLECTOR_RINGS"),                     description = GetStringFromHashKey("CI_TAG_FOLDER_COLLECTOR_RINGS_DESC"),                     txd = "inventory_items_mp", texture = "provision_jewelry_ring_set",                    tags = { "CI_TAG_FOLDER_COLLECTOR_RINGS" } },
    { id = "collector_card_cups",                 category = "documents",    title = joaat("CI_TAG_FOLDER_COLLECTOR_CARD_CUPS"),                 label = GetStringFromHashKey("CI_TAG_FOLDER_COLLECTOR_CARD_CUPS"),                 description = GetStringFromHashKey("CI_TAG_FOLDER_COLLECTOR_CARD_CUPS_DESC"),                 txd = "inventory_items_mp", texture = "document_card_cups_set",                        tags = { "CI_TAG_FOLDER_COLLECTOR_CARD_CUPS" } },
    { id = "collector_card_pentacles",            category = "documents",    title = joaat("CI_TAG_FOLDER_COLLECTOR_CARD_PENTACLES"),            label = GetStringFromHashKey("CI_TAG_FOLDER_COLLECTOR_CARD_PENTACLES"),            description = GetStringFromHashKey("CI_TAG_FOLDER_COLLECTOR_CARD_PENTACLES_DESC"),            txd = "inventory_items_mp", texture = "document_card_pentacles_set",                   tags = { "CI_TAG_FOLDER_COLLECTOR_CARD_PENTACLES" } },
    { id = "collector_card_swords",               category = "documents",    title = joaat("CI_TAG_FOLDER_COLLECTOR_CARD_SWORDS"),               label = GetStringFromHashKey("CI_TAG_FOLDER_COLLECTOR_CARD_SWORDS"),               description = GetStringFromHashKey("CI_TAG_FOLDER_COLLECTOR_CARD_SWORDS_DESC"),               txd = "inventory_items_mp", texture = "document_card_swords_set",                      tags = { "CI_TAG_FOLDER_COLLECTOR_CARD_SWORDS" } },
    { id = "collector_card_wands",                category = "documents",    title = joaat("CI_TAG_FOLDER_COLLECTOR_CARD_WANDS"),                label = GetStringFromHashKey("CI_TAG_FOLDER_COLLECTOR_CARD_WANDS"),                description = GetStringFromHashKey("CI_TAG_FOLDER_COLLECTOR_CARD_WANDS_DESC"),                txd = "inventory_items_mp", texture = "document_card_wands_set",                       tags = { "CI_TAG_FOLDER_COLLECTOR_CARD_WANDS" } },
    { id = "collector_fossils_common",            category = "valuables",    title = joaat("CI_TAG_FOLDER_COLLECTOR_FOSSILS_COMMON"),            label = GetStringFromHashKey("CI_TAG_FOLDER_COLLECTOR_FOSSILS_COMMON"),            description = GetStringFromHashKey("CI_TAG_FOLDER_COLLECTOR_FOSSILS_COMMON_DESC"),            txd = "inventory_items_mp", texture = "provision_fossil_set_01_common",                tags = { "CI_TAG_FOLDER_COLLECTOR_FOSSILS_COMMON" } },
    { id = "collector_fossils_rare",              category = "valuables",    title = joaat("CI_TAG_FOLDER_COLLECTOR_FOSSILS_RARE"),              label = GetStringFromHashKey("CI_TAG_FOLDER_COLLECTOR_FOSSILS_RARE"),              description = GetStringFromHashKey("CI_TAG_FOLDER_COLLECTOR_FOSSILS_RARE_DESC"),              txd = "inventory_items_mp", texture = "provision_fossil_set_03_rare",                  tags = { "CI_TAG_FOLDER_COLLECTOR_FOSSILS_RARE" } },
    { id = "collector_fossils_uncommon",          category = "valuables",    title = joaat("CI_TAG_FOLDER_COLLECTOR_FOSSILS_UNCOMMON"),          label = GetStringFromHashKey("CI_TAG_FOLDER_COLLECTOR_FOSSILS_UNCOMMON"),          description = GetStringFromHashKey("CI_TAG_FOLDER_COLLECTOR_FOSSILS_UNCOMMON_DESC"),          txd = "inventory_items_mp", texture = "provision_fossil_set_02_uncommon",              tags = { "CI_TAG_FOLDER_COLLECTOR_FOSSILS_UNCOMMON" } },

    -- Feather folders
    { id = "plumes",                              category = "materials",    title = joaat("CI_TAG_FOLDER_PLUMES"),                              label = GetStringFromHashKey("CI_TAG_FOLDER_PLUMES"),                              description = GetStringFromHashKey("CI_TAG_FOLDER_PLUMES_DESC"),                              txd = "satchel_textures",   texture = "feathers_plume",                                tags = { "CI_TAG_FOLDER_PLUMES" } },
    { id = "collectible_feathers",                category = "materials",    title = joaat("CI_TAG_FOLDER_COLLECTIBLE_FEATHERS"),                label = GetStringFromHashKey("CI_TAG_FOLDER_COLLECTIBLE_FEATHERS"),                description = GetStringFromHashKey("CI_TAG_FOLDER_COLLECTIBLE_FEATHERS_DESC"),                txd = "satchel_textures",   texture = "provision_bird_feather_flight",                 tags = { "CI_TAG_FOLDER_COLLECTIBLE_FEATHERS" } },
    { id = "craft_feathers",                      category = "materials",    title = joaat("CI_TAG_FOLDER_CRAFT_FEATHERS"),                      label = GetStringFromHashKey("CI_TAG_FOLDER_CRAFT_FEATHERS"),                      description = GetStringFromHashKey("CI_TAG_FOLDER_CRAFT_FEATHERS_DESC"),                      txd = "satchel_textures",   texture = "feathers_crafting",                             tags = { "CI_TAG_FOLDER_CRAFT_FEATHERS" } },

    -- Cigarette Card folders
    { id = "cig_card_act_set",                    category = "documents",    title = joaat("CI_TAG_FOLDER_CIG_CARD_ACT_SET"),                    label = GetStringFromHashKey("CI_TAG_FOLDER_CIG_CARD_ACT_SET"),                    description = GetStringFromHashKey("CI_TAG_FOLDER_CIG_CARD_ACT_SET_DESC"),                    txd = "inventory_items",    texture = "folder_cig_card_act_set",                       tags = { "CI_TAG_FOLDER_CIG_CARD_ACT_SET" } },
    { id = "cig_card_aml_set",                    category = "documents",    title = joaat("CI_TAG_FOLDER_CIG_CARD_AML_SET"),                    label = GetStringFromHashKey("CI_TAG_FOLDER_CIG_CARD_AML_SET"),                    description = GetStringFromHashKey("CI_TAG_FOLDER_CIG_CARD_AML_SET_DESC"),                    txd = "inventory_items",    texture = "folder_cig_card_aml_set",                       tags = { "CI_TAG_FOLDER_CIG_CARD_AML_SET" } },
    { id = "cig_card_art_set",                    category = "documents",    title = joaat("CI_TAG_FOLDER_CIG_CARD_ART_SET"),                    label = GetStringFromHashKey("CI_TAG_FOLDER_CIG_CARD_ART_SET"),                    description = GetStringFromHashKey("CI_TAG_FOLDER_CIG_CARD_ART_SET_DESC"),                    txd = "inventory_items",    texture = "folder_cig_card_art_set",                       tags = { "CI_TAG_FOLDER_CIG_CARD_ART_SET" } },
    { id = "cig_card_grl_set",                    category = "documents",    title = joaat("CI_TAG_FOLDER_CIG_CARD_GRL_SET"),                    label = GetStringFromHashKey("CI_TAG_FOLDER_CIG_CARD_GRL_SET"),                    description = GetStringFromHashKey("CI_TAG_FOLDER_CIG_CARD_GRL_SET_DESC"),                    txd = "inventory_items",    texture = "folder_cig_card_grl_set",                       tags = { "CI_TAG_FOLDER_CIG_CARD_GRL_SET" } },
    { id = "cig_card_gun_set",                    category = "documents",    title = joaat("CI_TAG_FOLDER_CIG_CARD_GUN_SET"),                    label = GetStringFromHashKey("CI_TAG_FOLDER_CIG_CARD_GUN_SET"),                    description = GetStringFromHashKey("CI_TAG_FOLDER_CIG_CARD_GUN_SET_DESC"),                    txd = "inventory_items",    texture = "folder_cig_card_gun_set",                       tags = { "CI_TAG_FOLDER_CIG_CARD_GUN_SET" } },
    { id = "cig_card_hor_set",                    category = "documents",    title = joaat("CI_TAG_FOLDER_CIG_CARD_HOR_SET"),                    label = GetStringFromHashKey("CI_TAG_FOLDER_CIG_CARD_HOR_SET"),                    description = GetStringFromHashKey("CI_TAG_FOLDER_CIG_CARD_HOR_SET_DESC"),                    txd = "inventory_items",    texture = "folder_cig_card_hor_set",                       tags = { "CI_TAG_FOLDER_CIG_CARD_HOR_SET" } },
    { id = "cig_card_inv_set",                    category = "documents",    title = joaat("CI_TAG_FOLDER_CIG_CARD_INV_SET"),                    label = GetStringFromHashKey("CI_TAG_FOLDER_CIG_CARD_INV_SET"),                    description = GetStringFromHashKey("CI_TAG_FOLDER_CIG_CARD_INV_SET_DESC"),                    txd = "inventory_items",    texture = "folder_cig_card_inv_set",                       tags = { "CI_TAG_FOLDER_CIG_CARD_INV_SET" } },
    { id = "cig_card_lnd_set",                    category = "documents",    title = joaat("CI_TAG_FOLDER_CIG_CARD_LND_SET"),                    label = GetStringFromHashKey("CI_TAG_FOLDER_CIG_CARD_LND_SET"),                    description = GetStringFromHashKey("CI_TAG_FOLDER_CIG_CARD_LND_SET_DESC"),                    txd = "inventory_items",    texture = "folder_cig_card_lnd_set",                       tags = { "CI_TAG_FOLDER_CIG_CARD_LND_SET" } },
    { id = "cig_card_pam_set",                    category = "documents",    title = joaat("CI_TAG_FOLDER_CIG_CARD_PAM_SET"),                    label = GetStringFromHashKey("CI_TAG_FOLDER_CIG_CARD_PAM_SET"),                    description = GetStringFromHashKey("CI_TAG_FOLDER_CIG_CARD_PAM_SET_DESC"),                    txd = "inventory_items",    texture = "folder_cig_card_pam_set",                       tags = { "CI_TAG_FOLDER_CIG_CARD_PAM_SET" } },
    { id = "cig_card_plt_set",                    category = "documents",    title = joaat("CI_TAG_FOLDER_CIG_CARD_PLT_SET"),                    label = GetStringFromHashKey("CI_TAG_FOLDER_CIG_CARD_PLT_SET"),                    description = GetStringFromHashKey("CI_TAG_FOLDER_CIG_CARD_PLT_SET_DESC"),                    txd = "inventory_items",    texture = "folder_cig_card_plt_set",                       tags = { "CI_TAG_FOLDER_CIG_CARD_PLT_SET" } },
    { id = "cig_card_spt_set",                    category = "documents",    title = joaat("CI_TAG_FOLDER_CIG_CARD_SPT_SET"),                    label = GetStringFromHashKey("CI_TAG_FOLDER_CIG_CARD_SPT_SET"),                    description = GetStringFromHashKey("CI_TAG_FOLDER_CIG_CARD_SPT_SET_DESC"),                    txd = "inventory_items",    texture = "folder_cig_card_spt_set",                       tags = { "CI_TAG_FOLDER_CIG_CARD_SPT_SET" } },
    { id = "cig_card_veh_set",                    category = "documents",    title = joaat("CI_TAG_FOLDER_CIG_CARD_VEH_SET"),                    label = GetStringFromHashKey("CI_TAG_FOLDER_CIG_CARD_VEH_SET"),                    description = GetStringFromHashKey("CI_TAG_FOLDER_CIG_CARD_VEH_SET_DESC"),                    txd = "inventory_items",    texture = "folder_cig_card_veh_set",                       tags = { "CI_TAG_FOLDER_CIG_CARD_VEH_SET" } },

    -- Animal Sample folders
    { id = "animal_samples_desert",               category = "valuables",    title = joaat("CI_TAG_FOLDER_ANIMAL_SAMPLES_DESERT"),               label = GetStringFromHashKey("CI_TAG_FOLDER_ANIMAL_SAMPLES_DESERT"),               description = GetStringFromHashKey("CI_TAG_FOLDER_ANIMAL_SAMPLES_DESERT_DESC"),               txd = "inventory_items_mp", texture = "provision_role_naturalist_sample_desert",       tags = { "CI_TAG_FOLDER_ANIMAL_SAMPLES_DESERT" } },
    { id = "animal_samples_domesticated",         category = "valuables",    title = joaat("CI_TAG_FOLDER_ANIMAL_SAMPLES_DOMESTICATED"),         label = GetStringFromHashKey("CI_TAG_FOLDER_ANIMAL_SAMPLES_DOMESTICATED"),         description = GetStringFromHashKey("CI_TAG_FOLDER_ANIMAL_SAMPLES_DOMESTICATED_DESC"),         txd = "inventory_items_mp", texture = "provision_role_naturalist_sample_domesticated", tags = { "CI_TAG_FOLDER_ANIMAL_SAMPLES_DOMESTICATED" } },
    { id = "animal_samples_forest",               category = "valuables",    title = joaat("CI_TAG_FOLDER_ANIMAL_SAMPLES_FOREST"),               label = GetStringFromHashKey("CI_TAG_FOLDER_ANIMAL_SAMPLES_FOREST"),               description = GetStringFromHashKey("CI_TAG_FOLDER_ANIMAL_SAMPLES_FOREST_DESC"),               txd = "inventory_items_mp", texture = "provision_role_naturalist_sample_forest",       tags = { "CI_TAG_FOLDER_ANIMAL_SAMPLES_FOREST" } },
    { id = "animal_samples_legendary_albino",     category = "valuables",    title = joaat("CI_TAG_FOLDER_ANIMAL_SAMPLES_LEGENDARY_ALBINO"),     label = GetStringFromHashKey("CI_TAG_FOLDER_ANIMAL_SAMPLES_LEGENDARY_ALBINO"),     description = GetStringFromHashKey("CI_TAG_FOLDER_ANIMAL_SAMPLES_LEGENDARY_ALBINO_DESC"),     txd = "inventory_items_mp", texture = "provision_role_naturalist_sample_albino",       tags = { "CI_TAG_FOLDER_ANIMAL_SAMPLES_LEGENDARY_ALBINO" } },
    { id = "animal_samples_legendary_melanistic", category = "valuables",    title = joaat("CI_TAG_FOLDER_ANIMAL_SAMPLES_LEGENDARY_MELANISTIC"), label = GetStringFromHashKey("CI_TAG_FOLDER_ANIMAL_SAMPLES_LEGENDARY_MELANISTIC"), description = GetStringFromHashKey("CI_TAG_FOLDER_ANIMAL_SAMPLES_LEGENDARY_MELANISTIC_DESC"), txd = "inventory_items_mp", texture = "provision_role_naturalist_sample_melanistic",   tags = { "CI_TAG_FOLDER_ANIMAL_SAMPLES_LEGENDARY_MELANISTIC" } },
    { id = "animal_samples_legendary_patterned",  category = "valuables",    title = joaat("CI_TAG_FOLDER_ANIMAL_SAMPLES_LEGENDARY_PATTERNED"),  label = GetStringFromHashKey("CI_TAG_FOLDER_ANIMAL_SAMPLES_LEGENDARY_PATTERNED"),  description = GetStringFromHashKey("CI_TAG_FOLDER_ANIMAL_SAMPLES_LEGENDARY_PATTERNED_DESC"),  txd = "inventory_items_mp", texture = "provision_role_naturalist_sample_patterned",    tags = { "CI_TAG_FOLDER_ANIMAL_SAMPLES_LEGENDARY_PATTERNED" } },
    { id = "animal_samples_legendary_red_blonde", category = "valuables",    title = joaat("CI_TAG_FOLDER_ANIMAL_SAMPLES_LEGENDARY_RED_BLONDE"), label = GetStringFromHashKey("CI_TAG_FOLDER_ANIMAL_SAMPLES_LEGENDARY_RED_BLONDE"), description = GetStringFromHashKey("CI_TAG_FOLDER_ANIMAL_SAMPLES_LEGENDARY_RED_BLONDE_DESC"), txd = "inventory_items_mp", texture = "provision_role_naturalist_sample_redblonde",    tags = { "CI_TAG_FOLDER_ANIMAL_SAMPLES_LEGENDARY_RED_BLONDE" } },
    { id = "animal_samples_mountain",             category = "valuables",    title = joaat("CI_TAG_FOLDER_ANIMAL_SAMPLES_MOUNTAIN"),             label = GetStringFromHashKey("CI_TAG_FOLDER_ANIMAL_SAMPLES_MOUNTAIN"),             description = GetStringFromHashKey("CI_TAG_FOLDER_ANIMAL_SAMPLES_MOUNTAIN_DESC"),             txd = "inventory_items_mp", texture = "provision_role_naturalist_sample_mountain",     tags = { "CI_TAG_FOLDER_ANIMAL_SAMPLES_MOUNTAIN" } },
    { id = "animal_samples_swamp",                category = "valuables",    title = joaat("CI_TAG_FOLDER_ANIMAL_SAMPLES_SWAMP"),                label = GetStringFromHashKey("CI_TAG_FOLDER_ANIMAL_SAMPLES_SWAMP"),                description = GetStringFromHashKey("CI_TAG_FOLDER_ANIMAL_SAMPLES_SWAMP_DESC"),                txd = "inventory_items_mp", texture = "provision_role_naturalist_sample_swamp",        tags = { "CI_TAG_FOLDER_ANIMAL_SAMPLES_SWAMP" } },
}

---------------------------------------------------------------------------------
--                                                                             --
--                             END OF CONFIGURATION                            --
--                                                                             --
-- If you change anything beyond this point, it's on you to make sure it works --
--                                                                             --
---------------------------------------------------------------------------------

Satchel._cacheCategoryItems = {}
Satchel._cacheMenuItems = {}
Satchel._cachePersistence = {}
Satchel._cacheItemDatabase = {}

function InitializePersistence()
    local datastore = DatabindingGetDataContainerFromPath("NativeSatchel")

    if (datastore == 0 or DatabindingIsEntryValid(datastore) ~= 1) then
        datastore = DatabindingAddDataContainerFromPath("", "NativeSatchel")

        -- For ints, the default will be 0, but we like explicit

        DatabindingAddDataInt(datastore, "CurrentCategoryIndex", 0)
        DatabindingAddDataInt(datastore, "CurrentCategoryCount", 0)
        DatabindingAddDataInt(datastore, "CurrentItemIndex", 0)
        DatabindingAddDataInt(datastore, "CurrentItemCount", 0)
        DatabindingAddDataInt(datastore, "CurrentListCount", 0)

        DatabindingAddDataInt(datastore, "RefMainData", 0)
        DatabindingAddDataInt(datastore, "RefSelectedData", 0)
        DatabindingAddDataInt(datastore, "RefSelectedEffectsData", 0)
        DatabindingAddDataInt(datastore, "RefCategoryItems", 0)
        DatabindingAddDataInt(datastore, "RefMenuItems", 0)
        DatabindingAddDataInt(datastore, "RefListItems", 0)
    end
end

function GetPersistedInt(key)
    if (Satchel._cachePersistence[key]) then
        local value = Satchel._cachePersistence[key]
        return tonumber(value) or 0
    end

    local datastore = DatabindingGetDataContainerFromPath("NativeSatchel")

    if (datastore == 0 or DatabindingIsEntryValid(datastore) ~= 1) then
        InitializePersistence()
    end

    local value = DatabindingReadDataIntFromParent(datastore, key)
    return tonumber(value) or 0
end

function SetPersistedInt(key, value)
    local datastore = DatabindingGetDataContainerFromPath("NativeSatchel")

    if (datastore == 0 or DatabindingIsEntryValid(datastore) ~= 1) then
        InitializePersistence()
    end

    DatabindingWriteDataIntFromParent(datastore, key, value)
    Satchel._cachePersistence[key] = value
end

function RefreshHashMaps()
    Satchel.mapCategories = {}
    Satchel.mapCategoriesJoaat = {}

    for index, item in ipairs(Satchel.categories) do
        Satchel.mapCategories[item.id] = index
        Satchel.mapCategoriesJoaat[joaat(item.id)] = index
    end

    Satchel.mapFolders = {}
    Satchel.mapFoldersJoaat = {}

    for index, item in ipairs(Satchel.folders) do
        Satchel.mapFolders[item.id] = index
        Satchel.mapFoldersJoaat[joaat(item.id)] = index
    end

    Satchel.mapItems = {}
    Satchel.mapItemsJoaat = {}

    for index, item in ipairs(Satchel.items) do
        Satchel.mapItems[item.id] = index
        Satchel.mapItemsJoaat[joaat(item.id)] = index
    end
end

function LoadEffectMaps()
    Satchel.effects = {}

    -- These are the effect maps from the base game (catalog_sp and catalog_mp), feel free to add more
    Satchel.effects.data = {
        { id = "EFFECT_HEALTH_MINUS_2",               type = "health",           value = -2, duration = 0 },
        { id = "EFFECT_HEALTH_10",                    type = "health",           value = 10, duration = 0 },
        { id = "EFFECT_HEALTH_OVERPOWERED_2H",        type = "health",           value = 11, duration = 1 },
        { id = "EFFECT_HEALTH_OVERPOWERED_3H",        type = "health",           value = 11, duration = 1 },
        { id = "EFFECT_HEALTH_OVERPOWERED_4H",        type = "health",           value = 11, duration = 2 },
        { id = "EFFECT_HEALTH_OVERPOWERED_6H",        type = "health",           value = 11, duration = 2 },
        { id = "EFFECT_HEALTH_OVERPOWERED_9H",        type = "health",           value = 11, duration = 3 },

        { id = "EFFECT_STAMINA_10",                   type = "stamina",          value = 10, duration = 0 },
        { id = "EFFECT_STAMINA_OVERPOWERED_2H",       type = "stamina",          value = 11, duration = 1 },
        { id = "EFFECT_STAMINA_OVERPOWERED_3H",       type = "stamina",          value = 11, duration = 1 },
        { id = "EFFECT_STAMINA_OVERPOWERED_4H",       type = "stamina",          value = 11, duration = 2 },
        { id = "EFFECT_STAMINA_OVERPOWERED_6H",       type = "stamina",          value = 11, duration = 2 },
        { id = "EFFECT_STAMINA_OVERPOWERED_9H",       type = "stamina",          value = 11, duration = 3 },

        { id = "EFFECT_DEADEYE_10",                   type = "deadeye",          value = 10, duration = 0 },
        { id = "EFFECT_DEADEYE_OVERPOWERED_2H",       type = "deadeye",          value = 11, duration = 1 },
        { id = "EFFECT_DEADEYE_OVERPOWERED_3H",       type = "deadeye",          value = 11, duration = 1 },
        { id = "EFFECT_DEADEYE_OVERPOWERED_4H",       type = "deadeye",          value = 11, duration = 2 },
        { id = "EFFECT_DEADEYE_OVERPOWERED_6H",       type = "deadeye",          value = 11, duration = 2 },
        { id = "EFFECT_DEADEYE_OVERPOWERED_9H",       type = "deadeye",          value = 11, duration = 3 },

        { id = "EFFECT_HEALTH_CORE_MINUS_2",          type = "healthCore",       value = -2, duration = 0 },
        { id = "EFFECT_HEALTH_CORE_MINUS_1",          type = "healthCore",       value = -1, duration = 0 },
        { id = "EFFECT_HEALTH_CORE_1",                type = "healthCore",       value = 1,  duration = 0 },
        { id = "EFFECT_HEALTH_CORE_2",                type = "healthCore",       value = 2,  duration = 0 },
        { id = "EFFECT_HEALTH_CORE_3",                type = "healthCore",       value = 3,  duration = 0 },
        { id = "EFFECT_HEALTH_CORE_4",                type = "healthCore",       value = 4,  duration = 0 },
        { id = "EFFECT_HEALTH_CORE_6",                type = "healthCore",       value = 6,  duration = 0 },
        { id = "EFFECT_HEALTH_CORE_8",                type = "healthCore",       value = 8,  duration = 0 },
        { id = "EFFECT_HEALTH_CORE_GOLD_1D",          type = "healthCore",       value = 12, duration = 4 },
        { id = "EFFECT_HEALTH_CORE_GOLD_72H",         type = "healthCore",       value = 12, duration = 4 },

        { id = "EFFECT_STAMINA_CORE_MINUS_1",         type = "staminaCore",      value = -1, duration = 0 },
        { id = "EFFECT_STAMINA_CORE_1",               type = "staminaCore",      value = 1,  duration = 0 },
        { id = "EFFECT_STAMINA_CORE_2",               type = "staminaCore",      value = 2,  duration = 0 },
        { id = "EFFECT_STAMINA_CORE_3",               type = "staminaCore",      value = 3,  duration = 0 },
        { id = "EFFECT_STAMINA_CORE_4",               type = "staminaCore",      value = 4,  duration = 0 },
        { id = "EFFECT_STAMINA_CORE_5",               type = "staminaCore",      value = 5,  duration = 0 },
        { id = "EFFECT_STAMINA_CORE_6",               type = "staminaCore",      value = 6,  duration = 0 },
        { id = "EFFECT_STAMINA_CORE_8",               type = "staminaCore",      value = 8,  duration = 0 },
        { id = "EFFECT_STAMINA_CORE_GOLD_1D",         type = "staminaCore",      value = 12, duration = 4 },
        { id = "EFFECT_STAMINA_CORE_GOLD_12H",        type = "staminaCore",      value = 12, duration = 4 },
        { id = "EFFECT_STAMINA_CORE_GOLD_36H",        type = "staminaCore",      value = 12, duration = 4 },
        { id = "EFFECT_STAMINA_CORE_GOLD_72H",        type = "staminaCore",      value = 12, duration = 4 },

        { id = "EFFECT_DEADEYE_CORE_MINUS_1",         type = "deadeyeCore",      value = -1, duration = 0 },
        { id = "EFFECT_DEADEYE_CORE_1",               type = "deadeyeCore",      value = 1,  duration = 0 },
        { id = "EFFECT_DEADEYE_CORE_2",               type = "deadeyeCore",      value = 2,  duration = 0 },
        { id = "EFFECT_DEADEYE_CORE_3",               type = "deadeyeCore",      value = 3,  duration = 0 },
        { id = "EFFECT_DEADEYE_CORE_4",               type = "deadeyeCore",      value = 4,  duration = 0 },
        { id = "EFFECT_DEADEYE_CORE_5",               type = "deadeyeCore",      value = 5,  duration = 0 },
        { id = "EFFECT_DEADEYE_CORE_6",               type = "deadeyeCore",      value = 6,  duration = 0 },
        { id = "EFFECT_DEADEYE_CORE_8",               type = "deadeyeCore",      value = 8,  duration = 0 },
        { id = "EFFECT_DEADEYE_CORE_GOLD_1D",         type = "deadeyeCore",      value = 12, duration = 4 },
        { id = "EFFECT_DEADEYE_CORE_GOLD_12H",        type = "deadeyeCore",      value = 12, duration = 4 },
        { id = "EFFECT_DEADEYE_CORE_GOLD_36H",        type = "deadeyeCore",      value = 12, duration = 4 },
        { id = "EFFECT_DEADEYE_CORE_GOLD_72H",        type = "deadeyeCore",      value = 12, duration = 4 },

        { id = "EFFECT_HORSE_HEALTH_5",               type = "horseHealth",      value = 5,  duration = 0 },
        { id = "EFFECT_HORSE_HEALTH_10",              type = "horseHealth",      value = 10, duration = 0 },
        { id = "EFFECT_HORSE_HEALTH_OVERPOWERED_3H",  type = "horseHealth",      value = 11, duration = 1 },
        { id = "EFFECT_HORSE_HEALTH_OVERPOWERED_6H",  type = "horseHealth",      value = 11, duration = 2 },
        { id = "EFFECT_HORSE_HEALTH_OVERPOWERED_9H",  type = "horseHealth",      value = 11, duration = 3 },

        { id = "EFFECT_HORSE_STAMINA_10",             type = "horseStamina",     value = 10, duration = 0 },
        { id = "EFFECT_HORSE_STAMINA_OVERPOWERED_3H", type = "horseStamina",     value = 11, duration = 1 },
        { id = "EFFECT_HORSE_STAMINA_OVERPOWERED_6H", type = "horseStamina",     value = 11, duration = 2 },
        { id = "EFFECT_HORSE_STAMINA_OVERPOWERED_9H", type = "horseStamina",     value = 11, duration = 3 },

        { id = "EFFECT_HORSE_HEALTH_CORE_1",          type = "horseHealthCore",  value = 1,  duration = 0 },
        { id = "EFFECT_HORSE_HEALTH_CORE_2",          type = "horseHealthCore",  value = 2,  duration = 0 },
        { id = "EFFECT_HORSE_HEALTH_CORE_4",          type = "horseHealthCore",  value = 4,  duration = 0 },
        { id = "EFFECT_HORSE_HEALTH_CORE_5",          type = "horseHealthCore",  value = 5,  duration = 0 },
        { id = "EFFECT_HORSE_HEALTH_CORE_GOLD_1D",    type = "horseHealthCore",  value = 12, duration = 4 },
        { id = "EFFECT_HORSE_HEALTH_CORE_GOLD_12H",   type = "horseHealthCore",  value = 12, duration = 4 },

        { id = "EFFECT_HORSE_STAMINA_CORE_1",         type = "horseStaminaCore", value = 1,  duration = 0 },
        { id = "EFFECT_HORSE_STAMINA_CORE_2",         type = "horseStaminaCore", value = 2,  duration = 0 },
        { id = "EFFECT_HORSE_STAMINA_CORE_4",         type = "horseStaminaCore", value = 4,  duration = 0 },
        { id = "EFFECT_HORSE_STAMINA_CORE_5",         type = "horseStaminaCore", value = 5,  duration = 0 },
        { id = "EFFECT_HORSE_STAMINA_CORE_GOLD_1D",   type = "horseStaminaCore", value = 12, duration = 4 },
        { id = "EFFECT_HORSE_STAMINA_CORE_GOLD_12H",  type = "horseStaminaCore", value = 12, duration = 4 },
    }

    -- Since the game will only be in hash, create a hash map
    Satchel.effects.mapEffects = {}
    Satchel.effects.mapEffectsJoaat = {}

    for index, item in ipairs(Satchel.effects.data) do
        Satchel.effects.mapEffects[item.id] = index
        Satchel.effects.mapEffectsJoaat[joaat(item.id)] = index
    end

    -- These are the effect duration IDs to simplify usage
    Satchel.effects.durations =
    {
        [0] = 0,
        [1] = 3059683677,
        [2] = 3969809883,
        [3] = 585722480,
        [4] = 3373446852,
    }
end

function InitializeSatchelMainData()
    local datastore = DatabindingGetDataContainerFromPath("Satchel")

    if (datastore == 0 or DatabindingIsEntryValid(datastore) ~= 1) then
        datastore = DatabindingAddDataContainerFromPath("", "Satchel")

        DatabindingAddDataBool(datastore, "FolderEmpty", false)

        -- Regular use prompt
        DatabindingAddDataHash(datastore, "PromptSelectLabel", joaat("SATCHEL_PROMPT_USE"))
        DatabindingAddDataBool(datastore, "PromptSelectEnabled", true)
        DatabindingAddDataBool(datastore, "PromptSelectVisible", true)

        -- Hold use prompt
        DatabindingAddDataHash(datastore, "PromptHoldSelectLabel", joaat("SATCHEL_PROMPT_BREAKDOWN"))
        DatabindingAddDataBool(datastore, "PromptHoldSelectEnabled", false)
        DatabindingAddDataBool(datastore, "PromptHoldSelectVisible", false)

        -- Discard prompt
        DatabindingAddDataBool(datastore, "PromptDropVisibile", false)

        -- Discard all prompt
        DatabindingAddDataString(datastore, "PromptDiscardAllLabel", GetStringFromHashKey("SATCHEL_PROMPT_DISCARD_ALL"))
        DatabindingAddDataBool(datastore, "PromptDiscardAllEnabled", false)
        DatabindingAddDataBool(datastore, "PromptDiscardAllVisible", false)

        -- Send all prompt
        DatabindingAddDataHash(datastore, "PromptSendLabel", joaat("SATCHEL_PROMPT_USE"))
        DatabindingAddDataBool(datastore, "PromptSendAllVisible", false)
    end

    SetPersistedInt("RefMainData", datastore)
end

function InitializeSatchelSelectedData()
    local datastore = GetPersistedInt("RefSelectedData")

    if (datastore == 0 or DatabindingIsEntryValid(datastore) ~= 1) then
        local parent = GetPersistedInt("RefMainData")

        if (parent == 0 or DatabindingIsEntryValid(parent) ~= 1) then
            print("[NativeSatchel] InitializeSatchelSelectedData: Main data wasn't ready in time!")
            return
        end

        datastore = DatabindingAddDataContainer(parent, "Selected")

        -- Hash for category label
        DatabindingAddDataHash(datastore, "Category", 0)

        -- The current selected category
        DatabindingAddDataInt(datastore, "CategoryIndex", 0)

        -- Amount of categories
        DatabindingAddDataInt(datastore, "CategoryCount", 0)

        -- The category the menu will open to, used when navigating back from folders
        DatabindingAddDataInt(datastore, "DefaultCategoryIndex", 0)

        -- Hash for selected label
        DatabindingAddDataHash(datastore, "Name", 0)

        -- String for selected label
        DatabindingAddDataString(datastore, "NameAsString", "")

        -- Hash for description
        DatabindingAddDataHash(datastore, "Description", 0)

        -- String for description
        DatabindingAddDataString(datastore, "DescriptionAsString", "")

        -- Hash for price label (left)
        DatabindingAddDataString(datastore, "PriceLabel", "")

        -- String for price amount (right)
        DatabindingAddDataString(datastore, "Price", "")

        -- String for items counter (X of Y)
        DatabindingAddDataString(datastore, "IndexDescription", "")

        -- String for footer text
        DatabindingAddDataString(datastore, "Tip", "")

        -- Hash for list items title (Folders)
        DatabindingAddDataHash(datastore, "Folder", 0)
    end

    SetPersistedInt("RefSelectedData", datastore)
end

function InitializeSatchelSelectedEffects()
    local datastore = GetPersistedInt("RefSelectedEffectsData")

    if (datastore == 0 or DatabindingIsEntryValid(datastore) ~= 1) then
        local parent = GetPersistedInt("RefSelectedData")

        if (parent == 0 or DatabindingIsEntryValid(parent) ~= 1) then
            print("[NativeSatchel] InitializeSatchelSelectedEffects: Selected data wasn't ready in time!")
            return
        end

        datastore = DatabindingAddDataContainer(parent, "effects")

        -- Tanks: -10 to -1 | 1 to 10   | 11 for overpowered
        -- Cores: -8 to -1  | 1 to 8    | 12 for overpowered
        -- Duration: See effectDurations enum

        DatabindingAddDataInt(datastore, "health", 0)
        DatabindingAddDataHash(datastore, "healthDurationCategory", 0)

        DatabindingAddDataInt(datastore, "stamina", 0)
        DatabindingAddDataHash(datastore, "staminaDurationCategory", 0)

        DatabindingAddDataInt(datastore, "deadeye", 0)
        DatabindingAddDataHash(datastore, "deadeyeDurationCategory", 0)

        DatabindingAddDataInt(datastore, "healthCore", 0)
        DatabindingAddDataHash(datastore, "healthCoreDurationCategory", 0)

        DatabindingAddDataInt(datastore, "staminaCore", 0)
        DatabindingAddDataHash(datastore, "staminaCoreDurationCategory", 0)

        DatabindingAddDataInt(datastore, "deadeyeCore", 0)
        DatabindingAddDataHash(datastore, "deadeyeCoreDurationCategory", 0)

        DatabindingAddDataInt(datastore, "healthHorse", 0)
        DatabindingAddDataHash(datastore, "healthHorseDurationCategory", 0)

        DatabindingAddDataInt(datastore, "staminaHorse", 0)
        DatabindingAddDataHash(datastore, "staminaHorseDurationCategory", 0)

        DatabindingAddDataInt(datastore, "healthCoreHorse", 0)
        DatabindingAddDataHash(datastore, "healthCoreHorseDurationCategory", 0)

        DatabindingAddDataInt(datastore, "staminaCoreHorse", 0)
        DatabindingAddDataHash(datastore, "staminaCoreHorseDurationCategory", 0)
    end

    SetPersistedInt("RefSelectedEffectsData", datastore)
end

function InitializeSatchelCategories()
    local datastore = GetPersistedInt("RefCategoryItems")

    if (datastore == 0 or DatabindingIsEntryValid(datastore) ~= 1) then
        datastore = DatabindingGetDataContainerFromPath("satchel_category_items")
    end

    SetPersistedInt("RefCategoryItems", datastore)
end

function ClearSatchelCategories()
    local datastore = GetPersistedInt("RefCategoryItems")

    if (datastore == 0 or DatabindingIsEntryValid(datastore) ~= 1) then
        print("[NativeSatchel] ClearSatchelCategories: Category items wasn't ready in time!")
        return
    end

    Satchel._cacheCategoryItems = {}
    SetPersistedInt("CurrentCategoryCount", 0)
    DatabindingSetTemplatedUiItemListSize(datastore, 0)
end

function ReloadSatchelCategories()
    if (GetPersistedInt("CurrentCategoryCount") > 0) then
        ClearSatchelCategories()
    end

    local datastore = GetPersistedInt("RefCategoryItems")
    local datastoreSelected = GetPersistedInt("RefSelectedData")

    if (datastore == 0 or DatabindingIsEntryValid(datastore) ~= 1) then
        print("[NativeSatchel] ReloadSatchelCategories: Category items wasn't ready in time!")
        return
    end

    if (datastoreSelected == 0 or DatabindingIsEntryValid(datastoreSelected) ~= 1) then
        print("[NativeSatchel] ReloadSatchelCategories: Selected data wasn't ready in time!")
        return
    end

    local categoryIndex = 0

    for _, category in ipairs(Satchel.categories) do
        local added = AddCategory(categoryIndex, category)

        if (added and added ~= 0) then
            table.insert(Satchel._cacheCategoryItems, added)
            categoryIndex = categoryIndex + 1
        end
    end

    SetPersistedInt("CurrentCategoryCount", categoryIndex)
    DatabindingSetTemplatedUiItemListSize(datastore, categoryIndex)

    local currentIndex = GetPersistedInt("CurrentCategoryIndex")
    DatabindingWriteDataIntFromParent(datastoreSelected, "CategoryIndex", currentIndex)
    DatabindingWriteDataIntFromParent(datastoreSelected, "DefaultCategoryIndex", currentIndex)
    DatabindingWriteDataIntFromParent(datastoreSelected, "CategoryCount", categoryIndex)
end

function UpdateSatchelCurrentCategory()
    local datastoreSelected = GetPersistedInt("RefSelectedData")

    if (datastoreSelected == 0 or DatabindingIsEntryValid(datastoreSelected) ~= 1) then
        print("[NativeSatchel] UpdateSatchelCurrentCategory: Selected data wasn't ready in time!")
        return
    end

    local currentIndex = GetPersistedInt("CurrentCategoryIndex")
    DatabindingWriteDataIntFromParent(datastoreSelected, "DefaultCategoryIndex", currentIndex)

    for index, datastoreCategory in ipairs(Satchel._cacheCategoryItems) do
        if ((index - 1) == GetPersistedInt("CurrentCategoryIndex")) then
            DatabindingWriteDataBoolFromParent(datastoreCategory, "CurrentCategory", true)
        else
            DatabindingWriteDataBoolFromParent(datastoreCategory, "CurrentCategory", false)
        end
    end
end

function InitializeSatchelMenuItems()
    local datastore = GetPersistedInt("RefMenuItems")

    if (datastore == 0 or DatabindingIsEntryValid(datastore) ~= 1) then
        datastore = DatabindingGetDataContainerFromPath("satchel_menu_items")
    end

    SetPersistedInt("RefMenuItems", datastore)
end

function ClearSatchelMenuItems()
    local datastore = GetPersistedInt("RefMenuItems")

    if (datastore == 0 or DatabindingIsEntryValid(datastore) ~= 1) then
        print("[NativeSatchel] ClearSatchelMenuItems: Menu items wasn't ready in time!")
        return
    end

    Satchel._cacheMenuItems = {}
    SetPersistedInt("CurrentItemCount", 0)
    DatabindingSetTemplatedUiItemListSize(datastore, 0)
end

function NavigateSatchelMenuItems()
    ClearSatchelSelectedData()

    if (GetPersistedInt("CurrentItemCount") > 0) then
        ClearSatchelMenuItems()
    end

    if (GetPersistedInt("CurrentListCount") > 0) then
        ClearSatchelListItems()
    end

    local datastore = GetPersistedInt("RefMenuItems")
    local datastoreSelected = GetPersistedInt("RefSelectedData")

    if (datastore == 0 or DatabindingIsEntryValid(datastore) ~= 1) then
        print("[NativeSatchel] NavigateSatchelMenuItems: Menu items wasn't ready in time!")
        return
    end

    if (datastoreSelected == 0 or DatabindingIsEntryValid(datastoreSelected) ~= 1) then
        print("[NativeSatchel] NavigateSatchelMenuItems: Selected data wasn't ready in time!")
        return
    end

    local currentCategoryIndex = DatabindingReadDataIntFromParent(datastoreSelected, "CategoryIndex")
    SetPersistedInt("CurrentCategoryIndex", currentCategoryIndex)

    UpdateSatchelCurrentCategory()

    -- Since the game is zero-based but LUA 1-based, increment
    local categoryKey = currentCategoryIndex + 1
    local category = Satchel.categories[categoryKey]

    if (not category) then
        print("[NativeSatchel] NavigateSatchelMenuItems: Could not identify category at key " .. categoryKey)
        return
    end

    DatabindingWriteDataHashStringFromParent(datastoreSelected, "Category", category.title)

    local filteredIndex = 0
    local folderItems = {}

    for _, item in ipairs(Satchel.items) do
        if (not category.recent and item.folder) then
            if (folderItems[item.folder] == nil) then
                folderItems[item.folder] = {}
            end

            table.insert(folderItems[item.folder], item)
        elseif (not Satchel.enableFolderItemsInRecent and category.recent and item.folder) then
            -- Skip items in folders for recent category
        elseif ((category.recent and filteredIndex < 48) or (item.category == category.id)) then
            local added = AddMenuItem(filteredIndex, item)

            if (added and added ~= 0) then
                table.insert(Satchel._cacheMenuItems, added)
                filteredIndex = filteredIndex + 1
            end
        end
    end

    for folderKey, items in pairs(folderItems) do
        local folderIndex = Satchel.mapFolders[folderKey]
        local folder = Satchel.folders[folderIndex]

        if (folder and (folder.category == category.id)) then
            local added = AddMenuFolder(filteredIndex, folder)

            if (added and added ~= 0) then
                table.insert(Satchel._cacheMenuItems, added)
                filteredIndex = filteredIndex + 1
            end
        end
    end

    SetPersistedInt("CurrentItemCount", filteredIndex)
    DatabindingSetTemplatedUiItemListSize(datastore, filteredIndex)

    UpdateSatchelIndexDescription()

    if (filteredIndex < 1) then
        EmptyCategorySatchelSelectedData(category)
    end
end

function UpdateSatchelPrompts(item)
    local datastoreMain = GetPersistedInt("RefMainData")

    if (datastoreMain == 0 or DatabindingIsEntryValid(datastoreMain) ~= 1) then
        print("[NativeSatchel] UpdateSatchelPrompts: Main data wasn't ready in time!")
        return
    end

    -- Regular use prompt
    local selectLabel = 0
    local selectEnabled = true
    local selectVisible = true

    if (item.drinkable) then
        selectLabel = joaat("SATCHEL_PROMPT_DRINK")
        selectEnabled = Satchel.allowDrinking or false
    elseif (item.edible) then
        selectLabel = joaat("SATCHEL_PROMPT_EAT")
        selectEnabled = Satchel.allowEating or false
    elseif (item.readable) then
        selectLabel = joaat("READ")
        selectEnabled = Satchel.allowReading or false
    elseif (item.consumable) then
        selectLabel = joaat("SATCHEL_PROMPT_USE")
        selectEnabled = Satchel.allowUsing or false
    else
        selectEnabled = false
    end

    -- Hold use prompt
    local holdSelectLabel = 0
    local holdSelectEnabled = false
    local holdSelectVisible = false

    if (item.breakable) then
        selectEnabled = false
        selectVisible = false

        holdSelectLabel = joaat("SATCHEL_PROMPT_BREAKDOWN")
        holdSelectEnabled = Satchel.allowBreakdown or false
        holdSelectVisible = true
    elseif (item.cookable) then
        selectEnabled = false
        selectVisible = false

        holdSelectLabel = joaat("SATCHEL_PROMPT_COOK")
        holdSelectEnabled = Satchel.allowCooking or false
        holdSelectVisible = true
    end

    -- Discard prompt
    local dropVisible = item.discardable or false
    local dropAllVisible = false

    if (item.count and item.count > 1) then
        dropAllVisible = true
    end

    if (not Satchel.allowDiscarding) then
        dropVisible = false
        dropAllVisible = false
    end

    -- Regular use prompt
    DatabindingWriteDataHashStringFromParent(datastoreMain, "PromptSelectLabel", selectLabel)
    DatabindingWriteDataBoolFromParent(datastoreMain, "PromptSelectEnabled", selectEnabled)
    DatabindingWriteDataBoolFromParent(datastoreMain, "PromptSelectVisible", selectVisible)

    -- Hold use prompt
    DatabindingWriteDataHashStringFromParent(datastoreMain, "PromptHoldSelectLabel", holdSelectLabel)
    DatabindingWriteDataBoolFromParent(datastoreMain, "PromptHoldSelectEnabled", holdSelectEnabled)
    DatabindingWriteDataBoolFromParent(datastoreMain, "PromptHoldSelectVisible", holdSelectVisible)

    -- Discard prompt
    DatabindingWriteDataBoolFromParent(datastoreMain, "PromptDropVisibile", dropVisible)

    -- Discard all prompt
    DatabindingWriteDataStringFromParent(datastoreMain, "PromptDiscardAllLabel", GetStringFromHashKey("SATCHEL_PROMPT_DISCARD_ALL"))
    DatabindingWriteDataBoolFromParent(datastoreMain, "PromptDiscardAllEnabled", dropAllVisible)
    DatabindingWriteDataBoolFromParent(datastoreMain, "PromptDiscardAllVisible", dropAllVisible)

    -- Send all prompt
    DatabindingWriteDataHashStringFromParent(datastoreMain, "PromptSendLabel", joaat("SATCHEL_PROMPT_USE"))
    DatabindingWriteDataBoolFromParent(datastoreMain, "PromptSendAllVisible", false)
end

function UpdateSatchelIndexDescription(type)
    local datastoreSelected = GetPersistedInt("RefSelectedData")

    if (datastoreSelected == 0 or DatabindingIsEntryValid(datastoreSelected) ~= 1) then
        print("[NativeSatchel] UpdateSatchelIndexDescription: Selected data wasn't ready in time!")
        return
    end

    local total = 0

    if (type == "item") then
        total = GetPersistedInt("CurrentItemCount")
    else
        total = GetPersistedInt("CurrentListCount")
    end

    local indexDescription = ""

    -- If there are more than 16 items (scrolling), add a "X of Y" counter
    if (total > 16) then
        indexDescription = GetStringFromHashKey("ENTRY_COUNTER")
        indexDescription = indexDescription:gsub("~1~", GetPersistedInt("CurrentItemIndex") + 1)
        indexDescription = indexDescription:gsub("~2~", total)
    end

    DatabindingWriteStringFromParent(datastoreSelected, "IndexDescription", indexDescription)
end

function UpdateSatchelSelectedData(itemId, folderId)
    if (not itemId and not folderId) then
        print("[NativeSatchel] UpdateSatchelSelectedData: Could not determine item to update")
        return
    end

    local datastoreSelected = GetPersistedInt("RefSelectedData")

    if (datastoreSelected == 0 or DatabindingIsEntryValid(datastoreSelected) ~= 1) then
        print("[NativeSatchel] UpdateSatchelSelectedData: Selected data wasn't ready in time!")
        return
    end

    local id = nil
    local count = nil
    local maxCount = nil

    -- The following could be set through catalog
    local label = nil
    local description = nil
    local effectIds = {}
    local discardable = nil
    local breakable = nil
    local cookable = nil
    local consumable = nil
    local drinkable = nil
    local edible = nil
    local readable = nil

    if (itemId) then
        local item = Satchel.items[itemId]

        if (not item) then
            print("[NativeSatchel] UpdateSatchelSelectedData: Could not determine item for ID " .. itemId)
            return
        end

        id = item.id
        count = item.count
        maxCount = item.maxCount

        if (item.catalog) then
            local database = GetItemFromDatabase(item.catalog)

            label = database.label or id
            description = database.description or ""
            effectIds = database.effectIds or {}
            discardable = database.discardable or false
            breakable = database.breakable or false
            cookable = database.cookable or false
            consumable = database.consumable or false
            drinkable = database.drinkable or false
            edible = database.edible or false
            readable = database.readable or false
        else
            label = item.label or id
            description = item.description or ""
            effectIds = item.effects or {}
            discardable = item.discardable or false
            breakable = item.breakable or false
            cookable = item.cookable or false
            consumable = item.consumable or false
            drinkable = item.drinkable or false
            edible = item.edible or false
            readable = item.readable or false
        end

        UpdateSatchelPrompts({
            count = count,
            discardable = discardable,
            breakable = breakable,
            cookable = cookable,
            consumable = consumable,
            drinkable = drinkable,
            edible = edible,
            readable = readable,
        })
    else
        local folder = Satchel.folders[folderId]

        if (not folder) then
            print("[NativeSatchel] UpdateSatchelSelectedData: Could not determine folder for ID " .. folderId)
            return
        end

        id = folder.id
        label = folder.label or ""
        description = folder.description or ""
    end

    if (label) then
        DatabindingWriteDataHashStringFromParent(datastoreSelected, "Name", 0)
        DatabindingWriteStringFromParent(datastoreSelected, "NameAsString", label)
    end

    if (description) then
        DatabindingWriteDataHashStringFromParent(datastoreSelected, "Description", 0)
        DatabindingWriteStringFromParent(datastoreSelected, "DescriptionAsString", description)
    end

    local tipDescription = ""

    if (count and count > 0) then
        if (maxCount) then
            if (maxCount == 1) then
                tipDescription = GetStringFromHashKey("SATCHEL_TIP_UNIQUE")
            elseif (count < maxCount) then
                tipDescription = GetStringFromHashKey("SATCHEL_TIP_CAPACITY")
                tipDescription = tipDescription:gsub("~1~", count)
                tipDescription = tipDescription:gsub("~2~", maxCount)
            else
                tipDescription = GetStringFromHashKey("SATCHEL_TIP_CAPACITY_FULL")
                tipDescription = tipDescription:gsub("~1~", count)
                tipDescription = tipDescription:gsub("~2~", maxCount)
            end
        else
            tipDescription = GetStringFromHashKey("SATCHEL_TIP_INFINITE")
            tipDescription = tipDescription:gsub("~1~", count)
        end
    end

    DatabindingWriteStringFromParent(datastoreSelected, "Tip", tipDescription)

    UpdateSatchelSelectedEffects(effectIds)
end

function EmptyCategorySatchelSelectedData(category)
    local datastoreSelected = GetPersistedInt("RefSelectedData")

    if (datastoreSelected == 0 or DatabindingIsEntryValid(datastoreSelected) ~= 1) then
        print("[NativeSatchel] EmptyCategorySatchelSelectedData: Selected data wasn't ready in time!")
        return
    end

    local name = category.label or ""
    local description = category.description or ""

    DatabindingWriteDataHashStringFromParent(datastoreSelected, "Name", 0)
    DatabindingWriteStringFromParent(datastoreSelected, "NameAsString", name)
    DatabindingWriteDataHashStringFromParent(datastoreSelected, "Description", 0)
    DatabindingWriteStringFromParent(datastoreSelected, "DescriptionAsString", description)
end

function ClearSatchelSelectedData()
    local datastoreSelected = GetPersistedInt("RefSelectedData")

    if (datastoreSelected == 0 or DatabindingIsEntryValid(datastoreSelected) ~= 1) then
        print("[NativeSatchel] ClearSatchelSelectedData: Selected data wasn't ready in time!")
        return
    end

    DatabindingWriteDataHashStringFromParent(datastoreSelected, "Name", 0)
    DatabindingWriteStringFromParent(datastoreSelected, "NameAsString", "")
    DatabindingWriteDataHashStringFromParent(datastoreSelected, "Description", 0)
    DatabindingWriteStringFromParent(datastoreSelected, "DescriptionAsString", "")
    DatabindingWriteStringFromParent(datastoreSelected, "Tip", "")

    ClearSatchelSelectedEffects()
end

function UpdateSatchelSelectedEffects(ids)
    local datastoreEffects = GetPersistedInt("RefSelectedEffectsData")

    if (datastoreEffects == 0 or DatabindingIsEntryValid(datastoreEffects) ~= 1) then
        print("[NativeSatchel] UpdateSatchelSelectedEffects: Selected data wasn't ready in time!")
        return
    end

    -- Check the IDs for valid mapped effects
    local validEffects = {}

    for _, hash in ipairs(ids) do
        if (Satchel.effects.mapEffectsJoaat[hash]) then
            local index = Satchel.effects.mapEffectsJoaat[hash]
            table.insert(validEffects, Satchel.effects.data[index])
        end
    end

    ClearSatchelSelectedEffects()

    -- If we don't have any valid mapped effects, we're done here
    if (#validEffects == 0) then
        return
    end

    for _, data in ipairs(validEffects) do
        if (data.type == "health") then
            DatabindingWriteDataIntFromParent(datastoreEffects, "health", data.value)

            local duration = Satchel.effects.durations[data.duration]
            DatabindingWriteDataHashStringFromParent(datastoreEffects, "healthDurationCategory", duration)
        end

        if (data.type == "stamina") then
            DatabindingWriteDataIntFromParent(datastoreEffects, "stamina", data.value)

            local duration = Satchel.effects.durations[data.duration]
            DatabindingWriteDataHashStringFromParent(datastoreEffects, "staminaDurationCategory", duration)
        end

        if (data.type == "deadeye") then
            DatabindingWriteDataIntFromParent(datastoreEffects, "deadeye", data.value)

            local duration = Satchel.effects.durations[data.duration]
            DatabindingWriteDataHashStringFromParent(datastoreEffects, "deadeyeDurationCategory", duration)
        end

        if (data.type == "healthCore") then
            DatabindingWriteDataIntFromParent(datastoreEffects, "healthCore", data.value)

            local duration = Satchel.effects.durations[data.duration]
            DatabindingWriteDataHashStringFromParent(datastoreEffects, "healthCoreDurationCategory", duration)
        end

        if (data.type == "staminaCore") then
            DatabindingWriteDataIntFromParent(datastoreEffects, "staminaCore", data.value)

            local duration = Satchel.effects.durations[data.duration]
            DatabindingWriteDataHashStringFromParent(datastoreEffects, "staminaCoreDurationCategory", duration)
        end

        if (data.type == "deadeyeCore") then
            DatabindingWriteDataIntFromParent(datastoreEffects, "deadeyeCore", data.value)

            local duration = Satchel.effects.durations[data.duration]
            DatabindingWriteDataHashStringFromParent(datastoreEffects, "deadeyeCoreDurationCategory", duration)
        end

        if (data.type == "horseHealth") then
            DatabindingWriteDataIntFromParent(datastoreEffects, "healthHorse", data.value)

            local duration = Satchel.effects.durations[data.duration]
            DatabindingWriteDataHashStringFromParent(datastoreEffects, "healthHorseDurationCategory", duration)
        end

        if (data.type == "horseStamina") then
            DatabindingWriteDataIntFromParent(datastoreEffects, "staminaHorse", data.value)

            local duration = Satchel.effects.durations[data.duration]
            DatabindingWriteDataHashStringFromParent(datastoreEffects, "staminaHorseDurationCategory", duration)
        end

        if (data.type == "horseHealthCore") then
            DatabindingWriteDataIntFromParent(datastoreEffects, "healthCoreHorse", data.value)

            local duration = Satchel.effects.durations[data.duration]
            DatabindingWriteDataHashStringFromParent(datastoreEffects, "healthCoreHorseDurationCategory", duration)
        end

        if (data.type == "horseStaminaCore") then
            DatabindingWriteDataIntFromParent(datastoreEffects, "staminaCoreHorse", data.value)

            local duration = Satchel.effects.durations[data.duration]
            DatabindingWriteDataHashStringFromParent(datastoreEffects, "staminaCoreHorseDurationCategory", duration)
        end
    end
end

function ClearSatchelSelectedEffects()
    local datastoreSelected = GetPersistedInt("RefSelectedEffectsData")

    if (datastoreSelected == 0 or DatabindingIsEntryValid(datastoreSelected) ~= 1) then
        print("[NativeSatchel] ClearSatchelSelectedEffects: Selected effects data wasn't ready in time!")
        return
    end

    DatabindingWriteDataIntFromParent(datastoreSelected, "health", 0)
    DatabindingWriteDataHashStringFromParent(datastoreSelected, "healthDurationCategory", 0)

    DatabindingWriteDataIntFromParent(datastoreSelected, "stamina", 0)
    DatabindingWriteDataHashStringFromParent(datastoreSelected, "staminaDurationCategory", 0)

    DatabindingWriteDataIntFromParent(datastoreSelected, "deadeye", 0)
    DatabindingWriteDataHashStringFromParent(datastoreSelected, "deadeyeDurationCategory", 0)

    DatabindingWriteDataIntFromParent(datastoreSelected, "healthCore", 0)
    DatabindingWriteDataHashStringFromParent(datastoreSelected, "healthCoreDurationCategory", 0)

    DatabindingWriteDataIntFromParent(datastoreSelected, "staminaCore", 0)
    DatabindingWriteDataHashStringFromParent(datastoreSelected, "staminaCoreDurationCategory", 0)

    DatabindingWriteDataIntFromParent(datastoreSelected, "deadeyeCore", 0)
    DatabindingWriteDataHashStringFromParent(datastoreSelected, "deadeyeCoreDurationCategory", 0)

    DatabindingWriteDataIntFromParent(datastoreSelected, "healthHorse", 0)
    DatabindingWriteDataHashStringFromParent(datastoreSelected, "healthHorseDurationCategory", 0)

    DatabindingWriteDataIntFromParent(datastoreSelected, "staminaHorse", 0)
    DatabindingWriteDataHashStringFromParent(datastoreSelected, "staminaHorseDurationCategory", 0)

    DatabindingWriteDataIntFromParent(datastoreSelected, "healthCoreHorse", 0)
    DatabindingWriteDataHashStringFromParent(datastoreSelected, "healthCoreHorseDurationCategory", 0)

    DatabindingWriteDataIntFromParent(datastoreSelected, "staminaCoreHorse", 0)
    DatabindingWriteDataHashStringFromParent(datastoreSelected, "staminaCoreHorseDurationCategory", 0)
end

function InitializeSatchelListItems()
    local datastore = GetPersistedInt("RefListItems")

    if (datastore == 0 or DatabindingIsEntryValid(datastore) ~= 1) then
        datastore = DatabindingGetDataContainerFromPath("satchel_list_items")
    end

    SetPersistedInt("RefListItems", datastore)
end

function ClearSatchelListItems()
    local datastore = GetPersistedInt("RefListItems")

    if (datastore == 0 or DatabindingIsEntryValid(datastore) ~= 1) then
        print("[NativeSatchel] ClearSatchelListItems: List items wasn't ready in time!")
        return
    end

    SetPersistedInt("CurrentListCount", 0)
    DatabindingSetTemplatedUiItemListSize(datastore, 0)
end

function PreloadSatchelListItems(folderId)
    if (GetPersistedInt("CurrentListCount") > 0) then
        ClearSatchelListItems()
    end

    local datastore = GetPersistedInt("RefListItems")
    local datastoreSelected = GetPersistedInt("RefSelectedData")

    if (datastore == 0 or DatabindingIsEntryValid(datastore) ~= 1) then
        print("[NativeSatchel] PreloadSatchelListItems: List items wasn't ready in time!")
        return
    end

    if (datastoreSelected == 0 or DatabindingIsEntryValid(datastoreSelected) ~= 1) then
        print("[NativeSatchel] PreloadSatchelListItems: Selected data wasn't ready in time!")
        return
    end

    if (not folderId) then
        print("[NativeSatchel] PreloadSatchelListItems: No folder ID provided!")
        return
    end

    local folder = Satchel.folders[folderId]

    DatabindingWriteDataHashStringFromParent(datastoreSelected, "Folder", folder.title)

    local listIndex = 0

    for _, item in ipairs(Satchel.items) do
        if (item.folder and item.folder == folder.id) then
            local added = AddListItem(listIndex, item)

            if (added and added ~= 0) then
                table.insert(Satchel._cacheMenuItems, added)
                listIndex = listIndex + 1
            end
        end
    end

    SetPersistedInt("CurrentListCount", listIndex)
    DatabindingSetTemplatedUiItemListSize(datastore, listIndex)
end

function NavigateSatchelListItems(folderId)
    if (not folderId) then
        print("[NativeSatchel] NavigateSatchelListItems: Could not determine folder")
        return
    end

    ClearSatchelSelectedData()
    UpdateSatchelIndexDescription("folder")
end

function EventItemFocused(index, parameter, datastore)
    local selectedKey = DatabindingReadDataHashStringFromParent(datastore, "item")

    -- Sometimes the UI doesn't properly focus on an item, this is a game bug
    -- You can also see this happening by switching from first to last rapidly
    if (not selectedKey or selectedKey == 0) then
        return
    end

    local itemIndex = Satchel.mapItemsJoaat[selectedKey]
    local item = nil
    local itemId = nil
    if (itemIndex) then item = Satchel.mapItems[itemIndex] end
    if (item) then itemId = item.id end

    local folderIndex = Satchel.mapFoldersJoaat[selectedKey]
    local folder = nil
    local folderId = nil
    if (folderIndex) then folder = Satchel.mapFolders[folderIndex] end
    if (folder) then folderId = folder.id end

    SetPersistedInt("CurrentItemIndex", index)
    UpdateSatchelIndexDescription("item")

    if (parameter == joaat("FOLDER_ITEM") or parameter == joaat("USABLE_ITEM")) then
        UpdateSatchelSelectedData(itemIndex, folderIndex)
    end

    if (parameter == joaat("FOLDER_ITEM")) then
        PreloadSatchelListItems(folderIndex)

        if (folderId) then
            TriggerEvent(Satchel.eventHandlerKey .. ":folder_focused", folderId)
        end
    elseif (parameter == joaat("USABLE_ITEM")) then
        if (itemId) then
            TriggerEvent(Satchel.eventHandlerKey .. ":item_focused", itemId)
        end
    else
        print("[NativeSatchel] EventItemFocused: Unknown focus parameter: " .. parameter)
    end
end

function EventItemSelected(index, parameter, datastore)
    local selectedKey = DatabindingReadDataHashStringFromParent(datastore, "item")

    -- Sometimes the UI doesn't properly focus on an item, this is a game bug
    -- You can also see this happening by switching from first to last rapidly
    if (not selectedKey or selectedKey == 0) then
        return
    end

    local itemIndex = Satchel.mapItemsJoaat[selectedKey]
    local item = nil
    local itemId = nil
    if (itemIndex) then item = Satchel.items[itemIndex] end
    if (item) then itemId = item.id end

    local folderIndex = Satchel.mapFoldersJoaat[selectedKey]
    local folder = nil
    local folderId = nil
    if (folderIndex) then folder = Satchel.folders[folderIndex] end
    if (folder) then folderId = folder.id end

    if (parameter == joaat("FOLDER_ITEM")) then
        NavigateSatchelListItems(folderIndex)

        if (folderId) then
            TriggerEvent(Satchel.eventHandlerKey .. ":folder_opened", folderId)
        end
    elseif (parameter == joaat("USABLE_ITEM")) then
        if (itemId) then
            TriggerEvent(Satchel.eventHandlerKey .. ":item_used", itemId)
        end
    elseif (parameter == joaat("BREAKABLE_ITEM")) then
        if (itemId) then
            TriggerEvent(Satchel.eventHandlerKey .. ":item_broken", itemId)
        end
    elseif (parameter == joaat("DROP_ITEM")) then
        if (itemId) then
            TriggerEvent(Satchel.eventHandlerKey .. ":item_discarded", itemId)
        end
    elseif (parameter == joaat("DISCARD_ALL")) then
        if (itemId) then
            TriggerEvent(Satchel.eventHandlerKey .. ":item_discarded_all", itemId)
        end
    elseif (parameter == joaat("SEND_ALL")) then
        if (itemId) then
            TriggerEvent(Satchel.eventHandlerKey .. ":item_sent_all", itemId)
        end
    else
        print("[NativeSatchel] EventItemSelected: Unknown select parameter: " .. parameter)
    end
end

function GetItemFromDatabase(item)
    local hash = joaat(item)

    if (Satchel._cacheItemDatabase[hash]) then
        return Satchel._cacheItemDatabase[hash]
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
        effectIds = {},
        stars = 0,
        special = false,
        discardable = true,
        breakable = false,
        cookable = false,
        consumable = false,
        drinkable = false,
        edible = false,
        readable = false,
    }

    if (ItemdatabaseIsKeyValid(hash, 0) == 0) then
        return result
    end

    local uiData = ItemdatabaseGetUiData(hash)
    if (uiData) then
        result.label = GetStringFromHashKey(uiData.label)
        result.labelHash = uiData.label
        result.description = GetStringFromHashKey(uiData.description)
        result.descriptionHash = uiData.description
        result.txd = uiData.textureDict
        result.texture = uiData.textureId
    end

    local effectIds = ItemdatabaseGetEffectIds(hash)
    if (effectIds) then
        result.effectIds = effectIds
    end

    local tagIds = ItemdatabaseGetTagIds(hash)
    for _, value in pairs(tagIds) do
        if (value == joaat("CI_TAG_ITEM_OVERPOWERED") or value == joaat("CI_TAG_ITEM_QUALITY_LEGENDARY")) then
            result.special = true
        end

        if (not Satchel.ignoreCannotDiscardTag and value == joaat("CI_TAG_ITEM_CANNOT_DISCARD")) then
            result.discardable = false
        end

        if (value == joaat("CI_TAG_ITEM_CAN_BREAKDOWN")) then
            result.breakable = true
        end

        if (hash ~= joaat("PROVISION_ROTTEN_MEAT") and hash ~= joaat("CONSUMABLE_CORNEDBEEF_CAN")) then
            if (value == joaat("CI_TAG_ITEM_MEAT_ANIMAL") or value == joaat("CI_TAG_ITEM_MEAT_FISH")) then
                result.cookable = true
            end
        end

        if (value == joaat("CI_TAG_ITEM_CONSUMABLE")) then
            result.consumable = true
        end

        if (value == -273840653 or value == 238865292 or value == 999632878 or value == 1130235258 or value == 1177617310) then
            result.drinkable = true
        end

        if (value == -1915958659 or value == -809056541 or value == 89124942 or value == 1451036371 or value == 1859991422 or value == 1891031775) then
            result.edible = true
        end

        if (value == joaat("CI_TAG_ITEM_DOCUMENT")) then
            result.readable = true
        end

        if (Satchel.enableAutoCategorization) then
            for _, category in pairs(Satchel.categories) do
                for _, tag in pairs(category.tags) do
                    if (value == joaat(tag)) then
                        result.category = category.id
                    end
                end
            end

            if (Satchel.enableAutoFolderAssignment) then
                for _, folder in pairs(Satchel.folders) do
                    for _, tag in pairs(folder.tags) do
                        if (value == joaat(tag)) then
                            result.folder = folder.id
                        end
                    end
                end
            end
        end
    end

    if (not result.category and Satchel.enableAutoCategorization) then
        print("[NativeSatchel] GetItemFromDatabase: Could not auto-assign category for item " .. item)
    end

    local isQualityLegendary = InventoryIsInventoryItemFlagEnabled(hash, 1 << 2)
    local isQualityPerfect = InventoryIsInventoryItemFlagEnabled(hash, 1 << 30)
    local isQualityHigh = InventoryIsInventoryItemFlagEnabled(hash, 1 << 29)
    local isQualityPoor = InventoryIsInventoryItemFlagEnabled(hash, 1 << 28)

    if (isQualityLegendary == 1) then
        result.special = true
        result.stars = 3
    elseif (isQualityPerfect == 1) then
        result.stars = 3
    elseif (isQualityHigh == 1) then
        result.stars = 2
    elseif (isQualityPoor == 1) then
        result.stars = 1
    else
        result.stars = 0
    end

    Satchel._cacheItemDatabase[hash] = result

    return result
end

function EnsureTxdIsLoaded(txd)
    local valid = DoesStreamedTextureDictExist(txd)

    if (not valid) then
        print("[NativeSatchel] EnsureTxdIsLoaded: Invalid TXD requested: " .. txd)
        return
    end

    local loaded = HasStreamedTextureDictLoaded(txd)

    if (not loaded) then
        RequestStreamedTextureDict(txd)
    end
end

function AddCategory(index, category)
    local datastoreMain = GetPersistedInt("RefCategoryItems")

    if (datastoreMain == 0 or DatabindingIsEntryValid(datastoreMain) ~= 1) then
        print("[NativeSatchel] AddCategory: Main data wasn't ready in time!")
        return
    end

    if (index == nil or category == nil) then
        print("[NativeSatchel] AddCategory: No index or category provided!")
        return
    end

    local texture = category.texture
    local label = category.label
    local default = category.default

    local id = "Satchel_Category_" .. index
    local data = DatabindingGetDataContainerFromChildIndex(datastoreMain, index)

    -- Set the texture from the "satchel_textures" TXD (eg. satchel_nav_all)
    DatabindingAddDataHash(data, "IconTexture", texture)

    -- This should be set the the current category index
    DatabindingAddDataBool(data, "CurrentCategory", index == 0)

    -- Let me know if you find out where this is shown
    DatabindingAddDataString(data, "name", label)
    DatabindingAddDataHash(data, "hLabel", joaat(label))

    DatabindingSetTemplatedUiItemHashAlias(datastoreMain, index, joaat("category_item"))

    return data
end

function AddMenuItem(index, item)
    local datastoreMain = GetPersistedInt("RefMenuItems")

    if (datastoreMain == 0 or DatabindingIsEntryValid(datastoreMain) ~= 1) then
        print("[NativeSatchel] AddMenuItem: Main data wasn't ready in time!")
        return
    end

    if (index == nil or item == nil) then
        print("[NativeSatchel] AddMenuItem: No index or item provided!")
        return
    end

    local id = item.id
    local hash = joaat(id)
    local count = item.count or 1
    local maxCount = item.maxCount or nil

    -- The following could be set through catalog
    local label = nil
    local txd = nil
    local texture = nil
    local special = nil
    local stars = nil

    if (item.catalog) then
        local database = GetItemFromDatabase(item.catalog)

        label = database.label or id
        txd = database.txd or "inventory_items"
        texture = database.texture or "_placeholder"
        special = database.special or false
        stars = database.stars or 0
    else
        label = item.label or id
        txd = item.txd or "inventory_items"
        texture = item.texture or "_placeholder"
        special = item.special or false
        stars = item.stars or 0
    end

    EnsureTxdIsLoaded(txd)

    local data = DatabindingGetDataContainerFromChildIndex(datastoreMain, index)

    DatabindingAddDataHash(data, "item", hash)

    DatabindingAddDataBool(data, "focusable", true)
    DatabindingAddDataHash(data, "color", joaat("COLOR_PURE_WHITE")) -- Colorizes the ENTIRE item (incl count and bg)

    DatabindingAddDataHash(data, "ItemTXD", txd)
    DatabindingAddDataHash(data, "ItemTexture", texture)

    DatabindingAddDataInt(data, "count", count) -- Adds a quantity number to the item

    -- Makes the count red
    if (maxCount and count >= maxCount) then
        DatabindingAddDataBool(data, "maxCount", Satchel.enableRedCountOnMax or false)
    else
        DatabindingAddDataBool(data, "maxCount", false)
    end

    DatabindingAddDataInt(data, "quality", stars) -- Adds quality stars (0 to disable, 1-3 for stars)
    DatabindingAddDataBool(data, "overpowered", special) -- Makes the icon yellow

    DatabindingSetTemplatedUiItemHashAlias(datastoreMain, index, joaat("inventory_item"))

    return data
end

function AddMenuFolder(index, folder)
    local datastoreMain = GetPersistedInt("RefMenuItems")

    if (datastoreMain == 0 or DatabindingIsEntryValid(datastoreMain) ~= 1) then
        print("[NativeSatchel] AddMenuFolder: Main data wasn't ready in time!")
        return
    end

    if (index == nil or folder == nil) then
        print("[NativeSatchel] AddMenuFolder: No index or folder provided!")
        return
    end

    local id = folder.id
    local hash = joaat(id)
    local txd = folder.txd
    local texture = folder.texture

    EnsureTxdIsLoaded(txd)

    local data = DatabindingGetDataContainerFromChildIndex(datastoreMain, index)

    DatabindingAddDataHash(data, "item", hash)

    DatabindingAddDataBool(data, "focusable", true)
    DatabindingAddDataHash(data, "color", joaat("COLOR_PURE_WHITE")) -- Colorizes the ENTIRE item (incl count and bg)

    DatabindingAddDataHash(data, "ItemTXD", txd)
    DatabindingAddDataHash(data, "ItemTexture", texture)

    -- Not sure why, but folders technically support counts
    -- To prevent lingering counts (datacontainer is reused), reset to default
    DatabindingAddDataInt(data, "count", 1)
    DatabindingAddDataBool(data, "maxCount", false)

    DatabindingSetTemplatedUiItemHashAlias(datastoreMain, index, joaat("folder_item"))

    return data
end

function AddListItem(index, item)
    local datastoreMain = GetPersistedInt("RefListItems")

    if (datastoreMain == 0 or DatabindingIsEntryValid(datastoreMain) ~= 1) then
        print("[NativeSatchel] AddListItem: Main data wasn't ready in time!")
        return
    end

    if (index == nil or item == nil) then
        print("[NativeSatchel] AddListItem: No index or item provided!")
        return
    end

    local id = item.id
    local hash = joaat(id)
    local count = item.count
    local maxCount = item.maxCount
    local isEquipped = false

    -- The following could be set through catalog
    local label = nil

    if (item.catalog) then
        local database = GetItemFromDatabase(item.catalog)

        label = database.label or id
    else
        label = item.label or id
    end

    local data = DatabindingGetDataContainerFromChildIndex(datastoreMain, index)

    DatabindingAddDataHash(data, "item", hash)

    DatabindingAddDataBool(data, "focusable", true)
    DatabindingAddDataHash(data, "label", 0)
    DatabindingAddDataString(data, "label_as_string", label)
    DatabindingAddDataHash(data, "color", joaat("COLOR_PURE_WHITE")) -- Colorizes the ENTIRE item (incl count and bg)

    DatabindingAddDataInt(data, "count", count) -- Adds a quantity number to the item

    -- Makes the count red
    if (maxCount and count >= maxCount) then
        DatabindingAddDataBool(data, "maxCount", Satchel.enableRedCountOnMax or false)
    else
        DatabindingAddDataBool(data, "maxCount", false)
    end

    DatabindingAddDataBool(data, "equipped", isEquipped) -- Adds a checkmark after the item

    DatabindingSetTemplatedUiItemHashAlias(datastoreMain, index, joaat("list_item"))

    return data
end

function InitializeData()
    InitializePersistence()
    RefreshHashMaps()
    LoadEffectMaps()
end

function InitializeSatchel()
    Citizen.CreateThread(function ()
        while (true) do
            local menuItems = GetPersistedInt("RefMenuItems")
            local listItems = GetPersistedInt("RefListItems")
            local categoryItems = GetPersistedInt("RefCategoryItems")
            local mainData = GetPersistedInt("RefMainData")

            if (menuItems == 0 or DatabindingIsEntryValid(menuItems) ~= 1) then
                InitializeSatchelMenuItems()
            elseif (listItems == 0 or DatabindingIsEntryValid(listItems) ~= 1) then
                InitializeSatchelListItems()
            elseif (mainData == 0 or DatabindingIsEntryValid(mainData) ~= 1) then
                InitializeSatchelMainData()
                InitializeSatchelSelectedData()
                InitializeSatchelSelectedEffects()
            elseif (categoryItems == 0 or DatabindingIsEntryValid(categoryItems) ~= 1) then
                InitializeSatchelCategories()
            else
                break
            end

            Citizen.Wait(10)
        end

        ReloadSatchelCategories()
        NavigateSatchelMenuItems()
    end)
end

function OpenSatchel()
    Citizen.CreateThread(function()
        SetPersistedInt("CurrentCategoryIndex", 0)

        LaunchUiappByHashWithEntry("satchel", "INGAME")
        InitializeSatchel()

        TriggerEvent(Satchel.eventHandlerKey .. ":satchel_opened")

        while IsUiappRunningByHash(uiAppChannel) == 1 do
            Citizen.Wait(0)
            UiPromptEnablePromptTypeThisFrame(0)
        end

        CloseSatchel()
    end)
end

function CloseSatchel()
    TriggerEvent(Satchel.eventHandlerKey .. ":satchel_closed")
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if IsControlJustPressed(0, "INPUT_OPEN_SATCHEL_MENU") and IsUiappRunningByHash(uiAppChannel) ~= 1 then
            local prompt = 0

            -- Create prompt
            if prompt == 0 then
                prompt = PromptRegisterBegin()
                PromptSetControlAction(prompt, GetHashKey("INPUT_OPEN_SATCHEL_MENU"))
                PromptSetText(prompt, CreateVarString(10, "LITERAL_STRING", "Satchel"))
                UiPromptSetHoldMode(prompt, 750)
                UiPromptSetAttribute(prompt, 2, true)
                UiPromptSetAttribute(prompt, 4, true)
                UiPromptSetAttribute(prompt, 9, true)
                UiPromptSetAttribute(prompt, 10, true) -- kPromptAttrib_NoButtonReleaseCheck. Immediately becomes pressed
                UiPromptSetAttribute(prompt, 17, true) -- kPromptAttrib_NoGroupCheck. Allows to appear in any active group
                PromptRegisterEnd(prompt)

                Citizen.CreateThread(function()
                    Citizen.Wait(100)

                    while UiPromptGetProgress(prompt) ~= 0.0 and UiPromptGetProgress(prompt) ~= 1.0 do
                        Citizen.Wait(0)
                    end

                    if UiPromptGetProgress(prompt) == 1.0 then
                        OpenSatchel()
                    end

                    PromptDelete(prompt)
                    prompt = 0

                    Citizen.Wait(1000)
                end)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if EventsUiIsPending(uiEventChannel) then
            local msg = DataView.ArrayBuffer(8 * 4)
            msg:SetInt32(0, 0)
            msg:SetInt32(8, 0)
            msg:SetInt32(16, 0)
            msg:SetInt32(24, 0)

            if (Citizen.InvokeNative(0x90237103F27F7937, uiEventChannel, msg:Buffer()) ~= 0) then -- EVENTS_UI_PEEK_MESSAGE
                local event = msg:GetInt32(0)
                local index = msg:GetInt32(8)
                local parameter = msg:GetInt32(16)
                local datastore = msg:GetInt32(24)

                if (event == joaat("TAB_PAGE_INCREMENT") or event == joaat("TAB_PAGE_DECREMENT")) then
                    NavigateSatchelMenuItems()
                    TriggerEvent("satchel:tab_changed")
                elseif event == joaat("ITEM_FOCUSED") then
                    EventItemFocused(index, parameter, datastore)
                    TriggerEvent("satchel:item_focused")
                elseif event == joaat("ITEM_SELECTED") then
                    EventItemSelected(index, parameter, datastore)
                    TriggerEvent("satchel:item_selected")
                end
            end

            EventsUiPopMessage(uiEventChannel)
        end
    end
end)

InitializeData()

AddEventHandler("onResourceStart", function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    InitializeData()
end)

AddEventHandler("onResourceStop", function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    if IsUiappActiveByHash(uiAppChannel) then
        CloseUiappByHash(uiAppChannel)
        CloseSatchel()
    end
end)
