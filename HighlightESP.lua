----------------------- Setup -----------------------

local function Setup()
    local Setup = '_G.WhiteList = {"NickName1", "NickName2"}\n\nloadstring(game:HttpGet("https://raw.githubusercontent.com/IGriffy/Roblox-Scripts/refs/heads/main/HighlightESP.lua"))()'

    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = "Notification";
        Text = "Script Config Copied !";
        Duration = 10;
    })
    
    setclipboard(Setup)
end

----------------------- Check's ---------------------

if getgenv().HighlightESPNeadoScriptExecuted then print("Highlight ESP script already executed") return end
if _G.WhiteList == nil then Setup(); print("Not founded 'WhiteList'") return end

--------------------- Service's ---------------------

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

----------------------- Var's -----------------------

local Folder = Instance.new("Folder")
Folder.Name = "_Highlight_Players_"
Folder.Parent = CoreGui

-------------------- Function's ---------------------

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
    for _, name in pairs(_G.WhiteList) do
        if name == Plr.Name then
            return true
        end
    end
    return false
end

---------------------- Other -----------------------

task.spawn(function()
    while true do
        for _, Plr in Players:GetChildren() do
            if Plr ~= Player and Plr.Character then
                if CheckWhiteList(Plr) then
                    ChangeHighlight(Plr.Character, Color3.fromRGB(255,255,0), 0.5, Color3.fromRGB(255,255,255), 0.5)
                elseif Plr.TeamColor ~= Player.TeamColor then
                    ChangeHighlight(Plr.Character, Color3.fromRGB(255,0,0), 0.5, Color3.fromRGB(255,255,255), 0.5)
                elseif Plr.TeamColor == Player.TeamColor then
                    ChangeHighlight(Plr.Character, Color3.fromRGB(0,0,255), 0.5, Color3.fromRGB(255,255,255), 0.5)
                end
            end
        end
        task.wait(1)
    end
end)

getgenv().HighlightESPNeadoScriptExecuted = true
