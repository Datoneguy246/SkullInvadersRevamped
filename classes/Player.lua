-- Player ship object
Player = Class{}

-- Constructor takes in movement speed and y coordinate
function Player:init(mv_speed, y, slide_width)
    self.object = Object(math.floor(V_WIDTH / 2), y, SPRITES["placeholder"]["images"]["default"])
    self.mv_speed = mv_speed

    -- Possible child object slots
    self.beam = nil
    self.attachedEnemy = nil

    -- X Bounds
    self.xMin = self.object.x - (X_SLIDE_WIDTH / 2)
    self.xMax = self.object.x + (X_SLIDE_WIDTH / 2)
end

function Player:update(dt)
    self:move(dt) -- Move left/right
    if self.beam ~= nil then
        self.beam:update(dt) -- Update beam if it exists
    end
end

function Player:move(dt)
    -- Get input
    xVel = 0
    if love.keyboard.isDown("left") then
        xVel = -self.mv_speed
    elseif love.keyboard.isDown("right") then
        xVel = self.mv_speed
    end

    xTarget = math.floor(self.object.x + (xVel * dt))

    -- Apply bounds
    self.object.x = ClampBetween(xTarget, self.xMin, self.xMax)
end

--[[
    Callback to handle player input
    Technically outside of the class
]] 
function love.keypressed(key)
    -- Check input
    if key == "z" and PLAYER.beam == nil then -- only shoot one beam at a time
        PLAYER:shoot()
    else
        console.info("PS: Not shoot input")
    end
end

function Player:shoot()
    -- Check what to shoot
    if self.attachedEnemy == nil then
        self.beam = TractorBeam(self.object.x, self.object.y, B_SPEED) -- Shoot beam
        console.info("PS: Shot")
    else
        self.attachedEnemy:detach()
    end
end

function Player:draw(debug)
    if debug then    
        -- TEST FOR COLLISION
        thisColObj = self.object:getCollisionProfile()
        mouseColObj = {love.mouse.getX(), love.mouse.getY(), 1, 1}
        if CheckCollision(thisColObj, mouseColObj) then
            love.graphics.setColor(1,0,0,1)
        else
            love.graphics.setColor(1,1,1,1)
        end
    end

    self.object:draw()

    if debug then
        -- Shows sprite center
        love.graphics.setColor(1,0,0,1)
        love.graphics.circle('fill', self.x, self.y, 3)
    end

    -- Draw beam if exists
    love.graphics.setColor(1,1,1,1)
    if self.beam ~= nil then
        self.beam:draw()
    end
end