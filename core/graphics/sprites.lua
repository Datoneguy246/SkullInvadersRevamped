-- Loads all sprites and organizes them for easy access

-- Configure spritesheets
local explosionSS = Spritesheet("graphics/Explosion.png", 32, 32)

-- Dictionary of drawable images and animations
return {
    ["placeholder"] = {
        ["images"] = {
            ["default"] = love.graphics.newImage("graphics/Placeholder.png"),
            ["beam"] = love.graphics.newImage("graphics/Beam.png"),
        },
        ["animations"] = {
            ["explosion"] = {
                Animation(explosionSS.values, 12, false),
                explosionSS
            }
        }
    }
}