-- Base displayable object that can be drawn 
Object = Class{}

local grphxTypes = Enum {
    "DRAWABLE",
    "QUAD",
    "ANIMATION"
}

function Object:init(x,y,grphx)
    self.x = x
    self.y = y
    self.grphx = grphx
    
    -- Find type
    local rawType = type(self.grphx)
    if rawType == "userdata" then -- LOVE2D Type
        if self.grphx:typeOf("Image") then
            self.grphxType = grphxTypes.DRAWABLE
        end
    elseif rawType == "table" then -- Has spritesheet attached
        console.warn("Created Object with Quad not Drawable")
        self.spritesheetObj = self.grphx[2]

        local contentType = type(self.grphx[1])
        if contentType == "userdata" then
            if self.grphx[1]:typeOf("Quad") then -- First element is single quad
                self.grphxType = grphxTypes.QUAD
            end
        else
            self.grphxType = grphxTypes.ANIMATION
        end
    end

    self.color = {1,1,1,1}

    -- Get dimension data dependent on type
    if self.grphxType == grphxTypes.DRAWABLE then
        self.width = self.grphx:getWidth()
        self.height = self.grphx:getHeight()
    else
        self.width = self.spritesheetObj.tilew
        self.height = self.spritesheetObj.tileh
    end

    self.xOff = self.width / 2
    self.yOff = self.height / 2
end

function Object:draw()
    love.graphics.setColor(self.color)

    -- Determine what sprite to draw
    switch(self.grphxType, {
        [grphxTypes.DRAWABLE] = function()
            love.graphics.draw(self.grphx, self.x, self.y, 0, 1, 1, self.xOff, self.yOff)
        end,
        [grphxTypes.QUAD] = function()
            love.graphics.draw(self.spritesheetObj.spritesheet, self.grphx, self.x, self.y, 0, 1, 1, self.xOff, self.yOff)
        end,
        [grphxTypes.ANIMATION] = function()
            love.graphics.draw(self.spritesheetObj.spritesheet, self.grphx[1].frames[self.grphx[1].currentFrame], self.x, self.y, 0, 1, 1, self.xOff, self.yOff)
        end
    })

    love.graphics.setColor(1,1,1,1)
end

function Object:getCollisionProfile()
    return {self.x, self.y, self.width, self.height}
end