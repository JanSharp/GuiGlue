
---@class _any

---@alias EventConditionFun fun(inst: GuiInst):boolean

---@class GuiInst : LuaGuiElementadd_param, GuiClass
---@field id integer
---@field name string|nil
---@field class string
---@field elem LuaGuiElement
---@field parent GuiInst
---@field core GuiInst|nil
---@field children GuiInst[]
---@field elem_mods table<string, _any>|nil
---@field style_mods table<string, _any>|nil

---@class GuiClass
---@field class_name string
---@field create fun(params?: table): GuiInst, table<_any, _any>|nil
---@field on_elem_created fun(inst: GuiInst)
---@field on_create fun(inst: GuiInst)
---@field on_destroy fun(inst: GuiInst)
---@field event_conditions table<string, EventConditionFun>

---@class GuiChild
---@field class string @ class_name
---@field name string|nil
---@field core GuiInst|nil

---@class BasicGuiInst : GuiInst
---@field core GuiInst|nil
---@field name_for_events string|nil
---@field parent_event_names string[]

-- fix semantics