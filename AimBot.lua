----------------------- Setup -----------------------

local function Setup()
    local Setup = '---------------------- Binds -----------------------\n--[[\n    Bind settings\n    To bind a function to your own key, specify the desired key after "Enum.KeyCode." For example:\n\n    * Enum.KeyCode.LeftControl\n    * Enum.KeyCode.RightAlt\n    * Enum.KeyCode.B\n    and so on.\n]]--\n\n_G.BindAimHoldEnabled = Enum.KeyCode.X -- Key to hold for aiming\n_G.BindAimEnabled = Enum.KeyCode.Z     -- Key to toggle aiming\n\n---------------------- Other -----------------------\n\n_G.WhiteList = {"piska_bobrafsko", "KingOvCursed", "Crankbread8743", "Luffy_77787"} -- Players on whom AimBot will not work. To add a player, enter their original nickname in quotes, separated by commas.\n_G.TargetPart = "Head" -- The body part AimBot will target. Available options: "Head", "Torso", or "Random" (random selection).\n_G.CircleRadius = 100 -- The radius of the aiming circle.\n_G.TeamCheck = true -- If true, AimBot will not target teammates. If false, it will target teammates.\n\nloadstring(game:HttpGet("https://raw.githubusercontent.com/IGriffy/Roblox-Scripts/refs/heads/main/AimBot.lua"))()'

    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = "Notification";
        Text = "Script Config Copied !";
        Duration = 10;
    })
    
    setclipboard(Setup)
end

----------------------- Check's ---------------------

if getgenv().ScriptExecuted then print("AimBot already executed") return end
if _G.BindAimHoldEnabledBind == nil then Setup(); print("Bind 'BindAimHoldEnabledBind' not founded") return end
if _G.BindAimEnabled == nil then Setup(); print("Bind 'BindAimEnabled' not founded") return end
if _G.CircleRadius == nil then Setup(); print("Not founded 'CircleRadius'") return end
if _G.TargetPart == nil then Setup(); print("Not founded 'TargetPart'") return end
if _G.WhiteList == nil then Setup(); print("Not founded 'WhiteList'") return end
if _G.TeamCheck == nil then Setup(); print("not founded 'TeamCheck'") return end

---------------------- Config -----------------------

getgenv().ScriptEnabled = true
getgenv().AimEnabled = false
getgenv().LockedTarget = false

--------------------- Service's ---------------------

local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

----------------------- Var's -----------------------

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local RootPart = Character:FindFirstChild("HumanoidRootPart")

local Mouse = Player:GetMouse()
local Camera = workspace.CurrentCamera

-------------------- Function's ---------------------

local function CheckWhiteList(Plr)
    for _, name in ipairs(_G.WhiteList) do
        if name == Plr.Name then
            return true
        end
    end
    return false
end

local function GetClosestPlayerToCursor()
    local ClosestDistance = math.huge
    local ClosestPlayer = nil
    
    for _, OtherPlayer in pairs(Players:GetPlayers()) do
        if OtherPlayer ~= Player and OtherPlayer.Character and not CheckWhiteList(OtherPlayer) then
            local Character = OtherPlayer.Character
            local RootPart = Character:FindFirstChild("HumanoidRootPart")
            local Humanoid = Character:FindFirstChild("Humanoid")

            if RootPart and Humanoid and Humanoid.Health > 0 then
                local ScreenPoint, OnScreen = Camera:WorldToScreenPoint(RootPart.Position)
                if OnScreen then
                    local Distance = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude
                    if Distance <= _G.CircleRadius and Distance < ClosestDistance then
                        ClosestDistance = Distance
                        ClosestPlayer = Character
                    end
                end
            end
        end
    end
    return ClosestPlayer
end

local function ReturnTargetPart()
    if _G.TargetPart == "Random" then
        return math.random(0, 1) == 0 and "Head" or "Torso"
    else
        return _G.TargetPart
    end
end

local function AimAt(Target)
    if Target.Parent:FindFirstChild("Humanoid") and Target.Parent.Humanoid.Health ~= 0 then
        local Direction = (Target.Position - Camera.CFrame.Position).Unit
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + Direction)
    end
end

local function ReturnCurrentCenter()
    local ViewportSize = Camera.ViewportSize
    return ViewportSize.X / 2, ViewportSize.Y / 2
end

local function OnMouseButton1Up()
    if getgenv().AimEnabled then
        getgenv().AimEnabled = false
    end
end

local function OnMouseButton1Down()
    if not getgenv().AimEnabled then
        getgenv().AimEnabled = true
    end
end

local function OnKeyUp()
    if not getgenv().AimEnabled then
        getgenv().AimEnabled = true
    end
end

local function OnKeyDown()
    if getgenv().AimEnabled then
        getgenv().AimEnabled = false
    end
end

local function SwitchScriptEnabled()
    getgenv().ScriptEnabled = not getgenv().ScriptEnabled
end

---------------------- Other -----------------------

local CenterX, CenterY = ReturnCurrentCenter()

getgenv().Circle = Drawing.new("Circle")
Circle.Position = Vector2.new(CenterX, CenterY)
Circle.Transparency = 1
Circle.Thickness = 2
Circle.Radius = _G.CircleRadius
Circle.Color = Color3.fromRGB(255, 100, 255)
Circle.Visible = true

task.spawn(function()
    while true do
        local CenterX, CenterY = ReturnCurrentCenter()
        Circle:Remove()
        getgenv().Circle = Drawing.new("Circle")
        Circle.Position = Vector2.new(CenterX, CenterY)
        Circle.Transparency = 1
        Circle.Thickness = 2
        Circle.Radius = _G.CircleRadius
        Circle.Color = Color3.fromRGB(255, 100, 255)
        Circle.Visible = true
        task.wait(5)
    end
end)

------------------- Connection's --------------------

Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
    local CenterX, CenterY = ReturnCurrentCenter()
    Circle:Remove()
    getgenv().Circle = Drawing.new("Circle")
    Circle.Position = Vector2.new(CenterX, CenterY)
    Circle.Transparency = 1
    Circle.Thickness = 2
    Circle.Radius = _G.CircleRadius
    Circle.Color = Color3.fromRGB(255, 100, 255)
    Circle.Visible = true
end)

RunService.RenderStepped:Connect(function()
    if getgenv().ScriptEnabled and getgenv().AimEnabled then
        local TargetPlr = GetClosestPlayerToCursor()
        if TargetPlr then
            local TargetTeam = Players:GetPlayerFromCharacter(TargetPlr).Team
            if not _G.TeamCheck or (Player.Team ~= TargetTeam) then
                AimAt(TargetPlr:FindFirstChild(ReturnTargetPart()))
            end
        end
    end
end)

UIS.InputEnded:Connect(function(Input, gameProcessed)
    if not gameProcessed and Input.KeyCode == _G.BindAimEnabled then
        SwitchScriptEnabled()
    end
    if not gameProcessed and Input.KeyCode == _G.BindAimHoldEnabledBind then
        OnKeyDown()
    end
end)

UIS.InputBegan:Connect(function(Input, gameProcessed)
    if not gameProcessed and Input.KeyCode == _G.BindAimHoldEnabledBind then
        OnKeyUp()
    end
end)

Mouse.Button1Down:Connect(OnMouseButton1Down)
Mouse.Button1Up:Connect(OnMouseButton1Up)

---------------------- Other -----------------------

getgenv().ScriptExecuted = true
