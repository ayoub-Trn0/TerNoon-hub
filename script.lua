-- 1. استدعاء مكتبة الواجهات Fluent متوافقة مع الجوال ودلتا
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- 2. إنشاء النافذة الرئيسية للواجهة
local Window = Fluent:CreateWindow({
    Title = "Steal an Egg - Egg Collector 🥚",
    SubTitle = "نسخة الجوال",
    TabWidth = 140,
    Size = UDim2.fromOffset(450, 320), -- حجم مناسب جداً لشاشات الجوال
    Acrylic = false, -- إيقاف التغبيش لتحسين الأداء (FPS) على الهواتف
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- 3. إضافة تبويب جديد داخل الواجهة
local Tabs = {
    Main = Window:AddTab({ Title = "الرئيسية", Icon = "egg" })
}

-- 4. إضافة نص توضيحي
Tabs.Main:AddParagraph({
    Title = "فحص البيض تلقائياً",
    Content = "اضغط على الزر بالأسفل لجلب كافة أسماء وأماكن البيض المتاحة في الماب."
})

-- 5. إضافة زر الفحص المتجاوب
Tabs.Main:AddButton({
    Title = "تجميع وفحص كل البيض 🥚",
    Description = "يجلب أسماء البيض من مجلدات الماب تلقائياً",
    Callback = function()
        -- إرسال إشعار للمستخدم بدء العملية
        Fluent:Notify({
            Title = "جاري البحث...",
            Content = " يتم فحص مسارات الماب الآن",
            Duration = 2
        })

        local foundEggs = {}

        -- المسارات الشائعة لوجود البيض في مابات السرقة
        local possiblePaths = {
            workspace:FindFirstChild("Eggs"),
            workspace:FindFirstChild("DroppedEggs"),
            workspace:FindFirstChild("SpawnedEggs"),
            game:GetService("ReplicatedStorage"):FindFirstChild("Eggs")
        }

        -- فحص المجلدات وتجميع العناصر
        for _, folder in ipairs(possiblePaths) do
            if folder then
                for _, item in ipairs(folder:GetChildren()) do
                    table.insert(foundEggs, item.Name)
                end
            end
        end

        -- عرض النتيجة عبر إشعار متناسق في الشاشة
        if #foundEggs > 0 then
            Fluent:Notify({
                Title = "نجحت العملية! 🎉",
                Content = "تم العثور على " .. #foundEggs .. " بيضة داخل الماب.",
                Duration = 4
            })
            
            print("--- قائمة البيض المكتشف ---")
            for i, egg in ipairs(foundEggs) do
                print(i .. ". " .. egg)
            end
        else
            Fluent:Notify({
                Title = "تنبيه ⚠️",
                Content = "لم يتم العثور على مجلد باسم Eggs، استخدم Dark Dex لمعرفة اسم المجلد.",
                Duration = 5
            })
        end
    end
})

-- اختيار التبويب الرئيسي بشكل افتراضي
Window:SelectTab(1)

-- إشعار بنجاح تحميل الواجهة
Fluent:Notify({
    Title = "تم تشغيل الواجهة",
    Content = "الواجهة جاهزة للاستخدام على الجوال!",
    Duration = 3
})
