-- Saving & Reload: Baseparts --
local ws = game:GetService("Workspace")
local htps = game:GetService("HttpService")
local module = {}
local folder_1, _object

if not ws:FindFirstChild("_ScriptFolder") then
  folder_1 = Instance.new("Folder", ws)
  folder_1.Name = "_ScriptFolder"

  _object = Instance.new("Part", folder_1)
  _object.Name = "Origin_Point"
  _object.Transparency = 1
  _object.Anchored = true
  _object.CanCollide = false
  _object.Material = "Neon"
  _object.Color = Color3.new(1, 0, 1)
  _object.Size = Vector3.new(0.5, 0.5, 0.5)
  _object.Position = Vector3.new(0, 9999, 0)
end

module.save_map = function(_path, from_point)
  local counts, kind_of, data_map, start_tick = 1, {"Part", "MeshPart", "TrussPart"}, {}, tick()
  for _, valid_obj in pairs(_path:GetDescendants()) do
    if valid_obj and table.find(kind_of, valid_obj.ClassName) then
      valid_obj.Parent = _path
    end
  end task.wait(0.2)
  for _, obj in pairs(_path:GetChildren()) do
    if obj and table.find(kind_of, obj.ClassName) then
      local p, s, r, c, clr, _mat, _trans = obj.Position - from_point.Position, obj.Size, obj.Rotation, obj.ClassName, obj.Color, obj.Material, obj.Transparency
      data_map["object_" .. tostring(counts)] = {
        position = {
          p.X, p.Y, p.Z
        }, size = {
          s.X, s.Y, s.Z
        }, rotation = {
          r.X, r.Y, r.Z
        }, class = c,
        color = {clr.R * 255, clr.G * 255, clr.B * 255}, material = tostring(_mat):split(".")[3], transparency = tonumber(_trans)
      } counts = counts + 1
      task.wait(0.01)
    end
  end local out = htps:JSONEncode(data_map)
  print("It's finished in " .. tostring(tick() - start_tick) .. " seconds !\nOutput: " .. out:sub(1, 1000) .. "...and more.")
  return out
end

module.load_map = function(_parent, t, at_point)
  local counts = 0
  if type(t) ~= "string" then return "argument 2 not a string." end
  t = htps:JSONDecode(t)
  for i, _ in pairs(t) do
    counts = counts + 1
  end task.wait(0.02)
  for idx = 1, counts do
    local data = t["object_" .. tostring(idx)]
    local p, s, r, c, clr, _mat, _trans = data.position, data.size, data.rotation, data.class, data.color, data.material, data.transparency
    local new_obj = Instance.new(c, _parent)
    new_obj.Name = c
    new_obj.Material = Enum.Material[_mat]
    new_obj.Anchored = true
    new_obj.CanCollide = true
    new_obj.Position = at_point.Position + Vector3.new(unpack(p))
    new_obj.Rotation = Vector3.new(unpack(r))
    new_obj.Size = Vector3.new(unpack(s))
    new_obj.Color = Color3.fromRGB(unpack(clr))
    new_obj.Transparency = _trans
    task.wait(0.01)
  end
end

return module