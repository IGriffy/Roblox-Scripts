if ScriptExecuted then print("AimBot already executed") return end

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
local PlayerGui = Player.PlayerGui
local Character = Player.Character or Player.CharacterAdded:Wait()
local RootPart = Character:FindFirstChild("HumanoidRootPart")

local Mouse = Player:GetMouse()
local Camera = workspace.CurrentCamera

-------------------- Function's ---------------------

local function SwitchScriptEnabled()
    getgenv().ScriptEnabled = not getgenv().ScriptEnabled
end

local function OnMouseButton1Down()
    if not getgenv().AimEnabled then
        getgenv().AimEnabled = true
    end
end

local function OnMouseButton1Up()
    if getgenv().AimEnabled then
        getgenv().AimEnabled = false
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

local function CheckWhiteList(Plr)
    for _, name in ipairs(_G.WhiteList) do
        if name == Plr.Name then
            return true
        end
    end
    return false
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

------------------- Connection's --------------------

local CenterX, CenterY = ReturnCurrentCenter()

getgenv().Circle = Drawing.new("Circle")
Circle.Position = Vector2.new(CenterX, CenterY)
Circle.Transparency = 1
Circle.Thickness = 2
Circle.Radius = _G.CircleRadius
Circle.Color = Color3.fromRGB(255, 100, 255)
Circle.Visible = true

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

Mouse.Button1Down:Connect(OnMouseButton1Down)
Mouse.Button1Up:Connect(OnMouseButton1Up)

UIS.InputBegan:Connect(function(Input, gameProcessed)
    if not gameProcessed and Input.KeyCode == Enum.KeyCode.X then
        OnKeyUp()
    end
end)

UIS.InputEnded:Connect(function(Input, gameProcessed)
    if not gameProcessed and Input.KeyCode == _G.BindAimEnabled then
        SwitchScriptEnabled()
    end
    if not gameProcessed and Input.KeyCode == Enum.KeyCode.X then
        OnKeyDown()
    end
end)

getgenv().ScriptExecuted = true
