-----------------------------------
------ Kingdom Hearts 1 FM AP -----
------         by Gicu        -----
-----------------------------------

LUAGUI_NAME = "1fmAPKeybladeLock"
LUAGUI_AUTH = "KSX and Gicu"
LUAGUI_DESC = "Kingdom Hearts 1FM AP Integration"

game_version = 1 --1 for ESG 1.0.0.9, 2 for Steam 1.0.0.9

chestslocked = true
interactinbattle = false
interactset = false
canExecute = false
settings_read = false

if os.getenv('LOCALAPPDATA') ~= nil then
    client_communication_path = os.getenv('LOCALAPPDATA') .. "\\KH1FM\\"
else
    client_communication_path = os.getenv('HOME') .. "/KH1FM/"
    ok, err, code = os.rename(client_communication_path, client_communication_path)
    if not ok and code ~= 13 then
        os.execute("mkdir " .. path)
    end
end

function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

function read_settings()
    if not settings_read then
        if file_exists(client_communication_path .. "chestslocked.cfg") then
            chestslocked = true
            settings_read = true
        elseif file_exists(client_communication_path .. "chestsunlocked.cfg") then
            chestslocked = false
            settings_read = true
        end
        if file_exists(client_communication_path .. "interactinbattle.cfg") then
            interactinbattle = true
        end
    end
end

function has_correct_keyblade()
    stock_address = {0x2DEA179, 0x2DE97F9}
    world_address = {0x2340DDC, 0x233FE84}
    keyblade_offsets = {nil, nil, 94, 98, 86, 96, nil, 87, 90, 89, 93, 99, 88, nil, 91, 97}
    current_world = ReadByte(world_address[game_version])
    if keyblade_offsets[current_world] ~= nil then
        keyblade_amt = ReadByte(stock_address[game_version] + keyblade_offsets[current_world])
        if keyblade_amt > 0 then
            return true
        end
    end
    return false
end

function get_dg_count()
    dg = 0
    party_slot_1_address = {0x2DEA16F, 0x2DE97EF}
    party_slot_2_address = {0x2DEA170, 0x2DE97F0}
    if ReadByte(party_slot_1_address[game_version]) == 1 or ReadByte(party_slot_1_address[game_version]) == 2 then
        dg = dg + 1
    end
    if ReadByte(party_slot_2_address[game_version]) == 1 or ReadByte(party_slot_2_address[game_version]) == 2 then
        dg = dg + 1
    end
    return dg
end

function _OnInit()
    IsEpicGLVersion  = 0x3A2B86
    IsSteamGLVersion = 0x3A29A6
    if GAME_ID == 0xAF71841E and ENGINE_TYPE == "BACKEND" then
        if ReadByte(IsEpicGLVersion) == 0xFF then
            ConsolePrint("Epic Version Detected")
            game_version = 1
        end
        if ReadByte(IsSteamGLVersion) == 0xFF then
            ConsolePrint("Steam Version Detected")
            game_version = 2
        end
        canExecute = true
    end
end

function _OnFrame()
    if canExecute then
        read_settings()
        chests_address = {0x2B35C4, 0x2B5764}
        chests = ReadByte(chests_address[game_version])
        if (chestslocked and has_correct_keyblade() and chests == 0x72) or not chestslocked then
            if interactinbattle then
                WriteByte(chests_address[game_version], 0x73)
            else
                WriteByte(chests_address[game_version], 0x74)
            end
        elseif chestslocked and not has_correct_keyblade() and chests ~= 0x72 then
            WriteByte(chests_address[game_version], 0x72)
        end
        if interactinbattle then
            if not interactset then
                Examine = {0x2926B9, 0x294849}
                Talk = {0x2926F9, 0x294889}
                WriteByte(Examine[game_version], 0x70)
                WriteByte(Talk[game_version], 0x70)
                interactset = true
            end
            Trinity = {0x1A2A6F, 0x1A4BBF}
            if get_dg_count() >= 2 then
                WriteByte(Trinity[game_version], 0x71) -- Forced
            else
                WriteByte(Trinity[game_version], 0x75) -- Default
            end
        end
    end
end
