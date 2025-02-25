if UniversalNeadoScriptExecuted then print("Universal script already executed") return end

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
	NoClipEnabled = not NoClipEnabled

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

			CurrentCF += add * FlySpeed
			RootPart.CFrame = CFrame.lookAt(
				CurrentCF.Position,
				CurrentCF.Position + (Camera.CFrame.LookVector * 2)
			)
		end
	until not Flying 
	Humanoid.PlatformStand = false
end

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

------------------- Connection's --------------------

task.spawn(function()
	while true do
		if IsPlusKeyHeld == true then
			FlySpeed = FlySpeed + 0.1
		end

		if IsMinusKeyHeld == true then
			FlySpeed = math.max(0.1, FlySpeed - 0.1)
		end

        TextLabel.Text = "Fly speed :  "..(string.format("%.1f", FlySpeed)).."\nNoclip......:  "..tostring(NoClipEnabled and "Enabled" or not NoClipEnabled and "Disabled")
		task.wait(.15)
	end
end)

UIS.InputBegan:Connect(function(Input, GameProcessed)
    if GameProcessed then return end
	if Input.KeyCode == Enum.KeyCode.Equals then
		IsPlusKeyHeld = true
	elseif Input.KeyCode == Enum.KeyCode.KeypadPlus then
		IsPlusKeyHeld = true
	elseif Input.KeyCode == Enum.KeyCode.Minus then
		IsMinusKeyHeld = true
	elseif Input.KeyCode == Enum.KeyCode.KeypadMinus then
		IsMinusKeyHeld = true
	end
    print("\nFly speed: "..FlySpeed.."\nInput key: "..Input.KeyCode.Name.."\nIs plus key held: "..tostring(IsPlusKeyHeld).."\nIs minus key held: "..tostring(IsPlusKeyHeld))
end)

UIS.InputEnded:Connect(function(Input, GameProcessed)
    if GameProcessed then return end
	if Input.KeyCode == Enum.KeyCode.Equals then
		IsPlusKeyHeld = false
	elseif Input.KeyCode == Enum.KeyCode.KeypadPlus then
		IsPlusKeyHeld = false
	elseif Input.KeyCode == Enum.KeyCode.Minus then
		IsMinusKeyHeld = false
	elseif Input.KeyCode == Enum.KeyCode.KeypadMinus then
		IsMinusKeyHeld = false
	end
end)

UIS.InputEnded:Connect(function(Input, GameProcessed)
    if GameProcessed then return end
	if Input.KeyCode == _G.BindFly then
		Flying = not Flying
		if Flying then
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

getgenv().UniversalNeadoScriptExecuted = true
