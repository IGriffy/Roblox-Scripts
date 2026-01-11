----------------------- Setup -----------------------

local function setup()
    local setupCode = '_G.whiteList = {"NickName1", "NickName2"}\n\nloadstring(game:HttpGet("https://raw.githubusercontent.com/IGriffy/Roblox-Scripts/refs/heads/main/BoxAdornmentESP.lua"))()'

    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = "Notification";
        Text = "Script Config Copied !";
        Duration = 10;
    })

    setclipboard(setupCode)
end

----------------------- Check's ---------------------

if getgenv().boxAdornmentESPNeadoScriptExecuted then print("BoxAdornment ESP script already executed!") return end
if _G.whiteList == nil then setup(); print("Not founded white list!") return end

--------------------- Service's ---------------------

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

----------------------- Var's -----------------------

local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:FindFirstChild("HumanoidRootPart")
local humanoid = character:FindFirstChild("Humanoid")

local boxFolder = Instance.new("Folder")
boxFolder.Name = "BoxHandleAdornment_Players"
boxFolder.Parent = CoreGui

-------------------- Function's ---------------------

local function changeBHA(object, color, enabled)
    local objFolder = boxFolder:FindFirstChild(object.Name) or Instance.new("Folder", boxFolder)
    objFolder.Name = object.Name

    for _, obj in pairs(object:GetChildren()) do
        if obj:IsA("Part") or obj:IsA("MeshPart") then
            local b = objFolder:FindFirstChild(object.Name .. "_" .. obj.Name) or Instance.new("BoxHandleAdornment", objFolder)
            b.Size = obj.Size
            b.Enabled = enabled
            b.AlwaysOnTop = true
            b.Transparency = 0.6
            b.Adornee = obj
            b.Color3 = color
            b.ZIndex = 1
            b.Name = object.Name .. "_" .. obj.Name
        end
    end
end

local function checkWhiteList(plr)
    for _, name in ipairs(_G.whiteList) do
        if name == plr.Name then
            return true
        end
    end
    return false
end

------------------- Connection's --------------------

Players.PlayerRemoving:Connect(function(plr)
    local box = boxFolder:FindFirstChild(plr.Name)
    if box then box:Destroy() end
end)

---------------------- Other -----------------------


for _, plr in Players:GetChildren() do
    if plr ~= player and plr.Character then
        if checkWhiteList(plr) then
            changeBHA(plr.Character, Color3.fromRGB(255,255,0), true)
        else
            changeBHA(plr.Character, plr.TeamColor.Color, true)
        end
    end
end

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        changeBHA(char, plr.TeamColor.Color, true)
    end)

    plr.CharacterRemoving:Connect(function(char)
        changeBHA(char, plr.TeamColor.Color, false)
    end)
end)

getgenv().boxAdornmentESPNeadoScriptExecuted = true
