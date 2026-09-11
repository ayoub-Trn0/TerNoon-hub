-- =================================================================
-- 1. الخدمات والمتغيرات العامة (Services & Config)
-- =================================================================
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
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
-- 3. دالة تجهيز اليد وتفعيل الضرب المباشر (Tool Activate)
-- =================================================================
local function EquipAndAttack(char)
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if not backpack or not char then return end

    -- 1. البحث عن اليد وتجهيزها إذا لم تكن ممسوكة
    local currentTool = char:FindFirstChildOfClass("Tool")
    if not currentTool then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and (tool.ToolTip == "Melee" or tool:FindFirstChild("Combat") or tool.Name == "Combat") then
                char.Humanoid:EquipTool(tool)
                currentTool = tool
                break
            end
        end
    end

    -- إذا لم يجد كلمة Melee يمسك أول Tool متوفر
    if not currentTool then
        local firstTool = backpack:FindFirstChildOfClass("Tool")
        if firstTool then
            char.Humanoid:EquipTool(firstTool)
            currentTool = firstTool
        end
    end

    -- 2. إطلاق أمر الضرب برمجياً مباشرة عبر الـ Tool نفسه
    if currentTool then
        currentTool:Activate() -- تفعيل هجوم السلاح/اليد مباشرة
    end
end

-- =================================================================
-- 4. المحرك الأساسي للتثبيت والتكرار السريع
-- =================================================================
local function StartFarmLoop()
    task.spawn(function()
        while _G.AutoFarm do
            task.wait(0.1)
            
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
                local targetMonster = GetLevelMatchedMonster()
                
                if targetMonster and targetMonster:FindFirstChild("HumanoidRootPart") then
                    -- التثبيت فوق رأس الوحش بـ 4 مكعبات
                    char.HumanoidRootPart.CFrame = targetMonster.HumanoidRootPart.CFrame * CFrame.new(0, 4, 0)
                    
                    -- تجهيز اليد وإطلاق الضرب الفوري
                    EquipAndAttack(char)
                end
            end
        end
    end)
end

-- =================================================================
-- 5. الواجهة والزر العائم للجوال
-- =================================================================
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Mobile Auto-Farm (Tool Activate)", "DarkTheme")

local Tab = Window:NewTab("التلفيل")
local Section = Tab:NewSection("التحكم بالسكربت")

Section:NewToggle("تفعيل الضرب المباشر", "تفعيل السلاح وتكرار الهجوم", function(state)
    _G.AutoFarm = state
    if state then
        StartFarmLoop()
    end
end)

-- زر إخفاء وإظهار الواجهة العائم للجوال
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Name = "MobileToggleGui"

ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleButton.Position = UDim2.new(0.05, 0, 0.15, 0)
ToggleButton.Size = UDim2.new(0, 80, 0, 40)
ToggleButton.Text = "إخفاء"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 12
ToggleButton.Active = true
ToggleButton.Draggable = true

UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = ToggleButton

ToggleButton.MouseButton1Click:Connect(function()
    Library:ToggleUI()
end)
