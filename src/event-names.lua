
---@type table<string, string>
local event_names = {}

local find = string.find
local match = string.match

---@type string
for name in pairs(defines.events) do
  if find(name, "^on_gui_") then
    local event_name = match(name, "^on_gui_(.*)$")
    event_names[event_name] = event_name
  end
end

return event_names

-- fix semantics