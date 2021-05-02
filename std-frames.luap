
local gui = require("gui")
require("basic-classes")

---@class StdFrameTitleBarInst : GuiInst
---@field searching boolean
---@field search_tf BasicGuiInst
---@field name_for_events string

---@class std_frame_title_bar_params : GuiChild
---@field caption string
---@field drag_target GuiInst
---@field search_tf_name string|nil @ if this is not nil a search button and textfield will be added
---@field close_btn_name string|nil @ if this is not nil a close button will be added
---@field name_for_events string

---@type StdFrameTitleBarInst
local std_frame = {class_name = "std-frame-title-bar"}

-- TODO: move style_mods out into actual styles
-- TODO: or have a better system for defining styles in the same file/inline

---@param params std_frame_title_bar_params
---@return GuiInst
function std_frame.create(params)
  local elem_mods = {drag_target = params.drag_target.elem}
  local self = {
    type = "flow",
    direction = "horizontal",
    elem_mods = elem_mods,
    style_mods = {
      vertically_stretchable = false,
      bottom_padding = 4,
      horizontally_stretchable = true,
      horizontal_spacing = 8,
    },
    search_tf_name = params.search_tf_name,
    name_for_events = params.name_for_events,
  }
  local child_count = 2
  self.children = {
    {
      class = "label",
      caption = params.caption,
      style = "frame_title",
      elem_mods = elem_mods,
      style_mods = {
        vertically_stretchable = true,
        horizontally_squashable = true,
      },
    },
    {
      class = "empty-widget",
      style = "draggable_space_header",
      elem_mods = elem_mods,
      style_mods = {
        right_margin = 4,
        height = 24,
        natural_height = 24,
        horizontally_stretchable = true,
        vertically_stretchable = true,
      },
    },
  }
  if params.search_tf_name then
    child_count = child_count + 2
    self.children[child_count - 1] = {
      class = "textfield",
      name = params.search_tf_name,
      core = params.core,
      style = "search_popup_textfield",
      style_mods = {
        top_margin = -2,
        left_margin = -4,
      },
      visible = false,
    }
    self.children[child_count] = {
      class = "sprite-button",
      style = "close_button",
      name = "search_btn",
      core = self,
      tooltip = "TODO: search",
      sprite="utility/search_white",
      hovered_sprite="utility/search_black",
      clicked_sprite="utility/search_black",
    }
    self.searching = false
  end
  if params.close_btn_name then
    child_count = child_count + 1
    self.children[child_count] = {
      class = "sprite-button",
      style = "close_button",
      name = params.close_btn_name,
      core = params.core,
      sprite="utility/close_white",
      hovered_sprite="utility/close_black",
      clicked_sprite="utility/close_black",
    }
  end
  return self
end

function std_frame:on_elem_created()
  self.player = game.get_player(self.elem.player_index)
end

function std_frame:on_create()
  -- FIXME: i don't like this
  ---@type string
  ---@diagnostic disable-next-line: undefined-field
  local search_tf_name = self.search_tf_name
  if search_tf_name then
    self.search_tf = self.core[search_tf_name]
    self.search_tf_name = nil
  end
end

---@param search_btn GuiInst
---@param event on_gui_click
function std_frame:on_click_search_btn(search_btn, event)
  if event.button == defines.mouse_button_type.left then
    self:set_searching(not self.searching)
  end
end

---@param searching boolean
---@param surpress_event boolean @ -- FIXME: i don't like this either
function std_frame:set_searching(searching, surpress_event)
  self.searching = searching
  local search_tf_elem = self.search_tf.elem
  search_tf_elem.visible = searching
  search_tf_elem.focus() -- it seems using this right as it's being created doesn't work?

  -- FIXME: this is like mediocre
  local name = self.name_for_events or self.name
  if name and not surpress_event then
    local core = self.core
    if searching then
      ---@type fun(core: GuiInst, inst: StdFrameTitleBarInst)
      local func = core["on_search_begin_"..name]
      if func then func(core, self) end
    else
      ---@type fun(core: GuiInst, inst: StdFrameTitleBarInst)
      local func = core["on_search_end_"..name]
      if func then func(core, self) end
    end
  end
end

gui.register_class(std_frame)

-- fix semantics