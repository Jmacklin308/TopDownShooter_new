function love.load()
    --get width of window
    game_width = love.graphics.getWidth()
    game_height = love.graphics.getHeight()


    -- loading our sprites
    sprites = {}
    sprites.background = love.graphics.newImage('res/background.png')
    sprites.zombie = love.graphics.newImage('res/zombie.png')
    sprites.player = love.graphics.newImage('res/player.png')
    sprites.bullet = love.graphics.newImage('res/bullet.png')


    --Player properties
    player = {}
    player.x = game_width/2
    player.y = game_height/2
    player.health = 100
    player.speed = 200
    player.width = sprites.player:getWidth()
    player.height = sprites.player:getHeight()


    --Zombie properties
    zombie_group = {}

end

function love.update(dt)

    playerMovement(dt)
    zombieMovement(dt)


    aimToMouse = playerMouseAngle()
    end

function love.draw()
    --background
    love.graphics.draw(sprites.background,0,0)

    --iterate throughout zombie tables
    for i,z in ipairs(zombie_group) do
        love.graphics.draw(sprites.zombie,
            z.x,
            z.y,
            zombiePlayerAngle(z),
            nil,
            nil,
            sprites.zombie:getWidth()/2,
            sprites.zombie:getHeight()/2
        )
    end

    --player sprite
    love.graphics.draw(sprites.player, player.x, player.y, aimToMouse , nil,nil,player.width/2,player.height/2)




end

function playerMovement(dt)
    --no movement at start
    move_dir_x = 0
    move_dir_y = 0

    --setup player input
    if love.keyboard.isDown("w") then
        move_dir_y = -1
    end

    if love.keyboard.isDown("s") then
        move_dir_y = 1
    end

    if love.keyboard.isDown("a") then
        move_dir_x = -1
    end

    if love.keyboard.isDown("d") then
        move_dir_x = 1
    end

    diagCheck = (move_dir_x*move_dir_x)+(move_dir_y*move_dir_y)

    if (diagCheck>1) then
        --movement is no longer 1 unit, so we need to normalize unit
        dist = math.sqrt(diagCheck)
        move_dir_x = move_dir_x / dist
        move_dir_y = move_dir_y / dist
    end


    player.x = player.x + ((player.speed * dt)* move_dir_x)
    player.y = player.y + ((player.speed * dt)* move_dir_y)
end

function zombieMovement(dt)
    for i,z in ipairs(zombie_group) do
        --use cos(zombie direction) to get x
        z.x = z.x + (math.cos(zombiePlayerAngle(z)) * z.speed * dt)
        --use sin(zombie direction) to get y
        z.y = z.y + (math.sin(zombiePlayerAngle(z)) * z.speed * dt)


        -- check collision with player
        if distanceToTarget(z.x, z.y, player.x, player.y) < player.width then
            for i,z in ipairs(zombie_group) do
                zombie_group[i] = nil --remove zombie
            end
        end
    end
end

---DEBUG
function love.keypressed(key)
    if key == "space" then
        spawnZombie()
    end
end

function playerMouseAngle()
    return math.atan2(player.y - love.mouse.getY(), player.x - love.mouse.getX()) + math.pi
end

function zombiePlayerAngle(enemy) -- calculate angle from zombie to player
    return math.atan2(player.y - enemy.y, player.x - enemy.x)
end

function spawnZombie()
    local zombie = {}
    zombie.x = math.random(0,love.graphics.getWidth())
    zombie.y = math.random(0,love.graphics.getHeight())
    zombie.speed = 140
    table.insert(zombie_group,zombie) --take zombie table and add it to the zombie group table
end

function distanceToTarget(x1,y1,x2,y2)
    return math.sqrt((x2-x1)^2+(y2-y1)^2)
end