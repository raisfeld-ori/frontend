-- Balance management with animations
local function updateBalanceWithAnimation(newBalance, oldBalance)
    local element = gurt.select('#wallet-balance')
    if element == nil then
        return
    end
    
    -- Update the text
    element.text = tostring(newBalance)
    
    -- Reset style after animation
    setTimeout(function()
        element.style = "text-white font-bold transition: all 0.3s ease;"
    end, 500)
end

-- Initialize balance on page load
local function initializeBalance()
    local balance = gurt.crumbs.get("balance")
    if balance == nil then
        gurt.crumbs.set({
            name = "balance",
            value = 100
        })
        balance = 100
    end
    
    local element = gurt.select('#wallet-balance')
    if element then
        element.text = tostring(balance)
        element.style = "text-white font-bold transition: all 0.3s ease;"
    end
    
    return balance
end

-- Global function to update balance with animation
function updateBalance(newBalance)
    local currentBalance = tonumber(gurt.crumbs.get("balance")) or 100
    
    -- Save new balance
    gurt.crumbs.set({
        name = "balance",
        value = newBalance
    })
    
    -- Animate the change
    updateBalanceWithAnimation(newBalance, currentBalance)
end

-- Auto-initialize when script loads
initializeBalance()
