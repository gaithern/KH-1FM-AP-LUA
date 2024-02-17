function _OnInit()
Now = 0x233CADC - 0x3A0606
Items = 0x2DE5E6A - 0x3A0606
ChestFlags = 0x2DE60CC - 0x3A0606
EventFlags = 0x2DE67D8 - 0x3A0606
RoomFlags = 0x2DE7AAE - 0x3A0606
CutsceneFlags = 0x2DE63D0 - 0x3A0606
end
    
function _OnFrame()
    if ReadByte(Now+0x00) == 0x04 and ReadByte(EventFlags+0x0F06) == 0x00 then
        WriteByte(EventFlags+0x0F06, 0xFF) --All Evidence Boxes Opened
    end
    if ReadByte(Items+0xDE) == 0x01 and ReadByte(EventFlags+0x00) == 0x00 then
        WriteByte(EventFlags+0x00, 0x01) --Found Footprints
    end
    if ReadByte(CutsceneFlags+0x0B06) < 0x32 and ReadByte(EventFlags+0x1008) == 0x00 and ReadByte(EventFlags+0x0125) == 0x00 then
        WriteByte(EventFlags+0x1008, 0x01) --Remove Olympus Coliseum Yellow Trinity before End of 1st Visit
    elseif ReadByte(CutsceneFlags+0x0B06) >= 0x32 and ReadByte (EventFlags+0x1008) == 0x01 and ReadByte(EventFlags+0x0125) == 0x00 then
        WriteByte(EventFlags+0x1008, 0x00) --Restore Olympus Coliseum Yellow Trinity after End of 1st Visit
    end
    if ReadByte(Now+0x00) == 0x05 and ReadByte(Now+0x68) == 0x09 and ReadByte(CutsceneFlags+0x0B05) == 0x53 then
        WriteByte(CutsceneFlags+0x0B05, 0x50) --Deep Jungle Clayton Softlock Fix
    end
    if ReadByte(Items+0xE3) == 0x01 and ReadByte(CutsceneFlags+0x0B0C) == 0x2B and ReadByte(ChestFlags+0x00) == 0x02 then
        WriteByte(CutsceneFlags+0x0B0C, 0x32) --HT Story Progression after finding Jack-in-the-Box
        WriteByte(RoomFlags+0x19, 0x05) --Boneyard Room Flag
        WriteByte(RoomFlags+0x1E, 0x03) --Research Lab Room Flag
    end
end