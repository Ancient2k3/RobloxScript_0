local ws = game:GetService("Workspace")
local plrs = game:GetService("Players")
local rls = game:GetService("ReplicatedStorage")

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

-- APIs Listed --
receive_turrets()~Return a table storing turret model instance... <void>@