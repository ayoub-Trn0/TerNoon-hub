-- [[ ScriptVerse - Steal An Egg (Mobile Optimized) ]]
local PLACE_ID = 107778070777162
local genv = (getgenv and getgenv()) or _G

if type(genv.SV_SAE_SHUTDOWN) == "function" then
	pcall(genv.SV_SAE_SHUTDOWN)
	task.wait(0.1)
end
if genv.SV_SAE_RUNNING then
	return
end
genv.SV_SAE_RUNNING = true

-- Bypass Client AC
local function bypassClientDetections()
	if typeof(filtergc) ~= "function" or typeof(debug) ~= "table" or typeof(debug.getupvalues) ~= "function" then
		return false
	end
	local ok, fn = pcall(function()
		return filtergc("function", { Constants = { "gmatch", "GetFullName" } }, true)
	end)
	if not ok or type(fn) ~= "function" then return false end
	local setMeta = (typeof(setrawmetatable) == "function" and setrawmetatable) or setmetatable
	if not setMeta then return false end
	local okUv, ups = pcall(debug.getupvalues, fn)
	if not okUv or type(ups) ~= "table" then return false end
	for _, tbl in pairs(ups) do
		if typeof(tbl) == "table" then
			pcall(setMeta, tbl, { __newindex = function() end })
		end
	end
	return true
end
bypassClientDetections()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

local function pinUiToPlayerGui()
	return LocalPlayer:WaitForChild("PlayerGui")
end

local SVUI = genv.SVUI or _G.SVUI
if not SVUI then
	pinUiToPlayerGui()
	local ok, lib = pcall(function()
		return loadstring(game:HttpGet("https://scriptversekey.xyz/svui.lua"))()
	end)
	if ok then SVUI = lib end
end
if not SVUI then
	genv.SV_SAE_RUNNING = nil
	return
end

local Accent = Color3.fromRGB(120, 220, 160)
local OkGreen = Color3.fromRGB(120, 220, 140)
local WarnOrange = Color3.fromRGB(255, 140, 80)

local function softRequire(inst)
	if typeof(inst) ~= "Instance" then return nil end
	local ok, mod = pcall(require, inst)
	return ok and mod or nil
end

local Lib = ReplicatedStorage:WaitForChild("Library", 30)
local Client = Lib:WaitForChild("Client", 15)
local Util = Lib:WaitForChild("Util", 15)
local Globals = Lib:WaitForChild("Globals", 15)

local EggCmds = softRequire(Client:WaitForChild("EggCmds", 15))
local PlotCmds = softRequire(Client:WaitForChild("PlotCmds", 15))
local Network = softRequire(Client:WaitForChild("Network", 15))
local Guard = softRequire(Client:WaitForChild("ToolGameplayGuard", 15))
local Lookup = softRequire(Util:WaitForChild("GuardAreaLookupUtil", 15))
local Save = softRequire(Client:WaitForChild("Save", 15))
local BaseUpgrade = softRequire(Client:WaitForChild("BaseUpgradeClient", 15))
local AssetCmds = softRequire(Client:WaitForChild("AssetCmds", 15))
local Constants = softRequire(Globals:WaitForChild("Constants", 15))

if not EggCmds or not PlotCmds or not Guard or not Lookup then
	genv.SV_SAE_RUNNING = nil
	return
end

local NetMap = (Constants and Constants.NETWORK_MAP) or (Network and Network.NET_MAP)
local PivotKey = (NetMap and NetMap.ClientCharacter and NetMap.ClientCharacter.SET_PIVOT) or "ClientCharacter: SetPivot"

local conns = {}
local espPool = {}

local State = {
	running = true,
	busy = false,
	status = "Idle",
	carrying = false,

	autofarm = false,
	preferHighValue = true,
	
	autoSellEggs = false,
	autoPlace = false,
	autoHatch = false,
	autoEquipBest = false,
	autoFuse = false,
	autoSellPets = false,
	neverSellMutated = true,
	neverSellEquipped = true,

	claimOffline = false,
	autoUpgrade = false,
	autoTreadmill = false,
	autoClaimIndex = false,
	autoGroupReward = false,

	espWorldEgg = false,
	espPlayer = false,
	espPlot = false,

	speedOn = false,
	walkSpeed = 32,
	jumpOn = false,
	jumpPower = 80,
	infJump = false,
	antiAfk = true,

	lastPlace = 0,
	lastHatch = 0,
	lastSell = 0,
	lastEquip = 0,
	lastUpgrade = 0,
	lastOffline = 0,
	lastIndex = 0,
	lastGroup = 0,
	lastTreadmill = 0,
	lastFuse = 0,
}

local function notify(title, content, color, dur)
	pcall(function()
		SVUI:Notify({ Title = title, Content = content, Duration = dur or 2.2, Color = color or Accent })
	end)
end

local function track(conn)
	table.insert(conns, conn)
	return conn
end

local function root()
	local char = LocalPlayer.Character
	return char and char:FindFirstChild("HumanoidRootPart")
end

local function hum()
	local char = LocalPlayer.Character
	return char and char:FindFirstChildOfClass("Humanoid")
end

local function zeroVel(part)
	if not part then return end
	part.AssemblyLinearVelocity = Vector3.zero
	part.AssemblyAngularVelocity = Vector3.zero
end

local function burstPivot(cf, fires)
	local r = root()
	if not r or not cf then return end
	fires = fires or 2
	for _ = 1, fires do
		if Network and PivotKey then
			pcall(function() Network.Fire(PivotKey, cf) end)
		end
		r.CFrame = cf
		zeroVel(r)
		task.wait(0.014)
	end
end

local function smoothPath(goal, steps)
	local r = root()
	if not r or not goal then return false end
	steps = steps or 12
	local from = r.Position
	for i = 1, steps do
		if not State.running then return false end
		r = root()
		if not r then return false end
		local p = from:Lerp(goal, i / steps)
		burstPivot(CFrame.new(p.X, math.max(p.Y, r.Position.Y), p.Z), 1)
	end
	return true
end

local function walkRunTo(goal, speed, timeout)
	local h = hum()
	if not h or not goal then return false end
	speed = math.min(speed or 16, 16)
	timeout = timeout or 30
	local saved = h.WalkSpeed
	h.WalkSpeed = speed
	h:MoveTo(goal)
	local t0 = os.clock()
	while os.clock() - t0 < timeout and State.running do
		local r = root()
		if not r then break end
		if (goal - r.Position).Magnitude <= 4.5 then
			h.WalkSpeed = saved
			h:Move(Vector3.zero, false)
			return true
		end
		local flat = Vector3.new(goal.X - r.Position.X, 0, goal.Z - r.Position.Z)
		if flat.Magnitude > 0.3 then h:Move(flat.Unit, false) end
		task.wait(0.15)
	end
	h.WalkSpeed = saved
	h:Move(Vector3.zero, false)
	local r = root()
	return r and (r.Position - goal).Magnitude <= 10
end

local speedBV
local function applySpeed()
	local r = root()
	local h = hum()
	if speedBV and (not State.speedOn or not r or speedBV.Parent ~= r) then
		pcall(function() speedBV:Destroy() end)
		speedBV = nil
	end
	if State.speedOn and r then
		if not speedBV or speedBV.Parent ~= r then
			speedBV = Instance.new("BodyVelocity")
			speedBV.Name = "SV_Speed_Mobile"
			speedBV.MaxForce = Vector3.new(8e4, 0, 8e4)
			speedBV.Parent = r
		end
		local dir = Vector3.zero
		if h and h.MoveDirection.Magnitude > 0.05 then
			dir = Vector3.new(h.MoveDirection.X, 0, h.MoveDirection.Z).Unit
		end
		speedBV.Velocity = dir * State.walkSpeed
	end
end

-- Mobile Friendly UI Adjustment
local Window = SVUI:CreateWindow({
	Title = "ScriptVerse - SAE (Mobile)",
	Size = UDim2.fromOffset(340, 260), -- حجم متناسب مع شاشات الجوال
	Accent = Accent,
})

local FarmTab = Window:CreateTab("المزرعة")
local BaseTab = Window:CreateTab("القاعدة")
local PetsTab = Window:CreateTab("الحيوانات")
local VisualsTab = Window:CreateTab("الرؤية")
local PlayerTab = Window:CreateTab("اللاعب")

-- Farm Tab
FarmTab:CreateSection("السرقة التلقائية")
FarmTab:CreateToggle("تفعيل المزرعة (Autofarm)", false, function(v) State.autofarm = v end)
FarmTab:CreateToggle("تفضيل البيض النادر", true, function(v) State.preferHighValue = v end)

-- Base Tab
BaseTab:CreateSection("إدارة البيض والقاعدة")
BaseTab:CreateToggle("وضع البيض تلقائياً", false, function(v) State.autoPlace = v end)
BaseTab:CreateToggle("تفقيس البيض تلقائياً", false, function(v) State.autoHatch = v end)
BaseTab:CreateToggle("ترقية القاعدة تلقائياً", false, function(v) State.autoUpgrade = v end)

-- Pets Tab
PetsTab:CreateSection("إدارة الحيوانات")
PetsTab:CreateToggle("لبس أفضل الحيوانات", false, function(v) State.autoEquipBest = v end)
PetsTab:CreateToggle("دمج الحيوانات تلقائياً", false, function(v) State.autoFuse = v end)
PetsTab:CreateToggle("بيع الحيوانات تلقائياً", false, function(v) State.autoSellPets = v end)

-- Visuals Tab
VisualsTab:CreateSection("كشف الأهداف (ESP)")
VisualsTab:CreateToggle("كشف البيض", false, function(v) State.espWorldEgg = v end)
VisualsTab:CreateToggle("كشف اللاعبين", false, function(v) State.espPlayer = v end)

-- Player Tab
PlayerTab:CreateSection("السرعة والقفز")
PlayerTab:CreateToggle("تعديل السرعة", false, function(v) State.speedOn = v end)
PlayerTab:CreateSlider("مقدار السرعة", 16, 80, 32, function(v) State.walkSpeed = v end)
PlayerTab:CreateToggle("قفز لا نهائي", false, function(v) State.infJump = v end)

-- Heartbeat Loop
track(RunService.Heartbeat:Connect(function()
	if not State.running then return end
	applySpeed()
	if State.jumpOn then
		local h = hum()
		if h then h.UseJumpPower = true; h.JumpPower = State.jumpPower end
	end
end))

-- Anti-AFK
track(LocalPlayer.Idled:Connect(function()
	if State.antiAfk then
		VirtualUser:CaptureController()
		VirtualUser:ClickButton2(Vector2.new())
	end
end))

notify("ScriptVerse", "تم تحميل السكربت بنجاح للجوال!", OkGreen, 3)
