local core = {}

package.path = GetScriptsDir() .. "/KRTDL/KRTDL_Pointers.lua"
local pointers = require("KRTDL_Pointers")

local function getPosition()
    return {X = ReadValueFloat(pointers.GetPlayerData(0xA0), 0x0), Y = ReadValueFloat(pointers.GetPlayerData(0xA0), 0x4)}
end
core.getPosition = getPosition

local function getSpeed()
    return {X = ReadValueFloat(pointers.GetPlayerData(0xA8), 0x4), Y = ReadValueFloat(pointers.GetPlayerData(0xA8), 0x8)}
end
core.getSpeed = getSpeed

local function getHP()
    return ReadValue32(pointers.GetPlayerData(0x138), 0x0)
end
core.getHP = getHP

local function intangibleFrames()
    return ReadValue32(pointers.GetPlayerData(0x128), 0x4)
end
core.intangibleFrames = intangibleFrames

local function getMouthItems()
    return ReadValue32(pointers.GetPlayerData(0x118), 0x18)
end
core.getMouthItems = getMouthItems

local function isGuarding()
    return ReadValue8(pointers.GetPlayerData(0x178), 0x4)
end
core.isGuarding = isGuarding

local function shakeTimer()
    return ReadValue32(pointers.GetPlayerData(0x208), 0x4)
end
core.shakeTimer = shakeTimer

local function getRNG()
    return ReadValue32(0x8B7418)
end
core.getRNG = getRNG

local function inverseRNG(seed) -- Created by Trivial171
    local powers = {1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768, 65536, 131072, 262144, 524288, 1048576, 2097152, 4194304, 8388608, 16777216, 33554432, 67108864, 134217728, 268435456, 536870912, 1073741824, 2147483648}
    local multi = 0x19660D
    local addi = 0x3C6EF35F
    local modulo = 0x100000000

    local function powmod(m, n, q)
        if (n == 0) then return 1 else
            local factor1 = powmod(m, math.floor(n / 2), q)
            local factor2 = 1

            if (n % 2 == 1) then
                factor2 = m
            end

            return (factor1 * factor1 * factor2) % q
        end
    end

    local function modinv(w)
        return powmod(w, math.floor(modulo / 2) - 1, modulo)
    end

    local function v2(a)
        if (a == 0) then return 1000000 end

        local n = a
        local v = 0

        while (n % 2 == 0) do
            n = math.floor(n / 2)
            v = v + 1
        end

        return v
    end

    local function rngInverse(r)
        local xpow = (r * 4 * math.floor((multi - 1) / 4) * modinv(addi) + 1) % (4 * modulo)
        local xguess = 0

        for index, value in ipairs(powers) do
            if v2(powmod(multi, xguess + value, 4 * modulo) - xpow) > v2(powmod(multi, xguess, 4 * modulo) - xpow) then
                xguess = xguess + value
            end
        end

        return xguess
    end

    return rngInverse(seed)
end
core.inverseRNG = inverseRNG

local function frameOfInput()
    return ReadValue32(0x8C160C)
end
core.frameOfInput = frameOfInput

local function getChallengeModeTimer()
    return ReadValue16(0x9ED0F0, 0x82)
end
core.getChallengeModeTimer = getChallengeModeTimer

local function getArenaStopwatch()
    return ReadValue32(0xC7BC94)
end
core.getArenaStopwatch = getArenaStopwatch

local function getAbility()
    local address = ReadValue32(pointers.GetPlayerData(0x120), 0x18)
    local ability = {
        [0] = "Normal",
        [1] = "Sword",
        [2] = "Cutter",
        [3] = "Leaf",
        [4] = "Whip",
        [5] = "Fire",
        [6] = "Needle",
        [7] = "Beam",
        [8] = "Spark",
        [9] = "Stone",
        [10] = "Sleep",
        [11] = "Parasol",
        [12] = "Water",
        [13] = "High Jump",
        [14] = "Tornado",
        [15] = "Bomb",
        [16] = "Spear",
        [17] = "Hammer",
        [18] = "Ice",
        [19] = "Wing",
        [20] = "Ninja",
        [21] = "Fighter",
        [22] = "Crash",
        [23] = "Mike",
        [24] = "Landia",
        [25] = "Ultra Sword",
        [26] = "Monster Flame",
        [27] = "Flare Beam",
        [28] = "Grand Hammer",
        [29] = "Snow Bowl",
        [30] = "Mike: 2nd Attack",
        [31] = "Mike: Final Attack",
        [32] = "Meta Knight",
        [33] = "King Dedede",
        [34] = "Bandana Waddle Dee"
    }

    local function readAbility(t)
        for _, v in ipairs(t) do
            local s = type(ability[v]) == "function" and ability[v]() or ability[v]
            return string.format("%s", s)
        end
    end

    return {abilityStr = readAbility{address}, value = address}
end
core.getAbility = getAbility

local function detectEntities()
    return ReadValue32(0x9ED108, 0xD0, 0x90)
end
core.detectEntities = detectEntities

local function getBossCount()
    return ReadValue32(0x9ED108, 0xD4, 0xE4)
end
core.getBossCount = getBossCount

local function bossData(bossCount)
    return {
        HP = ReadValue32(pointers.GetBossData(0x220, bossCount), 0x0),
        invincState = ReadValue8(pointers.GetBossData(0x208, bossCount), 0xC),
        lockoutFrames = ReadValue32(pointers.GetBossData(0x210, bossCount), 0x4),
    }
end
core.bossData = bossData

local function getObjectCount()
    return ReadValue32(0x9ED108, 0x9C, 0x0)
end
core.getObjectCount = getObjectCount

local function getObjectInactionableTables(objectCount)
    local objectLockout = ReadValue32(0x9ED108, 0x9C, (0x0 + (objectCount * 4)), 0x68)
    
    if (objectLockout > 1000) then
        return 0
    end

    return objectLockout
end
core.getObjectInactionableTables = getObjectInactionableTables

local function getInputs()
    local buttons = ReadValue16(0x807F40)

    local inputs = {
        LEFT = 0x0001,
        RIGHT = 0x0002,
        DOWN = 0x0004,
        UP = 0x0008,
        START = 0x0010,
        TWO = 0x0100,
        ONE = 0x0200,
        B_BUTTON = 0x0400,
        A_BUTTON = 0x0800,
        SELECT = 0x1000,
        HOME = 0x8000
    }

    local str = " "

    local function add(text)
        if (str:len() ~= 1) then
            str = str .. " "
        end
        str = str .. text
    end

    local function buttonPressed(value)
        return buttons & value == value
    end

    if buttonPressed(inputs.LEFT) then add("LEFT") end
    if buttonPressed(inputs.RIGHT) then add("RIGHT") end
    if buttonPressed(inputs.DOWN) then add("DOWN") end
    if buttonPressed(inputs.UP) then add("UP") end
    if buttonPressed(inputs.START) then add("+") end
    if buttonPressed(inputs.TWO) then add("2") end
    if buttonPressed(inputs.ONE) then add("1") end
    if buttonPressed(inputs.B_BUTTON) then add("B") end
    if buttonPressed(inputs.A_BUTTON) then add("A") end
    if buttonPressed(inputs.SELECT) then add("-") end
    if buttonPressed(inputs.HOME) then add("HOME") end
    return {addr = buttons, str = str, button_list = inputs}
end
core.getInputs = getInputs

return core