local Light = game:GetService("Lighting")
Light.Technology = Enum.Technology.Voxel
Light.GlobalShadows = false

local function ObjectOptimize(Object)
    if Object:IsA("Part") then
        Object.Material = Enum.Material.SmoothPlastic
    elseif Object:IsA("MeshPart") then
        Object.Material = Enum.Material.SmoothPlastic
    elseif Object:IsA("Model") then
        for _, obj in pairs(Object:GetDescendants()) do
            ObjectOptimize(obj)
        end
    end
end

for _, obj in pairs(workspace:GetDescendants()) do
    ObjectOptimize(obj)
end

workspace.ChildAdded:Connect(function(obj)
    ObjectOptimize(obj)
end)
