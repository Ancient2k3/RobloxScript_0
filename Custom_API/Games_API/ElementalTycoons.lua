local ws = game:GetService("Workspace")
local plrs = game:GetService("Players")
local rls = game:GetService("ReplicatedStorage")

local type_of_items = {
  "Part", "MeshPart", "BasePart"
}

local plr, magic, tycoons
plr = plrs.LocalPlayer
magic = rls.Remotes.DoMagic
tycoons = ws:FindFirstChild("Tycoons")

function receive_turrets()
  local listed = {}
  for _, tr in pairs(tycoons:GetDescendants()) do
    if tr:IsA("Model") and tr.Name == "XYZGuns" then
      local left, right = tr:FindFirstChild("Left"), right:FindFirstChild("Right")
      if left and right then
        table.insert(listed, tr)
      end
    end
  end if #listed > 0 then
    for index = 1, #listed do
      print(listed[index]:GetFullName())
    end
  end return listed
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