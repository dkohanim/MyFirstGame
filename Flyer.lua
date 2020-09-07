Flyer = Class{}

--[[sprite
GLIDE_DOWN = 1
GLIDE_UP = 3

FLAP_DOWN = 2
FLAP_UP = 4 --]]

function Flyer:init(sizeX, sizeY, y)
    self.sizeX =sizeX
    self.sizeY = sizeY
    self.x = 20
    self.y = y
    self.speed = 0    -- initial speed is zero
    self.diffY = 0    -- shift bird sprite to allisgn with collision box
end

function Flyer:update(dt, flapState)
    self.speed = self.speed + (gravity * dt)
    self.y = self.y + (self.speed * dt)

    --update size of Flyer (collision box), based on flap state
    if flapState == 2 then --flap down
        self.sizeY = 26
        self.diffY = 12
    elseif flapState == 4 then --flap up
        self.sizeY = 33
        self.diffY = -3
    else -- glide 
        self.sizeY = 20
        self.diffY = 8
    end
end

function Flyer:render(frame)
    -- draw animated flyer
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(spritesheet, frame, self.x, self.y)
    -- draw collision box
    --love.graphics.setColor(180/255, 180/255, 32/255, 255/255)
    love.graphics.setColor(220/255, 250/255, 220/255, 255/255)
    love.graphics.rectangle('line', self.x, self.y + self.diffY, self.sizeX, self.sizeY)
end

function Flyer:collision(pillar)
    --check x range
    if self.x + self.sizeX > pillar.x and self.x < pillar.x + pillar.width  then
        --check y range
        if self.y + self.diffY < pillar.gapY or self.y + self.diffY + self.sizeY > pillar.gapY + pillar.gapLength then
            return true
        end
    -- check bottom and top of screen
    elseif self.y + self.diffY <= 0 or self.y + self.diffY + self.sizeY >= height then
        return true
    else
        return false
    end
end

function Flyer:getSpeed()
    return self.speed
end