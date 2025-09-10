-- Initialize balance
local balance = gurt.crumbs.get("balance")
if balance == nil then
    gurt.crumbs.set({
        name = "balance",
        value = 100
    })
end

-- Game variables
local currentPattern = nil
local currentTestString = nil
local correctAnswer = nil
local gameState = "waiting" -- waiting, answering, result
local correctCount = 0
local wrongCount = 0
local totalChallenges = 0

-- Regex patterns and test cases
local regexChallenges = {
    {
        pattern = "^[a-z]+$",
        testCases = {
            {text = "hello", matches = true},
            {text = "Hello", matches = false},
            {text = "hello123", matches = false},
            {text = "world", matches = true},
            {text = "test-case", matches = false}
        }
    },
    {
        pattern = "\\d{3}-\\d{3}-\\d{4}",
        testCases = {
            {text = "123-456-7890", matches = true},
            {text = "555-123-4567", matches = true},
            {text = "12-345-6789", matches = false},
            {text = "123-45-6789", matches = false},
            {text = "abc-def-ghij", matches = false}
        }
    },
    {
        pattern = "^[A-Z][a-z]*$",
        testCases = {
            {text = "Hello", matches = true},
            {text = "World", matches = true},
            {text = "HELLO", matches = false},
            {text = "hello", matches = false},
            {text = "Test123", matches = false}
        }
    },
    {
        pattern = "^\\w+@\\w+\\.\\w+$",
        testCases = {
            {text = "user@example.com", matches = true},
            {text = "test@site.org", matches = true},
            {text = "invalid.email", matches = false},
            {text = "user@domain", matches = false},
            {text = "@example.com", matches = false}
        }
    },
    {
        pattern = "\\b\\d{2}/\\d{2}/\\d{4}\\b",
        testCases = {
            {text = "12/25/2023", matches = true},
            {text = "01/01/2000", matches = true},
            {text = "1/1/2023", matches = false},
            {text = "12/25/23", matches = false},
            {text = "date: 03/15/2024", matches = true}
        }
    },
    {
        pattern = "^#[0-9a-fA-F]{6}$",
        testCases = {
            {text = "#FF0000", matches = true},
            {text = "#123abc", matches = true},
            {text = "#fff", matches = false},
            {text = "FF0000", matches = false},
            {text = "#GG0000", matches = false}
        }
    },
    {
        pattern = "^\\$\\d+\\.\\d{2}$",
        testCases = {
            {text = "$19.99", matches = true},
            {text = "$0.50", matches = true},
            {text = "$100.00", matches = true},
            {text = "19.99", matches = false},
            {text = "$19.9", matches = false}
        }
    },
    {
        pattern = "\\b[A-Z]{2,3}\\b",
        testCases = {
            {text = "USA", matches = true},
            {text = "UK", matches = true},
            {text = "Visit USA today", matches = true},
            {text = "usa", matches = false},
            {text = "A", matches = false}
        }
    }
}

-- Get DOM elements
local regexPatternDisplay = gurt.select('#regex-pattern')
local testStringDisplay = gurt.select('#test-string')
local yesButton = gurt.select('#yes-button')
local noButton = gurt.select('#no-button')
local newChallengeButton = gurt.select('#new-challenge-button')
local result = gurt.select('#result')
local correctDisplay = gurt.select('#correct-count')
local wrongDisplay = gurt.select('#wrong-count')
local totalDisplay = gurt.select('#total-challenges')
local accuracyDisplay = gurt.select('#accuracy')
-- Update stats display
local function updateStats()
    if correctDisplay then correctDisplay.text = tostring(correctCount) end
    if wrongDisplay then wrongDisplay.text = tostring(wrongCount) end
    if totalDisplay then totalDisplay.text = tostring(totalChallenges) end
    
    local accuracy = 0
    if totalChallenges > 0 then
        accuracy = math.floor((correctCount / totalChallenges) * 100)
    end
    if accuracyDisplay then accuracyDisplay.text = tostring(accuracy) .. "%" end
end

-- Generate a new challenge
local function generateChallenge()
    local currentBalance = tonumber(gurt.crumbs.get("balance"))
    
    -- Check if player has enough balance
    if currentBalance < 10 then
        if result then result.text = "Not enough chips! Need 10 chips to play" end
        return
    end
    
    -- Pick a random regex challenge
    local challengeIndex = math.random(1, #regexChallenges)
    local challenge = regexChallenges[challengeIndex]
    
    -- Pick a random test case
    local testCaseIndex = math.random(1, #challenge.testCases)
    local testCase = challenge.testCases[testCaseIndex]
    
    currentPattern = challenge.pattern
    currentTestString = testCase.text
    
    -- Use Gurt Regex API to determine the correct answer
    local regex = Regex.new(currentPattern)
    correctAnswer = regex:test(currentTestString)
    
    -- Update display
    if regexPatternDisplay then regexPatternDisplay.text = currentPattern end
    if testStringDisplay then testStringDisplay.text = currentTestString end
    
    gameState = "answering"
    if result then result.text = "Make your choice: YES or NO" end
    
end

-- Handle answer selection
local function selectAnswer(playerAnswer)
    if gameState ~= "answering" then
        return
    end
    
    gameState = "result"
    totalChallenges = totalChallenges + 1
    
    local currentBalance = tonumber(gurt.crumbs.get("balance"))
    local newBalance = currentBalance - 10 -- Deduct bet first
    
    if playerAnswer == correctAnswer then
        -- Correct answer
        correctCount = correctCount + 1
        newBalance = newBalance + 15 -- Win 15 chips (5 profit)
        
        if result then result.text = "CORRECT! You win 15 chips! (+5 profit)" end
    else
        -- Wrong answer
        wrongCount = wrongCount + 1
        
        local correctText = correctAnswer and "YES" or "NO"
        if result then result.text = "WRONG! The answer was " .. correctText .. ". You lose 10 chips." end
    end
    
    -- Update balance
    updateBalance(newBalance)
    updateStats()
end

-- Initialize game
local function initialize()
    if newChallengeButton then newChallengeButton:on('click', generateChallenge) end
    if yesButton then yesButton:on('click', function() selectAnswer(true) end) end
    if noButton then noButton:on('click', function() selectAnswer(false) end) end
    
    math.randomseed(Time.now())
    updateStats()
    
    -- Initial UI state
    if result then result.text = "Ready to play!" end
    
    trace.log("Regex Challenge initialized")
end

-- Start the game
initialize()
