-- Saving & Reload: Baseparts --
local ws = game:GetService("Workspace")
local plrs = game:GetService("Players")
local htps = game:GetService("HttpService")
local coreui = game:GetService("CoreGui")

local module, ui_setup = {}, {}
local plr, folder_1, _object, _OnSave, _OnLoad
plr = plrs.LocalPlayer
_OnSave = false
_OnLoad = false

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

function _visible(bl)
  if ui_setup and ui_setup.main_screen then
    local ui_0 = ui_setup.main_screen
    ui_0.Visible = bl
    if ui_0.Visible == false and ui_setup and ui_setup.loading_bar then
      ui_setup.loading_bar.Size = UDim2.new(0, 0, 0.45, 0)
    end
  end
end

function _set_layoutsize(s)
  if ui_setup and ui_setup.loading_bar then
    local ui_1 = ui_setup.loading_bar
    ui_1.Size = UDim2.new(s, 0, 0.45, 0)
  end
end

function _display_progression(i4)
  if ui_setup and ui_setup.progression_displayer then
    local ui_2 = ui_setup.progression_displayer
    ui_2.Text = " " .. i4 .. "."
  end
end

module.CACHE = {}

module.SAVE = function(_path)
  if _OnSave then print("[Wait for previous save progress complete first...]") return end
  _OnSave = true
  local counts, kind_of, data_map, start_tick = 1, {"Part", "MeshPart", "TrussPart"}, {}, tick()
  if _path == nil then _OnSave = false return end
  local _descendants = _path:GetDescendants()
  local amount_of_child = #_descendants
  _idk_man(1) _visible(true)
  for _, obj in pairs(_descendants) do
    if obj and table.find(kind_of, obj.ClassName) then
      local p, s, r, c, cr, m, t = obj.Position - _object.Position, obj.Size, obj.Rotation, obj.ClassName, obj.Color, obj.Material, obj.Transparency
      _display_progression("ADDED: " .. obj.Name:upper())
      data_map["object_" .. tostring(counts)] = {
        position = {
          p.X, p.Y, p.Z
        }, size = {
          s.X, s.Y, s.Z
        }, rotation = {
          r.X, r.Y, r.Z
        }, class = c,
        color = {cr.R * 255, cr.G * 255, cr.B * 255}, material = tostring(m):split(".")[3], transparency = tonumber(t)
      } if c == kind_of[1] then 
        data_map["object_" .. tostring(counts)].shape = tostring(obj.Shape):split(".")[3]
      end counts = counts + 1
      _set_transparency(counts / amount_of_child)
      _set_layoutsize(counts / amount_of_child) task.wait(0.01)
    end
  end local out = htps:JSONEncode(data_map)
  _display_progression("Loading:...")
  print("It's finished in " .. tostring(tick() - start_tick) .. " seconds !\nOutput: " .. out:sub(1, 1000) .. "...and more.")
  table.insert(module.CACHE, out)
  _idk_man(0) _visible(false) _OnSave = false
  print("[MAP: Check #Map.CACHE...]")
  return out
end

module.LOAD = function(_parent, t)
  if _OnLoad then print("[Wait for previous map loading complete first...]") return end
  _OnLoad = true
  local counts = 0
  if _parent == nil then _OnLoad = false return end
  if t == nil then
    if #module.CACHE > 0 then
      t = module.CACHE[1]
    else _OnLoad = false return
    end
  end t = htps:JSONDecode(t)
  _idk_man(1) _visible(true)
  for i, _ in pairs(t) do
    counts = counts + 1
    _display_progression("Loading: " .. tostring(i):upper() .. " " .. tostring(counts))
    task.wait(0.001)
  end task.wait(0.02)
  for idx = 1, counts do
    local data = t["object_" .. tostring(idx)]
    local p, s, r, c, cr, m, tsp = data.position, data.size, data.rotation, data.class, data.color, data.material, data.transparency
    _display_progression("PLACING: " .. c:upper() .. "   " .. tostring(idx) .. "/" .. tostring(counts))
    local new_obj = Instance.new(c, _parent)
    new_obj.Name = c
    if c == "Part" and data and data.shape then
      new_obj.Shape = data.shape
    end
    new_obj.Material = Enum.Material[m]
    new_obj.Anchored = true
    new_obj.CanCollide = true
    new_obj.Position = _object.Position + Vector3.new(unpack(p))
    new_obj.Rotation = Vector3.new(unpack(r))
    new_obj.Size = Vector3.new(unpack(s))
    new_obj.Color = Color3.fromRGB(unpack(cr))
    new_obj.Transparency = tsp
    _set_transparency(idx / counts)
    _set_layoutsize(idx / counts) task.wait(0.01)
  end _display_progression("Loading:...") _idk_man(0) _visible(false) _OnLoad = false
  print("[MAP: Finished Loading Map...]")
end

module.SETUP_UI = function(parent_to)
  local LoadingBG = Instance.new("Frame", parent_to)
  LoadingBG.Name = "LOADING:BG"
  LoadingBG.BackgroundTransparency = 0.25
  LoadingBG.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
  LoadingBG.Position = UDim2.new(0.4, 0, -0.12, 0)
  LoadingBG.Size = UDim2.new(0.2, 0, 0.1, 0)
  LoadingBG.Active = true
  LoadingBG.Draggable = false
  LoadingBG.Visible = false
  LoadingBG.ZIndex = 0
  Instance.new("UICorner", LoadingBG).CornerRadius = UDim.new(0.15, 0)
  ui_setup.main_screen = LoadingBG

  local LoadingLayout_0 = Instance.new("Frame", LoadingBG)
  LoadingLayout_0.Name = "Layout_0"
  LoadingLayout_0.BackgroundTransparency = 0
  LoadingLayout_0.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
  LoadingLayout_0.Position = UDim2.new(0.02, 0, 0.1, 0)
  LoadingLayout_0.Size = UDim2.new(0.96, 0, 0.45, 0)
  LoadingLayout_0.Active = true
  LoadingLayout_0.Draggable = false
  LoadingLayout_0.Visible = true
  LoadingLayout_0.ZIndex = 1
  Instance.new("UICorner", LoadingLayout_0).CornerRadius = UDim.new(0.15, 0)

  local LoadingLayout_1 = Instance.new("Frame", LoadingBG)
  LoadingLayout_1.Name = "Layout_1"
  LoadingLayout_1.BackgroundTransparency = 0.25
  LoadingLayout_1.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
  LoadingLayout_1.Position = UDim2.new(0.02, 0, 0.1, 0)
  LoadingLayout_1.Size = UDim2.new(0, 0, 0.45, 0)
  LoadingLayout_1.Active = true
  LoadingLayout_1.Draggable = false
  LoadingLayout_1.Visible = true
  LoadingLayout_1.ZIndex = 2
  Instance.new("UICorner", LoadingLayout_1).CornerRadius = UDim.new(0.15, 0)
  ui_setup.loading_bar = LoadingLayout_1

  local PR = Instance.new("TextLabel", LoadingBG)
  PR.Name = "PROGRESSION_DISPLAY"
  PR.BackgroundTransparency = 0
  PR.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
  PR.Position = UDim2.new(0.02, 0, 0.6, 0)
  PR.Size = UDim2.new(0.96, 0, 0.3, 0)
  PR.TextScaled = false
  PR.TextSize = 9
  PR.TextColor3 = Color3.fromRGB(255, 255, 255)
  PR.TextXAlignment = "Left"
  PR.Font = Enum.Font.Code
  PR.Text = " Loading:..."
  PR.Visible = true
  PR.ZIndex = 1
  Instance.new("UICorner", PR).CornerRadius = UDim.new(0.15, 0)
  ui_setup.progression_displayer = PR
end

return module
