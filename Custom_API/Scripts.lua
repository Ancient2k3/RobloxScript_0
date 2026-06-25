-- Custom Built+In_Functions --
local ws, plrs, core, reps, tws, vim, txcs, htps, tps, asts
ws = game:GetService("Workspace")
plrs = game:GetService("Players")
core = game:GetService("CoreGui")
reps = game:GetService("ReplicatedStorage")
tws = game:GetService("TweenService")
vim = game:GetService("VirtualInputManager")
txcs = game:GetService("TextChatService")
htps = game:GetService("HttpService")
tps = game:GetService("TeleportService")
asts = game:GetService("AssetService")

local plr, built_in, x_numbers, in_script_funcs
plr = plrs.LocalPlayer
built_in, x_numbers = {
  "tpos() -- 1: vector3, 2: boolean?, 3: number.",
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
  "create_tween() -- I'm lazy to writing more tutorials... read it from info buttons.",
  "-- this function is useless for now... --"
}, {-10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10}

local HHxScripts = _G.HHxScripts or getgenv().HHxScripts
local Encoder, Map
if HHxScripts then
  Encoder = HHxScripts.Encoder
  Map = HHxScripts.Map
end

local v3, cframe = {
  random = Vector3.new(x_numbers[math.random(#x_numbers)], x_numbers[math.random(#x_numbers)], x_numbers[math.random(#x_numbers)]),
  zero = Vector3.new(0, 0, 0),
  inf = Vector3.new(999999999, 999999999, 999999999),
  own = plr.Character:GetBoundingBox().Position,
  mouse = plr:GetMouse().Hit.p,
  m_direction = (plr:GetMouse().Hit.p - plr.Character:GetBoundingBox().Position).Unit
}, {
  zero = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0)
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
      if usr.Name:lower():sub(1, #_input) == _input:lower() or usr.DisplayName:lower():sub(1, #_input) == _input:lower() then
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

function tpos(pos, origin, delay_time)
  local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
  local d = {o = hrp.Position, p = pos or nil, t = origin or false, s = delay_time or 0.02}
  if d.p ~= nil and typeof(d.p):lower() == "vector3" then
    hrp.CFrame = CFrame.new(d.p)
    if d.t ~= false then task.wait(d.s)
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
            structure = structure .. inspect_element(b, time + 8)
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

function find_plr(targeted, objection)
  local t, obj = targeted or nil, objection or nil
  local everyone = plrs:GetPlayers()
  if type(t) == "string" then
    if t == "near" then
      local nearest_from = nil
      if obj == nil then
        nearest_from = plr
      else
        if obj and type(obj) == "userdata" then
          nearest_from = obj
        elseif obj and type(obj) == "number" then
          if obj == 1 then
            print("Idk what to making yet... this for now, does nothing.")
            nearest_from = plr
          end
        else
          print("Invalid type of argument: #2\n• player or number expected.")
        end
      end local atlas = {near = nil, best_dist = math.huge}
      for _, out in pairs(everyone) do
        if out ~= nearest_from and out and out.Character then
          local dist = (out.Character:GetBoundingBox().Position - nearest_from.Character:GetBoundingBox().Position).magnitude
          if dist < atlas.best_dist then
            atlas.best_dist = dist
            atlas.near = out
          end
        end
      end if atlas.near then return atlas.near else print("No nearest target can be found!") end
    elseif t == "randomize" then
      return everyone[math.random(1, #everyone)]
    else
      if obj and type(obj) == "number" and obj > 0 then
        local these = {}
        local this_guy = plrs[in_script_funcs.find_full_name(t).Name]
        if not this_guy then print("Player naming started with keys " .. t .. ", it seem like doesnt exist in the server.") return end
        for _, out in pairs(everyone) do
          if out and out:IsFriendsWith(this_guy.UserId) then
            table.insert(these, out)
          end
        end table.insert(these, this_guy)
        return these[math.random(1, #these)]
      end
      return plrs[in_script_funcs.find_full_name(t).Name]
    end
  end
end

function inst(class_name, local_name, parent_name)
  local instances_list = loadstring(game:HttpGet("https://raw.githubusercontent.com/Ancient2k3/RobloxScript_0/refs/heads/main/Custom_API/QuickInstances.lua"))()
  local box = in_script_funcs.find_txt_box("inst%(")
  local name_instance = instances_list[class_name:lower()] or "empty"
  local args = {
    name = local_name or nil,
    parent = parent_name or nil
  }
  if box then
    if name_instance ~= "empty" and args.name == nil and args.parent == nil then
      box.Text = box.Text:gsub("inst%b()", name_instance:gsub("AK", class_name):gsub("EF", "Parented-With?"))
    elseif name_instance ~= "empty" and args.name ~= nil and args.parent == nil then
      box.Text = box.Text:gsub("inst%b()", name_instance:gsub("AK", args.name):gsub("EF", "Parented-With?"))
    elseif name_instance ~= "empty" and args.name ~= nil and args.parent ~= nil then
      box.Text = box.Text:gsub("inst%b()", name_instance:gsub("AK", args.name):gsub("EF", args.parent))
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

function anim_id(humanoid)
  if humanoid ~= nil then
    return humanoid:GetPlayingAnimationTracks()[1].Animation.AnimationId
  else
    print("<anim_id: humanoid, can't be nil>")
  end
end

function my_module(_path)
  if typeof(_path) == "string" then
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/Ancient2k3/" .. _path))()
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

function list_places()
  local map = asts:GetGamePlacesAsync():GetCurrentPage()
  local out = {}
  for i = 1, #map do
    out[map[i].Name] = map[i].PlaceId
  end return out
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

function simulate_input(name)
  vim:SendKeyEvent(true, Enum.KeyCode[name], false, game) task.wait(0.02)
  vim:SendKeyEvent(false, Enum.KeyCode[name], false, game)
end

function find_root(target, root_name)
  return target and target.Character and target.Character:FindFirstChild(root_name) or nil
end

function chat_str(str)
  local is_legacy_chat = txcs.ChatVersion == Enum.ChatVersion.LegacyChatService
  local message = tostring(str)
  if not is_legacy_chat then
    txcs.TextChannels.RBXGeneral:SendAsync(message)
  else
    reps.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(message, "All")
  end
end

--// Gonna updating this soon //--
function from_url(url)
  if type(url) == "string" then
    if url:sub(1, 8) == "https://" then
      return htps:JSONDecode(game:HttpGet(url))
    else
      print("Invalid type, only accept \"https\" kind of...")
    end
  else
    print("<argument: #1 url : string>")
  end
end

function through(t, s) for i, v in next, t do s(i, v) end end
function is(t, s, es) if t then s() else es() end end

function play_anim(t, anim_id)
  if t ~= nil and t.ClassName == "Humanoid" then
    if anim_id ~= nil and type(anim_id) == "string" then
      local obj = core["CodesEditor_xScripts"].Assets._Animation_Instance
      obj.AnimationId = anim_id
      t:LoadAnimation(obj):Play()
    else
      print("Invalid argument: #2 not a string.")
    end
  else
    print("<argument: #1 humanoid : instance, #2 animation id : string>")
  end
end

function chatted(t, s)
  if type(t) ~= "userdata" then print("argument: #1 must be a player...") return end
  if type(s) ~= "function" then print("argument: #2 must be a function...") return end
  t.Chatted:Connect(function(v) s(v) end)
end
--// End //--

function create_tween(...)
  local tween_info = {...}
  if #tween_info > 0 then
    return tws:Create(tween_info[1], TweenInfo.new(tween_info[2], Enum.EasingStyle[tween_info[3]], Enum.EasingDirection[tween_info[4]]), tween_info[5])
  else
    print("Missing argument: #1 Tweening Object : instance, #2 Tweening finish in seconds : numberic, #3 Tweening Style : string, #4 Tweening Direction : string, #5 Tweening Property : table.")
    return nil
  end
end

function find_jobid(pid)
  local url = "https://games.roblox.com/v1/games/" .. pid .. "/servers/Public?sortOrder=Asc&limit=100&excludeFullGames=true"
  local map = htps:JSONDecode(game:HttpGet(url))
  local counts, servers_list = {}, {}
  if map and map.data then
    for _, body in next, map.data do
      if body.playing then
        table.insert(counts, tonumber(body.playing))
      end
    end table.sort(counts)
    for _, body in next, map.data do
      if body.playing and tonumber(body.playing) == counts[1] then
        table.insert(servers_list, tostring(body.id))
      end
    end
  end return servers_list
end

function tplace(place_id, job_id)
  local success, err = pcall(function()
    tps:TeleportToPlaceInstance(place_id, job_id, plr)
  end) if success then print("Teleporting... ") else print("Teleport Failed, Error: " .. tostring(err) .. ".") end
end

function tgame(id)
  local success, err = pcall(function()
    tps:Teleport(id)
  end) if success then print("Teleporting... ") else print("Teleport Failed, Error: " .. tostring(err) .. ".") end
end

function show_bytes(str)
  local bytes = #str
  local units, unit_index = {"B", "kB", "MB", "GB", "TB"}, 1
  while bytes >= 1000 and unit_index < #units do
    bytes /= 1000
    unit_index += 1
  end print(string.format("%.2f %s", bytes, units[unit_index]))
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
tpos()~Teleport user to specific position then return to origin... <argument: #1 position : vector3, #2 reverse to origin : boolean, #3 delayed time : number>@
find_plr()~Return specific player... <argument: #1 "near" or "randomize" or player-name : string, #2 player-instance or number 1 = include alt : anything>@
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
inst()~Basically an Instance.new(...) and properties... on code editor. <argument: #1 class name : string>@
anim_id()~Return AnimationId get from an Humanoid... <argument: #1 character humanoid : instance>@
simulate_input()~Simulating a specific key pressing... <argument: #1 keycode : string>@
find_root()~Return an character basepart... <argument: #1 player : instance, #2 basepart name : string>@
chat_str()~Sending an string into chatbox... <argument: #1 message : string>@
from_url()~Return anything you want from an url... <argument: #1 json data : string>@
play_anim()~Play animation on humanoid... <argument: #1 humanoid : instance, #2 animation id : string>@
through()~Just for short, this is for i,v loop through table... <argument: #1 table to loop through : table, #2 function with i and v as first and second argument : function>@
is()~Same as through() just for short this is if-statement... <argument: #1 condition : anything, #2 function if true : function, #3 function if false : function>@
chatted()~It's user.Chatted:Connect(func()) but for short... <argument: #1 player : userdata, #2 function, first argument is returning a string : function>@
list_places()~Return a table storing all expierance from a universe... <argument: nil>@
find_jobid()~Return a table storing 30 different server jobid from a placeid... <argument: #1 placeid : numberic>@
tplace()~Teleport to specific place... <argument: #1 placeid : numberic, #2 jobid : string>@
tgame()~Teleport to specific expierance/game... <argument: #1 gameid : numberic>@
show_bytes()~Printing output showing how many bytes from a string... <argument: #1 string to check : string>