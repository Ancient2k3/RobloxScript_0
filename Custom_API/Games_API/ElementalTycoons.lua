local ws = game:GetService("Workspace")
local plrs = game:GetService("Players")
local rls = game:GetService("ReplicatedStorage")

local type_of_items = {
  "Part", "MeshPart", "BasePart"
}

local plr, magic
plr = plrs.LocalPlayer
magic = rls.Remotes.DoMagic

function receive_turrets()
  local turrets = {}
  if #plrs:GetPlayers() < 1 then return end
  for _, user in pairs(plrs:GetPlayers()) do
    local basement = ws.Tycoons[user.Name]
    for _, xyz in next, basement:GetDescendants() do
      if xyz:IsA("Model") and xyz.Name == "XYZGuns" and tostring(xyz.Parent) == "Turret" then
        if xyz:FindFirstChild("Left") or xyz:FindFirstChild("Right") then  
          table.insert(turrets, xyz)
        end    
      end
    end
  end return turrets
end

function receive_dollars()
  local dollars = {}
  for _, mesh in next, ws:GetDescendants() do
    if table.find(type_of_items, mesh.ClassName) and mesh.Name == "Dollar" then
      table.insert(dollars, mesh)
    end
  end return dollars
end

-- APIs Listed --
receive_turrets()~Return a table storing turret model instance... <void>@
receive_dollars()~Return a table of a bunch of dollar object... <void>@