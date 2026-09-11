-- Roblox Blox Fruits Mobile Script (Auto Farm & Mastery Engine)
_G.AutoFarm = false
_G.AutoSwordMastery = false
_G.AutoFarmGunMastery = false
_G.SelectWeapon = "Melee"
_G.Kill_At = 15 -- Percentage to switch weapon for Mastery
_G.Fastattack = true
_G.SkillZ = true
_G.SkillX = true
_G.SkillC = true
_G.SkillV = true

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Anti-AFK Setup
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- Mobile Safe Noclip
RunService.Stepped:Connect(function()
    if _G.AutoFarm or _G.AutoSwordMastery or _G.AutoFarmGunMastery then
        pcall(function()
            if LocalPlayer.Character then
                for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end
        end)
    end
end)

-- Helper Functions
function TP1(cframe)
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = cframe
        end
    end)
end

function EquipWeapon(weaponType)
    pcall(function()
        for _, v in pairs(LocalPlayer.Backpack:GetChildren()) do
            if v:IsA("Tool") then
                if (weaponType == "Melee" and v.ToolTip == "Melee") or
                   (weaponType == "Sword" and v.ToolTip == "Sword") or
                   (weaponType == "Fruit" and v.ToolTip == "Blox Fruit") or
                   (weaponType == "Gun" and v.ToolTip == "Gun") or
                   (v.Name == weaponType) then
                    LocalPlayer.Character.Humanoid:EquipTool(v)
                end
            end
        end
    end)
end

-- Fast Attack Simulation
RunService.RenderStepped:Connect(function()
    if (_G.AutoFarm or _G.AutoSwordMastery or _G.AutoFarmGunMastery) and _G.Fastattack then
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:Button1Down(Vector2.new(1280, 672))
        end)
    end
end)

-- Dynamic Level & Quest System (Fixed Infinite Teleport Loop)
function CheckQuest()
    local Level = LocalPlayer.Data.Level.Value
    
    -- First Sea Quests Setup
    if Level >= 1 and Level <= 9 then
        Mon = "Bandit" NameMon = "Bandit" NameQuest = "BanditQuest1" LevelQuest = 1
        CFrameQuest = CFrame.new(1059.37, 15.44, 1550.42) CFrameMon = CFrame.new(1145, 17, 1634)
    elseif Level >= 10 and Level <= 14 then
        Mon = "Monkey" NameMon = "Monkey" NameQuest = "JungleQuest" LevelQuest = 1
        CFrameQuest = CFrame.new(-1598.08, 35.55, 153.37) CFrameMon = CFrame.new(-1610, 22, 142)
    elseif Level >= 15 and Level <= 29 then
        Mon = "Gorilla" NameMon = "Gorilla" NameQuest = "JungleQuest" LevelQuest = 2
        CFrameQuest = CFrame.new(-1598.08, 35.55, 153.37) CFrameMon = CFrame.new(-1240, 6, 500)
    elseif Level >= 30 and Level <= 39 then
        Mon = "Pirate" NameMon = "Pirate" NameQuest = "BuggyQuest1" LevelQuest = 1
        CFrameQuest = CFrame.new(-1141.07, 4.10, 3831.54) CFrameMon = CFrame.new(-1200, 4, 3860)
    elseif Level >= 40 and Level <= 59 then
        Mon = "Brute" NameMon = "Brute" NameQuest = "BuggyQuest1" LevelQuest = 2
        CFrameQuest = CFrame.new(-1141.07, 4.10, 3831.54) CFrameMon = CFrame.new(-1150, 8, 4350)
    elseif Level >= 60 and Level <= 89 then
        Mon = "Desert Bandit" NameMon = "Desert Bandit" NameQuest = "DesertQuest" LevelQuest = 1
        CFrameQuest = CFrame.new(894.48, 6.43, 4392.43) CFrameMon = CFrame.new(900, 6, 4450)
    else
        -- Fallback to default island if level exceeds defined range
        Mon = "Bandit" NameMon = "Bandit" NameQuest = "BanditQuest1" LevelQuest = 1
        CFrameQuest = CFrame.new(1059.37, 15.44, 1550.42) CFrameMon = CFrame.new(1145, 17, 1634)
    end
end

-- Core Auto Farm Engine (Safe Teleport Logic)
task.spawn(function()
    while task.wait(0.2) do
        if _G.AutoFarm then
            pcall(function()
                CheckQuest()
                local QuestGui = LocalPlayer.PlayerGui.Main.Quest
                
                if not QuestGui.Visible then
                    TP1(CFrameQuest)
                    -- Wait until character is genuinely near NPC before calling server remote
                    if (LocalPlayer.Character.HumanoidRootPart.Position - CFrameQuest.Position).Magnitude <= 15 then
                        task.wait(0.3)
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", NameQuest, LevelQuest)
                    end
                else
                    local Target = workspace.Enemies:FindFirstChild(Mon)
                    if Target and Target:FindFirstChild("Humanoid") and Target.Humanoid.Health > 0 then
                        repeat task.wait()
                            EquipWeapon(_G.SelectWeapon)
                            Target.HumanoidRootPart.CanCollide = false
                            Target.Humanoid.WalkSpeed = 0
                            Target.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                            TP1(Target.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0))
                        until not _G.AutoFarm or Target.Humanoid.Health <= 0 or not Target.Parent or not QuestGui.Visible
                    else
                        TP1(CFrameMon)
                    end
                end
            end)
        end
    end
end)

-- Mobile UI Interface
local ScreenGui = Instance.new("ScreenGui")
local ToggleUIBtn = Instance.new("TextButton")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local FarmToggle = Instance.new("TextButton")
local SwordMasteryToggle = Instance.new("TextButton")
local UIList = Instance.new("UIListLayout")

ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

ToggleUIBtn.Name = "MobileMenuToggle"
ToggleUIBtn.Parent = ScreenGui
ToggleUIBtn.Position = UDim2.new(0.02, 0, 0.2, 0)
ToggleUIBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleUIBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleUIBtn.Text = "MENU"
ToggleUIBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleUIBtn.Font = Enum.Font.SourceSansBold

MainFrame.Name = "MainHubFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Position = UDim2.new(0.15, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 240, 0, 220)
MainFrame.Active = true
MainFrame.Draggable = true

ToggleUIBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "Blox Fruits Mobile Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold

UIList.Parent = MainFrame
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 8)

FarmToggle.Parent = MainFrame
FarmToggle.Size = UDim2.new(0.9, 0, 0, 45)
FarmToggle.Text = "Auto Farm Level: OFF"
FarmToggle.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
FarmToggle.TextColor3 = Color3.fromRGB(255, 255, 255)

FarmToggle.MouseButton1Click:Connect(function()
    _G.AutoFarm = not _G.AutoFarm
    FarmToggle.Text = _G.AutoFarm and "Auto Farm Level: ON" or "Auto Farm Level: OFF"
    FarmToggle.BackgroundColor3 = _G.AutoFarm and Color3.fromRGB(40, 180, 40) or Color3.fromRGB(180, 40, 40)
end)

SwordMasteryToggle.Parent = MainFrame
SwordMasteryToggle.Size = UDim2.new(0.9, 0, 0, 45)
SwordMasteryToggle.Text = "Sword Mastery: OFF"
SwordMasteryToggle.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
SwordMasteryToggle.TextColor3 = Color3.fromRGB(255, 255, 255)

SwordMasteryToggle.MouseButton1Click:Connect(function()
    _G.AutoSwordMastery = not _G.AutoSwordMastery
    SwordMasteryToggle.Text = _G.AutoSwordMastery and "Sword Mastery: ON" or "Sword Mastery: OFF"
    SwordMasteryToggle.BackgroundColor3 = _G.AutoSwordMastery and Color3.fromRGB(40, 180, 40) or Color3.fromRGB(180, 40, 40)
end)
