-- Custom Built+In_Functions --
local zx, zc, zv
zx = game:GetService("Workspace")
zc = game:GetService("Players")
zv = game:GetService("CoreGui")

local xz, built_in
xz = zc.LocalPlayer
built_in = {
  "tpos() -- 1: vector3, 2: boolean.",
  "find_plr() -- 1: \"self\" or \"near\".",
  "str_changed_to() -- 1: \"string to change\", 2: \"string changed to\".",
  "model_pos() -- 1: actual model or character model."
}

function tpos(pos, origin)
  local hrp = xz.Character:FindFirstChild("HumanoidRootPart")
  local d = {o = hrp.Position, p = pos or nil, t = origin or false}
  if d.p ~= nil and typeof(d.p):lower() == "vector3" then
    hrp.CFrame = CFrame.new(d.p)
    if d.t ~= false then task.wait(0.02)
      hrp.CFrame = CFrame.new(d.o)
    end
  else print("<tpos: vector3, boolean>")
  end
end

function find_plr(method)
  if method == "self" then return xz
  elseif method == "near" then
  local d = {f = nil, m = math.huge}
  for _, usr in pairs(zc:GetPlayers()) do
    if usr ~= xz and usr and usr.Character and usr.Character:FindFirstChild("HumanoidRootPart") then
      local dst= (usr.Character.HumanoidRootPart.Position - xz.Character.HumanoidRootPart.Position).magnitude
      if dst < d.m then
        d.m = dst
        d.f = usr
      end
    end
  end if d.f ~= nil then return d.f
    else print("Failed: found " .. #zc:GetPlayers() .. " players are in the server!")
  end else print("<find_plr: set method \"self\" or \"near\".") end
end

function str_changed_to(str, change)
  local tbox_found = nil
  local d = {o = str or nil, c = change or nil}
  for _, tbox in next, zv:GetDescendants() do
    if tbox:IsA("TextBox") and tbox.Text:match("str_changed_to") then
      tbox_found = tbox
    end
  end if tbox_found ~= nil then
    if d.o ~= nil and d.c ~= nil then
      tbox_found.Text = tbox_found.Text:gsub(str, change)
    else print("<str_changed_to: string, new_string>") end
  else print("Failed: function error... ")
  end
end

function model_pos(model)
  local md = model or nil
  if md ~= nil then return md:GetBoundingBox().Position
  else print("<model_pos: model or character>")
  end
end

function built_in_funcs()
  local tbox_found = nil
  local text_rs = ""
  for _, tbox in next, zv:GetDescendants() do
    if tbox:IsA("TextBox") and tbox.Text:match("built_in_funcs()") then
      tbox_found = tbox
    end
  end if tbox_found ~= nil then
    for i, nf in pairs(built_in) do
      text_rs = text_rs .. nf .. "\n"
    end tbox_found.Text = text_rs
  else print("Failed: function error... ")
  end
end

-- Hehe --
