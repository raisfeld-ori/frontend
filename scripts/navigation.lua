-- Navigation event handlers
local navHome = gurt.select('#nav-home')
local navSlots = gurt.select('#nav-slots')
local navBlackjack = gurt.select('#nav-blackjack')
local navRoulette = gurt.select('#nav-roulette')
local navregex = gurt.select('#nav-regex')
local navDice = gurt.select('#nav-dice')
local navCoinflip = gurt.select('#nav-coinflip')
local navNews = gurt.select('#nav-news')
local navCard = gurt.select('#slots_card')
local blackjackCard = gurt.select('#blackjack_card')
local regexCard = gurt.select('#regex_card')
local diceCard = gurt.select('#dice_card')
local coinflipCard = gurt.select('#coinflip_card')
local rouletteCard = gurt.select('#roulette_card')
local backgroundAudio = gurt.select('#background-audio')

navHome:on('click', function() gurt.location.goto('/') end)
navSlots:on('click', function() gurt.location.goto('/slots') end)
navBlackjack:on('click', function() gurt.location.goto('/blackjack') end)
navRoulette:on('click', function() gurt.location.goto('/roulette') end)
navregex:on('click', function() gurt.location.goto('/regex') end)
navDice:on('click', function() gurt.location.goto('/dice') end)
navCoinflip:on('click', function() gurt.location.goto('/coinflip') end)
if backgroundAudio then
    backgroundAudio.volume = 0.1
    backgroundAudio.src = "https://eu-central.storage.cloudconvert.com/tasks/e6ce772f-32f2-4b28-91d5-51bea81345aa/copyright_free_music.mp3?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=cloudconvert-production%2F20250911%2Ffra%2Fs3%2Faws4_request&X-Amz-Date=20250911T194125Z&X-Amz-Expires=86400&X-Amz-Signature=a53ee89368df66a0ff7cf65c45fff8f37553e67292a043c989919d3cd4af8d92&X-Amz-SignedHeaders=host&response-content-disposition=inline%3B%20filename%3D%22copyright_free_music.mp3%22&response-content-type=audio%2Fmpeg&x-id=GetObject"
    setTimeout(function()
        backgroundAudio:play()
end, 4000)
end

if regexCard then
    regexCard:on('click', function() gurt.location.goto('/regex') end)
end

if rouletteCard then
    rouletteCard:on('click', function() gurt.location.goto('/roulette') end)
end

if diceCard then
    diceCard:on('click', function() gurt.location.goto('/dice') end)
end

if coinflipCard then
    coinflipCard:on('click', function() gurt.location.goto('/coinflip') end)
end
if blackjackCard then
    blackjackCard:on('click', function() gurt.location.goto('/blackjack') end)
end
if navCard then
    navCard:on('click', function() gurt.location.goto('/slots') end)
end
if navNews then
    navNews:on('click', function() gurt.location.goto('/news') end)
end
