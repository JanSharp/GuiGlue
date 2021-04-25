
---@class _any

---@alias EventConditionFun fun(inst: GuiInst):boolean

---@class GuiInst : LuaGuiElementadd_param
---@field id integer
---@field name string|nil
---@field class_name string
---@field elem LuaGuiElement
---@field parent GuiInst
---@field children GuiInst[]
---@field elem_mods table<string, _any>|nil
---@field style_mods table<string, _any>|nil

---@class GuiClass
---@field class_name string
---@field create fun(params?: table): GuiInst, table<_any, _any>|nil
---@field on_elem_created fun(inst: GuiInst)
---@field on_create fun(inst: GuiInst)
---@field event_conditions table<string, EventConditionFun>

---@class BasicGuiInst : GuiInst
---@field core GuiInst|nil
---@field name_for_events string|nil
---@field parent_event_names string[]

-- fix semantics