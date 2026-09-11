-- =================================================================
-- 1. الخدمات والمتغيرات العامة (Services & Config)
-- =================================================================
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
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
-- 3. دالة تجهيز اليد (Melee) من الحقيبة
-- =================================================================
local function EquipMeleeTool(char)
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if not backpack or not char then return end

    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") and (tool.ToolTip == "Melee" or tool:FindFirstChild("Combat") or tool.Name == "Combat") then
            char.Humanoid:EquipTool(tool)
            break
        end
    end
    
    if char:FindFirstChildOfClass("Tool") == nil then
        local firstTool = backpack:FindFirstChildOfClass("Tool")
        if firstTool then
            char.Humanoid:EquipTool(firstTool)
        end
    end
end

-- =================================================================
-- 4. محرك التثبيت والنقر المباشر على الشاشة
-- =================================================================
local function StartFarmLoop()
    task.spawn(function()
        while _G.AutoFarm do
            task.wait(0.1) -- سرعة الضرب والتثبيت
            
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
                local targetMonster = GetLevelMatchedMonster()
                
                if targetMonster and targetMonster:FindFirstChild("HumanoidRootPart") then
                    -- 1. التثبيت فوق رأس الوحش بـ 4 مكعبات فقط للوصول السريع
                    char.HumanoidRootPart.CFrame = targetMonster.HumanoidRootPart.CFrame * CFrame.new(0, 4, 0)
                    
                    -- 2. التأكد من إمساك اليد
                    EquipMeleeTool(char)
                    
                    -- 3. محاكاة نقر الأصبع المباشر على منتصف الشاشة للجوال
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton1(Vector2.new(500, 500))
                end
            end
        end
    end)
end

-- =================================================================
-- 5. الواجهة والزر العائم للجوال
-- =================================================================
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Mobile Auto-Farm (Clicker)", "DarkTheme")

local Tab = Window:NewTab("التلفيل")
local Section = Tab:NewSection("الضرب بالنقر المباشر")

Section:NewToggle("تفعيل التلفيل والنقر", "ينقل فوق الوحش وينقر الشاشة تلقائياً", function(state)
    _G.AutoFarm = state
    if state then
        StartFarmLoop()
    end
end)

-- زر إخفاء/إظهار الواجهة المخصص للجوال
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Name = "MobileToggleGui"

ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleButton.Position = UDim2.new(0.05, 0, 0.15, 0)
ToggleButton.Size = UDim2.new(0, 80, 0, 40)
ToggleButton.Text = "إخفاء/إظهار"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 12
ToggleButton.Active = true
ToggleButton.Draggable = true

UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = ToggleButton

ToggleButton.MouseButton1Click:Connect(function()
    Library:ToggleUI()
end)
