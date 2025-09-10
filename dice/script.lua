-- Dice Game Logic
local winsCount = 0
local lossesCount = 0
local totalRolls = 0
local isRolling = false

-- Get DOM elements
local diceDisplay = gurt.select('#dice-display')
local guessInput = gurt.select('#origin')
local rollButton = gurt.select('#roll-button')
local result = gurt.select('#result')
local winsDisplay = gurt.select('#wins-count')
local lossesDisplay = gurt.select('#losses-count')
local totalDisplay = gurt.select('#total-rolls')

-- Function to update stats display
local function updateDisplay()
    winsDisplay.text = tostring(winsCount)
    lossesDisplay.text = tostring(lossesCount)
    totalDisplay.text = tostring(totalRolls)
end

-- Function to roll the dice
local function rollDice()
    if isRolling then
        return
    end

    -- Get user's guess
    local guess = tonumber(guessInput.value)
    if guess == nil or guess < 1 or guess > 6 then
        result.text = "Please enter a number between 1 and 6!"
        result.style = "text-2xl font-bold text-[#ef4444] mb-8 text-center"
        return
    end

    -- Check if user has enough balance for the bet
    local balance = tonumber(gurt.crumbs.get("balance"))
    if balance < 50 then
        result.text = "Insufficient balance! You need at least 50 chips to play."
        result.style = "text-2xl font-bold text-[#ef4444] mb-8 text-center"
        return
    end
    
    isRolling = true
    rollButton.text = "Rolling..."
    result.text = ""
    
    -- Animate dice rolling by changing numbers rapidly
    local rollCount = 0
    local rollInterval = setInterval(function()
        rollCount = rollCount + 1
        local animNumber = math.random(1, 6)
        diceDisplay.text = tostring(animNumber)
    end, 100)
    
    -- Generate final dice result (1-6)
    local diceResult = math.random(1, 6)
    
    -- Stop rolling animation and show final result after 1 second
    setTimeout(function()
        clearInterval(rollInterval)
        
        -- Show final dice result
        diceDisplay.text = tostring(diceResult)
        
        -- Check if guess matches dice result
        if guess == diceResult then
            -- Win: give 300 chips
            balance = balance + 300
            result.text = "🎉 You guessed correctly! +300 chips!"
            result.style = "text-2xl font-bold text-[#10b981] mb-8 text-center"
            winsCount = winsCount + 1
        else
            -- Lose: lose 50 chips
            balance = balance - 50
            result.text = "❌ Wrong guess! You rolled " .. diceResult .. ". -50 chips"
            result.style = "text-2xl font-bold text-[#ef4444] mb-8 text-center"
            lossesCount = lossesCount + 1
        end
        
        -- Update balance with animation
        updateBalance(balance)
        
        totalRolls = totalRolls + 1
        updateDisplay()
        
        rollButton.text = "Roll Dice"
        isRolling = false
        
        trace.log("Dice roll result: " .. diceResult .. ", guess: " .. guess)
    end, 1000)
end

-- Add click event listener
rollButton:on('click', rollDice)

-- Initialize random seed
math.randomseed(Time.now())

-- Initialize display
updateDisplay()

trace.log("Dice game initialized!")
