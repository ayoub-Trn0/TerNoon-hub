repeat
    task.wait()
until game:IsLoaded() and game.Players.LocalPlayer and game.Players.LocalPlayer:FindFirstChild("Data")

-- تحميل مكتبة الواجهة
local PiHub = loadstring(game:HttpGet("https://you.whimper.xyz/sources/pihub/lib/bf.lua", true))()
local Window = PiHub:Window("BloxFruit - Auto Farm Only")

-- إنشاء تاب واحد فقط (Auto Farm)
local Farm = Window:Tab("Auto Farm", "rbxassetid://18899804355")

-----------------------------------------------------------------------------------------------------------------------------
-- المتغيرات والخدمات الأساسية
local LP = game.Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

_G.AutoFarm = false
_G.Auto_Saber = false
_G.AutoRengoku = false
_G.AutoSuperhuman = false
_G.AutoDeathStep = false
_G.AutoSharkman = false
_G.AutoElectricClaw = false
_G.AutoDragonTalon = false
_G.Auto_God_Human = false
_G.SelectWeapon = "Melee"
local Pos = CFrame.new(0, 8, 0)

-- حماية وتجاوز الفحص (Anti-Ban & Anti-AFK)
pcall(function()
    VirtualUser:CaptureController()
    LP.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end)

-- دالة التحريك (topos)
function topos(TargetCFrame)
    if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then return end
    local HRT = LP.Character.HumanoidRootPart
    local Distance = (TargetCFrame.Position - HRT.Position).Magnitude
    
    if Distance > 250 then
        HRT.CFrame = TargetCFrame
    else
        local Tween = game:GetService("TweenService"):Create(
            HRT,
            TweenInfo.new(Distance / 350, Enum.EasingStyle.Linear),
            {CFrame = TargetCFrame}
        )
        Tween:Play()
    end
end

-- إيقاف الـ Tween
function StopTween(State)
    if not State and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        LP.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame
    end
end

-- تجهيز السلاح
function EquipWeapon(ToolName)
    pcall(function()
        if LP.Backpack:FindFirstChild(ToolName) then
            LP.Character.Humanoid:EquipTool(LP.Backpack:FindFirstChild(ToolName))
        elseif LP.Character:FindFirstChild(ToolName) then
            return
        end
    end)
end

function UnEquipWeapon(ToolName)
    pcall(function()
        if LP.Character:FindFirstChild(ToolName) then
            LP.Character.Humanoid:UnequipTools()
        end
    end)
end

function AutoHaki()
    pcall(function()
        if not LP.Character:FindFirstChild("HasBuso") then
            RS.Remotes.CommF_:InvokeServer("BuyHaki", "Buso")
        end
    end)
end

-----------------------------------------------------------------------------------------------------------------------------
-- 1. أوتو فارم اللفل الرئيسي (Level Farm)
-----------------------------------------------------------------------------------------------------------------------------
Farm:Toggle("Auto Farm Level", false, function(value)
    _G.AutoFarm = value
end)

local Mon, LevelQuest, NameQuest, NameMon, CFrameQuest, CFrameMon
function CheckQuest() 
    local MyLevel = LP.Data.Level.Value
    if game.PlaceId == 2753915549 then -- World 1
        if MyLevel >= 1 and MyLevel <= 9 then
            Mon = "Bandit"; LevelQuest = 1; NameQuest = "BanditQuest1"; NameMon = "Bandit"
            CFrameQuest = CFrame.new(1059.37195, 15.4495068, 1550.4231)
            CFrameMon = CFrame.new(1045.962646484375, 27.00250816345215, 1560.8203125)
        elseif MyLevel >= 10 and MyLevel <= 14 then
            Mon = "Monkey"; LevelQuest = 1; NameQuest = "JungleQuest"; NameMon = "Monkey"
            CFrameQuest = CFrame.new(-1598.08911, 35.5501175, 153.377838)
            CFrameMon = CFrame.new(-1448.51806640625, 67.85301208496094, 11.46579647064209)
        elseif MyLevel >= 15 and MyLevel <= 29 then
            Mon = "Gorilla"; LevelQuest = 2; NameQuest = "JungleQuest"; NameMon = "Gorilla"
            CFrameQuest = CFrame.new(-1598.08911, 35.5501175, 153.377838)
            CFrameMon = CFrame.new(-1129.8836669921875, 40.46354675292969, -525.4237060546875)
        elseif MyLevel >= 30 and MyLevel <= 39 then
            Mon = "Pirate"; LevelQuest = 1; NameQuest = "BuggyQuest1"; NameMon = "Pirate"
            CFrameQuest = CFrame.new(-1141.07483, 4.10001802, 3831.5498)
            CFrameMon = CFrame.new(-1103.513427734375, 13.752052307128906, 3896.091064453125)
        elseif MyLevel >= 40 and MyLevel <= 59 then
            Mon = "Brute"; LevelQuest = 2; NameQuest = "BuggyQuest1"; NameMon = "Brute"
            CFrameQuest = CFrame.new(-1141.07483, 4.10001802, 3831.5498)
            CFrameMon = CFrame.new(-1140.083740234375, 14.809885025024414, 4322.92138671875)
        else
            Mon = "Bandit"; LevelQuest = 1; NameQuest = "BanditQuest1"; NameMon = "Bandit"
            CFrameQuest = CFrame.new(1059.37195, 15.4495068, 1550.4231)
            CFrameMon = CFrame.new(1045.962646484375, 27.00250816345215, 1560.8203125)
        end
    end
end

task.spawn(function()
    while task.wait() do
        if _G.AutoFarm then
            pcall(function()
                CheckQuest()
                if not LP.PlayerGui.Main:FindFirstChild("Quest").Visible then
                    topos(CFrameQuest)
                    if (CFrameQuest.Position - LP.Character.HumanoidRootPart.Position).Magnitude <= 15 then
                        RS.Remotes.CommF_:InvokeServer("StartQuest", NameQuest, LevelQuest)
                    end
                else
                    for _, v in pairs(workspace.Enemies:GetChildren()) do
                        if v.Name == NameMon and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
                            repeat task.wait()
                                EquipWeapon(_G.SelectWeapon)
                                LP.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * Pos
                                VirtualUser:CaptureController()
                                VirtualUser:Button1Down(Vector2.new(1280, 672), workspace.CurrentCamera.CFrame)
                            until not _G.AutoFarm or not v.Parent or v.Humanoid.Health <= 0
                        end
                    end
                end
            end)
        end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------
-- 2. أوتو السيوف (Auto Saber & Rengoku)
-----------------------------------------------------------------------------------------------------------------------------
Farm:Seperator("Auto Swords")

Farm:Toggle("Auto Saber", false, function(value)
    _G.Auto_Saber = value
end)

task.spawn(function()
    while task.wait() do
        if _G.Auto_Saber then
            pcall(function()
                if RS.Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon") == 1 then
                    RS.Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon")
                    task.wait(0.5)
                    EquipWeapon("Relic")
                    task.wait(0.5)
                    topos(CFrame.new(-1404.91504, 29.9773273, 3.80598116, 0.876514494, 5.66906877e-09, 0.481375456, 2.53851997e-08, 1, -5.79995607e-08, -0.481375456, 6.30572643e-08, 0.876514494))
                else
                    if workspace.Enemies:FindFirstChild("Saber Expert") or RS:FindFirstChild("Saber Expert") then
                        for _, v in pairs(workspace.Enemies:GetChildren()) do
                            if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                if v.Name == "Saber Expert" then
                                    repeat task.wait()
                                        EquipWeapon(_G.SelectWeapon)
                                        topos(v.HumanoidRootPart.CFrame * Pos)
                                        v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                        v.HumanoidRootPart.Transparency = 1
                                        v.Humanoid.JumpPower = 0
                                        v.Humanoid.WalkSpeed = 0
                                        v.HumanoidRootPart.CanCollide = false
                                        VirtualUser:CaptureController()
                                        VirtualUser:Button1Down(Vector2.new(1280, 672), workspace.CurrentCamera.CFrame)
                                    until v.Humanoid.Health <= 0 or not _G.Auto_Saber
                                    if v.Humanoid.Health <= 0 then
                                        RS.Remotes.CommF_:InvokeServer("ProQuestProgress", "PlaceRelic")
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

Farm:Toggle("Auto Rengoku", false, function(value)
    _G.AutoRengoku = value
    StopTween(_G.AutoRengoku)
end)

task.spawn(function()
    while task.wait() do
        pcall(function()
            if _G.AutoRengoku then
                if LP.Backpack:FindFirstChild("Hidden Key") or LP.Character:FindFirstChild("Hidden Key") then
                    EquipWeapon("Hidden Key")
                    topos(CFrame.new(6571.1201171875, 299.23028564453, -6967.841796875))
                elseif workspace.Enemies:FindFirstChild("Snow Lurker") or workspace.Enemies:FindFirstChild("Arctic Warrior") then
                    for _, v in pairs(workspace.Enemies:GetChildren()) do
                        if (v.Name == "Snow Lurker" or v.Name == "Arctic Warrior") and v.Humanoid.Health > 0 then
                            repeat task.wait()
                                EquipWeapon(_G.SelectWeapon)
                                AutoHaki()
                                v.HumanoidRootPart.CanCollide = false
                                v.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                                topos(v.HumanoidRootPart.CFrame * Pos)
                                VirtualUser:CaptureController()
                                VirtualUser:Button1Down(Vector2.new(1280, 672))
                            until LP.Backpack:FindFirstChild("Hidden Key") or _G.AutoRengoku == false or not v.Parent or v.Humanoid.Health <= 0
                        end
                    end
                else
                    topos(CFrame.new(5439.716796875, 84.420944213867, -6715.1635742188))
                end
            end
        end)
    end
end)

-----------------------------------------------------------------------------------------------------------------------------
-- 3. أوتو أساليب القتال (Auto Melee)
-----------------------------------------------------------------------------------------------------------------------------
Farm:Seperator("Auto Melee")

Farm:Toggle("Auto Superhuman", false, function(value)
    _G.AutoSuperhuman = value
end)

task.spawn(function()
    while task.wait() do 
        pcall(function()
            if _G.AutoSuperhuman then
                if (LP.Backpack:FindFirstChild("Combat") or LP.Character:FindFirstChild("Combat")) and LP.Data.Beli.Value >= 150000 then
                    UnEquipWeapon("Combat")
                    task.wait(.1)
                    RS.Remotes.CommF_:InvokeServer("BuyBlackLeg")
                end   
                if LP.Character:FindFirstChild("Superhuman") or LP.Backpack:FindFirstChild("Superhuman") then
                    _G.SelectWeapon = "Superhuman"
                end  
                if LP.Backpack:FindFirstChild("Black Leg") or LP.Character:FindFirstChild("Black Leg") or LP.Backpack:FindFirstChild("Electro") or LP.Character:FindFirstChild("Electro") or LP.Backpack:FindFirstChild("Fishman Karate") or LP.Character:FindFirstChild("Fishman Karate") or LP.Backpack:FindFirstChild("Dragon Claw") or LP.Character:FindFirstChild("Dragon Claw") then
                    if LP.Backpack:FindFirstChild("Black Leg") and LP.Backpack["Black Leg"].Level.Value <= 299 then
                        _G.SelectWeapon = "Black Leg"
                    end
                    if LP.Backpack:FindFirstChild("Electro") and LP.Backpack["Electro"].Level.Value <= 299 then
                        _G.SelectWeapon = "Electro"
                    end
                    if LP.Backpack:FindFirstChild("Fishman Karate") and LP.Backpack["Fishman Karate"].Level.Value <= 299 then
                        _G.SelectWeapon = "Fishman Karate"
                    end
                    if LP.Backpack:FindFirstChild("Dragon Claw") and LP.Backpack["Dragon Claw"].Level.Value <= 299 then
                        _G.SelectWeapon = "Dragon Claw"
                    end
                    if (LP.Backpack:FindFirstChild("Black Leg") or LP.Character:FindFirstChild("Black Leg")) and (LP.Backpack:FindFirstChild("Black Leg") or LP.Character:FindFirstChild("Black Leg")).Level.Value >= 300 and LP.Data.Beli.Value >= 300000 then
                        UnEquipWeapon("Black Leg")
                        task.wait(.1)
                        RS.Remotes.CommF_:InvokeServer("BuyElectro")
                    end
                    if (LP.Backpack:FindFirstChild("Electro") or LP.Character:FindFirstChild("Electro")) and (LP.Backpack:FindFirstChild("Electro") or LP.Character:FindFirstChild("Electro")).Level.Value >= 300 and LP.Data.Beli.Value >= 750000 then
                        UnEquipWeapon("Electro")
                        task.wait(.1)
                        RS.Remotes.CommF_:InvokeServer("BuyFishmanKarate")
                    end
                    if (LP.Backpack:FindFirstChild("Fishman Karate") or LP.Character:FindFirstChild("Fishman Karate")) and (LP.Backpack:FindFirstChild("Fishman Karate") or LP.Character:FindFirstChild("Fishman Karate")).Level.Value >= 300 and LP.Data.Fragments.Value >= 1500 then
                        UnEquipWeapon("Fishman Karate")
                        task.wait(.1)
                        RS.Remotes.CommF_:InvokeServer("BlackbeardReward", "DragonClaw", "1")
                        RS.Remotes.CommF_:InvokeServer("BlackbeardReward", "DragonClaw", "2") 
                    end
                    if (LP.Backpack:FindFirstChild("Dragon Claw") or LP.Character:FindFirstChild("Dragon Claw")) and (LP.Backpack:FindFirstChild("Dragon Claw") or LP.Character:FindFirstChild("Dragon Claw")).Level.Value >= 300 and LP.Data.Beli.Value >= 3000000 then
                        UnEquipWeapon("Dragon Claw")
                        task.wait(.1)
                        RS.Remotes.CommF_:InvokeServer("BuySuperhuman")
                    end
                end
            end
        end)
    end
end)

Farm:Toggle("Auto Death Step", false, function(value)
    _G.AutoDeathStep = value
end)

task.spawn(function()
    while task.wait() do
        if _G.AutoDeathStep then
            if LP.Backpack:FindFirstChild("Black Leg") or LP.Character:FindFirstChild("Black Leg") or LP.Backpack:FindFirstChild("Death Step") or LP.Character:FindFirstChild("Death Step") then
                if (LP.Backpack:FindFirstChild("Black Leg") or LP.Character:FindFirstChild("Black Leg")) and (LP.Backpack:FindFirstChild("Black Leg") or LP.Character:FindFirstChild("Black Leg")).Level.Value >= 450 then
                    RS.Remotes.CommF_:InvokeServer("BuyDeathStep")
                    _G.SelectWeapon = "Death Step"
                end  
                if LP.Backpack:FindFirstChild("Black Leg") and LP.Backpack["Black Leg"].Level.Value <= 449 then
                    _G.SelectWeapon = "Black Leg"
                end 
            else 
                RS.Remotes.CommF_:InvokeServer("BuyBlackLeg")
            end
        end
    end
end)

Farm:Toggle("Auto Sharkman Karate", false, function(value)
    _G.AutoSharkman = value
end)

task.spawn(function()
    while task.wait() do
        pcall(function()
            if _G.AutoSharkman then
                RS.Remotes.CommF_:InvokeServer("BuyFishmanKarate")
                if string.find(tostring(RS.Remotes.CommF_:InvokeServer("BuySharkmanKarate")), "keys") then  
                    if LP.Character:FindFirstChild("Water Key") or LP.Backpack:FindFirstChild("Water Key") then
                        topos(CFrame.new(-2604.6958, 239.432526, -10315.1982, 0.0425701365, 0, -0.999093413, 0, 1, 0, 0.999093413, 0, 0.0425701365))
                        RS.Remotes.CommF_:InvokeServer("BuySharkmanKarate")
                    elseif LP.Character:FindFirstChild("Fishman Karate") and LP.Character["Fishman Karate"].Level.Value >= 400 then
                    else 
                        local Ms = "Tide Keeper"
                        if workspace.Enemies:FindFirstChild(Ms) then   
                            for _, v in pairs(workspace.Enemies:GetChildren()) do
                                if v.Name == Ms then    
                                    local OldCFrameShark = v.HumanoidRootPart.CFrame
                                    repeat task.wait()
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        v.Head.CanCollide = false
                                        v.Humanoid.WalkSpeed = 0
                                        v.HumanoidRootPart.CanCollide = false
                                        v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                        v.HumanoidRootPart.CFrame = OldCFrameShark
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                                        VirtualUser:CaptureController()
                                        VirtualUser:Button1Down(Vector2.new(1280, 670))
                                    until not v.Parent or v.Humanoid.Health <= 0 or _G.AutoSharkman == false or LP.Character:FindFirstChild("Water Key") or LP.Backpack:FindFirstChild("Water Key")
                                end
                            end
                        else
                            topos(CFrame.new(-3570.18652, 123.328949, -11555.9072, 0.465199202, -1.3857326e-08, 0.885206044, 4.0332897e-09, 1, 1.35347511e-08, -0.885206044, -2.72606271e-09, 0.465199202))
                            task.wait(3)
                        end
                    end
                else 
                    RS.Remotes.CommF_:InvokeServer("BuySharkmanKarate")
                end
            end
        end)
    end
end)

Farm:Toggle("Auto Electric Claw", false, function(value)
    _G.AutoElectricClaw = value
    StopTween(_G.AutoElectricClaw)
end)

task.spawn(function()
    while task.wait() do 
        pcall(function()
            if _G.AutoElectricClaw then
                if LP.Backpack:FindFirstChild("Electro") or LP.Character:FindFirstChild("Electro") or LP.Backpack:FindFirstChild("Electric Claw") or LP.Character:FindFirstChild("Electric Claw") then
                    if (LP.Backpack:FindFirstChild("Electro") or LP.Character:FindFirstChild("Electro")) and (LP.Backpack:FindFirstChild("Electro") or LP.Character:FindFirstChild("Electro")).Level.Value >= 400 then
                        RS.Remotes.CommF_:InvokeServer("BuyElectricClaw")
                        _G.SelectWeapon = "Electric Claw"
                    end  
                    if LP.Backpack:FindFirstChild("Electro") and LP.Backpack["Electro"].Level.Value <= 399 then
                        _G.SelectWeapon = "Electro"
                    end 
                else
                    RS.Remotes.CommF_:InvokeServer("BuyElectro")
                end

                if (LP.Backpack:FindFirstChild("Electro") or LP.Character:FindFirstChild("Electro")) and ((LP.Backpack:FindFirstChild("Electro") and LP.Backpack["Electro"].Level.Value >= 400) or (LP.Character:FindFirstChild("Electro") and LP.Character["Electro"].Level.Value >= 400)) then
                    if _G.AutoFarm == false then
                        repeat task.wait()
                            topos(CFrame.new(-10371.4717, 330.764496, -10131.4199))
                        until not _G.AutoElectricClaw or (LP.Character.HumanoidRootPart.Position - Vector3.new(-10371.4717, 330.764496, -10131.4199)).Magnitude <= 10
                        RS.Remotes.CommF_:InvokeServer("BuyElectricClaw", "Start")
                        task.wait(2)
                        repeat task.wait()
                            topos(CFrame.new(-12550.532226563, 336.22631835938, -7510.4233398438))
                        until not _G.AutoElectricClaw or (LP.Character.HumanoidRootPart.Position - Vector3.new(-12550.532226563, 336.22631835938, -7510.4233398438)).Magnitude <= 10
                        task.wait(1)
                        repeat task.wait()
                            topos(CFrame.new(-10371.4717, 330.764496, -10131.4199))
                        until not _G.AutoElectricClaw or (LP.Character.HumanoidRootPart.Position - Vector3.new(-10371.4717, 330.764496, -10131.4199)).Magnitude <= 10
                        task.wait(1)
                        RS.Remotes.CommF_:InvokeServer("BuyElectricClaw")
                    end
                end
            end
        end)
    end
end)

Farm:Toggle("Auto Dragon Talon", false, function(value)
    _G.AutoDragonTalon = value
end)

task.spawn(function()
    while task.wait() do
        if _G.AutoDragonTalon then
            if LP.Backpack:FindFirstChild("Dragon Claw") or LP.Character:FindFirstChild("Dragon Claw") or LP.Backpack:FindFirstChild("Dragon Talon") or LP.Character:FindFirstChild("Dragon Talon") then
                if (LP.Backpack:FindFirstChild("Dragon Claw") or LP.Character:FindFirstChild("Dragon Claw")) and (LP.Backpack:FindFirstChild("Dragon Claw") or LP.Character:FindFirstChild("Dragon Claw")).Level.Value >= 400 then
                    RS.Remotes.CommF_:InvokeServer("BuyDragonTalon")
                    _G.SelectWeapon = "Dragon Talon"
                end  
                if LP.Backpack:FindFirstChild("Dragon Claw") and LP.Backpack["Dragon Claw"].Level.Value <= 399 then
                    _G.SelectWeapon = "Dragon Claw"
                end 
            else 
                RS.Remotes.CommF_:InvokeServer("BlackbeardReward", "DragonClaw", "2")
            end
        end
    end
end)

Farm:Toggle("Auto Godhuman", false, function(value)
    _G.Auto_God_Human = value
end)

task.spawn(function()
    while task.wait() do
        if _G.Auto_God_Human then
            pcall(function()
                if LP.Character:FindFirstChild("Superhuman") or LP.Backpack:FindFirstChild("Superhuman") or LP.Backpack:FindFirstChild("Black Leg") or LP.Character:FindFirstChild("Black Leg") or LP.Backpack:FindFirstChild("Death Step") or LP.Character:FindFirstChild("Death Step") or LP.Backpack:FindFirstChild("Fishman Karate") or LP.Character:FindFirstChild("Fishman Karate") or LP.Backpack:FindFirstChild("Sharkman Karate") or LP.Character:FindFirstChild("Sharkman Karate") or LP.Backpack:FindFirstChild("Electro") or LP.Character:FindFirstChild("Electro") or LP.Backpack:FindFirstChild("Electric Claw") or LP.Character:FindFirstChild("Electric Claw") or LP.Backpack:FindFirstChild("Dragon Claw") or LP.Character:FindFirstChild("Dragon Claw") or LP.Backpack:FindFirstChild("Dragon Talon") or LP.Character:FindFirstChild("Dragon Talon") or LP.Character:FindFirstChild("Godhuman") or LP.Backpack:FindFirstChild("Godhuman") then
                    
                    if RS.Remotes.CommF_:InvokeServer("BuySuperhuman", true) == 1 then
                        if (LP.Backpack:FindFirstChild("Superhuman") and LP.Backpack["Superhuman"].Level.Value >= 400) or (LP.Character:FindFirstChild("Superhuman") and LP.Character["Superhuman"].Level.Value >= 400) then
                            RS.Remotes.CommF_:InvokeServer("BuyDeathStep")
                        end
                    else
                        game.StarterGui:SetCore("SendNotification", { Title = "Notification", Text = "Not Have Superhuman", Icon = "rbxassetid://18899804355", Duration = 2.5 })
                    end

                    if RS.Remotes.CommF_:InvokeServer("BuyDeathStep", true) == 1 then
                        if (LP.Backpack:FindFirstChild("Death Step") and LP.Backpack["Death Step"].Level.Value >= 400) or (LP.Character:FindFirstChild("Death Step") and LP.Character["Death Step"].Level.Value >= 400) then
                            RS.Remotes.CommF_:InvokeServer("BuySharkmanKarate")
                        end
                    else
                        game.StarterGui:SetCore("SendNotification", { Title = "Notification", Text = "Not Have Death Step", Icon = "rbxassetid://18899804355", Duration = 2.5 })
                    end

                    if RS.Remotes.CommF_:InvokeServer("BuySharkmanKarate", true) == 1 then
                        if (LP.Backpack:FindFirstChild("Sharkman Karate") and LP.Backpack["Sharkman Karate"].Level.Value >= 400) or (LP.Character:FindFirstChild("Sharkman Karate") and LP.Character["Sharkman Karate"].Level.Value >= 400) then
                            RS.Remotes.CommF_:InvokeServer("BuyElectricClaw")
                        end
                    else
                        game.StarterGui:SetCore("SendNotification", { Title = "Notification", Text = "Not Have SharkMan Karate", Icon = "rbxassetid://18899804355", Duration = 2.5 })
                    end

                    if RS.Remotes.CommF_:InvokeServer("BuyElectricClaw", true) == 1 then
                        if (LP.Backpack:FindFirstChild("Electric Claw") and LP.Backpack["Electric Claw"].Level.Value >= 400) or (LP.Character:FindFirstChild("Electric Claw") and LP.Character["Electric Claw"].Level.Value >= 400) then
                            RS.Remotes.CommF_:InvokeServer("BuyDragonTalon")
                        end
                    else
                        game.StarterGui:SetCore("SendNotification", { Title = "Notification", Text = "Not Have Electric Claw", Icon = "rbxassetid://18899804355", Duration = 2.5 })
                    end

                    if RS.Remotes.CommF_:InvokeServer("BuyDragonTalon", true) == 1 then
                        if (LP.Backpack:FindFirstChild("Dragon Talon") and LP.Backpack["Dragon Talon"].Level.Value >= 400) or (LP.Character:FindFirstChild("Dragon Talon") and LP.Character["Dragon Talon"].Level.Value >= 400) then
                            RS.Remotes.CommF_:InvokeServer("BuyGodhuman")
                        end
                    else
                        game.StarterGui:SetCore("SendNotification", { Title = "Notification", Text = "Not Have Dragon Talon", Icon = "rbxassetid://18899804355", Duration = 2.5 })
                    end

                end
            end)
        end
    end
end)
