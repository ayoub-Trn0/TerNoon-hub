-- =================================================================
-- 1. الخدمات والمتغيرات العامة (Services & Variables)
-- =================================================================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

_G.AutoFarm = false 

-- =================================================================
-- 2. دالة المسح الذكي لجميع الوحوش المناسبة للمستوى
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
            -- استخراج مستوى الوحش من اسمه إن وجد (مثل: Bandit [Lv. 5])
            local monsterLevel = tonumber(string.match(monster.Name, "%d+")) or 1
            
            -- اختيار الوحش الأكثر مناسبة لمستواك الحالي دون أن يتجاوزه بكثير
            if monsterLevel <= playerLevel and monsterLevel > highestMonsterLevel then
                highestMonsterLevel = monsterLevel
                bestTarget = monster
            end
        end
    end
    
    -- إذا لم يجد وحشاً مطابقاً، يختار أي وحش حي متاح في المنطقة
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
-- 3. المحرك الأساسي للتلفيل والتثبيت والضرب التلقائي
-- =================================================================
local function StartFarmLoop()
    task.spawn(function()
        while _G.AutoFarm do
            task.wait()
            
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local targetMonster = GetLevelMatchedMonster()
                
                if targetMonster and targetMonster:FindFirstChild("HumanoidRootPart") then
                    -- 1. التثبيت فوق رأس الوحش بـ 6 مكعبات
                    char.HumanoidRootPart.CFrame = targetMonster.HumanoidRootPart.CFrame * CFrame.new(0, 6, 0)
                    
                    -- 2. تجهيز السلاح الأول في الحقيبة تلقائياً
                    local backpack = LocalPlayer:FindFirstChild("Backpack")
                    if backpack then
                        local tool = backpack:FindFirstChildOfClass("Tool")
                        if tool and char:FindFirstChildOfClass("Tool") == nil then
                            char.Humanoid:EquipTool(tool)
                        end
                    end
                    
                    -- 3. محاكاة النقر والضرب الحقيقي على الشاشة للجوال
                    VirtualUser:CaptureController()
                    VirtualUser:Button1Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
                end
            end
        end
    end)
end

-- =================================================================
-- 4. واجهة المستخدم الكبيرة + زر إخفاء/إظهار متطاير للجوال
-- =================================================================
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Mobile Auto-Farm", "DarkTheme")

local Tab = Window:NewTab("التلفيل")
local Section = Tab:NewSection("التحكم بالسكربت")

Section:NewToggle("تفعيل التلفيل الذكي", "يقوم بالبحث عن وحش مناسب وضربه", function(state)
    _G.AutoFarm = state
    if state then
        StartFarmLoop()
    end
end)

-- إنشاء زر إخفاء وإظهار الواجهة المخصص للجوال (Floating Toggle Button)
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")

ScreenGui.Parent = game:GetService("CoreGui") or LocalPlayer.PlayerGui
ScreenGui.Name = "MobileToggleGui"

ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleButton.Position = UDim2.new(0.05, 0, 0.2, 0) -- موقع الزر على الشاشة
ToggleButton.Size = UDim2.new(0, 70, 0, 35)
ToggleButton.Text = "MENU"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 14
ToggleButton.Active = true
ToggleButton.Draggable = true -- يمكنك سحب الزر لأي مكان في الشاشة أصبعك

local uiVisible = true
ToggleButton.MouseButton1Click:Connect(function()
    uiVisible = not uiVisible
    Library:ToggleUI() -- إخفاء وإظهار الواجهة الرئيسية
end)
