----------------------- Check -----------------------

if getgenv().OptimizationNeadoScrptExecuted then print("Optimization script already executed") return end

--------------------- Service's ---------------------

local Light = game:GetService("Lighting")

---------------------- Other -----------------------

Light.Technology = Enum.Technology.Voxel
Light.GlobalShadows = false

-------------------- Function's ---------------------

local function ObjectOptimize(Object)
    if Object:IsA("Part") or Object:IsA("MeshPart") or Object:IsA("WedgePart") or Object:IsA("UnionOperation") then
        Object.Material = Enum.Material.SmoothPlastic
    elseif Object:IsA("Model") then
        for _, obj in pairs(Object:GetDescendants()) do
            ObjectOptimize(obj)
        end
    end
end

------------------- Connection's --------------------

workspace.ChildAdded:Connect(function(Object)
    ObjectOptimize(obj)
end)

---------------------- Other -----------------------

for _, Object in pairs(workspace:GetDescendants()) do
    ObjectOptimize(Object)
end

getgenv().OptimizationNeadoScrptExecuted = true
