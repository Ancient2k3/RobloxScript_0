local ws = game:GetService("Workspace")
local plrs = game:GetService("Players")
local rls = game:GetService("ReplicatedStorage")

local plr, uid, register_hit, register_atk, enms
plr = plrs.LocalPlayer
uid = plr.UserId
register_hit = rls.Modules.Net["RE/RegisterHit"]
register_atk = rls.Modules.Net["RE/RegisterAttack"]
enms = ws.Enemies:GetChildren()


local funcs = {
  attack_moved = function(p)
    local t = plr.Character and plr.Character:FindFirstChildOfClass("Tool")
    if t and t:FindFirstChild("RemoteEvent") then
      t.RemoteEvent:FireServer(p)
    end
  end,
  uid = function(str)
    local is_nil = str or nil
    if is_nil == nil then
      return tostring(uid)
    else
      if type(is_nil) == "string" and is_nil:match("-") then
        local s_e = string.split(is_nil, "-")
        local st, ed = tonumber(s_e[1]), tonumber(s_e[2])
        if ed > st then
          return tostring(uid):sub(st, ed)
        else
          return "argument: #2 must be a numberic higher than #1"
        end
      end
    end
  end
}

-- APIs Listed --
funcs.attack_moved()~Make the items ability moving to specific position, idk what to say... <argument: #1 position : vector3>@
funcs.uid()~Return user-id as string... <argument: #1 numberic start - numberic end : string>@
Hehe...❤~Nothing to see here.@
