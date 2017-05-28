function love.load()
    GAME_STATUS = 'ready'   -- ready started end

    winWidth = love.graphics.getWidth()
    winHeight = love.graphics.getHeight()

    Steve = love.graphics.newImage('images/dragon.png')
    Ground = love.graphics.newImage('images/ground.png')

    groundWidth=Ground:getWidth()
    groundHeight=Ground:getHeight()

    px1 = 0
    py1 = (winHeight*0.85 + 25)
    px2 = px1 + groundWidth - 100
    py2 = py1
    dw = groundWidth * 0.2

    --设置64px(像素)为1米,box2d使用实际的物理体系单位
    love.physics.setMeter(64)
    world = love.physics.newWorld( 0, 20*64, true )
    objects = {}

    --创建地面
    objects.ground = {}
    objects.ground.body = love.physics.newBody(world, winWidth/2, winHeight*0.85)
    objects.ground.shape = love.physics.newRectangleShape(winWidth, 1)
    objects.ground.fixture = love.physics.newFixture(objects.ground.body, objects.ground.shape)

    --创建Steve
    objects.steve = {}
    objects.steve.body = love.physics.newBody(world, winWidth*0.1, winHeight/4, "dynamic")
    objects.steve.shape = love.physics.newRectangleShape(70, 75)
    objects.steve.fixture = love.physics.newFixture(objects.steve.body, objects.steve.shape, 200)
    objects.steve.fixture:setRestitution(0) --反弹系数

end

function love.keypressed(key)
    if key == 'q' then
        love.event.quit()
    end

    SteveX, SteveY = objects.steve.body:getLinearVelocity()
    if love.keyboard.isDown("space") and objects.steve.body:getY() >= (winHeight*0.85-50) and GAME_STATUS == 'started' then
        objects.steve.body:setLinearVelocity(0, -600)
    else
        GAME_STATUS = 'started'
    end
end

function love.update(dt)
    world:update(dt)

    if GAME_STATUS == 'started' then
        if px1 > -groundWidth/2 then
            px1 = px1 - dt * dw
        else
            px1 = px2 + groundWidth - 100
        end
        if px2 > -groundWidth/2 then
            px2 = px2 - dt * dw
        else
            px2 = px1 + groundWidth - 100
        end
    end
end

function love.draw()
    love.graphics.draw(Steve, objects.steve.body:getX(), objects.steve.body:getY())
    -- love.graphics.draw(Ground, 0, winHeight*0.85 + 15)
    love.graphics.draw(Ground, px1, py1, 0, 1, 1, groundWidth/2, groundHeight/2)
    love.graphics.draw(Ground, px2, py2, 0, 1, 1, groundWidth/2, groundHeight/2)
    love.graphics.setBackgroundColor(255, 255, 255)

    love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
    local delta = love.timer.getAverageDelta()
    love.graphics.print(string.format("Average frame time: %.3f ms", 1000 * delta), 10, 25)
    love.graphics.print(string.format("Ball location: ( %d , %d )", objects.steve.body:getX(), objects.steve.body:getY()), 10, 50)
end