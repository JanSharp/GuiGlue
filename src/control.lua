
local gui = require("gui")

script.on_load(() => {
  gui.on_load()
})

script.on_init(() => {
  gui.on_init()
})

local foo = {class_name = "foo"}

function foo.create(params)
  return {
    type = "frame",
    caption = "Foo "..params.str,
    style_mods = {
      width = 200,
      height = 150,
    },
    str = params.str,
  }
end

function foo:on_click(event)
  game.print("click "..self.str.."!")
end

gui.register_class(foo)

script.on_event(defines.events.on_player_created, function(event)
  local player = game.get_player(event.player_index)
  gui.create(player.gui.screen, "foo", nil, {str = "hi"})
  gui.create(player.gui.screen, "foo", nil, {str = "bye"})
end)

-- fix semantics