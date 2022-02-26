-- soon to be rewriten



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
        FOVColor = Color3.fromRGB(255,255,255)
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

local FOV = Drawing.new("Circle")
FOV.Color = Settings.Aimbot.FOVColor
FOV.Thickness = 1
FOV.Filled = false
FOV.Radius = Settings.Aimbot.FOVRadius
FOV.Transparency = 1
FOV.Visible = Settings.Aimbot.FOVUsed
FOV.NumSides = 1000

local Main = loadstring(game:HttpGet("https://raw.githubusercontent.com/RealZzHub/Main/main/UILibV2.lua", true))():Main("Universal")

MainTab = Main:NewTab("Main")

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
MainTab:NewDropdown("Aim Part", {"Head", "Torso/UpperTorso"}, function(v)
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

Main:NewConfigTab()

-- Aimbot --
function GetPart(v)
    if Settings.Aimbot.AimbotPart == "Torso/UpperTorso" then
        return tostring(v:FindFirstChild("Torso") or v:FindFirstChild("UpperTorso"))
    end
    return "Head"
end

function IsVisible(Pos, List)
    return #zzCamera:GetPartsObscuringTarget({zzLPlayer.Character.Head.Position, Pos}, List) == 0 and true or false
end

function getTarget()
    local Mag = math.huge
    local plr = nil
    for i, v in pairs(zzPlayers:GetPlayers()) do 
        if v ~= zzLPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then 
            if not Settings.Aimbot.TeamCheck or Settings.Aimbot.TeamCheck and v.Team ~= zzLPlayer.Team then
                local Pos, onScreen = zzCamera:WorldToScreenPoint(v.Character[GetPart(v.Character)].Position) 
                if onScreen then
                    local Dist = (Vector2.new(zzMouse.X, zzMouse.Y) - Vector2.new(Pos.X, Pos.Y)).Magnitude 
                    if not Settings.Aimbot.FOVUsed and Dist < Mag or Settings.Aimbot.FOVUsed and Dist < Mag and Dist < Settings.Aimbot.FOVRadius then
                        if not Settings.Aimbot.VisibleCheck and true or Settings.Aimbot.VisibleCheck and IsVisible(v.Character[GetPart(v.Character)].Position, {v.Character, zzLPlayer.Character, zzCamera}) then 
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

local Aiming = false

local AimPlayer = getTarget()
zzRunService.RenderStepped:Connect(function()
    local MousePos = zzUIS:GetMouseLocation()
    FOV.Position = Vector2.new(MousePos.X, MousePos.Y)
    
    AimPlayer = getTarget()
    if Aiming and Settings.Aimbot.AimbotUsed then
        if AimPlayer then
            local Pos = zzCamera:WorldToViewportPoint(AimPlayer.Character[GetPart(AimPlayer.Character)].Position)
            mousemoverel((Pos.X - MousePos.X) / Settings.Aimbot.SmoothnessX, (Pos.Y - MousePos.Y) / Settings.Aimbot.SmoothnessY)
        end
    end
end)

zzUIS.InputEnded:Connect(function(v)
    if v.KeyCode == Settings.Aimbot.AimbotKey or v.UserInputType == Settings.Aimbot.AimbotKey then
        Aiming = false
    end
end)

zzUIS.InputBegan:Connect(function(v)
    if v.KeyCode == Settings.Aimbot.AimbotKey or v.UserInputType == Settings.Aimbot.AimbotKey then
        Aiming = true
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
        if plr.Character ~= nil and plr.Character:FindFirstChild("HumanoidRootPart") and zzLPlayer ~= plr and plr then
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
            if Settings.Aimbot.AimbotUsed and plr == AimPlayer then
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
