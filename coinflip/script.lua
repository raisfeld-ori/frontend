-- Coinflip Game Logic
local gameStats = {
    wins = 0,
    losses = 0,
    total = 0
}
local isFlipping = false

-- Get DOM elements
local coin = gurt.select('#coin')
local result = gurt.select('#result')
local flipButton = gurt.select('#flipButton')
local choiceSelect = gurt.select('#choice-select')
local betInput = gurt.select('#bet-input')
local winsDisplay = gurt.select('#wins-count')
local lossesDisplay = gurt.select('#losses-count')
local totalDisplay = gurt.select('#total-count')

-- Update stats display
local function updateStats()
    winsDisplay.text = tostring(gameStats.wins)
    lossesDisplay.text = tostring(gameStats.losses)
    totalDisplay.text = tostring(gameStats.total)
end

-- Main flip function
local function flipCoin()
    if isFlipping then
        return
    end
    
    -- Get user inputs
    local userChoice = choiceSelect.value
    local betText = betInput.value
    local betAmount = tonumber(betText)
    local currentBalance = tonumber(gurt.crumbs.get("balance"))
    
    -- Validate inputs
    if betAmount == nil or betAmount - 1 >= currentBalance or betAmount <= 0 then
        result.text = "Enter a valid bet amount"
        result.style = "text-2xl font-bold text-[#ef4444] mb-8"
        return
    end
    
    if currentBalance - 1 <= betAmount then
        result.text = "Not enough balance"
        result.style = "text-2xl font-bold text-[#ef4444] mb-8"
        return
    end
    
    -- Start flipping
    isFlipping = true
    flipButton.text = "Flipping..."
    result.text = "Flipping..."
    result.style = "text-2xl font-bold text-[#fbbf24] mb-8"
    
    -- Play coin flip sound effect
    local coinFlipAudio = gurt.select('#coin-flip-audio')
    if coinFlipAudio then
        coinFlipAudio.src = "gurt://" .. gurt.location.href .. "/coin-flip.mp3"  -- Ensure the source is set
        coinFlipAudio:play()
    end
    
    -- Coin animation
    local animCount = 0
    local animation = setInterval(function()
        animCount = animCount + 1
        if animCount % 2 == 0 then
            coin.text = "6"
            coin.style = "w-[300px] h-[300px] rounded-full bg-[#ffd700] border-4 border-[#f59e0b] text-4xl font-bold text-[#92400e] cursor-pointer mx-auto flex items-center justify-center"
        else
            coin.text = "7"
            coin.style = "w-[300px] h-[300px] rounded-full bg-[#d1d5db] border-4 border-[#9ca3af] text-4xl font-bold text-[#374151] cursor-pointer mx-auto flex items-center justify-center"
        end
    end, 100)
    
    -- Get random result
    local coinResult = math.random(0, 1)
    
    -- Stop animation and show result
    setTimeout(function()
        clearInterval(animation)
        
        -- Check if user won
        local won = false
        if (userChoice == "6" and coinResult == 0) or (userChoice == "7" and coinResult == 1) then
            won = true
        end
        
        -- Update balance
        local newBalance = currentBalance
        if won then
            newBalance = newBalance + betAmount
            gameStats.wins = gameStats.wins + 1
        else
            newBalance = newBalance - betAmount
            gameStats.losses = gameStats.losses + 1
        end
        gameStats.total = gameStats.total + 1
        
        -- Update balance with animation
        updateBalance(newBalance)
        
        -- Show final coin state
        if coinResult == 0 then
            coin.text = "6"
            coin.style = "w-[300px] h-[300px] rounded-full bg-[#ffd700] border-4 border-[#f59e0b] text-4xl font-bold text-[#92400e] cursor-pointer mx-auto flex items-center justify-center"
        else
            coin.text = "7"
            coin.style = "w-[300px] h-[300px] rounded-full bg-[#d1d5db] border-4 border-[#9ca3af] text-4xl font-bold text-[#374151] cursor-pointer mx-auto flex items-center justify-center"
        end
        
        -- Show result message
        if won then
            result.text = "You Won " .. betAmount .. " chips"
            result.style = "text-2xl font-bold text-[#10b981] mb-8"
        else
            result.text = "You Lost " .. betAmount .. " chips"
            result.style = "text-2xl font-bold text-[#ef4444] mb-8"
        end
        
        -- Update display
        updateStats()
        flipButton.text = "Flip Again"
        isFlipping = false
        
        trace.log("Flip complete - Result: " .. (coinResult == 0 and "6" or "7") .. " Won: " .. tostring(won))
    end, 1500)
end

-- Event listeners
flipButton:on('click', flipCoin)
coin:on('click', flipCoin)

-- Initialize
math.randomseed(Time.now())
updateStats()

trace.log("Coinflip initialized")
