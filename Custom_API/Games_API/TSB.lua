local ws = game:GetService("Workspace")

local vars = {
  debug_pr = false
}

function debug_print()
  vars.debug_pr = not vars.debug_pr
  return ({["true"] = "Debug print enabled for all built in functions.", ["false"] = "Debug print just disabled."})[tostring(vars.debug_pr)]
end

function no_mesh()
  local folder = ws:FindFirstChild("Thrown")
  if folder and folder:GetAttribute("NO_MESH") == nil then
    folder:Destroy()
    task.wait(1.25)
    local new_folder = Instance.new("Folder", ws)
    new_folder:SetAttribute("NO_MESH", true)
    new_folder.Name = "Thrown"
    new_folder.ChildAdded:Connect(function(child)
      if new_folder:GetAttribute("NO_MESH") == tru e then
      if vars.debug_pr then
        print("Removed Item: " .. child.Name .. " from " .. child.Parent.Name)
      end child:Destroy()
      end
    end)
  end
end

-- APIs Listed --
debug_print()~Toggle debug print on another built in functions... <void>@
no_mesh()~Removing some mesh, it's reason create lag on expierence... <void>@