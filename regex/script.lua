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
    -- Basic patterns
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
    },
    -- Advanced patterns - much more challenging!
    {
        pattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$",
        testCases = {
            {text = "Password123!", matches = true},
            {text = "MySecure1@", matches = true},
            {text = "password123", matches = false},
            {text = "PASSWORD123!", matches = false},
            {text = "Pass1!", matches = false}
        }
    },
    {
        pattern = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$",
        testCases = {
            {text = "user.name+tag@example.co.uk", matches = true},
            {text = "test_123@sub.domain.org", matches = true},
            {text = "invalid@.com", matches = false},
            {text = "user@domain.", matches = false},
            {text = "@domain.com", matches = false}
        }
    },
    {
        pattern = "^\\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12]\\d|3[01])$",
        testCases = {
            {text = "2023-12-25", matches = true},
            {text = "2024-02-29", matches = true},
            {text = "2023-13-25", matches = false},
            {text = "2023-12-32", matches = false},
            {text = "23-12-25", matches = false}
        }
    },
    {
        pattern = "^((25[0-5]|2[0-4]\\d|[01]?\\d\\d?)\\.){3}(25[0-5]|2[0-4]\\d|[01]?\\d\\d?)$",
        testCases = {
            {text = "192.168.1.1", matches = true},
            {text = "255.255.255.255", matches = true},
            {text = "256.1.1.1", matches = false},
            {text = "192.168.1", matches = false},
            {text = "192.168.01.1", matches = true}
        }
    },
    {
        pattern = "^[+]?[(]?[\\d\\s\\-\\(\\)]{10,}$",
        testCases = {
            {text = "+1 (555) 123-4567", matches = true},
            {text = "(555) 123-4567", matches = true},
            {text = "555-123-4567", matches = true},
            {text = "555 123 4567", matches = true},
            {text = "123456789", matches = false}
        }
    },
    {
        pattern = "^(?:https?:\\/\\/)?(?:www\\.)?[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}(?:\\/[^\\s]*)?$",
        testCases = {
            {text = "https://www.example.com/path", matches = true},
            {text = "http://example.com", matches = true},
            {text = "www.example.com", matches = true},
            {text = "example.com/path?param=value", matches = true},
            {text = "not-a-url", matches = false}
        }
    },
    {
        pattern = "^[A-Z]{1,2}\\d{1,4}\\s?\\d[A-Z]{2}$",
        testCases = {
            {text = "SW1A 1AA", matches = true},
            {text = "M1 1AA", matches = true},
            {text = "B33 8TH", matches = true},
            {text = "12345", matches = false},
            {text = "SW1A1AA", matches = true}
        }
    },
    {
        pattern = "^[A-Z]{2}\\d{2}\\s?[A-Z]{4}\\s?\\d{2}$",
        testCases = {
            {text = "GB29 NWBK 6016 1331 9268 19", matches = false},
            {text = "AB12 CDEF 34", matches = true},
            {text = "XY99WXYZ56", matches = true},
            {text = "AB1234567890", matches = false},
            {text = "ab12 cdef 34", matches = false}
        }
    },
    {
        pattern = "^(?=.*[a-z].*[a-z])(?=.*[A-Z].*[A-Z])(?=.*\\d.*\\d)(?=.*[!@#$%^&*()].*[!@#$%^&*()])\\S{12,}$",
        testCases = {
            {text = "MyVerySecure123!@#", matches = true},
            {text = "ANOTHER-Strong99$$", matches = true},
            {text = "WeakPassword1!", matches = false},
            {text = "Strong123!@", matches = false},
            {text = "TooShort1!", matches = false}
        }
    },
    {
        pattern = "^\\d{1,3}(,\\d{3})*(\\.\\d{2})?$",
        testCases = {
            {text = "1,234,567.89", matches = true},
            {text = "999", matches = true},
            {text = "12,345", matches = true},
            {text = "1234", matches = false},
            {text = "1,23,456", matches = false}
        }
    },
    {
        pattern = "^([01]?\\d|2[0-3]):[0-5]\\d(:[0-5]\\d)?$",
        testCases = {
            {text = "23:59:59", matches = true},
            {text = "09:30", matches = true},
            {text = "1:05", matches = true},
            {text = "24:00", matches = false},
            {text = "12:60", matches = false}
        }
    },
    {
        pattern = "^(?=[MDCLXVI])M{0,4}(C[MD]|D?C{0,3})(X[CL]|L?X{0,3})(I[XV]|V?I{0,3})$",
        testCases = {
            {text = "MCMXC", matches = true},
            {text = "MMXXIII", matches = true},
            {text = "IV", matches = true},
            {text = "IIII", matches = false},
            {text = "ABC", matches = false}
        }
    },
    {
        pattern = "^[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}$",
        testCases = {
            {text = "550e8400-e29b-41d4-a716-446655440000", matches = true},
            {text = "6ba7b810-9dad-11d1-80b4-00c04fd430c8", matches = true},
            {text = "550e8400-e29b-41d4-a716-44665544000", matches = false},
            {text = "550e8400e29b41d4a716446655440000", matches = false},
            {text = "not-a-uuid", matches = false}
        }
    },
    {
        pattern = "^[+-]?(?:\\d+(?:\\.\\d*)?|\\.\\d+)(?:[eE][+-]?\\d+)?$",
        testCases = {
            {text = "123.456", matches = true},
            {text = "-3.14159", matches = true},
            {text = "1.23e-4", matches = true},
            {text = ".5", matches = true},
            {text = "not_a_number", matches = false}
        }
    },
    {
        pattern = "^\\s*[a-zA-Z_$][a-zA-Z0-9_$]*\\s*=\\s*(?:\"[^\"]*\"|'[^']*'|[^;]+);\\s*$",
        testCases = {
            {text = "var name = \"John\";", matches = true},
            {text = "  $value = 123;  ", matches = true},
            {text = "_test = 'hello';", matches = true},
            {text = "123invalid = \"test\";", matches = false},
            {text = "name = value", matches = false}
        }
    },
    {
        pattern = "^[A-Za-z0-9+/]{4}*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?$",
        testCases = {
            {text = "SGVsbG8gV29ybGQ=", matches = true},
            {text = "dGVzdA==", matches = true},
            {text = "YWJjZGVm", matches = true},
            {text = "invalid base64!", matches = false},
            {text = "SGVsbG8gV29ybGQ", matches = false}
        }
    },
    {
        pattern = "^(?:\\+?1[-. ]?)?\\(?([0-9]{3})\\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$",
        testCases = {
            {text = "+1 (555) 123-4567", matches = true},
            {text = "555.123.4567", matches = true},
            {text = "(555) 123 4567", matches = true},
            {text = "15551234567", matches = true},
            {text = "555-123-456", matches = false}
        }
    },
    {
        pattern = "^\\s*<\\s*([a-zA-Z][a-zA-Z0-9-]*)\\s*(?:[^>]*)>.*</\\s*\\1\\s*>\\s*$",
        testCases = {
            {text = "<div>content</div>", matches = true},
            {text = "<p class=\"test\">text</p>", matches = true},
            {text = "  <span>  data  </span>  ", matches = true},
            {text = "<div>content</span>", matches = false},
            {text = "<img src=\"test.jpg\">", matches = false}
        }
    },
    {
        pattern = "^(?=.*\\w)(?=.*[.,!?;:])(?=.*\\s)[\\w\\s.,!?;:]{20,}$",
        testCases = {
            {text = "This is a complete sentence with punctuation!", matches = true},
            {text = "Another valid example; it has many words.", matches = true},
            {text = "Short text!", matches = false},
            {text = "No punctuation here", matches = false},
            {text = "Nospaces,butpunctuation!", matches = false}
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
