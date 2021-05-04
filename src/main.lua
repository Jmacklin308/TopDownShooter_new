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


    --create player table to assign properties
    player = {}
    player.x = game_width/2
    player.y = game_height/2
    player.health = 100
    player.speed = 200

end

function love.update(dt)

    playerMovement(dt) -- Player movement

end

function love.draw()
    --draw background
    love.graphics.draw(sprites.background,0,0)
    --draw player sprite
    love.graphics.draw(sprites.player, player.x, player.y)

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

    --Taking care of that pathagoriean therum
    if (diagCheck>1) then
        --movement is no longer 1 unit, so we need to normalize unit
        dist = math.sqrt(diagCheck)
        move_dir_x = move_dir_x / dist
        move_dir_y = move_dir_y / dist
    end


    player.x = player.x + ((player.speed * dt)* move_dir_x)
    player.y = player.y + ((player.speed * dt)* move_dir_y)
end