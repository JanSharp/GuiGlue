
local gui = require("gui")
local class_names = require("basic-class-names")
local event_name_map = require("basic-class-event-map")

---@type table<string, string[]>
local all_full_event_names = {}
---@type table<string, string[]>
local all_fuller_event_names = {}
for class_name, event_names in pairs(event_name_map) do
  local full_event_names = {}
  all_full_event_names[class_name] = full_event_names
  local fuller_event_names = {}
  all_fuller_event_names[class_name] = fuller_event_names

  for _, event_name in pairs(event_names) do
    local full_name = "on_" .. event_name
    full_event_names[#full_event_names+1] = full_name
    fuller_event_names[#fuller_event_names+1] = full_name .. '_'
  end
end

-- create and register classes
for _, class_name in pairs(class_names) do
  local full_event_names = all_full_event_names[class_name]
  local fuller_event_names = all_fuller_event_names[class_name]

  ---@type GuiClass
  local class = {
    class_name = class_name,
    create = params => {
      params.type = class_name
      params.core = nil
      local data = params.data
      params.data = nil
      return params, data
    },
    event_conditions = {},

    on_elem_created = self => { -- init parent_event_names so they only get evaluated once
      local name_for_events = self.name_for_events or self.name
      if not name_for_events then return end -- without a name, events will never be passed through
      self.name_for_events = name_for_events
      local parent_event_names = {}
      self.parent_event_names = parent_event_names
      for _, event_name in ipairs(fuller_event_names) do
        parent_event_names[#parent_event_names+1] = event_name .. name_for_events
      end
    },
  }

  for i, event_name in ipairs(full_event_names) do -- event conditions and event handlers
    ---@param self BasicGuiInst
    ---@return boolean
    class.event_conditions[event_name] = self => { -- this means event handlers only get subscribed if the core actually defines a handler for it and self has a name
      if self.name_for_events then
        local core = self.core
        return core and core[self.parent_event_names[i]]
      end
      return false
    }
    ---@param self BasicGuiInst
    ---@param event on_gui_click (or any other gui event)
    class[event_name] = (self, event) => { -- the event handler, no checks thanks to event_conditions
      local core = self.core
      core[self.parent_event_names[i]](core, self, event)
    }
  end

  gui.register_class(class)
end

-- fix semantics