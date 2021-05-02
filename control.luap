
local gui = require("gui")
require("gui-std")

script.on_load(() => {
  gui.on_load()
})

script.on_init(() => {
  gui.on_init()
})

local foo = {class_name = "foo"}

function foo.create(params)
  local self = {
    type = "frame",
    style_mods = {
      width = 300,
      height = 200,
    },
    elem_mods = {
      auto_center = true,
    },
    direction = "vertical",
  }
  self.children = {
    {
      class = "std-frame-title-bar",
      caption = "Foo",
      core = self,
      name = "title_bar",
      drag_target = self,
      search_tf_name = "search_tf",
      close_btn_name = "close_btn",
    },
    {
      class = "frame",
      style = "inside_deep_frame_for_tabs",
      style_mods = {
        top_margin = -4,
        horizontally_stretchable = true,
        vertically_stretchable = true,
      },
    },
  }
  return self, {
    player = params.player,
  }
end

function foo:on_create()
  self.player.opened = self.elem
end

function foo:close()
  game.print("cleaning up!")
  self:destroy()
end

function foo:on_click_close_btn(close_btn, event)
  self:close()
end

function foo:on_closed(event)
  self:close()
end

-- usage of the class is not that bad
-- writing the class is more annoying though

---@param search_tf BasicGuiInst
---@param event on_gui_text_changed
function foo:on_text_changed_search_tf(search_tf, event)
  game.print(event.text)
end

---@param title_bar StdFrameTitleBarInst
function foo:on_search_begin_title_bar(title_bar)
  game.print("begin search")
end

---@param title_bar StdFrameTitleBarInst
function foo:on_search_end_title_bar(title_bar)
  game.print("end search")
end

gui.register_class(foo)

script.on_event(defines.events.on_player_created, function(event)
  local player = game.get_player(event.player_index)

  gui.create(player.gui.screen, {class = "foo", player = player})

  -- local create_time = game.create_profiler()
  -- local ctstop, ctrestart = create_time.stop, create_time.restart
  -- ctstop()
  -- create_time.reset()

  -- local destroy_time = game.create_profiler()
  -- local dtstop, dtrestart = destroy_time.stop, destroy_time.restart
  -- dtstop()
  -- destroy_time.reset()

  -- for i = 1, 10000 do
  --   ctrestart()
  --   local inst = gui.create(player.gui.screen, {class = "foo", player = player})
  --   ctstop()
  --   dtrestart()
  --   inst:destroy()
  --   dtstop()
  -- end

  -- create_time.divide(10000)
  -- destroy_time.divide(10000)
  -- game.print{"", "create time average: ", create_time}
  -- game.print{"", "destroy time average: ", destroy_time}
end)

-- fix semantics