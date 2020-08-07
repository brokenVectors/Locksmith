local pages = {}
local currentPage




function pages.GetPageByName(pageName)
    if type(pageName) ~= "string" then
        error('Page name must be a string')
    end
    if not pages.pageList[pageName] then
        error( string.format('Page %s does not exist', pageName))
    end
    return pages.pageList[pageName]
end

function pages.Init(pageList, initialPage)
    pages.pageList = pageList
    currentPage = initialPage

    pages.Open( initialPage )
end

function pages.Open(pageName)
    if pageName == currentPage then
        return
    end
    local pageToOpen = pages.GetPageByName(pageName)
    local pageToClose = pages.GetPageByName(currentPage)

    print(pageName, currentPage)
    print(pageToOpen, pageToClose)
    pageToOpen.Visible = true
    pageToClose.Visible = false

    currentPage = pageName
end
return pages
