
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
          data = {core = self},
          name = "btn",
          caption = "yooo wassup",
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
  game.print("clicked yooooo")
end

gui.register_class(foo)

script.on_event(defines.events.on_player_created, function(event)
  local player = game.get_player(event.player_index)
  gui.create(player.gui.screen, "foo", nil, {str = "hi"})
  -- gui.create(player.gui.screen, "foo", nil, {str = "bye"})
end)

-- fix semantics