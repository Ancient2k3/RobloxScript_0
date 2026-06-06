-- Saving & Reload: Baseparts --
local module = {}

module.save_map = function(_path, t)
  local counts, kind_of = 1, {"Part", "MeshPart", "TrussPart"}
  for _, obj in pairs(_path:GetChildren()) do
    if obj and table.find(kind_of, obj.ClassName) then
      local p, s, r, c, clr, _mat, _trans = obj.Position, obj.Size, obj.Rotation, obj.ClassName, obj.Color, obj.Material, obj.Transparency
      t["object_" .. tostring(counts)] = {
        position = {
          p.X, p.Y, p.Z
        }, size = {
          s.X, s.Y, s.Z
        }, rotation = {
          r.X, r.Y, r.Z
        }, class = c,
        color = {clr.R, clr.G, clr.B}, material = tostring(_mat):split(".")[3], transparency = tonumber(_trans)
      } counts = counts + 1
      task.wait(0.01)
    end
  end
end

module.load_map = function(_parent, t)
  local counts = 0
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
    new_obj.Position = Vector3.new(unpack(p))
    new_obj.Rotation = Vector3.new(unpack(r))
    new_obj.Size = Vector3.new(unpack(s))
    new_obj.Color = Color3.fromRGB(unpack(clr))
    new_obj.Transparency = _trans
    task.wait(0.02)
  end
end

return module