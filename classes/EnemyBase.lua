EnemyBase = Class{}

--[[
    Basic Enemy
    All other enemies derive from this
]]

function EnemyBase:init(sprite, mv_speed, id)
    -- X Bounds
    self.xMin = math.floor(V_WIDTH / 2) - (X_SLIDE_WIDTH / 2)
    self.xMax = math.floor(V_WIDTH / 2) + (X_SLIDE_WIDTH / 2)

    local xStartRand = math.random(self.xMin, self.xMax) 
    self.object = Object(xStartRand, 0, sprite)
    self.mv_speed = mv_speed

    self.curState = enemyStates.ATTACK
    self.id = id
    self.yTrackOff = 0
end

function EnemyBase:attach()
    self.curState = enemyStates.BEAMED
    PLAYER.attachedEnemy = self
end

function EnemyBase:detach()
    self.curState = enemyStates.SHOT
    PLAYER.attachedEnemy = nil

    -- Change mv_speed so it goes upward
    self.mv_speed = SH_SPEED
end

function EnemyBase:update(dt)
    -- Switch statement for enemy states
    switch(self.curState, { 
        [enemyStates.ATTACK] = function()	
		    self:move(dt)
            self.object.color = {1,1,1,1}

            -- Check for collision with other enemy
            for key, otherEnemy in pairs(currentEnemies) do
                if otherEnemy.object ~= nil and key ~= self.id and otherEnemy.curState ~= enemyStates.ATTACK then
                    otherColProf = otherEnemy.object:getCollisionProfile()
                    thisColProf = self.object:getCollisionProfile()
                    if CheckCollision(otherColProf, thisColProf) then
                        otherEnemy:kill()
                        self:kill()
                    end
                end
            end
	    end,
	    [enemyStates.BEAMED] = function()	
		    self:aim(dt)
            self.object.color = {1,1,0,1}
	    end,
	    [enemyStates.SHOT] = function()	
            self:move(dt) -- mv_speed is reversed
		    self.object.color = {1,1,0,1}
	    end
    })

    -- Check if off-screen to despawn
    if self.object.y < -self.object.yOff or self.object.y > V_HEIGHT then
        self:kill()
        console.info("Killed OOB enemy")
    end
end

function EnemyBase:move(dt)
    self.object.y = self.object.y + (self.mv_speed * dt) -- Move down. Badabing badaboom
end

function EnemyBase:aim(dt)
    local lerpX = lerp(self.object.x, PLAYER.object.x, B_STRENGTH * dt)
    local lerpY = lerp(self.object.y, PLAYER.object.y - self.yTrackOff, B_STRENGTH * dt)

    -- Set coordinates
    self.object.x = lerpX
    self.object.y = lerpY
end

function EnemyBase:draw()
    self.object:draw()
end

function EnemyBase:kill()
    currentEnemies[self.id] = nil

    -- Create explosion FX
    local explosion = Object(self.object.x, self.object.y, SPRITES["placeholder"]["animations"]["explosion"])
    explosion.grphx[1]:start()
    table.insert(currentFX, explosion)
end