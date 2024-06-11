package.path = GetScriptsDir() .. "/KRTDL/KRTDL_Pointers.lua"
local pointers = require("KRTDL_Pointers")

package.path = GetScriptsDir() .. "/KRTDL/KRTDL_Core.lua"
local core = require("KRTDL_Core")
----- GLOBAL VARIABLES -----
local lastIndex = 0
local startRNG = 0
local startFrame = 174
local current = core.getRNG()
----- Add an underscore (_) at the beginning of the script name to execute on game startup! -----
function onScriptStart()
    if (GetGameID() ~= "SUKE01") then
        error("Incompatible.")
        CancelScript()
    end

    MsgBox("Script Started.")
    startRNG = core.inverseRNG(current)
end

function onScriptCancel()
    MsgBox("Script Ended.")
    SetScreenText("")
end

function convertFramesToTimeString(start, current)
    local difference = current - start
    local timeString = difference / 60
    return string.format("%.2f (%df)", timeString, difference)
end

function onScriptUpdate()
    local frame = GetFrameCount()
    -- local index = core.inverseRNG(core.getRNG()) - startRNG
    -- local advance = index - lastIndex

    local text = ""
    local bossDataText = ""
    local lockoutTableText = ""

    text = text .. string.format("\nFrame: %d\n", frame)
    text = text .. "===== Position =====\n"
    text = text .. string.format("X: %10.7f | Y: %10.7f\n", core.getPosition().X, core.getPosition().Y)
    text = text .. "===== Speed =====\n"
    text = text .. string.format("X: %10.7f | Y: %10.7f\n", core.getSpeed().X, core.getSpeed().Y)
    -- text = text .. "===== RNG =====\n"
    -- text = text .. string.format("RNG: %X\n", core.getRNG())
    -- text = text .. string.format("Index: %d\n", index)
    -- text = text .. string.format("Advance: %d\n", advance)
    text = text .. "===== P1 =====\n"
    text = text .. string.format("HP: %d\n", core.getHP())
    text = text .. string.format("I-Frames: %d\n", core.intangibleFrames())
    text = text .. string.format("Ability: %s\n", core.getAbility().abilityStr)
    text = text .. string.format("Shake Timer: %d\n", core.shakeTimer())
    text = text .. string.format("Guarding Flag: %d\n", core.isGuarding())

    for index = 1, core.getBossCount() do
        bossDataText = bossDataText .. string.format("HP: %d | Invinc State: %d | Lockout: %d\n", 
        core.bossData(index).HP, 
        core.bossData(index).invincState, 
        core.bossData(index).lockoutFrames)
    end

    for secondIndex = 1, core.getObjectCount() do
        if (core.getObjectInactionableTables(secondIndex) ~= 0) then
            lockoutTableText = lockoutTableText .. string.format("Inactionable Timer: %d\n", 
            core.getObjectInactionableTables(secondIndex))
        end
    end

    if (core.getBossCount() >= 1) then
        text = text .. "===== Boss (Assist) =====\n"
        text = text .. string.format("%s", bossDataText)
    end

    if (core.getObjectCount() >= 1) then
        text = text .. string.format("%s", lockoutTableText)
    end

    text = text .. "===== Misc. =====\n"
    text = text .. string.format("Entities: %d\n", core.detectEntities())
    text = text .. string.format("Boss Count: %d\n", core.getBossCount())
    -- text = text .. string.format("Dashing State: %d\n", ReadValue8(0x8132EF1C))
    -- text = text .. string.format("Crouching State: %d\n", ReadValue8(0x8132EF1E))
    -- text = text .. string.format("Challenge Mode Timer: %d\n", core.getChallengeModeTimer())
    -- text = text .. string.format("Inputs: %s\n", core.getInputs().str)
    -- text = text .. string.format("Time: %s\n", convertFramesToTimeString(startFrame, GetFrameCount()))
    SetScreenText(text)

    lastIndex = index
end