require "ButtonManager"
require "Block"

local gameSettings = {}
local gameData = {}
local shapes = { }
local queue = {}
local activeShape = {}
local bM, bMMenu, bMGO, bMOpt, animatedBG = {} , {} , {} , {} , {} 

function love.load()
	shapes = {}
	shapes.n = 0
	shapes.lMax = 800
	gameSettings.mode = gameSettings.mode or "menu"
	gameSettings.fieldHeight = 18
	gameSettings.fieldWidth = 10
	gameSettings.width, gameSettings.height = love.graphics.getDimensions()
	gameSettings.spawnX = 5
	gameSettings.spawnY = 0
	gameSettings.size = 30
	gameSettings.vars = function() return gameSettings end
	gameSettings.dummyVars1 = function() return 18,4.75,20 end   -- center at 360,95  18*20,
	gameSettings.dummyVars2 = function() return 72,33,5 end   -- center at 360,165  18*20, 50-50
	gameSettings.shapes = shapes
	gameSettings.bgColor = {255,255,255,255}
	gameSettings.raster = {}
		gameSettings.raster.color = {125,125,125,125}
		gameSettings.raster.lineW = 1
	gameSettings.labelColor = {235,165,61,255}
	gameSettings.grayedOut = {45,45,45,45}
	gameSettings.grayedOutLine = {22,22,22,255}
	gameSettings.warningColor = {235,165,61,160}
	gameSettings.pause = false
	gameSettings.continue = false
	gameSettings.eraserMode = false
	gameSettings.pencilMode = false
	gameSettings.x = love.mouse.getX()
	gameSettings.y = love.mouse.getY()
	gameSettings.maxSpeed = 10
	gameSettings.reactionTime = 0.12
	gameSettings.sound = true
	loadOptions()
	gameSettings.sensitivity = gameSettings.sensitivity or 1
	
	
	gameData.gameTime = 0
	gameData.realTime = 0
	gameData.updateTime = 0
	gameData.highScore = gameData.highScore or loadHighScore()
	gameData.droppedBlocks = 0
	gameData.score = 0
	gameData.currentRemovedLines = 0
	gameData.removedLines = 0
	gameData.level = 1
	gameData.warning = false
	gameData.combo = false
	gameData.comboTurns = 0
	gameData.comboLines = 0
	gameData.comboPoints = 0
	gameData.sprites = {}
		gameData.sprites.eraser = love.image.newImageData("sprites/eraser.png")
		gameData.sprites.pencil = love.image.newImageData("sprites/pencil.png")
	gameData.sounds = {}
		gameData.sounds.combo = love.audio.newSource("sounds/combo.wav", "static")
		gameData.sounds.sCombo = love.audio.newSource("sounds/superCombo.wav", "static")
		gameData.sounds.mCombo = love.audio.newSource("sounds/megaCombo.wav", "static")
		gameData.sounds.umCombo = love.audio.newSource("sounds/ultraMegaCombo.wav", "static")
		gameData.sounds.sumCombo = love.audio.newSource("sounds/superUltraMegaCombo.wav", "static")
	
	activeShape = Block.newRandom(gameSettings.vars())
	queue[1] = Block.newDummyRandom(gameSettings.dummyVars1())
	queue[2] = Block.newDummyRandom(gameSettings.dummyVars2())
	
	local id = ""
	local w,h = love.graphics.getDimensions()
	
	animatedBG = ButtonManager.new()
	
	bMMenu = ButtonManager.new()
	bMMenu.font = love.graphics.newFont(18)
	bMMenu.margin = 5
	
	bMOpt = ButtonManager.new()
	bMOpt.font = love.graphics.newFont(18)
	bMOpt.margin = 5
	
	bM = ButtonManager.new()
	bM.font = love.graphics.newFont(15)
	bM.margin = 5
	
	bMGO = ButtonManager.new()
	bMGO.font = love.graphics.newFont(22)
	bMGO.margin = 5
	
	local titleSize = 15
	local titleW, titleH = titleSize*21,  titleSize*5
	local titleTopOffset = 10
	
	id = "title"
	animatedBG:newButton(A_TitleScreen.new(animatedBG,	id,	0,	(w-titleW)/2,	titleTopOffset, titleSize, w, gameSettings.size))
	
	local menuW, menuH = w*4/6, h*6/8
	local menuX, menuY = (w-menuW)/2, titleTopOffset+titleH + (h-titleTopOffset-titleH-menuH)/2
	local buttonW, buttonH = menuW*2/3, h/12
	local sideOffset, topOffset, bottomOffset, buttonSpacing = (menuW-buttonW)/2, 30, 10, 10
	

	
	id = "menuBG"
	bMMenu:newButton(TextLabelTrans.new(bMMenu,id,menuX, menuY, menuW, menuH,""))
	bMMenu:getButton(id).color.default = {0,0,0,220}
	
	id = "newGame"
	bMMenu:newButton(B_UnderLinedText.new(bMMenu,id,menuX+sideOffset,menuY+topOffset,buttonW, buttonH,"New game"))
	bMMenu:addEvent(id, function() newGame() end)
	
	id = "continue"
	bMMenu:newButton(B_UnderLinedText.new(bMMenu,id,menuX+sideOffset,menuY+buttonH+topOffset+buttonSpacing,buttonW, buttonH,"Continue"))
	grayOutButton(id,bMMenu)
	
	id = "options"
	bMMenu:newButton(B_UnderLinedText.new(bMMenu,id,menuX+sideOffset,menuY+buttonH*2+topOffset+buttonSpacing*2,buttonW, buttonH,"Options"))
	bMMenu:addEvent(id, function() gameSettings.mode = "options" end)
	
	id = "exit"
	bMMenu:newButton(B_UnderLinedText.new(bMMenu,id,menuX+sideOffset,menuY+menuH-buttonH-bottomOffset,buttonW, buttonH,"Exit"))
	bMMenu:addEvent(id, function() exitGame() end)
	
	
	id = "menuBG"
	bMOpt:newButton(TextLabelTrans.new(bMOpt,id,menuX, menuY, menuW, menuH,""))
	bMOpt:getButton(id).color.default = {0,0,0,220}
	
	id = "enableSound"
	local s = "OFF"
	if gameSettings.sound then s = "ON" end
	bMOpt:newButton(B_Text.new(bMOpt,id,menuX+sideOffset,menuY+topOffset,buttonW, buttonH,("Sound is: %s"):format(s)))
	bMOpt:addEvent(id, function() local id, s = "enableSound", "OFF";  gameSettings.sound = not gameSettings.sound; if gameSettings.sound then s = "ON" end; bMOpt:getButton(id):refresh(("Sound is: %s"):format(s));end)
	
	id = "sensitivity"
	bMOpt:newButton(TextLabel.new(bMOpt,id,menuX+sideOffset,menuY+buttonH+buttonSpacing+topOffset,buttonW*3/4, buttonH,("Sensitivity: %.2f"):format(gameSettings.sensitivity)))
	
	id = "sensUpTriangle"
	bMOpt:newButton(B_Triangle.new(bMOpt,id,menuX+sideOffset+4/5*buttonW,menuY+buttonH+buttonSpacing+topOffset,buttonW*1/6, buttonH/2-2))
	bMOpt:addEvent(id, function() gameSettings.sensitivity = math.min(gameSettings.sensitivity + 0.005,3); bMOpt:getButton("sensitivity"):refresh(("Sensitivity: %.2f"):format(gameSettings.sensitivity)) end, "dragged")
	
	id = "sensDownTriangle"
	bMOpt:newButton(B_Triangle.new(bMOpt,id,menuX+sideOffset+4/5*buttonW,menuY+buttonH*2+buttonSpacing+topOffset-(buttonH/2-2),buttonW*1/6, buttonH/2-2,"down"))
	bMOpt:addEvent(id, function() gameSettings.sensitivity = math.max(gameSettings.sensitivity - 0.005,0.5); bMOpt:getButton("sensitivity"):refresh(("Sensitivity: %.2f"):format(gameSettings.sensitivity)) end, "dragged")
	
	id = "resetHS"
	bMOpt:newButton(B_Text.new(bMOpt,id,menuX+sideOffset,menuY+buttonH*2+buttonSpacing*2+topOffset,buttonW, buttonH,"Reset High Score"))
	bMOpt:addEvent(id, function() resetHS() end)
	
	id = "highScore"
	bMOpt:newButton(TextLabel.new(bMOpt,id,menuX+sideOffset,menuY+buttonH*3+buttonSpacing*3+topOffset,buttonW, buttonH,("High Score: %d"):format(gameData.highScore)))
	bMOpt:addEvent(id, function() resetHS() end)
	
	id = "back"
	bMOpt:newButton(B_UnderLinedText.new(bMOpt,id,menuX+sideOffset,menuY+menuH-buttonH-bottomOffset,buttonW, buttonH,"Back"))
	bMOpt:addEvent(id, function() saveOptions() end)
	
	id = "level"
	bM:newButton(TextLabel.new(bM,id,315,10,90,30,("Level: %d"):format(gameData.level)))
	
	id = "score"
	bM:newButton(TextLabel.new(bM,id,315,190,90,50,("Score\n %d"):format(gameData.score)))
	
	id = "lines"
	bM:newButton(TextLabel.new(bM,id,315,245,90,50,("Lines\n %d"):format(gameData.removedLines)))
		
	id = "highScore"
	bM:newButton(TextLabel.new(bM,id,315,300,90,50,("High Score\n %d"):format(gameData.highScore)))
	
	id = "fade"
	bM:newButton(TextLabelTrans.new(bM,id,0,0,w,h,""))
	bM:getButton(id).color.default = {175,175,175,0}
	
	id = "replay"
	bM:newButton(B_UnderLinedText.new(bM,id,315,430,90,30,"Restart"))
	grayOutButton(id,bM)
	
	id = "menu"
	bM:newButton(B_UnderLinedText.new(bM,id,315,465,90,30,"Main Menu"))
	grayOutButton(id,bM)
	
	id = "exit"
	bM:newButton(B_UnderLinedText.new(bM,id,315,500,90,30,"Exit"))
	grayOutButton(id,bM)
	
	id = "pause"
	bM:newButton(B_UnderLinedText.new(bM,id,315,395,90,30,"Pause"))
	bM:addEvent(id, function() pauseGame() end)
	
	menuX, menuY = (w-menuW)/2, (h-menuH)/2
	topOffset = 10
	
	id = "fade"
	bMGO:newButton(TextLabelTrans.new(bMGO,id,0,0,w,h,""))
	bMGO:getButton(id).color.default = {175,175,175,175}
	
	id = "gameOverBG"
	bMGO:newButton(TextLabelTrans.new(bMGO,id,menuX, menuY, menuW, menuH,("Game Over\n\n\nYou scored: %d points"):format(gameData.score)))
	bMGO:getButton(id).color.default = {0,0,0,220}
	
	id = "replay"
	bMGO:newButton(B_UnderLinedText.new(bMGO,id,menuX+sideOffset,menuY+menuH-3*buttonH-buttonSpacing*2-bottomOffset,buttonW, buttonH,"Restart"))
	bMGO:addEvent(id, function() newGame() end)
	
	id = "menu"
	bMGO:newButton(B_UnderLinedText.new(bMGO,id,menuX+sideOffset,menuY+menuH-2*buttonH-buttonSpacing-bottomOffset,buttonW, buttonH,"Main Menu"))
	bMGO:addEvent(id, function() gameSettings.mode = "menu" end)
	
	id = "exit"
	bMGO:newButton(B_UnderLinedText.new(bMGO,id,menuX+sideOffset,menuY+menuH-buttonH-bottomOffset,buttonW, buttonH,"Exit"))
	bMGO:addEvent(id, function() exitGame() end)
end

function grayOutButton(id, buttonMan)
	local button = buttonMan:getButton(id)
	button.color.default = gameSettings.grayedOut
	button.color.hovered = gameSettings.grayedOut
	button.color.clicked = gameSettings.grayedOut
	button.color.line = gameSettings.grayedOutLine
end

function backToMainMenu()
	local id = "continue"
	gameSettings.continue = true
	bMMenu:getButton(id):resetColor()
	bMMenu:addEvent(id,function() gameSettings.mode = "game"; grayOutButton(id,bMMenu); bMMenu:removeEvent(id); end)
end
function pauseGame()
	local id = "pause" gameSettings.pause = not gameSettings.pause
	if gameSettings.pause then 	bM:getButton(id):refresh("Unpause", 'p')
		bM:getButton("fade").color.default[4] = 175	
		
		bM:getButton("exit"):resetColor()
		bM:addEvent("exit", function() exitGame() end)
		
		bM:getButton("menu"):resetColor()
		bM:addEvent("menu", function() backToMainMenu(); gameSettings.mode = "menu" end)
		
		bM:getButton("replay"):resetColor()
		bM:addEvent("replay", function() newGame() end)
	else 
		bM:getButton(id):refresh("Pause")
		
		grayOutButton("exit",bM)
		bM:removeEvent("exit")
		
		grayOutButton("menu",bM)
		bM:removeEvent("menu")
		
		grayOutButton("replay",bM)
		bM:removeEvent("replay")
		
		bM:getButton("fade").color.default[4] = 0 
	end	
end

function resetHS()
	gameData.highScore = 0
	bMOpt:getButton("highScore"):refresh(("High score: %d"):format(gameData.highScore))
	saveHighScore()
end
function removeLine(lineNumber)
	shapes.lMax = shapes.lMax + gameSettings.size
	for i=shapes.n,1,-1 do
		if shapes[i].center[2] == lineNumber then
			table.remove(shapes,i)
			shapes.n = shapes.n - 1
		end
	end
	print(shapes.n)
	gameData.currentRemovedLines = gameData.currentRemovedLines + 1
	gameData.removedLines = gameData.removedLines + 1
	gameData.comboLines = gameData.comboLines + 1
	gameData.combo = true
	moveLinesDown(lineNumber)
end

function moveLinesDown(removedLineNumber)
	for i=shapes.n,1,-1 do
		if shapes[i].center[2] < removedLineNumber then
			for j=2,8,2 do
				shapes[i][j] = shapes[i][j] + gameSettings.size
			end
			shapes[i].center[2] = shapes[i].center[2] + gameSettings.size
		end
	end
end

function checkForLines()
	for i=(gameSettings.fieldHeight-0.5)*gameSettings.size,shapes.lMax,-gameSettings.size do
		local count = 0
		for j=1,shapes.n,1 do
			if shapes[j].center[2] == i then
				count = count + 1
			end
			if count == 10 then
				removeLine(i)
				return true
			end
		end
	end
	return false
end

function checkForGameOver()
	if shapes.lMax < 0 then
		gameData.highScore = math.max(gameData.highScore, gameData.score)
		saveHighScore()
		gameSettings.mode = "gameOver"
	end
end

function shoveUp(randLow, randHigh)
	if randLow 	then assert(randLow >0 and randLow < 10,"1st input must be between 1 and 9") end
	if randHigh then assert(randHigh > randLow and randHigh < 10,"2nd input must be between 1st input and 9") end
	for i=1,shapes.n,1 do
		for j=2,8,2 do
			shapes[i][j] = shapes[i][j] - gameSettings.size
		end
		shapes[i].center[2] = shapes[i].center[2] - gameSettings.size
	end
	shapes.lMax = shapes.lMax - gameSettings.size
	local rand = love.math.random(randLow or 7,randHigh or 9)
	local randX = {1,2,3,4,5,6,7,8,9,10}
	for i=1,rand,1 do
		local randXChoice = love.math.random(1,11-i)
		local x = randX[randXChoice]
		local t = {	x*gameSettings.size,	    (gameSettings.fieldHeight-1)*gameSettings.size,
					x*gameSettings.size,		 gameSettings.fieldHeight*gameSettings.size,
					(x-1)*gameSettings.size,	 gameSettings.fieldHeight*gameSettings.size,
					(x-1)*gameSettings.size,		(gameSettings.fieldHeight-1)*gameSettings.size,
					center = {(x-0.5)*gameSettings.size,(gameSettings.fieldHeight-0.5)*gameSettings.size}
					}
		table.remove(randX,randXChoice)
		shapes.n = shapes.n + 1
		shapes[shapes.n] = t
		bM:newButton(A_TetrisBlockPart.new(bM,"blockPlaced".. shapes.n .. shapes.lMax, 3, t))
	end		
end

function spawnNewBlock()
	for i=1,4 do																									--- Add old block to the pile
		shapes.n = shapes.n + 1
		shapes[shapes.n] = activeShape.parts[i]
		shapes.lMax = math.min(shapes.lMax,activeShape.parts[i].center[2])
		bM:newButton(A_TetrisBlockPart.new(bM,"blockPlaced".. shapes.n .. shapes.lMax, 3, activeShape.parts[i]))
	end
	gameData.combo = false																							-- allow checking for combo again
	gameData.droppedBlocks = gameData.droppedBlocks + 1 															-- a block was dropped
	
	while checkForLines() do end																					-- checks for lines, removes them, prepares for scoring and checks combo
	
	if gameData.combo then 
		gameData.comboTurns = gameData.comboTurns + 1 
		local comboString = ""
		if gameData.comboTurns > 1 then 
			if gameData.comboTurns > 5 then
				comboString = "SUPER ULTRA MEGA COMBO"
				if gameSettings.sound then gameData.sounds.sumCombo:play() end
			elseif gameData.comboTurns > 4 then
				comboString = "ULTRA MEGA COMBO"
				if gameSettings.sound then gameData.sounds.umCombo:play() end
			elseif gameData.comboTurns > 3 then
				comboString = "MEGA COMBO"
				if gameSettings.sound then gameData.sounds.mCombo:play() end
			elseif gameData.comboTurns > 2 then
				comboString = "SUPER COMBO"
				if gameSettings.sound then gameData.sounds.sCombo:play() end
			else
				comboString = "COMBO"
			if gameSettings.sound then gameData.sounds.combo:play() end
			end
		end
		local font = love.graphics.newFont(70)
		local _, yMod = font:getWrap(comboString,gameSettings.fieldWidth*gameSettings.size)
		bM:newButton(A_Text.new(bM,"comboText1",1.2 , 0 , 0 ,gameSettings.fieldWidth*gameSettings.size,gameSettings.fieldHeight*gameSettings.size,comboString,font))
	else 
		scoreComboPoints() 
	end
	if gameData.currentRemovedLines > 0 then
		scorePoints()							-- checks for scoring
	end
	if gameData.level > 10 then					-- add extra lines at bottom @ higher lvls
		if math.min(gameData.level,20) + gameData.droppedBlocks > 23 then
			gameData.warning = true
		end
		if math.min(gameData.level,20) + gameData.droppedBlocks > 25 then
			shoveUp()
			gameData.droppedBlocks =0
			gameData.warning = false
		end
	else
		gameData.droppedBlocks = 0				-- reset dropped blocks before reaching lvl 10+
	end
	checkForGameOver()							-- check for gameover
	
	activeShape = Block.new(queue[1].typeName,queue[1].rotation,gameSettings)					-- actual new blocks part
	queue[1] = Block.newDummy(queue[2].typeName,queue[2].rotation,gameSettings.dummyVars1())
	queue[2] = Block.newDummyRandom(gameSettings.dummyVars2())
end

function scorePoints()
	local points = gameData.currentRemovedLines^2*(100 + 10 * (gameData.level-1))
	gameData.score = gameData.score + points
	gameData.level = math.max(gameData.level, 1 + math.floor(gameData.removedLines / 10))
	updateScore()
	gameData.droppedBlocks = math.max(gameData.droppedBlocks - gameData.currentRemovedLines,0)
	gameData.currentRemovedLines = 0
	print("scoring: ", points )
end

function scoreComboPoints()
	if gameData.comboTurns > 1 then
		local cPoints = gameData.comboLines / 4 *(gameData.comboTurns + math.floor(gameData.level/5) ) ^2 * 100
		gameData.score = gameData.score + cPoints
		updateScore()
		print("scored combo points: ", cPoints)
	end
	gameData.comboTurns = 0
	gameData.comboLines = 0
end

function updateScore()
	bM:getButton("level"):refresh(("Level: %d"):format(gameData.level))
	bM:getButton("lines"):refresh(("Lines\n %d"):format(gameData.removedLines))
	bM:getButton("score"):refresh(("Score\n %d"):format(gameData.score))
	bMOpt:getButton("highScore"):refresh(gameData.highScore)
	bMGO:getButton("gameOverBG"):refresh(("Game Over\n\n\nYou scored: %d points"):format(gameData.score))
end

function saveHighScore()		
	if not love.filesystem.exists('hs.lua') then
		file = love.filesystem.newFile('hs.lua')
	end
	love.filesystem.write('hs.lua', ("return %d"):format(gameData.highScore))
end

function loadHighScore()
	if love.filesystem.exists('hs.lua') then
		local chunk = love.filesystem.load('hs.lua')
	    return chunk() or 0
	end
	return 0
end

function saveOptions()		
	if not love.filesystem.exists('opts.lua') then
		file = love.filesystem.newFile('opts.lua')
	end
	love.filesystem.write('opts.lua', ("return %s, %f"):format(tostring(gameSettings.sound),gameSettings.sensitivity))
	gameSettings.mode = "menu"
end

function loadOptions()
	if love.filesystem.exists('opts.lua') then
		local chunk = love.filesystem.load('opts.lua')
		gameSettings.sound, gameSettings.sensitivity = chunk()
	end
end

function loadDevLVL()
	local fct = require('dev.devLVL')
	shapes = fct(gameSettings.size, gameSettings.fieldWidth, gameSettings.fieldHeight)
	gameSettings.shapes = shapes
	activeShape = Block.new(1,1,gameSettings)
	gameData.score = gameData.score -1000000
end

function noCheats()
	gameSettings.pencilMode = false
	gameSettings.eraserMode = false
end

function love.keypressed(key)
	modCtrl, modShift = love.keyboard.isDown( "lctrl" ), love.keyboard.isDown( "lshift" )
	if gameSettings.mode == "game" then
		if key == "p" then
			pauseGame()
		elseif key == "r" and modCtrl then
			noCheats()
			gameSettings.pencilMode = true
			setCursor()
		elseif key == "z" and modCtrl then
			noCheats()
			gameSettings.eraserMode = true
			setCursor()
		elseif key == "escape" then
			noCheats()
			setCursor()
		--elseif key == "d" and modCtrl and modShift then
		--	loadDevLVL()
		end
		if gameSettings.pause then
			if key == "r" and not modCtrl then
				newGame()
			elseif key == "e" then
				exitGame()
			elseif key == "m" then
				backToMainMenu()
				gameSettings.mode = "menu" 
			end
		else
			if key == ' ' then
				if activeShape:pushDown() then
					spawnNewBlock()
				end
			elseif key == "up" then
					activeShape:rotate("clockwise")
			end
		end
	elseif gameSettings.mode == "gameOver" then
		if key == "r" then
			newGame()
		elseif key == "e" then
			exitGame()
		elseif key == "m" then
			gameSettings.mode = "menu"
		end
	elseif gameSettings.mode == "menu" then
		if key == "n" then
			newGame()
		elseif key == "c" and gameSettings.continue then
			local id = "continue"
			gameSettings.mode = "game"
			grayOutButton(id,bMMenu)
			bMMenu:removeEvent(id)
		elseif key == "o" then
			gameSettings.mode = "options"
		elseif key == "e" then
			exitGame()
		end
	else
		if key == "b" then
			saveOptions()
		end
	end
end

function newGame()
	gameSettings.mode = "game"
	noCheats()
	setCursor()
	love.load()
end

function exitGame()
	love.event.quit()
end

function setCursor()
	if gameSettings.eraserMode then
		love.mouse.setCursor(love.mouse.newCursor( gameData.sprites.eraser, 27, 57 ))
	elseif gameSettings.pencilMode then
		love.mouse.setCursor(love.mouse.newCursor( gameData.sprites.pencil, 13, 67 ))
	else
		love.mouse.setCursor()
	end
end

function updateGame(dt)
	gameSettings.x = love.mouse.getX()
	gameSettings.y = love.mouse.getY()
	if love.mouse.isDown(2) then
		noCheats()
	end
	if gameSettings.eraserMode and love.mouse.isDown("l") then
			for i=shapes.n,1,-1 do
				if gameSettings.x >= shapes[i].center[1] - 0.5 * gameSettings.size and gameSettings.x <= shapes[i].center[1] + 0.5 * gameSettings.size then
					if gameSettings.y >= shapes[i].center[2] - 0.5 * gameSettings.size and gameSettings.y <= shapes[i].center[2] + 0.5 * gameSettings.size then
						table.remove(shapes,i)
						shapes.n = shapes.n - 1
						gameData.score = gameData.score - 16000
						updateScore()
					end
				end
			end
	end	
		if gameSettings.pencilMode and love.mouse.isDown("l") and gameSettings.x > 0 and gameSettings.x < gameSettings.fieldWidth*gameSettings.size and gameSettings.y > 0 and gameSettings.y < gameSettings.fieldHeight*gameSettings.size then
			local x, y = math.floor(gameSettings.x / gameSettings.size), math.floor(gameSettings.y / gameSettings.size)
			local center = { (x + 0.5)* gameSettings.size,	(y + 0.5) * gameSettings.size}
			local bool = true
			for i=shapes.n,1,-1 do
				if shapes[i].center[1] == center[1] and shapes[i].center[2] == center[2] then
					bool = false
					break
				end
			end
				if bool then				
					local t = 	{	x * gameSettings.size	,	y * gameSettings.size,
									(x + 1) * gameSettings.size	,	y * gameSettings.size,
									(x + 1) * gameSettings.size	,	(y + 1) * gameSettings.size,
									x * gameSettings.size		,	(y + 1) * gameSettings.size,
									center = center
								}																						
					table.insert(shapes,t)
					gameData.score = gameData.score - 16000
					updateScore()
					shapes.n = shapes.n + 1
				end
		end
	bM:update(dt, love.mouse.getX(), love.mouse.getY(),love.mouse.isDown("l"))
	if  not gameSettings.pause then
		gameData.realTime = gameData.realTime + dt		
		if  gameData.realTime - gameData.updateTime > gameSettings.reactionTime / gameSettings.sensitivity then
			if love.keyboard.isDown("left") then
				activeShape:translate(-1,0)
				gameData.updateTime = gameData.realTime
			end
			if love.keyboard.isDown("right") then
				activeShape:translate(1,0)
				gameData.updateTime = gameData.realTime
			end
			if love.keyboard.isDown("down") then
				if not activeShape:translate(0,1) then
					spawnNewBlock()
				end
				gameData.updateTime = gameData.realTime
			end
		end
		
		if gameData.warning and math.floor(gameData.realTime) % 2 == 0 then
			gameSettings.warningColor[4] = 25
		else
			gameSettings.warningColor[4] = 160
		end
		gameData.gameTime = gameData.gameTime + dt*(0.5 + math.min(gameData.level,gameSettings.maxSpeed)/2)
		if gameData.gameTime > 1 then
			if not activeShape:translate(0,1) then
				spawnNewBlock()
			end
		gameData.gameTime = gameData.gameTime - math.floor(gameData.gameTime)
		end
	end
end

function updateGameOver(dt)
	print(bMGO.mouseX, bMGO.mouseY)
	bMGO:update(dt, love.mouse.getX(), love.mouse.getY(),love.mouse.isDown("l"))
end

function updateMenu(dt)
	gameData.realTime = gameData.realTime + dt
	animatedBG:update(dt, love.mouse.getX(), love.mouse.getY(),love.mouse.isDown("l"))
	bMMenu:update(dt, love.mouse.getX(), love.mouse.getY(),love.mouse.isDown("l"))
end

function updateOptions(dt)
	gameData.realTime = gameData.realTime + dt
	animatedBG:update(dt, love.mouse.getX(), love.mouse.getY(),love.mouse.isDown("l"))
	bMOpt:update(dt, love.mouse.getX(), love.mouse.getY(),love.mouse.isDown("l"))
end

function love.update(dt)
	if gameSettings.mode == "game" then
		updateGame(dt)
	elseif gameSettings.mode == "gameOver" then
		updateGameOver(dt)
	elseif gameSettings.mode == "menu" then
		updateMenu(dt)
	else
		updateOptions(dt)
	end
end

local function drawGame()
	love.graphics.setColor(gameSettings.raster.color)
	love.graphics.setLineWidth(gameSettings.raster.lineW)
	for i=1,gameSettings.fieldWidth-1,1 do
		love.graphics.line(i*gameSettings.size,0,i*gameSettings.size,gameSettings.fieldHeight*gameSettings.size)
	end
	for i=1,gameSettings.fieldHeight-1,1 do
		love.graphics.line(0,i*gameSettings.size,gameSettings.fieldWidth*gameSettings.size,i*gameSettings.size)
	end
	for i=1,shapes.n,1 do
		love.graphics.setColor(125,125,125)
		love.graphics.polygon("fill",shapes[i])
		love.graphics.setColor(0,0,0)
		love.graphics.polygon("line",shapes[i])
	end
	if gameData.warning then
		love.graphics.setColor(gameSettings.warningColor)
		love.graphics.circle("fill",150,677,182)
	end
	activeShape:draw()
	
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill",300,0,120,540)
		
	love.graphics.setColor(gameSettings.labelColor)
	love.graphics.rectangle("fill",315,50,90,90,5)
	love.graphics.setColor(255,255,255,175)
	love.graphics.rectangle("line",315,50,90,90,5)
	queue[1]:draw()
	
	love.graphics.setColor(gameSettings.labelColor)
	love.graphics.rectangle("fill",340,145,40,40,5)
	love.graphics.setColor(255,255,255,175)
	love.graphics.rectangle("line",340,145,40,40,5)
	queue[2]:draw()
	
	bM:draw()
end

function drawMenuBG()
	love.graphics.setColor(gameSettings.raster.color)
	love.graphics.setLineWidth(gameSettings.raster.lineW)
	for i=1,gameSettings.width-1,1 do
		love.graphics.line(i*gameSettings.size,0,i*gameSettings.size,gameSettings.height*gameSettings.size)
	end
	for i=1,gameSettings.height-1,1 do
		love.graphics.line(0,i*gameSettings.size,gameSettings.width*gameSettings.size,i*gameSettings.size)
	end
end

function love.draw()
	love.graphics.setBackgroundColor(gameSettings.bgColor)
	if gameSettings.mode == "game" or gameSettings.mode == "gameOver" then
		drawGame()
		if gameSettings.mode == "gameOver" then
		bMGO:draw()
		end
	else
		drawMenuBG()
		animatedBG:draw()
		if gameSettings.mode == "menu" then
			bMMenu:draw()
		else
			bMOpt:draw()
		end
	end
end







