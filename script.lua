-- [[ TerNoon Hub - Steal An Egg (Bypass Anti-Cheat) ]]
local genv = (getgenv and getgenv()) or _G

if type(genv.TN_SHUTDOWN) == "function" then
	pcall(genv.TN_SHUTDOWN)
	task.wait(0.1)
end
if genv.TN_RUNNING then return end
genv.TN_RUNNING = true

-- 1. تعطيل نظام الحماية المباشر (Bypass Anti-Cheat) لمنع الطرد عند الضغط
pcall(function()
	local RawMetatable = getrawmetatable(game)
	if RawMetatable then
		local OldNamecall = RawMetatable.__namecall
		setreadonly(RawMetatable, false)

		RawMetatable.__namecall = newcclosure(function(self, ...)
			local Method = getnamecallmethod()
			-- منع طلبات الكشف والحظر القادمة من السيرفر/العميل
			if Method == "FireServer" or Method == "InvokeServer" then
				local Name = tostring(self)
				if Name:find("Ban") or Name:find("Kick") or Name:find("Check") or Name:find("Detection") or Name:find("Guard") then
					return nil
				end
			end
			return OldNamecall(self, ...)
		end)
		setreadonly(RawMetatable, true)
	end
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

-- 2. استدعاء شبكة اللعبة الأصلية بأمان (Safe Network Call)
local Lib = ReplicatedStorage:WaitForChild("Library", 10)
local Client = Lib and Lib:WaitForChild("Client", 10)
local Network
if Client then
	pcall(function()
		Network = require(Client:WaitForChild("Network", 5))
	end)
end

-- Kavo UI Engine
local Kavo = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Kavo.CreateLib("TerNoon Hub 🥚", "Midnight")

local FarmTab = Window:NewTab("المزرعة")
local BaseTab = Window:NewTab("القاعدة")
local PlayerTab = Window:NewTab("اللاعب")

local FarmSec = FarmTab:NewSection("أتمتة البيض")
local BaseSec = BaseTab:NewSection("إدارة المقر")
local PlayerSec = PlayerTab:NewSection("الحركة")

local State = {
	running = true,
	autoPlace = false,
	autoHatch = false,
	speedOn = false,
	walkSpeed = 24,
	antiAfk = true
}

-- Safe Action Triggers
local function fireNet(remoteName, ...)
	if Network and typeof(Network.Fire) == "function" then
		pcall(function(...) Network.Fire(remoteName, ...) end, ...)
	elseif Network and typeof(Network.Invoke) == "function" then
		pcall(function(...) Network.Invoke(remoteName, ...) end, ...)
	end
end

-- Logic Loop (تنفذ العمليات عبر الشبكة الأصلية دون طرد)
task.spawn(function()
	while State.running do
		task.wait(1)
		
		-- وضع البيض تلقائياً
		if State.autoPlace then
			pcall(function()
				fireNet("Plot: PlaceEgg")
				fireNet("PlotCmds: PlaceEgg")
			end)
		end

		-- تفقيس البيض تلقائياً
		if State.autoHatch then
			pcall(function()
				fireNet("Plot: HatchEgg")
				fireNet("EggCmds: Hatch")
			end)
		end
	end
end)

-- Controls
BaseSec:NewToggle("وضع البيض تلقائياً", "Auto Place Egg", function(v)
	State.autoPlace = v
end)

BaseSec:NewToggle("تفقيس البيض تلقائياً", "Auto Hatch Egg", function(v)
	State.autoHatch = v
end)

PlayerSec:NewToggle("سرعة مشي آمنة", "Safe Speed", function(v)
	State.speedOn = v
	if not v and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
		LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
	end
end)

PlayerSec:NewSlider("تعديل السرعة", "WalkSpeed", 32, 16, function(v)
	State.walkSpeed = v
end)

-- Speed Loop
RunService.Heartbeat:Connect(function()
	if State.speedOn and LocalPlayer.Character then
		local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if hum and hum.MoveDirection.Magnitude > 0 then
			hum.WalkSpeed = State.walkSpeed
		end
	end
end)

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
	if State.antiAfk then
		VirtualUser:CaptureController()
		VirtualUser:ClickButton2(Vector2.new())
	end
end)

-- Floating UI Button for Mobile
local ScreenGui = Instance.new("ScreenGui")
local ToggleBtn = Instance.new("TextButton")
ScreenGui.Parent = game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")
ToggleBtn.Parent = ScreenGui
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 10, 0.4, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Text = "TerNoon"
ToggleBtn.Active = true
ToggleBtn.Draggable = true

ToggleBtn.MouseButton1Click:Connect(function()
	Kavo:ToggleUI()
end)
