local ffi = require("ffi")

ffi.cdef[[
  typedef struct SDL_Window SDL_Window;
  SDL_Window *SDL_GL_GetCurrentWindow(void);
  uint32_t SDL_GetGlobalMouseState(int *x, int *y);
  void SDL_GetWindowPosition(SDL_Window * window, int* x, int* y);
]]

local sdl = jit.os == "Windows" and ffi.load("sdl2") or ffi.C

local dropping = { 
  stop = false,
  primaryButton = 1, -- primary
  event = "isdropping",
}

love.handlers[dropping.event] = function(x,y)
  if love[dropping.event] then return love[dropping.event](x,y) end
end

local intX = ffi.new("int[1]")
local intY = ffi.new("int[1]")

-- to keep things simple
local set = function() return intX, intY end
local get = function() return tonumber(intX[0]), tonumber(intY[0]) end

local isPointInsideRect = function(px, py, x, y, w, h)
  return px > x and px < x + w and
         py > y and py < y + h
end

dropping.eventUpdate = function()
  if not dropping.stop then
    jit.off() -- There is a weird ass jit bug where tonumber doesn't actually make variables become lua numbers till you touch them. It works fine with jit.off()
      -- if jit is on, then memory is shared between mouseX, mouseY and windowX and windowY 
    -- get mouse state
    local button = sdl.SDL_GetGlobalMouseState(set())
    local mouseX, mouseY = get()

    -- get window state
    sdl.SDL_GetWindowPosition(sdl.SDL_GL_GetCurrentWindow(), set())
    local windowX, windowY = get()
    --print("w", windowX, windowY, "m", mouseX, mouseY) -- these will print the same if jit was on
    local windowW, windowH = love.window.getMode()
    jit.on()
    -- is mouse inside window
    if isPointInsideRect(mouseX, mouseY, windowX, windowY, windowW, windowH) then

      if dropping.heldoutside then -- if mouse was held outside of window, assume it is holding a file
        if button == dropping.primaryButton then
          love.event.push(dropping.event, mouseX - windowX, mouseY - windowY)
        else
          dropping.heldoutside = false
        end
      end
    else
      dropping.heldoutside = button == dropping.primaryButton
    end
  end
end

return dropping
