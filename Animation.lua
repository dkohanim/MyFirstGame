Animation = Class{}

--frame options
GLIDE_DOWN = 1
GLIDE_UP = 3

FLAP_DOWN = 2
FLAP_UP = 4

function Animation:init(frames)
    self.frames = frames
    self.timer = 0.3 --starts after flap animation (just gliding)
    self.currentFrame = 1
    self.animOrder = {1, 2, 3}
    self.animIntervals = {0.1, 0.25, 0.3}
end

function Animation:getCurrentFrame()
    return self.frames[self.currentFrame]
end

function Animation:update(dt, speed)
    self.timer = self.timer + dt
    if self.timer < self.animIntervals[3] and state == 'playing' then 
        if self.timer < self.animIntervals[1] then
            -- first interval, use first frame
            self.currentFrame = self.animOrder[1]
        elseif self.timer <self.animIntervals[2] then
            -- second interval, use second frame
            self.currentFrame = self.animOrder[2]
        end
    else
        if speed > 275 then
            -- if descending fast
            self.currentFrame = FLAP_UP
        else
            self.currentFrame = self.animOrder[3] --glide
        end
    end
end

function Animation:flap()
    -- set timer to zero, where the flap animation begins
    self.timer = 0
end

function Animation:getFlapState()
    return self.currentFrame
end