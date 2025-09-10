-- Initialize balance
local balance = gurt.crumbs.get("balance")
if balance == nil then
    gurt.crumbs.set({
        name = "balance",
        value = 100
    })
end

-- Game variables
local symbols = {"A", "B", "C", "D", "6", "8", "7"}
local isSpinning = false
local wins = 0
local losses = 0
local totalSpins = 0
local bigWins = 0

-- Get DOM elements
local slot1 = gurt.select('#slot-1')
local slot2 = gurt.select('#slot-2')
local slot3 = gurt.select('#slot-3')
local spinButton = gurt.select('#spin-button')
local betInput = gurt.select('#bet-input')
local result = gurt.select('#result')
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

-- Get random symbol
local function getRandomSymbol()
    local index = math.random(1, 7)
    return symbols[index]
end

-- Calculate winnings based on symbols
local function calculateWin(sym1, sym2, sym3, betAmount)
    -- Check for three of a kind
    if sym1 == sym2 and sym2 == sym3 then
        if sym1 == "🍒" then
            return betAmount * 2
        elseif sym1 == "🍋" then
            return betAmount * 3
        elseif sym1 == "🍊" then
            return betAmount * 4
        elseif sym1 == "🍇" then
            return betAmount * 5
        elseif sym1 == "⭐" then
            return betAmount * 10
        elseif sym1 == "💎" then
            return betAmount * 20
        elseif sym1 == "7" then
            return betAmount * 50
        end
    end
    
    -- Check for two of a kind (half payout)
    if sym1 == sym2 or sym2 == sym3 or sym1 == sym3 then
        local symbol = sym1
        if sym2 == sym3 then 
            symbol = sym2 
        end
        
        if symbol == "🍒" then
            return betAmount
        elseif symbol == "🍋" then
            return math.floor(betAmount * 1.5)
        elseif symbol == "🍊" then
            return betAmount * 2
        elseif symbol == "🍇" then
            return math.floor(betAmount * 2.5)
        elseif symbol == "⭐" then
            return betAmount * 5
        elseif symbol == "💎" then
            return betAmount * 10
        elseif symbol == "7" then
            return betAmount * 25
        end
    end
    
    return 0
end

-- Animate slot spinning
local function animateSlot(slotElement, duration)
    local interval = setInterval(function()
        local randomSymbol = getRandomSymbol()
        slotElement.text = randomSymbol
    end, 80)
    
    setTimeout(function()
        clearInterval(interval)
    end, duration)
end

-- Main spin function
local function spinSlots()
    if isSpinning then
        return
    end
    
    -- Get bet amount and current balance
    local betText = betInput.value
    local betAmount = tonumber(betText)
    local currentBalance = tonumber(gurt.crumbs.get("balance"))
    
    -- Validate bet amount
    if betAmount == nil or betAmount <= 0 then
        result.text = "Enter a valid bet amount"
        result.style = "text-2xl font-bold text-[#ef4444] mb-6 min-h-[2rem]"
        return
    end
    
    -- Check if player has enough balance
    if currentBalance < betAmount then
        result.text = "Not enough balance"
        result.style = "text-2xl font-bold text-[#ef4444] mb-6 min-h-[2rem]"
        return
    end
    
    -- Start spinning
    isSpinning = true
    spinButton.text = "Spinning..."
    result.text = "Good luck!"
    result.style = "text-2xl font-bold text-[#fbbf24] mb-6 min-h-[2rem]"
    
    -- Animate all slots with different durations
    animateSlot(slot1, 1000)
    animateSlot(slot2, 1500)
    animateSlot(slot3, 2000)
    
    -- Set final results after animation
    setTimeout(function()
        local finalSym1 = getRandomSymbol()
        local finalSym2 = getRandomSymbol()
        local finalSym3 = getRandomSymbol()
        
        slot1.text = finalSym1
        slot2.text = finalSym2
        slot3.text = finalSym3
        
        -- Calculate winnings
        local winAmount = calculateWin(finalSym1, finalSym2, finalSym3, betAmount)
        local newBalance = currentBalance
        
        if winAmount > 0 then
            newBalance = newBalance + winAmount - betAmount
            wins = wins + 1
            
            if winAmount >= betAmount * 10 then
                bigWins = bigWins + 1
                result.text = "BIG WIN! " .. winAmount .. " chips!"
                result.style = "text-3xl font-bold text-[#ffd700] mb-6 min-h-[2rem]"
            else
                result.text = "You Won " .. winAmount .. " chips!"
                result.style = "text-2xl font-bold text-[#10b981] mb-6 min-h-[2rem]"
            end
        else
            newBalance = newBalance - betAmount
            losses = losses + 1
            result.text = "No match - Lost " .. betAmount .. " chips"
            result.style = "text-2xl font-bold text-[#ef4444] mb-6 min-h-[2rem]"
        end
        
        totalSpins = totalSpins + 1
        
        -- Save new balance
        gurt.crumbs.set({
            name = "balance",
            value = newBalance
        })
        local balanceElement = gurt.select('#wallet-balance')
        balanceElement.text = tostring(newBalance)
        
        -- Update stats and reset button
        updateStats()
        spinButton.text = "SPIN"
        isSpinning = false
        
        trace.log("Spin complete - Result: " .. finalSym1 .. finalSym2 .. finalSym3 .. " Win: " .. winAmount)
    end, 2200)
end

-- Navigation event handlers
local function setupNavigation()
    local navHome = gurt.select('#nav-home')
    local navSlots = gurt.select('#nav-slots')
    local navBlackjack = gurt.select('#nav-blackjack')
    local navRoulette = gurt.select('#nav-roulette')
    local navPoker = gurt.select('#nav-poker')
    local navDice = gurt.select('#nav-dice')
    local navCoinflip = gurt.select('#nav-coinflip')
    
    navHome:on('click', function() gurt.location.goto('/') end)
    navSlots:on('click', function() gurt.location.goto('/slots') end)
    navBlackjack:on('click', function() gurt.location.goto('/blackjack') end)
    navRoulette:on('click', function() gurt.location.goto('/roulette') end)
    navPoker:on('click', function() gurt.location.goto('/poker') end)
    navDice:on('click', function() gurt.location.goto('/dice') end)
    navCoinflip:on('click', function() gurt.location.goto('/coinflip') end)
end

-- Initialize game
local function initialize()
    -- Event listeners
    spinButton:on('click', spinSlots)
    
    -- Setup navigation
    setupNavigation()
    
    -- Initialize random seed and stats
    math.randomseed(Time.now())
    updateStats()
    
    trace.log("Slot machine initialized")
end

-- Start the game
initialize()
