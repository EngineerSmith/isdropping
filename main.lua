local dropping = require("isdropping")

-- default love.run par the lines marked

function love.run()
  if love.load then love.load(love.arg.parseGameArguments(arg), arg) end

  if love.timer then love.timer.step() end

  local dt = 0

  return function()
    dropping.eventUpdate() -- Add dropping function before events are handled
    
    if love.event then
      love.event.pump()
      for name, a,b,c,d,e,f in love.event.poll() do
        if name == "quit" then
          if not love.quit or not love.quit() then
            return a or 0
          end
        end
        love.handlers[name](a,b,c,d,e,f)
      end
    end

    if love.timer then dt = love.timer.step() end

    if love.update then love.update(dt) end

    if love.graphics and love.graphics.isActive() then
      love.graphics.origin()
      love.graphics.clear(love.graphics.getBackgroundColor())

      if love.draw then love.draw() end

      love.graphics.present()
    end

    if love.timer then love.timer.sleep(0.001) end
  end
end

local dropX, dropY
love.isdropping = function(x, y) -- called each frame the mouse is being held above the window
  dropX, dropY = x, y
end

local files = { }
love.filedropped = function(file)
  local f = { filename = file:getFilename() }
  f.x, f.y = love.mouse.getPosition()
  table.insert(files, f)
end

local lg = love.graphics
love.draw = function()
  lg.setColor(1,0,0,1)
  if dropX and dropY then
    lg.circle("fill", dropX, dropY, 8)
    dropX, dropY = nil, nil
  end
  lg.setColor(0,0,1,1)
  for _, file in ipairs(files) do
    lg.circle("fill", file.x, file.y, 5)
    lg.print(file.filename, file.x+10, file.y-lg.getFont():getHeight()/2)
  end
end