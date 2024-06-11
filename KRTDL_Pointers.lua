local pointers = {}

local function GetObjectCount()
    return ReadValue32(0x9ED108, 0x9C, 0x0)
end
pointers.GetObjectCount = GetObjectCount

local function GetPlayerData(offset)
    return GetPointerNormal(0x9ED108, 0xC8, 0xA0, offset)
end
pointers.GetPlayerData = GetPlayerData

-- local function getObjectData(pointer, offset)
--     return GetPointerNormal(pointer, 0xD0, 0x)

local function GetBossData(offset, bossCount)
    return GetPointerNormal(0x9ED108, 0xD4, (0xE4 + (bossCount * 4)), offset)
end
pointers.GetBossData = GetBossData

return pointers