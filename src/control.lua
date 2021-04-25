
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
    caption = "Foo "..params.str,
    style_mods = {
      width = 200,
      height = 150,
    },
    elem_mods = {
      auto_center = true,
    },
    direction = "vertical",
    str = params.str,
  }
  self.children = {
    {
      class = "flow",
      direction = "vertical",
      children = {
        {
          class = "label",
          caption = "omg this is a label wooooo",
        },
        {
          class = "button",
          core = self,
          name = "btn",
          caption = "yooo wassup",
          cool = params.cool,
        },
      },
    },
  }
  return self
end

function foo:on_click(event)
  game.print("click "..self.str.."!")
end

function foo:on_click_btn(btn, event)
  game.print("clicked yooooo "..btn.cool.." "..self.btn.cool)
end

gui.register_class(foo)

script.on_event(defines.events.on_player_created, function(event)
  local player = game.get_player(event.player_index)
  local inst = gui.create(player.gui.screen, {class = "foo", str = "hi", cool = "wowoowowowo"})
  inst:destroy();
  gui.create(player.gui.screen, {class = "foo", str = "bye", cool = "wow"})
  local breakpoint
end)

-- fix semantics