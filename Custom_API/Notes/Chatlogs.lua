local plrs
plrs = game:GetService("Players")

_G.my_chatlogs = {}

function add_user(t)
  _G.my_chatlogs[t.Name] = {}
  t.Chatted:Connect(function(str)
    table.insert(_G.my_chatlogs[t.Name], str)
  end)
end

for _, user in next, plrs:GetPlayers() do
  add_user(user)
end

plrs.PlayerAdded:Connect(function(user)
  add_user(user)
end)

