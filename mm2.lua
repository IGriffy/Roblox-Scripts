local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local Character = Player.Character or Player.CharacterAdded:Wait()
local RootPart = Character:FindFirstChild("HumanoidRootPart")

local Folder = Instance.new("Folder")
Folder.Name = "_Highlight_Players_"
Folder.Parent = CoreGui

_G.WhiteList = {"piska_bobrafsko", "KingOvCursed", "Crankbread8743", "Luffy_77787", "Akira_kun44", "VenomForTSB1234"}

local function ChangeHighlight(Object, FillColor, FillTransparency, OutlineColor, OutlineTransparency)
    local Highlight = Folder:FindFirstChild(Object.Name) or Instance.new("Highlight", Folder)
    Highlight.Name = Object.Name
    Highlight.FillColor = FillColor
    Highlight.FillTransparency = FillTransparency
    Highlight.OutlineColor = OutlineColor
    Highlight.OutlineTransparency = OutlineTransparency
    Highlight.Adornee = Object
end

local function CheckWhiteList(Plr)
    for _, name in ipairs(_G.WhiteList) do
        if name == Plr.Name then
            return true
        end
    end
    return false
end

local function CheckGun()
    local Bindable = Instance.new("BindableFunction")
    for i, v in pairs(workspace:GetDescendants()) do
        if v.Name == "GunDrop" then
            ChangeHighlight(v, Color3.fromRGB(255,255,0), 0.5, Color3.fromRGB(255,255,255), 0.5)

            function Bindable.OnInvoke(Response)
                if Response == "Yes" then
                    local Pos = RootPart.CFrame
                    if v then
                        RootPart.CFrame = v.CFrame
                        task.wait(.2)
                        RootPart.CFrame = Pos
                    else
                        StarterGui:SetCore("SendNotification", {
                            Icon = "rbxassetid://7635712200";
                            Text = "Дудку спиздили";
                            Title = "Nofitication";
                            Button1 = "Close";
                            Duration = 5
                        })
                    end
                end
            end
            StarterGui:SetCore("SendNotification", {
                Icon = "rbxassetid://7635712200";
                Text = "Pick up gun?";
                Title = "Gun drop";
                Button1 = "Yes";
                Button2 = "No";
                Callback = Bindable;
                Duration = 10
            })
        end
    end
end

Player.CharacterAdded:Connect(function(NewCharacter)
    Character = NewCharacter
    RootPart = Character:WaitForChild("HumanoidRootPart")
end)

workspace.ChildAdded:Connect(function(Child)
    if Child:IsA("Model") then
        CheckGun()
    end
end)

while true do
    for _, Plr in Players:GetChildren() do
        if Plr ~= Player and Plr.Character then
            if CheckWhiteList(Plr) then
                ChangeHighlight(Plr.Character, Color3.fromRGB(255,255,0), 0.5, Color3.fromRGB(255,255,255), 0.5)
            elseif Plr.Backpack:FindFirstChild("Knife") or Plr.Character:FindFirstChild("Knife") then
                ChangeHighlight(Plr.Character, Color3.fromRGB(255,0,0), 0.5, Color3.fromRGB(255,255,255), 0.5)
            elseif Plr.Backpack:FindFirstChild("Gun") or Plr.Character:FindFirstChild("Gun") then
                ChangeHighlight(Plr.Character, Color3.fromRGB(0,0,255), 0.5, Color3.fromRGB(255,255,255), 0.5)
            elseif not Plr.Backpack:FindFirstChild("Knife") or not Plr.Character:FindFirstChild("Knife") and not Plr.Backpack:FindFirstChild("Gun") or not Plr.Character:FindFirstChild("Gun") then
                ChangeHighlight(Plr.Character, Color3.fromRGB(0,255,0), 0.5, Color3.fromRGB(255,255,255), 0.5)
            end
        end
    end
    task.wait(1)
end
