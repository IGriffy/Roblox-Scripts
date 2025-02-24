if _G.FlingEnabledBind == nil then print("Bind 'FlingEnabledBind' not founded") return end
if _G.ChangePlayerBind == nil then print("Bind 'ChangePlayerBind' not founded") return end
if getgenv().SkibidiOhioScript then print("SkibidiOhioScript alredy executed!") return end

local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local RootPart = Character:FindFirstChild("HumanoidRootPart")
local Humanoid = Character:FindFirstChild("Humanoid")

local Mouse = Player:GetMouse()
local Camera = workspace.CurrentCamera

getgenv().TargetName = nil
getgenv().FlingEnabled = false

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = CoreGui
local TextLabel = Instance.new("TextLabel")
TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel.Position = UDim2.new(0.8, 0, 0.9, 0)
TextLabel.Size = UDim2.new(0.125, 0, 0.1, 0)
TextLabel.BackgroundTransparency = 1
TextLabel.TextColor3 = Color3.fromRGB(85, 255, 127)
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.TextStrokeTransparency = 0
TextLabel.TextSize = 20
TextLabel.Text = ""
TextLabel.Parent = ScreenGui

local function GetRoot(Char)
	local RootPart = Char:FindFirstChild('HumanoidRootPart') or Char:FindFirstChild('Torso') or Char:FindFirstChild('UpperTorso')
	return RootPart
end

local function ReturnTargetCharacter(TargetPlayerN)
    local Target_Player = Players:FindFirstChild(TargetPlayerN.Name)
    local Target_Character = Target_Player.Character or Target_Player.CharacterAdded:Wait()
    local Target_RootPart = Target_Character:FindFirstChild("HumanoidRootPart")
    local Target_Humanoid = Target_Character:FindFirstChild("Humanoid")

    Target_Player.CharacterAdded:Connect(function(NewTargetCharacter)
        Target_Character = NewTargetCharacter
        Target_RootPart = Target_Character:WaitForChild("HumanoidRootPart")
        Target_Humanoid = Target_Character:WaitForChild("HumanoidRootPart")
    end)

    return Target_Player, Target_Character, Target_RootPart, Target_Humanoid
end

local function GetClosestPlayerToCursor()
    local ClosestDistance = math.huge
    local ClosestPlayer = nil
    
    for _, OtherPlayer in pairs(Players:GetPlayers()) do
        if OtherPlayer ~= Player and OtherPlayer.Character then
            local Character = OtherPlayer.Character
            local TRootPart = Character:FindFirstChild("HumanoidRootPart")
            local THumanoid = Character:FindFirstChild("Humanoid")
            
            if TRootPart and THumanoid and THumanoid.Health > 0 then
                local ScreenPoint, OnScreen = Camera:WorldToScreenPoint(TRootPart.Position)
                if OnScreen then
                    local CursorPosition = Vector2.new(Mouse.X, Mouse.Y)
                    local PlayerPosition = Vector2.new(ScreenPoint.X, ScreenPoint.Y)
                    local Distance = (CursorPosition - PlayerPosition).Magnitude

                    if Distance < ClosestDistance then
                        ClosestDistance = Distance
                        ClosestPlayer = OtherPlayer.Character
                    end
                end
            end
        end
    end
    return ClosestPlayer
end

local function ReturnRandomNum(num1, num2)
    local a = math.random(0,1)
    return a==0 and num1 or a==1 and num2
end

UIS.InputEnded:Connect(function(Input, GameProcessed)
    if GameProcessed then return end
    if Input.KeyCode == _G.FlingEnabledBind then
        getgenv().FlingEnabled = not getgenv().FlingEnabled
        TextLabel.Text = "\nEnabled: "..tostring(FlingEnabled).."\nTarget: "..tostring(TargetName)or"None"
    elseif Input.KeyCode == _G.ChangePlayerBind then
        getgenv().TargetName = GetClosestPlayerToCursor()
        TextLabel.Text = "\nEnabled: "..tostring(FlingEnabled).."\nTarget: "..tostring(TargetName)or"None"
    end
end)

Player.CharacterAdded:Connect(function(NewCharacter)
    Character = NewCharacter
    RootPart = Character:WaitForChild("HumanoidRootPart")
    Humanoid = Character:WaitForChild("Humanoid")
end)

game:GetService("RunService").Stepped:Connect(function()
    if getgenv().FlingEnabled and TargetName then
        local TPlr, TChar, TRP, TH = ReturnTargetCharacter(TargetName)
        local Root = GetRoot(Player.Character)
        if TRP and TRP.CFrame and Root and TH then
            Root.CFrame = CFrame.new(TRP.CFrame.Position + Vector3.new(ReturnRandomNum(-3,3), 0, ReturnRandomNum(-3,3)))*RootPart.CFrame.Rotation
            Root.CFrame = CFrame.lookAt(RootPart.Position, TRP.Position)
            Camera.CameraSubject = TH
        end
    else
        Camera.CameraSubject = Humanoid
    end
end)

queue_on_teleport('_G.FlingEnabledBind = Enum.KeyCode.X _G.ChangePlayerBind = Enum.KeyCode.C loadstring(game:HttpGet("https://raw.githubusercontent.com/IGriffy/Roblox-Scripts/refs/heads/main/SkibidiOhioScript.lua"))()')

getgenv().SkibidiOhioScript = true
