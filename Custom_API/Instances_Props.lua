local x = function(i, p) return tostring(i[p] or nil) end
local z = function(i, p)
  local prop = i[p]
  if prop then
    local ist = typeof(i[p]):lower()
    if ist == "vector3" then
      return "X: " .. tostring(prop.X) .. ", Y: " .. tostring(prop.Y) .. ", Z: " .. tostring(prop.Z)
    elseif ist == "color3" then
      return "R: " .. tostring(prop.R) .. ", G: " .. tostring(prop.G) .. ", B: " .. tostring(prop.B)
    elseif ist == "cframe" then
      return tostring(prop)
    end
  end return tostring(nil)
end
return {
  ["Folder"] = {},
  ["Sound"] = {
    ["SoundId"] = x,
    ["Pitch"] = x,
    ["Volume"] = x
  },
  ["Animation"] = {
    ["AnimationId"] = x
  },
  ["Humanoid"] = {
    ["Health"] = x,
    ["WalkSpeed"] = x,
    ["JumpPower"] = x,
    ["Jump"] = x,
    ["Sit"] = x
  },
  ["Part"] = {
    ["Transparency"] = x,
    ["Position"] = z,
    ["Size"] = z,
    ["Anchored"] = x,
    ["CanCollide"] = x,
    ["Color"] = z,
    ["CFrame"] = z
  }
}
