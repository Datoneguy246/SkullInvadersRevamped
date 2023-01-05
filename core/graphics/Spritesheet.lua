-- Hnadler class for spritesheets
Spritesheet = Class{}

-- Load sprites as quads
function Spritesheet:init(atlas, tilew, tileh)
    self.spritesheet = love.graphics.newImage(atlas)
    self.tilew = tilew
    self.tileh = tileh

    local sheetWidth = self.spritesheet:getWidth() / tilew
    local sheetHeight = self.spritesheet:getHeight() / tileh

    console.info("SS: Formatting stylesheet - t-dim: "..sheetWidth.." x "..sheetHeight)

    i = 1
    quads = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            quads[i] = love.graphics.newQuad(x * tilew, y * tileh, tilew, tileh, self.spritesheet:getDimensions())
            console.info("SS: Adding quad @ "..x.." x "..y)
            i = i + 1
        end
    end

    self.values = quads
end

-- Assign each quad a string value
function Spritesheet:AssignQuadValue(index, value)
    index = tostring(index)
    self.values[value] = self.values[index]
    self.values[index] = nil
end