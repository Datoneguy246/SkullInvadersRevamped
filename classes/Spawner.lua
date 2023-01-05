-- Spawns enemies
Spawner = Class{}

function Spawner:init()
    self.spawnRate = 3
    self.timer = nil 
    self.spawnEnabled = false
end

function Spawner:StartSpawning()
    self.spawnEnabled = true
end

function Spawner:StopSpawning()
    self.spawnEnabled = false
end

-- Spawn loop
function Spawner:update()
    if self.spawnEnabled then
        -- Check if a timer is in progress
        if self.timer == nil then
            -- Spawn new enemy and start timer
            self:createEnemy()
            self.timer = GAMETIME:startWait(self.spawnRate)
        else
            -- Check timer
            if self.timer:check() then
                -- Destroy timer
                self.timer = nil
            end
        end
    end
end

function Spawner:createEnemy()
    local id = os.time() -- ID is just game time created
    currentEnemies[id] = EnemyBase(SPRITES["placeholder"]["images"]["default"], 150, id)
end

return Spawner() -- Doesn't need to have multiple instances