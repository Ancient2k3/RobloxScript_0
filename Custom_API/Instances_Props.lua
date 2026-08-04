local x = function(i, p) return tostring(i[p] or nil) end
local z = function(i, p)
  local prop = i[p]
  if prop then
    local ist = typeof(i[p]):lower()
    if ist:match"vector3" then
      return "X: " .. tostring(prop.X):sub(1, 4) .. ", Y: " .. tostring(prop.Y):sub(1, 4) .. ", Z: " .. tostring(prop.Z):sub(1, 4)
    elseif ist:match"color3" then
      return "R: " .. tostring(prop.R * 255):sub(1, 4) .. ", G: " .. tostring(prop.G * 255):sub(1, 4) .. ", B: " .. tostring(prop.B * 255):sub(1, 4)
    elseif ist:match"cframe" then
      return tostring(prop)
    elseif ist:match"udim2" then
      return "X: {" .. tostring(prop.X.Scale):sub(1, 4) .. ", " .. tostring(prop.X.Offset):sub(1, 4) .. "}, Y: {" .. tostring(prop.Y.Scale):sub(1, 4) .. ", " .. tostring(prop.Y.Offset):sub(1, 4) .. "}"
    end
  end return tostring(nil)
end
return {
  ["Folder"] = {},
  ["ScreenGui"] = {
    ["Enable"] = x
  },
  ["Frame"] = {
    ["BackgroundTransparency"] = x, ["BackgroundColor3"] = z, ["Position"] = z, ["Size"] = z, ["Active"] = x, ["Draggable"] = x, ["Visible"] = x, ["ZIndex"] = x
  },
  ["Sound"] = {
    ["SoundId"] = x, ["Pitch"] = x, ["Volume"] = x
  },
  ["Animation"] = {
    ["AnimationId"] = x
  },
  ["Humanoid"] = {
    ["Health"] = x, ["WalkSpeed"] = x, ["JumpPower"] = x, ["Jump"] = x, ["Sit"] = x
  },
  ["Part"] = {
    ["Transparency"] = x, ["Position"] = z, ["Size"] = z, ["Anchored"] = x, ["CanCollide"] = x, ["Color"] = z, ["CFrame"] = z
  },
  ["Player"] = {
    ["UserId"] = x, ["AccountAge"] = x, ["Archivable"] = x, ["Team"] = x
  },
  ["Model"] = {}, ["Workspace"] = {}, ["RemoteEvent"] = {}, ["Players"] = {},
  ["ReplicatedStorage"] = {}, ["Tool"] = {}
}
