local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/cqf5Dev/Public/main/OrionUI.lua"))()

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")

local Player = Players.LocalPlayer

-- =========================
-- WHITELIST
-- =========================
local WHITELIST = {
    "MeisterErwin",
    "felyrun",
    "JUSTsigma2razy"
}

local allowed = false
for _, user in ipairs(WHITELIST) do
    if user:lower() == Player.Name:lower() then
        allowed = true
        break
    end
end

if not allowed then
    Player:Kick("Not whitelisted. Join Discord to get access.")
    return
end

-- =========================
-- ASCII
-- =========================
print([[
 ________   _______   ________  ___  ___  ___       ________     
|\   ___  \|\  ___ \ |\   __  \|\  \|\  \|\  \     |\   __  \    
\ \  \\ \  \ \   __/|\ \  \|\ /\ \  \\\  \ \  \    \ \  \|\  \   
 \ \  \\ \  \ \  \_|/_\ \   __  \ \  \\\  \ \  \    \ \   __  \  
  \ \  \\ \  \ \  \_|\ \ \  \|\  \ \  \\\  \ \  \____\ \  \ \  \ 
   \ \__\\ \__\ \_______\ \_______\ \_______\ \_______\ \__\ \__\
    \|__| \|__|\|_______|\|_______|\|_______|\|_______|\|__|\|__|
]])

-- =========================
-- WINDOW
-- =========================
local Window = OrionLib:MakeWindow({
    Name = "Nebula Hub",
    HidePremium = false,
    SaveConfig = false,
    IntroEnabled = false
})

-- =========================
-- TABS
-- =========================
local SkyTab = Window:MakeTab({
    Name = "Sky",
    Icon = "",
    PremiumOnly = false
})

local CombatTab = Window:MakeTab({
    Name = "Combat",
    Icon = "",
    PremiumOnly = false
})

-- =========================
-- SKYBOXES
-- =========================
local SKYBOXES = {
    {Name="Red", ID="108929045660200|78646480540009|90546017435179|109838453114563|94190734796082|126944775797063"},
    {Name="Galaxy", ID="15983968922|15983966825|15983965025|15983967420|15983966246|15983964246"},
    {Name="Sunset", ID="600830446|600831635|600832720|600886090|600833862|600835177"},
    {Name="Astral", ID="16553658937|16553660713|16553662144|16553664042|16553665766|16553667750"},
    {Name="Green", ID="16563478983|16563481302|16563484084|16563485362|16563487078|16563489821"},
}

-- APPLY SKY
local function applySky(id)
    for _,v in pairs(Lighting:GetChildren()) do
        if v:IsA("Sky") then v:Destroy() end
    end

    if id == "nil" then return end

    local sky = Instance.new("Sky", Lighting)
    local ids = string.split(id,"|")

    if #ids == 6 then
        sky.SkyboxBk = "rbxassetid://"..ids[1]
        sky.SkyboxDn = "rbxassetid://"..ids[2]
        sky.SkyboxFt = "rbxassetid://"..ids[3]
        sky.SkyboxLf = "rbxassetid://"..ids[4]
        sky.SkyboxRt = "rbxassetid://"..ids[5]
        sky.SkyboxUp = "rbxassetid://"..ids[6]
    end
end

local function resetSky()
    applySky("nil")
end

-- SKY TAB
for _,sky in pairs(SKYBOXES) do
    SkyTab:AddButton({
        Name = sky.Name,
        Callback = function()
            applySky(sky.ID)
        end
    })
end

SkyTab:AddButton({
    Name = "Reset Sky",
    Callback = function()
        resetSky()
    end
})

-- =========================
-- COMBAT TAB
-- =========================
local function apply(tool)
    if tool and tool:IsA("Tool") then
        tool:SetAttribute("AimDelay", 0)
        tool:SetAttribute("Scope", false)
    end
end

local function onToolAdded(tool)
    task.wait()
    apply(tool)
end

local function onCharacter(char)
    for _, tool in pairs(char:GetChildren()) do
        apply(tool)
    end
    char.ChildAdded:Connect(onToolAdded)
end

CombatTab:AddToggle({
    Name = "No Aim Delay",
    Default = false,
    Callback = function(state)
        if state then
            OrionLib:MakeNotification({
                Name = "Nebula",
                Content = "No Aim Enabled",
                Time = 3
            })

            Player.CharacterAdded:Connect(onCharacter)

            if Player.Character then
                onCharacter(Player.Character)
            end
        end
    end
})

-- =========================
-- INIT
-- =========================
OrionLib:Init()
