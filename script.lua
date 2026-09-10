-- TerNoon Hub - Infinite Speed Script

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "TerNoon Hub 🚀",
   LoadingTitle = "TerNoon Hub Loading...",
   LoadingSubtitle = "by TerNoon",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

local MainTab = Window:CreateTab("الميزات الرئيسية ⚡", 4483362458)

local defaultSpeed = 16
local targetSpeed = 100
local speedEnabled = false
local LocalPlayer = game:GetService("Players").LocalPlayer

-- التعديل المستمر لمنع الماب من إعادة إعادة ضبط السرعة
task.spawn(function()
    while task.wait(0.1) do
        if speedEnabled then
            pcall(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid.WalkSpeed = targetSpeed
                end
            end)
        end
    end
end)

-- زر التفعيل والإيقاف
MainTab:CreateToggle({
   Name = "سرعة لا نهائية (Infinite Speed)",
   CurrentValue = false,
   Flag = "SpeedToggle",
   Callback = function(Value)
       speedEnabled = Value
       if not Value then
           pcall(function()
               if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                   LocalPlayer.Character.Humanoid.WalkSpeed = defaultSpeed
               end
           end)
       end
   end,
})

-- شريط التحكم بمقدار السرعة
MainTab:CreateSlider({
   Name = "مستوى السرعة (Speed Value)",
   Range = {16, 500},
   Increment = 5,
   Suffix = "Speed",
   CurrentValue = 100,
   Flag = "SpeedSlider",
   Callback = function(Value)
       targetSpeed = Value
       if speedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
           LocalPlayer.Character.Humanoid.WalkSpeed = targetSpeed
       end
   end,
})

Rayfield:Notify({
   Title = "TerNoon Hub",
   Content = "تم تحميل السكريبت بنجاح! 🚀",
   Duration = 4,
   Image = 4483362458,
})