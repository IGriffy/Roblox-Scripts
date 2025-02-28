----------------------- Check -----------------------

if getgenv().SkibidiOhioScript then print("SkibidiOhioScript already executed!") return end
if _G.FlingEnabledBind == nil then print("Bind 'FlingEnabledBind' not founded") return end
if _G.ChangePlayerBind == nil then print("Bind 'ChangePlayerBind' not founded") return end
if game.PlaceId ~= 10449761463 then print("Script don't supported this place") return end

--------------------- Service's ---------------------

local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

----------------------- Var's -----------------------

local Map = workspace:FindFirstChild("Map") or false
local ArenaSurface = Map and Map:FindFirstChild("ArenaSurface") or false
local Borders = ArenaSurface and ArenaSurface:FindFirstChild("Borders") or false

local CanCollideList = {"Head", "Torso"}

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local RootPart = Character:FindFirstChild("HumanoidRootPart")
local Humanoid = Character:FindFirstChild("Humanoid")

local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

getgenv().TargetName = nil
getgenv().FlingEnabled = false
getgenv().NoClipEnabled = false
getgenv().PreRenderConnection = nil

---------------------- Other -----------------------

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = CoreGui

local TextLabel = Instance.new("TextLabel")
TextLabel.TextColor3 = Color3.fromRGB(85, 255, 127)
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.Position = UDim2.new(0.8, 0, 0.9, 0)
TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel.Size = UDim2.new(0.125, 0, 0.1, 0)
TextLabel.BackgroundTransparency = 1
TextLabel.TextStrokeTransparency = 0
TextLabel.TextSize = 20
TextLabel.Text = ("Enabled: "..tostring(getgenv().FlingEnabled).."\nTarget: "..tostring(getgenv().TargetName) or "None")
TextLabel.Parent = ScreenGui

local Folder = Instance.new("Folder")
Folder.Name = "_Highlight_Players_"
Folder.Parent = CoreGui

if Borders then Borders:Destroy() end

-------------------- Function's ---------------------

local function GetClosestPlayerToCursor()
    local ClosestDistance = math.huge
    local ClosestPlayer = nil
    for _, OtherPlayer in pairs(Players:GetPlayers()) do
        if OtherPlayer ~= LocalPlayer and OtherPlayer.Character then
            local OtherCharacter = OtherPlayer.Character
            local OtherRootPart = OtherCharacter:FindFirstChild("HumanoidRootPart")
            local OtherHumanoid = OtherCharacter:FindFirstChild("Humanoid")
            if OtherRootPart and OtherHumanoid and OtherHumanoid.Health > 0 then
                local ScreenPoint, OnScreen = Camera:WorldToScreenPoint(OtherRootPart.Position)
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

local function ChangeHighlight(Object, FillColor, FillTransparency, OutlineColor, OutlineTransparency)
    local Highlight = Object and Folder:FindFirstChild(Object.Name) or Instance.new("Highlight", Folder)
    Highlight.Name = Object.Name or "None"
    Highlight.FillColor = FillColor
    Highlight.FillTransparency = FillTransparency
    Highlight.OutlineColor = OutlineColor
    Highlight.OutlineTransparency = OutlineTransparency
    Highlight.Adornee = Object
end

local function ToggleNoClip()
	for _, Part in ipairs(Character:GetChildren()) do
		if Part:IsA("BasePart") then
			if getgenv().NoClipEnabled then
				Part.CanCollide = false
			else
				Part.CanCollide = table.find(CanCollideList, Part.Name)
			end
		end
	end
end

local function ReturnCharacterInfo(CurrentPlayer)
    local Current_Player = CurrentPlayer and Players:FindFirstChild(CurrentPlayer.Name)
    local Current_Character = Current_Player.Character or Current_Player.CharacterAdded:Wait()
    local Current_RootPart = Current_Character:FindFirstChild("HumanoidRootPart")
    local Current_Humanoid = Current_Character:FindFirstChild("Humanoid")
    return Current_Player, Current_Character, Current_RootPart, Current_Humanoid
end

local function ReturnRandomNum(Number1, Number2)
    local random = math.random(0,1)
    return random == 0 and Number1 or random == 1 and Number2
end

local function Main()
    local _, Target_Character, Target_RootPart, Target_Humanoid = ReturnCharacterInfo(getgenv().TargetName)
    if getgenv().FlingEnabled and getgenv().TargetName then
        getgenv().NoClipEnabled = true
        if Target_RootPart and Target_RootPart.CFrame and RootPart and Target_Humanoid and Target_Humanoid.Health ~= 0 and Humanoid.Health ~= 0 then
            ChangeHighlight(Target_Character, Color3.fromRGB(255,0,0), 0.7, Color3.fromRGB(255,255,255), 0.7)
            RootPart.CFrame = CFrame.new(Target_RootPart.CFrame.Position + Vector3.new(ReturnRandomNum(-5,5), 0, ReturnRandomNum(-5,5)))
            RootPart.CFrame = CFrame.lookAt(RootPart.Position, Target_RootPart.Position)
            Camera.CameraSubject = Target_Humanoid
        elseif Humanoid and Humanoid.Health == 0 or Target_Character and Target_Humanoid and Target_Humanoid.Health == 0 then
            ChangeHighlight(Target_Character, Color3.fromRGB(255,0,0), 1, Color3.fromRGB(255,255,255), 1)
            Camera.CameraSubject = LocalPlayer.Character:FindFirstChild("Humanoid")
            getgenv().NoClipEnabled = false
        end
    end
    ToggleNoClip()
end

------------------- Connection's --------------------

UIS.InputEnded:Connect(function(Input, GameProcessed)
    if GameProcessed then return end
    if Input.KeyCode == _G.FlingEnabledBind then
        getgenv().FlingEnabled = not getgenv().FlingEnabled
        TextLabel.Text = "Enabled: "..tostring(getgenv().FlingEnabled).."\nTarget: "..tostring(getgenv().TargetName) or "None"
        if getgenv().FlingEnabled then
            PreRenderConnection = RunService.PreRender:Connect(Main)
        else
            local _, Target_Character = ReturnCharacterInfo(getgenv().TargetName)
            Camera.CameraSubject = LocalPlayer.Character:FindFirstChild("Humanoid")
            ChangeHighlight(Target_Character, Color3.fromRGB(255,0,0), 1, Color3.fromRGB(255,255,255), 1)
            getgenv().NoClipEnabled = false
            PreRenderConnection:Disconnect()
        end
    elseif Input.KeyCode == _G.ChangePlayerBind then
        getgenv().TargetName = GetClosestPlayerToCursor()
        TextLabel.Text = "Enabled: "..tostring(getgenv().FlingEnabled).."\nTarget: "..tostring(getgenv().TargetName) or "None"
    end
end)

LocalPlayer.CharacterAdded:Connect(function(NewCharacter)
    Character = NewCharacter
    RootPart = Character:WaitForChild("HumanoidRootPart")
    Humanoid = Character:WaitForChild("Humanoid")
end)

getgenv().SkibidiOhioScript = true
--Nah
