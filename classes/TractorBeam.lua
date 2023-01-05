TractorBeam = Class{}

function TractorBeam:init(x, y, speed)
    self.object = Object(x,y,SPRITES["placeholder"]["images"]["beam"])
    self.speed = speed
    console.info("BULLET: Exists @ ("..self.object.x..", "..self.object.y..")")
end

function TractorBeam:update(dt)
    self.object.y = self.object.y - math.floor(self.speed * dt) -- Move upwards

    -- Check if beam left view
    if self.object.y - self.object.yOff < 0 then
        self:kill()
    end

    -- Check for hit
    for key, enemy in pairs(currentEnemies) do
        if enemy.object ~= nil then
            enemyColProf = enemy.object:getCollisionProfile()
            thisColProf = self.object:getCollisionProfile()
            if CheckCollision(enemyColProf, thisColProf) then
                enemy:attach(PLAYER) -- set enemy parent to the player
                enemy.yTrackOff = math.floor(PLAYER.object.height * 1.3) -- Give the enemy a tracking offset for y-axis
                self:kill()
            end
        end
    end
end

function TractorBeam:kill()
    PLAYER.beam = nil -- Is this good for memory management? I'm not sure...
end

function TractorBeam:draw()
    self.object:draw()
end