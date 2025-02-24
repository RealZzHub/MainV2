repeat task.wait() until game:IsLoaded()

-- Settings --
local Settings = {
    Visuals = {
        Esp = false,
        Distance = false,
        Name = false,
        TeamCheck = false,
        Tracer = false,
        FromTracer = "Center"
       },
    Aimbot = {
        AimbotKey = Enum.KeyCode.F,
        AimbotUsed = false,
        FOVRadius = 150,
        SmoothnessX = 1,
        SmoothnessY = 1,
        TeamCheck = false,
        VisibleCheck = false,
        FOVUsed = false,
        AimbotPart = "Head",
        FOVColor = Color3.fromRGB(255,255,255),
        SilentAim = false,
        Wallbang = false,
        HitChance = 100,
        Parts = {"Head", "UpperTorso", "Random"},
    },
    Gun = {
        UnlockAll = false,
        NoFirerate = false,
        AlwaysAuto = false,
        NoDrop = false
    },
    LPlayer = {
        WalkSpeed = 25,
        WalkSpeedUsed = false,
        JumpPower = 25,
        JumpPowerUsed = false,
        InfJump = false,
    }
}


-- Services --
local zzWorkspace = game:GetService("Workspace")
local zzRunService = game:GetService("RunService")
local zzUIS = game:GetService("UserInputService")
local zzPlayers = game:GetService("Players")
local zzCamera = zzWorkspace.CurrentCamera
local zzLPlayer = zzPlayers.LocalPlayer
local zzMouse = zzLPlayer:GetMouse()
local senv = getsenv(zzLPlayer.PlayerScripts.Scripts.Game["First Person Controller"])
local FrameworkLibrary = require(game:GetService("ReplicatedStorage").Framework.Library)
local Network = FrameworkLibrary.Network
local GunCmds = FrameworkLibrary.GunCmds

local FOV = Drawing.new("Circle")
FOV.Color = Settings.Aimbot.FOVColor
FOV.Thickness = 1
FOV.Filled = false
FOV.Radius = Settings.Aimbot.FOVRadius
FOV.Transparency = 1
FOV.Visible = Settings.Aimbot.FOVUsed
FOV.NumSides = 1000

local OldSettings = {}
function RefreshGUNS()
    for _, v in pairs(getgc(true)) do
    	if typeof(v) == "table" and rawget(v, "shotrate") then
            setreadonly(v, false)
    	    if not OldSettings[v] then
        		OldSettings[v] = {
        		    SHOTRATE = v.shotrate,
        		    AUTOMATIC = v.automatic,
        		    VELOCITY = v.velocity   
        		}
        	end
        	if OldSettings[v] then
        	    if Settings.Gun.NoFirerate then
                    if OldSettings[v].SHOTRATE > 0.0225 then
                        v.shotrate = 0.0225
                    else
                        v.shotrate = OldSettings[v].SHOTRATE
                    end
                else
                    v.shotrate = OldSettings[v].SHOTRATE
                end
                if Settings.Gun.AlwaysAuto then
                    v.automatic = true
                else
                    v.automatic = OldSettings[v].AUTOMATIC
                end
                if Settings.Gun.NoDrop then
                    v.velocity = 999
                else
                    v.velocity = OldSettings[v].VELOCITY
                end
        	end
    	end
    end
end
RefreshGUNS()

local Main = loadstring(game:HttpGet("https://raw.githubusercontent.com/RealZzHub/Main/main/UILibV2.lua", true))():Main("BIG Paintball")

MainTab = Main:NewTab("Main")
MainTab:NewToggle("Silent Aim", function(state)
    Settings.Aimbot.SilentAim = state
end)
MainTab:NewSlider("Silent Aim Hit Chance", 2,100,1, function(v)
    Settings.Aimbot.HitChance = v
end,100)
MainTab:NewToggle("Wallbang", function(state)
    Settings.Aimbot.Wallbang = state
end)
MainTab:NewToggle("Aimbot", function(state)
    Settings.Aimbot.AimbotUsed = state
end)
MainTab:NewKeybind("Aimbot Key", Settings.Aimbot.AimbotKey, function(key)
    Settings.Aimbot.AimbotKey = key
end)
MainTab:NewToggle("Team Check", function(state)
    Settings.Aimbot.TeamCheck = state
end)
MainTab:NewSlider("Smoothness X", 1, 20, 0.1, function(v)
    Settings.Aimbot.SmoothnessX = v
end,1)
MainTab:NewSlider("Smoothness Y", 1, 20, 0.1, function(v)
    Settings.Aimbot.SmoothnessY = v 
end,1)
MainTab:NewDropdown("Aim Part", Settings.Aimbot.Parts, function(v)
    Settings.Aimbot.AimbotPart = v
end,true)
MainTab:NewToggle("Use FOV", function(state)
    Settings.Aimbot.FOVUsed = state
    FOV.Visible = state
end)
MainTab:NewSlider("FOV Radius", 1,1000,1, function(v)
    Settings.Aimbot.FOVRadius = v
    FOV.Radius = v
end, Settings.Aimbot.FOVRadius)
MainTab:NewLabel("https://realzzhub.xyz")

VisualsTab = Main:NewTab("Visuals")
VisualsTab:NewToggle("Box ESP", function(state)
    Settings.Visuals.Esp = state
end)
VisualsTab:NewToggle("Name ESP", function(state)
    Settings.Visuals.Name = state
end)
VisualsTab:NewToggle("Distance ESP", function(state)
    Settings.Visuals.Distance = state
end)
VisualsTab:NewToggle("Tracer ESP", function(state)
    Settings.Visuals.Tracer = state
end)
VisualsTab:NewDropdown("Tracer Origin", {"Top", "Center", "Bottom", "Mouse"}, function(v)
    Settings.Visuals.FromTracer = v
end,true)
VisualsTab:NewToggle("Team Check", function(state)
    Settings.Visuals.TeamCheck = state
end)

GunsTab = Main:NewTab("Guns")
GunsTab:NewButton("Unlock All Guns", function()
    Settings.Gun.UnlockAll = true
    for _, v in pairs(FrameworkLibrary.Directory.Guns) do
        v["offsale"] = false
    end
end)
GunsTab:NewToggle("No Firerate", function(state)
    Settings.Gun.NoFirerate = state
    RefreshGUNS()
end)
GunsTab:NewToggle("Always Auto", function(state)
    Settings.Gun.AlwaysAuto = state
    RefreshGUNS()
end)
GunsTab:NewToggle("No Bullet Drop", function(state)
    Settings.Gun.NoDrop = state
    RefreshGUNS()
end)

LPlayerTab = Main:NewTab("LocalPlayer")
LPlayerTab:NewToggle("Use Walkspeed", function(t)
    Settings.LPlayer.WalkSpeedUsed = t
    if t == true and zzLPlayer.Character and zzLPlayer.Character:FindFirstChildOfClass("Humanoid") then
        zzLPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = Settings.LPlayer.WalkSpeed
    end
end,false)
LPlayerTab:NewSlider("Walkspeed", 1,500,1, function(t)
    Settings.LPlayer.WalkSpeed = t
    if Settings.LPlayer.WalkSpeedUsed == true and zzLPlayer.Character and zzLPlayer.Character:FindFirstChildOfClass("Humanoid") then
        zzLPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = t
    end
end,25)
LPlayerTab:NewToggle("Use Jumppower", function(t)
    Settings.LPlayer.JumpPowerUsed = t
    if t == true and zzLPlayer.Character and zzLPlayer.Character:FindFirstChildOfClass("Humanoid") then
        zzLPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = Settings.LPlayer.JumpPower
    end
end,false)
LPlayerTab:NewSlider("Jumppower", 1,300,1, function(t)
    Settings.LPlayer.JumpPower = t
    if Settings.toggles.JumpPowerUsed == true and zzLPlayer.Character and zzLPlayer.Character:FindFirstChildOfClass("Humanoid") then
        zzLPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = t
    end
end,25)

Main:NewConfigTab()

-- Aimbot --
function GetPart()
    if Settings.Aimbot.AimbotPart == "Random" then
        return Settings.Aimbot.Parts[math.random(1,#Settings.Aimbot.Parts - 1)]
    else
        return Settings.Aimbot.AimbotPart
    end
end

function IsVisible(Pos, List)
    return true --#zzCamera:GetPartsObscuringTarget({zzLPlayer.Character.Head.Position, Pos}, List) == 0 and true or false
end

local Aiming = false

function getTarget()
    local Mag = math.huge
    local plr
    for i, v in pairs(zzPlayers.GetPlayers(zzPlayers)) do 
        if v ~= zzLPlayer and v.Character and v.Character.FindFirstChild(v.Character, "HumanoidRootPart") and v.Character.FindFirstChild(v.Character, "Head") and v.Character.FindFirstChild(v.Character, "UpperTorso") then 
            if not Settings.Aimbot.TeamCheck or Settings.Aimbot.TeamCheck and v.Team ~= zzLPlayer.Team then
                local Pos, onScreen = zzCamera.WorldToScreenPoint(zzCamera, v.Character[GetPart()].Position) 
                if onScreen then
                    local Dist = (Vector2.new(zzMouse.X, zzMouse.Y) - Vector2.new(Pos.X, Pos.Y)).Magnitude 
                    if not Settings.Aimbot.FOVUsed and Dist < Mag or Settings.Aimbot.FOVUsed and Dist < Mag and Dist < Settings.Aimbot.FOVRadius then
                        if not Settings.Aimbot.VisibleCheck and true or Settings.Aimbot.VisibleCheck and IsVisible(v) then 
                            Mag = Dist
                            plr = v
                        end
                    end
                end
            end
        end
    end
    return plr 
end

local AimPlayer = getTarget()
zzRunService.RenderStepped:Connect(function()
    local MousePos = zzUIS:GetMouseLocation()
    FOV.Position = Vector2.new(MousePos.X, MousePos.Y)
    if Aiming and Settings.Aimbot.AimbotUsed and AimPlayer ~= nil then
        local Pos = zzCamera:WorldToViewportPoint(AimPlayer.Character[GetPart(AimPlayer.Character)].Position)
        mousemoverel((Pos.X - MousePos.X) / Settings.Aimbot.SmoothnessX, (Pos.Y - MousePos.Y) / Settings.Aimbot.SmoothnessY)
    end
end)

zzUIS.InputEnded:Connect(function(v)
    if v.KeyCode == Settings.Aimbot.AimbotKey or v.UserInputType == Settings.Aimbot.AimbotKey then
        Aiming = false
        AimPlayer = nil
    end
end)

zzUIS.InputBegan:Connect(function(v)
    if v.KeyCode == Settings.Aimbot.AimbotKey or v.UserInputType == Settings.Aimbot.AimbotKey then
        Aiming = true
        AimPlayer = getTarget()
    elseif v.KeyCode == Enum.KeyCode.Space and Settings.LPlayer.InfJump and zzLPlayer.Character and zzLPlayer.Character:FindFirstChildOfClass("Humanoid") then
        zzLPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(3)
    end
end)


-- ESP --
function StartESP(plr) 

    local BoxOutline = Drawing.new("Square")
    BoxOutline.Visible = false
    BoxOutline.Color = Color3.new(0,0,0)
    BoxOutline.Thickness = 4
    BoxOutline.Transparency = 1
    BoxOutline.Filled = false

    local Box = Drawing.new("Square")
    Box.Visible = false
    Box.Color = Color3.new(1,1,1)
    Box.Thickness = 1.5
    Box.Transparency = 1
    Box.Filled = false

    local Name = Drawing.new("Text")
    Name.Visible = false
    Name.Size = 17
    Name.Color = Color3.new(1,1,1)
    Name.Center = true
    Name.Outline = true

    local Dist = Drawing.new("Text")
    Dist.Visible = false
    Dist.Size = 17
    Dist.Color = Color3.new(1,1,1)
    Dist.Center = true
    Dist.Outline = true

    local Tracer = Drawing.new("Line")
    Tracer.Visible = false
    Tracer.Color = Color3.new(1,1,1)
    Tracer.Thickness = 2
    Tracer.Transparency = 1

    local Run
    Run = zzRunService.RenderStepped:Connect(function()
        if plr.Character ~= nil and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Head") and zzLPlayer ~= plr and plr then
            if Settings.Visuals.Distance or Settings.Visuals.Name or Settings.Visuals.Esp or Settings.Visuals.Tracer then
            local _, onScreen = zzCamera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)


           local HeadPos = zzCamera:WorldToViewportPoint(plr.Character.Head.Position + Vector3.new(0, 0.5, 0))
           local RootPos = zzCamera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
           local LegPos = zzCamera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position - Vector3.new(0,3,0))

            
           if onScreen then

            Box.Size = Vector2.new(2400 / RootPos.Z, HeadPos.Y - LegPos.Y)
            Box.Position = Vector2.new(RootPos.X - Box.Size.X / 2, RootPos.Y - Box.Size.Y / 2)

            BoxOutline.Size = Vector2.new(2400 / RootPos.Z, HeadPos.Y - LegPos.Y)
            BoxOutline.Position = Vector2.new(RootPos.X - Box.Size.X / 2, RootPos.Y - Box.Size.Y / 2)

            if Settings.Visuals.Name then
                Name.Position = Vector2.new(RootPos.X, (RootPos.Y + Box.Size.Y / 2) - 25)
                Name.Text = plr.Name
            end
            
            if Settings.Visuals.Distance then
                Dist.Position = Vector2.new(RootPos.X, (RootPos.Y - Box.Size.Y / 2) + 25)
                Dist.Text = "["..tostring(math.floor((plr.Character.HumanoidRootPart.Position - zzCamera.CFrame.Position).Magnitude)).." Studs]"
            end

            if Settings.Visuals.Tracer then
                if Settings.Visuals.FromTracer == "Center" then
                Tracer.From = Vector2.new(zzCamera.ViewportSize.X / 2, zzCamera.ViewportSize.Y / 2)
                elseif Settings.Visuals.FromTracer == "Top" then
                    Tracer.From = Vector2.new(zzCamera.ViewportSize.X / 2, 0)
                elseif Settings.Visuals.FromTracer == "Bottom" then
                    Tracer.From = Vector2.new(zzCamera.ViewportSize.X / 2, zzCamera.ViewportSize.Y)
                elseif Settings.Visuals.FromTracer == "Mouse" then
                    Tracer.From = zzUIS:GetMouseLocation()
                end
                Tracer.To = Vector2.new(RootPos.X, RootPos.Y - BoxOutline.Size.Y / 2)
            end
            

            Dist.Color = plr.TeamColor.Color
            Name.Color = plr.TeamColor.Color
            Box.Color = plr.TeamColor.Color
            Tracer.Color = plr.TeamColor.Color
            if Settings.Aimbot.AimbotUsed and plr == getTarget() or Settings.Aimbot.SilentAim and plr == getTarget() then
                Dist.Color = Color3.new(1,1,1)
                Name.Color = Color3.new(1,1,1)
                Box.Color = Color3.new(1,1,1)
                Tracer.Color = Color3.new(1,1,1)
            end

            if Settings.Visuals.TeamCheck and plr.Team == zzLPlayer.Team then
                Box.Visible = false
                Name.Visible = false
                Dist.Visible = false
                BoxOutline.Visible = false
                Tracer.Visible = false
            else
                Dist.Visible = Settings.Visuals.Distance
                Name.Visible = Settings.Visuals.Name
                Box.Visible = Settings.Visuals.Esp
                BoxOutline.Visible = Settings.Visuals.Esp
                Tracer.Visible = Settings.Visuals.Tracer
            end


           else
            Box.Visible = false
            Name.Visible = false
            Dist.Visible = false
            BoxOutline.Visible = false
            Tracer.Visible = false
           end
        
        else
            Box.Visible = false
            Name.Visible = false
            Dist.Visible = false
            BoxOutline.Visible = false
            Tracer.Visible = false
        end

        else
            Box.Visible = false
            Name.Visible = false
            Dist.Visible = false
            BoxOutline.Visible = false
            Tracer.Visible = false
        end
    end)

    local Removing
    Removing = zzPlayers.PlayerRemoving:Connect(function(v)
        if v == plr then
            Removing:Disconnect()
            Run:Disconnect()
            Box:Remove()
            Name:Remove()
            Dist:Remove()
            BoxOutline:Remove()
            Tracer:Remove()
        end
    end)
end

for _,v in pairs(zzPlayers:GetPlayers()) do
    StartESP(v)
end

zzPlayers.PlayerAdded:Connect(function(v)
    StartESP(v)
end)

local oldnamecall
oldnamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
	local Args = {...}
    local Method = getnamecallmethod()
    local Caller = getcallingscript()
	if tostring(Method) == "FindPartOnRayWithWhitelist" and tostring(Caller) == "First Person Controller" then
        local HitChance = math.random(2,100)
        local old = Args[1]
        local part = GetPart()
        local plr = getTarget()
        if Settings.Aimbot.Wallbang then
            local NewWhitelist = {game.Workspace["__THINGS"]["Mini Sentries"], game.Workspace["__THINGS"]["Armored Sentries"], game.Workspace["__THINGS"]["Dark Matter Sentries"], game.Workspace["__THINGS"]["Sentries"], game.Workspace["__THINGS"]["Drones"]}
            for _,v in pairs(game.Players.GetPlayers(game.Players)) do
                if v ~= game.Players.LocalPlayer and v.Character then
                    table.insert(NewWhitelist, v.Character)
                end
            end
            Args[2] = NewWhitelist
        end
	    if HitChance < Settings.Aimbot.HitChance and Settings.Aimbot.SilentAim then
            if plr and plr.Character and plr.Character.FindFirstChild(plr.Character, part) then
    			Args[1] = Ray.new(old.Origin, (plr.Character[part].Position - old.Origin).Unit * 2500)
    		end
    	end
        return oldnamecall(self, unpack(Args))
    end
	return oldnamecall(self, ...)
end))

local oldnewindex
oldnewindex = hookmetamethod(game, "__newindex", newcclosure(function(Obj, Key, Value) 
    if tostring(Obj) == "Humanoid" and tostring(Key) == "WalkSpeed" and Settings.LPlayer.WalkSpeedUsed then
        Value = Settings.LPlayer.WalkSpeed
    end
    if tostring(Obj) == "Humanoid" and tostring(Key) == "JumpPower" and Settings.LPlayer.JumpPowerUsed then
        Value = Settings.LPlayer.JumpPower
    end
	return oldnewindex(Obj, Key, Value)
end))

setreadonly(GunCmds, false)
local oldDoesOwnGun = GunCmds.DoesOwnGun
GunCmds.DoesOwnGun = newcclosure(function(...)
    if Settings.Gun.UnlockAll then
        return true
    end
    return oldDoesOwnGun(...)
end)

setreadonly(senv, false)
local oldDoesOwnGunSenv = senv.DoesOwnGun
senv.DoesOwnGun = newcclosure(function(...)
    if Settings.Gun.UnlockAll then
        return true
    end
    oldDoesOwnGunSenv(...)
end)

for _,v in pairs(getgc(true)) do
    if typeof(v) == "table" and rawget(v, "Fired") and string.find(debug.getinfo(v.Fired).source, "Network") then
        local func = debug.getupvalues(v.Fire)[1]
        hookfunction(func, newcclosure(function(...)
            return true
        end))
        
        setreadonly(v, false)
        local oldFire = v.Fire
        v.Fire = newcclosure(function(self, ...)
            local Args = {...}
            if Settings.Gun.UnlockAll and (tostring(self) == ".2" or tostring(self) == ".k") then
                Args[1] = "1"
                return oldFire(self, unpack(Args))
            end
            return oldFire(self, ...)
        end)
    end
end
