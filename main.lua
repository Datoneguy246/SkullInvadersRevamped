console = require("core/lib/console.console") -- Amazing stuff (changed up some stuff to allow my scripts to use it)
Class = require 'core/lib/class' -- Class definition to allow for OOP
Enum = require "core/lib/enum" -- Custom Enum data type
require "core/graphics/Spritesheet"
require "core/graphics/Animation"
SPRITES = require "core/graphics/sprites" -- Import organized sprites as drawables
require "core/Object" -- Base drawable object most classes "derive" from (inheritance is fucked in this gd language)
require "core/GameTime" -- My game time defintion

GAMETIME = nil -- Game timer. Initalized on load instead of here for more accurate start time

-- window dimensions
W_WIDTH = 480
W_HEIGHT = 640
W_SCALE = 1

-- virtual dimensions based on W_SCALE
V_WIDTH = W_WIDTH / W_SCALE
V_HEIGHT = W_HEIGHT / W_SCALE

-- other constants
P_SPEED = 350 -- Player Speed
B_SPEED = 1000 -- Beam Speed
SH_SPEED = -1000 -- Enemy shoot speed
B_STRENGTH = 8 -- Beam Strength
X_SLIDE_WIDTH = V_WIDTH * 0.8 -- Width of movement

-- Import classes
require "util"
require "classes/TractorBeam"
require "classes/Player"
require "classes/EnemyBase"
SPAWNER = require "classes/Spawner"

-- Seed random generator
math.randomseed(os.time())

PLAYER = Player(P_SPEED, math.floor(V_HEIGHT * 0.75)) --[[
    The player object

    ...I kept on wasting memory and code cleanliness by 
    having every instance of each enemy and beam have a 
    refrence to the player. Eventually I realized how
    horrible of a system that was.
]]

-- FSM for basic enemy actions (enum type given from 3rd party lib)
enemyStates = Enum {
    "ATTACK",
    "BEAMED",
    "SHOT"
}

-- All current enemies
currentEnemies = {}

-- All current effects that need to update
currentFX = {}

function love.load()
    -- Set up window
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setMode(W_WIDTH, W_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
    love.window.setTitle('Skull Invaders Revamped')

    -- Initialize game timer
    GAMETIME = GameTime()

    SPAWNER:StartSpawning() -- Start game loop
end

function love.update(dt)
    GAMETIME:update(dt) -- Update game time
    SPAWNER:update() -- Update Spawner
    PLAYER:update(dt) -- Update player

    -- Update all enemies
    for key, enemy in pairs(currentEnemies) do
        enemy:update(dt)
    end

    -- Update all effects
    for _, FX in pairs(currentFX) do
        FX.grphx[1]:update() -- Animations are indexed
    end
end

function love.draw()
    love.graphics.scale(W_SCALE) -- Apply constant window scale
    love.graphics.setColor(1,1,1,1) -- Reset color prefrence

    PLAYER:draw(false) -- Draw  player

    -- Draw all enemies
    for key, enemy in pairs(currentEnemies) do
        enemy:draw()
    end

    -- Draw all effects
    for _, FX in pairs(currentFX) do
        FX:draw()
    end

    -- Draw gradient at the top to hide enemy spawning (bit less jarring)
    topGradient(0.9, 0.05)
end

function topGradient(startAlpha, fadeRate)
    local alpha = startAlpha
    local y = 0
    while alpha > 0 do
        love.graphics.setColor(0.6,0,0,alpha)
        love.graphics.line(0,y,V_WIDTH,y)
        y = y + 1
        alpha = alpha - fadeRate
    end
end

-- Done for console
function love.textinput(t)
    console.toggle(t)
end