-- Custom Built+In_Functions --
local ws, plrs, core, reps, tws
ws = game:GetService("Workspace")
plrs = game:GetService("Players")
core = game:GetService("CoreGui")
reps = game:GetService("ReplicatedStorage")
tws = game:GetService("TweenService")

local plr, built_in, x_numbers, in_script_funcs
plr = plrs.LocalPlayer
built_in, x_numbers = {
  "tpos() -- 1: vector3, 2: boolean?.",
  "find_plr() -- 1: \"self\" or \"near\" or \"randomize\".",
  "str_changed_to() -- 1: \"string to change\"?, 2: \"string changed to\".",
  "model_pos() -- 1: actual model or character model.",
  "checkdescendants() -- 1: from path? *example: workspace or workspace.folder_a*",
  "find_model() -- 1: \"near\" or \"randomize\", 2: from path?",
  "loadscriptfrom_url() -- 1: url string *raw code*, 2: from site... \"github\"?",
  "find_object_by_name() -- 1: object name?, 2: which specific class it's, example \"Part\"?",
  "find_sound() -- 1: sound name?",
  "server() -- 1: which remote instance, inf: anything as an argument.",
  "new_tool() -- 1: tool name : string.",
  "inspect_element() -- 1: table : table, 2: indent : number.",
  "raycast() -- 1: start position : vector3, 2: end position : vector3, 3: settings : table.",
  "create_tweeb() -- I'm lazy to writing more tutorials... read it from info buttons."
}, {-10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10}

local v3, cframe = {
  random = Vector3.new(x_numbers[math.random(#x_numbers)], x_numbers[math.random(#x_numbers)], x_numbers[math.random(#x_numbers)]),
  zero = Vector3.new(0, 0, 0),
  inf = Vector3.new(999999999, 999999999, 999999999),
  own = plr.Character:GetBoundingBox().Position
}, {
  zero = CFrame.new(0, 0, 0)
}

in_script_funcs = {
  find_txt_box = function(name_func)
    local found = nil
    for _, box in next, core:GetDescendants() do
      if box:IsA("TextBox") and box.Text:match(name_func) then
        found = box
      end
    end return found
  end,
  find_full_name = function(_input)
    for _, usr in pairs(plrs:GetPlayers()) do
      if (usr.Name:lower():sub(1, #_input) or usr.DisplayName:lower():sub(1, #_input)) == _input:lower() then
        return usr
      end
    end
  end
}

local mt_table = {}
mt_table.__index = mt_table

function mt_table:Play()
  print("Play? what play.... i could not find your sound-track name!") return nil
end

function mt_table:Pause()
  print("Pause what... ?") return nil
end

function tpos(pos, origin)
  local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
  local d = {o = hrp.Position, p = pos or nil, t = origin or false}
  if d.p ~= nil and typeof(d.p):lower() == "vector3" then
    hrp.CFrame = CFrame.new(d.p)
    if d.t ~= false then task.wait(0.02)
      hrp.CFrame = CFrame.new(d.o)
    end
  else print("<tpos: vector3, boolean>")
  end
end

function checkdescendants(_path, depth_mode)
    local ts_path = _path or nil
    local d_mode = depth_mode or 0
    if not ts_path then print("<checkdescendants: path, depth_mode?>")
        return "missing argument 1: path, example workspace"
    end 
    
    local function getstructure(obj, indent, is_shallow)
        local res = "{\n"
        local children = obj:GetChildren()
        for i, c in ipairs(children) do
            local spaces = string.rep("  ", indent)
            res = res .. spaces .. c.Name .. " = "
            if #c:GetChildren() > 0 and is_shallow == 0 then
                res = res .. getstructure(c, indent + 1, is_shallow)
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
    local str = getstructure(ts_path, 2, d_mode)
    return "{\n  " .. ts_path.Name .. " = " .. str .. "\n}"
end

function inspect_element(t, time)
    time = time or 0 local structure = string.rep(" ", time) .. "{\n"
    for a, b in pairs(t) do local _istype = type(b)
        if _istype == "table" then structure = structure .. string.rep(" ", time + 4) .. a .. " = {\n"
            structure = structure .. _return_structure(b, time + 8)
            structure = structure .. string.rep(" ", time + 4) .. "}\n"
        elseif _istype == "function" then structure = structure .. string.rep(" ", time + 4) .. a .. " = function: " .. tostring(b) .. "\n"
        elseif _istype == "boolean" then structure = structure .. string.rep(" ", time + 4) .. a .. " = " .. tostring(b) .. "\n"
        elseif _istype == "number" then structure = structure .. string.rep(" ", time + 4) .. a .. " = " .. b .. "\n"
        elseif _istype == "string" then structure = structure .. string.rep(" ", time + 4) .. a .. " = \"" .. b .. "\"\n"
        elseif _istype == "nil" then structure = structure .. string.rep(" ", time + 4) .. a .. " = nil\n"
        end end structure = structure .. string.rep(" ", time) .. "}\n"
    return structure
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
                    local dst = (mdl:GetBoundingBox().Position - plr.Character.HumanoidRootPart.Position).magnitude
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

function find_plr(method, incl)
  local is_method = method or nil
  local sec_argument = incl or nil
  if method == "self" then return plr
  elseif method == "randomize" then
    return plrs:GetPlayers()[math.random(1, #plrs:GetPlayers())]
  elseif method == "near" then
  local d = {f = nil, m = math.huge}
  for _, usr in pairs(plrs:GetPlayers()) do
    if usr ~= plr and usr and usr.Character and usr.Character:FindFirstChild("HumanoidRootPart") then
      local dst = (usr.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).magnitude
      if dst < d.m then
        d.m = dst
        d.f = usr
      end
    end
  end if d.f ~= nil then return d.f
    else print("Failed: found " .. #plrs:GetPlayers() .. " players are in the server!")
  end else if is_method and type(is_method) == "string" then
      local user_founded, alt_found = nil, {}
      if sec_argument and type(sec_argument) == "string" then
        local target_usr = in_script_funcs.find_full_name(is_method)
        if not target_usr then return nil end
        table.insert(alt_found, target_usr)
        for _, usr_alt in pairs(plrs:GetPlayers()) do
          if usr_alt and usr_alt:IsFriendsWith(target_usr.UserId) then
            table.insert(alt_found, usr_alt)
          end
        end return alt_found
      else
        user_founded = in_script_funcs.find_full_name(is_method)
        return user_founded
      end
    else print("Missing argument: #1 \"near\" or \"self\" or \"randomize\" or player-name.")
    end
  end
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
  for _, tbox in next, core:GetDescendants() do
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

function find_sound(name)
  local inGame_Folder = ws:FindFirstChild("HHxScripts")
  local sound = nil
  if inGame_Folder then
    sound = inGame_Folder.Assets.Audios:FindFirstChild(name)
  end if sound then return sound else
    print("Could not find: " .. name .. " sound obj... ")
    return setmetatable({}, mt_table)
  end
end

function server(ins, ...)
  local is_instance = ins or nil
  if is_instance ~= nil then
    if is_instance.ClassName == "RemoteEvent" then
      is_instance:FireServer(...)
    elseif is_instance.ClassName == "RemoteFunction" then
      is_instance:InvokeServer(...)
    else print("Argument: #1 Invalid... must be an Remote(Event/Function) !")
    end
  else print("Missing argument: #1")
  end
end

function new_tool(name)
  local xtool = Instance.new("Tool", plr.Backpack)
  xtool.Name = name or "unknown item"
  xtool.RequiresHandle = false
  return xtool
end

function raycast(pos, direction, datas)
    pos = pos or nil
    direction = direction or nil
    datas = datas or nil
    if not pos then
        print("Missing argument: #1 Start Position : Vector3.")
        return nil
    end if not direction then
        print("Missing argument: #2 End Position : Vector3.")
        return nil
    end if not datas then
        return ws:Raycast(pos, direction - pos)
    end
end

function create_tween(...)
  local tween_info = {...}
  if #tween_info > 0 then
    return tws:Create(tween_info[1], TweenInfo.new(tween_info[2], Enum.EasingStyle[tween_info[3]], Enum.EasingDirection[tween_info[4]]), tween_info[5])
  else
    print("Missing argument: #1 Tweening Object : instance, #2 Tweening finish in seconds : numberic, #3 Tweening Style : string, #4 Tweening Direction : string, #5 Tweening Property : table.")
    return nil
  end
end

function built_in_funcs()
  local tbox_found = nil
  local text_rs = ""
  for _, tbox in next, core:GetDescendants() do
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

-- APIs Listed --
tpos()~Teleport user to specific position then return to origin... <argument: #1 position : vector3, #2 reverse to origin : boolean>@
find_plr()~Return specific player... <argument: #1 "near" or "self" or "randomize" or player-name : string, #2 any string to include alt : string>@
str_changed_to()~Change a string inside codes editor to something else... <argument: #1 current_string : string, #2 new_string : string>@
model_pos()~Return position of a model... <argument: #1 model or user-character : instance>@
checkdescendants()~Return string structured of path childrens... <argument: #1 path : instance, #2 mode : numberic>@
find_model()~Return specific model from path... <argument: #1 "near" or "randomize" : string, #2 path : instance>@
loadscriptfrom_url()~Load source into codes editor from url, site... <argument: #1 url : string, #2 "git" or nil : string> if having argument 2 "git" then argument 1 can start from user-name to main-source.@
find_object_by_name()~Return object by name and which class... <argument: #1 name of an object : string, #2 class name : string>@
built_in_funcs()~<OLD VERSION FUNC> Load built in func tutorial into codes editor... <void>@
find_sound()~Return a sound-track sound object from inside my own folder created on games... <argument: #1 sound name : string>@
server()~Sending items to server... <argument: #1 remote event or function : instance, #inf anything : any>@
new_tool()~Return a tool object into backpack... no handles require. <argument: #1 tool name : string>@
inspect_element()~Return what inside a table, structure as a string... <argument: #1 table to check : table, #2 spaces : numberic>@
raycast()~Return raycastresult... <argument: #1 start position : vector3, #2 end position : vector3, #3 settings : table>@
create_tween()~Return tweening progress... tws:Create(...) but make it as a function just for short <argument: #1 object to tweening : instance, #2 finish in seconds : numberic, #3 tweening style : string, #4 tweening direction : string, #5 tweening property : table>@
