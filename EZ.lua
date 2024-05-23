frame = 0
is_cure = true
is_mp = true
is_hp = true
is_drive_recharge = true
not_in_drive_frame = 0
is_mickey = true
is_no_rule_drive = true
is_longer_drive = true
in_drive_frame = 0
is_code_printed = false
has_to_init = true

mickey1_0_0_2 = {}
mickey1_0 = {}

no_rule_drive = {}

function _OnInit()
    offset = 0x56454E
    sora_level_stat = 0x2A9A168 + 0x40 - offset
    input = 0x711488 - offset
    L3_triangle = 0x1002
    L3_square = 0x8002
    L3_circle = 0x2002
    L3_cross = 0x4002
    L3_L1 = 0x402
    L3_L2 = 0x102
    L3_R1 = 0x802
    cure = 0x2A5A820 - offset + 0x40
    cura = 0x2A5B4B0 - offset + 0x40
    curaga = 0x2A5B4E0 - offset + 0x40
    pause_status_address = 0x0AB9038 + 0x40 - offset
    battle_state_address = 0x2A0EB04 - offset
    is_controllable_address = 0x2A148A8 + 0x40 - offset
    menu_status_address = 0x79A5D0 - offset
    sora_unit_stat = 0x2A20C58 + 0x40 - offset
    DriveList = 0x3F059E - offset
    DriveWithoutParty = 0x3FF734 - offset
    DriveWithoutForcedParty = 0x3E107C - offset
    DriveForceEvents = 0x3FF788 - offset
    PartyWontRemove = 0x3FE3C4 - offset
    RoomTransitionDontRemoveParty = 0x3C07CE - offset
    DriveWhenPartyisDead = 0x3F05BA - offset
    current_form_adress = 0x40 + 0x09AA594 - offset
    current_summon_adress = 0x40 + 0x09AA595 - offset
end

function _OnFrame()
    if has_to_init and frame == 110 then
        if ReadInt(sora_level_stat) > 40 then
            ConsolePrint("Rando detected")
            rando_offset = 0x580
        else
            ConsolePrint("Vanilla game detected")
            rando_offset = 0
        end

        mickey1_0_0_2[1] = ReadArray(0x3FA07E - offset, 5)
        mickey1_0_0_2[2] = ReadArray(0x3FA10A - offset, 2)
        mickey1_0_0_2[3] = ReadArray(0x3C3F15 - offset, 8)
        mickey1_0[1] = ReadArray(0x3F9EEE - offset, 5)
        mickey1_0[2] = ReadArray(0x3F9F7A - offset, 2)
        mickey1_0[3] = ReadArray(0x3C3D85 - offset, 8)

        no_rule_drive[1] = ReadByte(DriveList)
        no_rule_drive[2] = ReadShort(DriveWithoutParty)
        no_rule_drive[3] = ReadByte(DriveWithoutForcedParty)
        no_rule_drive[4] = ReadShort(DriveForceEvents)
        no_rule_drive[5] = ReadByte(PartyWontRemove)
        no_rule_drive[6] = ReadByte(RoomTransitionDontRemoveParty)
        no_rule_drive[7] = ReadByte(DriveWhenPartyisDead)

        apply_cure()
        apply_mickey()
        apply_no_rule_drive()
        has_to_init = false
    end

    battle_state = ReadInt(battle_state_address)
    pause_status = ReadInt(pause_status_address)
    menu_status = ReadByte(menu_status_address)
    is_controllable = ReadByte(is_controllable_address)

    sora_max_mp_charge_time = ReadFloat(sora_unit_stat + 0x1C0)

    gauge_fill = ReadByte(sora_unit_stat + 0x1B0)
    max_drive = ReadByte(sora_unit_stat + 0x1B2)
    current_drive = ReadByte(sora_unit_stat + 0x1B1)
    current_drive_time = ReadFloat(sora_unit_stat + 0x1B4)
    max_drive_time = ReadFloat(sora_unit_stat + 0x1B8)
    current_form = ReadByte(current_form_adress)
    current_summon = ReadByte(current_summon_adress)

    frame = frame + 1
    update_drive_recharge()

    if is_longer_drive then
        update_longer_drive()
        longer_drive()
    end 



    if ReadShort(input) == L3_triangle then
        toggle_cure()
    end

    if ReadShort(input) == L3_square then
        toggle_drive_recharge()
    end

    if ReadShort(input) == L3_circle then
        toggle_mp()
    end

    if ReadShort(input) == L3_cross then
        toggle_mickey()
    end

    if ReadShort(input) == L3_L1 then
        toggle_no_rule_drive()
    end

    if ReadShort(input) == L3_L2 then
        toggle_hp()
    end

    if ReadShort(input) == L3_R1 then
        toggle_longer_drive()
    end

    if is_mickey then
        A = ReadLong(0x0ABA7E8 - offset)+0x170, true
        B = ReadLong(0x0ABA7E8 - offset)+0x178, true

        if ReadByte(0x714DB8 - offset) ~= 0xFF and ReadLong(A,true) == 0x0 then
            WriteLong(A,ReadLong(B,true)-0x26A0, true)
        end
    end

    if frame == 60 then
        is_code_printed = false
    end

    if gauge_fill >= 100 and is_drive_recharge then
        not_in_drive_frame = 0
        recharge_drive()
        if current_drive + 1 ~= max_drive then
            gauge_fill = WriteByte(sora_unit_stat + 0x1B0, 0)
        end
    end

    if frame == 120 then
        frame = 0
        if is_mp then
            mp_recharge()
        end
        if is_hp then
            hp_recharge()
        end 
    end
end

function toggle_cure()
    if is_cure then
        if not is_code_printed then
            is_code_printed = true
            is_cure = false
            remove_cure()
            ConsolePrint("better cure cost disabled")
        end
    else
        if not is_code_printed then
            is_code_printed = true
            is_cure = true
            apply_cure()
            ConsolePrint("better cure cost enabled")
        end
    end
end

function apply_cure()
    WriteByte(cure, 25)
    WriteByte(cura, 25)
    WriteByte(curaga, 25)
end

function remove_cure()
    WriteByte(cure, 255)
    WriteByte(cura, 255)
    WriteByte(curaga, 255)
end

function toggle_drive_recharge()
    if is_drive_recharge then
        if not is_code_printed then
            is_code_printed = true
            is_drive_recharge = false
            ConsolePrint("drive recharge disabled")
        end
    else
        if not is_code_printed then
            is_code_printed = true
            is_drive_recharge = true
            ConsolePrint("drive recharge enabled")
        end
    end
end

function recharge_drive()
    if max_drive > current_drive then
        WriteByte(sora_unit_stat + 0x1B1, current_drive + 1)
    end
end

function update_drive_recharge()
    if current_form == 0 and current_summon == 0 and is_controllable == 0 then
        if pause_status == 0 and menu_status == 0 then
            if not_in_drive_frame%18 == 0 and max_drive > current_drive and is_drive_recharge then
                WriteByte(sora_unit_stat + 0x1B0, gauge_fill + 1)
            end
            if max_drive == current_drive and is_drive_recharge then
                WriteByte(sora_unit_stat + 0x1B0, 99)
            end
            not_in_drive_frame = not_in_drive_frame + 1
        end
    end
end

function toggle_longer_drive()
    if is_longer_drive then
        if not is_code_printed then
            is_code_printed = true
            is_longer_drive = false
            ConsolePrint("longer drive disabled")
        end
    else
        if not is_code_printed then
            is_code_printed = true
            is_longer_drive = true
            ConsolePrint("longer drive enabled")
        end
    end
end

function update_longer_drive()
    if current_form ~= 0 or current_summon ~= 0 then
        in_drive_frame =  in_drive_frame + 1
    else
        in_drive_frame = 0
    end
end

function longer_drive()
    if in_drive_frame == 120 then
        if current_form ~= 0 or current_summon ~= 0 then
            WriteFloat(sora_unit_stat + 0x1B8, max_drive_time * 2)
            WriteFloat(sora_unit_stat + 0x1B4, max_drive_time * 2)
        end
    end
end

function toggle_hp()
    if is_hp then
        if not is_code_printed then
            is_code_printed = true
            is_hp = false
            ConsolePrint("hp recharge disabled")
        end
    else
        if not is_code_printed then
            is_code_printed = true
            is_hp = true
            ConsolePrint("hp recharge enabled")
        end
    end
end

function hp_recharge()
    local sora_current_hp = ReadInt(sora_unit_stat)
    local sora_max_hp = ReadInt(sora_unit_stat + 0x4)

    if pause_status == 0 and menu_status == 0 then
        if sora_max_hp > sora_current_hp then
            WriteInt(sora_unit_stat, sora_current_hp + 1)
        end
    end
end

function toggle_mp()
    if is_mp then
        if not is_code_printed then
            is_code_printed = true
            is_mp = false
            ConsolePrint("mp recharge disabled")
        end
    else
        if not is_code_printed then
            is_code_printed = true
            is_mp = true
            ConsolePrint("mp recharge enabled")
        end
    end
end

function mp_recharge()
    local sora_current_mp = ReadInt(sora_unit_stat + 0x180)
    local sora_max_mp = ReadInt(sora_unit_stat + 0x184)
    local sora_current_mp_charge_time = ReadFloat(sora_unit_stat + 0x1BC)

    if pause_status == 0 and menu_status == 0 then
        if sora_max_mp_charge_time == 0 then
            if sora_max_mp > sora_current_mp then
                WriteInt(sora_unit_stat + 0x180, sora_current_mp + 1)
            end
        end
    end
end

function toggle_mickey()
    if is_mickey then
        if not is_code_printed then
            is_code_printed = true
            is_mickey = false
            remove_mickey()
            ConsolePrint("Mickey anywhere disabled")
        end
    else
        if not is_code_printed then
            is_code_printed = true
            is_mickey = true
            apply_mickey()
            ConsolePrint("Mickey anywhere enabled")
        end
    end
end

function apply_mickey()
    if ReadShort(0x3FA07E - offset) == 0x8DE8 then
        WriteArray(0x3FA07E - offset, {0x90,0x90,0x90,0x90,0x90})
        WriteArray(0x3FA10A - offset, {0x90,0x90})
        WriteArray(0x3C3F15 - offset, {0x90,0x90,0x90,0x90,0x90,0x90,0x90,0x90})
    end
    if ReadShort(0x3F9EEE - offset) == 0xDDE8 then
        WriteArray(0x3F9EEE - offset, {0x90,0x90,0x90,0x90,0x90})
        WriteArray(0x3F9F7A - offset, {0x90,0x90})
        WriteArray(0x3C3D85 - offset, {0x90,0x90,0x90,0x90,0x90,0x90,0x90,0x90})
    end
end

function remove_mickey()
    if ReadShort(0x3FA07E - offset) ~= 0x8DE8 and mickey1_0_0_2[1] ~= nil then
        WriteArray(0x3FA07E - offset, mickey1_0_0_2[1])
        WriteArray(0x3FA10A - offset, mickey1_0_0_2[2])
        WriteArray(0x3C3F15 - offset, mickey1_0_0_2[3])
    end
    if ReadShort(0x3F9EEE - offset) == 0xDDE8 and mickey1_0[1] ~= nil then
        WriteArray(0x3F9EEE - offset, mickey1_0[1])
        WriteArray(0x3F9F7A - offset, mickey1_0[2])
        WriteArray(0x3C3D85 - offset, mickey1_0[3])
    end
end

function toggle_no_rule_drive()
    if is_no_rule_drive then
        if not is_code_printed then
            is_code_printed = true
            is_no_rule_drive = false
            remove_no_rule_drive()
            ConsolePrint("No restriction drive disabled")
        end
    else
        if not is_code_printed then
            is_code_printed = true
            is_no_rule_drive = true
            apply_no_rule_drive()
            ConsolePrint("No restriction drive enabled")
        end
    end
end

function apply_no_rule_drive()
    WriteByte(DriveList, 0x77)
	WriteShort(DriveWithoutParty, 0x820F)
	WriteByte(DriveWithoutForcedParty, 0x72)
	WriteShort(DriveForceEvents, 0x820F)
	WriteByte(PartyWontRemove, 0x7D)
	WriteByte(RoomTransitionDontRemoveParty, 0x7D)
	WriteByte(DriveWhenPartyisDead, 0x03)
end

function remove_no_rule_drive()
    if no_rule_drive[1] ~= nil then
        WriteByte(DriveList, no_rule_drive[1])
	    WriteShort(DriveWithoutParty, no_rule_drive[2])
	    WriteByte(DriveWithoutForcedParty, no_rule_drive[3])
	    WriteShort(DriveForceEvents, no_rule_drive[4])
	    WriteByte(PartyWontRemove, no_rule_drive[5])
	    WriteByte(RoomTransitionDontRemoveParty, no_rule_drive[6])
	    WriteByte(DriveWhenPartyisDead, no_rule_drive[7])
    end
end