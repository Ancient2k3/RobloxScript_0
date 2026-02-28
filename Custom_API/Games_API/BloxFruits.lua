local plrs = game:GetService("Players")
local rls = game:GetService("ReplicatedStorage")

local plr, uid
plr = plrs.LocalPlayer
uid = plr.UserId

local funcs = {
  aimbot_skill = function(p)
    local t = plr.Character and plr.Character:FindFirstChildOfClass("Tool")
    if t and t:FindFirstChild("RemoteEvent") then
      t.RemoteEvent(p)
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
funcs.aimbot_skill()~Make the items ability moving to specific position... <argument: #1 position : vector3>@
funcs.uid()~Return user-id as string... <argument: #1 numberic start - numberic end : string>@
Hehe...❤~Nothing to see here.@
