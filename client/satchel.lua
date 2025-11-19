local uiAppChannel = joaat("satchel")
local uiEventChannel = joaat("satchel_menu")

Satchel = {}

-- Items
-- This determines which items are visible in the UI by category

-- ID: Any string identifier you want to internally use
-- Count: The amount of items for that specific item
-- Category: Which category the item belongs to, see Satchel.categories
-- Folder: Optional. Groups the item in a folder, see Satchel.folders
-- Catalog: Optional. When set to a string, we'll use catalog_sp and catalog_mp to pre-fill data for you

Satchel.items = {
    { id = "big_game_meat_cooked",           count = 5,  maxCount = nil, special = false, stars = 0, category = "provisions",  folder = "big_game",     catalog = "CONSUMABLE_BIG_GAME_MEAT_COOKED", },
    { id = "fully_custom_item",              count = 1,  maxCount = 1,   special = false, stars = 0, category = "provisions",  folder = nil,            catalog = nil },
    { id = "special_tonic_crafted",          count = 10, maxCount = 10,  special = true,  stars = 0, category = "tonics",      folder = nil,            catalog = "CONSUMABLE_SPECIAL_TONIC_CRAFTED", },
    { id = "bird_feather_flight",            count = 7,  maxCount = 10,  special = false, stars = 0, category = "materials",   folder = nil,            catalog = "PROVISION_BIRD_FEATHER_FLIGHT", },
    { id = "necklace_gold",                  count = 8,  maxCount = nil, special = false, stars = 0, category = "valuables",   folder = nil,            catalog = "PROVISION_NECKLACE_GOLD", },
    { id = "horse_reviver",                  count = 1,  maxCount = nil, special = false, stars = 0, category = "tonics",      folder = nil,            catalog = "CONSUMABLE_HORSE_REVIVER", },
    { id = "prime_beef",                     count = 1,  maxCount = nil, special = false, stars = 0, category = "ingredients", folder = nil,            catalog = "PROVISION_PRIME_BEEF", },
    { id = "herbivore_bait",                 count = 1,  maxCount = nil, special = false, stars = 0, category = "kit",         folder = nil,            catalog = "CONSUMABLE_HERBIVORE_BAIT", },
    { id = "card_ace_swords",                count = 1,  maxCount = nil, special = false, stars = 0, category = "documents",   folder = "cards_swords", catalog = "DOCUMENT_CARD_ACE_SWORDS", },
    { id = "card_eight_swords",              count = 1,  maxCount = nil, special = false, stars = 0, category = "documents",   folder = "cards_swords", catalog = "DOCUMENT_CARD_EIGHT_SWORDS", },
    { id = "card_five_swords",               count = 1,  maxCount = nil, special = false, stars = 0, category = "documents",   folder = "cards_swords", catalog = "DOCUMENT_CARD_FIVE_SWORDS", },
    { id = "card_four_swords",               count = 1,  maxCount = nil, special = false, stars = 0, category = "documents",   folder = "cards_swords", catalog = "DOCUMENT_CARD_FOUR_SWORDS", },
    { id = "card_king_swords",               count = 1,  maxCount = nil, special = false, stars = 0, category = "documents",   folder = "cards_swords", catalog = "DOCUMENT_CARD_KING_SWORDS", },
    { id = "card_knight_swords",             count = 1,  maxCount = nil, special = false, stars = 0, category = "documents",   folder = "cards_swords", catalog = "DOCUMENT_CARD_KNIGHT_SWORDS", },
    { id = "card_nine_swords",               count = 1,  maxCount = nil, special = false, stars = 0, category = "documents",   folder = "cards_swords", catalog = "DOCUMENT_CARD_NINE_SWORDS", },
    { id = "card_page_swords",               count = 1,  maxCount = nil, special = false, stars = 0, category = "documents",   folder = "cards_swords", catalog = "DOCUMENT_CARD_PAGE_SWORDS", },
    { id = "card_queen_swords",              count = 1,  maxCount = nil, special = false, stars = 0, category = "documents",   folder = "cards_swords", catalog = "DOCUMENT_CARD_QUEEN_SWORDS", },
    { id = "card_seven_swords",              count = 1,  maxCount = nil, special = false, stars = 0, category = "documents",   folder = "cards_swords", catalog = "DOCUMENT_CARD_SEVEN_SWORDS", },
    { id = "card_six_swords",                count = 1,  maxCount = nil, special = false, stars = 0, category = "documents",   folder = "cards_swords", catalog = "DOCUMENT_CARD_SIX_SWORDS", },
    { id = "card_ten_swords",                count = 1,  maxCount = nil, special = false, stars = 0, category = "documents",   folder = "cards_swords", catalog = "DOCUMENT_CARD_TEN_SWORDS", },
    { id = "card_three_swords",              count = 1,  maxCount = nil, special = false, stars = 0, category = "documents",   folder = "cards_swords", catalog = "DOCUMENT_CARD_THREE_SWORDS", },
    { id = "card_two_swords",                count = 1,  maxCount = nil, special = false, stars = 0, category = "documents",   folder = "cards_swords", catalog = "DOCUMENT_CARD_TWO_SWORDS", },
    { id = "salmon_can",                     count = 1,  maxCount = nil, special = false, stars = 0, category = "provisions",  folder = nil,            catalog = "CONSUMABLE_SALMON_CAN", },
    { id = "carcass_parrot_high_quality",    count = 1,  maxCount = nil, special = false, stars = 2, category = "materials",   folder = nil,            catalog = "PROVISION_ANIMAL_CARCASS_PARROT_HIGH_QUALITY", },
    { id = "armadillo_skin",                 count = 1,  maxCount = nil, special = false, stars = 0, category = "materials",   folder = nil,            catalog = "PROVISION_ARMADILLO_SKIN", },
    { id = "carcass_wolf_high_quality",      count = 1,  maxCount = nil, special = false, stars = 2, category = "materials",   folder = nil,            catalog = "PROVISION_ANIMAL_CARCASS_WOLF_HIGH_QUALITY", },
    { id = "buckle_silver",                  count = 1,  maxCount = nil, special = false, stars = 0, category = "valuables",   folder = nil,            catalog = "PROVISION_BUCKLE_SILVER", },
    { id = "fish_smallmouth_bass",           count = 1,  maxCount = nil, special = false, stars = 0, category = "materials",   folder = nil,            catalog = "PROVISION_FISH_SMALLMOUTH_BASS", },
    { id = "carcass_deer_poor",              count = 1,  maxCount = nil, special = false, stars = 1, category = "materials",   folder = nil,            catalog = "PROVISION_ANIMAL_CARCASS_DEER_POOR", },
    { id = "carcass_crow_perfect",           count = 1,  maxCount = nil, special = false, stars = 3, category = "materials",   folder = nil,            catalog = "PROVISION_ANIMAL_CARCASS_CROW_PERFECT", },
    { id = "skinned_carcass_pig_perfect",    count = 1,  maxCount = nil, special = false, stars = 0, category = "materials",   folder = nil,            catalog = "PROVISION_SKINNED_CARCASS_PIG_PERFECT", },
    { id = "carcass_songbird_poor",          count = 1,  maxCount = nil, special = false, stars = 1, category = "materials",   folder = nil,            catalog = "PROVISION_ANIMAL_CARCASS_SONGBIRD_POOR", },
    { id = "carcass_cormorant_high_quality", count = 1,  maxCount = nil, special = false, stars = 2, category = "materials",   folder = nil,            catalog = "PROVISION_ANIMAL_CARCASS_CORMORANT_HIGH_QUALITY", },
    { id = "wolf_fur_poor",                  count = 1,  maxCount = nil, special = false, stars = 0, category = "materials",   folder = nil,            catalog = "PROVISION_WOLF_FUR_POOR", },
    { id = "gila_skin",                      count = 1,  maxCount = nil, special = false, stars = 0, category = "materials",   folder = nil,            catalog = "PROVISION_GILA_SKIN", },
    { id = "herb_milkweed",                  count = 1,  maxCount = nil, special = false, stars = 0, category = "ingredients", folder = nil,            catalog = "CONSUMABLE_HERB_MILKWEED", },
    { id = "herb_burdock_root",              count = 1,  maxCount = nil, special = false, stars = 0, category = "ingredients", folder = nil,            catalog = "CONSUMABLE_HERB_BURDOCK_ROOT", },
    { id = "bread_chunk",                    count = 1,  maxCount = nil, special = false, stars = 0, category = "provisions",  folder = nil,            catalog = "CONSUMABLE_BREAD_CHUNK", },
    { id = "exotic_bird_wild_mint_cooked",   count = 1,  maxCount = nil, special = false, stars = 0, category = "provisions",  folder = "exotic_bird",  catalog = "CONSUMABLE_EXOTIC_BIRD_WILD_MINT_COOKED", },
    { id = "gamey_bird_cooked",              count = 1,  maxCount = nil, special = false, stars = 0, category = "provisions",  folder = "gamey_bird",   catalog = "CONSUMABLE_GAMEY_BIRD_COOKED", },
    { id = "cocaine_chewing_gum",            count = 1,  maxCount = nil, special = false, stars = 0, category = "tonics",      folder = nil,            catalog = "CONSUMABLE_COCAINE_CHEWING_GUM", },
    { id = "herb_prairie_poppy",             count = 1,  maxCount = nil, special = false, stars = 0, category = "ingredients", folder = nil,            catalog = "CONSUMABLE_HERB_PRAIRIE_POPPY", },
    { id = "medicine",                       count = 1,  maxCount = nil, special = false, stars = 0, category = "tonics",      folder = nil,            catalog = "CONSUMABLE_MEDICINE", },
    { id = "moonshine",                      count = 1,  maxCount = nil, special = false, stars = 0, category = "tonics",      folder = nil,            catalog = "CONSUMABLE_MOONSHINE", },
    { id = "peach",                          count = 1,  maxCount = nil, special = false, stars = 0, category = "provisions",  folder = nil,            catalog = "CONSUMABLE_PEACH", },
    { id = "cigar",                          count = 1,  maxCount = nil, special = false, stars = 0, category = "provisions",  folder = nil,            catalog = "CONSUMABLE_CIGAR", },
    { id = "snake_oil_used",                 count = 1,  maxCount = nil, special = false, stars = 0, category = "tonics",      folder = nil,            catalog = "CONSUMABLE_SNAKE_OIL_USED", },
    { id = "tenn_whiskey",                   count = 1,  maxCount = nil, special = false, stars = 0, category = "tonics",      folder = "bottles",      catalog = "CONSUMABLE_TENN_WHISKEY", },
    { id = "irish_whiskey",                  count = 1,  maxCount = nil, special = false, stars = 0, category = "tonics",      folder = "bottles",      catalog = "CONSUMABLE_IRISH_WHISKEY", },
    { id = "scotch_whiskey",                 count = 1,  maxCount = nil, special = false, stars = 0, category = "tonics",      folder = "bottles",      catalog = "CONSUMABLE_SCOTCH_WHISKEY", },
    { id = "cyprus_brandy",                  count = 1,  maxCount = nil, special = false, stars = 0, category = "tonics",      folder = "bottles",      catalog = "CONSUMABLE_CYPRUS_BRANDY", },
}

-- Categories
-- This determines what categories are visible in the UI

-- ID: Any string identifier you want to internally use
-- All: Whether the category lists all items (up to 48) in order of being added, does not include folders
-- Texture: The hash of the texture to use, due to UI limitations it has to be in "satchel_textures"
-- Label: The hash of the UI label to use for the category

Satchel.categories = {
    { id = "recent",      all = true,  texture = joaat("satchel_nav_all"),         label = 0x504364F1 },
    { id = "provisions",  all = false, texture = joaat("satchel_nav_provisions"),  label = 0x3B1DCCD8 },
    { id = "tonics",      all = false, texture = joaat("satchel_nav_remedies"),    label = 0x855B3FAE },
    { id = "ingredients", all = false, texture = joaat("satchel_nav_ingredients"), label = 0x3268E974 },
    { id = "materials",   all = false, texture = joaat("satchel_nav_materials"),   label = 0xEB0408D2 },
    { id = "kit",         all = false, texture = joaat("satchel_nav_kit"),         label = 0x7A0D8994 },
    { id = "valuables",   all = false, texture = joaat("satchel_nav_valuables"),   label = 0xFA827B50 },
    { id = "documents",   all = false, texture = joaat("satchel_nav_documents"),   label = 0xFDD0A576 },
}

-- Folders
-- This determines what folders are available in the UI

-- ID: Any string identifier you want to internally use
-- Category: Which category the folder belongs to, see Satchel.categories
-- TXD: The hash of the texture dictionary to use
-- Texture: The hash of the texture to use
-- Label: The hash of the UI label to use for the category
-- Description: The hash of the UI description to use for the category

Satchel.folders = {
    -- Collector
    { id = "arrowheads",       category = "valuables",  txd = joaat("inventory_items_mp"), texture = joaat("provision_arrowhead_set"),          label = joaat("CI_TAG_FOLDER_COLLECTOR_ARROWHEADS"),       description = joaat("CI_TAG_FOLDER_COLLECTOR_ARROWHEADS_DESC") },
    { id = "bottles",          category = "tonics",     txd = joaat("inventory_items_mp"), texture = joaat("consumable_whiskey_set"),           label = joaat("CI_TAG_FOLDER_COLLECTOR_BOTTLES"),          description = joaat("CI_TAG_FOLDER_COLLECTOR_BOTTLES_DESC") },
    { id = "bracelets",        category = "valuables",  txd = joaat("inventory_items_mp"), texture = joaat("provision_jewelry_bracelet_set"),   label = joaat("CI_TAG_FOLDER_COLLECTOR_BRACELETS"),        description = joaat("CI_TAG_FOLDER_COLLECTOR_BRACELETS_DESC") },
    { id = "cards_cups",       category = "documents",  txd = joaat("inventory_items_mp"), texture = joaat("document_card_cups_set"),           label = joaat("CI_TAG_FOLDER_COLLECTOR_CARD_CUPS"),        description = joaat("CI_TAG_FOLDER_COLLECTOR_CARD_CUPS_DESC") },
    { id = "cards_pentacles",  category = "documents",  txd = joaat("inventory_items_mp"), texture = joaat("document_card_pentacles_set"),      label = joaat("CI_TAG_FOLDER_COLLECTOR_CARD_PENTACLES"),   description = joaat("CI_TAG_FOLDER_COLLECTOR_CARD_PENTACLES_DESC") },
    { id = "cards_swords",     category = "documents",  txd = joaat("inventory_items_mp"), texture = joaat("document_card_swords_set"),         label = joaat("CI_TAG_FOLDER_COLLECTOR_CARD_SWORDS"),      description = joaat("CI_TAG_FOLDER_COLLECTOR_CARD_SWORDS_DESC") },
    { id = "cards_wands",      category = "documents",  txd = joaat("inventory_items_mp"), texture = joaat("document_card_wands_set"),          label = joaat("CI_TAG_FOLDER_COLLECTOR_CARD_WANDS"),       description = joaat("CI_TAG_FOLDER_COLLECTOR_CARD_WANDS_DESC") },
    { id = "coins",            category = "valuables",  txd = joaat("inventory_items_mp"), texture = joaat("provision_coin_set"),               label = joaat("CI_TAG_FOLDER_COLLECTOR_COINS"),            description = joaat("CI_TAG_FOLDER_COLLECTOR_COINS_DESC") },
    { id = "earrings",         category = "valuables",  txd = joaat("inventory_items_mp"), texture = joaat("provision_jewelry_earring_set"),    label = joaat("CI_TAG_FOLDER_COLLECTOR_EARRINGS"),         description = joaat("CI_TAG_FOLDER_COLLECTOR_EARRINGS_DESC") },
    { id = "eggs",             category = "valuables",  txd = joaat("inventory_items_mp"), texture = joaat("provision_egg_set"),                label = joaat("CI_TAG_FOLDER_COLLECTOR_EGGS"),             description = joaat("CI_TAG_FOLDER_COLLECTOR_EGGS_DESC") },
    { id = "fossils_common",   category = "valuables",  txd = joaat("inventory_items_mp"), texture = joaat("provision_fossil_set_01_common"),   label = joaat("CI_TAG_FOLDER_COLLECTOR_FOSSILS_COMMON"),   description = joaat("CI_TAG_FOLDER_COLLECTOR_FOSSILS_COMMON_DESC") },
    { id = "fossils_rare",     category = "valuables",  txd = joaat("inventory_items_mp"), texture = joaat("provision_fossil_set_03_rare"),     label = joaat("CI_TAG_FOLDER_COLLECTOR_FOSSILS_RARE"),     description = joaat("CI_TAG_FOLDER_COLLECTOR_FOSSILS_RARE_DESC") },
    { id = "fossils_uncommon", category = "valuables",  txd = joaat("inventory_items_mp"), texture = joaat("provision_fossil_set_02_uncommon"), label = joaat("CI_TAG_FOLDER_COLLECTOR_FOSSILS_UNCOMMON"), description = joaat("CI_TAG_FOLDER_COLLECTOR_FOSSILS_UNCOMMON_DESC") },
    { id = "heirlooms",        category = "valuables",  txd = joaat("inventory_items_mp"), texture = joaat("provision_hrlm_set"),               label = joaat("CI_TAG_FOLDER_COLLECTOR_HEIRLOOMS"),        description = joaat("CI_TAG_FOLDER_COLLECTOR_HEIRLOOMS_DESC") },
    { id = "necklaces",        category = "valuables",  txd = joaat("inventory_items_mp"), texture = joaat("provision_jewelry_necklace_set"),   label = joaat("CI_TAG_FOLDER_COLLECTOR_NECKLACES"),        description = joaat("CI_TAG_FOLDER_COLLECTOR_NECKLACES_DESC") },
    { id = "rings",            category = "valuables",  txd = joaat("inventory_items_mp"), texture = joaat("provision_jewelry_ring_set"),       label = joaat("CI_TAG_FOLDER_COLLECTOR_RINGS"),            description = joaat("CI_TAG_FOLDER_COLLECTOR_RINGS_DESC") },
    { id = "wildflowers",      category = "provisions", txd = joaat("inventory_items_mp"), texture = joaat("provision_wldflwr_set"),            label = joaat("CI_TAG_FOLDER_COLLECTOR_WILDFLOWERS"),      description = joaat("CI_TAG_FOLDER_COLLECTOR_WILDFLOWERS_DESC") },

    -- Documents
    { id = "taxidermist_orders", category = "documents", txd = joaat("inventory_items"),    texture = joaat("folder_taxidermist_orders"),            label = joaat("CI_TAG_FOLDER_TAXIDERMIST_ORDERS"), description = joaat("CI_TAG_FOLDER_TAXIDERMIST_ORDERS_DESC") },
    { id = "letters",            category = "documents", txd = joaat("inventory_items"),    texture = joaat("folder_letters"),                       label = joaat("CI_TAG_FOLDER_LETTERS"),            description = joaat("CI_TAG_FOLDER_LETTERS_DESC") },
    { id = "treasure_maps",      category = "documents", txd = joaat("inventory_items"),    texture = joaat("folder_treasure_maps"),                 label = joaat("CI_TAG_FOLDER_TREASURE_MAPS"),      description = joaat("CI_TAG_FOLDER_TREASURE_MAPS_DESC") },
    { id = "photographs",        category = "documents", txd = joaat("inventory_items"),    texture = joaat("folder_photographs"),                   label = joaat("CI_TAG_FOLDER_PHOTOGRAPHS"),        description = joaat("CI_TAG_FOLDER_PHOTOGRAPHS_DESC") },
    { id = "collector_maps",     category = "documents", txd = joaat("inventory_items_mp"), texture = joaat("folder_collector_maps"),                label = joaat("CI_TAG_FOLDER_COLLECTOR_MAPS"),     description = joaat("CI_TAG_FOLDER_COLLECTOR_MAPS_DESC") },
    { id = "recipe_pamphlets",   category = "documents", txd = joaat("inventory_items"),    texture = joaat("folder_recipe_pamphlets"),              label = joaat("CI_TAG_FOLDER_RECIPE_PAMPHLETS"),   description = joaat("CI_TAG_FOLDER_RECIPE_PAMPHLETS_DESC") },
    { id = "newspaper_scraps",   category = "documents", txd = joaat("inventory_items"),    texture = joaat("folder_newspaper_scraps"),              label = joaat("CI_TAG_FOLDER_NEWSPAPER_SCRAPS"),   description = joaat("CI_TAG_FOLDER_NEWSPAPER_SCRAPS_DESC") },
    { id = "business_cards",     category = "documents", txd = joaat("inventory_items"),    texture = joaat("folder_business_cards"),                label = joaat("CI_TAG_FOLDER_BUSINESS_CARDS"),     description = joaat("CI_TAG_FOLDER_BUSINESS_CARDS_DESC") },
    { id = "newspapers",         category = "documents", txd = joaat("inventory_items"),    texture = joaat("folder_newspapers"),                    label = joaat("CI_TAG_FOLDER_NEWSPAPERS"),         description = joaat("CI_TAG_FOLDER_NEWSPAPERS_DESC") },
    { id = "dinosaur_notes",     category = "documents", txd = joaat("inventory_items"),    texture = joaat("folder_dinosaur_notes"),                label = joaat("CI_TAG_FOLDER_DINOSAUR_NOTES"),     description = joaat("CI_TAG_FOLDER_DINOSAUR_NOTES_DESC") },
    { id = "rock_carving_notes", category = "documents", txd = joaat("inventory_items"),    texture = joaat("document_business_card_rock_carvings"), label = joaat("CI_TAG_FOLDER_ROCK_CARVING_NOTES"), description = joaat("CI_TAG_FOLDER_ROCK_CARVING_NOTES_DESC") },
    { id = "books",              category = "documents", txd = joaat("inventory_items"),    texture = joaat("folder_books"),                         label = joaat("CI_TAG_FOLDER_BOOKS"),              description = joaat("CI_TAG_FOLDER_BOOKS_DESC") },
    { id = "drawings",           category = "documents", txd = joaat("inventory_items"),    texture = joaat("folder_drawings"),                      label = joaat("CI_TAG_FOLDER_DRAWINGS"),           description = joaat("CI_TAG_FOLDER_DRAWINGS_DESC") },
    { id = "bounty_posters",     category = "documents", txd = joaat("inventory_items"),    texture = joaat("folder_bounty_posters"),                label = joaat("CI_TAG_FOLDER_BOUNTY_POSTERS"),     description = joaat("CI_TAG_FOLDER_BOUNTY_POSTERS_DESC") },
    { id = "maps",               category = "documents", txd = joaat("inventory_items"),    texture = joaat("folder_maps"),                          label = joaat("CI_TAG_FOLDER_MAPS"),               description = joaat("CI_TAG_FOLDER_MAPS_DESC") },
    { id = "notes",              category = "documents", txd = joaat("inventory_items"),    texture = joaat("folder_notes"),                         label = joaat("CI_TAG_FOLDER_NOTES"),              description = joaat("CI_TAG_FOLDER_NOTES_DESC") },
    { id = "skill_pamphlets",    category = "documents", txd = joaat("inventory_items_mp"), texture = joaat("folder_skill_pages"),                   label = joaat("CI_TAG_FOLDER_SKILL_PAMPHLETS"),    description = joaat("CI_TAG_FOLDER_SKILL_PAMPHLETS_DESC") },
    { id = "satchel_pamphlets",  category = "documents", txd = joaat("inventory_items_mp"), texture = joaat("folder_satchel_upgrades"),              label = joaat("CI_TAG_FOLDER_SATCHEL_PAMPHLETS"),  description = joaat("CI_TAG_FOLDER_SATCHEL_PAMPHLETS_DESC") },

    -- Kit
    { id = "keychain", category = "kit", txd = joaat("inventory_items"), texture = joaat("folder_kit_keychain"),      label = joaat("CI_TAG_FOLDER_KIT_KEYCHAIN"), description = joaat("CI_TAG_FOLDER_KIT_KEYCHAIN_DESC") },
    { id = "watches",  category = "kit", txd = joaat("inventory_items"), texture = joaat("provision_folder_watches"), label = joaat("CI_TAG_FOLDER_KIT_WATCHES"),  description = joaat("CI_TAG_FOLDER_KIT_WATCHES_DESC") },

    -- Provisions
    { id = "gamey_bird",     category = "provisions", txd = joaat("satchel_textures"), texture = joaat("provision_meat_gamey_bird"),     label = joaat("CI_TAG_FOLDER_GAMEY_BIRD"),     description = joaat("CI_TAG_FOLDER_GAMEY_BIRD_DESC") },
    { id = "big_game",       category = "provisions", txd = joaat("satchel_textures"), texture = joaat("provision_meat_big_game"),       label = joaat("CI_TAG_FOLDER_BIG_GAME"),       description = joaat("CI_TAG_FOLDER_BIG_GAME_DESC") },
    { id = "gristly_mutton", category = "provisions", txd = joaat("satchel_textures"), texture = joaat("provision_meat_gristly_mutton"), label = joaat("CI_TAG_FOLDER_GRISTLY_MUTTON"), description = joaat("CI_TAG_FOLDER_GRISTLY_MUTTON_DESC") },
    { id = "herptile_meat",  category = "provisions", txd = joaat("satchel_textures"), texture = joaat("provision_meat_herptile"),       label = joaat("CI_TAG_FOLDER_HERPTILE_MEAT"),  description = joaat("CI_TAG_FOLDER_HERPTILE_MEAT_DESC") },
    { id = "succulent_fish", category = "provisions", txd = joaat("satchel_textures"), texture = joaat("provision_meat_succulent_fish"), label = joaat("CI_TAG_FOLDER_SUCCULENT_FISH"), description = joaat("CI_TAG_FOLDER_SUCCULENT_FISH_DESC") },
    { id = "stringy_meat",   category = "provisions", txd = joaat("satchel_textures"), texture = joaat("provision_meat_stringy"),        label = joaat("CI_TAG_FOLDER_STRINGY_MEAT"),   description = joaat("CI_TAG_FOLDER_STRINGY_MEAT_DESC") },
    { id = "mature_venison", category = "provisions", txd = joaat("satchel_textures"), texture = joaat("provision_meat_mature_venison"), label = joaat("CI_TAG_FOLDER_MATURE_VENISON"), description = joaat("CI_TAG_FOLDER_MATURE_VENISON_DESC") },
    { id = "game",           category = "provisions", txd = joaat("satchel_textures"), texture = joaat("provision_meat_game"),           label = joaat("CI_TAG_FOLDER_GAME"),           description = joaat("CI_TAG_FOLDER_GAME_DESC") },
    { id = "crustacean",     category = "provisions", txd = joaat("satchel_textures"), texture = joaat("provision_meat_crustacean"),     label = joaat("CI_TAG_FOLDER_CRUSTACEAN"),     description = joaat("CI_TAG_FOLDER_CRUSTACEAN_DESC") },
    { id = "flakey_fish",    category = "provisions", txd = joaat("satchel_textures"), texture = joaat("provision_meat_flakey_fish"),    label = joaat("CI_TAG_FOLDER_FLAKEY_FISH"),    description = joaat("CI_TAG_FOLDER_FLAKEY_FISH_DESC") },
    { id = "plump_bird",     category = "provisions", txd = joaat("satchel_textures"), texture = joaat("provision_meat_plump_bird"),     label = joaat("CI_TAG_FOLDER_PLUMP_BIRD"),     description = joaat("CI_TAG_FOLDER_PLUMP_BIRD_DESC") },
    { id = "prime_beef",     category = "provisions", txd = joaat("satchel_textures"), texture = joaat("provision_meat_prime_beef"),     label = joaat("CI_TAG_FOLDER_PRIME_BEEF"),     description = joaat("CI_TAG_FOLDER_PRIME_BEEF_DESC") },
    { id = "gritty_fish",    category = "provisions", txd = joaat("satchel_textures"), texture = joaat("provision_meat_gritty_fish"),    label = joaat("CI_TAG_FOLDER_GRITTY_FISH"),    description = joaat("CI_TAG_FOLDER_GRITTY_FISH_DESC") },
    { id = "tender_pork",    category = "provisions", txd = joaat("satchel_textures"), texture = joaat("provision_meat_tender_pork"),    label = joaat("CI_TAG_FOLDER_TENDER_PORK"),    description = joaat("CI_TAG_FOLDER_TENDER_PORK_DESC") },
    { id = "exotic_bird",    category = "provisions", txd = joaat("satchel_textures"), texture = joaat("provision_meat_exotic_bird"),    label = joaat("CI_TAG_FOLDER_EXOTIC_BIRD"),    description = joaat("CI_TAG_FOLDER_EXOTIC_BIRD_DESC") },
}

-- Configuration

-- Change this in case you have another resource using the "native_satch" prefix for events
Satchel.eventHandlerKey = "native_satchel"

-- When the maxCount is exceeded, make the item count red
-- This doesn't affect the tip text, which will always be marked red
Satchel.enableRedCountOnMax = false

-- Item database cache
-- This is used to be able to reuse data lookups for inventory items
-- You shouldn't need to add items to this, but you could do so for frequent items

Satchel.cacheItemDatabase = {}

-- Internal properties, don't modify

Satchel._cacheCategoryItems = {}
Satchel._cacheMenuItems = {}
Satchel._cacheListItems = {}
Satchel._cachePersistence = {}

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

        -- Hash for selected name
        DatabindingAddDataHash(datastore, "Name", 0)
        
        -- String for selected name
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

    DatabindingWriteDataHashStringFromParent(datastoreSelected, "Category", category.label)

    local filteredIndex = 0
    local folderItems = {}

    for _, item in ipairs(Satchel.items) do
        if (not category.all and item.folder) then
            if (folderItems[item.folder] == nil) then
                folderItems[item.folder] = {}
            end

            table.insert(folderItems[item.folder], item)
        elseif ((category.all and filteredIndex < 48) or (item.category == category.id)) then
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
    local name = nil
    local description = nil
    local effectIds = {}

    if (itemId) then
        local item = Satchel.items[itemId]

        if (not item) then
            print("[NativeSatchel] UpdateSatchelSelectedData: Could not determine item for ID " .. itemId)
            return
        end

        id = item.id
        count = item.count
        maxCount = item.maxCount
        name = joaat(id)
        description = joaat(id)
        effectIds = {}

        if (item.catalog) then
            local itemDatabase = GetItemFromDatabase(item.catalog)

            name = itemDatabase.name
            description = itemDatabase.description
            effectIds = itemDatabase.effectIds
        end
    else
        local folder = Satchel.folders[folderId]

        if (not folder) then
            print("[NativeSatchel] UpdateSatchelSelectedData: Could not determine folder for ID " .. folderId)
            return
        end

        id = folder.id
        name = folder.label
        description = folder.description
    end

    if (name) then
        local asString = GetStringFromHashKey(name)
        DatabindingWriteDataHashStringFromParent(datastoreSelected, "Name", name)
        DatabindingWriteStringFromParent(datastoreSelected, "NameAsString", asString)
    end

    if (description) then
        local asString = GetStringFromHashKey(description)
        DatabindingWriteDataHashStringFromParent(datastoreSelected, "Description", description)
        DatabindingWriteStringFromParent(datastoreSelected, "DescriptionAsString", asString)
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

function ClearSatchelSelectedData()
    local datastoreSelected = GetPersistedInt("RefSelectedData")

    if (datastoreSelected == 0 or DatabindingIsEntryValid(datastoreSelected) ~= 1) then
        print("[NativeSatchel] ClearSatchelSelectedData: Selected data wasn't ready in time!")
        return
    end

    DatabindingWriteDataHashStringFromParent("Name", 0)
    DatabindingWriteStringFromParent("NameAsString", "")
    DatabindingWriteDataHashStringFromParent("Description", 0)
    DatabindingWriteStringFromParent("DescriptionAsString", "")
    DatabindingWriteStringFromParent("Tip", "")

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

    Satchel._cacheListItems = {}
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

    DatabindingWriteDataHashStringFromParent(datastoreSelected, "Folder", folder.label)

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
            TriggerEvent(Satchel.eventHandlerKey .. ":focus_folder", folderId)
        end
    elseif (parameter == joaat("USABLE_ITEM")) then
        if (itemId) then
            TriggerEvent(Satchel.eventHandlerKey .. ":focus_item", itemId)
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
            TriggerEvent(Satchel.eventHandlerKey .. ":open_folder", folderId)
        end
    elseif (parameter == joaat("USABLE_ITEM")) then
        if (itemId) then
            TriggerEvent(Satchel.eventHandlerKey .. ":use_item", itemId)
        end
    elseif (parameter == joaat("BREAKABLE_ITEM")) then
        if (itemId) then
            TriggerEvent(Satchel.eventHandlerKey .. ":break_item", itemId)
        end
    elseif (parameter == joaat("DROP_ITEM")) then
        if (itemId) then
            TriggerEvent(Satchel.eventHandlerKey .. ":drop_item", itemId)
        end
    elseif (parameter == joaat("DISCARD_ALL")) then
        if (itemId) then
            TriggerEvent(Satchel.eventHandlerKey .. ":discard_all", itemId)
        end
    elseif (parameter == joaat("SEND_ALL")) then
        if (itemId) then
            TriggerEvent(Satchel.eventHandlerKey .. ":send_all", itemId)
        end
    else
        print("[NativeSatchel] EventItemSelected: Unknown select parameter: " .. parameter)
    end
end

function GetItemFromDatabase(item)
    local hash = joaat(item)

    if (Satchel.cacheItemDatabase[hash]) then
        return Satchel.cacheItemDatabase[hash]
    end

    local result = {
        name = nil,
        description = nil,
        txd = nil,
        texture = nil,
        effectIds = nil,
    }

    if (ItemdatabaseIsKeyValid(hash, 0) == 0) then
        return result
    end

    local uiData = ItemdatabaseGetUiData(hash)
    if (uiData) then
        result.name = uiData.name
        result.description = uiData.description
        result.txd = uiData.textureDict
        result.texture = uiData.textureId
    end

    local effectIds = ItemdatabaseGetEffectIds(hash)
    if (effectIds) then
        result.effectIds = effectIds
    end

    Satchel.cacheItemDatabase[hash] = result

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
    DatabindingAddDataString(data, "name", GetStringFromHashKey(label))
    DatabindingAddDataHash(data, "hLabel", label)

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
    local special = item.special or false
    local stars = item.stars or 0

    -- The following could be set through catalog
    local name = joaat(id)
    local txd = joaat("inventory_items")
    local texture = joaat("_placeholder")

    if (item.catalog) then
        local itemDatabase = GetItemFromDatabase(item.catalog)

        name = itemDatabase.name
        txd = itemDatabase.txd
        texture = itemDatabase.texture
    end

    EnsureTxdIsLoaded(txd)

    local data = DatabindingGetDataContainerFromChildIndex(datastoreMain, index)

    DatabindingAddDataHash(data, "item", hash)
    
    DatabindingAddDataBool(data, "focusable", true)
    DatabindingAddDataHash(data, "color", joaat("COLOR_WHITE")) -- Colorizes the ENTIRE item (incl count and bg)

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

    local name = folder.label
    local txd = folder.txd
    local texture = folder.texture

    EnsureTxdIsLoaded(txd)

    local data = DatabindingGetDataContainerFromChildIndex(datastoreMain, index)

    DatabindingAddDataHash(data, "item", hash)
    
    DatabindingAddDataBool(data, "focusable", true)
    DatabindingAddDataHash(data, "color", joaat("COLOR_WHITE")) -- Colorizes the ENTIRE item (incl count and bg)

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
    local name = joaat(id)

    if (item.catalog) then
        local itemDatabase = GetItemFromDatabase(item.catalog)

        name = itemDatabase.name
    end

    local data = DatabindingGetDataContainerFromChildIndex(datastoreMain, index)

    DatabindingAddDataHash(data, "item", hash)
    
    DatabindingAddDataBool(data, "focusable", true)
    DatabindingAddDataHash(data, "label", name)
    DatabindingAddDataString(data, "label_as_string", GetStringFromHashKey(name))
    DatabindingAddDataHash(data, "color", joaat("COLOR_WHITE")) -- Colorizes the ENTIRE item (incl count and bg)

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

        TriggerEvent(Satchel.eventHandlerKey .. ":open")

        while IsUiappRunningByHash(uiAppChannel) == 1 do
            Citizen.Wait(0)
            UiPromptEnablePromptTypeThisFrame(0)
        end

        CloseSatchel()
    end)
end

function CloseSatchel()
    TriggerEvent(Satchel.eventHandlerKey .. ":close")
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
