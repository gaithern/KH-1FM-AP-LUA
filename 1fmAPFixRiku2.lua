-----------------------------------
------ Kingdom Hearts 1 FM AP -----
------         by Gicu        -----
-----------------------------------

LUAGUI_NAME = "kh1fmAP"
LUAGUI_AUTH = "Gicu"
LUAGUI_DESC = "Kingdom Hearts 1FM AP Integration"

local offset = 0x3A0606
local canExecute = false
frame_count = 0
corrected = false
second_visit = {false,false,false,false}

function read_world_progress_array()
    --[[Reads an array of world progress bytes that correspond to Sora's progress through
    each world.  The order of worlds are as follows:
    Traverse Town, Deep Jungle, Olympus Coliseum, Wonderland, Agrabah, Monstro,
    Atlantica, Unused, Halloween Town, Neverland, Hollow Bastion, End of the World]]
    world_progress_address = 0x2DE65D0 - 0x200 + 0xB04 - offset
    world_progress_array = ReadArray(world_progress_address, 12)
    extra_traverse_town_progress_address = world_progress_address + 0xE
    world_progress_array[13] = ReadByte(extra_traverse_town_progress_address)
    return world_progress_array
end

function write_world_progress_byte(world_index, progress_byte)
    world_progress_address = 0x2DE65D0 - 0x200 + 0xB04 - offset
    WriteByte(world_progress_address + (world_index-1), progress_byte)
end

function define_world_progress_reset_array()
    world_progress_reset_array = {}
    --Wonderland
    world_progress_reset_array[1] = {
        {0x00, {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0D, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}}
       ,{0x04, {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0D, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}}
       ,{0x07, {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0D, 0x0D, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}}
       ,{0x0D, {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0D, 0x0D, 0x02, 0x01, 0x0D, 0x00, 0x00, 0x00, 0x00, 0x0D}}
       ,{0x11, {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0D, 0x0D, 0x02, 0x01, 0x0D, 0x00, 0x00, 0x00, 0x00, 0x0D}}
       ,{0x21, {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0D, 0x0E, 0x02, 0x02, 0x0E, 0x00, 0x0E, 0x0E, 0x0E, 0x0E}}
       ,{0x2B, {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0D, 0x00, 0x02, 0x02, 0x0E, 0x00, 0x0E, 0x0E, 0x0F, 0x0E}}
       ,{0x2E, {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0D, 0x00, 0x02, 0x02, 0x0E, 0x00, 0x0E, 0x0E, 0x0F, 0x0E}}
       ,{0x30, {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0D, 0x02, 0x02, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0E}}
     --,{0x32, {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0D, 0x0E, 0x02, 0x02, 0x0E, 0x00, 0x0F, 0x0F, 0x0F, 0x0E}}
       ,{0x32, {0x02, 0x00, 0x00, 0x00, 0x11, 0x04, 0x0D, 0x10, 0x02, 0x02, 0x10, 0x00, 0x10, 0x10, 0x10, 0x10}}
    }
    --Deep Jungle
    world_progress_reset_array[2] = {
        {0x00, {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}}
       ,{0x0A, {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}}
       ,{0x14, {0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}}
       ,{0x17, {0x0F, 0x00, 0x0F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0F, 0x00, 0x00, 0x00, 0x00}}
       ,{0x1A, {0x0F, 0x00, 0x0F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0F, 0x00, 0x00, 0x00, 0x00}}
       ,{0x20, {0x0F, 0x00, 0x0F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0F, 0x0F, 0x00, 0x00, 0x00}}
       ,{0x23, {0x02, 0x00, 0x0F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0F, 0x0F, 0x00, 0x00, 0x00}}
       ,{0x28, {0x0F, 0x00, 0x0F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0F, 0x0F, 0x00, 0x00, 0x00}}
       ,{0x2B, {0x03, 0x00, 0x02, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x02, 0x01, 0x00, 0x00, 0x00}}
       ,{0x32, {0x03, 0x00, 0x02, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x02, 0x0E, 0x00, 0x00, 0x00}}
       ,{0x35, {0x0D, 0x00, 0x0D, 0x00, 0x00, 0x00, 0x0D, 0x00, 0x00, 0x00, 0x00, 0x0D, 0x0E, 0x00, 0x00, 0x00}}
       ,{0x37, {0x0D, 0x00, 0x0D, 0x00, 0x00, 0x00, 0x0D, 0x00, 0x00, 0x00, 0x00, 0x0D, 0x02, 0x00, 0x00, 0x00}}
       ,{0x39, {0x0D, 0x00, 0x01, 0x00, 0x00, 0x00, 0x0D, 0x00, 0x00, 0x00, 0x00, 0x0D, 0x0E, 0x00, 0x00, 0x00}}
       ,{0x3C, {0x0D, 0x00, 0x01, 0x00, 0x00, 0x00, 0x0D, 0x00, 0x00, 0x00, 0x00, 0x0D, 0x0E, 0x00, 0x00, 0x00}}
       ,{0x3F, {0x0D, 0x00, 0x01, 0x00, 0x00, 0x00, 0x0D, 0x00, 0x00, 0x00, 0x00, 0x0D, 0x0E, 0x00, 0x00, 0x00}}
       ,{0x42, {0x0D, 0x01, 0x0D, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x0D, 0x0E, 0x00, 0x00, 0x00}}
       ,{0x44, {0x0D, 0x01, 0x0D, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x0D, 0x0E, 0x00, 0x00, 0x00}}
       ,{0x46, {0x0D, 0x01, 0x0D, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x0D, 0x0E, 0x00, 0x00, 0x00}}
       ,{0x49, {0x0D, 0x01, 0x0D, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x0E, 0x00, 0x00, 0x00}}
       ,{0x50, {0x0D, 0x01, 0x0D, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x0E, 0x00, 0x00, 0x00}}
       ,{0x53, {0x0D, 0x01, 0x0D, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x0E, 0x00, 0x00, 0x00}}
       ,{0x56, {0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}}
       ,{0x59, {0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}}
       ,{0x5C, {0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}}
       ,{0x5F, {0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}}
     --,{0x6E, {0x0D, 0x01, 0x0D, 0x00, 0x00, 0x00, 0x0D, 0x00, 0x00, 0x00, 0x00, 0x0D, 0x0E, 0x00, 0x00, 0x00}}
       ,{0x6E, {0x11, 0x01, 0x11, 0x00, 0x00, 0x00, 0x11, 0x00, 0x00, 0x00, 0x00, 0x11, 0x11, 0x00, 0x00, 0x00}}
    }
    --Agrabah
    world_progress_reset_array[3] = {
        {0x00, {0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}}
       ,{0x0A, {0x00, 0x00, 0x0D, 0x02, 0x00, 0x0D, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}}
       ,{0x17, {0x03, 0x02, 0x0D, 0x0D, 0x00, 0x0D, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}}
       ,{0x1E, {0x04, 0x02, 0x0D, 0x0D, 0x00, 0x0D, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}}
       ,{0x24, {0x05, 0x0E, 0x0E, 0x0E, 0x0E, 0x0E, 0x0E, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}}
       ,{0x27, {0x05, 0x0E, 0x0E, 0x0E, 0x0E, 0x0E, 0x0E, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}}
       ,{0x35, {0x05, 0x03, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}}
       ,{0x3F, {0x05, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x00, 0x0F, 0x0F, 0x0F, 0x0F, 0x00, 0x00, 0x00, 0x00}}
       ,{0x46, {0x05, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x00, 0x0F, 0x0F, 0x0F, 0x00, 0x00, 0x00, 0x00, 0x00}}
       ,{0x49, {0x05, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x00, 0x0F, 0x0F, 0x0F, 0x00, 0x00, 0x00, 0x00, 0x00}}
       ,{0x50, {0x05, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x00, 0x0F, 0x0F, 0x0F, 0x00, 0x00, 0x00, 0x00, 0x00}}
       ,{0x53, {0x05, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x00, 0x0F, 0x0F, 0x0F, 0x00, 0x00, 0x00, 0x00, 0x00}}
       ,{0x5A, {0x05, 0x04, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x00, 0x0F, 0x0F, 0x0F, 0x00, 0x00, 0x00, 0x00, 0x00}}
       ,{0x5D, {0x05, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0F, 0x0F, 0x0F, 0x00, 0x00, 0x00, 0x00, 0x00}}
       ,{0x64, {0x05, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0F, 0x0F, 0x0F, 0x00, 0x00, 0x00, 0x00, 0x00}}
       ,{0x6E, {0x05, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0F, 0x0F, 0x0F, 0x00, 0x00, 0x00, 0x00, 0x00}}
       ,{0x78, {0x05, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0F, 0x0F, 0x0F, 0x00, 0x00, 0x00, 0x00, 0x00}}
     --,{0x82, {0x05, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x00, 0x0F, 0x0F, 0x0F, 0x0F, 0x00, 0x00, 0x00, 0x00}}
       ,{0x82, {0x05, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x00, 0x10, 0x10, 0x10, 0x10, 0x00, 0x00, 0x00, 0x00}}
    }
    --Neverland
    world_progress_reset_array[4] = {
        {0x00, {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}}
       ,{0x04, {0x00, 0x00, 0x00, 0x00, 0x00, 0x0D, 0x0D, 0x0D, 0x0D, 0x00, 0x0D, 0x00, 0x02, 0x00, 0x00, 0x00}}
       ,{0x14, {0x00, 0x00, 0x00, 0x00, 0x00, 0x0D, 0x0D, 0x0D, 0x0D, 0x02, 0x0D, 0x00, 0x00, 0x00, 0x00, 0x00}}
       ,{0x1E, {0x00, 0x00, 0x00, 0x00, 0x00, 0x0D, 0x0D, 0x0D, 0x0D, 0x02, 0x0D, 0x02, 0x00, 0x00, 0x00, 0x00}}
       ,{0x28, {0x00, 0x00, 0x00, 0x00, 0x00, 0x0D, 0x0D, 0x0D, 0x0D, 0x0D, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00}}
       ,{0x32, {0x00, 0x00, 0x00, 0x00, 0x00, 0x0D, 0x0D, 0x0D, 0x0D, 0x0D, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00}}
       ,{0x35, {0x00, 0x00, 0x00, 0x00, 0x00, 0x0E, 0x0E, 0x0E, 0x0E, 0x0E, 0x0E, 0x0E, 0x00, 0x00, 0x00, 0x02}}
       ,{0x38, {0x00, 0x00, 0x00, 0x00, 0x00, 0x0E, 0x0E, 0x0E, 0x0E, 0x0E, 0x0E, 0x0E, 0x00, 0x01, 0x00, 0x00}}
       ,{0x3C, {0x00, 0x00, 0x00, 0x00, 0x00, 0x0E, 0x0E, 0x0E, 0x0E, 0x0E, 0x0E, 0x0E, 0x00, 0x01, 0x00, 0x00}}
       ,{0x3F, {0x00, 0x00, 0x00, 0x00, 0x00, 0x0E, 0x0E, 0x0E, 0x0E, 0x0E, 0x0E, 0x0E, 0x00, 0x01, 0x00, 0x00}}
       ,{0x50, {0x00, 0x00, 0x00, 0x00, 0x00, 0x0E, 0x0E, 0x0E, 0x0E, 0x0E, 0x0E, 0x0E, 0x00, 0x01, 0x00, 0x00}}
       ,{0x53, {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x02, 0x00, 0x00}}
       ,{0x56, {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x02, 0x00, 0x00}}
       ,{0x5A, {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x02, 0x00, 0x00}}
       ,{0x6A, {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x02, 0x00, 0x00}}
       ,{0x6E, {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x02, 0x00, 0x00}}
     --,{0x78, {0x00, 0x00, 0x00, 0x00, 0x00, 0x0E, 0x0E, 0x0E, 0x0E, 0x0E, 0x0E, 0x0E, 0x00, 0x0E, 0x02, 0x00}}
       ,{0x78, {0x12, 0x12, 0x00, 0x12, 0x12, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x00, 0x11, 0x01, 0x00}}
    }
    return world_progress_reset_array
end

world_progress_reset_array = define_world_progress_reset_array()

function correct_world_flags(world_offset, corrected_world_flag_array)
    world_flags_address = 0x2DE79D0 + 0x6C - offset
    WriteArray(world_flags_address + world_offset, corrected_world_flag_array)
end

function read_world_flags(world_offset)
    world_flags_address = 0x2DE79D0 + 0x6C - offset
    return ReadArray(world_flags_address + world_offset, 16)
end

function turn_on_kurt_zisa()
    carpet_takes_you_to_kurt_zisa_address = 0x2DE6ED0 - offset
    WriteByte(carpet_takes_you_to_kurt_zisa_address, 0xF0)
end

function fix_library()
    world_flag_base_address = 0x2DE79D0 + 0x6C - offset
    hollow_bastion_world_flag_base_address = world_flag_base_address + 0xB0
    library_address = hollow_bastion_world_flag_base_address + 0x7
    if ReadByte(library_address) ~= 0x02 then
        WriteByte(library_address, 0x02)
    end
end

function main()
    specific_worlds_progress_array = {}
    world_progress_array = read_world_progress_array()
    hollow_bastion_progress = world_progress_array[11]
    corrected_world_flag_arrays = {}
    second_visit_test_bytes = {0x30,0x5F,0x82,0x6E}
    final_bytes = {0x32,0x6E,0x82,0x78}
    world_progress_indexes = {4,2,5,10}
    check_byte_num = {8, 3, 3, 6}
    world_offset = {0x30, 0x40, 0x60, 0xA0}
    
    
    if hollow_bastion_progress >= 0x82 then --Riku 2 Defeated
        specific_worlds_progress_array[1] = world_progress_array[4]
        specific_worlds_progress_array[2] = world_progress_array[2]
        specific_worlds_progress_array[3] = world_progress_array[5]
        specific_worlds_progress_array[4] = world_progress_array[10]
        for world_num, world_progress_byte in pairs(specific_worlds_progress_array) do
            if world_progress_byte < final_bytes[world_num] and read_world_flags(world_offset[world_num])[check_byte_num[world_num]] >= 0x10 then
                for i=1,#world_progress_reset_array[world_num] do
                    if world_progress_byte >= world_progress_reset_array[world_num][i][1] then
                        reset_array = world_progress_reset_array[world_num][i][2]
                        correct_world_flags(world_offset[world_num], reset_array)
                    end
                end
            end
        end
        for i=1,#second_visit_test_bytes do
            if not second_visit[i] and specific_worlds_progress_array[i] >= second_visit_test_bytes[i] then
                if not (i == 4 and specific_worlds_progress_array[i] == 0x96) then --Ignore if Neverland is already post Phantom
                    write_world_progress_byte(world_progress_indexes[i], final_bytes[i])
                    correct_world_flags(world_offset[i], world_progress_reset_array[i][#world_progress_reset_array[i]][2])
                    second_visit[i] = true
                    if i == 3 then --Agrabah
                        turn_on_kurt_zisa()
                    end
                end
            end
        end
    end
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
    if frame_count == 0 and canExecute then
        main()
        fix_library()
    end
    frame_count = (frame_count + 1) % 120
end