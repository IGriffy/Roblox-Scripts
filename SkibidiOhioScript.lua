_G.FlingEnabledBind = Enum.KeyCode.X
_G.ChangePlayerBind = Enum.KeyCode.C

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
getgenv().NoClipEnabled = false

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
TextLabel.Text = "\nEnabled: "..tostring(FlingEnabled).."\nTarget: "..tostring(TargetName)or"None"
TextLabel.Parent = ScreenGui

local MessageTable = {"Ez", "Cry about it", "Kid", "Cry", "Venom", "L", "Where's your mom?", "Noobs", "Get good", "What’s wrong with you?", "Are you even trying?", "Who taught you?", "First time?", "Potato skills", "Need a tutorial?", "Grandma’s student", "Carrying backwards", "Boring strategy", "Rocks have better reflexes", "Lobby decoration", "Cereal box skills", "Upside-down keyboard", "Worse than a bot", "Need a map?", "Mom wants her skills back", "Tutorial’s reason", "Uninstall yourself", "Are you awake?", "Placeholder player", "Eyes-closed pick", "Artistic failure", "Asking for help?", "MVP of losing", "Too embarrassed to roast", "Did you learn this from your grandma?", "You’re carrying the team... backwards!", "Is your strategy to bore them to death?", "I’ve seen rocks with better reflexes.", "Are you here to decorate the lobby?", "You’re so bad, you make me look good.", "Did you get your skills from a cereal box?", "Is your keyboard upside down?", "You’re like a bot, but worse.", "Do you need a map to find the exit?", "Your mom called, she wants her skills back.", "You’re the reason we have tutorials.", "I’d say ‘uninstall,’ but you’re already doing nothing.", "Are you even awake right now?", "You’re like a placeholder for a real player.", "Did you pick your character by closing your eyes?", "You’re so bad, it’s almost artistic.", "Is this your way of asking for help?", "You’re the MVP... of losing.", "I’d roast you, but I don’t want to embarrass you further.", "Where's your mom at?", "You guys are noobs!", "What’s wrong with you, bro?", "Are you even trying?", "Get good, loser!", "Who taught you how to play?", "Is this your first time or something?", "You’re so bad, it’s almost impressive.", "Do you need a tutorial or what?", "I’ve seen better skills from a potato."}

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

local function SayChatRandomMessage(_Message)
	if _Message then
		game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):FindFirstChild("SayMessageRequest"):FireServer(tostring(_Message), "All")
	else
		local Message = MessageTable[math.random(1, #MessageTable)]
		game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):FindFirstChild("SayMessageRequest"):FireServer(tostring(Message), "All")
	end
end

local function ToggleNoClip()
	for _, Part in ipairs(Character:GetChildren()) do
		if Part:IsA("BasePart") then
			if NoClipEnabled then
				Part.CanCollide = false
			else
				Part.CanCollide = true
			end
		end
	end
end

UIS.InputEnded:Connect(function(Input, GameProcessed)
    if GameProcessed then return end
    if Input.KeyCode == _G.FlingEnabledBind then
        FlingEnabled = not FlingEnabled
        TextLabel.Text = "\nEnabled: "..tostring(FlingEnabled).."\nTarget: "..tostring(TargetName)or"None"
    elseif Input.KeyCode == _G.ChangePlayerBind then
        TargetName = GetClosestPlayerToCursor()
        TextLabel.Text = "\nEnabled: "..tostring(FlingEnabled).."\nTarget: "..tostring(TargetName)or"None"
    end
end)

Player.CharacterAdded:Connect(function(NewCharacter)
    Character = NewCharacter
    RootPart = Character:WaitForChild("HumanoidRootPart")
    Humanoid = Character:WaitForChild("Humanoid")
end)

RunService.PreRender:Connect(function()
    if FlingEnabled and TargetName then
        NoClipEnabled = true
        local TPlr, TChar, TRP, TH = ReturnTargetCharacter(TargetName)
        local Root = GetRoot(Player.Character)

        if TRP and TRP.CFrame and Root and TH.Health ~= 0 then
            Root.CFrame = CFrame.new(TRP.CFrame.Position + Vector3.new(ReturnRandomNum(-5,5), 0, ReturnRandomNum(-5,5)))*Root.CFrame.Rotation
            Root.CFrame = CFrame.lookAt(Root.Position, TRP.Position)
            Camera.CameraSubject = TH
        elseif TChar and TH.Health == 0 then
            Camera.CameraSubject = Player.Character:FindFirstChild("Humanoid")
            NoClipEnabled = false
        end

    elseif not FlingEnabled then
        Camera.CameraSubject = Player.Character:FindFirstChild("Humanoid")
        NoClipEnabled = false
    end
    ToggleNoClip()
end)

local Map = workspace:FindFirstChild("Map") or false
local ArenaSurface = Map and Map:FindFirstChild("ArenaSurface") or false
local Borders = ArenaSurface and ArenaSurface:FindFirstChild("Borders") or false

if Borders then
	Borders:Destroy()
end

getgenv().SkibidiOhioScript = true
