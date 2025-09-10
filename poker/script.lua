-- Initialize balance
local balance = gurt.crumbs.get("balance")
if balance == nil then
    gurt.crumbs.set({
        name = "balance",
        value = 100
    })
end

-- Game variables
local deck = {}
local playerHand = {}
local dealerHand = {}
local gameState = "betting" -- betting, dealing, player_turn, dealer_turn, game_over
local currentBet = 0
local wins = 0
local losses = 0
local totalHands = 0
local bigWins = 0

-- Card suits and values
local suits = {"♠", "♥", "♦", "♣"}
local values = {"A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"}

-- Get DOM elements
local betInput = gurt.select('#bet-input')
local dealButton = gurt.select('#deal-button')
local hitButton = gurt.select('#hit-button')
local standButton = gurt.select('#stand-button')
local result = gurt.select('#result')
local playerCards = gurt.select('#player-cards')
local dealerCards = gurt.select('#dealer-cards')
local playerScore = gurt.select('#player-score')
local dealerScore = gurt.select('#dealer-score')
local winsDisplay = gurt.select('#wins-count')
local lossesDisplay = gurt.select('#losses-count')
local totalDisplay = gurt.select('#total-count')
local bigWinsDisplay = gurt.select('#big-wins-count')

-- Update stats display
local function updateStats()
    winsDisplay.text = tostring(wins)
    lossesDisplay.text = tostring(losses)
    totalDisplay.text = tostring(totalHands)
    bigWinsDisplay.text = tostring(bigWins)
end

-- Create and shuffle deck
local function createDeck()
    deck = {}
    for _, suit in ipairs(suits) do
        for _, value in ipairs(values) do
            table.insert(deck, {suit = suit, value = value})
        end
    end
    
    -- Shuffle deck
    for i = #deck, 2, -1 do
        local j = math.random(i)
        deck[i], deck[j] = deck[j], deck[i]
    end
end

-- Calculate hand value
local function calculateHandValue(hand)
    local value = 0
    local aces = 0
    
    for _, card in ipairs(hand) do
        if card.value == "A" then
            aces = aces + 1
            value = value + 11
        elseif card.value == "J" or card.value == "Q" or card.value == "K" then
            value = value + 10
        else
            value = value + tonumber(card.value)
        end
    end
    
    -- Adjust for aces
    while value > 21 and aces > 0 do
        value = value - 10
        aces = aces - 1
    end
    
    return value
end

-- Display hand
local function displayHand(hand, element, hideFirst)
    local cardText = ""
    for i, card in ipairs(hand) do
        if hideFirst and i == 1 then
            cardText = cardText .. "[??] "
        else
            local color = ""
            if card.suit == "♥" or card.suit == "♦" then
                color = "text-[#ef4444]"
            else
                color = "text-white"
            end
            cardText = cardText .. "<span class='" .. color .. "'>[" .. card.value .. card.suit .. "]</span> "
        end
    end
    element.innerHTML = cardText
end

-- Deal initial cards
local function dealInitialCards()
    playerHand = {}
    dealerHand = {}
    
    -- Deal 2 cards to each
    table.insert(playerHand, table.remove(deck, 1))
    table.insert(dealerHand, table.remove(deck, 1))
    table.insert(playerHand, table.remove(deck, 1))
    table.insert(dealerHand, table.remove(deck, 1))
    
    displayHand(playerHand, playerCards, false)
    displayHand(dealerHand, dealerCards, true)
    
    playerScore.text = "Score: " .. calculateHandValue(playerHand)
    dealerScore.text = "Score: ?"
end

-- Hit (take another card)
local function hit()
    if gameState ~= "player_turn" then
        return
    end
    
    table.insert(playerHand, table.remove(deck, 1))
    displayHand(playerHand, playerCards, false)
    
    local playerValue = calculateHandValue(playerHand)
    playerScore.text = "Score: " .. playerValue
    
    if playerValue > 21 then
        -- Player busted
        gameState = "game_over"
        result.text = "BUST! You lose " .. currentBet .. " chips"
        result.style = "text-2xl font-bold text-[#ef4444] mb-6"
        endHand(false)
    elseif playerValue == 21 then
        -- Automatic stand on 21
        stand()
    end
end

-- Stand (end player turn)
local function stand()
    if gameState ~= "player_turn" then
        return
    end
    
    gameState = "dealer_turn"
    result.text = "Dealer's turn..."
    result.style = "text-2xl font-bold text-[#fbbf24] mb-6"
    
    -- Show dealer's hidden card
    displayHand(dealerHand, dealerCards, false)
    dealerScore.text = "Score: " .. calculateHandValue(dealerHand)
    
    -- Dealer hits until 17 or higher
    setTimeout(function()
        dealerPlay()
    end, 1000)
end

-- Dealer plays automatically
local function dealerPlay()
    local dealerValue = calculateHandValue(dealerHand)
    
    if dealerValue < 17 then
        table.insert(dealerHand, table.remove(deck, 1))
        displayHand(dealerHand, dealerCards, false)
        dealerValue = calculateHandValue(dealerHand)
        dealerScore.text = "Score: " .. dealerValue
        
        setTimeout(function()
            dealerPlay()
        end, 1000)
    else
        -- Determine winner
        local playerValue = calculateHandValue(playerHand)
        
        if dealerValue > 21 then
            -- Dealer busted
            result.text = "Dealer BUST! You win " .. (currentBet * 2) .. " chips!"
            result.style = "text-2xl font-bold text-[#10b981] mb-6"
            endHand(true)
        elseif playerValue > dealerValue then
            -- Player wins
            result.text = "You win " .. (currentBet * 2) .. " chips!"
            result.style = "text-2xl font-bold text-[#10b981] mb-6"
            endHand(true)
        elseif dealerValue > playerValue then
            -- Dealer wins
            result.text = "Dealer wins! You lose " .. currentBet .. " chips"
            result.style = "text-2xl font-bold text-[#ef4444] mb-6"
            endHand(false)
        else
            -- Tie
            result.text = "Push! Bet returned"
            result.style = "text-2xl font-bold text-[#888888] mb-6"
            endHand(false, true)
        end
    end
end

-- End hand and update balance
local function endHand(playerWon, tie)
    gameState = "betting"
    local currentBalance = tonumber(gurt.crumbs.get("balance"))
    local newBalance = currentBalance
    
    if tie then
        -- Return bet on tie
        newBalance = currentBalance
    elseif playerWon then
        newBalance = currentBalance + currentBet
        wins = wins + 1
        if currentBet >= 50 then
            bigWins = bigWins + 1
        end
    else
        newBalance = currentBalance - currentBet
        losses = losses + 1
    end
    
    totalHands = totalHands + 1
    
    -- Save balance
    gurt.crumbs.set({
        name = "balance",
        value = newBalance
    })
    local balanceElement = gurt.select('#wallet-balance')
    balanceElement.text = tostring(newBalance)
    
    updateStats()
    
    -- Reset UI
    dealButton.text = "DEAL"
    dealButton.style = dealButton.style:gsub("opacity%-50", "")
    hitButton.style = hitButton.style .. " opacity-50"
    standButton.style = standButton.style .. " opacity-50"
    
    trace.log("Hand complete - Player won: " .. tostring(playerWon) .. " Bet: " .. currentBet)
end

-- Deal cards
local function dealCards()
    if gameState ~= "betting" then
        return
    end
    
    local betText = betInput.value
    local betAmount = tonumber(betText)
    local currentBalance = tonumber(gurt.crumbs.get("balance"))
    
    -- Validate bet
    if betAmount == nil or betAmount <= 0 then
        result.text = "Enter a valid bet amount"
        result.style = "text-2xl font-bold text-[#ef4444] mb-6"
        return
    end
    
    if currentBalance < betAmount then
        result.text = "Not enough balance"
        result.style = "text-2xl font-bold text-[#ef4444] mb-6"
        return
    end
    
    currentBet = betAmount
    createDeck()
    dealInitialCards()
    
    gameState = "player_turn"
    result.text = "Your turn - Hit or Stand?"
    result.style = "text-2xl font-bold text-[#fbbf24] mb-6"
    
    -- Update UI
    dealButton.text = "DEALING..."
    dealButton.style = dealButton.style .. " opacity-50"
    hitButton.style = hitButton.style:gsub("opacity%-50", "")
    standButton.style = standButton.style:gsub("opacity%-50", "")
    
    -- Check for blackjack
    local playerValue = calculateHandValue(playerHand)
    local dealerValue = calculateHandValue(dealerHand)
    
    if playerValue == 21 then
        if dealerValue == 21 then
            -- Both have blackjack
            displayHand(dealerHand, dealerCards, false)
            dealerScore.text = "Score: " .. dealerValue
            result.text = "Both Blackjack! Push!"
            result.style = "text-2xl font-bold text-[#888888] mb-6"
            endHand(false, true)
        else
            -- Player blackjack
            result.text = "BLACKJACK! You win " .. math.floor(currentBet * 2.5) .. " chips!"
            result.style = "text-3xl font-bold text-[#ffd700] mb-6"
            setTimeout(function()
                displayHand(dealerHand, dealerCards, false)
                dealerScore.text = "Score: " .. dealerValue
                endHand(true)
            end, 1000)
        end
    end
end

-- Navigation setup
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
    dealButton:on('click', dealCards)
    hitButton:on('click', hit)
    standButton:on('click', stand)
    setupNavigation()
    
    math.randomseed(Time.now())
    updateStats()
    
    -- Initial UI state
    result.text = "Place your bet and deal!"
    result.style = "text-2xl font-bold text-white mb-6"
    playerCards.innerHTML = ""
    dealerCards.innerHTML = ""
    playerScore.text = ""
    dealerScore.text = ""
    
    hitButton.style = hitButton.style .. " opacity-50"
    standButton.style = standButton.style .. " opacity-50"
    
    trace.log("Poker (Blackjack) initialized")
end

-- Start the game
initialize()
