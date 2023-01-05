-- Takes in an array of frames to create animation
Animation = Class{}

function Animation:init(frames, framerate, loop, quadSize)
    self.frames = frames
    self.currentFrame = 1
    self.loop = loop
    self.delay = 1 / framerate -- Convert from FPS to SPF
    self.timeSinceLast = nil

    self.playing = false

    console.info("Anim: new animation w/ #"..#self.frames)
end

function Animation:start()
    -- Set start time
    self.timeSinceLast = GAMETIME.timeSinceStart
    self.currentFrame = 1
    self.playing = true
end

function Animation:update()
    if self.playing == false then
        -- Delete it's instance in the currentFX table
        for i = 1, #currentFX, 1 do
            local FXOBJ = currentFX[i]
            if FXOBJ.grphx[1] == self then
                currentFX[i] = nil
            end
        end
        return
    end

    local timer = GAMETIME.timeSinceStart - self.timeSinceLast

    -- iteratively subtract interval from timer to proceed in the animation,
    -- in case we skipped more than one frame
    while timer > self.delay do
        timer = timer - self.delay
        self.currentFrame = self.currentFrame + 1
        if self.currentFrame > #self.frames then
            self.currentFrame = 1
            self.playing = self.loop
        end
        self.timeSinceLast = GAMETIME.timeSinceStart
    end
end