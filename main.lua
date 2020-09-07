-- SFCave style game
Class = require 'class'

require 'Flyer'
require 'Pillar'
require 'Util'
require 'Animation'

width = love.graphics.getWidth()
height = love.graphics.getHeight()

flyerSizeX = 30 --collision box
flyerSizeY = 30 --collision box
gravity = 516
flappingspeed = -200
state = 'playing' -- either playing or paused
reset = false
score = 0
gapLength = 175
gapAsymp = 1 -- used to asymptotically make the gap smaller
pressed = false -- keeping track of key pressed for animation

function love.load()
    math.randomseed(os.time())
    
    spritesheet = love.graphics.newImage('seagull.png')
    sprites = generateQuads(spritesheet, 30, 35)
    animation = Animation(sprites)
    tiles = love.graphics.newImage('Stone_texture.jpg')
    background = generateQuads(tiles, 40, height)
    
    --set flyers inital values (start middle of screen)
    flyer = Flyer(flyerSizeX, flyerSizeY, height / 2)
    
    --set pillar initial values (each half screen apart)
    pillar1 = Pillar(width, gapLength)
    pillar2 = Pillar(1.5 * width, gapLength)
    pillar3 = Pillar(2 * width, gapLength)

    -- keep track of the left most pillar
    pillars = {pillar1, pillar2, pillar3}
    tracker = 1
    --collide_pillar = pillars[tracker]
    
end

function love.update(dt)
    --flyer stays 20 pixels away from left edge, only moves Y axis
    flyer:update(dt, animation:getFlapState())
    animation:update(dt, flyer:getSpeed())

    --piilar movement acrros the screen- right to left
    pillar1:update(dt)
    pillar2:update(dt)
    pillar3:update(dt)

    if flyer:collision(pillars[tracker]) == true then
        -- collided, pause game
        pause()
    end

    if state == 'paused' and reset == true then
        -- if game is paued because of collosion, and plater presse enter
        restart()
    end
end

function love.draw()
    --background color
    love.graphics.clear(135/255, 203/255, 235/255, 255/255) --sky blue

    --draw piller (brown pillar with gap)
    pillar1:render(background[1])
    pillar2:render(background[2])
    pillar3:render(background[3])

    --draw flyer
    flyer:render(animation:getCurrentFrame())

    -- draw score, top left corner
    love.graphics.setColor(1,1,1,1)
    love.graphics.printf('Score: ' .. score, 5, 10, width, 'left')

    if state == 'paused' then
        --show on screen status
        love.graphics.setColor(1,1,1,1)
        love.graphics.printf('You crashed!', 0, 10, width, 'center')
        love.graphics.printf('Press Enter to restart', 0, 20, width, 'center')
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'space' then
        --flap wing/ move up
        flyer.speed = flappingspeed
        pressed = true
        animation:flap()
    elseif key == 'return' or 'enter' then
        reset = true
    end   
end

function pause()
    -- pause player
    gravity = 0
    flappingspeed = 0
    flyer.speed = 0

    -- pause pillars
    for _, p in ipairs(pillars) do
        p.speed = 0
    end
    state = 'paused'
end

function restart()
    math.randomseed(os.time())
    gravity = 516
    flappingspeed = -200
    gapLength = 175
    gapAsymp = 1

    flyer = Flyer(flyerSizeX, flyerSizeY, height / 2)
    pillar1 = Pillar(width, gapLength)
    pillar2 = Pillar(1.5 * width, gapLength)
    pillar3 = Pillar(2 * width, gapLength)
    pillars = {pillar1, pillar2, pillar3}
    tracker = 1
    score = 0

    state = 'playing'
    reset = false
end