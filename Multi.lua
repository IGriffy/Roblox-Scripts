----------------------- Check -----------------------hhhh

if getgenv().UniversalNeadoScriptExecuted then print("Universal script already executed") return end
if _G.BindTeleport == nil then print("Bind 'BindTeleport' not founded") return end
if _G.BindNoclip == nil then print("Bind 'BindNoclip' not founded") return end
if _G.BindFly == nil then print("Bind 'BindFly' not founded") return end

--------------------- Service's ---------------------

local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

----------------------- Var's -----------------------

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:FindFirstChild("HumanoidRootPart")
local Mouse = Player:GetMouse()
local Camera = workspace.CurrentCamera

getgenv().CanCollideFalseList = {"HumanoidRootPart", "Left Leg", "Right Arm", "Right Leg"}
getgenv().NoClipEnabled = false
getgenv().Flying = false
getgenv().FlySpeed = 0.5

getgenv().IsPlusKeyHeld = false
getgenv().IsMinusKeyHeld = false

-------------------- Function's ---------------------

local function TeleportToMouse()
	local MousePos = Mouse.Hit.Position
	RootPart.CFrame = CFrame.new(MousePos+Vector3.new(0,3,0))*RootPart.CFrame.Rotation
end

local function ToggleNoClip()
	getgenv().NoClipEnabled = not getgenv().NoClipEnabled

	for _, Part in ipairs(Character:GetChildren()) do
		if Part:IsA("BasePart") then
			if getgenv().NoClipEnabled then
				Part.CanCollide = false
			else
				Part.CanCollide = not table.find(CanCollideFalseList, Part.Name)
			end
		end
	end
end

local function StartFlying()
	repeat
		Humanoid.PlatformStand = true
		local CurrentCF = RootPart.CFrame

		task.wait() do
			local add = Vector3.new(0,0,0)

			if UIS:IsKeyDown(Enum.KeyCode.W) then add += Camera.CFrame.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.S) then add -= Camera.CFrame.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.D) then add += Camera.CFrame.RightVector end
			if UIS:IsKeyDown(Enum.KeyCode.A) then add -= Camera.CFrame.RightVector end
			if UIS:IsKeyDown(Enum.KeyCode.E) then add += Camera.CFrame.UpVector end
			if UIS:IsKeyDown(Enum.KeyCode.Q) then add -= Camera.CFrame.UpVector end

			RootPart.AssemblyLinearVelocity = Vector3.zero
			RootPart.AssemblyAngularVelocity = Vector3.zero

			CurrentCF += add * getgenv().FlySpeed
			RootPart.CFrame = CFrame.lookAt(
				CurrentCF.Position,
				CurrentCF.Position + (Camera.CFrame.LookVector * 2)
			)
		end
	until not Flying 
	Humanoid.PlatformStand = false
end

---------------------- Other -----------------------

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = CoreGui
local TextLabel = Instance.new("TextLabel")
TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel.Position = UDim2.new(0.65, 0, 0.9, 0)
TextLabel.Size = UDim2.new(0.125, 0, 0.1, 0)
TextLabel.BackgroundTransparency = 1
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.TextStrokeTransparency = 0
TextLabel.TextSize = 15
TextLabel.Parent = ScreenGui

task.spawn(function()
	while true do
		if IsPlusKeyHeld == true then
			getgenv().FlySpeed = getgenv().FlySpeed + 0.1
		end
		if IsMinusKeyHeld == true then
			getgenv().FlySpeed = math.max(0.1, getgenv().FlySpeed - 0.1)
		end
			
        TextLabel.Text = "Fly speed :  "..(string.format("%.1f", getgenv().FlySpeed)).."\nNoclip......:  "..tostring(getgenv().NoClipEnabled and "Enabled" or not getgenv().NoClipEnabled and "Disabled")
		task.wait(.15)
	end
end)

------------------- Connection's --------------------

UIS.InputBegan:Connect(function(Input, GameProcessed)
    if GameProcessed then return end
	if Input.KeyCode == Enum.KeyCode.Equals then
		getgenv().IsPlusKeyHeld = true
	elseif Input.KeyCode == Enum.KeyCode.KeypadPlus then
		getgenv().IsPlusKeyHeld = true
	elseif Input.KeyCode == Enum.KeyCode.Minus then
		getgenv().IsMinusKeyHeld = true
	elseif Input.KeyCode == Enum.KeyCode.KeypadMinus then
		getgenv().IsMinusKeyHeld = true
	end
    print("\nFly speed: "..getgenv().FlySpeed.."\nInput key: "..Input.KeyCode.Name.."\nIs plus key held: "..tostring(getgenv().IsPlusKeyHeld).."\nIs minus key held: "..tostring(getgenv().IsPlusKeyHeld))
end)

UIS.InputEnded:Connect(function(Input, GameProcessed)
    if GameProcessed then return end
	if Input.KeyCode == Enum.KeyCode.Equals then
		getgenv().IsPlusKeyHeld = false
	elseif Input.KeyCode == Enum.KeyCode.KeypadPlus then
		getgenv().IsPlusKeyHeld = false
	elseif Input.KeyCode == Enum.KeyCode.Minus then
		getgenv().IsMinusKeyHeld = false
	elseif Input.KeyCode == Enum.KeyCode.KeypadMinus then
		getgenv().IsMinusKeyHeld = false
	end
end)

UIS.InputEnded:Connect(function(Input, GameProcessed)
    if GameProcessed then return end
	if Input.KeyCode == _G.BindFly then
		getgenv().Flying = not getgenv().Flying
		if getgenv().Flying then
			StartFlying()
		end
    elseif Input.KeyCode == _G.BindTeleport then
		TeleportToMouse()
	elseif Input.KeyCode == _G.BindNoclip then
		ToggleNoClip()
	end
end)

Player.CharacterAdded:Connect(function(newCharacter)
	Character = newCharacter
	Humanoid = Character:WaitForChild("Humanoid")
	RootPart = Character:WaitForChild("HumanoidRootPart")
end)

---------------------- Other -----------------------

getgenv().UniversalNeadoScriptExecuted = true
