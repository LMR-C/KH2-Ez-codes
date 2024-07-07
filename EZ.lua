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

mickey = {}

no_rule_drive = {}

function _OnInit()
end

function adress_init()
    if (GAME_ID == 0xF266B00B or GAME_ID == 0xFAF99301) and ENGINE_TYPE == "ENGINE" then --PCSX2
        ConsolePrint("Ez code are not compatible with PS2 version")
    elseif GAME_ID == 0x431219CC and ENGINE_TYPE == 'BACKEND' then --PC
	    if ReadString(0x09A92F0,4) == 'KH2J' then --EGS
            ConsolePrint("PC version (EGS) detected")
            Sys3Pointer = 0x2AE5890
            Btl0Pointer = 0x2AE5898
            Sys3 = ReadLong(Sys3Pointer)
            Btl0 = ReadLong(Btl0Pointer)
            Save = 0x09A92F0
            Now = 0x0716DF8
            input = Now - 0x3970
            battle_state_address = 0x2A10E44
            pause_status_address = 0x0ABB2B8
            is_controllable_address = 0x2A16C28
            menu_status_address = Now - 0x5B4
            sora_level_stat = Btl0 + 0x25928
            cure_cost = Sys3 + 0x0A70
            cura_cost = Sys3 + 0x1700
            curaga_cost = Sys3 + 0x1730
            sora_unit_stat = 0x2A22FD8
            mickey_adress1 = 0x3FB7AE
            mickey_adress2 = 0x3FB83A
            mickey_adress3 = 0x3C5645
            DriveList = 0x3F1CCE
            DriveWithoutParty = 0x400E6
            DriveWithoutForcedParty = 0x3E27AC
            DriveForceEvents = 0x400EB8
            PartyWontRemove = 0x3FFAF4
            RoomTransitionDontRemoveParty = 0x3C1EFE
            DriveWhenPartyisDead = 0x3F1CEA
            current_form_adress = Save + 0x3524
            current_summon_adress = Save + 0x3525
            L3_triangle = 0x1002
            L3_square = 0x8002
            L3_circle = 0x2002
            L3_cross = 0x4002
            L3_L1 = 0x402
            L3_L2 = 0x102
            L3_R1 = 0x802
	    elseif ReadString(0x09A9830,4) == 'KH2J' then --Steam Global
            ConsolePrint("PC version (Steam global) detected")
	    Sys3Pointer = 0x2AE5DD0
	    Btl0Pointer = 0x2AE5DD8
            Sys3 = ReadLong(Sys3Pointer)
            Btl0 = ReadLong(Btl0Pointer)
            Save = 0x09A9830
	    Now = 0x0717008
            input = Now - 0x3970
            battle_state_address = 0x2A11384
            pause_status_address = 0x0ABB7F8
            is_controllable_address = 0x2A17168
            menu_status_address = Now - 0x5B4
            sora_level_stat = Btl0 + 0x25928
            cure_cost = Sys3 + 0x0A70
            cura_cost = Sys3 + 0x1700
            curaga_cost = Sys3 + 0x1730
            sora_unit_stat = 0x2A23518
            mickey_adress1 = 0x3FC4CE
            mickey_adress2 = 0x3FC55A
            mickey_adress3 = 0x3C6365
            DriveList = 0x3F29EE
            DriveWithoutParty = 0x401B84
            DriveWithoutForcedParty = 0x3E34CC
            DriveForceEvents = 0x401BD8
            PartyWontRemove = 0x400814
            RoomTransitionDontRemoveParty = 0x3C2C1E
            DriveWhenPartyisDead = 0x3F2A0A
            current_form_adress = Save + 0x3524
            current_summon_adress = Save + 0x3525
            L3_triangle = 0x1002
            L3_square = 0x8002
            L3_circle = 0x2002
            L3_cross = 0x4002
            L3_L1 = 0x402
            L3_L2 = 0x102
            L3_R1 = 0x802
	    elseif ReadString(0x09A8830,4) == 'KH2J' then --Steam JP
	    Sys3Pointer = 0x2AE4DD0
	    Btl0Pointer = 0x2AE4DD8
            Sys3 = ReadLong(Sys3Pointer)
            Btl0 = ReadLong(Btl0Pointer)
            Save = 0x09A8830
            Now = 0x0716008
            input = Now - 0x3970
            battle_state_address = 0x2A10384
            pause_status_address = 0x0ABA7F8
            is_controllable_address = 0x2A16168
            menu_status_address = Now - 0x5B4
            sora_level_stat = Btl0 + 0x25928
            cure_cost = Sys3 + 0x0A70
            cura_cost = Sys3 + 0x1700
            curaga_cost = Sys3 + 0x1730
            sora_unit_stat = 0x2A22518
            mickey_adress1 = 0x3FC24E
            mickey_adress2 = 0x3FC2DA
            mickey_adress3 = 0x3C60E5
            DriveList = 0x3F276E
            DriveWithoutParty = 0x401904
            DriveWithoutForcedParty = 0x3E324C
            DriveForceEvents = 0x401958
            PartyWontRemove = 0x400594
            RoomTransitionDontRemoveParty = 0x3C299E
            DriveWhenPartyisDead = 0x3F278A
            current_form_adress = Save + 0x3524
            current_summon_adress = Save + 0x3525
            L3_triangle = 0x1002
            L3_square = 0x8002
            L3_circle = 0x2002
            L3_cross = 0x4002
            L3_L1 = 0x402
            L3_L2 = 0x102
            L3_R1 = 0x802
        end
    end
end

function _OnFrame()
    if has_to_init and frame == 110 then
        adress_init()
        if ReadInt(sora_level_stat, true) > 40 then
            ConsolePrint("Rando detected")
            rando_offset = 0x580
        else
            ConsolePrint("Vanilla game detected")
            rando_offset = 0
        end

        mickey[1] = ReadArray(mickey_adress1, 5)
        mickey[2] = ReadArray(mickey_adress2, 2)
        mickey[3] = ReadArray(mickey_adress3, 8)

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

    frame = frame + 1

    if has_to_init == false then
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
    WriteByte(cure_cost, 25, true)
    WriteByte(cura_cost, 25, true)
    WriteByte(curaga_cost, 25, true)
end

function remove_cure()
    WriteByte(cure, 255, true)
    WriteByte(cura_cost, 255, true)
    WriteByte(curaga_cost, 255, true)
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
    WriteArray(mickey_adress1, {0x90,0x90,0x90,0x90,0x90})
	WriteArray(mickey_adress2, {0x90,0x90})
	WriteArray(mickey_adress3, {0x90,0x90,0x90,0x90,0x90,0x90,0x90,0x90})
end

function remove_mickey()
    WriteArray(mickey_adress1, mickey[1])
    WriteArray(mickey_adress2, mickey[2])
    WriteArray(mickey_adress3, mickey[3])
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
