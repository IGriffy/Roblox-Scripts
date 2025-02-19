if HighlightESPNeadoScriptExecuted then print("Highlight ESP script already executed") return end

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local Folder = Instance.new("Folder")
Folder.Name = "_Highlight_Players_"
Folder.Parent = CoreGui

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

getgenv().HighlightESPNeadoScriptExecuted = true
