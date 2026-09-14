local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- 1. إنشاء واجهة الشاشة للـ Delta
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StealAnEggUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- 2. تصميم الزر المخصص للجوال
local CollectButton = Instance.new("TextButton")
CollectButton.Parent = ScreenGui
CollectButton.Size = UDim2.new(0.4, 0, 0.08, 0) -- حجم متناسق مع الجوال
CollectButton.Position = UDim2.new(0.05, 0, 0.4, 0)
CollectButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
CollectButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CollectButton.Text = "فحص بيض الماب 🥚"
CollectButton.TextScaled = true
CollectButton.Font = Enum.Font.SourceSansBold

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.2, 0)
UICorner.Parent = CollectButton

-- 3. منطق البحث والتجميع للعبة Steal an Egg
CollectButton.MouseButton1Click:Connect(function()
    CollectButton.Text = "جاري الفحص..."
    CollectButton.BackgroundColor3 = Color3.fromRGB(200, 150, 0)

    local foundEggs = {}

    -- البحث في المجلدات الشائعة لمابات السرقة
    local possiblePaths = {
        workspace:FindFirstChild("Eggs"),
        workspace:FindFirstChild("DroppedEggs"),
        workspace:FindFirstChild("SpawnedEggs"),
        ReplicatedStorage:FindFirstChild("Eggs")
    }

    for _, folder in ipairs(possiblePaths) do
        if folder then
            for _, item in ipairs(folder:GetChildren()) do
                table.insert(foundEggs, item.Name)
            end
        end
    end

    -- تحديث الواجهة بالنتيجة
    if #foundEggs > 0 then
        CollectButton.Text = "تم العثور على: " .. #foundEggs .. " بيضة!"
        CollectButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
        
        print("--- قائمة البيضات المكتشفة في Steal an Egg ---")
        for i, egg in ipairs(foundEggs) do
            print(i .. ". " .. egg)
        end
    else
        CollectButton.Text = "استخدم Dex لتحديد المجلد"
        CollectButton.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
    end

    task.wait(2.5)
    CollectButton.Text = "فحص بيض الماب 🥚"
    CollectButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
end)
