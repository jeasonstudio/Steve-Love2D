function getIntPart(x)
    if x <= 0 then
        return math.ceil(x)
    end

    if math.ceil(x) == x then
        x = math.ceil(x)
    else
        x = math.ceil(x) - 1
    end
    return x
end

SPEED_G = 500
SPEED_SLOW = 90

function love.load()
    GAME_STATUS = 'ready'   -- ready started end

    winWidth = love.graphics.getWidth()
    winHeight = love.graphics.getHeight()

    Steve = love.graphics.newImage('images/steves/normal.png')
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
    treeItem1 = love.graphics.newImage(treePathArr[love.math.random(1, #treePathArr)])
    treeItem2 = love.graphics.newImage(treePathArr[love.math.random(1, #treePathArr)])
    tx1 = winWidth + 100
    tx2 = tx1 + winWidth * 0.9
    ty1 = winHeight - 30 -- winHeight - treeItem1:getHeight()
    ty2 = winHeight - 30 -- winHeight - treeItem2:getHeight()
    treeMove = SPEED_G

    -- ground parmas
    groundWidth=Ground:getWidth()
    groundHeight=Ground:getHeight()
    px1 = 0
    py1 = (winHeight*0.85 + 25)
    px2 = px1 + groundWidth - 100
    py2 = py1
    dw = SPEED_G

    -- cloud parmas
    cx1 = winWidth + love.math.random(100, 400)
    cx2 = winWidth + love.math.random(200, 500)
    cx3 = winWidth + love.math.random(300, 600)
    cx4 = winWidth + love.math.random(400, 700)
    cy1 = love.math.random(winHeight*0.2, winHeight*0.7)
    cy2 = love.math.random(winHeight*0.2, winHeight*0.7)
    cy3 = love.math.random(winHeight*0.2, winHeight*0.7)
    cy4 = love.math.random(winHeight*0.2, winHeight*0.7)
    cloudMove = SPEED_SLOW


    -- 设置64px(像素)为1米,box2d使用实际的物理体系单位
    love.physics.setMeter(64)
    world = love.physics.newWorld( 0, 20*64, true )
    objects = {}

    -- 创建地面
    objects.ground = {}
    objects.ground.body = love.physics.newBody(world, winWidth/2, winHeight + 20)
    objects.ground.shape = love.physics.newRectangleShape(winWidth*10, 1)
    objects.ground.fixture = love.physics.newFixture(objects.ground.body, objects.ground.shape)

    -- 创建Steve
    objects.steve = {}
    objects.steve.body = love.physics.newBody(world, winWidth*0.14, winHeight/2, "dynamic")
    objects.steve.shape = love.physics.newRectangleShape(Steve:getWidth(), Steve:getHeight())
    objects.steve.fixture = love.physics.newFixture(objects.steve.body, objects.steve.shape, 200)
    objects.steve.fixture:setRestitution(0) --反弹系数

    -- 创建障碍物1
    objects.tree1 = {}
    objects.tree1.body = love.physics.newBody(world, winWidth + 100, winHeight + 20, "dynamic")
    objects.tree1.shape = love.physics.newRectangleShape(treeItem1:getWidth(), treeItem1:getHeight())
    objects.tree1.fixture = love.physics.newFixture(objects.tree1.body, objects.tree1.shape, 0)

    -- 创建障碍物2
    objects.tree2 = {}
    objects.tree2.body = love.physics.newBody(world, winWidth * 1.9, winHeight + 20, "dynamic")
    objects.tree2.shape = love.physics.newRectangleShape(treeItem2:getWidth(), treeItem2:getHeight())
    objects.tree2.fixture = love.physics.newFixture(objects.tree2.body, objects.tree2.shape, 0)

end

function love.keypressed(key)
    if key == 'q' then
        love.event.quit()
    end

    SteveX, SteveY = objects.steve.body:getLinearVelocity()
    if love.keyboard.isDown("space") and objects.steve.body:getY() >= (winHeight-30) then
        objects.steve.body:setLinearVelocity(0, -600)
    end
    if (GAME_STATUS == 'ready' or GAME_STATUS == 'end') and love.keyboard.isDown("space") then
        GAME_STATUS = 'started'
        objects.tree1.body:setLinearVelocity(-SPEED_G, 0)
    end
end

-- this keeps track of how much time has passed
dtotal = 0

function love.update(dt)
    world:update(dt)

    if GAME_STATUS == 'started' then
        dtotal = dtotal + dt

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
        if objects.tree1.body:getX() < -50 then
            objects.tree1.body:setX(objects.tree2.body:getX() + winWidth * 0.9)
            treeItem1 = love.graphics.newImage(treePathArr[love.math.random(1, #treePathArr)])
        else
            -- tx1 = tx1 - dt * treeMove
            objects.tree1.body:setLinearVelocity(-SPEED_G, 0)

        end
        -- objects.tree1.body:setX(tx1)
        if objects.tree2.body:getX() < -50 then
            objects.tree2.body:setX(objects.tree1.body:getX() + winWidth * 0.9)
            treeItem2 = love.graphics.newImage(treePathArr[love.math.random(1, #treePathArr)])
        else
            -- tx2 = tx2 - dt * treeMove
            objects.tree2.body:setLinearVelocity(-SPEED_G, 0)
        end
        -- objects.tree2.body:setX(tx2)
        -- Tree Move End

        -- Steve Animation Start
        if objects.steve.body:getY() < (winHeight-30) then
            Steve = love.graphics.newImage('images/steves/normal.png')
        elseif getIntPart(dtotal * 10) % 2 == 0 then
            Steve = love.graphics.newImage('images/steves/left.png')
        else
            Steve = love.graphics.newImage('images/steves/right.png')
        end
        -- Steve Animation End
    end
end

function love.draw()
    love.graphics.draw(Steve, objects.steve.body:getX(), objects.steve.body:getY(), 0, 1, 1, Steve:getWidth()/2, Steve:getHeight())
    love.graphics.draw(Ground, px1, py1, 0, 1, 1, groundWidth/2, groundHeight/2)
    love.graphics.draw(Ground, px2, py2, 0, 1, 1, groundWidth/2, groundHeight/2)
    love.graphics.draw(Cloud, cx1, cy1, 0, 1, 1, Cloud:getWidth()/2, Cloud:getHeight()/2)
    love.graphics.draw(Cloud, cx2, cy2, 0, 1, 1, Cloud:getWidth()/2, Cloud:getHeight()/2)
    -- love.graphics.setBackgroundColor(255, 255, 255)
    
    love.graphics.draw(treeItem1, objects.tree1.body:getX(), objects.tree1.body:getY(), 0, 1, 1, treeItem1:getWidth()/2, treeItem1:getHeight())
    love.graphics.draw(treeItem2, objects.tree2.body:getX(), objects.tree2.body:getY(), 0, 1, 1, treeItem2:getWidth()/2, treeItem2:getHeight())

    -- can be deleted
    -- love.graphics.setColor(0, 0, 0)
    love.graphics.print("Current FPS: "..tostring(love.timer.getFPS()), 10, 10)
    local delta = love.timer.getAverageDelta()
    love.graphics.print(string.format("Average frame time: %.3f ms, %.3f", 1000 * delta,dtotal), 10, 25)
    love.graphics.print(string.format("Steve location: ( %d , %d )", objects.steve.body:getX(), objects.steve.body:getY()), 10, 40)
    love.graphics.print(string.format("Tree1 location: ( %d , %d )", objects.tree1.body:getX(), objects.tree1.body:getY()), 10, 55)
    love.graphics.print(string.format("Tree2 location: ( %d , %d )", objects.tree2.body:getX(), objects.tree2.body:getY()), 10, 70)
end