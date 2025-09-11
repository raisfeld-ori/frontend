local API_KEY = '2bd1100fcc5a48ef8d4b2c6de324175d'
local API_BASE_URL = 'https://api.worldnewsapi.com/top-news'

trace.log('67 Casino News Script: Starting initialization')

-- State management
local currentPage = 1
local isLoading = false
local newsContainer = gurt.select('#news-articles')

-- Utility function to format date for API
local function formatDate(date)
    trace.log('formatDate called with date: ' .. tostring(date))
    local now = Time.now()
    local date = date or Time.date(now)
    return Time.format(date, "%Y-%m-%d")
end

-- Utility function to format publish date for display
local function formatPublishDate(dateString)
    if not dateString then return 'Recently' end
    
    -- Parse the date string and format it nicely
    local year, month, day, hour, min = 2025, 1, 1, 0, 0
    if year and month and day and hour and min then
        local publishTime = Time.format({
            year = tonumber(year) or 2025,
            month = tonumber(month) or 1,
            day = tonumber(day) or 1,
            hour = tonumber(hour) or 0,
            min = tonumber(min) or 0
        }, "%Y-%m-%d %H:%M")
        
        local timeAgo = 10
        local hoursAgo = math.floor(timeAgo / 3600)
        
        if hoursAgo < 1 then
            return 'Just now'
        elseif hoursAgo < 24 then
            return hoursAgo .. ' hours ago'
        else
            local daysAgo = math.floor(hoursAgo / 24)
            return daysAgo .. ' days ago'
        end
    end
    return 'Recently'
end

-- Function to determine news category based on title content
local function getNewsCategory(title, text)
    trace.log('getNewsCategory called for title: ' .. tostring(title))
    local lowerTitle = (title or ''):lower()
    local lowerText = (text or ''):lower()
    
    if lowerTitle:find('trump') or lowerTitle:find('election') or lowerTitle:find('politics') or lowerTitle:find('government') then
        return { name = 'Politics', color = '#dc2626' }
    elseif lowerTitle:find('stock') or lowerTitle:find('market') or lowerTitle:find('economy') or lowerTitle:find('business') then
        return { name = 'Business', color = '#10b981' }
    elseif lowerTitle:find('tech') or lowerTitle:find('ai') or lowerTitle:find('cyber') or lowerTitle:find('software') then
        return { name = 'Technology', color = '#7c3aed' }
    elseif lowerTitle:find('sport') or lowerTitle:find('game') or lowerTitle:find('player') or lowerTitle:find('team') then
        return { name = 'Sports', color = '#f59e0b' }
    elseif lowerTitle:find('health') or lowerTitle:find('medical') or lowerTitle:find('covid') then
        return { name = 'Health', color = '#06b6d4' }
    else
        return { name = 'General', color = '#6b7280' }
    end
end

-- Function to create news article element
local function createNewsArticle(article)
    if not article or not article.title then
        return nil
    end
    
    local category = getNewsCategory(article.title, article.text)
    local timeAgo = formatPublishDate(article.publish_date)
    local summary = article.summary or (article.text and article.text:sub(1, 200) .. '...') or 'No summary available.'
    
    -- Create main article container
    local articleDiv = gurt.create('div', {
        style = 'bg-[#1a1a1a] p-6 rounded-lg border border-[#333333] hover:border-[#555555] transition-colors mb-6 shadow-lg'
    })
    
    -- Create header section
    local headerDiv = gurt.create('div', {
        style = 'flex justify-between items-start mb-4'
    })
    
    -- Create title
    local titleH2 = gurt.create('h2', {
        style = 'text-2xl font-bold text-white mb-2 line-height-tight',
        text = tostring(article.title or 'Untitled')
    })
    
    -- Create time span
    local timeSpan = gurt.create('span', {
        style = 'text-[#888888] text-sm whitespace-nowrap ml-4',
        text = tostring(timeAgo)
    })
    
    headerDiv:append(titleH2)
    headerDiv:append(timeSpan)
    
    -- Create summary paragraph
    local summaryP = gurt.create('p', {
        style = 'text-[#cccccc] mb-4 line-height-7',
        text = tostring(summary)
    })
    
    -- Create footer section
    local footerDiv = gurt.create('div', {
        style = 'flex justify-between items-center'
    })
    
    -- Create tags container
    local tagsDiv = gurt.create('div', {
        style = 'flex gap-2'
    })
    
    -- Create category tag
    local categorySpan = gurt.create('span', {
        style = 'bg-[' .. tostring(category.color) .. '] text-white px-3 py-1 rounded-full text-sm',
        text = tostring(category.name)
    })
    tagsDiv:append(categorySpan)
    
    -- Create author tag if available
    if article.author and article.author ~= '' then
        local authorSpan = gurt.create('span', {
            style = 'bg-[#555555] text-white px-3 py-1 rounded-full text-sm',
            text = tostring(article.author)
        })
        tagsDiv:append(authorSpan)
    end
    
    -- Create read more link
    local readMoreLink = gurt.create('a', {
        style = 'text-[#7c3aed] hover:text-[#8b5cf6] text-sm font-medium no-underline',
        text = 'Read More →'
    })
    readMoreLink:setAttribute('href', tostring(article.url or '#'))
    readMoreLink:setAttribute('target', '_blank')
    
    footerDiv:append(tagsDiv)
    footerDiv:append(readMoreLink)
    
    -- Assemble the article
    articleDiv:append(headerDiv)
    articleDiv:append(summaryP)
    articleDiv:append(footerDiv)
    
    return articleDiv
end

-- Function to show loading state
local function showLoading()
    trace.log('showLoading: Setting loading state')
    isLoading = true
    -- We'll handle visual state through content manipulation instead of style properties
end

-- Function to hide loading state
local function hideLoading()
    trace.log('hideLoading: Clearing loading state')
    isLoading = false
    -- We'll handle visual state through content manipulation instead of style properties
end

-- Function to display error message
local function showError(message)
    trace.log('showError: ' .. tostring(message))
    if newsContainer then
        -- Clear existing content
        newsContainer.text = ''
        
        -- Create error container
        local errorDiv = gurt.create('div', {
            style = 'bg-[#dc2626] p-4 rounded-lg border border-[#991b1b] text-center mb-6'
        })
        
        -- Create error title
        local errorTitle = gurt.create('h3', {
            style = 'text-white font-bold mb-2',
            text = 'Error Loading News'
        })
        
        -- Create error message
        local errorMessage = gurt.create('p', {
            style = 'text-white',
            text = tostring(message or 'Unknown error occurred')
        })
        
        -- Create try again button
        local tryAgainBtn = gurt.create('button', {
            style = 'bg-white text-[#dc2626] px-4 py-2 rounded mt-3 font-bold cursor-pointer border-none',
            text = 'Try Again'
        })
        
        tryAgainBtn:on('click', function()
            gurt.location.reload()
        end)
        
        errorDiv:append(errorTitle)
        errorDiv:append(errorMessage)
        errorDiv:append(tryAgainBtn)
        
        newsContainer:append(errorDiv)
    end
end

-- Function to show "No news today" message
local function showNoNewsToday()
    trace.log('showNoNewsToday: Displaying no news message')
    
    local noNewsElement = gurt.select("#no-news-message")
    if noNewsElement then
        noNewsElement.visible = true
    end
    
    -- Hide news container content
    if newsContainer then
        newsContainer.text = ''
    end
end

-- Function to display news articles
local function displayNews(topNews)
    trace.log('displayNews called with ' .. tostring(topNews and #topNews or 0) .. ' news clusters')
    
    if not newsContainer then
        trace.log('displayNews: newsContainer not found')
        return
    end
    
    -- Hide no news message
    local noNewsElement = gurt.select("#no-news-message")
    if noNewsElement then
        noNewsElement.visible = false
    end
    
    if not topNews or #topNews == 0 then
        trace.log('displayNews: No news data provided')
        showNoNewsToday()
        return
    end
    
    local articles = {}
    local articleCount = 0
    
    -- Process each news cluster
    for i, cluster in ipairs(topNews) do
        if cluster.news and #cluster.news > 0 then
            -- Take the first article from each cluster (highest ranked)
            local article = cluster.news[1]
            if article and article.title then
                local articleElement = createNewsArticle(article)
                if articleElement then
                    table.insert(articles, articleElement)
                    articleCount = articleCount + 1
                    
                    -- Limit to 10 articles per load
                    if articleCount >= 10 then
                        break
                    end
                end
            end
        end
    end
    
    if articleCount > 0 then
        trace.log('displayNews: Displaying ' .. tostring(articleCount) .. ' articles')
        -- If this is the first page, clear and add; otherwise append
        if currentPage == 1 then
            newsContainer.text = ''
        end
        
        -- Append all articles with separators
        for i, articleElement in ipairs(articles) do
            newsContainer:append(articleElement)
            
            -- Add separator line between articles (except after the last one)
            if i < #articles then
                local separator = gurt.create('div', {
                    style = 'border-b border-[#444444] mx-4 mb-6 opacity-50'
                })
                newsContainer:append(separator)
            end
        end
    else
        trace.log('displayNews: No valid articles found')
        showNoNewsToday()
    end
end

-- Function to fetch news from WorldNewsAPI
local function fetchNews()
    trace.log('fetchNews: Starting API call, isLoading=' .. tostring(isLoading))
    
    if isLoading then 
        trace.log('fetchNews: Already loading, skipping')
        return 
    end
    
    showLoading()
    
    -- Build API URL with parameters
    local url = string.format('%s?source-country=us&language=en&date=%s&headlines-only=false&max-news-per-cluster=1',
        API_BASE_URL,
        formatDate()
    )
    
    trace.log('fetchNews: Making request to: ' .. url)
    
    -- Make the API request
    local response = fetch(url, {
        method = 'GET',
        headers = {
            ['x-api-key'] = API_KEY,
            ['Content-Type'] = 'application/json'
        }
    })
    
    if response and response:ok() then
        trace.log('fetchNews: API call successful, status: ' .. tostring(response.status))
        local data = response:json()
        
        if data and data.top_news then
            trace.log('fetchNews: Parsed JSON successfully, found ' .. tostring(#data.top_news) .. ' news clusters')
            displayNews(data.top_news)
        else
            trace.log('fetchNews: Failed to parse JSON data')
            showError('Failed to parse news data. Please try again later.')
        end
    else
        local status = response and response.status or 'Unknown'
        trace.log('fetchNews: API call failed with status: ' .. tostring(status))
        showError('Failed to fetch news. Status: ' .. status)
    end
    
    hideLoading()
end
-- Function to display sample news while real news loads
local function displaySampleNews()
    trace.log('displaySampleNews: Creating sample news')
    local now = Time.now()
    local date = Time.date(now)
    
    local sampleNews = {
        {
            news = {
                {
                    title = "Welcome to 67 Casino Live News",
                    text = "Stay updated with the latest news while you enjoy our games. Real news is loading...",
                    publish_date = date,
                    author = "67 Casino Team",
                    url = "#"
                }
            }
        }
    }
    
    displayNews(sampleNews)
end

-- Function to initialize the news page
local function initNews()
    trace.log('initNews: Starting initialization')

    local noNewsElement = gurt.select("#no-news-message")
    if noNewsElement then
        noNewsElement.visible = false
    end
    
    -- Get DOM elements
    loadMoreBtn = gurt.select('#load-more-btn')
    
    trace.log('initNews: newsContainer found: ' .. tostring(newsContainer ~= nil))
    trace.log('initNews: loadMoreBtn found: ' .. tostring(loadMoreBtn ~= nil))
    
    if not newsContainer then
        trace.log('initNews: newsContainer not found, aborting')
        return
    end
    
    -- Set up Load More button with Gurty event handler
    if loadMoreBtn then
        trace.log('initNews: Setting up Load More button click handlers')
        
        -- Gurty event handler
        loadMoreBtn:on('click', function()
            trace.log('Load More button clicked (Gurty handler)')
            currentPage = currentPage + 1
            fetchNews()
        end)
    else
        trace.log('initNews: Load More button not found')
    end
    
    -- Display sample news first, then load real news
    trace.log('initNews: Displaying sample news')
    displaySampleNews()
    
    -- Load real news after a short delay
    trace.log('initNews: Starting real news fetch')
    fetchNews()
end

-- Initialize when the page loads
trace.log('Script loaded, starting initialization')
initNews()