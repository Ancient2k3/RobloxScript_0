local x = function(i, p) return tostring(i[p] or nil) end
local z = function(i, p)
  local prop = i[p]
  if prop then
    local ist = typeof(i[p]):lower()
    if ist == "vector3" then
      return "X: " .. tostring(prop.X):sub(1, 4) .. ", Y: " .. tostring(prop.Y):sub(1, 4) .. ", Z: " .. tostring(prop.Z):sub(1, 4)
    elseif ist == "color3" then
      return "R: " .. tostring(prop.R):sub(1, 4) .. ", G: " .. tostring(prop.G):sub(1, 4) .. ", B: " .. tostring(prop.B):sub(1, 4)
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
