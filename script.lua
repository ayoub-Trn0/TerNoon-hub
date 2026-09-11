repeat
    task.wait()
until game:IsLoaded() and game.Players.LocalPlayer

-- تحميل مكتبة الواجهة المتوافقة مع الجوال
local PiHub = loadstring(game:HttpGet("https://you.whimper.xyz/sources/pihub/lib/bf.lua", true))()
local Window = PiHub:Window("BloxFruit")

-- إنشاء القوائم الرئيسية (Tabs)
local Set = Window:Tab("Settings Farm", "rbxassetid://18899804355")
local Main = Window:Tab("Auto Farm", "rbxassetid://18899804355")
local Farm = Window:Tab("Item Quest", "rbxassetid://18899804355")
local Event = Window:Tab("Sea Event", "rbxassetid://18899804355")
local Stats = Window:Tab("Auto Stats", "rbxassetid://18899804355")
local Tele = Window:Tab("World Tele", "rbxassetid://18899804355")
local Player = Window:Tab("Player Pvp", "rbxassetid://18899804355")
local Race = Window:Tab("Race V4", "rbxassetid://18899804355")
local Raid = Window:Tab("Dungeon Raid", "rbxassetid://18899804355")
local DemonFruit = Window:Tab("Fruit Demon", "rbxassetid://18899804355")
local Esp = Window:Tab("Esp Player", "rbxassetid://18899804355")
local Shop = Window:Tab("Shopee", "rbxassetid://18899804355")
local Misc = Window:Tab("Miscellaneous", "rbxassetid://18899804355")

-----------------------------------------------------------------------------------------------------------------------------
-- حماية من الطرد ومجموعات الفحص (تجاوز الحماية للأجهزة الذكية)
pcall(function()
    if getrawmetatable and setreadonly and newcclosure then
        local grm = getrawmetatable(game)
        setreadonly(grm, false)
        local old = grm.__namecall
        grm.__namecall = newcclosure(function(self, ...)
            local args = {...}
            local method = getnamecallmethod()
            if method == "FireServer" or method == "InvokeServer" then
                if tostring(args[1]) == "TeleportDetect" or tostring(args[1]) == "CHECKER_1" or 
                   tostring(args[1]) == "CHECKER" or tostring(args[1]) == "GUI_CHECK" or 
                   tostring(args[1]) == "OneMoreTime" or tostring(args[1]) == "checkingSPEED" or 
                   tostring(args[1]) == "BANREMOTE" or tostring(args[1]) == "PERMAIDBAN" or 
                   tostring(args[1]) == "KICKREMOTE" or tostring(args[1]) == "BR_KICKPC" or 
                   tostring(args[1]) == "BR_KICKMOBILE" then
                    return nil
                end
            end
            return old(self, ...)
        end)
    end
end)

-- معالجة الأخطاء وحقن الـ Fast Attack
local _tbl
_tbl = function(t)
    return setmetatable(t or {}, {
        __index = function() return _tbl() end,
        __call = function() return _tbl() end
    })
end

local _require = require
local require = function(...)
    local success, result = pcall(_require, ...)
    return success and result or _tbl()
end

pcall(function()
    getgenv().A = require(game:GetService("ReplicatedStorage").CombatFramework.RigLib).wrapAttackAnimationAsync
    getgenv().B = require(game.Players.LocalPlayer.PlayerScripts.CombatFramework.Particle).play
end)

_G.setfflag = true
task.spawn(function()
    while task.wait(1) do
        if _G.setfflag and setfflag then
            pcall(function()
                setfflag("AbuseReportScreenshot", "False")
                setfflag("AbuseReportScreenshotPercentage", "0")
            end)
        end
    end
end)

-- نظام Safe Farm لحماية الحساب وحذف السكربتات المزعجة
_G.SafeFarm = true
task.spawn(function()
    while task.wait(2) do
        if _G.SafeFarm then
            pcall(function()
                for _, v in pairs(game:GetService("Players").LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("LocalScript") and (v.Name == "General" or v.Name == "Shiftlock" or v.Name == "FallDamage" or v.Name == "4444" or v.Name == "CamBob" or v.Name == "JumpCD" or v.Name == "Looking" or v.Name == "Run") then
                        v:Destroy()
                    end
                end
                for _, v in pairs(game:GetService("Players").LocalPlayer.PlayerScripts:GetDescendants()) do
                    if v:IsA("LocalScript") and (v.Name == "RobloxMotor6DBugFix" or v.Name == "Clans" or v.Name == "Codes" or v.Name == "CustomForceField" or v.Name == "MenuBloodSp" or v.Name == "PlayerList") then
                        v:Destroy()
                    end
                end
            end)
        end
    end
end)

-- تحديد العالم المتواجد فيه اللاعب
local World1, World2, World3 = false, false, false
if game.PlaceId == 2753915549 then World1 = true
elseif game.PlaceId == 4442272183 then World2 = true
elseif game.PlaceId == 7449423635 then World3 = true end

-- دالة فحص وتقسيم المهام (CheckQuest)
function CheckQuest() 
    local MyLevel = game:GetService("Players").LocalPlayer.Data.Level.Value
    if World1 then
        if MyLevel >= 1 and MyLevel <= 9 then
            Mon = "Bandit"; LevelQuest = 1; NameQuest = "BanditQuest1"; NameMon = "Bandit"
            CFrameQuest = CFrame.new(1059.37195, 15.4495068, 1550.4231)
            CFrameMon = CFrame.new(1045.962646484375, 27.00250816345215, 1560.8203125)
        elseif MyLevel >= 10 and MyLevel <= 14 then
            Mon = "Monkey"; LevelQuest = 1; NameQuest = "JungleQuest"; NameMon = "Monkey"
            CFrameQuest = CFrame.new(-1598.08911, 35.5501175, 153.377838)
            CFrameMon = CFrame.new(-1448.51806640625, 67.85301208496094, 11.46579647064209)
        elseif MyLevel >= 15 and MyLevel <= 29 then
            Mon = "Gorilla"; LevelQuest = 2; NameQuest = "JungleQuest"; NameMon = "Gorilla"
            CFrameQuest = CFrame.new(-1598.08911, 35.5501175, 153.377838)
            CFrameMon = CFrame.new(-1129.8836669921875, 40.46354675292969, -525.4237060546875)
        elseif MyLevel >= 30 and MyLevel <= 39 then
            Mon = "Pirate"; LevelQuest = 1; NameQuest = "BuggyQuest1"; NameMon = "Pirate"
            CFrameQuest = CFrame.new(-1141.07483, 4.10001802, 3831.5498)
            CFrameMon = CFrame.new(-1103.513427734375, 13.752052307128906, 3896.091064453125)
        elseif MyLevel >= 40 and MyLevel <= 59 then
            Mon = "Brute"; LevelQuest = 2; NameQuest = "BuggyQuest1"; NameMon = "Brute"
            CFrameQuest = CFrame.new(-1141.07483, 4.10001802, 3831.5498)
            CFrameMon = CFrame.new(-1140.083740234375, 14.809885025024414, 4322.92138671875)
        else
            Mon = "Bandit"; LevelQuest = 1; NameQuest = "BanditQuest1"; NameMon = "Bandit"
            CFrameQuest = CFrame.new(1059.37195, 15.4495068, 1550.4231)
            CFrameMon = CFrame.new(1045.962646484375, 27.00250816345215, 1560.8203125)
        end
    elseif World2 then
        if MyLevel >= 700 and MyLevel <= 724 then
            Mon = "Raider"; LevelQuest = 1; NameQuest = "Area1Quest"; NameMon = "Raider"
            CFrameQuest = CFrame.new(-429.543518, 71.7699966, 1836.18188)
            CFrameMon = CFrame.new(-728.3267211914062, 52.779319763183594, 2345.7705078125)
        else
            Mon = "Raider"; LevelQuest = 1; NameQuest = "Area1Quest"; NameMon = "Raider"
            CFrameQuest = CFrame.new(-429.543518, 71.7699966, 1836.18188)
            CFrameMon = CFrame.new(-728.3267211914062, 52.779319763183594, 2345.7705078125)
        end
    elseif World3 then
        if MyLevel >= 1500 and MyLevel <= 1524 then
            Mon = "Pirate Millionaire"; LevelQuest = 1; NameQuest = "PiratePortQuest"; NameMon = "Pirate Millionaire"
            CFrameQuest = CFrame.new(-290.074677, 42.9034653, 5581.58984)
            CFrameMon = CFrame.new(-245.9963836669922, 47.30615234375, 5584.1005859375)
        else
            Mon = "Pirate Millionaire"; LevelQuest = 1; NameQuest = "PiratePortQuest"; NameMon = "Pirate Millionaire"
            CFrameQuest = CFrame.new(-290.074677, 42.9034653, 5581.58984)
            CFrameMon = CFrame.new(-245.9963836669922, 47.30615234375, 5584.1005859375)
        end
    end
end

-- زر تفعيل Farm تلقائي داخل القائمة الرئيسية
Main:Toggle("Auto Farm Level", false, function(Value)
    _G.AutoFarm = Value
end)

-- الحلقة التكرارية لعملية Auto Farm بدون التهنيج في الجوال
task.spawn(function()
    while task.wait(0.1) do
        if _G.AutoFarm then
            pcall(function()
                CheckQuest()
                local player = game.Players.LocalPlayer
                if not player.PlayerGui.Main:FindFirstChild("Quest") then
                    player.Character.HumanoidRootPart.CFrame = CFrameQuest
                    task.wait(0.5)
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", NameQuest, LevelQuest)
                else
                    for _, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v.Name == NameMon and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
                            repeat
                                task.wait()
                                player.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 7, 0)
                                game:GetService("VirtualUser"):CaptureController()
                                game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0))
                            until not _G.AutoFarm or not v.Parent or v.Humanoid.Health <= 0
                        end
                    end
                end
            end)
        end
    end
end)
