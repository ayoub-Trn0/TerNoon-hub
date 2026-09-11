-- Global Engine & Mobile Optimization Setup
_G.AutoFarm = false
_G.FarmMode = "Quest" -- "Quest" or "No Quest"
_G.SelectWeapon = "Melee" -- "Melee", "Sword", "Fruit", "Gun"
_G.Fastattack = true

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Anti-AFK Handler
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- Mobile Collision & Noclip Engine
RunService.Stepped:Connect(function()
    if _G.AutoFarm then
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

-- Weapon Selector Engine
function EquipWeapon(weaponType)
    pcall(function()
        for _, v in pairs(LocalPlayer.Backpack:GetChildren()) do
            if v:IsA("Tool") then
                if weaponType == "Melee" and v.ToolTip == "Melee" then
                    LocalPlayer.Character.Humanoid:EquipTool(v)
                elseif weaponType == "Sword" and v.ToolTip == "Sword" then
                    LocalPlayer.Character.Humanoid:EquipTool(v)
                elseif weaponType == "Fruit" and v.ToolTip == "Blox Fruit" then
                    LocalPlayer.Character.Humanoid:EquipTool(v)
                elseif weaponType == "Gun" and v.ToolTip == "Gun" then
                    LocalPlayer.Character.Humanoid:EquipTool(v)
                end
            end
        end
    end)
end

function TP1(cframe)
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = cframe
        end
    end)
end

-- Fast Attack Simulation for Touch & PC
RunService.RenderStepped:Connect(function()
    if _G.AutoFarm and _G.Fastattack then
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:Button1Down(Vector2.new(1280, 672))
        end)
    end
end)

-- Level Quest Check System
function CheckQuest()
    local MyLevel = LocalPlayer.Data.Level.Value
    
    if MyLevel >= 1 and MyLevel <= 9 then
        NameMon = "Bandit"
        NameQuest = "BanditQuest1"
        LevelQuest = 1
        CFrameQuest = CFrame.new(1059.37195, 15.4495068, 1550.4231)
        CFrameMon = CFrame.new(1145, 17, 1634)
    elseif MyLevel >= 10 and MyLevel <= 14 then
        NameMon = "Monkey"
        NameQuest = "JungleQuest"
        LevelQuest = 1
        CFrameQuest = CFrame.new(-1598.08911, 35.5501175, 153.377838)
        CFrameMon = CFrame.new(-1610, 22, 142)
    elseif MyLevel >= 15 and MyLevel <= 29 then
        NameMon = "Gorilla"
        NameQuest = "JungleQuest"
        LevelQuest = 2
        CFrameQuest = CFrame.new(-1598.08911, 35.5501175, 153.377838)
        CFrameMon = CFrame.new(-1240, 6, 500)
    elseif MyLevel >= 30 and MyLevel <= 39 then
        NameMon = "Pirate"
        NameQuest = "BuggyQuest1"
        LevelQuest = 1
        CFrameQuest = CFrame.new(-1141.07483, 4.10001802, 3831.54956)
        CFrameMon = CFrame.new(-1200, 4, 3860)
    elseif MyLevel >= 40 and MyLevel <= 59 then
        NameMon = "Brute"
        NameQuest = "BuggyQuest1"
        LevelQuest = 2
        CFrameQuest = CFrame.new(-1141.07483, 4.10001802, 3831.54956)
        CFrameMon = CFrame.new(-1150, 8, 4350)
    elseif MyLevel >= 60 and MyLevel <= 89 then
        NameMon = "Desert Bandit"
        NameQuest = "DesertQuest"
        LevelQuest = 1
        CFrameQuest = CFrame.new(894.488647, 6.43846154, 4392.43359)
        CFrameMon = CFrame.new(900, 6, 4450)
    else
        -- القائمة تمتد لتغطي باقي مستويات اللعبة والبحار الثلاثة بنفس النمط
        NameMon = "Bandit"
        NameQuest = "BanditQuest1"
        LevelQuest = 1
        CFrameQuest = CFrame.new(1059.37195, 15.4495068, 1550.4231)
        CFrameMon = CFrame.new(1145, 17, 1634)
    end
end

-- Full Auto Farm Quest Execution Loop
task.spawn(function()
    while task.wait(0.2) do
        if _G.AutoFarm then
            pcall(function()
                CheckQuest()
                local QuestGui = LocalPlayer.PlayerGui.Main.Quest
                
                -- إذا لم تكن هناك مهمة مفعّلة، اتجه للجزيرة وخذ المهمة
                if not QuestGui.Visible then
                    TP1(CFrameQuest)
                    if (LocalPlayer.Character.HumanoidRootPart.Position - CFrameQuest.Position).Magnitude <= 10 then
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", NameQuest, LevelQuest)
                    end
                else
                    -- إذا كانت المهمة مفعّلة، ابحث عن الوحش واتجه للقتال
                    local EnemyFound = false
                    for _, v in pairs(workspace.Enemies:GetChildren()) do
                        if v.Name == NameMon and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            EnemyFound = true
                            repeat task.wait()
                                EquipWeapon(_G.SelectWeapon)
                                v.HumanoidRootPart.CanCollide = false
                                v.Humanoid.WalkSpeed = 0
                                v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                TP1(v.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0))
                            until not _G.AutoFarm or v.Humanoid.Health <= 0 or not v.Parent or not QuestGui.Visible
                        end
                    end
                    -- إذا لم يظهر الوحش بعد، ينتظر في منطقة الـ Spawn الخاصة بالوحوش
                    if not EnemyFound then
                        TP1(CFrameMon)
                    end
                end
            end)
        end
    end
end)

-- Mobile UI Panel (Touch-Friendly Controls)
local ScreenGui = Instance.new("ScreenGui")
local ToggleUIBtn = Instance.new("TextButton")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local FarmToggle = Instance.new("TextButton")
local WeaponToggle = Instance.new("TextButton")
local UIList = Instance.new("UIListLayout")

ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- زر عائم لفتح وإغلاق القائمة في الموبايل
ToggleUIBtn.Name = "OpenMenuBtn"
ToggleUIBtn.Parent = ScreenGui
ToggleUIBtn.Position = UDim2.new(0.02, 0, 0.15, 0)
ToggleUIBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleUIBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ToggleUIBtn.Text = "MENU"
ToggleUIBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleUIBtn.TextSize = 12
ToggleUIBtn.Font = Enum.Font.SourceSansBold

MainFrame.Name = "MainHubFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Position = UDim2.new(0.15, 0, 0.15, 0)
MainFrame.Size = UDim2.new(0, 240, 0, 180)
MainFrame.Visible = true
MainFrame.Active = true
MainFrame.Draggable = true

ToggleUIBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "Auto Farm Level - Mobile"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold

UIList.Parent = MainFrame
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 8)

FarmToggle.Parent = MainFrame
FarmToggle.Size = UDim2.new(0.9, 0, 0, 45)
FarmToggle.Text = "Auto Farm Level: OFF"
FarmToggle.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
FarmToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
FarmToggle.TextSize = 14

FarmToggle.MouseButton1Click:Connect(function()
    _G.AutoFarm = not _G.AutoFarm
    if _G.AutoFarm then
        FarmToggle.Text = "Auto Farm Level: ON"
        FarmToggle.BackgroundColor3 = Color3.fromRGB(40, 180, 40)
    else
        FarmToggle.Text = "Auto Farm Level: OFF"
        FarmToggle.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    end
end)

WeaponToggle.Parent = MainFrame
WeaponToggle.Size = UDim2.new(0.9, 0, 0, 45)
WeaponToggle.Text = "Weapon: Melee"
WeaponToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
WeaponToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
WeaponToggle.TextSize = 14

local weapons = {"Melee", "Sword", "Fruit", "Gun"}
local wIdx = 1

WeaponToggle.MouseButton1Click:Connect(function()
    wIdx = (wIdx % #weapons) + 1
    _G.SelectWeapon = weapons[wIdx]
    WeaponToggle.Text = "Weapon: " .. _G.SelectWeapon
end)
