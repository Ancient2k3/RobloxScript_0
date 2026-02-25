-- Custom Built+In_Functions --
local zx, zc, zv
zx = game:GetService("Workspace")
zc = game:GetService("Players")
zv = game:GetService("CoreGui")

local xz, built_in, in_script_funcs
xz = zc.LocalPlayer
built_in = {
  "tpos() -- 1: vector3, 2: boolean?.",
  "find_plr() -- 1: \"self\" or \"near\".",
  "str_changed_to() -- 1: \"string to change\"?, 2: \"string changed to\".",
  "model_pos() -- 1: actual model or character model.",
  "checkdescendants() -- 1: from path? *example: workspace or workspace.folder_a*",
  "find_model() -- 1: \"near\" or \"randomize\", 2: from path?",
  "loadscriptfrom_url() -- 1: url string *raw code*, 2: from site... \"github\"?",
  "find_object_by_name() -- 1: object name?, 2: which specific class it's, example \"Part\"?"
}

in_script_funcs = {
  find_txt_box = function(name_func)
    local found = nil
    for _, box in next, zv:GetDescendants() do
      if box:IsA("TextBox") and box.Text:match(name_func) then
        found = box
      end
    end return found
  end
}

function tpos(pos, origin)
  local hrp = xz.Character:FindFirstChild("HumanoidRootPart")
  local d = {o = hrp.Position, p = pos or nil, t = origin or false}
  if d.p ~= nil and typeof(d.p):lower() == "vector3" then
    hrp.CFrame = CFrame.new(d.p)
    if d.t ~= false then task.wait(0.02)
      hrp.CFrame = CFrame.new(d.o)
    end
  else print("<tpos: vector3, boolean>")
  end
end

function checkdescendants(_path)
    local ts_path = _path or nil
    if not ts_path then print("<checkdescendants: path>")
        return "missing argument 1: path, example workspace"
    end local function getstructure(obj, indent)
        local res = "{\n"
        local children = obj:GetChildren()
        for i, c in ipairs(children) do
            local spaces = string.rep("  ", indent)
            res = res .. spaces .. c.Name .. " = "
            if #c:GetChildren() > 0 then
                res = res .. getstructure(c, indent + 1)
            else
                res = res .. "{}"
            end
            if i < #children then
                res = res .. ",\n"
            else
                res = res .. "\n"
            end
        end
        res = res .. string.rep("  ", indent - 1) .. "}"
        return res
    end
    local str = getstructure(ts_path, 2)
    return "{\n  " .. ts_path.Name .. " = " .. str .. "\n}"
end

function find_model(method, _path)
    local f_method = method or nil
    local f_path = _path or nil
    if not f_method then print("<find_model: \"near\" or \"randomize\", path>")
        return "missing argument 1: aka some method"
    else if not f_path then print("<find_model: " .. f_method .. ", path?>")
            return "missing argument 2: path, example workspace"
        end
    end if #f_path:GetChildren() > 0 then
        if f_method == "near" then
            local d = {n = nil, m = math.huge}
            for _, mdl in pairs(_path:GetChildren()) do
                if mdl:IsA("Model") then
                    local dst = (mdl:GetBoundingBox().Position - xz.Character.HumanoidRootPart.Position).magnitude
                    if dst < d.m then
                        d.m = dst
                        d.n = mdl
                    end
                end
            end return d.n
        elseif f_method == "randomize" then
            return f_path:GetChildren()[math.random(1, #f_path:GetChildren())]
        end
    else print("Failed: " .. f_path.Name .. " does not exist any child which is a model.")
        return "no childrens"
    end
end

function find_plr(method)
  if method == "self" then return xz
  elseif method == "near" then
  local d = {f = nil, m = math.huge}
  for _, usr in pairs(zc:GetPlayers()) do
    if usr ~= xz and usr and usr.Character and usr.Character:FindFirstChild("HumanoidRootPart") then
      local dst = (usr.Character.HumanoidRootPart.Position - xz.Character.HumanoidRootPart.Position).magnitude
      if dst < d.m then
        d.m = dst
        d.f = usr
      end
    end
  end if d.f ~= nil then return d.f
    else print("Failed: found " .. #zc:GetPlayers() .. " players are in the server!")
  end else print("<find_plr: set method \"self\" or \"near\".") end
end

function loadscriptfrom_url(url, f_site)
  local x_site = f_site
  local s_time = tick()
  local script_str = ""
  if not url then
    print("<loadscriptfr...: url string, site>")
    return "missing argument 1: url string"
  end
  if type(url) ~= "string" then
    print("<loadscriptfr...: not a string, ...>")
    return "argument 1: url must be a string"
  end
  if x_site and type(x_site) == "string" and x_site:lower():match("git") then
    script_str = game:HttpGet("https://raw.githubusercontent.com/" .. url)
  else
    if not url:match("^https://") then
      print("<loadscriptfr...: invalid, ...>")
      return "argument 1: invalid"
    end
    script_str = game:HttpGet(url)
  end task.wait(0.02)
  local box = in_script_funcs.find_txt_box("loadscriptfrom_url%(")
  if box then
    if script_str:lower():match(" 404") then
      script_str = "Script does not exist..."
    end
    box.Text = "-- Loaded Successfully In "
      .. tostring(tick() - s_time):sub(1,4)
      .. " Seconds --\n"
      .. script_str
  else
    print("Failed: function error...")
  end
end

function str_changed_to(str, change)
  local tbox_found = nil
  local d = {o = str or nil, c = change or nil}
  for _, tbox in next, zv:GetDescendants() do
    if tbox:IsA("TextBox") and tbox.Text:match("str_changed_to") then
      tbox_found = tbox
    end
  end if tbox_found ~= nil then
    if d.o ~= nil and d.c ~= nil then
      tbox_found.Text = tbox_found.Text:gsub("str_changed_to%b()", "") task.wait(0.02)
      tbox_found.Text = tbox_found.Text:gsub(str, change)
    else print("<str_changed_to: string, new_string>") end
  else print("Failed: function error... ")
  end
end

function model_pos(model)
  local md = model or nil
  if md ~= nil then return md:GetBoundingBox().Position
  else print("<model_pos: model or character>")
  end
end

function find_object_by_name(name, class)
  if not name then print("<find_object_by_name: name, class?>")
    return "missing argument 1: object name"
  end local found = nil
  for _, obj in pairs(game:GetDescendants()) do
    if obj.Name == name then
      if class then
        if obj:IsA(class) then found = obj
          break
        end
      else found = obj
        break
      end
    end
  end if found then return found
  else print("Failed: no object named \"" .. name .. "\" was found.")
    return "object not found"
  end
end

function built_in_funcs()
  local tbox_found = nil
  local text_rs = ""
  for _, tbox in next, zv:GetDescendants() do
    if tbox:IsA("TextBox") and tbox.Text:match("built_in_funcs()") then
      tbox_found = tbox
    end
  end if tbox_found ~= nil then
    for i, nf in pairs(built_in) do
      text_rs = text_rs .. nf .. "\n"
    end tbox_found.Text = text_rs
  else print("Failed: function error... ")
  end
end

-- Hehe --