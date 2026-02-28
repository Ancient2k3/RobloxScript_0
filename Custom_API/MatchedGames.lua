local lists = {
  [994732206] = "BloxFruits",
  [3754482795] = "ElementalTycoons",
  [3808081382] = "TSB"
}

local url = lists[game.GameId] or ""
if url ~= "" then
  return game:HttpGet("https://raw.githubusercontent.com/Ancient2k3/RobloxScript_0/refs/heads/main/Custom_API/Games_API/" .. url .. ".lua")
else
  return ""
end
