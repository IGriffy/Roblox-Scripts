----------------------- Check's ---------------------

if getgenv().BoxAdornmentESPNeadoScriptExecuted then print("BoxAdornment ESP script already executed") return end

--------------------- Service's ---------------------

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

----------------------- Var's -----------------------

local Character = Player.Character or Player.CharacterAdded:Wait()
local RootPart = Character:FindFirstChild("HumanoidRootPart")
local Humanoid = Character:FindFirstChild("Humanoid")

local Folder = Instance.new("Folder")
Folder.Name = "_BoxHandleAdornment_Players_"
Folder.Parent = CoreGui

-------------------- Function's ---------------------

local function ChangeBHA(Object, Color)
    local ObjectsFolder = Folder:FindFirstChild(Object.Name) or Instance.new("Folder", Folder)
    ObjectsFolder.Name = Object.Name

    for i, v in pairs(Object:GetChildren()) do
        if v:IsA("Part") or v:IsA("MeshPart") then
            local BoxAdornment = ObjectsFolder:FindFirstChild(Object.Name.."_"..v.Name) or Instance.new("BoxHandleAdornment", ObjectsFolder)
            BoxAdornment.Size = v.Size
            BoxAdornment.AlwaysOnTop = true
            BoxAdornment.Transparency = 0.6
            BoxAdornment.Adornee = v
            BoxAdornment.Color3 = Color
            BoxAdornment.ZIndex = 1
            BoxAdornment.Name = Object.Name.."_"..v.Name
        end
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

------------------- Connection's --------------------

Players.PlayerRemoving:Connect(function(player)
    local a = Folder:FindFirstChild(player.Name)
    if a then a:Destroy() end
end)

---------------------- Other -----------------------

task.spawn(function()
    while true do
        for _, Plr in Players:GetChildren() do
            if Plr ~= Player and Plr.Character then
                if CheckWhiteList(Plr) then
                    ChangeBHA(Plr.Character, Color3.fromRGB(255,255,0))
                elseif Plr.TeamColor ~= Player.TeamColor then
                    ChangeBHA(Plr.Character, Color3.fromRGB(255,0,0))
                elseif Plr.TeamColor == Player.TeamColor then
                    ChangeBHA(Plr.Character, Color3.fromRGB(0,0,255))
                end
            end
        end
        task.wait(1)
    end
end)

getgenv().BoxAdornmentESPNeadoScriptExecuted = true
