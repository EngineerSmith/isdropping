# love.isdropping
This is a simple library which adds a `love.isdropping` event to go with `love.filedropped`! This can be used to estimate if a file is being held over the window and where about it is being held.

# Known disadvantages
As there isn't an event in SDL for when a file is being held above the window. This library works by finding out if the mouse is held down outside of the window and then passes over the love window. So it is possible to trigger it without holding anything by holding the mouse down and then putting it over the window. Such situations could happen by moving a window title bar over the love's window.

# Docs

You can check out `main.lua` for a working example. 
TLDR; `love.isdropping(x: number, y: number)`

```lua
local dropping = require("isdropping") -- Require the library

love.keyboardpressed = function()
  dropping.stop = not dropping.stop -- easily stop the event from being check when not needed
end

love.update = function()
  dropping.eventUpdate() -- Call the update function each frame
end -- I  recommend putting it in your love.run before events are polled; see main.lua

local dropX, dropY = -50, -50
love.isdropping = function(x, y) -- add callback
  dropX, dropY = x, y
end

love.draw = function()
  love.graphics.setColor(1,0,0,1)
  love.graphics.circle("fill", dropX, dropY, 5)
end
```