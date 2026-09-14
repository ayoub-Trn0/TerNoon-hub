-- [[ TerNoon Hub - Steal An Egg (Safe Mobile Version) ]]
local genv = (getgenv and getgenv()) or _G

if type(genv.SV_SAE_SHUTDOWN) == "function" then
	pcall(genv.SV_SAE_SHUTDOWN)
	task.wait(0.1)
end
if genv.SV_SAE_RUNNING then return end
genv.SV_SAE_RUNNING = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

-- Kavo UI Engine
local Kavo = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Kavo.CreateLib("TerNoon Hub 🥚", "Midnight")

local FarmTab = Window:NewTab("المزرعة")
local BaseTab = Window:NewTab("القاعدة")
local PlayerTab = Window:NewTab("اللاعب")

local FarmSec = FarmTab:NewSection("أتمتة السرقة (Safe)")
local BaseSec = BaseTab:NewSection("البيض")
local PlayerSec = PlayerTab:NewSection("الحركة والحماية")

local State = {
	running = true,
	autofarm = false,
	autoPlace = false,
	autoHatch = false,
	speedOn = false,
	walkSpeed = 24, -- سرعة آمنة لتفادي الطرد
	infJump = false,
	antiAfk = true
}

-- Safe Movement Helper (Avoid Anti-Cheat Kick)
local function safeMoveTo(targetCFrame)
	local char = LocalPlayer.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local dist = (root.Position - targetCFrame.Position).Magnitude
	local speed = math.clamp(State.walkSpeed, 16, 30)
	local time = dist / speed

	local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear)
	local tween = TweenService:Create(root, tweenInfo, {CFrame = targetCFrame})
	tween:Play()
	tween.Completed:Wait()
end

-- Farm Logic Loop
task.spawn(function()
	while State.running do
		task.wait(0.5)
		if State.autofarm then
			pcall(function()
				-- البحث عن البيض القريب في الخريطة
				local eggsFolder = workspace:FindFirstChild("Eggs") or workspace:FindFirstChild("DroppedEggs")
				if eggsFolder then
					for _, egg in ipairs(eggsFolder:GetChildren()) do
						if not State.autofarm then break end
						if egg:IsA("BasePart") or egg:FindFirstChild("TouchInterest") or egg:FindFirstChildOfClass("ProximityPrompt") then
							local prompt = egg:FindFirstChildOfClass("ProximityPrompt")
							if prompt then
								safeMoveTo(egg.CFrame + Vector3.new(0, 3, 0))
								task.wait(0.2)
								fireproximityprompt(prompt)
								task.wait(0.5)
							end
						end
					end
				end
			end)
		end
	end
end)

-- Controls
FarmSec:NewToggle("تفعيل السرقة التلقائية الآمنة", "Safe Autofarm", function(v)
	State.autofarm = v
end)

BaseSec:NewToggle("وضع البيض تلقائياً", "Auto Place", function(v)
	State.autoPlace = v
end)

BaseSec:NewToggle("تفقيس البيض تلقائياً", "Auto Hatch", function(v)
	State.autoHatch = v
end)

PlayerSec:NewToggle("تفعيل سرعة آمنة", "Safe Speed", function(v)
	State.speedOn = v
end)

PlayerSec:NewSlider("السرعة (الحد الأقصى 35)", "Speed", 35, 16, function(v)
	State.walkSpeed = v
end)

PlayerSec:NewToggle("قفز لا نهائي", "Inf Jump", function(v)
	State.infJump = v
end)

-- Speed Management
RunService.Heartbeat:Connect(function()
	if State.speedOn and LocalPlayer.Character then
		local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if hum and hum.MoveDirection.Magnitude > 0 then
			hum.WalkSpeed = math.min(State.walkSpeed, 32)
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

-- Mobile Menu Button
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
