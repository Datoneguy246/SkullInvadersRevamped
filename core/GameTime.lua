--[[
    Keeps track of game time using frame delta
    LOVE2D only has a wait function that freezes 
    your entire program, so this is more ideal.
]]

GameTime = Class{}
Timer = Class{}

function GameTime:init()  
    self.timeSinceStart = 0 
end

function GameTime:update(dt)
    self.timeSinceStart = self.timeSinceStart + dt -- Add delta
end

--[[
    Waiting has to occur within update() to stop the game from freezing each frame
    but at the same time... pausing the update loop will freeze the game each frame
    as well...

    So: waiting is defined as an object that can be checked each frame
]]
function GameTime:startWait(time)
    local startTime = self.timeSinceStart
    local targetTime = startTime + time
    return Timer(targetTime, self)
end

-- TIMER OBJECT FUNCTIONS
function Timer:init(target, timeInstance)
    self.target = target
    self.timeInstance = timeInstance
end

function Timer:check()
    return self.timeInstance.timeSinceStart > self.target
end