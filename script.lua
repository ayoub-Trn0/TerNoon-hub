-- =================================================================
-- 1. الخدمات والمتغيرات العامة (Services & Config)
-- =================================================================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

_G.AutoFarm = false -- متغير التشغيل والإيقاف

-- =================================================================
-- 2. دالة التجميع التلقائي لجميع الوحوش (Dynamic Monster Scanner)
-- =================================================================
local function GetNearestAliveMonster()
    local enemiesFolder = Workspace:FindFirstChild("Enemies")
    if not enemiesFolder then return nil end
    
    -- البحث في الماب عن أي وحش يملك طاقة أكبر من 0
    for _, monster in ipairs(enemiesFolder:GetChildren()) do
        local humanoid = monster:FindFirstChildOfClass("Humanoid")
        local rootPart = monster:FindFirstChild("HumanoidRootPart")
        
        if humanoid and humanoid.Health > 0 and rootPart then
            return monster -- إرجاع أول وحش حي يتم العثور عليه تلقائياً
        end
    end
    return nil
end

-- =================================================================
-- 3. المحرك الأساسي للقتل والتلفيل التلقائي (Main Loop)
-- =================================================================
local function StartFarmLoop()
    task.spawn(function()
        while _G.AutoFarm do
            task.wait()
            
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                
                -- جلب أي وحش متوفر في الماب عبر الدالة التلقائية
                local targetMonster = GetNearestAliveMonster()
                
                if targetMonster then
                    -- 1. نقل إحداثيات اللاعب فوق رأس الوحش تلقائياً
                    char.HumanoidRootPart.CFrame = targetMonster.HumanoidRootPart.CFrame * CFrame.new(0, 7, 0)
                    
                    -- 2. إرسال أمر الهجوم للسيرفر
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("Attack")
                end
            end
        end
    end)
end

-- =================================================================
-- 4. بناء الواجهة والأزرار (UI Setup)
-- =================================================================
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/UI-Library/Example"))()
local Window = Library:CreateWindow("Universal Auto-Farm")
local Tab = Window:CreateTab("التجميع التلقائي")

-- زر تشغيل وإيقاف السكربت
Tab:CreateToggle({
    Name = "تفعيل قتل جميع الوحوش تلقائياً",
    Callback = function(State)
        _G.AutoFarm = State
        if State then
            StartFarmLoop()
        end
    end
})
