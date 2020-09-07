Pillar = Class {}

function Pillar:init(x, gapL)
    self.x = x
    --self.y = 0
    self.width = 40
    self.gapLength = gapL
    self.gapY = love.math.random(5, height - 5 - self.gapLength)
    self.speed = 100
end

function Pillar:render(texture)
    -- draw textured pillar
    love.graphics.setColor(160/255, 90/255, 15/255, 255/255) --brown
    love.graphics.draw(tiles, texture, self.x, 0)
    --draw pillar gap
    love.graphics.setColor(135/255, 203/255, 235/255, 255/255) --sky blue
    love.graphics.rectangle('fill', self.x, self.gapY, self.width, self.gapLength)
end

function Pillar:update(dt)
    if self.x < -self.width then
        --reached left end, start again at the right
        self.x = (1.5 * width)
        -- update score
        score = score + 10
        -- makge pillar gap length smaller
        gapAsymp = gapAsymp + 0.15 -- can change decimal to rate of smaller (bigger is faster)
        gapLength = 80 +  (95 * (1 / gapAsymp)) -- first # is samllest gap, second is difference bewteen smallest and largest
        self.gapLength = gapLength
        -- change the colliding pillar check to the next pillar
        if tracker == 3 then
            tracker = 1
        else
            tracker = tracker + 1
        end
        --random new gap
        self.gapY = love.math.random(5, height - 5 - self.gapLength)
    else
        self.x = self.x - (self.speed * dt)
    end
end