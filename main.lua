function love.load()
    GAME_STATUS = 'ready'   -- ready started end

    winWidth = love.graphics.getWidth()
    winHeight = love.graphics.getHeight()

    Steve = love.graphics.newImage('images/dragon.png')
    Ground = love.graphics.newImage('images/ground.png')
    Cloud = love.graphics.newImage('images/cloud.png')

    treePathArr = {
        "images/trees/bbt.png",
        "images/trees/bt1.png",
        "images/trees/bt2.png",
        "images/trees/bt3.png",
        "images/trees/bt4.png",
        "images/trees/st1.png",
        "images/trees/st2.png",
        "images/trees/st3.png",
        "images/trees/st4.png",
        "images/trees/st5.png",
        "images/trees/st6.png"
    }
    treeItem1 = love.graphics.newImage(treePathArr[love.math.random(0, 10)])
    treeItem2 = love.graphics.newImage(treePathArr[love.math.random(0, 10)])
    tx1 = winWidth + 100
    tx2 = tx1 + winWidth * 0.9
    ty1 = winHeight - treeItem1:getHeight()
    ty2 = winHeight - treeItem2:getHeight()
    treeMove = 500

    -- ground parmas
    groundWidth=Ground:getWidth()
    groundHeight=Ground:getHeight()
    px1 = 0
    py1 = (winHeight*0.85 + 25)
    px2 = px1 + groundWidth - 100
    py2 = py1
    dw = 500

    -- cloud parmas
    cx1 = winWidth + love.math.random(100, 400)
    cx2 = winWidth + love.math.random(200, 500)
    cx3 = winWidth + love.math.random(300, 600)
    cx4 = winWidth + love.math.random(400, 700)
    cy1 = love.math.random(winHeight*0.2, winHeight*0.7)
    cy2 = love.math.random(winHeight*0.2, winHeight*0.7)
    cy3 = love.math.random(winHeight*0.2, winHeight*0.7)
    cy4 = love.math.random(winHeight*0.2, winHeight*0.7)
    cloudMove = 90


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
    if love.keyboard.isDown("space") and objects.steve.body:getY() >= (winHeight*0.85-50) then
        objects.steve.body:setLinearVelocity(0, -600)
    end
    if (GAME_STATUS == 'ready' or GAME_STATUS == 'end') and love.keyboard.isDown("space") then
        GAME_STATUS = 'started'
    end
end

function love.update(dt)
    world:update(dt)

    if GAME_STATUS == 'started' then
        -- UnderGround move start
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
        -- UnderGround move end

        -- Cloud Move Start
        if cx1 > -120 then
            cx1 = cx1 - dt * cloudMove
        else
            cx1 = winWidth + love.math.random(100, 400)
            cy1 = love.math.random(winHeight*0.2, winHeight*0.7)
        end
        if cx2 > -120 then
            cx2 = cx2 - dt * cloudMove
        else
            cx2 = winWidth + love.math.random(200, 500)
            cy2 = love.math.random(winHeight*0.2, winHeight*0.7)
        end
        if cx3 > -120 then
            cx3 = cx3 - dt * cloudMove
        else
            cx3 = winWidth + love.math.random(300, 600)
            cy3 = love.math.random(winHeight*0.2, winHeight*0.7)
        end
        if cx4 > -120 then
            cx4 = cx4 - dt * cloudMove
        else
            cx4 = winWidth + love.math.random(400, 700)
            cy4 = love.math.random(winHeight*0.2, winHeight*0.7)
        end
        -- Cloud Move End

        -- Tree Move Start
        if tx1 < -50 then
            tx1 = tx2 + winWidth * 0.9
            treeItem1 = love.graphics.newImage(treePathArr[love.math.random(0, 10)])
        else 
            tx1 = tx1 - dt * treeMove
        end
        if tx2 < -50 then
            tx2 = tx1 + winWidth * 0.9
            treeItem2 = love.graphics.newImage(treePathArr[love.math.random(0, 10)])
        else 
            tx2 = tx2 - dt * treeMove
        end
        -- Tree Move End
    end
end

function love.draw()
    love.graphics.draw(Steve, objects.steve.body:getX(), objects.steve.body:getY())
    love.graphics.draw(Ground, px1, py1, 0, 1, 1, groundWidth/2, groundHeight/2)
    love.graphics.draw(Ground, px2, py2, 0, 1, 1, groundWidth/2, groundHeight/2)
    love.graphics.draw(Cloud, cx1, cy1, 0, 1, 1)
    love.graphics.draw(Cloud, cx2, cy2, 0, 1, 1)
    love.graphics.setBackgroundColor(255, 255, 255)
    
    love.graphics.draw(treeItem1, tx1, ty1, 0, 1, 1)
    love.graphics.draw(treeItem1, tx2, ty2, 0, 1, 1)

    -- can be deleted
    love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
    local delta = love.timer.getAverageDelta()
    love.graphics.print(string.format("Average frame time: %.3f ms", 1000 * delta), 10, 25)
    love.graphics.print(string.format("Ball location: ( %d , %d )", objects.steve.body:getX(), objects.steve.body:getY()), 10, 50)
end