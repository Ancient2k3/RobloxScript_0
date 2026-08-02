local x = function(i, p) return i[p] end
return {
  ["Folder"] = {
    ["Name"] = x
  },
  ["Sound"] = {
    ["Name"] = x,
    ["SoundId"] = x
  }
}
