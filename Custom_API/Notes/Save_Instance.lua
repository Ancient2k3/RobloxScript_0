-- Saving & Reload: Baseparts --
local module = {}

module.save_map = function(_path, t)
  local counts, kind_of = 1, {"Part", "MeshPart", "TrussPart"}
  for _, obj in pairs(_path:GetChildren()) do
    if obj and table.find(kind_of, obj.ClassName) then
      local p, s, r, c = obj.Position, obj.Size, obj.Rotation, obj.ClassName
      t["object_" .. tostring(counts)] = {
        position = {
          p.X, p.Y, p.Z
        }, size = {
          s.X, s.Y, s.Z
        }, rotation = {
          r.X, r.Y, r.Z
        }, class = c
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
    local p, s, r, c = data.position, data.size, data.rotation, data.class
    local new_obj = Instance.new(c, _parent)
    new_obj.Name = c
    new_obj.Material = "Plastic"
    new_obj.Anchored = true
    new_obj.CanCollide = true
    new_obj.Position = Vector3.new(unpack(p))
    new_obj.Rotation = Vector3.new(unpack(r))
    new_obj.Size = Vector3.new(unpack(s))
    new_obj.Transparency = 0
    task.wait(0.02)
  end
end

return module