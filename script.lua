-- [[ ScriptVerse - Steal An Egg (Mobile Native UI) ]]
local genv = (getgenv and getgenv()) or _G

if type(genv.SV_SAE_SHUTDOWN) == "function" then
	pcall(genv.SV_SAE_SHUTDOWN)
	task.wait(0.1)
end
if genv.SV_SAE_RUNNING then return end
genv.SV_SAE_RUNNING = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

-- تحميل مكتبة واجهة مخصصة ومضمنة للجوال (Mobile Friendly Library)
local Kavo = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Kavo.CreateLib("Steal An Egg 🥚 (Delta Mobile)", "Midnight")

-- Tabs
local FarmTab = Window:NewTab("المزرعة")
local BaseTab = Window:NewTab("القاعدة")
local PetsTab = Window:NewTab("الحيوانات")
local PlayerTab = Window:NewTab("اللاعب")

-- Sections
local FarmSec = FarmTab:NewSection("أتمتة السرقة")
local BaseSec = BaseTab:NewSection("البيض والتطوير")
local PetsSec = PetsTab:NewSection("إدارة الحيوانات")
local PlayerSec = PlayerTab:NewSection("الحركة والحماية")

local State = {
	running = true,
	autofarm = false,
	preferHighValue = true,
	autoPlace = false,
	autoHatch = false,
	autoUpgrade = false,
	autoEquipBest = false,
	autoFuse = false,
	autoSellPets = false,
	speedOn = false,
	walkSpeed = 32,
	infJump = false,
	antiAfk = true
}

-- Farm Controls
FarmSec:NewToggle("تفعيل السرقة التلقائية (Autofarm)", "يقوم بالسرقة والعودة تلقائياً", function(v)
	State.autofarm = v
end)

FarmSec:NewToggle("إعطاء الأولوية للبيض النادر", "يختار البيض الأغلى", function(v)
	State.preferHighValue = v
end)

-- Base Controls
BaseSec:NewToggle("وضع البيض تلقائياً", "يضع البيض من الحقيبة", function(v)
	State.autoPlace = v
end)

BaseSec:NewToggle("تفقيس البيض تلقائياً", "يفقس البيض الجاهز", function(v)
	State.autoHatch = v
end)

BaseSec:NewToggle("ترقية المقر تلقائياً", "يشتري ترقيات الـ Base", function(v)
	State.autoUpgrade = v
end)

-- Pets Controls
PetsSec:NewToggle("لبس أفضل الحيوانات", "Equip Best Pets", function(v)
	State.autoEquipBest = v
end)

PetsSec:NewToggle("دمج الحيوانات تلقائياً", "Fuse Pets", function(v)
	State.autoFuse = v
end)

PetsSec:NewToggle("بيع الحيوانات الزائدة", "Auto Sell Pets", function(v)
	State.autoSellPets = v
end)

-- Player Controls
PlayerSec:NewToggle("تفعيل سرعة المشي", "Speed Hack", function(v)
	State.speedOn = v
	if not v and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
		LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
	end
end)

PlayerSec:NewSlider("مستوى السرعة", "WalkSpeed", 100, 16, function(v)
	State.walkSpeed = v
end)

PlayerSec:NewToggle("قفز لا نهائي", "Infinite Jump", function(v)
	State.infJump = v
end)

-- Mobile Movement & Anti-AFK Logic
local speedBV
RunService.Heartbeat:Connect(function()
	if not State.running then return end
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local root = char and char:FindFirstChild("HumanoidRootPart")
	
	if State.speedOn and root and hum then
		if hum.MoveDirection.Magnitude > 0.05 then
			root.CFrame = root.CFrame + (hum.MoveDirection * (State.walkSpeed / 50))
		end
	end
end)

UserInputService.JumpRequest:Connect(function()
	if State.infJump and LocalPlayer.Character then
		local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
	end
end)

LocalPlayer.Idled:Connect(function()
	if State.antiAfk then
		VirtualUser:CaptureController()
		VirtualUser:ClickButton2(Vector2.new())
	end
end)

-- زر عائم لإخفاء/إظهار الواجهة على شاشة الجوال (Toggle UI Button)
local ScreenGui = Instance.new("ScreenGui")
local ToggleBtn = Instance.new("TextButton")
ScreenGui.Parent = game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")
ToggleBtn.Parent = ScreenGui
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 10, 0.4, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Text = "MENU"
ToggleBtn.Active = true
ToggleBtn.Draggable = true

ToggleBtn.MouseButton1Click:Connect(function()
	Kavo:ToggleUI()
end)
