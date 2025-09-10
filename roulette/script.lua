-- Initialize balance
local balance = gurt.crumbs.get("balance")
if balance == nil then
    gurt.crumbs.set({
        name = "balance",
        value = 100
    })
end

-- Game variables
local isSpinning = false
local wins = 0
local losses = 0
local totalSpins = 0
local bigWins = 0
local currentBet = 0
local selectedNumbers = {}
local selectedColors = {}
local selectedTypes = {}

-- Roulette numbers with colors (0 is green, odd reds, even blacks in European style)
local rouletteNumbers = {
    {number = 0, color = "green"},
    {number = 1, color = "red"}, {number = 2, color = "black"}, {number = 3, color = "red"}, {number = 4, color = "black"},
    {number = 5, color = "red"}, {number = 6, color = "black"}, {number = 7, color = "red"}, {number = 8, color = "black"},
    {number = 9, color = "red"}, {number = 10, color = "black"}, {number = 11, color = "black"}, {number = 12, color = "red"},
    {number = 13, color = "black"}, {number = 14, color = "red"}, {number = 15, color = "black"}, {number = 16, color = "red"},
    {number = 17, color = "black"}, {number = 18, color = "red"}, {number = 19, color = "red"}, {number = 20, color = "black"},
    {number = 21, color = "red"}, {number = 22, color = "black"}, {number = 23, color = "red"}, {number = 24, color = "black"},
    {number = 25, color = "red"}, {number = 26, color = "black"}, {number = 27, color = "red"}, {number = 28, color = "black"},
    {number = 29, color = "black"}, {number = 30, color = "red"}, {number = 31, color = "black"}, {number = 32, color = "red"},
    {number = 33, color = "black"}, {number = 34, color = "red"}, {number = 35, color = "red"}, {number = 36, color = "black"}
}

-- Get DOM elements
local betInput = gurt.select('#bet-input')
local spinButton = gurt.select('#spin-button')
local result = gurt.select('#result')
local winningNumber = gurt.select('#winning-number')
local winsDisplay = gurt.select('#wins-count')
local lossesDisplay = gurt.select('#losses-count')
local totalDisplay = gurt.select('#total-count')
local bigWinsDisplay = gurt.select('#big-wins-count')

-- Update stats display
local function updateStats()
    winsDisplay.text = tostring(wins)
    lossesDisplay.text = tostring(losses)
    totalDisplay.text = tostring(totalSpins)
    bigWinsDisplay.text = tostring(bigWins)
end

-- Get number color
local function getNumberColor(num)
    for i = 1, #rouletteNumbers do
        if rouletteNumbers[i].number == num then
            return rouletteNumbers[i].color
        end
    end
    return "black"
end

-- Calculate winnings
local function calculateWin(winNum, betAmount)
    local totalWin = 0
    
    -- Check number bets (35:1 payout)
    for i = 1, #selectedNumbers do
        if selectedNumbers[i] == winNum then
            totalWin = totalWin + (betAmount * 35)
        end
    end
    
    -- Check color bets (1:1 payout)
    local winColor = getNumberColor(winNum)
    for i = 1, #selectedColors do
        if selectedColors[i] == winColor and winNum ~= 0 then
            totalWin = totalWin + (betAmount * 2)
        end
    end
    
    -- Check type bets (1:1 payout)
    for i = 1, #selectedTypes do
        if selectedTypes[i] == "even" and winNum > 0 and winNum % 2 == 0 then
            totalWin = totalWin + (betAmount * 2)
        elseif selectedTypes[i] == "odd" and winNum > 0 and winNum % 2 == 1 then
            totalWin = totalWin + (betAmount * 2)
        elseif selectedTypes[i] == "low" and winNum >= 1 and winNum <= 18 then
            totalWin = totalWin + (betAmount * 2)
        elseif selectedTypes[i] == "high" and winNum >= 19 and winNum <= 36 then
            totalWin = totalWin + (betAmount * 2)
        end
    end
    
    return totalWin
end

-- Toggle bet selection
local function toggleBet(betType, value)
    trace.log("toggleBet called with type: " .. betType .. " value: " .. tostring(value))
    
    if betType == "number" then
        local found = false
        for i = 1, #selectedNumbers do
            if selectedNumbers[i] == value then
                table.remove(selectedNumbers, i)
                found = true
                trace.log("Removed number bet: " .. value)
                break
            end
        end
        if not found then
            table.insert(selectedNumbers, value)
            trace.log("Added number bet: " .. value)
        end
        
        -- Animate visual indicator for number button
        local numBtn = gurt.select('#num-' .. value)
        if numBtn then
            if found then
                -- Animate deselection - scale down
                numBtn:createTween()
                    :to('scale', 1.0)
                    :to('opacity', 0.8)
                    :duration(0.2)
                    :easing('out')
                    :transition('quad')
                    :play()
            else
                -- Animate selection - scale up and glow
                numBtn:createTween()
                    :to('scale', 1.1)
                    :to('opacity', 1.0)
                    :duration(0.2)
                    :easing('out')
                    :transition('back')
                    :play()
            end
        end
        
    elseif betType == "color" then
        local found = false
        for i = 1, #selectedColors do
            if selectedColors[i] == value then
                table.remove(selectedColors, i)
                found = true
                trace.log("Removed color bet: " .. value)
                break
            end
        end
        if not found then
            table.insert(selectedColors, value)
            trace.log("Added color bet: " .. value)
        end
        
        -- Animate visual indicator for color button
        local colorBtn = gurt.select('#bet-' .. value)
        if colorBtn then
            if found then
                -- Animate deselection
                colorBtn:createTween()
                    :to('scale', 1.0)
                    :duration(0.2)
                    :easing('out')
                    :transition('quad')
                    :play()
            else
                -- Animate selection
                colorBtn:createTween()
                    :to('scale', 1.05)
                    :duration(0.2)
                    :easing('out')
                    :transition('back')
                    :play()
            end
        end
        
    elseif betType == "type" then
        local found = false
        for i = 1, #selectedTypes do
            if selectedTypes[i] == value then
                table.remove(selectedTypes, i)
                found = true
                trace.log("Removed type bet: " .. value)
                break
            end
        end
        if not found then
            table.insert(selectedTypes, value)
            trace.log("Added type bet: " .. value)
        end
        
        -- Animate visual indicator for type button
        local typeBtn = gurt.select('#bet-' .. value)
        if typeBtn then
            if found then
                -- Animate deselection
                typeBtn:createTween()
                    :to('scale', 1.0)
                    :duration(0.2)
                    :easing('out')
                    :transition('quad')
                    :play()
            else
                -- Animate selection
                typeBtn:createTween()
                    :to('scale', 1.05)
                    :duration(0.2)
                    :easing('out')
                    :transition('back')
                    :play()
            end
        end
    end
    
    -- Show current bets
    trace.log("Current bets - Numbers: " .. #selectedNumbers .. " Colors: " .. #selectedColors .. " Types: " .. #selectedTypes)
end

-- Clear all bets
local function clearBets()
    -- Reset number bet animations
    for i = 1, #selectedNumbers do
        local numBtn = gurt.select('#num-' .. selectedNumbers[i])
        if numBtn then
            numBtn:createTween()
                :to('scale', 1.0)
                :to('opacity', 1.0)
                :duration(0.15)
                :easing('out')
                :transition('quad')
                :play()
        end
    end
    
    -- Reset color bet animations
    for i = 1, #selectedColors do
        local colorBtn = gurt.select('#bet-' .. selectedColors[i])
        if colorBtn then
            colorBtn:createTween()
                :to('scale', 1.0)
                :duration(0.15)
                :easing('out')
                :transition('quad')
                :play()
        end
    end
    
    -- Reset type bet animations
    for i = 1, #selectedTypes do
        local typeBtn = gurt.select('#bet-' .. selectedTypes[i])
        if typeBtn then
            typeBtn:createTween()
                :to('scale', 1.0)
                :duration(0.15)
                :easing('out')
                :transition('quad')
                :play()
        end
    end
    
    selectedNumbers = {}
    selectedColors = {}
    selectedTypes = {}
end

-- Spin roulette
local function spinRoulette()
    if isSpinning then
        return
    end
    
    local betText = betInput.value
    local betAmount = tonumber(betText)
    local currentBalance = tonumber(gurt.crumbs.get("balance"))
    
    -- Validate bet
    if betAmount == nil or betAmount <= 0 then
        result.text = "Enter a valid bet amount"
        return
    end
    
    if currentBalance < betAmount then
        result.text = "Not enough balance"
        return
    end
    
    local totalBets = #selectedNumbers + #selectedColors + #selectedTypes
    local totalBetAmount = betAmount * totalBets
    
    if totalBets == 0 then
        result.text = "Select at least one bet"
        return
    end
    
    if currentBalance < totalBetAmount then
        result.text = "Not enough balance for all bets"
        return
    end
    
    -- Store current bet for tracking
    currentBet = totalBetAmount
    
    -- Start spinning
    isSpinning = true
    spinButton.text = "Spinning..."
    result.text = "The wheel is spinning..."
    -- Play roulette sound effect
    local rouletteAudio = gurt.select('#roulette-audio')
    if rouletteAudio then
        rouletteAudio.src = "../roulette.mp3"  -- Ensure the source is set
        rouletteAudio:play()
    end
    
    -- Animate spinning
    local spinCount = 0
    
    -- Add spinning animation to the winning number display
    winningNumber:createTween()
        :to('rotation', 360)
        :to('scale', 1.2)
        :duration(3.0)
        :easing('inout')
        :transition('linear')
        :play()
    
    local spinInterval = setInterval(function()
        local randomNum = math.random(0, 36)
        winningNumber.text = tostring(randomNum)
        spinCount = spinCount + 1
    end, 100)
    
    -- Stop spinning and show result
    setTimeout(function()
        clearInterval(spinInterval)
        
        -- Stop the spinning animation and show final number
        local finalNumber = math.random(0, 36)
        winningNumber.text = tostring(finalNumber)
        
        -- Animate final result with a bounce effect
        winningNumber:createTween()
            :to('scale', 1.0)
            :to('rotation', 0)
            :to('opacity', 1)
            :duration(0.5)
            :easing('out')
            :transition('bounce')
            :play()
        
        -- Add a pulse effect for the final number after bounce
        setTimeout(function()
            winningNumber:createTween()
                :to('scale', 1.3)
                :duration(0.3)
                :easing('inout')
                :transition('elastic')
                :play()
                
            -- Scale back down
            setTimeout(function()
                winningNumber:createTween()
                    :to('scale', 1.0)
                    :duration(0.3)
                    :easing('out')
                    :transition('back')
                    :play()
            end, 300)
        end, 600)
        
        local winAmount = calculateWin(finalNumber, betAmount)
        local newBalance = currentBalance - totalBetAmount + winAmount
        
        if winAmount > 0 then
            wins = wins + 1
            if winAmount >= totalBetAmount * 5 then
                bigWins = bigWins + 1
                result.text = "BIG WIN! Won " .. winAmount .. " chips!"
                
                -- Animate the result text for big wins
                result:createTween()
                    :to('scale', 1.2)
                    :duration(0.5)
                    :easing('out')
                    :transition('elastic')
                    :play()
            else
                result.text = "Winner! Won " .. winAmount .. " chips!"
            end
        else
            losses = losses + 1
            result.text = "House wins - Lost " .. totalBetAmount .. " chips"
        end
        
        totalSpins = totalSpins + 1
        
        -- Update balance with animation
        updateBalance(newBalance)
        
        updateStats()
        spinButton.text = "SPIN"
        isSpinning = false
        
        -- Clear bets for next round
        clearBets()
        
        trace.log("Roulette spin complete - Number: " .. finalNumber .. " Win: " .. winAmount)
    end, 3000)
end

-- Setup number bet buttons
local function setupNumberBets()
    for i = 0, 36 do
        local numBtn = gurt.select('#num-' .. i)
        if numBtn then
            trace.log("Setting up click handler for number: " .. i)
            numBtn:on('click', function()
                trace.log("Number button clicked: " .. i)
                toggleBet("number", i)
            end)
        else
            trace.log("Button not found for number: " .. i)
        end
    end
end

-- Setup color and type bets
local function setupOtherBets()
    local redBtn = gurt.select('#bet-red')
    local blackBtn = gurt.select('#bet-black')
    local evenBtn = gurt.select('#bet-even')
    local oddBtn = gurt.select('#bet-odd')
    local lowBtn = gurt.select('#bet-low')
    local highBtn = gurt.select('#bet-high')
    
    if redBtn then
        redBtn:on('click', function()
            toggleBet("color", "red")
        end)
    end
    
    if blackBtn then
        blackBtn:on('click', function()
            toggleBet("color", "black")
        end)
    end
    
    if evenBtn then
        evenBtn:on('click', function()
            toggleBet("type", "even")
        end)
    end
    
    if oddBtn then
        oddBtn:on('click', function()
            toggleBet("type", "odd")
        end)
    end
    
    if lowBtn then
        lowBtn:on('click', function()
            toggleBet("type", "low")
        end)
    end
    
    if highBtn then
        highBtn:on('click', function()
            toggleBet("type", "high")
        end)
    end
end

-- Navigation setup
local function setupNavigation()
    local navHome = gurt.select('#nav-home')
    local navSlots = gurt.select('#nav-slots')
    local navBlackjack = gurt.select('#nav-blackjack')
    local navRoulette = gurt.select('#nav-roulette')
    local navregex = gurt.select('#nav-regex')
    local navDice = gurt.select('#nav-dice')
    local navCoinflip = gurt.select('#nav-coinflip')
    
    navHome:on('click', function() gurt.location.goto('/') end)
    navSlots:on('click', function() gurt.location.goto('/slots') end)
    navBlackjack:on('click', function() gurt.location.goto('/blackjack') end)
    navRoulette:on('click', function() gurt.location.goto('/roulette') end)
    navregex:on('click', function() gurt.location.goto('/regex') end)
    navDice:on('click', function() gurt.location.goto('/dice') end)
    navCoinflip:on('click', function() gurt.location.goto('/coinflip') end)
end

-- Initialize game
local function initialize()
    spinButton:on('click', spinRoulette)
    setupNumberBets()
    setupOtherBets()
    setupNavigation()
    updateStats()
    
    winningNumber.text = "--"
    
    trace.log("Roulette initialized")
end

-- Start the game
initialize()
