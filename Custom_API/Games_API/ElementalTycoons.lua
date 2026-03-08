local ws = game:GetService("Workspace")
local plrs = game:GetService("Players")
local rls = game:GetService("ReplicatedStorage")

local type_of_items, muzzles = {
  "Part", "MeshPart", "BasePart"
}, {"Left", "Right"}

local plr, magic, slap
plr = plrs.LocalPlayer
magic = rls.Remotes.DoMagic
slap = rls.Slap.RemoteEvent

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

function shoot_rmt(t, g)
  magic:FireServer("Turret", "Energy Ball", {
    ["Mouse"] = t, ["Camera"] = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0), ["Gun"] = g
  })
end

function use_turret(t, p)
  local tds = t or nil
  local position = p or nil
  if tds ~= nil and position then
    if typeof(tds) == "table" then
      if #tds > 0 then
        shoot_rmt(p, tds[math.random(1, #tds)][muzzles[math.random(1, #muzzles)]])
      end
    else
      if typeof(tds):lower() == "instance" then
        shoot_rmt(p, tds[muzzles[math.random(#muzzles)]])
      end
    end
  else
    if not position then
      print("Missing argument: #2")
    end
    print("Missing argument: #1")
    return nil
  end
end

function aura(t, dmg)
  if t then
    slap:FireServer(t, dmg or 2, 0, 0, "Jay")
  else print("Missing argument: #1 target important. !")
  end
end

-- APIs Listed --
receive_turrets()~Return a table storing turret model instance... <void>@
receive_dollars()~Return a table of a bunch of dollar object... <void>@
shoot_rmt()~Using turret to shooting at specific position... <argument: #1 position : vector3, #2 turret model : instance>@
use_turret()~Using turret models, working same as shoot_rmt... <argument: #1 turret? : instance or table storing instance, #2 position : vector3>@
aura()~Instantly [eliminating or damage] a specific target... <argument: #1 target : instance, #2 damage : numberic>