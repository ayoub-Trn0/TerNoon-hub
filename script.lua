if not game:IsLoaded() then
    game.Loaded:Wait()
end
do
    local str

    do
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer

        if not LocalPlayer then
            pcall(function()
                Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
            end)
            LocalPlayer = Players.LocalPlayer
        end

        str = tostring(LocalPlayer and LocalPlayer.UserId or 0)
    end

    local v4 = getgenv and getgenv() or _G
    local KiraHub = v4.KiraHub

    if type(KiraHub) ~= "table" then
        KiraHub = {
			slots = {}
		}
        v4.KiraHub = KiraHub
    end

    if type(KiraHub.slots) ~= "table" then
        KiraHub.slots = {}
    end

    local unload

    do
        local v6 = KiraHub.slots[str]

        if type(v6) ~= "table" then
            v6 = {}
            KiraHub.slots[str] = v6
        end

        v6.gen = (tonumber(v6.gen) or 0) + 1

        local v7 = false

        for k, v in pairs(KiraHub.slots) do
            if str ~= tostring(k) and type(v) == "table" and v.alive == true then
                v7 = true

                break
            end
        end

        if not v7 then
            v4.KiraCfgGen = (tonumber(v4.KiraCfgGen) or 0) + 1
        end

        unload = v6.unload
        v6.unload = nil
        v6.alive = false
    end

    if type(unload) == "function" then
        pcall(unload)
    elseif type(v4.KiraUnload) == "function" then
        local KiraUnloadUid = v4.KiraUnloadUid
        local v12 = KiraUnloadUid == nil or str == tostring(KiraUnloadUid)

        if KiraUnloadUid == nil then
            for k, v in pairs(KiraHub.slots) do
                if str ~= tostring(k) and type(v) == "table" and type(v.unload) == "function" then
                    v12 = false

                    break
                end
            end
        end

        if v12 then
            local KiraUnload = v4.KiraUnload

            if str == tostring(KiraUnloadUid or str) then
                v4.KiraUnload = nil
                v4.KiraUnloadUid = nil
            end

            pcall(KiraUnload)
        end
    end
end
do
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    if not LocalPlayer then
        pcall(function()
            Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
        end)
        LocalPlayer = Players.LocalPlayer
    end

    local v18 = os.clock() + 60

    while LocalPlayer and v18 > os.clock() do
        local v20, v21

        do
            local Character = LocalPlayer.Character

            v20 = Character and Character:FindFirstChildOfClass("Humanoid")
            v21 = Character and Character:FindFirstChild("HumanoidRootPart")
        end

        if v20 and v21 and v20.Health > 0 then
            task.wait(0.45)

            local Character = LocalPlayer.Character
            local v23 = Character and Character:FindFirstChildOfClass("Humanoid")
            local v24 = Character and Character:FindFirstChild("HumanoidRootPart")

            if not v23 or not v24 or not (v23.Health > 0) then
                continue
            end

            break
        end

        task.wait(0.1)
    end
end
local t1 = {
	Title = "Kira Hub",
	Version = "0.1",
	Product = "Steal an Egg",
	OpenBind = Enum.KeyCode.RightShift,
	FlightBind = Enum.KeyCode.F,
	Tagline = "",
	Status = "preview",
	Game = "Steal an Egg",
	Discord = "https://discord.gg/ZNwS8csX3j",
	Website = "",
	Changelog = "",
	Author = "Kira (@kira_scripts.gg)",
	Credits = "Thanks to all my dicord members",
	Support = "Thank You for your support !"
}
local function v26(p1)
    local v328 = tostring(p1 or "Game"):gsub("[<>:\"/\\|?*]", "_"):gsub("%s+", "_"):gsub("_+", "_"):match("^%s*(.-)%s*$")

    if not v328 or v328 == "" or v328 == "_" then
        v328 = "Game"
    end

    return v328
end
t1.LogoFile = "Kira" .. "/logo.png"
t1.LogoFileLight = "Kira" .. "/logo-light.png"
local n1 = 620
local n2 = 430
local n3 = 152
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService, Stats, ProximityPromptService, ReplicatedStorage, LocalPlayer, v40, v41, u42, u43, u44, str, v48, v49, v50, v51, t2
local t3, t4, t5, t6, t7, t9, t10, t11, t12, u66, u67, u68, u69, u70, u71, t14
local v73, u75, u76, v79, self, v82, v83, v84, v85, v87, v98, v103, v108, v113, v151, v194
local v199, v217, v228, v229, v245, v250, v259, v261, v262, v263, u265, u266, v268, v270, v272, v274
local v277, v278, v279, v280, v281, v282, u284, v287, v288, v289, v290, v291, v292, v293
do
    local t8, t13, v81, v86

    do
        local t26, v94

        do
            local TweenService = game:GetService("TweenService")

            HttpService = game:GetService("HttpService")
            Stats = game:GetService("Stats")
            ProximityPromptService = game:GetService("ProximityPromptService")
            ReplicatedStorage = game:GetService("ReplicatedStorage")

            local GuiService = game:GetService("GuiService")

            LocalPlayer = Players.LocalPlayer

            if not LocalPlayer then
                pcall(function()
                    Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
                end)
                LocalPlayer = Players.LocalPlayer
            end

            function v40()
                if UserInputService.VREnabled then
                    return false
                end
                local u338 = false
                pcall(function()
                    u338 = GuiService:IsTenFootInterface()
                end)
                if u338 then
                    return false
                end
                if UserInputService.TouchEnabled then
                    return true
                end
                if UserInputService.MouseEnabled == false then
                    return true
                end
                local u339 = false
                local u340 = false
                pcall(function()
                    u339 = UserInputService.GyroscopeEnabled == true
                end)
                pcall(function()
                    u340 = UserInputService.AccelerometerEnabled == true
                end)
                if u339 or u340 then
                    return true
                end
                local PreferredInput
                local LastInputType
                pcall(function()
                    PreferredInput = UserInputService.PreferredInput
                end)
                pcall(function()
                    LastInputType = UserInputService:GetLastInputType()
                end)
                if PreferredInput == Enum.PreferredInput.Touch or LastInputType == Enum.UserInputType.Touch then
                    return true
                end
                local v343 = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")
                if v343 and (v343:FindFirstChild("TouchGui", true) or v343:FindFirstChild("TouchControlFrame", true) or v343:FindFirstChild("JumpButton", true) or v343:FindFirstChild("DynamicThumbstickFrame", true)) then
                    return true
                end

                return true -- Force Mobile Support Enabled
            end
            function v41()
                local CurrentCamera = workspace.CurrentCamera
                local v345 = if not CurrentCamera then Vector2.new(1280, 720) else CurrentCamera.ViewportSize
                local v346 = math.floor(math.clamp(v345.X * 0.7, 440, 560))
                local v347 = math.floor(math.clamp(v345.Y * 0.74, 340, 410))

                if v345.X > 80 then
                    v346 = math.min(v346, v345.X - 36)
                end

                if v345.Y > 80 then
                    v347 = math.min(v347, v345.Y - 36)
                end

                return math.max(400, v346), math.max(320, v347)
            end

            u42 = v40()
            u43 = false
            u44 = nil

            if u42 then
                local v45, v46 = v41()

                n1 = v45
                n2 = v46
                n3 = 128
            end

            str = tostring(LocalPlayer and LocalPlayer.UserId or 0)
            v48 = "PH_UI_" .. str
            v49 = "KiraWorldGui_" .. str

            function v50()
                return getgenv and getgenv() or _G
            end
            function v51()
                local v350 = getgenv and getgenv() or _G
                local KiraHub = v350.KiraHub

                if type(KiraHub) ~= "table" then
                    KiraHub = {
						slots = {}
					}
                    v350.KiraHub = KiraHub
                end

                if type(KiraHub.slots) ~= "table" then
                    KiraHub.slots = {}
                end

                local v352 = KiraHub.slots[str]

                if type(v352) ~= "table" then
                    v352 = {}
                    KiraHub.slots[str] = v352
                end

                return v352
            end

            t1.ConfigFile = (("Kira" .. "/" .. v26(t1.Game)) .. "/cache") .. "/" .. v26(LocalPlayer and LocalPlayer.Name or "Player") .. "-config.json"
            t2 = {
				Dark = {
					bg = Color3.fromRGB(12, 11, 10),
					rail = Color3.fromRGB(16, 15, 14),
					card = Color3.fromRGB(32, 30, 27),
					lift = Color3.fromRGB(42, 39, 35),
					fill = Color3.fromRGB(48, 44, 39),
					line = Color3.fromRGB(58, 53, 46),
					text = Color3.fromRGB(246, 242, 234),
					dim = Color3.fromRGB(168, 158, 144),
					mute = Color3.fromRGB(110, 102, 92),
					accent = Color3.fromRGB(214, 168, 108),
					accentDeep = Color3.fromRGB(92, 68, 36),
					accentHover = Color3.fromRGB(228, 186, 128),
					ink = Color3.fromRGB(22, 18, 14),
					ok = Color3.fromRGB(138, 166, 128),
					Kira = Color3.fromRGB(246, 242, 234)
				},
				Light = {
					bg = Color3.fromRGB(232, 226, 218),
					rail = Color3.fromRGB(232, 226, 218),
					card = Color3.fromRGB(252, 250, 246),
					lift = Color3.fromRGB(242, 236, 228),
					fill = Color3.fromRGB(224, 218, 208),
					line = Color3.fromRGB(204, 196, 184),
					text = Color3.fromRGB(28, 24, 20),
					dim = Color3.fromRGB(92, 84, 74),
					mute = Color3.fromRGB(128, 120, 108),
					accent = Color3.fromRGB(168, 114, 56),
					accentDeep = Color3.fromRGB(120, 80, 38),
					accentHover = Color3.fromRGB(186, 132, 70),
					ink = Color3.fromRGB(252, 250, 246),
					ok = Color3.fromRGB(64, 118, 82),
					Kira = Color3.fromRGB(28, 24, 20)
				}
			}
            t3 = {}

            for k, v in pairs(t2.Dark) do
                t3[k] = v
            end

            t4 = {
				title = Enum.Font.BuilderSansBold,
				mid = Enum.Font.BuilderSansMedium,
				body = Enum.Font.BuilderSans,
				mono = Enum.Font.RobotoMono
			}
            t5 = {
				"Forest",
				"Desert",
				"Lake",
				"Jungle",
				"Snow",
				"Volcano",
				"Prehistoric",
				"Cosmic",
				"Abyss Ocean",
				"Cherry Blossom"
			}
            t6 = {
				"Common",
				"Uncommon",
				"Rare",
				"Epic",
				"Legendary",
				"Mythic",
				"Cosmic",
				"Secret",
				"Eternal",
				"Divine",
				"Titan"
			}
            t7 = {
				"Golden",
				"Rainbow",
				"Galaxy",
				"Crystal",
				"Bloom"
			}
            t8 = {
				About = "info",
				["Auto Steal"] = "egg",
				Plot = "grid",
				Serverhop = "rocket",
				Misc = "layers",
				Webhook = "out",
				Settings = "cog"
			}
            t9 = {}
            t10 = {}
            t11 = {}
            t12 = {}
            t13 = {}
            u66 = nil
            u67 = nil
            u68 = nil
            u69 = nil
            u70 = nil
            u71 = nil
            t14 = {}

            function v73(p2)
                if p2 then
                    t14[#t14 + 1] = p2
                end

                return p2
            end

            local t15 = {}

            u75 = nil
            u76 = nil

            local function v77(p3)
                if type(p3) ~= "string" or p3 == "" then
                    return
                end

                local t16 = {}

                if crypt then
                    t16[#t16 + 1] = crypt.base64decode
                    t16[#t16 + 1] = crypt.base64_decode
                end

                if syn and syn.crypt and syn.crypt.base64 and syn.crypt.base64.decode then
                    t16[#t16 + 1] = syn.crypt.base64.decode
                end

                if base64 and base64.decode then
                    t16[#t16 + 1] = base64.decode
                end

                if base64_decode then
                    t16[#t16 + 1] = base64_decode
                end

                for i = 1, #t16 do
                    local ok, result = pcall(t16[i], p3)

                    if ok and type(result) == "string" and #result > 64 then
                        return result
                    end
                end
            end
            local function v78(p4)
                if p4 then
                    if u76 then
                        return u76
                    end
                elseif u75 then
                    return u75
                end

                local v367 = v77(not p4 and "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 groundwater")

                if not v367 then
                    return
                end

                local v368 = p4 and t1.LogoFileLight or t1.LogoFile

                if type(makefolder) == "function" then
                    pcall(makefolder, "Kira")
                end

                if writefile then
                    pcall(writefile, v368, v367)
                end

                if getcustomasset then
                    local ok, result = pcall(getcustomasset, v368)

                    if ok and type(result) == "string" and result ~= "" then
                        if p4 then
                            u76 = result

                            return result
                        end

                        u75 = result

                        return result
                    end
                end
            end

            function v79()
                local v371 = v78(t9.Theme == "Light")

                if not v371 then
                    return
                end

                for _, v in ipairs(t15) do
                    local Mark = v:FindFirstChild("Mark")

                    if Mark and Mark:IsA("ImageLabel") then
                        Mark.Image = v371
                        Mark.ImageColor3 = Color3.new(1, 1, 1)
                    end
                end
            end

            self = setmetatable({}, {
				__mode = "k"
			})

            function v81(p5, p6, p7, p8)
                local v379 = self[p5]

                if v379 then
                    pcall(function()
                        v379:Cancel()
                    end)
                end

                local tween = TweenService:Create(p5, TweenInfo.new(p6, p8 or Enum.EasingStyle.Quart, Enum.EasingDirection.Out), p7)

                self[p5] = tween
                tween:Play()
                tween.Completed:Connect(function()
                    if self[p5] == tween then
                        self[p5] = nil
                    end
                end)
            end
            function v82(p9, p10, p11)
                local v384 = Instance.new(p9)

                if p10 then
                    for k, v in pairs(p10) do
                        v384[k] = v
                    end
                end

                if p11 then
                    v384.Parent = p11
                end

                return v384
            end
            function v83(p12, p13, p14)
                local v396
                local v397
                if type(p13) == "string" then
                    v396 = p13
                    v397 = t3[p13] or t3.line
                else
                    v397 = p13 or t3.line
                end
                local t17 = {
					Color = v397,
					Thickness = p14 or 1,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border
				}
                local UIStroke = Instance.new("UIStroke")
                if t17 then
                    for k, v in pairs(t17) do
                        UIStroke[k] = v
                    end
                end
                if p12 then
                    UIStroke.Parent = p12
                end
                if v396 then
                    UIStroke:SetAttribute("th_stroke", v396)
                end

                return UIStroke
            end
            function v84(p15, p16, p17, p18, p19)
                if p17 == nil then
                    p17 = p16
                    p18 = p16
                    p19 = p16
                end

                local t18 = {
					PaddingLeft = UDim.new(0, p16),
					PaddingTop = UDim.new(0, p17),
					PaddingRight = UDim.new(0, p18 or p16),
					PaddingBottom = UDim.new(0, p19 or p17)
				}
                local UIPadding = Instance.new("UIPadding")

                if t18 then
                    for k, v in pairs(t18) do
                        UIPadding[k] = v
                    end
                end

                if p15 then
                    UIPadding.Parent = p15
                end

                return UIPadding
            end
            function v85(p20, p21, p22)
                if type(p21) == "string" then
                    if p20 and p21 then
                        p20:SetAttribute("th_bg", p21)

                        local v418 = t3[p21]

                        if v418 and p20:IsA("GuiObject") then
                            p20.BackgroundColor3 = v418
                        end
                    end

                    p20:SetAttribute("th_hover", p22)
                end

                p20.MouseEnter:Connect(function()
                    if p20:GetAttribute("locked") then
                        return
                    end

                    p20:SetAttribute("th_over", true)

                    local v1246 = p20:GetAttribute("th_hover") or p22
                    local v1247 = type(v1246) == "string" and t3[v1246] or v1246

                    if v1247 then
                        v81(p20, 0.12, {
							BackgroundColor3 = v1247
						})
                    end
                end)
                p20.MouseLeave:Connect(function()
                    if p20:GetAttribute("locked") then
                        return
                    end

                    p20:SetAttribute("th_over", false)

                    local v1248 = p20:GetAttribute("th_bg") or p21
                    local v1249 = type(v1248) == "string" and t3[v1248] or v1248

                    if v1249 then
                        v81(p20, 0.12, {
							BackgroundColor3 = v1249
						})
                    end
                end)
            end
            function v86(p23, p24, p25, p26)
                local t19 = {
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(16, 16),
					ZIndex = p26
				}
                local Frame = Instance.new("Frame")

                if t19 then
                    for k, v in pairs(t19) do
                        Frame[k] = v
                    end
                end

                if p23 then
                    Frame.Parent = p23
                end

                local v427 = Frame

                local function v428(p27, p28, p29, p30, p31)
                    local t20 = {
						BackgroundColor3 = p25,
						BorderSizePixel = 0,
						Position = UDim2.fromOffset(p27, p28),
						Size = UDim2.fromOffset(p29, p30),
						ZIndex = p26 + 1
					}
                    local v1256 = v427
                    local Frame2 = Instance.new("Frame")

                    if t20 then
                        for k, v in pairs(t20) do
                            Frame2[k] = v
                        end
                    end

                    if v1256 then
                        Frame2.Parent = v1256
                    end

                    if p31 then
                        local t21 = {
							CornerRadius = UDim.new(0, p31 or 8)
						}
                        local UICorner = Instance.new("UICorner")

                        if t21 then
                            for k, v in pairs(t21) do
                                UICorner[k] = v
                            end
                        end

                        if Frame2 then
                            UICorner.Parent = Frame2
                        end
                    end

                    return Frame2
                end
                local function v429(p32, p33, p34, p35, p36)
                    local t22 = {
						BackgroundTransparency = 1,
						Position = UDim2.fromOffset(p32, p33),
						Size = UDim2.fromOffset(p34, p35),
						ZIndex = p26 + 1
					}
                    local v1270 = v427
                    local Frame3 = Instance.new("Frame")

                    if t22 then
                        for k, v in pairs(t22) do
                            Frame3[k] = v
                        end
                    end

                    if v1270 then
                        Frame3.Parent = v1270
                    end

                    local t23 = {
						CornerRadius = UDim.new(0, p36 or 8)
					}
                    local UICorner = Instance.new("UICorner")

                    if t23 then
                        for k, v in pairs(t23) do
                            UICorner[k] = v
                        end
                    end

                    if Frame3 then
                        UICorner.Parent = Frame3
                    end

                    v83(Frame3, p25, 1.2)

                    return Frame3
                end

                if p24 == "egg" then
                    v428(4, 2, 8, 12, 5)

                    return v427
                end

                if p24 == "aim" then
                    v429(2, 2, 12, 12, 6)
                    v428(7, 7, 2, 2, 1)
                    v428(7, 0, 2, 3, 0)
                    v428(7, 13, 2, 3, 0)
                    v428(0, 7, 3, 2, 0)
                    v428(13, 7, 3, 2, 0)

                    return v427
                end

                if p24 == "spark" then
                    v428(7, 1, 2, 14, 1)
                    v428(1, 7, 14, 2, 1)
                    v428(4, 4, 2, 2, 1)
                    v428(10, 10, 2, 2, 1)

                    return v427
                end

                if p24 == "grid" then
                    v428(1, 1, 6, 6, 2)
                    v428(9, 1, 6, 6, 2)
                    v428(1, 9, 6, 6, 2)
                    v428(9, 9, 6, 6, 2)

                    return v427
                end

                if p24 == "layers" then
                    v428(2, 3, 12, 2, 1)
                    v428(2, 7, 12, 2, 1)
                    v428(2, 11, 12, 2, 1)

                    return v427
                end

                if p24 == "out" then
                    v429(1, 3, 10, 10, 3)
                    v428(8, 2, 6, 2, 1)
                    v428(12, 2, 2, 6, 1)

                    return v427
                end

                if p24 == "cog" then
                    v429(3, 3, 10, 10, 5)
                    v428(7, 1, 2, 3, 1)
                    v428(7, 12, 2, 3, 1)
                    v428(1, 7, 3, 2, 1)
                    v428(12, 7, 3, 2, 1)

                    return v427
                end

                if p24 == "rocket" then
                    v428(6, 1, 4, 9, 2)
                    v428(7, 0, 2, 3, 1)
                    v428(4, 8, 3, 4, 1)
                    v428(9, 8, 3, 4, 1)
                    v428(7, 11, 2, 4, 1)

                    return v427
                end

                if p24 == "search" then
                    v429(1, 1, 10, 10, 5)
                    v428(9, 10, 5, 2, 1).Rotation = 40

                    return v427
                end

                if p24 == "info" then
                    v429(2, 2, 12, 12, 6)
                    v428(7, 4, 2, 2, 1)
                    v428(7, 7, 2, 5, 1)
                end

                return v427
            end
            function v87(p37, p38, p39)
                local v433 = p39 or 18
                local t24 = {
					Name = "Kira Hub",
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(v433, v433),
					ZIndex = p38
				}
                local Frame = Instance.new("Frame")

                if t24 then
                    for k, v in pairs(t24) do
                        Frame[k] = v
                    end
                end

                if p37 then
                    Frame.Parent = p37
                end

                local v438 = v78(false)
                local t25 = {
					Name = "Mark",
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					Image = v438 or "",
					ImageColor3 = Color3.new(1, 1, 1),
					ScaleType = Enum.ScaleType.Fit,
					ZIndex = p38 + 1
				}
                local ImageLabel = Instance.new("ImageLabel")

                if t25 then
                    for k, v in pairs(t25) do
                        ImageLabel[k] = v
                    end
                end

                if Frame then
                    ImageLabel.Parent = Frame
                end

                t15[#t15 + 1] = Frame

                return Frame
            end

            local function v88()
                if gethui then
                    local ok, result = pcall(gethui)

                    if ok and result then
                        return result
                    end
                end

                local CoreGui = game:GetService("CoreGui")

                if pcall(function()
                    return CoreGui:FindFirstChild("PH_UI")
                end) then
                    return CoreGui
                end

                return LocalPlayer:WaitForChild("PlayerGui")
            end

            local v89 = v88()
            local v90 = v89:FindFirstChild(v48)

            if v90 then
                v90:Destroy()
            end

            local PH_UI = v89:FindFirstChild("PH_UI")

            if PH_UI then
                local KiraUnloadUid = (getgenv and getgenv() or _G).KiraUnloadUid

                if KiraUnloadUid == nil or str == tostring(KiraUnloadUid) then
                    PH_UI:Destroy()
                end
            end

            t26 = {
				Name = v48,
				ResetOnSpawn = false,
				IgnoreGuiInset = true,
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
				DisplayOrder = 1200
			}
            v94 = v88()
        end

        local ScreenGui = Instance.new("ScreenGui")

        if t26 then
            for k, v in pairs(t26) do
                ScreenGui[k] = v
            end
        end

        if v94 then
            ScreenGui.Parent = v94
        end

        v98 = ScreenGui
        pcall(function()
            if syn and syn.protect_gui then
                syn.protect_gui(v98)
            end
        end)

        local t27 = {
			Name = "Overlay",
			BackgroundTransparency = 1,
			Text = "",
			AutoButtonColor = false,
			Size = UDim2.fromScale(1, 1),
			Visible = false,
			ZIndex = 80
		}
        local TextButton = Instance.new("TextButton")

        if t27 then
            for k, v in pairs(t27) do
                TextButton[k] = v
            end
        end

        if v98 then
            TextButton.Parent = v98
        end

        v103 = TextButton

        local t28 = {
			Scale = 1
		}
        local UIScale = Instance.new("UIScale")

        if t28 then
            for k, v in pairs(t28) do
                UIScale[k] = v
            end
        end

        v108 = UIScale

        local t29 = {
			Name = "Window",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(n1, n2),
			BackgroundColor3 = t3.bg,
			BorderSizePixel = 0,
			ClipsDescendants = false,
			ZIndex = 10
		}
        local Frame = Instance.new("Frame")

        if t29 then
            for k, v in pairs(t29) do
                Frame[k] = v
            end
        end

        if v98 then
            Frame.Parent = v98
        end

        v113 = Frame
    end

    do
        local t30 = {
			CornerRadius = UDim.new(0, 12)
		}
        local UICorner = Instance.new("UICorner")

        if t30 then
            for k, v in pairs(t30) do
                UICorner[k] = v
            end
        end

        if v113 then
            UICorner.Parent = v113
        end

        local s1 = "line"
        local t31 = {
			Color = t3.line or t3.line,
			Thickness = 1,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		}
        local UIStroke = Instance.new("UIStroke")

        if t31 then
            for k, v in pairs(t31) do
                UIStroke[k] = v
            end
        end

        if v113 then
            UIStroke.Parent = v113
        end

        if s1 then
            UIStroke:SetAttribute("th_stroke", s1)
        end

        v108.Parent = v113

        if v113 then
            v113:SetAttribute("th_bg", "bg")

            local bg = t3.bg

            if bg and v113:IsA("GuiObject") then
                v113.BackgroundColor3 = bg
            end
        end

        local t32 = {
			Name = "Shadow",
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 0.7,
			Position = UDim2.fromOffset(8, 12),
			Size = UDim2.new(1, 0, 1, 0),
			ZIndex = 9,
			BorderSizePixel = 0
		}
        local Frame = Instance.new("Frame")

        if t32 then
            for k, v in pairs(t32) do
                Frame[k] = v
            end
        end

        if v113 then
            Frame.Parent = v113
        end

        local Shadow = v113.Shadow
        local t33 = {
			CornerRadius = UDim.new(0, 14)
		}
        local UICorner2 = Instance.new("UICorner")

        if t33 then
            for k, v in pairs(t33) do
                UICorner2[k] = v
            end
        end

        if Shadow then
            UICorner2.Parent = Shadow
        end
    end

    do
        local t34 = {
			Name = "HeadBar",
			BackgroundColor3 = t3.rail,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 82),
			ZIndex = 11
		}
        local Frame = Instance.new("Frame")

        if t34 then
            for k, v in pairs(t34) do
                Frame[k] = v
            end
        end

        if v113 then
            Frame.Parent = v113
        end

        if Frame then
            Frame:SetAttribute("th_bg", "rail")

            local rail = t3.rail

            if rail and Frame:IsA("GuiObject") then
                Frame.BackgroundColor3 = rail
            end
        end

        local t35 = {
			CornerRadius = UDim.new(0, 12)
		}
        local UICorner = Instance.new("UICorner")

        if t35 then
            for k, v in pairs(t35) do
                UICorner[k] = v
            end
        end

        if Frame then
            UICorner.Parent = Frame
        end

        local t36 = {
			BackgroundColor3 = t3.rail,
			BorderSizePixel = 0,
			Position = UDim2.new(0, 0, 1, -16),
			Size = UDim2.new(1, 0, 0, 16),
			ZIndex = 11
		}
        local Frame4 = Instance.new("Frame")

        if t36 then
            for k, v in pairs(t36) do
                Frame4[k] = v
            end
        end

        if Frame then
            Frame4.Parent = Frame
        end

        if Frame4 then
            Frame4:SetAttribute("th_bg", "rail")

            local rail = t3.rail

            if rail and Frame4:IsA("GuiObject") then
                Frame4.BackgroundColor3 = rail
            end
        end

        local t37 = {
			Name = "Rail",
			BackgroundColor3 = t3.rail,
			BorderSizePixel = 0,
			Size = UDim2.new(0, n3, 1, 0),
			ZIndex = 11
		}
        local Frame5 = Instance.new("Frame")

        if t37 then
            for k, v in pairs(t37) do
                Frame5[k] = v
            end
        end

        if v113 then
            Frame5.Parent = v113
        end

        v151 = Frame5

        if v151 then
            v151:SetAttribute("th_bg", "rail")

            local rail = t3.rail

            if rail and v151:IsA("GuiObject") then
                v151.BackgroundColor3 = rail
            end
        end

        local t38 = {
			CornerRadius = UDim.new(0, 12)
		}
        local UICorner3 = Instance.new("UICorner")

        if t38 then
            for k, v in pairs(t38) do
                UICorner3[k] = v
            end
        end

        if v151 then
            UICorner3.Parent = v151
        end
    end

    local v171, v204, v210

    do
        local Frame, TextLabel

        do
            local t39 = {
				BackgroundColor3 = t3.rail,
				BorderSizePixel = 0,
				Position = UDim2.new(1, -16, 0, 0),
				Size = UDim2.new(0, 16, 1, 0),
				ZIndex = 11
			}
            local Frame6 = Instance.new("Frame")

            if t39 then
                for k, v in pairs(t39) do
                    Frame6[k] = v
                end
            end

            if v151 then
                Frame6.Parent = v151
            end

            if Frame6 then
                Frame6:SetAttribute("th_bg", "rail")

                local rail = t3.rail

                if rail and Frame6:IsA("GuiObject") then
                    Frame6.BackgroundColor3 = rail
                end
            end

            local t40 = {
				BackgroundColor3 = t3.line,
				BorderSizePixel = 0,
				Position = UDim2.new(1, -1, 0, 2),
				Size = UDim2.new(0, 1, 1, -2),
				ZIndex = 12
			}
            local Frame7 = Instance.new("Frame")

            if t40 then
                for k, v in pairs(t40) do
                    Frame7[k] = v
                end
            end

            if v151 then
                Frame7.Parent = v151
            end

            if Frame7 then
                Frame7:SetAttribute("th_bg", "line")

                local line = t3.line

                if line and Frame7:IsA("GuiObject") then
                    Frame7.BackgroundColor3 = line
                end
            end

            v151.Active = true

            local t41 = {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, -18),
				Position = UDim2.fromOffset(0, 12),
				CanvasSize = UDim2.new(0, 0, 0, 0),
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				ScrollBarThickness = not u42 and 0 or 5,
				BorderSizePixel = 0,
				ZIndex = 12
			}
            local ScrollingFrame = Instance.new("ScrollingFrame")

            if t41 then
                for k, v in pairs(t41) do
                    ScrollingFrame[k] = v
                end
            end

            if v151 then
                ScrollingFrame.Parent = v151
            end

            v171 = ScrollingFrame
            v84(v171, 10, 2, 10, 12)

            local t42 = {
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, 3),
				SortOrder = Enum.SortOrder.LayoutOrder
			}
            local UIListLayout = Instance.new("UIListLayout")

            if t42 then
                for k, v in pairs(t42) do
                    UIListLayout[k] = v
                end
            end

            if v171 then
                UIListLayout.Parent = v171
            end

            local t43 = {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 40),
				LayoutOrder = 0,
				ZIndex = 12
			}

            Frame = Instance.new("Frame")

            if t43 then
                for k, v in pairs(t43) do
                    Frame[k] = v
                end
            end

            if v171 then
                Frame.Parent = v171
            end

            v87(Frame, 13, 28).Position = UDim2.fromOffset(0, 2)

            local t44 = {
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(34, 3),
				Size = UDim2.new(1, -34, 0, 16),
				Font = t4.title,
				Text = t1.Title,
				TextColor3 = t3.text,
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd,
				ZIndex = 13
			}

            TextLabel = Instance.new("TextLabel")

            if t44 then
                for k, v in pairs(t44) do
                    TextLabel[k] = v
                end
            end
        end

        if Frame then
            TextLabel.Parent = Frame
        end

        if TextLabel then
            TextLabel:SetAttribute("th_text", "text")

            local text = t3.text

            if text then
                TextLabel.TextColor3 = text
            end
        end

        local t45 = {
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(34, 20),
			Size = UDim2.new(1, -34, 0, 12),
			Font = t4.mono,
			Text = t1.Product,
			TextColor3 = t3.mute,
			TextSize = 9,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 13
		}
        local TextLabel2 = Instance.new("TextLabel")

        if t45 then
            for k, v in pairs(t45) do
                TextLabel2[k] = v
            end
        end

        if Frame then
            TextLabel2.Parent = Frame
        end

        if TextLabel2 then
            TextLabel2:SetAttribute("th_text", "mute")

            local mute = t3.mute

            if mute then
                TextLabel2.TextColor3 = mute
            end
        end

        local t46 = {
			Name = "Main",
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(n3, 2),
			Size = UDim2.new(1, -n3, 1, -2),
			ZIndex = 11
		}
        local Frame8 = Instance.new("Frame")

        if t46 then
            for k, v in pairs(t46) do
                Frame8[k] = v
            end
        end

        if v113 then
            Frame8.Parent = v113
        end

        v194 = Frame8

        local t47 = {
			Name = "Header",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 46),
			ZIndex = 12,
			Active = true
		}
        local Frame9 = Instance.new("Frame")

        if t47 then
            for k, v in pairs(t47) do
                Frame9[k] = v
            end
        end

        if v194 then
            Frame9.Parent = v194
        end

        v199 = Frame9

        local t48 = {
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(14, 8),
			Size = UDim2.new(1, -180, 0, 18),
			Font = t4.title,
			Text = "Auto Steal",
			TextColor3 = t3.text,
			TextSize = 16,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 12
		}
        local TextLabel3 = Instance.new("TextLabel")

        if t48 then
            for k, v in pairs(t48) do
                TextLabel3[k] = v
            end
        end

        if v199 then
            TextLabel3.Parent = v199
        end

        v204 = TextLabel3

        if v204 then
            v204:SetAttribute("th_text", "text")

            local text = t3.text

            if text then
                v204.TextColor3 = text
            end
        end

        local t49 = {
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(14, 26),
			Size = UDim2.new(1, -180, 0, 14),
			Font = t4.body,
			Text = "idle",
			TextColor3 = t3.dim,
			TextSize = 11,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 12
		}
        local TextLabel4 = Instance.new("TextLabel")

        if t49 then
            for k, v in pairs(t49) do
                TextLabel4[k] = v
            end
        end

        if v199 then
            TextLabel4.Parent = v199
        end

        v210 = TextLabel4
    end

    if v210 then
        v210:SetAttribute("th_text", "dim")

        local dim = t3.dim

        if dim then
            v210.TextColor3 = dim
        end
    end

    local Frame, UIStroke

    do
        local function v212(p40, p41)
            local t50 = {
				AnchorPoint = Vector2.new(1, 0.5),
				BackgroundColor3 = t3.card,
				Position = UDim2.new(1, p41, 0.5, 2),
				Size = UDim2.fromOffset(p40, 22),
				Font = t4.mono,
				Text = "—",
				TextColor3 = t3.dim,
				TextSize = 10,
				ZIndex = 12
			}
            local v449 = v199
            local TextLabel = Instance.new("TextLabel")

            if t50 then
                for k, v in pairs(t50) do
                    TextLabel[k] = v
                end
            end

            if v449 then
                TextLabel.Parent = v449
            end

            local t51 = {
				CornerRadius = UDim.new(0, 7)
			}
            local UICorner = Instance.new("UICorner")

            if t51 then
                for k, v in pairs(t51) do
                    UICorner[k] = v
                end
            end

            if TextLabel then
                UICorner.Parent = TextLabel
            end

            local s2 = "line"
            local t52 = {
				Color = t3.line or t3.line,
				Thickness = 1,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			}
            local UIStroke2 = Instance.new("UIStroke")

            if t52 then
                for k, v in pairs(t52) do
                    UIStroke2[k] = v
                end
            end

            if TextLabel then
                UIStroke2.Parent = TextLabel
            end

            if s2 then
                UIStroke2:SetAttribute("th_stroke", s2)
            end

            if TextLabel then
                TextLabel:SetAttribute("th_bg", "card")

                local card = t3.card

                if card and TextLabel:IsA("GuiObject") then
                    TextLabel.BackgroundColor3 = card
                end
            end

            if TextLabel then
                TextLabel:SetAttribute("th_text", "dim")

                local dim = t3.dim

                if not dim then
                    return TextLabel
                end

                TextLabel.TextColor3 = dim
            end

            return TextLabel
        end

        local t53 = {
			AnchorPoint = Vector2.new(1, 0.5),
			BackgroundColor3 = t3.card,
			Position = UDim2.new(1, -12, 0.5, 2),
			Size = UDim2.fromOffset(not u42 and 22 or 32, not u42 and 22 or 32),
			Font = t4.mid,
			Text = "–",
			TextColor3 = t3.dim,
			TextSize = 14,
			AutoButtonColor = false,
			ZIndex = 12
		}
        local TextButton = Instance.new("TextButton")

        if t53 then
            for k, v in pairs(t53) do
                TextButton[k] = v
            end
        end

        if v199 then
            TextButton.Parent = v199
        end

        v217 = TextButton

        local t54 = {
			CornerRadius = UDim.new(0, 7)
		}
        local UICorner = Instance.new("UICorner")

        if t54 then
            for k, v in pairs(t54) do
                UICorner[k] = v
            end
        end

        if v217 then
            UICorner.Parent = v217
        end

        local s3 = "line"
        local t55 = {
			Color = t3.line or t3.line,
			Thickness = 1,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		}
        local UIStroke3 = Instance.new("UIStroke")

        if t55 then
            for k, v in pairs(t55) do
                UIStroke3[k] = v
            end
        end

        if v217 then
            UIStroke3.Parent = v217
        end

        if s3 then
            UIStroke3:SetAttribute("th_stroke", s3)
        end

        v85(v217, "card", "lift")

        if v217 then
            v217:SetAttribute("th_text", "dim")

            local dim = t3.dim

            if dim then
                v217.TextColor3 = dim
            end
        end

        v228 = v212(52, -54)
        v229 = v212(56, -110)

        local t56 = {
			BackgroundColor3 = t3.card,
			Position = UDim2.fromOffset(14, 46),
			Size = UDim2.new(1, -28, 0, not u42 and 28 or 36),
			ZIndex = 12
		}

        Frame = Instance.new("Frame")
    end

    -- Mobile Toggle Button Implementation
    local MobileToggleButton = Instance.new("TextButton")
    local MobileUICorner = Instance.new("UICorner")
    local MobileUIStroke = Instance.new("UIStroke")

    MobileToggleButton.Name = "KiraMobileToggle"
    MobileToggleButton.Parent = v98
    MobileToggleButton.BackgroundColor3 = t3.card or Color3.fromRGB(32, 30, 27)
    MobileToggleButton.Position = UDim2.new(0, 15, 0.4, 0)
    MobileToggleButton.Size = UDim2.new(0, 50, 0, 50)
    MobileToggleButton.Font = t4.title
    MobileToggleButton.Text = "Kira"
    MobileToggleButton.TextColor3 = t3.accent or Color3.fromRGB(214, 168, 108)
    MobileToggleButton.TextSize = 14
    MobileToggleButton.Active = true
    MobileToggleButton.Draggable = true
    MobileToggleButton.ZIndex = 1000

    MobileUICorner.CornerRadius = UDim.new(0, 25)
    MobileUICorner.Parent = MobileToggleButton

    MobileUIStroke.Color = t3.accent or Color3.fromRGB(214, 168, 108)
    MobileUIStroke.Thickness = 2
    MobileUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    MobileUIStroke.Parent = MobileToggleButton

    MobileToggleButton.MouseButton1Click:Connect(function()
        v113.Visible = not v113.Visible
    end)

    if v217 then
        v217.MouseButton1Click:Connect(function()
            v113.Visible = false
        end)
    end
end
