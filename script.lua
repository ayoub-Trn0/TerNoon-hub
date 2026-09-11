-- =================================================================
-- 1. الخدمات والمتغيرات العامة (Services & Config)
-- =================================================================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

_G.AutoFarm = false 

-- =================================================================
-- 2. دالة البحث عن الوحش المناسب للمستوى
-- =================================================================
local function GetLevelMatchedMonster()
    local enemiesFolder = Workspace:FindFirstChild("Enemies")
    if not enemiesFolder then return nil end
    
    local playerLevel = 1
    if LocalPlayer:FindFirstChild("Data") and LocalPlayer.Data:FindFirstChild("Level") then
        playerLevel = LocalPlayer.Data.Level.Value
    end
    
    local bestTarget = nil
    local highestMonsterLevel = -1
    
    for _, monster in ipairs(enemiesFolder:GetChildren()) do
        local humanoid = monster:FindFirstChildOfClass("Humanoid")
        local rootPart = monster:FindFirstChild("HumanoidRootPart")
        
        if humanoid and humanoid.Health > 0 and rootPart then
            local monsterLevel = tonumber(string.match(monster.Name, "%d+")) or 1
            if monsterLevel <= playerLevel and monsterLevel > highestMonsterLevel then
                highestMonsterLevel = monsterLevel
                bestTarget = monster
            end
        end
    end
    
    if not bestTarget then
        for _, monster in ipairs(enemiesFolder:GetChildren()) do
            local humanoid = monster:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 and monster:FindFirstChild("HumanoidRootPart") then
                return monster
            end
        end
    end
    
    return bestTarget
end

-- =================================================================
-- 3. محرك التثبيت وإطلاق الضربات المباشرة (Combat Engine)
-- =================================================================
local function StartFarmLoop()
    task.spawn(function()
        while _G.AutoFarm do
            task.wait()
            
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local targetMonster = GetLevelMatchedMonster()
                
                if targetMonster and targetMonster:FindFirstChild("HumanoidRootPart") then
                    -- 1. التثبيت فوق الوحش بـ 6 مكعبات
                    char.HumanoidRootPart.CFrame = targetMonster.HumanoidRootPart.CFrame * CFrame.new(0, 6, 0)
                    
                    -- 2. تجهيز السلاح تلقائياً
                    local backpack = LocalPlayer:FindFirstChild("Backpack")
                    if backpack then
                        local tool = backpack:FindFirstChildOfClass("Tool")
                        if tool and char:FindFirstChildOfClass("Tool") == nil then
                            char.Humanoid:EquipTool(tool)
                        end
                    end
                    
                    -- 3. إرسال أمر الهجوم المباشر للعبة (Blox Fruits Register Hit)
                    pcall(function()
                        local netFolder = ReplicatedStorage:FindFirstChild("Modules") and ReplicatedStorage.Modules:FindFirstChild("Net")
                        if netFolder then
                            netFolder:FindFirstChild("RegisterAttack"):InvokeServer()
                            netFolder:FindFirstChild("RegisterHit"):FireServer(targetMonster.HumanoidRootPart, {targetMonster})
                        else
                            -- كود بديل للأجهزة والسيرفرات القديمة
                            game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1)
                            game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 1)
                        end
                    end)
                end
            end
        end
    end)
end

-- =================================================================
-- 4. الواجهة الأساسية (Kavo UI)
-- =================================================================
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Mobile Auto-Farm", "DarkTheme")

local Tab = Window:NewTab("التلفيل")
local Section = Tab:NewSection("التحكم بالسكربت")

Section:NewToggle("تفعيل التلفيل والضرب", "تشغيل التثبيت والقتل التلقائي", function(state)
    _G.AutoFarm = state
    if state then
        StartFarmLoop()
    end
end)

-- =================================================================
-- 5. زر إخفاء وإظهار الواجهة العائم للجوال (Floating Toggle Button)
-- =================================================================
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Name = "MobileToggleGui"

ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleButton.Position = UDim2.new(0.05, 0, 0.15, 0) -- اعلى يسار الشاشة
ToggleButton.Size = UDim2.new(0, 80, 0, 40)
ToggleButton.Text = "إخفاء/إظهار"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 12
ToggleButton.Active = true
ToggleButton.Draggable = true -- سحب الزر بأصبعك لأي مكان

UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = ToggleButton

ToggleButton.MouseButton1Click:Connect(function()
    Library:ToggleUI()
end)
