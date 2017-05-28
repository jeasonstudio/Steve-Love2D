function love.load()

    winWidth = love.graphics.getWidth()
    winHeight = love.graphics.getHeight()

    Steve = love.graphics.newImage('images/dragon.png')
    Ground = love.graphics.newImage('images/ground.png')

    groundWidth=Ground:getWidth()
    groundHeight=Ground:getHeight()

    px1 = 0
    py1 = (winHeight*0.85 + 25)
    px2 = px1 - winWidth
    py2 = py1
    dw = groundWidth

    --设置64px(像素)为1米,box2d使用实际的物理体系单位
    love.physics.setMeter(64)
    world = love.physics.newWorld( 0, 15*64, true )
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
    if love.keyboard.isDown("space") and objects.steve.body:getY() >= (winHeight*0.85-50) then
        objects.steve.body:setLinearVelocity(0, -500)
    end
end

function love.update(dt)
    world:update(dt)

    if px1 < winWidth + groundWidth/2 then    
        px1 = px1 + dt * dw * 0.1
    else
        px1 = px2 - winWidth
    end
    if px2 < winWidth + groundWidth/2 then
        px2 = px2 + dt * dw * 0.1
    else
        px2 = px1 - winWidth
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