-- Saving & Reload: Baseparts --
local ws = game:GetService("Workspace")
local plrs = game:GetService("Players")
local htps = game:GetService("HttpService")
local coreui = game:GetService("CoreGui")

local module = {}
local plr, folder_1, _object, folder_2
plr = plrs.LocalPlayer

if not coreui:FindFirstChild("CodesEditor_xScripts") then
  folder_2 = Instance.new("Folder", coreui)
  folder_2.Name = "CodesEditor_xScripts"
end

if not ws:FindFirstChild("_ScriptFolder") then
  folder_1 = Instance.new("Folder", ws)
  folder_1.Name = "_ScriptFolder"
  -- Nothing here... --
  _object = Instance.new("Part", folder_1)
  _object.Name = "Origin_Point"
  _object.Transparency = 1
  _object.Anchored = true
  _object.CanCollide = false
  _object.Material = "Neon"
  _object.Color = Color3.new(1, 0, 1)
  _object.Size = Vector3.new(0.5, 0.5, 0.5)
  _object.Position = Vector3.new(0, 9999, 0)
else
  _object = ws._ScriptFolder.Origin_Point
end

function _idk_man(is_num)
  local char = plr and plr.Character
  if char then
    if is_num > 0 then
      _object.Position = char:GetBoundingBox().Position
      _object.Transparency = 0.25
    else
      _object.Position = Vector3.new(0, 9999, 0)
      _object.Transparency = 1
    end
  end
end function _set_transparency(num) _object.Transparency = num end

module.CACHE = {}

module.SAVE = function(_path)
  local counts, kind_of, data_map, start_tick = 1, {"Part", "MeshPart", "TrussPart"}, {}, tick()
  _idk_man(1)
  for _, valid_obj in pairs(_path:GetDescendants()) do
    if valid_obj and table.find(kind_of, valid_obj.ClassName) then
      valid_obj.Parent = _path
    end task.wait(0.01)
  end task.wait(0.2)
  local amount_of_child = #_path:GetChildren()
  for _, obj in pairs(_path:GetChildren()) do
    if obj and table.find(kind_of, obj.ClassName) then
      local p, s, r, c, clr, _mat, _trans = obj.Position - _object.Position, obj.Size, obj.Rotation, obj.ClassName, obj.Color, obj.Material, obj.Transparency
      data_map["object_" .. tostring(counts)] = {
        position = {
          p.X, p.Y, p.Z
        }, size = {
          s.X, s.Y, s.Z
        }, rotation = {
          r.X, r.Y, r.Z
        }, class = c,
        color = {clr.R * 255, clr.G * 255, clr.B * 255}, material = tostring(_mat):split(".")[3], transparency = tonumber(_trans)
      } if c == kind_of[1] then 
        data_map["object_" .. tostring(counts)].shape = tostring(obj.Shape):split(".")[3]
      end counts = counts + 1
      _set_transparency(counts / amount_of_child) task.wait(0.01)
    end
  end local out = htps:JSONEncode(data_map)
  print("It's finished in " .. tostring(tick() - start_tick) .. " seconds !\nOutput: " .. out:sub(1, 1000) .. "...and more.")
  table.insert(module.CACHE, out)
  _idk_man(0)
  print("[MAP: Check #Map.CACHE...]")
  return out
end

module.LOAD = function(_parent, t)
  local counts = 0
  if type(t) ~= "string" then return "argument 2 not a string." end
  t = htps:JSONDecode(t)
  _idk_man(1)
  for i, _ in pairs(t) do
    counts = counts + 1
    task.wait(0.01)
  end task.wait(0.02)
  for idx = 1, counts do
    local data = t["object_" .. tostring(idx)]
    local p, s, r, c, clr, _mat, _trans = data.position, data.size, data.rotation, data.class, data.color, data.material, data.transparency
    local new_obj = Instance.new(c, _parent)
    new_obj.Name = c
    if c == "Part" and data and data.shape then
      new_obj.Shape = data.shape
    end
    new_obj.Material = Enum.Material[_mat]
    new_obj.Anchored = true
    new_obj.CanCollide = true
    new_obj.Position = _object.Position + Vector3.new(unpack(p))
    new_obj.Rotation = Vector3.new(unpack(r))
    new_obj.Size = Vector3.new(unpack(s))
    new_obj.Color = Color3.fromRGB(unpack(clr))
    new_obj.Transparency = _trans
    _set_transparency(idx / counts) task.wait(0.01)
  end _idk_man(0)
  print("[MAP: Finished Loading Map...]")
end

return module