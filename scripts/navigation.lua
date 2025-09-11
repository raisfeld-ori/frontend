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

navHome:on('click', function() gurt.location.goto('/') end)
navSlots:on('click', function() gurt.location.goto('/slots') end)
navBlackjack:on('click', function() gurt.location.goto('/blackjack') end)
navRoulette:on('click', function() gurt.location.goto('/roulette') end)
navregex:on('click', function() gurt.location.goto('/regex') end)
navDice:on('click', function() gurt.location.goto('/dice') end)
navCoinflip:on('click', function() gurt.location.goto('/coinflip') end)

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
