
-- TODO
---@diagnost ic disable

local event_names = require("event-names")

---@type table<string, GuiClass>
local classes = {}
-- table<event_name, table<GuiInst.id, GuiInst>>
---@type table<string, table<number, GuiInst>>
local event_handlers = {}
-- table<class_name, evevnt_name[]>
---@type table<string, string[]>
local cached_class_events = {}
-- table<class_name, table<event_name, event_condition_func>>
---@type table<string, table<string, EventConditionFun>>
local conditional_cached_class_events = {}

local script_data
local insts
local tags_prefab

local tags_magic = 7235849015680863

local function on_load()
  script_data = global.gui_glue
  insts = script_data.insts
  tags_prefab = script_data.tags_prefab
end

local function on_init()
  ---@type GuiInst[]
  insts = {}
  ---@class tags_prefab
  tags_prefab = {
    __gui_glue_magic = tags_magic,
    id = 1,
  }
  ---@class gui_glue_script_data
  script_data = {
    insts = insts,
    tags_prefab = tags_prefab,
  }
  global.gui_glue = script_data
end

for _, event_name in pairs(event_names) do
  event_handlers[event_name] = {}
end

---@param inst GuiInst
local function add_event_handlers(inst)
  local id = inst.id
  local class_name = inst.class_name
  for _, event_name in pairs(cached_class_events[class_name]) do
    event_handlers[event_name][id] = inst
  end
  for event_name, condition in pairs(conditional_cached_class_events[class_name]) do
    if condition(inst) then
      event_handlers[event_name][id] = inst
    end
  end
end

---@param parent_element LuaGuiElement
---@param parent GuiInst
---@param class_name string
---@param name string
---@param params table
---@return GuiInst
local function create_internal(parent_element, parent, class_name, name, params)
  local class = classes[class_name]
  if not class then
    error("No class with the 'class_name' \""..class_name.."\" registered.")
  end
  -- HACK: language server annotations being weird
  ---@typelist GuiInst, table<_any, _any>
  local inst, passed_data = class.create(params)
  setmetatable(inst, class)

  local children = inst.children
  inst.children = {} -- removing the reference to children before parent_element.add,
  -- because children may cause recursive tables

  inst.name = name
  local tags = tags_prefab
  inst.tags = tags
  -- HACK: language server annotations being weird
  ---@type LuaGuiElement
  ---@diagnostic disable-next-line: undefined-field
  local elem = parent_element.add(inst)
  inst.id = tags.id
  tags_prefab.id = tags_prefab.id + 1
  inst.elem = elem
  inst.class_name = class_name
  insts[inst.elem.index] = inst
  inst.parent = parent
  if passed_data then
    for k, v in pairs(passed_data) do
      inst[k] = v
    end
  end

  local mods = inst.elem_mods
  if mods then
    for k, v in pairs(mods) do
      elem[k] = v
    end
  end

  mods = inst.style_mods
  if mods then
    local style = elem.style
    for k, v in pairs(mods) do
      style[k] = v
    end
  end

  local on_elem_created = class.on_elem_created
  if on_elem_created then on_elem_created(inst) end

  add_event_handlers(inst)

  if children then
    ---@type table
    for _, child in pairs(children) do
      create_internal(elem, inst, child.class, child.name, child)
    end
  end

  local on_create = class.on_create
  if on_create then on_create(inst) end

  return inst
end

---@param parent_element LuaGuiElement
---@param class_name string
---@param name string
---@param params table
---@return GuiInst
local function create(parent_element, class_name, name, params)
  return create_internal(parent_element, nil, class_name, name, params)
end

---@param class GuiClass
local function register_class(class)
  -- validate_class(class)
  classes[class.class_name] = class
  class.__index = class

  local class_events = {}
  local conditional_class_events = {}
  cached_class_events[class.class_name] = class_events
  conditional_cached_class_events[class.class_name] = conditional_class_events

  for _, event_name in pairs(event_names) do
    if class["on_"..event_name] then
      local condition = class.event_conditions and class.event_conditions["on_"..event_name]
      if condition ~= nil then
        conditional_class_events[event_name] = type(condition) == "function"
          and condition
          or function() return condition end
      else
        class_events[#class_events+1] = event_name
      end
    end
  end

  -- TODO
  -- these functions will be directly accessable on the instances, because metatables
  -- class.add = gui_handler.add_child
  -- class.add_definition = gui_handler.add_child_definition
  -- class.add_children = gui_handler.add_children
  -- class.destroy = gui_handler.destroy
  -- class.got_destroyed = gui_handler.got_destroyed
end

for _, event_name in pairs(event_names) do
  local handler_name = "on_"..event_name
  local event_specific_handlers = event_handlers[event_name]

  ---@param event on_gui_click (or any other of the on_gui events)
  script.on_event(defines.events["on_gui_"..event_name], (event) => {
    if not event.element then return end -- for on_gui_closed and on_gui_opened
    local tags = event.element.tags
    if tags.__gui_glue_magic == tags_magic then
      local inst = event_specific_handlers[tags.id]
      if inst then
        inst[handler_name](inst, event)
      end
    end
  })
end

return {
  on_load = on_load,
  on_init = on_init,
  create = create,
  register_class = register_class,
}

-- fix semantics