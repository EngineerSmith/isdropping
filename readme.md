# love.isdropping
This is a simple library which adds a `love.isdropping` event to go with `love.filedropped`! This can be used to estimate if a file is being held over the window and where about it is being held.

# Known disadvantages
As there isn't an event in SDL for when a file is being held above the window. This library works by finding out if the mouse is held down outside of the window and then passes over the love window. So it is possible to trigger it without grabbing a file; by holding the mouse down and then putting it over the window. Such situations could occur by moving a window title bar over the love's window; this will trigger the `love.isdropping` event.

# Docs
You can check out `main.lua` for a working example. 

### Events
#### `love.isdropping(x: number, y: number)`
Called each frame (or each cycle of `dropping.eventUpdate` is called) when a grabbed cursor is over the love window
#### `love.stoppeddropping()`
Called once in place of `love.filedropped` or `love.directorydropped` if the cursor leaves the window after `love.isdropping` has been called but nothing has been dropped. (`love.isdropping` will resume being called if it returns to the window)

### Functions
#### `dropping.eventUpdate()`
To be called once per cycle; this can be placed anywhere such as within `love.update`, but I recommend just putting it above the event polling in `love.run`. 

#### `dropping.stop`
This variable can be set to true to stop the code from checking for a grab. E.g. when you aren't listening for either `love.filedropped` or `love.directorydropped`. Equally can be set to true, as is default to let it test if there is a grab.

## Important notes
This library overwrites the `love.handlers` for both `love.filedropped` and `love.directorydropped`. This is to ensure `love.stoppeddropping` isn't called if there has been a successful drop.

# Example

You can check out `main.lua` for a working example. 
```lua
local dropping = require("isdropping") -- Require the library

love.keyboardpressed = function()
  dropping.stop = not dropping.stop -- easily stop the event from being check when not needed
end

love.update = function()
  dropping.eventUpdate() -- Call the update function each frame
end -- I  recommend putting it in your love.run before events are polled; see main.lua; but can be placed anywhere

local dropX, dropY = -50, -50
love.isdropping = function(x, y) -- add callback
  dropX, dropY = x, y
end

love.stoppeddropping = function() -- called when mouse leaves window, but doesn't drop
	dropX, dropY = -50, -50
end

love.draw = function()
  love.graphics.setColor(1,0,0,1)
  love.graphics.circle("fill", dropX, dropY, 5)
end
```