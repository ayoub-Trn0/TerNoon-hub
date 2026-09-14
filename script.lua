-- 1. استدعاء مكتبة Orion الخفيفة والمناسبة للجوال ودلتا
local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()

-- 2. إنشاء النافذة الرئيسية
local Window = OrionLib:MakeWindow({
    Name = "Steal an Egg - Egg Collector 🥚",
    HidePremium = true,
    SaveConfig = false,
    ConfigFolder = "OrionTest",
    IntroEnabled = false -- إيقاف مقدمة التشغيل لضمان عدم التعليق على الجوال
})

-- 3. إضافة تبويب رئيسي
local MainTab = Window:MakeTab({
    Name = "الرئيسية",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- 4. إضافة زر التجميع المتوافق مع اللمس
MainTab:AddButton({
    Name = "فحص وتجميع البيض 🥚",
    Callback = function()
        local foundEggs = {}

        -- البحث في المسارات المختلفة للعبة Steal an Egg
        local possiblePaths = {
            workspace:FindFirstChild("Eggs"),
            workspace:FindFirstChild("DroppedEggs"),
            workspace:FindFirstChild("SpawnedEggs"),
            game:GetService("ReplicatedStorage"):FindFirstChild("Eggs")
        }

        for _, folder in ipairs(possiblePaths) do
            if folder then
                for _, item in ipairs(folder:GetChildren()) do
                    table.insert(foundEggs, item.Name)
                end
            end
        end

        -- إظهار إشعار النتيجة على الشاشة مباشرة
        if #foundEggs > 0 then
            OrionLib:MakeNotification({
                Name = "تم الفحص بنجاح! 🎉",
                Content = "تم العثور على " .. #foundEggs .. " بيضة داخل الماب.",
                Image = "rbxassetid://4483345998",
                Time = 4
            })
            
            print("--- قائمة البيض المكتشف ---")
            for i, egg in ipairs(foundEggs) do
                print(i .. ". " .. egg)
            end
        else
            OrionLib:MakeNotification({
                Name = "تنبيه ⚠️",
                Content = "لم يتم العثور على مجلد Eggs، جرب التأكد من مسار الماب.",
                Image = "rbxassetid://4483345998",
                Time = 4
            })
        end
    end
})

-- 5. إنهاء تهيئة المكتبة (ضروري لظهور الواجهة)
OrionLib:Init()
