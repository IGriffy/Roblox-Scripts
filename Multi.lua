local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Mouse = Player:GetMouse()
local Camera = workspace.CurrentCamera

local CanCollideFalseList = {"HumanoidRootPart", "Left Leg", "Right Arm", "Right Leg"}
local noClipEnabled = false
local flying = false
local keys = {a = false, d = false, w = false, s = false, e = false, q = false, z = false, shift = false}

local function TeleportToMouse()
	local MousePos = Mouse.Hit.Position
	Character:MoveTo(MousePos)
end

local function toggleNoClip()
	noClipEnabled = not noClipEnabled

	for _, part in ipairs(Character:GetChildren()) do
		if part:IsA("BasePart") then
			if noClipEnabled then
				part.CanCollide = false
			else
				part.CanCollide = not table.find(CanCollideFalseList, part.Name)
			end
		end
	end
end

local function startFlying()
	repeat
		local char = Player.Character
		local rootPart:BasePart = char:WaitForChild('HumanoidRootPart')
		local hum:Humanoid = char:WaitForChild('Humanoid')
		hum.PlatformStand = true
		local currentCF = rootPart.CFrame

		task.wait() do
			local add = Vector3.new(0,0,0)

			if UIS:IsKeyDown(Enum.KeyCode.W) then add += Camera.CFrame.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.S) then add -= Camera.CFrame.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.D) then add += Camera.CFrame.RightVector end
			if UIS:IsKeyDown(Enum.KeyCode.A) then add -= Camera.CFrame.RightVector end
			if UIS:IsKeyDown(Enum.KeyCode.E) then add += Camera.CFrame.UpVector end
			if UIS:IsKeyDown(Enum.KeyCode.Q) then add -= Camera.CFrame.UpVector end

			rootPart.AssemblyLinearVelocity = Vector3.zero
			rootPart.AssemblyAngularVelocity = Vector3.zero

			currentCF += add
			rootPart.CFrame = CFrame.lookAt(
				currentCF.Position,
				currentCF.Position + (Camera.CFrame.LookVector * 2)
			)
		end
	until not flying 

	Humanoid.PlatformStand = false
end

Mouse.KeyDown:Connect(function(key)
	if key == "x" then
		flying = not flying
		if flying then
			startFlying()
		end
	elseif key == "w" then
		keys.w = true
	elseif key == "s" then
		keys.s = true
	elseif key == "a" then
		keys.a = true
	elseif key == "d" then
		keys.d = true
	elseif key == "e" then
		keys.e = true
	elseif key == "q" then
		keys.q = true
	elseif key == "0" then
		keys.shift = true
	elseif key == "t" then
		TeleportToMouse()
	elseif key == "z" then
		toggleNoClip()
	end
end)

Mouse.KeyUp:Connect(function(key)
	if key == "w" then
		keys.w = false
	elseif key == "s" then
		keys.s = false
	elseif key == "a" then
		keys.a = false
	elseif key == "d" then
		keys.d = false
	elseif key == "e" then
		keys.e = false
	elseif key == "q" then
		keys.q = false
	elseif key == "0" then
		keys.shift = false
	end
end)

Player.CharacterAdded:Connect(function(newCharacter)
	Character = newCharacter
	Humanoid = Character:WaitForChild("Humanoid")
	HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
end)
