-- =================================================================
-- 1. الخدمات والمتغيرات العامة (Services & Config)
-- =================================================================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

_G.AutoFarm = false -- متغير التشغيل والإيقاف

-- =================================================================
-- 2. دالة المسح الديناميكي للوحوش (Mobile Optimized)
-- =================================================================
local function GetNearestAliveMonster()
    local enemiesFolder = Workspace:FindFirstChild("Enemies")
    if not enemiesFolder then return nil end
    
    for _, monster in ipairs(enemiesFolder:GetChildren()) do
        local humanoid = monster:FindFirstChildOfClass("Humanoid")
        local rootPart = monster:FindFirstChild("HumanoidRootPart")
        
        if humanoid and humanoid.Health > 0 and rootPart then
            return monster
        end
    end
    return nil
end

-- =================================================================
-- 3. المحرك الأساسي للتلفيل (Main Farm Loop)
-- =================================================================
local function StartFarmLoop()
    task.spawn(function()
        while _G.AutoFarm do
            task.wait()
            
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local targetMonster = GetNearestAliveMonster()
                
                if targetMonster and targetMonster:FindFirstChild("HumanoidRootPart") then
                    -- التثبيت فوق الوحش
                    char.HumanoidRootPart.CFrame = targetMonster.HumanoidRootPart.CFrame * CFrame.new(0, 7, 0)
                    -- إرسال أمر الضرب
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("Attack")
                end
            end
        end
    end)
end

-- =================================================================
-- 4. واجهة Kavo UI (تظهر على الجوال والكمبيوتر بدون مشاكل)
-- =================================================================
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Mobile Auto-Farm", "DarkTheme")

-- إنشاء تبويب وزر داخل الواجهة
local Tab = Window:NewTab("التلفيل")
local Section = Tab:NewSection("التحكم بالسكربت")

Section:NewToggle("تفعيل قتل جميع الوحوش", "تشغيل/إيقاف التجميع", function(state)
    _G.AutoFarm = state
    if state then
        StartFarmLoop()
    end
end)
