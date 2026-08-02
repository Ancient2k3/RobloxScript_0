local x = function(i, p) return i[p] end
return {
  ["Folder"] = {
    ["Name"] = x(i, "Name")
  },
  ["Sound"] = {
    ["Name"] = x(i, "Name"),
    ["SoundId"] = x(i, "SoundId")
  }
}
