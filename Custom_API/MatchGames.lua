local lists = {
  [] = "BloxFruits"
}

local url = lists[game.GameId] or ""
if url ~= "" then
  return game:HttpGet("https://raw.githubusercontent.com/Ancient2k3/RobloxScript_0/Custom_API/Games_API/" .. url .. ".lua")
else
  return ""
end
