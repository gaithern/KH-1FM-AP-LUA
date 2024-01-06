-----------------------------------
------ Kingdom Hearts 1 FM AP -----
------         by Gicu        -----
-----------------------------------

LUAGUI_NAME = "kh1fmAP"
LUAGUI_AUTH = "Gicu"
LUAGUI_DESC = "Kingdom Hearts 1FM AP Integration"

if os.getenv('LOCALAPPDATA') ~= nil then
    client_communication_path = os.getenv('LOCALAPPDATA') .. "\\KH1FM\\"
else
    client_communication_path = os.getenv('HOME') .. "/KH1FM/"
    ok, err, code = os.rename(client_communication_path, client_communication_path)
    if not ok and code ~= 13 then
        os.execute("mkdir " .. path)
    end
end

function toBits(num)
    -- returns a table of bits, least significant first.
    local t={} -- will contain the bits
    while num>0 do
        rest=math.fmod(num,2)
        t[#t+1]=rest
        num=(num-rest)/2
    end
    return t
end

function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

--- Global Variables ---
frame_count = 1
canExecute = false
worlds_unlocked_array = {3, 0, 0, 0, 0, 0, 0, 0, 0}
monstro_unlocked = 0
item_categories = {
  equipment = 0,
  consumables = 1,
  unlocks = 2,
  abilities = 3,
  magic_trinities_summons = 4,
}
message_cache = {
  items = {},
  debug = { {} }
}
colourOffsetIterator = -8

--- Addresses ---
offset = 0x3A0606


--- Definitions ---

function define_items()
  items = {

    --Consumables
  { ID = 2640000, Name = "Victory", Progression = true },
  { ID = 2641001, Name = "Potion" },
  { ID = 2641002, Name = "Hi-Potion" },
  { ID = 2641003, Name = "Ether" },
  { ID = 2641004, Name = "Elixir" },
  { ID = 2641005, Name = "BO5" },
  { ID = 2641006, Name = "Mega-Potion" },
  { ID = 2641007, Name = "Mega-Ether" },
  { ID = 2641008, Name = "Megalixir" },

  --Synthesis
  { ID = 2641009, Name = "Fury Stone" },
  { ID = 2641010, Name = "Power Stone" },
  { ID = 2641011, Name = "Energy Stone" },
  { ID = 2641012, Name = "Blazing Stone" },
  { ID = 2641013, Name = "Frost Stone" },
  { ID = 2641014, Name = "Lightning Stone" },
  { ID = 2641015, Name = "Dazzling Stone" },
  { ID = 2641016, Name = "Stormy Stone" },

    --Equipment
  { ID = 2641017, Name = "Protect Chain" },
  { ID = 2641018, Name = "Protera Chain" },
  { ID = 2641019, Name = "Protega Chain" },
  { ID = 2641020, Name = "Fire Ring" },
  { ID = 2641021, Name = "Fira Ring" },
  { ID = 2641022, Name = "Firaga Ring" },
  { ID = 2641023, Name = "Blizzard Ring" },
  { ID = 2641024, Name = "Blizzara Ring" },
  { ID = 2641025, Name = "Blizzaga Ring" },
  { ID = 2641026, Name = "Thunder Ring" },
  { ID = 2641027, Name = "Thundara Ring" },
  { ID = 2641028, Name = "Thundaga Ring" },
  { ID = 2641029, Name = "Ability Stud" },
  { ID = 2641030, Name = "Guard Earring" },
  { ID = 2641031, Name = "Master Earring" },
  { ID = 2641032, Name = "Chaos Ring" },
  { ID = 2641033, Name = "Dark Ring" },
  { ID = 2641034, Name = "Element Ring" },
  { ID = 2641035, Name = "Three Stars" },
  { ID = 2641036, Name = "Power Chain" },
  { ID = 2641037, Name = "Golem Chain" },
  { ID = 2641038, Name = "Titan Chain" },
  { ID = 2641039, Name = "Energy Bangle" },
  { ID = 2641040, Name = "Angel Bangle" },
  { ID = 2641041, Name = "Gaia Bangle" },
  { ID = 2641042, Name = "Magic Armlet" },
  { ID = 2641043, Name = "Rune Armlet" },
  { ID = 2641044, Name = "Atlas Armlet" },
  { ID = 2641045, Name = "Heartguard" },
  { ID = 2641046, Name = "Ribbon" },
  { ID = 2641047, Name = "Crystal Crown" },
  { ID = 2641048, Name = "Brave Warrior" },
  { ID = 2641049, Name = "Ifrit's Horn" },
  { ID = 2641050, Name = "Inferno Band" },
  { ID = 2641051, Name = "White Fang" },
  { ID = 2641052, Name = "Ray of Light" },
  { ID = 2641053, Name = "Holy Circlet" },
  { ID = 2641054, Name = "Raven's Claw" },
  { ID = 2641055, Name = "Omega Arts" },
  { ID = 2641056, Name = "EXP Earring" },
  { ID = 2641057, Name = "A41" },
  { ID = 2641058, Name = "EXP Ring" },
  { ID = 2641059, Name = "EXP Bracelet" },
  { ID = 2641060, Name = "EXP Necklace" },
  { ID = 2641061, Name = "Firagun Band" },
  { ID = 2641062, Name = "Blizzagun Band" },
  { ID = 2641063, Name = "Thundagun Band" },
  { ID = 2641064, Name = "Ifrit Belt" },
  { ID = 2641065, Name = "Shiva Belt" },
  { ID = 2641066, Name = "Ramuh Belt" },
  { ID = 2641067, Name = "Moogle Badge" },
  { ID = 2641068, Name = "Cosmic Arts" },
  { ID = 2641069, Name = "Royal Crown" },
  { ID = 2641070, Name = "Prime Cap" },
  { ID = 2641071, Name = "Obsidian Ring" },
  { ID = 2641072, Name = "A56" },
  { ID = 2641073, Name = "A57" },
  { ID = 2641074, Name = "A58" },
  { ID = 2641075, Name = "A59" },
  { ID = 2641076, Name = "A60" },
  { ID = 2641077, Name = "A61" },
  { ID = 2641078, Name = "A62" },
  { ID = 2641079, Name = "A63" },
  { ID = 2641080, Name = "A64" },
  { ID = 2641081, Name = "Kingdom Key" },
  { ID = 2641082, Name = "Dream Sword" },
  { ID = 2641083, Name = "Dream Shield" },
  { ID = 2641084, Name = "Dream Rod" },
  { ID = 2641085, Name = "Wooden Sword" },
  { ID = 2641086, Name = "Jungle King" },
  { ID = 2641087, Name = "Three Wishes" },
  { ID = 2641088, Name = "Fairy Harp" },
  { ID = 2641089, Name = "Pumpkinhead" },
  { ID = 2641090, Name = "Crabclaw" },
  { ID = 2641091, Name = "Divine Rose" },
  { ID = 2641092, Name = "Spellbinder" },
  { ID = 2641093, Name = "Olympia" },
  { ID = 2641094, Name = "Lionheart" },
  { ID = 2641095, Name = "Metal Chocobo" },
  { ID = 2641096, Name = "Oathkeeper" },
  { ID = 2641097, Name = "Oblivion" },
  { ID = 2641098, Name = "Lady Luck" },
  { ID = 2641099, Name = "Wishing Star" },
  { ID = 2641100, Name = "Ultima Weapon" },
  { ID = 2641101, Name = "Diamond Dust" },
  { ID = 2641102, Name = "One-Winged Angel" },
  { ID = 2641103, Name = "Mage's Staff" },
  { ID = 2641104, Name = "Morning Star" },
  { ID = 2641105, Name = "Shooting Star" },
  { ID = 2641106, Name = "Magus Staff" },
  { ID = 2641107, Name = "Wisdom Staff" },
  { ID = 2641108, Name = "Warhammer" },
  { ID = 2641109, Name = "Silver Mallet" },
  { ID = 2641110, Name = "Grand Mallet" },
  { ID = 2641111, Name = "Lord Fortune" },
  { ID = 2641112, Name = "Violetta" },
  { ID = 2641113, Name = "Dream Rod (Donald)" },
  { ID = 2641114, Name = "Save the Queen" },
  { ID = 2641115, Name = "Wizard's Relic" },
  { ID = 2641116, Name = "Meteor Strike" },
  { ID = 2641117, Name = "Fantasista" },
  { ID = 2641118, Name = "Unused (Donald)" },
  { ID = 2641119, Name = "Knight's Shield" },
  { ID = 2641120, Name = "Mythril Shield" },
  { ID = 2641121, Name = "Onyx Shield" },
  { ID = 2641122, Name = "Stout Shield" },
  { ID = 2641123, Name = "Golem Shield" },
  { ID = 2641124, Name = "Adamant Shield" },
  { ID = 2641125, Name = "Smasher" },
  { ID = 2641126, Name = "Gigas Fist" },
  { ID = 2641127, Name = "Genji Shield" },
  { ID = 2641128, Name = "Herc's Shield" },
  { ID = 2641129, Name = "Dream Shield" },
  { ID = 2641130, Name = "Save the King" },
  { ID = 2641131, Name = "Defender" },
  { ID = 2641132, Name = "Mighty Shield" },
  { ID = 2641133, Name = "Seven Elements" },
  { ID = 2641134, Name = "Unused (Goofy)" },
  { ID = 2641135, Name = "Spear" },

  { ID = 2641136, Name = "No Weapon" },
  { ID = 2641137, Name = "Genie" },
  { ID = 2641138, Name = "No Weapon" },
  { ID = 2641139, Name = "No Weapon" },
  { ID = 2641140, Name = "Tinker Bell" },
  { ID = 2641141, Name = "Claws" },
  { ID = 2641142, Name = "Tent" },
  { ID = 2641143, Name = "Camping Set" },
  { ID = 2641144, Name = "Cottage" },
  { ID = 2641145, Name = "C04" },
  { ID = 2641146, Name = "C05" },
  { ID = 2641147, Name = "C06" },
  { ID = 2641148, Name = "C07" },
  { ID = 2641149, Name = "Ansem's Report 11" },
  { ID = 2641150, Name = "Ansem's Report 12" },
  { ID = 2641151, Name = "Ansem's Report 13" },
  { ID = 2641152, Name = "Power Up" },
  { ID = 2641153, Name = "Defense Up" },
  { ID = 2641154, Name = "AP Up" },
  { ID = 2641155, Name = "Serenity Power" },
  { ID = 2641156, Name = "Dark Matter" },
  { ID = 2641157, Name = "Mythril Stone" },
  { ID = 2641158, Name = "Fire Arts" },
  { ID = 2641159, Name = "Blizzard Arts" },
  { ID = 2641160, Name = "Thunder Arts" },
  { ID = 2641161, Name = "Cure Arts" },
  { ID = 2641162, Name = "Gravity Arts" },
  { ID = 2641163, Name = "Stop Arts" },
  { ID = 2641164, Name = "Aero Arts" },
  { ID = 2641165, Name = "Shiitank Rank" },
  { ID = 2641166, Name = "Matsutake Rank" },
  { ID = 2641167, Name = "Mystery Mold" },
  { ID = 2641168, Name = "Ansem's Report 1" },
  { ID = 2641169, Name = "Ansem's Report 2" },
  { ID = 2641170, Name = "Ansem's Report 3" },
  { ID = 2641171, Name = "Ansem's Report 4" },
  { ID = 2641172, Name = "Ansem's Report 5" },
  { ID = 2641173, Name = "Ansem's Report 6" },
  { ID = 2641174, Name = "Ansem's Report 7" },
  { ID = 2641175, Name = "Ansem's Report 8" },
  { ID = 2641176, Name = "Ansem's Report 9" },
  { ID = 2641177, Name = "Ansem's Report 10" },
  { ID = 2641178, Name = "Khama Vol. 8" },
  { ID = 2641179, Name = "Salegg Vol. 6" },
  { ID = 2641180, Name = "Azal Vol. 3" },
  { ID = 2641181, Name = "Mava Vol. 3" },
  { ID = 2641182, Name = "Mava Vol. 6" },
  { ID = 2641183, Name = "Theon Vol. 6" },
  { ID = 2641184, Name = "Nahara Vol. 5" },
  { ID = 2641185, Name = "Hafet Vol. 4" },
  { ID = 2641186, Name = "Empty Bottle" },
  { ID = 2641187, Name = "Old Book" },
  { ID = 2641188, Name = "Emblem Piece (Flame)",    Progression = true },
  { ID = 2641189, Name = "Emblem Piece (Chest)",    Progression = true },
  { ID = 2641190, Name = "Emblem Piece (Statue)",   Progression = true },
  { ID = 2641191, Name = "Emblem Piece (Fountain)", Progression = true },
  { ID = 2641192, Name = "Log" },
  { ID = 2641193, Name = "Cloth" },
  { ID = 2641194, Name = "Rope" },
  { ID = 2641195, Name = "Seagull Egg" },
  { ID = 2641196, Name = "Fish" },
  { ID = 2641197, Name = "Mushroom" },
  { ID = 2641198, Name = "Coconut" },
  { ID = 2641199, Name = "Drinking Water" },
  { ID = 2641200, Name = "Navi-G Piece 1" },
  { ID = 2641201, Name = "Navi-G Piece 2" },
  { ID = 2641202, Name = "Navi-Gummi Unused" },
  { ID = 2641203, Name = "Navi-G Piece 3" },
  { ID = 2641204, Name = "Navi-G Piece 4" },
  { ID = 2641205, Name = "Navi-Gummi" },
  { ID = 2641206, Name = "Watergleam" },
  { ID = 2641207, Name = "Naturespark" },
  { ID = 2641208, Name = "Fireglow" },
  { ID = 2641209, Name = "Earthshine" },
  { ID = 2641210, Name = "Crystal Trident" },
  { ID = 2641211, Name = "Postcard" },
  { ID = 2641212, Name = "Torn Page 1" },
  { ID = 2641213, Name = "Torn Page 2" },
  { ID = 2641214, Name = "Torn Page 3" },
  { ID = 2641215, Name = "Torn Page 4" },
  { ID = 2641216, Name = "Torn Page 5" },
  { ID = 2641217, Name = "Slide 1", Progression = true },
  { ID = 2641218, Name = "Slide 2" },
  { ID = 2641219, Name = "Slide 3" },
  { ID = 2641220, Name = "Slide 4" },
  { ID = 2641221, Name = "Slide 5" },
  { ID = 2641222, Name = "Slide 6" },
  { ID = 2641223, Name = "Footprints", Progression = true },
  { ID = 2641224, Name = "Claw Marks" },
  { ID = 2641225, Name = "Stench" },
  { ID = 2641226, Name = "Antenna" },
  { ID = 2641227, Name = "Forget-Me-Not" },
  { ID = 2641228, Name = "Jack-In-The-Box", Progression = true },
  { ID = 2641229, Name = "Entry Pass" },
  { ID = 2641230, Name = "Hero License" },
  { ID = 2641231, Name = "Pretty Stone" },
  { ID = 2641232, Name = "N41" },
  { ID = 2641233, Name = "Lucid Shard" },
  { ID = 2641234, Name = "Lucid Gem" },
  { ID = 2641235, Name = "Lucid Crystal" },
  { ID = 2641236, Name = "Spirit Shard" },
  { ID = 2641237, Name = "Spirit Gem" },
  { ID = 2641238, Name = "Power Shard" },
  { ID = 2641239, Name = "Power Gem" },
  { ID = 2641240, Name = "Power Crystal" },
  { ID = 2641241, Name = "Blaze Shard" },
  { ID = 2641242, Name = "Blaze Gem" },
  { ID = 2641243, Name = "Frost Shard" },
  { ID = 2641244, Name = "Frost Gem" },
  { ID = 2641245, Name = "Thunder Shard" },
  { ID = 2641246, Name = "Thunder Gem" },
  { ID = 2641247, Name = "Shiny Crystal" },
  { ID = 2641248, Name = "Bright Shard" },
  { ID = 2641249, Name = "Bright Gem" },
  { ID = 2641250, Name = "Bright Crystal" },
  { ID = 2641251, Name = "Mystery Goo" },
  { ID = 2641252, Name = "Gale" },
  { ID = 2641253, Name = "Mythril Shard" },
  { ID = 2641254, Name = "Mythril" },
  { ID = 2641255, Name = "Orichalcum" },

  -- Abilities
  { ID = 2642001, Name = "High Jump",    Progression = true },
  { ID = 2642002, Name = "Mermaid Kick", Progression = true },
  { ID = 2642003, Name = "Glide",        Progression = true },
  { ID = 2642004, Name = "Superglide",   Progression = true },
  { ID = 2643005, Name = "Treasure Magnet" },
  { ID = 2643006, Name = "Combo Plus" },
  { ID = 2643007, Name = "Air Combo Plus" },
  { ID = 2643008, Name = "Critical Plus" },
  { ID = 2643009, Name = "Second Wind" },
  { ID = 2643010, Name = "Scan" },
  { ID = 2643011, Name = "Sonic Blade" },
  { ID = 2643012, Name = "Ars Arcanum" },
  { ID = 2643013, Name = "Strike Raid" },
  { ID = 2643014, Name = "Ragnarok" },
  { ID = 2643015, Name = "Trinity Limit" },
  { ID = 2643016, Name = "Cheer" },
  { ID = 2643017, Name = "Vortex" },
  { ID = 2643018, Name = "Aerial Sweep" },
  { ID = 2643019, Name = "Counterattack" },
  { ID = 2643020, Name = "Blitz" },
  { ID = 2643021, Name = "Guard" },
  { ID = 2643022, Name = "Dodge Roll" },
  { ID = 2643023, Name = "MP Haste" },
  { ID = 2643024, Name = "MP Rage" },
  { ID = 2643025, Name = "Second Chance" },
  { ID = 2643026, Name = "Berserk" },
  { ID = 2643027, Name = "Jackpot" },
  { ID = 2643028, Name = "Lucky Strike" },
  { ID = 2643029, Name = "Charge" },
  { ID = 2643030, Name = "Rocket" },
  { ID = 2643031, Name = "Tornado" },
  { ID = 2643032, Name = "MP Gift" },
  { ID = 2643033, Name = "Raging Boar" },
  { ID = 2643034, Name = "Asp's Bite" },
  { ID = 2643035, Name = "Healing Herb" },
  { ID = 2643036, Name = "Wind Armor" },
  { ID = 2643037, Name = "Crescent" },
  { ID = 2643038, Name = "Sandstorm" },
  { ID = 2643039, Name = "Applause!" },
  { ID = 2643040, Name = "Blazing Fury" },
  { ID = 2643041, Name = "Icy Terror" },
  { ID = 2643042, Name = "Bolts of Sorrow" },
  { ID = 2643043, Name = "Ghostly Scream" },
  { ID = 2643044, Name = "Humming Bird" },
  { ID = 2643045, Name = "Time-Out" },
  { ID = 2643046, Name = "Storm's Eye" },
  { ID = 2643047, Name = "Ferocious Lunge" },
  { ID = 2643048, Name = "Furious Bellow" },
  { ID = 2643049, Name = "Spiral Wave" },
  { ID = 2643050, Name = "Thunder Potion" },
  { ID = 2643051, Name = "Cure Potion" },
  { ID = 2643052, Name = "Aero Potion" },
  { ID = 2643053, Name = "Slapshot" },
  { ID = 2643054, Name = "Sliding Dash" },
  { ID = 2643055, Name = "Hurricane Blast" },
  { ID = 2643056, Name = "Ripple Drive" },
  { ID = 2643057, Name = "Stun Impact" },
  { ID = 2643058, Name = "Gravity Break" },
  { ID = 2643059, Name = "Zantetsuken" },
  { ID = 2643060, Name = "Tech Boost" },
  { ID = 2643061, Name = "Encounter Plus" },
  { ID = 2643062, Name = "Leaf Bracer" },
  { ID = 2643063, Name = "Evolution" },
  { ID = 2643064, Name = "EXP Zero" },
  { ID = 2643065, Name = "Combo Master" },

  --Stats Up
  { ID = 2644001, Name = "Max HP Increase" },
  { ID = 2644002, Name = "Max MP Increase" },
  { ID = 2644003, Name = "Max AP Increase" },
  { ID = 2644004, Name = "Strength Increase" },
  { ID = 2644005, Name = "Defense Increase" },
  { ID = 2644006, Name = "Item Slot Increase" },
  { ID = 2644007, Name = "Accessory Slot Increase" },

  --Summons
  { ID = 2645000, Name = "Dumbo" },
  { ID = 2645001, Name = "Bambi" },
  { ID = 2645002, Name = "Genie" },
  { ID = 2645003, Name = "Tinker Bell" },
  { ID = 2645004, Name = "Mushu" },
  { ID = 2645005, Name = "Simba" },

  --Magic
  { ID = 2646001, Name = "Progressive Fire",     Progression = true },
  { ID = 2646002, Name = "Progressive Blizzard", Progression = true },
  { ID = 2646003, Name = "Progressive Thunder",  Progression = true },
  { ID = 2646004, Name = "Progressive Cure",     Progression = true },
  { ID = 2646005, Name = "Progressive Gravity",  Progression = true },
  { ID = 2646006, Name = "Progressive Stop",     Progression = true },
  { ID = 2646007, Name = "Progressive Aero",     Progression = true },

  --World unlocks
  { ID = 2647002, Name = "Wonderland",       Progression = true },
  { ID = 2647003, Name = "Olympus Coliseum", Progression = true },
  { ID = 2647004, Name = "Deep Jungle",      Progression = true },
  { ID = 2647005, Name = "Agrabah",          Progression = true },
  { ID = 2647006, Name = "Halloween Town",   Progression = true },
  { ID = 2647007, Name = "Atlantica",        Progression = true },
  { ID = 2647008, Name = "Neverland",        Progression = true },
  { ID = 2647009, Name = "Hollow Bastion",   Progression = true },
  { ID = 2647010, Name = "End of the World", Progression = true },
  { ID = 2647011, Name = "Monstro",          Progression = true },

  --Trinities
  { ID = 2648001, Name = "Blue Trinity",   Progression = true },
  { ID = 2648002, Name = "Red Trinity",    Progression = true },
  { ID = 2648003, Name = "Green Trinity",  Progression = true },
  { ID = 2648004, Name = "Yellow Trinity", Progression = true },
  { ID = 2648005, Name = "White Trinity",  Progression = true },

  --Cups
  { ID = 2649001, Name = "Phil Cup",     Progression = true },
  { ID = 2649002, Name = "Pegasus Cup",  Progression = true },
  { ID = 2649003, Name = "Hercules Cup", Progression = true },
  { ID = 2649004, Name = "Hades Cup",    Progression = true },
}
    return items
end

local items = define_items()
function get_item_by_id(item_id)
  for i = 1, #items do
    if items[i].ID == item_id then
      return items[i]
    end
  end
end


function read_chests_opened_array()
    --Reads an array of bits which represent which chests have been opened by the player
    chests_opened_address = 0x2DE5F9C - offset
    chest_array = ReadArray(chests_opened_address, 509)
    return chest_array
end

function read_soras_abilities_array()
    --Reads an array of Sora's abilties.  The first 7 bits define the ability,
    --while the last bit defines whether its equiped.
    soras_abilities_address   = 0x2DE5A14 - offset
    return ReadArray(soras_abilities_address, 40)
end

function read_soras_level()
    --Reads Sora's Current Level
    soras_level_address = 0x2DE5A08 - offset
    return ReadShort(soras_level_address)
end

function read_shared_abilities_array()
    --Reads an array of the player's current shared abilities.
    shared_abilties_addresss = 0x2DE5F68 - offset
    return ReadArray(shared_abilties_addresss, 4)
end

function read_soras_stats_array()
    --Reads an array of Sora's stats
    soras_stats_address         = 0x2DE59D6 - offset
    sora_hp_offset              = 0x0
    sora_mp_offset              = 0x2
    sora_ap_offset              = 0x3
    sora_strength_offset        = 0x4
    sora_defense_offset         = 0x5
    sora_accessory_slots_offset = 0x16
    sora_item_slots_offset      = 0x1F
    return {ReadByte(soras_stats_address + sora_hp_offset)
          , ReadByte(soras_stats_address + sora_mp_offset)
          , ReadByte(soras_stats_address + sora_ap_offset)
          , ReadByte(soras_stats_address + sora_strength_offset)
          , ReadByte(soras_stats_address + sora_defense_offset)
          , ReadByte(soras_stats_address + sora_accessory_slots_offset)
          , ReadByte(soras_stats_address + sora_item_slots_offset)}
end

function read_check_array()
    --Reads the current check number by getting the sum total of the 3 AP items
    inventory_address = 0x2DE5E69 - offset
    check_number_item_address = inventory_address + 0x48
    return ReadArray(check_number_item_address, 3)
end

function read_room()
    --Gets the numeric value of the currently occupied room
    world_address = 0x233CADC - offset
    room_address = world_address + 0x68
    return ReadByte(room_address)
end

function read_world()
    --Gets the numeric value of the currently occupied world
    world_address = 0x233CADC - offset
    return ReadByte(world_address)
end

function read_chronicles()
    chronicles_address = 0x2DE7367 - offset
    chronicles_array = ReadArray(chronicles_address, 36)
    return chronicles_array
end

function read_ansems_secret_reports()
    ansems_secret_reports = 0x2DE7390 - offset
    ansems_secret_reports_array = ReadArray(ansems_secret_reports, 2)
    return ansems_secret_reports_array
end

function read_olympus_cups_array()
    olympus_cups_address = 0x2DE77D0 - offset
    return ReadArray(olympus_cups_address, 4)
end

function write_world_lines()
    --Opens all world connections on the world map
    world_map_lines_address = 0x2DE78E2 - offset
    WriteArray(world_map_lines_address, {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF})
end

function write_rewards()
    --Removes all obtained items from rewards
    battle_table_address = 0x2D1F3C0 - offset
    rewards_offset = 0xC6A8
    reward_array = {}
    local i = 1
    while i <= 169 * 2 do
        reward_array[i] = 0x00
        i = i + 1
    end
    WriteArray(battle_table_address + rewards_offset, reward_array)
end

function write_chests()
    --Removes all obtained items from chests
    chest_table_address = 0x5259E0 - offset
    chest_array = {}
    local i = 1
    while i <= 511 * 2 do
        chest_array[i] = 0x00
        i = i + 1
    end
    WriteArray(chest_table_address, chest_array)
end

function write_unlocked_worlds(unlocked_worlds_array, monstro_unlocked)
    --Writes unlocked worlds.  Array of 11 values, one for each world
    --TT, WL, OC, DJ, AG, AT, HT, NL, HB, EW, MS
    --00 is invisible
    --01 is visible/unvisited
    --02 is selectable/unvisited
    --03 is incomplete
    --04 is complete
    world_status_address = 0x2DE78C0 - offset
    monstro_status_addresss = world_status_address + 0xA
    WriteArray(world_status_address, unlocked_worlds_array)
    WriteByte(monstro_status_addresss, monstro_unlocked)
end

function write_synth_requirements()
    --Writes to the synth requirements array, making the first 20 items require
    --an unobtainable material, preventing the player from synthing.
    synth_requirements_address = 0x544320 - offset
    synth_array = {}
    local i = 0
    while i < 20 do --First 20 items should be enough to prevent player from unlocking more recipes
        synth_array[(i*4) + 1] = 0xE8 --Requirement (unobtainable)
        synth_array[(i*4) + 2] = 0x00 --Blank
        synth_array[(i*4) + 3] = 0x01 --Number of items needed
        synth_array[(i*4) + 4] = 0x00 --Blank
        i = i + 1
    end
    WriteArray(synth_requirements_address, synth_array)
end

function write_soras_level_up_rewards()
    --Writes Sora's level up rewards to make them empty.
    --Level up rewards will be handled by the client/server.
    battle_table_address = 0x2D1F3C0 - offset
    soras_stat_level_up_rewards_address = battle_table_address + 0x3AC0
    overwrite_array = {}
    local i = 1
    while i <= 99 do
        overwrite_array[i] = 0
        i = i + 1
    end
    WriteArray(soras_stat_level_up_rewards_address, overwrite_array)
end

function write_soras_stats(soras_stats_array)
    --Writes Sora's calculated stats back to memory
    soras_stats_address         = 0x2DE59D6 - offset
    sora_hp_offset              = 0x00
    sora_mp_offset              = 0x02
    sora_ap_offset              = 0x03
    sora_strength_offset        = 0x04
    sora_defense_offset         = 0x05
    sora_accessory_slots_offset = 0x16
    sora_item_slots_offset      = 0x1F
    WriteByte(soras_stats_address + sora_hp_offset              , soras_stats_array[1])
    WriteByte(soras_stats_address + sora_mp_offset              , soras_stats_array[2])
    WriteByte(soras_stats_address + sora_ap_offset              , soras_stats_array[3])
    WriteByte(soras_stats_address + sora_strength_offset        , soras_stats_array[4])
    WriteByte(soras_stats_address + sora_defense_offset         , soras_stats_array[5])
    WriteByte(soras_stats_address + sora_accessory_slots_offset , soras_stats_array[6])
    WriteByte(soras_stats_address + sora_item_slots_offset      , soras_stats_array[7])
end

function write_check_array(check_array)
    inventory_address = 0x2DE5E69 - offset
    check_number_item_address = inventory_address + 0x48
    WriteArray(check_number_item_address, check_array)
end

function write_evidence_chests()
    lotus_forest_evidence_address = 0x2D39B90 - offset
    bizarre_rooom_evidence_address = 0x2D39230 - offset
    --if read_world() == 4 then
    --    if read_room() == 4 then
    --        WriteLong(lotus_forest_evidence_address, 0)
    --        WriteLong(lotus_forest_evidence_address + 0x4B0, 0)
    --    elseif read_room() == 1 then
    --        WriteLong(bizarre_rooom_evidence_address, 0)
    --        WriteLong(bizarre_rooom_evidence_address + 0x4B0, 0)
    --    end
    --end
    if read_world() == 4 then
        if read_room() == 4 then
            local o = 0
            while ReadInt(lotus_forest_evidence_address+4+o*0x4B0) ~= 0x40013 and ReadInt(lotus_forest_evidence_address+4+o*0x4B0) ~= 0 and o > -5 do
                o = o-1
            end
            if ReadLong(lotus_forest_evidence_address+o*0x4B0) == 0x0004001300008203 then
                WriteLong(lotus_forest_evidence_address+o*0x4B0, 0)
                WriteLong(lotus_forest_evidence_address+(o+1)*0x4B0, 0)
            end
        elseif read_room() == 1 then
            local o = 0
            while ReadInt(bizarre_rooom_evidence_address+4+o*0x4B0) ~= 0x40013 and ReadInt(bizarre_rooom_evidence_address+4+o*0x4B0) ~= 0 and o > -5 do
                o = o-1
            end
            if ReadLong(bizarre_rooom_evidence_address+o*0x4B0) == 0x0004001300008003 then
                    WriteLong(bizarre_rooom_evidence_address+o*0x4B0, 0)
                    WriteLong(bizarre_rooom_evidence_address+(o+1)*0x4B0, 0)
                end
            end
        end
end

function write_slides()
    slide_address = 0x2D3CA70 - offset
    if read_world() == 5 and read_room() == 12 then
        for i=0,5 do
            local o = 0
            while ReadInt(slide_address+o*0x4B0+4) ~= 0x40018 and ReadInt(slide_address+o*0x4B0+4) ~= 0 and o > -5 do
                o = o-1
            end
            if ReadInt(slide_address+o*0x4B0+4) == 0x40018 then
                for i=0,5 do
                    if ReadInt(slide_address+(i+o)*0x4B0+4) == 0x40018+(i>1 and i+4 or i) then
                        WriteLong(slide_address+(i+o)*0x4B0, 0)
                    end
                end
            end
        end
    end
end

function write_item(item_offset)
    inventory_address = 0x2DE5E69 - offset
    WriteByte(inventory_address + item_offset, ReadByte(inventory_address + item_offset) + 1)
end

function write_sora_ability(ability_value)
    abilities_address = 0x2DE5A13 - offset
    local i = 1
    while ReadByte(abilities_address + i) ~= 0 do
        i = i + 1
    end
    WriteByte(abilities_address + i, ability_value + 128)
end

function write_shared_abilities_array(shared_abilities_array)
    shared_abilities_address = 0x2DE5F69 - offset
    WriteArray(shared_abilities_address, shared_abilities_array)
end

function write_summons_array(summons_array)
    summons_address = 0x2DE61A0 - offset
    WriteArray(summons_address, summons_array)
end

function write_magic(magic_unlocked_bits, magic_levels_array)
    magic_unlocked_address = 0x2DE5A44 - offset
    magic_levels_offset = 0x41E
    WriteByte(magic_unlocked_address,
        (1 * magic_unlocked_bits[1]) + (2 * magic_unlocked_bits[2]) + (4 * magic_unlocked_bits[3]) + (8 * magic_unlocked_bits[4])
        + (16 * magic_unlocked_bits[5]) + (32 * magic_unlocked_bits[6]) + (64 * magic_unlocked_bits[7]))
    WriteArray(magic_unlocked_address + magic_levels_offset, magic_levels_array)
end

function write_trinities(trinity_bits)
    trinities_unlocked_address = 0x2DE75EB - offset
    WriteByte(trinities_unlocked_address, (1 * trinity_bits[1]) + (2 * trinity_bits[2]) + (4 * trinity_bits[3]) + (8 * trinity_bits[4]) + (16 * trinity_bits[5]))
end

function write_olympus_cups(olympus_cups_array)
    olympus_cups_address = 0x2DE77D0 - offset
    current_olympus_cups_array = read_olympus_cups_array()
    for k,v in pairs(current_olympus_cups_array) do
        if v == 1 then
            olympus_cups_array[k] = v
        end
    end
    WriteArray(olympus_cups_address, olympus_cups_array)
end

function write_level_up_rewards()
    battle_table_address = 0x2D1F3C0 - offset
    level_up_rewards_offset = 0x3AC0
    abilities_1_table_offset = 0x3BF8
    abilities_2_table_offset = 0x3BF8 - 0xD0
    abilities_3_table_offset = 0x3BF8 - 0x68
    level_up_array = {}
    ability_array = {}
    local i = 1
    while i <= 100 do
        level_up_array[i] = 0
        i = i + 1
    end
    WriteArray(battle_table_address + level_up_rewards_offset, level_up_array)
    WriteArray(battle_table_address + abilities_1_table_offset, level_up_array)
    WriteArray(battle_table_address + abilities_2_table_offset, level_up_array)
    WriteArray(battle_table_address + abilities_3_table_offset, level_up_array)
end

function write_e()
    inventory_address = 0x2DE5E69 - offset
    WriteByte(inventory_address, 0)
end

function increment_check_array(check_array)
    if check_array[1] == 255 and check_array[2] == 255 then
        check_array[3] = check_array[3] + 1
    elseif check_array[1] == 255 then
        check_array[2] = check_array[2] + 1
    else
        check_array[1] = check_array[1] + 1
    end
    return check_array
end

function add_to_soras_stats(value)
    stat_increases = {3, 1, 2, 2, 2, 1, 1}
    soras_stats_array = read_soras_stats_array()
    soras_stats_array[value] = soras_stats_array[value] + stat_increases[value]
    write_soras_stats(soras_stats_array)
end

function add_to_shared_abilities_array(shared_abilities_array, value)
    local i = 1
    while shared_abilities_array[i] ~= 0 do
        i = i + 1
    end
    shared_abilities_array[i] = value
    return shared_abilities_array
end

function add_to_summons_array(summons_array, value)
    local i = 1
    while summons_array[i] < 10 do
        i = i + 1
    end
    summons_array[i] = value
    return summons_array
end

function receive_items()
    check_array = read_check_array()
    i = check_array[1] + check_array[2] + check_array[3] + 1
    while file_exists(client_communication_path .. "AP_" .. tostring(i) .. ".item") do
        file = io.open(client_communication_path .. "AP_" .. tostring(i) .. ".item", "r")
        io.input(file)
        received_item_id = tonumber(io.read())
        io.close(file)

       local item = get_item_by_id(received_item_id) or { Name = "UNKNOWN ITEM", ID = -1}

        table.insert(message_cache.items, item)

        if received_item_id >= 2641000 and received_item_id < 2642000 then
            write_item(received_item_id % 2641000)
        elseif received_item_id >= 2643000 and received_item_id < 2644000 then
            write_sora_ability(received_item_id % 2643000)
        elseif received_item_id >= 2644000 and received_item_id < 2645000 then
            add_to_soras_stats(received_item_id % 2644000)
        end

        check_array = increment_check_array(check_array)
        i = i + 1
    end
    write_check_array(check_array)
end

function calculate_full()
    magic_unlocked_bits = {0, 0, 0, 0, 0, 0, 0}
    magic_levels_array  = {0, 0, 0, 0, 0, 0, 0}
    worlds_unlocked_array = {3, 0, 0, 0, 0, 0, 0, 0, 0}
    monstro_unlocked = 0
    shared_abilities_array = {0, 0, 0, 0}
    summons_array = {255, 255, 255, 255, 255, 255}
    trinity_bits = {0, 0, 0, 0, 0}
    olympus_cups_array = {0, 0, 0, 0}
    victory = false
    local i = 1
    while file_exists(client_communication_path .. "AP_" .. tostring(i) .. ".item") do
        file = io.open(client_communication_path .. "AP_" .. tostring(i) .. ".item", "r")
        io.input(file)
        received_item_id = tonumber(io.read())
        io.close(file)
        if received_item_id == 2640000 then
            victory = true
        elseif received_item_id >= 2642000 and received_item_id < 2643000 then
            shared_abilities_array = add_to_shared_abilities_array(shared_abilities_array, received_item_id % 2642000)
        elseif received_item_id >= 2645000 and received_item_id < 2646000 then
            summons_array = add_to_summons_array(summons_array, received_item_id % 2645000)
        elseif received_item_id >= 2646000 and received_item_id < 2647000 then
            magic_unlocked_bits[received_item_id % 2646000] = 1
            magic_levels_array[received_item_id % 2646000] = magic_levels_array[received_item_id % 2646000] + 1
        elseif received_item_id >= 2647000 and received_item_id < 2648000 then
            if received_item_id % 2647000 < 10 then
                worlds_unlocked_array[received_item_id % 2647000] = 3
            elseif received_item_id % 2647000 == 11 then
                monstro_unlocked = 3
            end
        elseif received_item_id >= 2648000 and received_item_id < 2649000 then
            trinity_bits[received_item_id % 2648000] = 1
        elseif received_item_id >= 2649000 then
            olympus_cups_array[received_item_id % 2649000] = 10
        end
        i = i + 1
    end
    if olympus_cups_array[1] == 10 and olympus_cups_array[2] == 10 and olympus_cups_array[3] == 10 then
        olympus_cups_array[4] = 10
    end
    write_magic(magic_unlocked_bits, magic_levels_array)
    write_shared_abilities_array(shared_abilities_array)
    write_summons_array(summons_array)
    write_trinities(trinity_bits)
    write_olympus_cups(olympus_cups_array)
    return victory
end

function send_locations()
    chest_array = read_chests_opened_array()
    chronicles_array = read_chronicles()
    ansems_secret_reports_array = read_ansems_secret_reports()
    soras_level = read_soras_level()
    olympus_cups_array = read_olympus_cups_array()
    for k,v in pairs(chest_array) do
        bits = toBits(v)
        for ik,iv in pairs(bits) do
            if iv == 1 then
                location_id = 2650000 + k * 10 + ik
                if not file_exists(client_communication_path .. "send" .. tostring(location_id)) then
                    file = io.open(client_communication_path .. "send" .. tostring(location_id), "w")
                    io.output(file)
                    io.write("")
                    io.close(file)
                end
            end
        end
    end
    for k,v in pairs(chronicles_array) do
        bits = toBits(v)
        for ik,iv in pairs(bits) do
            if iv == 1 then
                location_id = 2656000 + k * 10 + ik
                if not file_exists(client_communication_path .. "send" .. tostring(location_id)) then
                    file = io.open(client_communication_path .. "send" .. tostring(location_id), "w")
                    io.output(file)
                    io.write("")
                    io.close(file)
                end
            end
        end
    end
    for k,v in pairs(ansems_secret_reports_array) do
        bits = toBits(v)
        for ik,iv in pairs(bits) do
            if iv == 1 then
                location_id = 2657000 + k * 10 + ik
                if not file_exists(client_communication_path .. "send" .. tostring(location_id)) then
                    file = io.open(client_communication_path .. "send" .. tostring(location_id), "w")
                    io.output(file)
                    io.write("")
                    io.close(file)
                end
            end
        end
    end
    for j=1,soras_level do
        location_id = 2658000 + j
        if not file_exists(client_communication_path .. "send" .. tostring(location_id)) then
            file = io.open(client_communication_path .. "send" .. tostring(location_id), "w")
            io.output(file)
            io.write("")
            io.close(file)
        end
    end
    for j=1,#olympus_cups_array do
        if olympus_cups_array[j] == 1 then
            location_id = 2659000 + j
            if not file_exists(client_communication_path .. "send" .. tostring(location_id)) then
                file = io.open(client_communication_path .. "send" .. tostring(location_id), "w")
                io.output(file)
                io.write("")
                io.close(file)
            end
        end
    end
    if victory then
        if not file_exists(client_communication_path .. "victory") then
            file = io.open(client_communication_path .. "victory", "w")
            io.output(file)
            io.write("")
            io.close(file)
        end
    end
end

function GetKHSCII(INPUT)
    local _charTable = {
        [' '] =  0x01,
        ['\n'] =  0x02,
        ['-'] =  0x6E,
        ['!'] =  0x5F,
        ['?'] =  0x60,
        ['%'] =  0x62,
        ['/'] =  0x66,
        ['.'] =  0x68,
        [','] =  0x69,
        [';'] =  0x6C,
        [':'] =  0x6B,
        ['\''] =  0x71,
        ['('] =  0x74,
        [')'] =  0x75,
        ['['] =  0x76,
        [']'] =  0x77,
        ['¡'] =  0xCA,
        ['¿'] =  0xCB,
        ['À'] =  0xCC,
        ['Á'] =  0xCD,
        ['Â'] =  0xCE,
        ['Ä'] =  0xCF,
        ['Ç'] =  0xD0,
        ['È'] =  0xD1,
        ['É'] =  0xD2,
        ['Ê'] =  0xD3,
        ['Ë'] =  0xD4,
        ['Ì'] =  0xD5,
        ['Í'] =  0xD6,
        ['Î'] =  0xD7,
        ['Ï'] =  0xD8,
        ['Ñ'] =  0xD9,
        ['Ò'] =  0xDA,
        ['Ó'] =  0xDB,
        ['Ô'] =  0xDC,
        ['Ö'] =  0xDD,
        ['Ù'] =  0xDE,
        ['Ú'] =  0xDF,
        ['Û'] =  0xE0,
        ['Ü'] =  0xE1,
        ['ß'] =  0xE2,
        ['à'] =  0xE3,
        ['á'] =  0xE4,
        ['â'] =  0xE5,
        ['ä'] =  0xE6,
        ['ç'] =  0xE7,
        ['è'] =  0xE8,
        ['é'] =  0xE9,
        ['ê'] =  0xEA,
        ['ë'] =  0xEB,
        ['ì'] =  0xEC,
        ['í'] =  0xED,
        ['î'] =  0xEE,
        ['ï'] =  0xEF,
        ['ñ'] =  0xF0,
        ['ò'] =  0xF1,
        ['ó'] =  0xF2,
        ['ô'] =  0xF3,
        ['ö'] =  0xF4,
        ['ù'] =  0xF5,
        ['ú'] =  0xF6,
        ['û'] =  0xF7,
        ['ü'] =  0xF8
    }

    local _returnArray = {}

    local i = 1
    local z = 1

    while z <= #INPUT do
        local _char = INPUT:sub(z, z)

        if _char >= 'a' and _char <= 'z' then
            _returnArray[i] = string.byte(_char) - 0x1C
            z = z + 1
        elseif _char >= 'A' and _char <= 'Z' then
            _returnArray[i] = string.byte(_char) - 0x16
            z = z + 1
        elseif _char >= '0' and _char <= '9' then
            _returnArray[i] = string.byte(_char) - 0x0F
            z = z + 1
        elseif _char == '{' then
            local _str =
            {
                INPUT:sub(z + 1, z + 1),
                INPUT:sub(z + 2, z + 2),
                INPUT:sub(z + 3, z + 3),
                INPUT:sub(z + 4, z + 4),
                INPUT:sub(z + 5, z + 5)
            }

            if _str[1] == '0' and _str[2] == 'x' and _str[5] == '}' then

                local _s = _str[3] .. _str[4]

                _returnArray[i] = tonumber(_s, 16)
                z = z + 6
            end
        else
            if _charTable[_char] ~= nil then
                _returnArray[i] = _charTable[_char]
                z = z + 1
            else
                _returnArray[i] = 0x01
                z = z + 1
            end
        end

        i = i + 1
    end

    table.insert(_returnArray, 0x00)
    return _returnArray
end

function get_colour_offset(colour_name)
  if       colour_name == "red"         then return 0
    elseif colour_name == "blue"        then return 1
    elseif colour_name == "green"       then return 2
    elseif colour_name == "orange"      then return 3
    elseif colour_name == "lightred"    then return 4
    elseif colour_name == "lightblue"   then return 5
    elseif colour_name == "lightgreen"  then return 6
    elseif colour_name == "lightorange" then return 7
    elseif colour_name == "white"       then return 8
    elseif colour_name == "black"       then return 9
    else return 0
  end
end

function show_prompt_for_item(item)
  local text_1 = ""
  local text_2 = { { item.Name } }

  local category = item_categories.consumables;
  local smallId = item.ID - 2640000

  if smallId > 1000 and smallId < 1009 then
    category = item_categories.consumables
  elseif smallId > 1016 and smallId < 1136 then
    category = item_categories.equipment
  elseif smallId > 2000 and smallId < 4001 then
    category = item_categories.abilities
  elseif smallId > 4000 and smallId < 5000 then
    category = item_categories.consumables
  elseif smallId > 4999 and smallId < 7000 then
    category = item_categories.magic_trinities_summons
  elseif smallId > 8000 and smallId < 9000 then
    category = item_categories.magic_trinities_summons
  elseif smallId > 7000  and smallId < 10000 then
    category = item_categories.unlocks
  end

  local colour = "red";
  if item.Progression then
    colour = "black"
  end

  --maybe colours when colours are beautiful
  if category == item_categories.equipment then
    -- colour = "red"
    text_1 = "New Equipment"
  elseif category == item_categories.consumables then
    -- colour = "green"
  elseif category == item_categories.unlocks then
    -- colour = "black"
    text_1 = "Now Accessible"
  elseif category == item_categories.abilities then
    -- colour = "orange"
    text_1 = "Learned Ability"
  elseif category == item_categories.magic_trinities_summons then
    -- colour = "blue"
  end

  show_prompt({ text_1 }, text_2, null, colour)
end

function show_prompt(input_title, input_party, duration, colour)
    local _boxMemory = 0x249740A
    local _textMemory = 0x2A1379A;

    local _partyOffset = 0x3A20;

    for i = 1, #input_title do
        if input_title[i] then
            WriteArray(_textMemory + 0x20 * (i - 1), GetKHSCII(input_title[i]))
        end
    end

    for z = 1, 3 do
        local _boxArray = input_party[z];

        local colourOffset;

        if type(colour) == "string" then
            colourOffset = get_colour_offset(colour) * 0x10
        else
            colourOffset = colour
        end

        local _colorBox  = 0x018408A + colourOffset
        local _colorText = 0x01840CA + colourOffset

        if _boxArray then
            local _textAddress = (_textMemory + 0x70) + (0x140 * (z - 1)) + (0x40 * 0)
            local _boxAddress = _boxMemory + (_partyOffset * (z - 1)) + (0xBA0 * 0)

            -- Write the box count.
            WriteInt(0x24973FA + 0x04 * (z - 1), 1)

            -- Write the Title Pointer.
            WriteLong(_boxAddress + 0x30, BASE_ADDR  + _textMemory + 0x20 * (z - 1))

            if _boxArray[2] then
                -- String Count is 2.
                WriteInt(_boxAddress + 0x18, 0x02)

                -- Second Line Text.
                WriteArray(_textAddress + 0x20, GetKHSCII(_boxArray[2]))
                WriteLong(_boxAddress + 0x28, BASE_ADDR  + _textAddress + 0x20)
            else
                -- String Count is 1
                WriteInt(_boxAddress + 0x18, 0x01)
            end

            -- First Line Text
            WriteArray(_textAddress, GetKHSCII(_boxArray[1]))
            WriteLong(_boxAddress + 0x20, BASE_ADDR  + _textAddress)

            -- Reset box timers.
            WriteInt(_boxAddress + 0x0C, duration)
            WriteFloat(_boxAddress + 0xB80, 1)

            -- Set box colors.
            WriteLong(_boxAddress + 0xB88, BASE_ADDR  + _colorBox)
            WriteLong(_boxAddress + 0xB90, BASE_ADDR  + _colorText)

            -- Show the box.
            WriteInt(_boxAddress, 0x01)
        end
    end
end

function handle_messages()
  local item = message_cache.items[1]

  if item ~= nil then
    show_prompt_for_item(item)
    table.remove(message_cache.items, 1)
    return
  end


  local debugmsg = message_cache.debug[1]
  if debugmsg ~= nil then
    show_prompt({ 'debug' }, {{'Colouroffset: ' .. tostring(colourOffsetIterator)}}, null, colourOffsetIterator)
    -- table.remove(message_cache.debug, 1) -- show forever
    colourOffsetIterator = colourOffsetIterator + 4
    return
  end

end

function main()
    receive_items()
    victory = calculate_full()
    send_locations(victory)

    --Cleaning up static things
    write_synth_requirements()
    write_chests()
    write_rewards()
    --write_evidence_chests()
    --write_slides()
    write_world_lines()
    write_level_up_rewards()
    write_e()
    handle_messages()
end

function test()
    chests_opened_array = read_chests_opened_array()
    ConsolePrint(toBits(chests_opened_array[21])[1])
    write_world_lines()
    write_unlocked_worlds({0x3, 0x0, 0x3, 0x0, 0x0, 0x0, 0x0, 0x3, 0x0, 0x0, 0x0})
    write_synth_requirements()
    soras_abilities = read_soras_abilities_array()
    ConsolePrint(soras_abilities[1])
    ConsolePrint("Sora's Current Level: " .. tostring(read_soras_level()))
    check_array = read_check_array()
    check_number = check_array[1] + check_array[2] + check_array[3]
    ConsolePrint("Current check number: " .. tostring(check_number))
    sora_stats_array = read_soras_stats_array()
    ConsolePrint("Sora's Max HP = " .. tostring(sora_stats_array[1]))
    write_rewards()
    write_chests()
    ConsolePrint("Current World: " .. tostring(read_world()))
    ConsolePrint("Current Room: " .. tostring(read_room()))
    write_evidence_chests()
    write_slides()
end

function _OnInit()
	if GAME_ID == 0xAF71841E and ENGINE_TYPE == "BACKEND" then
		canExecute = true
		ConsolePrint("KH1 detected, running script")
	else
		ConsolePrint("KH1 not detected, not running script")
	end
end

function _OnFrame()
    if frame_count % 120 == 0 and canExecute then
        main()
        --test()
    end
    frame_count = frame_count + 1
    write_unlocked_worlds(worlds_unlocked_array, monstro_unlocked)
end
