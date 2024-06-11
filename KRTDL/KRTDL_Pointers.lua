local pointers = {}

local function GetPlayerData(offset)
    return GetPointerNormal(0x9ED108, 0xC8, 0xA0, offset)
end
pointers.GetPlayerData = GetPlayerData

local function GetBossData(offset, bossCount)
    return GetPointerNormal(0x9ED108, 0xD4, (0xE4 + (bossCount * 4)), offset)
end
pointers.GetBossData = GetBossData

return pointers