-- Blackjack Game Logic
local playerCards = {}
local dealerCards = {}
local deck = {}
local gameState = "betting" -- betting, playing, dealer, finished
local playerScore = 0
local dealerScore = 0
local currentBet = 0
local gamesWon = 0
local gamesLost = 0
local totalGames = 0

-- Card values and suits
local suits = {"♠", "♥", "♦", "♣"}
local ranks = {"A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"}
local values = {A = 11, ["2"] = 2, ["3"] = 3, ["4"] = 4, ["5"] = 5, ["6"] = 6, ["7"] = 7, ["8"] = 8, ["9"] = 9, ["10"] = 10, J = 10, Q = 10, K = 10}

-- Get DOM elements
local playerCardsEl = gurt.select('#player-cards')
local dealerCardsEl = gurt.select('#dealer-cards')
local playerScoreEl = gurt.select('#player-score')
local dealerScoreEl = gurt.select('#dealer-score')
local gameStatusEl = gurt.select('#game-status')
local betAmountEl = gurt.select('#bet-amount')
local dealButton = gurt.select('#deal-button')
local hitButton = gurt.select('#hit-button')
local standButton = gurt.select('#stand-button')
local newGameButton = gurt.select('#new-game-button')
local gamesWonEl = gurt.select('#games-won')
local gamesLostEl = gurt.select('#games-lost')
local totalGamesEl = gurt.select('#total-games')
local playerOverall = gurt.select('#player-overall')

-- Initialize deck
local function initializeDeck()
    deck = {}
    for _, suit in ipairs(suits) do
        for _, rank in ipairs(ranks) do
            table.insert(deck, {rank = rank, suit = suit})
        end
    end
    -- Shuffle deck
    for i = #deck, 2, -1 do
        local j = math.random(i)
        deck[i], deck[j] = deck[j], deck[i]
    end
end

-- Calculate hand value
local function calculateHandValue(cards)
    local value = 0
    local aces = 0
    
    for _, card in ipairs(cards) do
        if card.rank == "A" then
            aces = aces + 1
            value = value + 11
        else
            value = value + values[card.rank]
        end
    end
    
    -- Handle aces
    while value > 21 and aces > 0 do
        value = value - 10
        aces = aces - 1
    end
    
    return value
end

-- Display cards
local function displayCards(cards, element, hideFirst)
    if #cards == 0 then
        element.text = "No cards"
        return
    end
    
    local cardDisplay = ""
    for i, card in ipairs(cards) do
        if hideFirst and i == 1 then
            -- Hidden card
            cardDisplay = cardDisplay .. "HIDDEN  "
        else
            -- Visible card - simple format
            cardDisplay = cardDisplay .. card.rank .. card.suit .. "  "
        end
    end
    
    if element then
        element.text = cardDisplay
        trace.log("Displaying cards: " .. cardDisplay)
    else
        trace.log("Element not found for card display")
    end
end

-- Update scores
local function updateScores()
    playerScore = calculateHandValue(playerCards)
    dealerScore = calculateHandValue(dealerCards)
    playerScoreEl.text = tostring(playerScore)
    playerOverall.text = "You: " .. tostring(playerScore)
    if gameState == "playing" or gameState == "betting" then
        dealerScoreEl.text = "?"
    else
        dealerScoreEl.text = tostring(dealerScore)
    end
end

-- Update game status
local function updateGameStatus(message)
    gameStatusEl.text = message
end

-- Update stats
local function updateStats()
    gamesWonEl.text = tostring(gamesWon)
    gamesLostEl.text = tostring(gamesLost)
    totalGamesEl.text = tostring(totalGames)
end

-- Deal initial cards
local function dealCards()
    currentBet = 50
    
    local balance = tonumber(gurt.crumbs.get("balance"))
    if currentBet > balance then
        updateGameStatus("Insufficient balance!")
        return
    end
    
    
    initializeDeck()
    playerCards = {}
    dealerCards = {}
    
    -- Deal 2 cards to each
    table.insert(playerCards, table.remove(deck))
    table.insert(dealerCards, table.remove(deck))
    table.insert(playerCards, table.remove(deck))
    table.insert(dealerCards, table.remove(deck))
    
    gameState = "playing"
    betAmountEl.text = "Bet: " .. currentBet
    
    displayCards(playerCards, playerCardsEl, false)
    displayCards(dealerCards, dealerCardsEl, true)
    updateScores()
    
    -- Check for blackjack
    if playerScore == 21 then
        stand()
    else
        updateGameStatus("Your turn! Hit or Stand?")
    end
end

-- Stand function
local function stand()
    if gameState ~= "playing" then return end
    
    gameState = "dealer"
    displayCards(dealerCards, dealerCardsEl, false)
    updateScores()
    
    -- Dealer plays
    while dealerScore < 17 do
        table.insert(dealerCards, table.remove(deck))
        dealerScore = calculateHandValue(dealerCards)
        displayCards(dealerCards, dealerCardsEl, false)
        updateScores()
    end
    
    gameState = "finished"
    
    -- Determine winner
    if dealerScore > 21 then
        updateGameStatus("Dealer busts! You win!")
        endGame(true)
    elseif dealerScore > playerScore then
        updateGameStatus("Dealer wins!")
        endGame(false)
    elseif playerScore > dealerScore then
        updateGameStatus("You win!")
        endGame(true)
    else
        updateGameStatus("Push! It's a tie!")
        endGame(nil) -- tie
    end
end

-- End game function
local function endGame(playerWon)
    local balance = tonumber(gurt.crumbs.get("balance"))
    
    if playerWon == true then
        -- Player wins
        balance = balance + currentBet
        gamesWon = gamesWon + 1
    elseif playerWon == false then
        -- Player loses
        balance = balance - currentBet
        gamesLost = gamesLost + 1
    end
    -- If tie (nil), no money change
    
    totalGames = totalGames + 1
    
    -- Update balance with animation
    updateBalance(balance)
    
    updateStats()
end

-- Hit function
local function hit()
    if gameState ~= "playing" then return end
    
    table.insert(playerCards, table.remove(deck))
    displayCards(playerCards, playerCardsEl, false)
    updateScores()
    
    if playerScore > 21 then
        gameState = "finished"
        updateGameStatus("Bust! You lose!")
        endGame(false)
    elseif playerScore == 21 then
        stand()
    end
end

-- New game function
local function newGame()
    gameState = "betting"
    playerCards = {}
    dealerCards = {}
    playerScore = 0
    dealerScore = 0
    currentBet = 0
    
    playerCardsEl.text = ""
    dealerCardsEl.text = ""
    playerScoreEl.text = "0"
    dealerScoreEl.text = "0"
    betAmountEl.text = "Bet: 50 chips per game"
    updateGameStatus("Click Deal to start! (50 chips per game)")
    
    -- Show/hide buttons
    dealButton.style = "display: inline-block; bg-[#7c3aed] text-white px-8 py-3 rounded-lg font-bold cursor-pointer hover:bg-[#8b5cf6] border-none"
    hitButton.style = "display: none"
    standButton.style = "display: none"
    newGameButton.style = "display: none"
end

-- Event listeners
dealButton:on('click', dealCards)
hitButton:on('click', hit)
standButton:on('click', stand)
newGameButton:on('click', newGame)

-- Initialize random seed and game
math.randomseed(Time.now())
newGame()
updateStats()

trace.log("Blackjack game initialized!")
