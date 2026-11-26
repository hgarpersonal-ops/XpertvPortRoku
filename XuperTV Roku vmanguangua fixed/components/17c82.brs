sub init()
    m.rail        = m.top.FindNode("rail")
    m.content     = m.top.FindNode("content")
    m.navRows     = [m.top.FindNode("navRow0"), m.top.FindNode("navRow1"), m.top.FindNode("navRow2"), m.top.FindNode("navRow3"), m.top.FindNode("navRow4"), m.top.FindNode("navRow5"), m.top.FindNode("navRow6"), m.top.FindNode("navRow7"), m.top.FindNode("navRow8"), m.top.FindNode("navRow9")]
    m.navBgs      = [m.top.FindNode("navBg0"),  m.top.FindNode("navBg1"),  m.top.FindNode("navBg2"),  m.top.FindNode("navBg3"),  m.top.FindNode("navBg4"),  m.top.FindNode("navBg5"),  m.top.FindNode("navBg6"),  m.top.FindNode("navBg7"),  m.top.FindNode("navBg8"),  m.top.FindNode("navBg9")]
    m.navFocus    = [m.top.FindNode("navFocus0"), m.top.FindNode("navFocus1"), m.top.FindNode("navFocus2"), m.top.FindNode("navFocus3"), m.top.FindNode("navFocus4"), m.top.FindNode("navFocus5"), m.top.FindNode("navFocus6"), m.top.FindNode("navFocus7"), m.top.FindNode("navFocus8"), m.top.FindNode("navFocus9")]
    m.navIcons    = [m.top.FindNode("navIcon0"),m.top.FindNode("navIcon1"),m.top.FindNode("navIcon2"),m.top.FindNode("navIcon3"),m.top.FindNode("navIcon4"),m.top.FindNode("navIcon5"),m.top.FindNode("navIcon6"),m.top.FindNode("navIcon7"),m.top.FindNode("navIcon8"),m.top.FindNode("navIcon9")]
    m.navLabels   = [m.top.FindNode("navLabel0"),m.top.FindNode("navLabel1"),m.top.FindNode("navLabel2"),m.top.FindNode("navLabel3"),m.top.FindNode("navLabel4"),m.top.FindNode("navLabel5"),m.top.FindNode("navLabel6"),m.top.FindNode("navLabel7"),m.top.FindNode("navLabel8"),m.top.FindNode("navLabel9")]
    m.brandGroup  = m.top.FindNode("brandGroup")
    m.eyebrow      = m.top.FindNode("eyebrow")
    m.sectionTitle = m.top.FindNode("sectionTitle")
    m.sectionSub   = m.top.FindNode("sectionSub")
    m.clockLabel   = m.top.FindNode("clockLabel")
    m.titleAccent  = m.top.FindNode("titleAccent")
    m.hardwareLabel = m.top.FindNode("hardwareLabel")
    m.hardwareSummary = m.top.FindNode("hardwareSummary")
    m.hardwareModel = m.top.FindNode("hardwareModel")
    m.hardwareResolution = m.top.FindNode("hardwareResolution")
    m.hardwareCompat1 = m.top.FindNode("hardwareCompat1")
    m.hardwareCompat2 = m.top.FindNode("hardwareCompat2")
    m.catRow    = m.top.FindNode("catRow")
    m.liveCatOverlay = m.top.FindNode("liveCatOverlay")
    m.fullPanelSlide = m.top.FindNode("fullPanelSlide")
    m.vodDetailOverlay = m.top.FindNode("vodDetailOverlay")
    m.gridArea  = m.top.FindNode("gridArea")
    m.player    = m.top.FindNode("player")
    m.NAV = [
        { id: "home",    label: "Inicio",     rootCol: 0,     vodCol: 76177 }
        { id: "vivo",    label: "TV en vivo", rootCol: 76175, vodCol: 0 }
        { id: "favs",    label: "Favoritos",  rootCol: 76175, vodCol: 0 }
        { id: "vod",     label: "Películas",  rootCol: 0,     vodCol: 76177 }
        { id: "vod",     label: "Series",     rootCol: 0,     vodCol: 76178 }
        { id: "vod",     label: "Infantil",   rootCol: 0,     vodCol: 76180 }
        { id: "anime",   label: "Anime",      rootCol: 0,     vodCol: 76178 }
        { id: "search",  label: "Buscar",     rootCol: 0,     vodCol: 0 }
        { id: "history", label: "Historial",  rootCol: 0,     vodCol: 0 }
        { id: "settings",label: "Ajustes",    rootCol: 0,     vodCol: 0 }
    ]
    m.VOD_GENRES = [
        { name: "Todas",     tag: "" }
        { name: "Accion",    tag: "Acción" }
        { name: "Drama",     tag: "Drama" }
        { name: "Aventuras", tag: "Aventuras" }
        { name: "Crimen",    tag: "Crimen" }
        { name: "Sci-Fi",    tag: "Ciencia ficción" }
        { name: "Comedia",   tag: "Comedia" }
        { name: "Romance",   tag: "Romántico" }
        { name: "Animacion", tag: "Animación" }
        { name: "Familia",   tag: "Familia" }
        { name: "Fantasia",  tag: "Fantastico" }
        { name: "Suspenso",  tag: "Suspenso" }
        { name: "Horror",    tag: "Horror" }
        { name: "Misterio",  tag: "Misterio" }
    ]
    m.section     = "vivo"
    m.navIdx      = 1
    m.navCursor   = 1
    m.pendingEnter = false
    m.region      = "nav"
    m.categories  = []
    m.catIdx      = 0
    m.liveCatCursor = 0
    m.savedLiveCatIdx = 1
    m.items       = []
    m.rawItems    = []
    m.gridIdx     = 0
    m.rowOffset   = 0
    m.gridState   = "ready"
    m.previewBtnIdx = 0
    m.fullPanelFavFocus = false
    m.favList     = []
    m.favs        = {}
    m.favToastTimer = invalid
    m.uiNotice      = ""
    m.uiNoticeTimer = invalid
    FavLoad()
    m.catCache    = {}
    m.itemCache   = {}
    m.vodCodecCache = CodecCache_Load()
    m.vodAudioCache = {}
    m.activeVodCodecKey = ""
    m.codecWarningDlg = invalid
    m.codecPendingIdx = -1
    m.codecPendingKey = ""
    m.codecWarningAcceptedKey = ""
    m.errorDetail = ""
    m.catTask     = invalid
    m.itemTask    = invalid
    m.started = false
    m.startupActive = false
    m.startupRecord = LastLiveLoad()
    m.startupTriedCats = {}
    m.startupFallbackUsed = false
    m.startupPlayback = false
    m.pendingLiveSave = invalid
    m.lastSavedSignature = ""
    m.liveSessionChannelId = ""
    m.liveSessionCatId = ""
    m.resumeLiveOnLoad = false
    m.adultPin        = PinLoad()
    m.adultUnlocked   = false
    m.adultPendingIdx = -1
    m.adultPendingCat = -1
    m.pinDlg          = invalid
    m.pinMode         = ""
    m.pinEntry1       = ""
    m.pinEntry2       = ""
    m.pinVerifyEntry  = ""
    m.pinResetTimer   = invalid
    m.pinResetDlg     = invalid
    m.pinResetMessage = ""
    m.seriesMode      = false
    m.seriesContentId = ""
    m.seriesPoster    = ""
    m.savedGrid       = invalid
    m.player.ObserveField("state", "OnPlayerState")
    m.player.ObserveField("detectedVideoCodec", "OnDetectedVideoCodec")
    m.player.ObserveField("detectedAudioFormat", "OnDetectedAudioFormat")
    m.player.ObserveField("menuAction", "OnPlayerMenuAction")
    m.closingPlayer = false
    m.liveFullscreen = false
    m.fullPanelMode = ""
    m.fullPanelCursor = 0
    m.fullPanelWaiting = false
    m.fullPanelPositions = {}
    m.fullPanelWidth = 500
    m.fullPanelWidthKey = ""
    m.vodDetailMode = ""
    m.vodDetailItem = invalid
    m.vodDetailData = invalid
    m.vodDetailSeries = invalid
    m.vodDetailSeriesData = invalid
    m.vodDetailEpisodes = []
    m.vodDetailSeasons = []
    m.vodDetailSeasonIdx = 0
    m.vodDetailEpisodeIdx = 0
    m.vodDetailRegion = "play"
    m.vodDetailLoading = false
    m.detailTask = invalid
    m.vodErrorActive = false
    m.vodErrorFormat = false
    m.vodErrorChoice = 0
    m.vodErrorCode = "VOD-002"
    m.lastVodPlaybackItem = invalid
    m.lastVodPlaybackSeriesMode = false
    m.lastVodPlaybackSeriesId = ""
    m.pinContext = ""
    m.switchingLive = false
    m.recoveryState = "IDLE"
    m.recoveryGeneration = 0
    m.recoveryTried = {}
    m.recoveryInternal = false
    m.recoveryWasPlaying = false
    m.recoveryRetryUsed = false
    m.recoveryTimer = invalid
    m.watchTimer = invalid
    m.top.hardwareInfo = Hardware_Detect()
    m.vodFilter = VodFilterPref_Load("all")
    m.renderedTiles = []
    m.tileGridSignature = ""
    m.codecProbeTask = invalid
    m.codecProbeTimer = invalid
    m.codecProbeGen = 0
    m.detailProbeTask = invalid
    m.detailProbeGen = 0
    m.workingImageHosts = ["cmscjw.9np35rfp.xyz"]
    m.workingImageHostSet = { "cmscjw.9np35rfp.xyz": true }
    m.deadImageHosts = {}
    RenderHardwareSummary()
    m.top.ObserveField("start", "OnStart")
    m.top.ObserveField("halt",  "OnHalt")
    m.clockTimer = CreateObject("roSGNode", "Timer")
    m.clockTimer.duration = 15
    m.clockTimer.repeat   = true
    m.clockTimer.ObserveField("fire", "OnClockTick")
    m.clockTimer.control  = "start"
    UpdateClock()
    RenderRail()
    RenderHeader()
end sub
function CountStarPress() as Boolean
    now = CreateObject("roDateTime").AsSeconds()
    if m.lastStar = invalid or (now - m.lastStar) > 3
        m.starCount = 1
    else
        m.starCount = m.starCount + 1
    end if
    m.lastStar = now
    if m.starCount < 5 then return false
    m.starCount = 0
    sc = m.top.getScene()
    if sc = invalid then return false
    sc.showDebug = true
    return true
end function
sub OnClockTick(event as Object)
    UpdateClock()
end sub
sub UpdateClock()
    t = CreateObject("roDateTime")
    t.ToLocalTime()
    m.clockLabel.text = Right("0" + t.GetHours().ToStr(), 2) + ":" + Right("0" + t.GetMinutes().ToStr(), 2)
end sub
sub OnStart(event as Object)
    if event.GetData() <> true then return
    if m.started then return
    m.started = true
    m.top.SetFocus(true)
    m.region = "grid"
    m.startupActive = true
    m.startupTriedCats = {}
    LoadCategoriesForSection()
end sub
sub OnHalt(event as Object)
    if event.GetData() <> true then return
    ClosePlayer()
end sub
function IsVodSection(id as String) as Boolean
    return id = "home" or id = "vod" or id = "anime"
end function
function IsLiveSection(id as String) as Boolean
    return id = "vivo" or id = "favs"
end function
function PreviewBtnCount() as Integer
    if m.NAV[m.navIdx].id = "vivo" then return 3
    return 2
end function
sub SetGridError(context as String, detail as Dynamic)
    m.errorDetail = context + ": " + SafeStr(detail)
    if m.errorDetail = context + ": " then m.errorDetail = context + ": error desconocido"
    m.gridState = "error"
    RenderGrid()
end sub
sub LoadCategoriesForSection()
    m.seriesMode      = false
    m.seriesContentId = ""
    m.savedGrid       = invalid
    nav = m.NAV[m.navIdx]
    if nav.id = "favs"
        m.categories = [{ id: -99, columnId: -99, name: "Mis Favoritos", isFavCat: true }]
        m.catIdx = 0
        m.liveCatCursor = 0
        m.items = FavItems()
        m.gridIdx = 0
        m.rowOffset = 0
        if m.items.Count() = 0
            if m.player.visible and not m.liveFullscreen then ClosePlayer()
            m.gridState = "empty"
        else
            m.gridState = "ready"
            playingCode = SafeStr(m.player.channelCode)
            if m.player.visible and playingCode <> ""
                for idxFav = 0 to m.items.Count() - 1
                    if SafeStr(m.items[idxFav].channelCode) = playingCode
                        m.gridIdx = idxFav
                        exit for
                    end if
                end for
            end if
            EnsureLiveChannelVisible()
            if not m.player.visible
                PlayLiveItem(m.gridIdx, false)
            end if
        end if
        RenderHeader() : RenderCategories() : RenderGrid()
        MaybeEnterPending()
        return
    end if
    if nav.id = "history"
        m.categories = []
        m.rawItems   = HistoryItems()
        ApplyVodFilter(false)
        RenderHeader() : RenderCategories() : RenderGrid()
        MaybeEnterPending()
        return
    end if
    if nav.id = "settings"
        m.categories = []
        m.items = []
        m.gridState = "empty"
        RenderHeader() : RenderCategories() : RenderGrid()
        return
    end if
    if IsVodSection(nav.id)
        if not CanPlayVod()
            m.categories = []
            m.items = []
            m.gridState = "nohevc"
            RenderHeader() : RenderCategories() : RenderGrid()
            return
        end if
        m.categories = m.VOD_GENRES
        m.catIdx = Tern(nav.id = "anime", 8, 0)
        RenderHeader() : RenderCategories()
        LoadItemsForCurrentCategory()
        return
    end if
    if m.catCache[nav.id] <> invalid
        m.categories = m.catCache[nav.id]
        RefreshFavCategoryLabel()
        if nav.id = "vivo" and m.startupActive
            BeginLiveStartup()
            return
        end if
        if nav.id = "vivo"
            m.catIdx = m.savedLiveCatIdx
            if m.catIdx < 0 or m.catIdx >= m.categories.Count() then m.catIdx = Tern(m.categories.Count() > 1, 1, 0)
            if IsFavCat(m.categories[m.catIdx]) and m.favList.Count() = 0 and m.categories.Count() > 1 then m.catIdx = 1
        else
            m.catIdx = 0
        end if
        m.liveCatCursor = m.catIdx
        RenderHeader() : RenderCategories()
        LoadItemsForCurrentCategory()
        return
    end if
    m.gridState = "loading"
    RenderHeader() : RenderCategories() : RenderGrid()
    if m.catTask <> invalid then m.catTask.control = "STOP"
    m.catTask = Api_OpTask("columns", { columnId: nav.rootCol })
    if m.catTask = invalid
        SetGridError("columns", "operación ausente en kit") : return
    end if
    m.catTask.ObserveField("rawResp", "OnCategoriesResp")
    m.catTask.ObserveField("error",   "OnCategoriesError")
    m.catTask.control = "RUN"
end sub
sub OnCategoriesResp(event as Object)
    raw = event.GetData()
    data = Api_ParseOp(raw)
    if data = invalid
        SetGridError("columns", "respuesta inválida: " + Left(SafeStr(raw), 220))
        return
    end if
    cats = []
    if data <> invalid
        if data.childColumnList <> invalid then cats = data.childColumnList
        if data.list <> invalid and cats.Count() = 0 then cats = data.list
    end if
    nav = m.NAV[m.navIdx]
    if nav.id = "vivo" then cats = InjectFavCategory(cats)
    m.catCache[nav.id] = cats
    m.categories = cats
    RefreshFavCategoryLabel()
    if nav.id = "vivo" and m.startupActive
        BeginLiveStartup()
        return
    end if
    m.catIdx = Tern(nav.id = "vivo", m.savedLiveCatIdx, 0)
    if m.catIdx < 0 or m.catIdx >= cats.Count() then m.catIdx = Tern(nav.id = "vivo" and cats.Count() > 1, 1, 0)
    if nav.id = "vivo" and cats.Count() > 1 and IsFavCat(cats[m.catIdx]) and m.favList.Count() = 0 then m.catIdx = 1
    m.liveCatCursor = m.catIdx
    RenderHeader() : RenderCategories()
    LoadItemsForCurrentCategory()
end sub
sub OnCategoriesError(event as Object)
    if Api_LicenseGone(event.GetData()) then return
    SetGridError("columns", event.GetData())
end sub
sub LoadVodPage(page as Integer)
    nav = m.NAV[m.navIdx]
    cat = m.categories[m.catIdx]
    if m.itemTask <> invalid then m.itemTask.control = "STOP"
    m.itemTask = Api_OpTask("filter", { columnId: nav.vodCol, tag: SafeStr(cat.tag), page: page })
    if m.itemTask = invalid
        m.vodLoadingMore = false
        if m.items.Count() = 0 then m.gridState = "error" : RenderGrid()
        return
    end if
    m.itemTask.ObserveField("rawResp", "OnVodPageResp")
    m.itemTask.ObserveField("error",   "OnVodPageError")
    m.itemTask.control = "RUN"
end sub
sub OnVodPageResp(event as Object)
    raw = event.GetData()
    data = Api_ParseOp(raw)
    if data = invalid
        m.vodLoadingMore = false
        if m.rawItems.Count() = 0 then SetGridError("filter", "respuesta inválida: " + Left(SafeStr(raw), 220))
        return
    end if
    newItems = []
    if data <> invalid and data.assetList <> invalid then newItems = data.assetList
    if data <> invalid and data.totalSize <> invalid then m.vodTotal = data.totalSize
    for each a in newItems
        m.rawItems.Push(a)
    end for
    m.vodLoadingMore = false
    ApplyVodFilter(true)
    RenderHeader() : RenderGrid()
    MaybeEnterPending()
    if m.vodFilter <> "all" and m.items.Count() < (GRID_COLS() * 2) and m.rawItems.Count() < m.vodTotal
        if m.vodAutoFetchCount = invalid then m.vodAutoFetchCount = 0
        if m.vodAutoFetchCount < 25
            m.vodAutoFetchCount = m.vodAutoFetchCount + 1
            if m.items.Count() = 0
                m.gridState = "loading"
                RenderGrid()
            end if
            MaybeLoadMoreVod()
        end if
    end if
end sub
sub OnVodPageError(event as Object)
    if Api_LicenseGone(event.GetData()) then return
    m.vodLoadingMore = false
    if m.rawItems.Count() = 0
        SetGridError("filter página " + m.vodPage.ToStr(), event.GetData())
    end if
end sub
sub MaybeLoadMoreVod()
    if not IsVodSection(m.NAV[m.navIdx].id) then return
    if m.seriesMode then return   ' los episodios vienen todos de una (getItemData)
    if m.vodLoadingMore = true then return
    if m.rawItems.Count() >= m.vodTotal then return
    if m.gridIdx >= m.items.Count() - (GRID_COLS() * 2) or (m.vodFilter <> "all" and m.items.Count() < (GRID_COLS() * 2))
        m.vodLoadingMore = true
        m.vodPage = m.vodPage + 1
        LoadVodPage(m.vodPage)
    end if
end sub
sub LoadItemsForCurrentCategory()
    nav = m.NAV[m.navIdx]
    if m.categories.Count() = 0
        m.rawItems  = []
        m.items     = []
        m.gridState = "empty"
        RenderGrid()
        return
    end if
    cat = m.categories[m.catIdx]
    nav = m.NAV[m.navIdx]
    if IsFavCat(cat)
        m.items = FavItems()
        m.gridIdx = 0
        m.rowOffset = 0
        if m.items.Count() = 0
            if m.player.visible and not m.liveFullscreen then ClosePlayer()
            m.gridState = "empty"
        else
            m.gridState = "ready"
        end if
        RenderHeader() : RenderGrid()
        MaybeEnterPending()
        FullCategoryLoaded()
        ContinueLiveStartup()
        ContinueLiveResume()
        return
    end if
    if IsVodSection(nav.id)
        m.rawItems = []
        m.items = []
        m.gridIdx = 0
        m.rowOffset = 0
        m.vodPage = 1
        m.vodTotal = 0
        m.vodLoadingMore = false
        m.vodAutoFetchCount = 0
        m.gridState = "loading"
        RenderGrid()
        LoadVodPage(1)
        return
    end if
    cacheKey = nav.id + ":" + GetCatId(cat).ToStr()
    if m.itemCache[cacheKey] <> invalid
        m.items = m.itemCache[cacheKey]
        m.gridIdx = 0
        m.rowOffset = 0
        m.gridState = Tern(m.items.Count() > 0, "ready", "empty")
        RenderHeader() : RenderGrid()
        MaybeEnterPending()
        FullCategoryLoaded()
        ContinueLiveStartup()
        ContinueLiveResume()
        return
    end if
    m.gridState = "loading"
    RenderGrid()
    if m.itemTask <> invalid then m.itemTask.control = "STOP"
    m.activeItemCacheKey = cacheKey
    m.itemTask = Api_OpTask("channels", { columnId: GetCatId(cat) })
    if m.itemTask = invalid
        SetGridError("channelList", "operación ausente en kit") : return
    end if
    m.itemTask.ObserveField("rawResp", "OnItemsResp")
    m.itemTask.ObserveField("error",   "OnItemsError")
    m.itemTask.control = "RUN"
end sub
sub OnItemsResp(event as Object)
    raw = event.GetData()
    data = Api_ParseOp(raw)
    if data = invalid
        SetGridError("channelList", "respuesta inválida: " + Left(SafeStr(raw), 220))
        return
    end if
    items = []
    if data <> invalid
        if data.channelList <> invalid then items = data.channelList
        if data.liveList <> invalid and items.Count() = 0 then items = data.liveList
        if data.list <> invalid and items.Count() = 0 then items = data.list
    end if
    m.items     = items
    if m.activeItemCacheKey <> invalid and m.activeItemCacheKey <> ""
        m.itemCache[m.activeItemCacheKey] = items
    end if
    m.gridIdx   = 0
    m.rowOffset = 0
    m.gridState = Tern(items.Count() > 0, "ready", "empty")
    RenderHeader() : RenderGrid()
    MaybeEnterPending()
    FullCategoryLoaded()
    ContinueLiveStartup()
    ContinueLiveResume()
end sub
sub OnVodItemsResp(event as Object)
    data = Api_ParseOp(event.GetData())
    items = []
    seen = {}
    if data <> invalid and data.recommendList <> invalid
        for each row in data.recommendList
            if row.assetList <> invalid
                for each a in row.assetList
                    code = SafeStr(a.contentId)
                    if code <> "" and seen[code] = invalid
                        seen[code] = true
                        items.Push(a)
                    end if
                end for
            end if
        end for
    end if
    m.rawItems  = items
    m.gridIdx   = 0
    m.rowOffset = 0
    ApplyVodFilter(false)
    RenderHeader() : RenderGrid()
end sub
sub OnItemsError(event as Object)
    if Api_LicenseGone(event.GetData()) then return
    if m.startupActive
        if TryNextStartupCategory() then return
        m.startupActive = false
    end if
    if m.fullPanelWaiting
        m.fullPanelWaiting = false
        m.fullPanelMode = "categories"
        RenderFullLivePanel()
    end if
    SetGridError("channelList", event.GetData())
end sub
function VisRows() as Integer
    id = m.NAV[m.navIdx].id
    if IsVodSection(id) or id = "search" or id = "history" then return 2
    return VISIBLE_ROWS()
end function
sub EnsureRowVisible()
    row = Int(m.gridIdx / GRID_COLS())
    if row < m.rowOffset
        m.rowOffset = row
    else if row > m.rowOffset + VisRows() - 1
        m.rowOffset = row - VisRows() + 1
    end if
    MaybeLoadMoreVod()   ' paginación infinita del catálogo VOD
end sub
function GetCatId(cat as Object) as Integer
    if cat.id <> invalid then return cat.id
    if cat.columnId <> invalid then return cat.columnId
    return 0
end function
function LastLiveLoad() as Dynamic
    reg = CreateObject("roRegistrySection", "jglcustoms")
    if not reg.Exists("lastLive") then return invalid
    data = ParseJSON(reg.Read("lastLive"))
    if data = invalid or Type(data) <> "roAssociativeArray" then return invalid
    return data
end function
function LiveProviderId() as String
    s = v4a25()
    return SafeStr(s.portalCode)
end function
function LiveStableId(it as Object) as String
    if it = invalid then return ""
    if IsValidStr(SafeStr(it.id)) then return SafeStr(it.id)
    if IsValidStr(SafeStr(it.channelCode)) then return SafeStr(it.channelCode)
    return ""
end function
function FindLiveCategory(catId as String, catName as String) as Integer
    for i = 0 to m.categories.Count() - 1
        cat = m.categories[i]
        if not IsCatAdult(cat)
            if IsFavCat(cat)
                if catId = "-99" and m.favList.Count() > 0 then return i
            else
                if catId <> "" and GetCatId(cat).ToStr() = catId then return i
                if catName <> "" and LCase(SafeStr(cat.name)) = LCase(catName) then return i
            end if
        end if
    end for
    return -1
end function
sub StartLiveCategory(idx as Integer)
    if idx < 0 or idx >= m.categories.Count() then return
    m.startupTriedCats["c" + idx.ToStr()] = true
    m.catIdx = idx
    m.savedLiveCatIdx = idx
    m.liveCatCursor = idx
    m.gridIdx = 0 : m.rowOffset = 0
    RenderHeader() : RenderCategories()
    LoadItemsForCurrentCategory()
end sub
sub BeginLiveStartup()
    if not m.startupActive then return
    idx = -1
    rec = m.startupRecord
    if rec <> invalid
        if SafeStr(rec.provider) = "" or SafeStr(rec.provider) = LiveProviderId()
            idx = FindLiveCategory(SafeStr(rec.categoryId), SafeStr(rec.categoryName))
        end if
    end if
    if idx < 0
        for i = 0 to m.categories.Count() - 1
            if not IsCatAdult(m.categories[i]) and not IsFavCat(m.categories[i])
                idx = i
                exit for
            end if
        end for
    end if
    if idx < 0 and m.categories.Count() > 0 and IsFavCat(m.categories[0]) and m.favList.Count() > 0
        idx = 0
    end if
    if idx < 0
        m.startupActive = false
        m.gridState = "empty"
        RenderGrid()
        return
    end if
    StartLiveCategory(idx)
end sub
function TryNextStartupCategory() as Boolean
    for i = 0 to m.categories.Count() - 1
        if m.startupTriedCats["c" + i.ToStr()] = invalid and not IsCatAdult(m.categories[i]) and (not IsFavCat(m.categories[i]) or m.favList.Count() > 0)
            StartLiveCategory(i)
            return true
        end if
    end for
    m.startupActive = false
    return false
end function
function FindStartupChannel() as Integer
    wanted = ""
    rec = m.startupRecord
    if rec <> invalid
        if SafeStr(rec.categoryId) = GetCatId(m.categories[m.catIdx]).ToStr() or LCase(SafeStr(rec.categoryName)) = LCase(SafeStr(m.categories[m.catIdx].name))
            wanted = SafeStr(rec.channelId)
        end if
    end if
    if wanted <> ""
        for i = 0 to m.items.Count() - 1
            same = (LiveStableId(m.items[i]) = wanted)
            if not same and SafeStr(rec.apiId) <> "" then same = (SafeStr(m.items[i].id) = SafeStr(rec.apiId))
            if not same and SafeStr(rec.channelCode) <> "" then same = (SafeStr(m.items[i].channelCode) = SafeStr(rec.channelCode))
            if same and not IsLocked(m.items[i]) then return i
        end for
    end if
    for i = 0 to m.items.Count() - 1
        if not IsLocked(m.items[i]) then return i
    end for
    return -1
end function
sub ContinueLiveStartup()
    if not m.startupActive then return
    if m.items.Count() = 0
        if not TryNextStartupCategory()
            m.gridState = "empty" : RenderGrid()
        end if
        return
    end if
    idx = FindStartupChannel()
    if idx < 0
        if not TryNextStartupCategory()
            m.gridState = "empty" : RenderGrid()
        end if
        return
    end if
    m.startupActive = false
    m.startupPlayback = true
    m.startupFallbackUsed = false
    m.region = "grid"
    m.gridIdx = idx : m.rowOffset = 0
    EnsureLiveChannelVisible()
    RenderRail() : RenderCategories() : RenderGrid()
    PlayLiveItem(idx, false)
end sub
function TryStartupFallback() as Boolean
    if m.startupFallbackUsed or m.items.Count() < 2 then return false
    m.startupFallbackUsed = true
    startIdx = m.gridIdx
    for offset = 1 to m.items.Count() - 1
        idx = (startIdx + offset) mod m.items.Count()
        if not IsLocked(m.items[idx])
            PlayLiveItem(idx, false)
            return true
        end if
    end for
    return false
end function
sub SavePendingLive()
    data = m.pendingLiveSave
    m.pendingLiveSave = invalid
    if data = invalid or data.protected = true then return
    sig = SafeStr(data.provider) + "|" + SafeStr(data.categoryId) + "|" + SafeStr(data.channelId)
    m.liveSessionChannelId = SafeStr(data.channelId)
    m.liveSessionCatId = SafeStr(data.categoryId)
    m.savedLiveCatIdx = m.catIdx
    if sig = m.lastSavedSignature then return
    reg = CreateObject("roRegistrySection", "jglcustoms")
    existing = ""
    if reg.Exists("lastLive") then existing = reg.Read("lastLive")
    encoded = FormatJson(data)
    if existing <> encoded
        reg.Write("lastLive", encoded)
        reg.Flush()
    end if
    m.lastSavedSignature = sig
    m.startupRecord = data
end sub
sub ContinueLiveResume()
    if not m.resumeLiveOnLoad then return
    m.resumeLiveOnLoad = false
    if m.liveSessionChannelId = "" then return
    for i = 0 to m.items.Count() - 1
        if LiveStableId(m.items[i]) = m.liveSessionChannelId and not IsLocked(m.items[i])
            m.region = "grid" : m.gridIdx = i : m.rowOffset = 0
            EnsureLiveChannelVisible()
            RenderRail() : RenderCategories() : RenderGrid()
            PlayLiveItem(i, false)
            return
        end if
    end for
end sub
sub FavLoad()
    m.favList = []
    m.favs = {}
    reg = CreateObject("roRegistrySection", "jglcustoms")
    if not reg.Exists("favorites") then return
    arr = ParseJSON(reg.Read("favorites"))
    if arr = invalid or Type(arr) <> "roArray" then return
    for each it in arr
        code = ItemCode(it)
        if code <> "" and not IsLocked(it) and m.favs[code] = invalid
            m.favList.Push(it)
            m.favs[code] = it
        end if
    end for
end sub
sub FavSave()
    reg = CreateObject("roRegistrySection", "jglcustoms")
    reg.Write("favorites", FormatJson(m.favList))
    reg.Flush()
end sub
function FavItems() as Object
    out = []
    for each it in m.favList
        out.Push(it)
    end for
    return out
end function
function IsChannelFav(it as Object) as Boolean
    if it = invalid then return false
    code = ItemCode(it)
    return (code <> "" and m.favs[code] <> invalid)
end function
function IsFavCat(cat as Object) as Boolean
    if cat = invalid then return false
    return (GetCatId(cat) = -99 or cat.isFavCat = true)
end function
function InjectFavCategory(cats as Object) as Object
    out = [{ id: -99, columnId: -99, name: "Favoritos (" + m.favList.Count().ToStr() + ")", isFavCat: true }]
    if cats <> invalid
        for each c in cats
            if not IsFavCat(c) then out.Push(c)
        end for
    end if
    return out
end function
sub RefreshFavCategoryLabel()
    if m.catCache <> invalid and m.catCache["vivo"] <> invalid
        vivoCats = m.catCache["vivo"]
        if vivoCats.Count() > 0 and IsFavCat(vivoCats[0])
            vivoCats[0].name = "Favoritos (" + m.favList.Count().ToStr() + ")"
        end if
    end if
    if m.categories <> invalid and m.categories.Count() > 0 and IsFavCat(m.categories[0]) and m.NAV[m.navIdx].id = "vivo"
        m.categories[0].name = "Favoritos (" + m.favList.Count().ToStr() + ")"
    end if
    if m.navLabels <> invalid and m.navLabels.Count() > 2 and m.navLabels[2] <> invalid
        cnt = m.favList.Count()
        m.navLabels[2].text = Tern(cnt > 0, "Favoritos (" + cnt.ToStr() + ")", "Favoritos")
    end if
end sub
sub ShowUiNotice(msg as String)
    m.uiNotice = msg
    RenderHeader()
    if m.uiNoticeTimer <> invalid then m.uiNoticeTimer.control = "stop"
    t = CreateObject("roSGNode", "Timer")
    t.duration = 2.6
    t.repeat = false
    t.ObserveField("fire", "OnUiNoticeHide")
    m.uiNoticeTimer = t
    t.control = "start"
end sub
sub OnUiNoticeHide(event as Object)
    m.uiNotice = ""
    RenderHeader()
end sub
sub ShowFavToast(msg as String)
    m.player.statusMessage = msg
    if m.favToastTimer <> invalid then m.favToastTimer.control = "stop"
    t = CreateObject("roSGNode", "Timer")
    t.duration = 2.4
    t.repeat = false
    t.ObserveField("fire", "OnFavToastHide")
    m.favToastTimer = t
    t.control = "start"
end sub
sub OnFavToastHide(event as Object)
    if m.recoveryState <> "RECOVERING" and m.recoveryState <> "FAILED"
        m.player.statusMessage = ""
    end if
end sub
function ToggleFavItem(it as Object) as Boolean
    if it = invalid or IsLocked(it) then return false
    code = ItemCode(it)
    if code = "" then return false
    added = false
    if m.favs[code] <> invalid
        m.favs.Delete(code)
        filtered = []
        for each existing in m.favList
            if ItemCode(existing) <> code then filtered.Push(existing)
        end for
        m.favList = filtered
    else
        copy = ParseJSON(FormatJson(it))
        if copy = invalid then return false
        if copy._favColumnId = invalid or AsInt(copy._favColumnId) <= 0
            colId = 76182
            catNm = "TV en vivo"
            if m.catIdx >= 0 and m.catIdx < m.categories.Count() and not IsFavCat(m.categories[m.catIdx])
                colId = GetCatId(m.categories[m.catIdx])
                catNm = SafeStr(m.categories[m.catIdx].name)
            else if it._historyColumnId <> invalid and AsInt(it._historyColumnId) > 0
                colId = AsInt(it._historyColumnId)
            end if
            copy["_favColumnId"] = colId
            copy["_favCategoryName"] = catNm
        end if
        m.favList.Unshift(copy)
        m.favs[code] = copy
        added = true
    end if
    FavSave()
    RefreshFavCategoryLabel()
    return added
end function
function HistoryItems() as Object
    reg = CreateObject("roRegistrySection", "jglcustoms")
    if not reg.Exists("history") then return []
    items = ParseJSON(reg.Read("history"))
    if items = invalid or Type(items) <> "roArray" then return []
    safe = []
    for each item in items
        if not IsLocked(item) then safe.Push(item)
    end for
    return safe
end function
sub HistoryAdd(it as Object, kind as String)
    if IsLocked(it) then return
    if kind = "live" and m.catIdx >= 0 and m.catIdx < m.categories.Count()
        if IsCatAdult(m.categories[m.catIdx]) then return
    end if
    copy = ParseJSON(FormatJson(it))
    if copy = invalid then return
    copy["_historyKind"] = kind
    key = ItemCode(copy)
    if key = "" then key = SafeStr(copy.contentId)
    out = [copy]
    history = HistoryItems()
    for each old in history
        oldKey = ItemCode(old)
        if oldKey = "" then oldKey = SafeStr(old.contentId)
        if oldKey <> key and out.Count() < 10 then out.Push(old)
    end for
    reg = CreateObject("roRegistrySection", "jglcustoms")
    reg.Write("history", FormatJson(out))
    reg.Flush()
end sub
sub RenderRail()
    railOn = (m.region = "nav")
    w = RAIL_W_EXPANDED()
    m.top.FindNode("railBg").width  = w
    m.top.FindNode("railLine").translation = [w - 1, 0]
    shadow = m.top.FindNode("railShadow")
    shadow.translation = [w, 0]
    shadow.visible = true
    m.brandGroup.visible = true
    m.top.FindNode("brandMini").visible = false
    RefreshFavCategoryLabel()
    for i = 0 to m.NAV.Count() - 1
        active  = (i = m.navIdx)
        focused = railOn and (i = m.navCursor)
        bg = m.navBgs[i]
        focus = m.navFocus[i]
        icon = m.navIcons[i]
        lbl = m.navLabels[i]
        isFavNav = (m.NAV[i].id = "favs")
        if focused
            focus.blendColor = Tern(isFavNav, THEME_GOLD(), THEME_ACCENT())
            bg.blendColor = Tern(isFavNav, "0x362A10FF", "0x11325EFF")
            icon.blendColor = "0xFFFFFFFF"
            icon.opacity = 1.0
            lbl.color = "0xFFFFFFFF"
        else if active
            focus.blendColor = Tern(isFavNav, THEME_GOLD(), THEME_ACCENT())
            bg.blendColor = "0x0D1A33FF"
            icon.blendColor = Tern(isFavNav, THEME_GOLD(), THEME_ACCENT_LT())
            icon.opacity = 1.0
            lbl.color = Tern(isFavNav, THEME_GOLD(), THEME_TEXT())
        else
            focus.blendColor = "0x00000000"
            bg.blendColor = "0x00000000"
            icon.blendColor = Tern(isFavNav and m.favList.Count() > 0, "0xFFE08AFF", "0x94A3B8FF")
            icon.opacity = Tern(isFavNav and m.favList.Count() > 0, 0.95, 0.85)
            lbl.color = Tern(isFavNav and m.favList.Count() > 0, "0xFFE08AFF", "0xCBD5E1FF")
        end if
        lbl.visible = true
        bg.width = 248
    end for
end sub
sub RenderHeader()
    nav = m.NAV[m.navIdx]
    m.hardwareLabel.visible = false
    m.hardwareSummary.visible = IsLiveSection(nav.id)
    m.eyebrow.visible = true
    m.eyebrow.text = UCase(nav.label)
    m.eyebrow.color = Tern(nav.id = "favs", THEME_GOLD(), THEME_ACCENT_LT())
    m.sectionTitle.visible = true
    m.titleAccent.visible = true
    m.sectionSub.visible = true
    m.sectionSub.translation = [0, 98]
    m.catRow.translation = [40, 160]
    m.gridArea.translation = [40, 250]
    if nav.id = "home"
        m.eyebrow.text = "XUPERTV  ·  CATÁLOGO"
        m.sectionTitle.text = "Recomendados"
        m.sectionTitle.visible = true
        m.titleAccent.visible = true
        m.sectionSub.translation = [0, 98]
        m.gridArea.translation = [40, 142]
    else if IsLiveSection(nav.id)
        if nav.id = "favs"
            m.eyebrow.visible = true
            m.eyebrow.text = "MIS CANALES FAVORITOS"
            m.sectionSub.translation = [0, 40]
        else
            m.eyebrow.visible = false
            m.sectionSub.translation = [0, 16]
        end if
        m.sectionTitle.visible = false
        m.titleAccent.visible = false
        m.catRow.translation = [20, 110]
        m.gridArea.translation = [0, 0]
    else if nav.id = "history"
        m.sectionTitle.text = "Vistos recientemente"
    else if nav.id = "settings"
        m.sectionTitle.text = "Configuración"
    else if m.categories.Count() > 0 and not m.seriesMode
        m.sectionTitle.text = SafeStr(m.categories[m.catIdx].name)
    else if not m.seriesMode
        m.sectionTitle.text = nav.label
    end if
    if m.uiNotice <> ""
        m.sectionSub.color = THEME_GOLD()
        m.sectionSub.text = m.uiNotice
        return
    end if
    m.sectionSub.color = THEME_MUTED()
    count = m.items.Count()
    if m.gridState = "loading"
        m.sectionSub.text = "Cargando contenido..."
    else if m.gridState = "error"
        m.sectionSub.text = "Error de señal"
    else if count = 0
        if IsVodFilterContext() and m.rawItems.Count() > 0
            m.sectionSub.text = "0 de " + m.rawItems.Count().ToStr() + " títulos  ·  Filtro: " + VodFilterLabel() + "  (* cambiar)"
        else
            m.sectionSub.text = Tern(nav.id = "favs", "Usa la flecha Derecha + OK en cualquier canal para guardarlo aquí", "Sin contenido")
        end if
    else if IsLiveSection(nav.id)
        catTxt = ""
        if nav.id = "vivo" and m.catIdx >= 0 and m.catIdx < m.categories.Count()
            catTxt = SafeStr(m.categories[m.catIdx].name) + "  ·  "
        end if
        favCount = m.favList.Count()
        favTxt = Tern(favCount > 0 and nav.id = "vivo", "  ·  " + favCount.ToStr() + " en Favoritos", "")
        if nav.id = "favs" then favTxt = "  ·  Derecha + OK para quitar"
        m.sectionSub.text = catTxt + count.ToStr() + Tern(count = 1, " canal", " canales") + favTxt
    else
        unidad = Tern(IsVodSection(nav.id) or nav.id = "search" or nav.id = "history", " títulos", " canales")
        totalRows = Int((count - 1) / GRID_COLS()) + 1
        rowTxt = ""
        if totalRows > VisRows()
            curRow = m.rowOffset + 1
            rowTxt = "  ·  fila " + curRow.ToStr() + " de " + totalRows.ToStr()
        end if
        filterTxt = ""
        if IsVodFilterContext()
            filterTxt = "  ·  Filtro: " + VodFilterLabel() + " (* cambiar)"
        end if
        m.sectionSub.text = count.ToStr() + unidad + rowTxt + filterTxt
    end if
end sub
sub SetHardwareIndicator(prefix as String, value as Dynamic)
    isYes = (value = true)
    isNo = (value = false)
    m.top.FindNode(prefix + "CheckShort").visible = isYes
    m.top.FindNode(prefix + "CheckLong").visible = isYes
    m.top.FindNode(prefix + "X1").visible = isNo
    m.top.FindNode(prefix + "X2").visible = isNo
    m.top.FindNode(prefix + "Unknown").visible = (value = invalid)
end sub
sub RenderHardwareSummary()
    info = m.top.hardwareInfo
    if info = invalid then return
    name = SafeStr(info.modelName)
    if name = "" then name = "Roku " + SafeStr(info.model)
    resolution = SafeStr(info.videoMode)
    if resolution = "" then resolution = "No determinado"
    m.hardwareModel.text = name
    m.hardwareResolution.text = resolution
    SetHardwareIndicator("avc", info.avc)
    SetHardwareIndicator("hevc", info.hevc)
    m.hardwareCompat2.text = ""
    if info.avc = true and info.hevc = true
        m.hardwareCompat1.color = "0x5BD68AFF"
        m.hardwareCompat1.text = "Esta TV puede reproducir películas y series H.264/H.265 compatibles."
    else if info.avc = true and info.hevc = false
        m.hardwareCompat1.color = "0x5BD68AFF"
        m.hardwareCompat1.text = "Esta TV admite películas y series H.264 compatibles."
        m.hardwareCompat2.color = "0xE96A72FF"
        m.hardwareCompat2.text = "HEVC no compatible. Para contenido H.265, utiliza un Roku 4K compatible."
    else if info.avc = invalid or info.hevc = invalid
        m.hardwareCompat1.color = "0x999DA8FF"
        m.hardwareCompat1.text = "No se pudo determinar la compatibilidad de video."
    else
        m.hardwareCompat1.color = "0xE96A72FF"
        m.hardwareCompat1.text = "Los perfiles H.264 y HEVC probados no son compatibles con este Roku."
    end if
end sub
sub RenderCategories()
    m.catRow.RemoveChildren(m.catRow.GetChildren(-1, 0))
    m.liveCatOverlay.RemoveChildren(m.liveCatOverlay.GetChildren(-1, 0))
    m.liveCatOverlay.visible = false
    nav = m.NAV[m.navIdx]
    m.catRow.visible = true
    if nav.id = "vivo"
        m.catRow.visible = false
        if m.region = "cats" then RenderLiveCategories()
        return
    end if
    if nav.id = "favs" or nav.id = "home" or nav.id = "history" or nav.id = "settings" or nav.id = "search"
        m.catRow.visible = false
        return
    end if
    CHIP_H  = 48
    FS      = 17
    AVAIL_W = 1520
    widths = []
    for i = 0 to m.categories.Count() - 1
        label = SafeStr(m.categories[i].name)
        widths.Push(TextW(label, FS) + 46)
    end for
    shift = 0
    if m.catIdx > 0
        endX = 0
        for i = 0 to m.catIdx
            endX = endX + widths[i] + 12
        end for
        if endX > AVAIL_W - 40 then shift = AVAIL_W - endX - 40
    end if
    x = shift
    for i = 0 to m.categories.Count() - 1
        label = SafeStr(m.categories[i].name)
        w = widths[i]
        if x + w > -50 and x < AVAIL_W + 50
            chip = m.catRow.CreateChild("Group")
            chip.translation = [x, 4]
            focused  = (m.region = "cats") and (i = m.catIdx)
            selected = (i = m.catIdx)
            if focused
                ring = chip.CreateChild("Poster")
                ring.uri = "pkg:/images/ui/focus_ring.9.png"
                ring.width = w + 8
                ring.height = CHIP_H + 8
                ring.translation = [-4, -4]
                ring.blendColor = "0x7DD3FCFF"
            end if
            bg = chip.CreateChild("Poster")
            bg.uri = "pkg:/images/ui/pill_white.9.png"
            bg.width  = w
            bg.height = CHIP_H
            if focused
                bg.blendColor = THEME_ACCENT()
            else if selected
                bg.blendColor = "0x1B335EFF"
            else
                bg.blendColor = "0x0E1930FF"
            end if
            txt = chip.CreateChild("Label")
            txt.text = label
            txt.font = ThemeFont(FS, focused or selected)
            txt.color = Tern(focused or selected, "0xFFFFFFFF", "0x94A3B8FF")
            txt.width = w
            txt.height = CHIP_H
            txt.horizAlign = "center"
            txt.vertAlign = "center"
        end if
        x = x + w + 12
    end for
end sub
sub RenderLiveCategories()
    m.liveCatOverlay.visible = true
    VISIBLE = 12
    ROW_H = 68
    startI = m.liveCatCursor - Int(VISIBLE / 2)
    if startI < 0 then startI = 0
    maxStart = m.categories.Count() - VISIBLE
    if maxStart < 0 then maxStart = 0
    if startI > maxStart then startI = maxStart
    lastI = startI + VISIBLE - 1
    if lastI > m.categories.Count() - 1 then lastI = m.categories.Count() - 1
    overlayShade = m.liveCatOverlay.CreateChild("Rectangle")
    overlayShade.width = 1620
    overlayShade.height = 1080
    overlayShade.translation = [300, 0]
    overlayShade.color = "0x00000099"
    panel = m.liveCatOverlay.CreateChild("Rectangle")
    panel.width = 476
    panel.height = 1080
    panel.translation = [300, 0]
    panel.color = "0x070E1FF7"
    borderR = m.liveCatOverlay.CreateChild("Rectangle")
    borderR.width = 2
    borderR.height = 1080
    borderR.translation = [774, 0]
    borderR.color = "0x1B335EFF"
    accent = m.liveCatOverlay.CreateChild("Rectangle")
    accent.width = 5
    accent.height = 50
    accent.translation = [330, 54]
    accent.color = THEME_ACCENT()
    heading = m.liveCatOverlay.CreateChild("Label")
    heading.text = "CATEGORÍAS"
    heading.font = ThemeFont(28, true)
    heading.color = THEME_TEXT()
    heading.translation = [352, 54]
    heading.width = 390
    heading.height = 50
    help = m.liveCatOverlay.CreateChild("Label")
    help.text = "↑↓ Elegir carpeta   ·   OK Abrir   ·   Atrás Volver"
    help.font = ThemeFont(15, false)
    help.color = THEME_MUTED()
    help.translation = [330, 112]
    help.width = 420
    help.height = 32
    if lastI < startI then return
    for i = startI to lastI
        cat = m.categories[i]
        isFavEntry = IsFavCat(cat)
        y = 172 + (i - startI) * ROW_H
        selected = (i = m.catIdx)
        focused = (i = m.liveCatCursor) and m.region = "cats"
        row = m.liveCatOverlay.CreateChild("Group")
        row.translation = [322, y]
        bg = row.CreateChild("Rectangle")
        bg.width = 430
        bg.height = 60
        bg.color = Tern(focused, Tern(isFavEntry, THEME_GOLD(), THEME_ACCENT()), Tern(selected, "0x122648FF", "0x0C162CFF"))
        bar = row.CreateChild("Rectangle")
        bar.width = 5
        bar.height = 60
        bar.color = Tern(selected and not focused, Tern(isFavEntry, THEME_GOLD(), THEME_ACCENT()), "0x00000000")
        textX = 18
        if isFavEntry
            starIc = row.CreateChild("Poster")
            starIc.uri = Tern(focused, "pkg:/images/ui/star_dark.png", "pkg:/images/ui/star_gold.png")
            starIc.width = 24
            starIc.height = 24
            starIc.translation = [16, 18]
            starIc.loadDisplayMode = "scaleToFit"
            textX = 48
        end if
        label = row.CreateChild("Label")
        label.text = SafeStr(cat.name)
        label.font = ThemeFont(19, focused or selected or isFavEntry)
        if focused and isFavEntry
            label.color = "0x060B18FF"
        else if focused or selected
            label.color = "0xFFFFFFFF"
        else if isFavEntry
            label.color = THEME_GOLD()
        else
            label.color = "0xCBD5E1FF"
        end if
        label.translation = [textX, 0]
        label.width = Tern(IsCatAdult(cat), 342, 412 - textX)
        label.height = 60
        label.vertAlign = "center"
        label.ellipsisText = "..."
        if IsCatAdult(cat)
            badge = row.CreateChild("Label")
            badge.text = "+18"
            badge.font = ThemeFont(15, true)
            badge.color = THEME_ACCENT_LT()
            badge.translation = [370, 0]
            badge.width = 46
            badge.height = 60
            badge.horizAlign = "center"
            badge.vertAlign = "center"
        end if
    end for
end sub
sub CalculateFullPanelWidth(mode as String)
    widthKey = "sections"
    if mode = "channels" and m.catIdx >= 0 and m.catIdx < m.categories.Count()
        widthKey = "channels:" + GetCatId(m.categories[m.catIdx]).ToStr()
    end if
    if widthKey = m.fullPanelWidthKey then return
    widest = 0
    if mode = "channels"
        for each entry in m.items
            w = TextW(SafeStr(entry.name), 17)
            if w > widest then widest = w
        end for
        m.fullPanelWidth = widest + 196
        if m.catIdx >= 0 and m.catIdx < m.categories.Count()
            headingWidth = TextW(UCase(SafeStr(m.categories[m.catIdx].name)), 25) + 60
            if headingWidth > m.fullPanelWidth then m.fullPanelWidth = headingWidth
        end if
        if m.fullPanelWidth < 460 then m.fullPanelWidth = 460
        if m.fullPanelWidth > 650 then m.fullPanelWidth = 650
    else
        for each entry in m.categories
            w = TextW(SafeStr(entry.name), 17)
            if w > widest then widest = w
        end for
        m.fullPanelWidth = widest + 112
        if m.fullPanelWidth < 390 then m.fullPanelWidth = 390
        if m.fullPanelWidth > 540 then m.fullPanelWidth = 540
    end if
    m.fullPanelWidthKey = widthKey
end sub
sub RenderFullLivePanel()
    m.liveCatOverlay.RemoveChildren(m.liveCatOverlay.GetChildren(-1, 0))
    if m.fullPanelMode = ""
        m.liveCatOverlay.visible = false
        return
    end if
    m.liveCatOverlay.visible = true
    PANEL_X = 24
    PANEL_Y = 74
    PANEL_W = m.fullPanelWidth
    PANEL_H = 932
    ROW_X = 44
    ROW_W = PANEL_W - 40
    shade = m.liveCatOverlay.CreateChild("Rectangle")
    shade.width = 1920 : shade.height = 1080 : shade.color = "0x00000066"
    panel = m.liveCatOverlay.CreateChild("Rectangle")
    panel.translation = [PANEL_X, PANEL_Y] : panel.width = PANEL_W : panel.height = PANEL_H : panel.color = "0x060C1BF2"
    borderTop = m.liveCatOverlay.CreateChild("Rectangle")
    borderTop.translation = [PANEL_X, PANEL_Y] : borderTop.width = PANEL_W : borderTop.height = 2 : borderTop.color = "0x1E3A6AFF"
    accent = m.liveCatOverlay.CreateChild("Rectangle")
    accent.translation = [PANEL_X, PANEL_Y] : accent.width = 5 : accent.height = PANEL_H : accent.color = THEME_ACCENT()
    eyebrow = m.liveCatOverlay.CreateChild("Label")
    eyebrow.translation = [ROW_X, 98] : eyebrow.width = ROW_W : eyebrow.height = 26
    eyebrow.font = ThemeFont(13, true) : eyebrow.color = THEME_ACCENT_LT()
    eyebrow.text = "XUPERTV  ·  GUÍA RÁPIDA"
    title = m.liveCatOverlay.CreateChild("Label")
    title.translation = [ROW_X, 126] : title.width = ROW_W : title.height = 44
    title.font = ThemeFont(25, true) : title.color = THEME_TEXT()
    title.ellipsisText = "..."
    if m.fullPanelMode = "channels" and m.catIdx >= 0 and m.catIdx < m.categories.Count()
        title.text = UCase(SafeStr(m.categories[m.catIdx].name))
    else
        title.text = "CATEGORÍAS"
    end if
    if m.fullPanelMode = "loading"
        title.text = "CARGANDO CANALES..."
        return
    end if
    source = m.categories
    if m.fullPanelMode = "channels" then source = m.items
    if source.Count() = 0
        emptyMsg = m.liveCatOverlay.CreateChild("Label")
        emptyMsg.translation = [ROW_X, 230] : emptyMsg.width = ROW_W : emptyMsg.height = 100
        emptyMsg.wrap = true : emptyMsg.font = ThemeFont(17, false) : emptyMsg.color = THEME_MUTED()
        emptyMsg.text = "Aún no tienes canales guardados en Favoritos. Usa Flecha Derecha + OK sobre cualquier canal para agregarlo."
        helpEmpty = m.liveCatOverlay.CreateChild("Label")
        helpEmpty.translation = [ROW_X, 956] : helpEmpty.width = ROW_W : helpEmpty.height = 26
        helpEmpty.font = ThemeFont(14, false) : helpEmpty.color = THEME_MUTED()
        helpEmpty.text = "Atrás Regresar"
        return
    end if
    VISIBLE = 9
    startI = m.fullPanelCursor - Int(VISIBLE / 2)
    if startI < 0 then startI = 0
    maxStart = source.Count() - VISIBLE
    if maxStart < 0 then maxStart = 0
    if startI > maxStart then startI = maxStart
    lastI = startI + VISIBLE - 1
    if lastI > source.Count() - 1 then lastI = source.Count() - 1
    if lastI < startI then return
    for i = startI to lastI
        entry = source[i]
        row = m.liveCatOverlay.CreateChild("Group")
        row.translation = [ROW_X, 194 + (i - startI) * 74]
        focusedRow = (i = m.fullPanelCursor)
        mainW = Tern(m.fullPanelMode = "channels", ROW_W - 64, ROW_W)
        bg = row.CreateChild("Rectangle")
        bg.width = mainW : bg.height = 64
        active = (m.fullPanelMode = "channels" and i = m.gridIdx)
        isFavCatRow = (m.fullPanelMode = "categories" and IsFavCat(entry))
        if focusedRow and not (m.fullPanelMode = "channels" and m.fullPanelFavFocus)
            bg.color = Tern(isFavCatRow, THEME_GOLD(), THEME_ACCENT())
        else if active
            bg.color = "0x102A4EFF"
        else
            bg.color = "0x0D172EEB"
        end if
        marker = row.CreateChild("Rectangle")
        marker.width = 4 : marker.height = 64
        marker.color = Tern(active and not focusedRow, THEME_ACCENT_LT(), "0x00000000")
        xText = 22
        if m.fullPanelMode = "channels"
            logo = row.CreateChild("Poster")
            logo.translation = [14, 9]
            SetupPoster(logo, entry, 56, 46, "scaleToFit")
            xText = 82
        else if isFavCatRow
            stCat = row.CreateChild("Poster")
            stCat.uri = Tern(focusedRow, "pkg:/images/ui/star_dark.png", "pkg:/images/ui/star_gold.png")
            stCat.translation = [15, 20] : stCat.width = 24 : stCat.height = 24 : stCat.loadDisplayMode = "scaleToFit"
            xText = 48
        else
            dot = row.CreateChild("Rectangle")
            dot.translation = [18, 27] : dot.width = 8 : dot.height = 8
            dot.color = Tern(focusedRow, "0xFFFFFFFF", THEME_ACCENT())
            xText = 46
        end if
        textWidth = mainW - xText - 14
        if m.fullPanelMode = "categories" then textWidth = textWidth - 42
        needsScroll = (m.fullPanelMode = "channels" and focusedRow and not m.fullPanelFavFocus and TextW(SafeStr(entry.name), 17) > textWidth)
        if needsScroll
            label = row.CreateChild("ScrollingLabel")
            label.text = SafeStr(entry.name) : label.translation = [xText, 0]
            label.maxWidth = textWidth : label.height = 64 : label.vertAlign = "center"
            label.scrollSpeed = 48 : label.repeatCount = -1
            label.font = ThemeFont(17, true) : label.color = "0xFFFFFFFF"
        else
            label = row.CreateChild("Label")
            label.text = SafeStr(entry.name) : label.translation = [xText, 0]
            label.width = textWidth : label.height = 64 : label.vertAlign = "center"
            label.ellipsisText = "..." : label.font = ThemeFont(17, focusedRow or isFavCatRow)
            if focusedRow and isFavCatRow
                label.color = "0x060B18FF"
            else if not focusedRow and isFavCatRow
                label.color = THEME_GOLD()
            else
                label.color = "0xFFFFFFFF"
            end if
        end if
        if m.fullPanelMode = "channels"
            chFav = IsChannelFav(entry)
            favCellFocused = (focusedRow and m.fullPanelFavFocus)
            favBg = row.CreateChild("Rectangle")
            favBg.translation = [mainW + 6, 0]
            favBg.width = 58 : favBg.height = 64
            if favCellFocused
                favBg.color = Tern(chFav, THEME_GOLD(), THEME_ACCENT())
            else if chFav
                favBg.color = "0x2E2410EB"
            else
                favBg.color = "0x0D172EEB"
            end if
            favIcon = row.CreateChild("Poster")
            if favCellFocused and chFav
                favIcon.uri = "pkg:/images/ui/star_dark.png"
            else if favCellFocused
                favIcon.uri = "pkg:/images/ui/star_white.png"
            else if chFav
                favIcon.uri = "pkg:/images/ui/star_gold.png"
            else
                favIcon.uri = "pkg:/images/ui/star_outline.png"
            end if
            favIcon.width = 28 : favIcon.height = 28
            favIcon.translation = [mainW + 21, 18]
            favIcon.loadDisplayMode = "scaleToFit"
        else if m.fullPanelMode = "categories" and IsCatAdult(entry)
            lockBadge = row.CreateChild("Label")
            lockBadge.text = "+18" : lockBadge.translation = [ROW_W - 54, 0] : lockBadge.width = 48 : lockBadge.height = 64
            lockBadge.vertAlign = "center" : lockBadge.horizAlign = "center"
            lockBadge.font = ThemeFont(15, true) : lockBadge.color = THEME_GOLD()
        else if m.fullPanelMode = "categories"
            arrow = row.CreateChild("Label")
            arrow.text = ">" : arrow.translation = [ROW_W - 36, 0] : arrow.width = 28 : arrow.height = 64
            arrow.vertAlign = "center" : arrow.horizAlign = "center"
            arrow.font = ThemeFont(18, true) : arrow.color = Tern(focusedRow, Tern(isFavCatRow, "0x060B18FF", "0xFFFFFFFF"), THEME_MUTED())
        end if
    end for
    help = m.liveCatOverlay.CreateChild("Label")
    help.translation = [ROW_X, 958] : help.width = ROW_W : help.height = 26
    help.font = ThemeFont(14, false) : help.color = THEME_MUTED()
    backLbl = Tern(m.NAV[m.navIdx].id = "favs", "Atrás Cerrar", "Atrás Categorías")
    if m.fullPanelMode = "channels"
        help.text = Tern(m.fullPanelFavFocus, "OK Guardar/Quitar Favorito  ·  ◀ Canal", "OK Ver  ·  ▶ Favorito  ·  " + backLbl)
    else
        help.text = "OK Abrir carpeta  ·  Atrás Cerrar"
    end if
end sub
sub OpenFullLivePanel(focusFav = false as Boolean)
    RecoveryCancel()
    m.fullPanelFavFocus = focusFav
    if m.items.Count() > 0
        m.fullPanelMode = "channels"
        CalculateFullPanelWidth("channels")
        m.fullPanelCursor = m.gridIdx
        if m.fullPanelCursor < 0 or m.fullPanelCursor >= m.items.Count() then m.fullPanelCursor = 0
    else
        m.fullPanelMode = "categories"
        CalculateFullPanelWidth("categories")
        m.fullPanelCursor = m.catIdx
    end if
    m.fullPanelWaiting = false
    RenderFullLivePanel()
    if m.fullPanelSlide <> invalid then m.fullPanelSlide.control = "start"
end sub
sub CloseFullLivePanel()
    m.fullPanelMode = ""
    m.fullPanelFavFocus = false
    m.fullPanelWaiting = false
    RenderFullLivePanel()
end sub
sub FullCategoryLoaded()
    if not m.fullPanelWaiting then return
    m.fullPanelWaiting = false
    m.fullPanelMode = "channels"
    CalculateFullPanelWidth("channels")
    m.fullPanelCursor = 0
    key = GetCatId(m.categories[m.catIdx]).ToStr()
    if m.fullPanelPositions[key] <> invalid then m.fullPanelCursor = m.fullPanelPositions[key]
    if m.fullPanelCursor < 0 or m.fullPanelCursor >= m.items.Count() then m.fullPanelCursor = 0
    RenderFullLivePanel()
end sub
sub RenderGrid()
    RenderHeader()
    if m.gridState = "loading"
        ClearGridArea()
        MakeStatusLabel("Cargando...")
        return
    else if m.gridState = "locked"
        ClearGridArea()
        MakeLockedState()
        return
    else if m.gridState = "error"
        ClearGridArea()
        MakeErrorState()
        return
    else if m.gridState = "empty"
        ClearGridArea()
        MakeEmptyState()
        return
    else if m.gridState = "nohevc"
        ClearGridArea()
        MakeNoHevcState()
        return
    end if
    nav = m.NAV[m.navIdx]
    if IsLiveSection(nav.id)
        ClearGridArea()
        MakeLiveBrowser()
        return
    end if
    if IsVodSection(nav.id) or nav.id = "search" or nav.id = "history"
        MakeTileGrid(true)
    else
        MakeTileGrid(false)
    end if
end sub
sub ClearGridArea()
    m.gridArea.RemoveChildren(m.gridArea.GetChildren(-1, 0))
    m.renderedTiles = []
    m.tileGridSignature = ""
end sub
sub MakeLiveBrowser()
    if m.items.Count() = 0 then return
    if m.gridIdx < 0 then m.gridIdx = 0
    if m.gridIdx > m.items.Count() - 1 then m.gridIdx = m.items.Count() - 1
    it = m.items[m.gridIdx]
    isFav = IsChannelFav(it)
    playingCode = SafeStr(m.player.channelCode)
    isSelectedPlaying = (m.player.visible and playingCode <> "" and SafeStr(it.channelCode) = playingCode)

    preview = m.gridArea.CreateChild("Group")
    preview.translation = [40, 146]
    previewBorder = preview.CreateChild("Rectangle")
    previewBorder.width = 1052
    previewBorder.height = 804
    previewBorder.translation = [-4, -4]
    previewBorder.color = Tern(m.region = "preview", THEME_ACCENT(), "0x162848FF")

    previewBg = preview.CreateChild("Rectangle")
    previewBg.width = 1044
    previewBg.height = 796
    previewBg.color = "0x091122FF"

    frame = preview.CreateChild("Rectangle")
    frame.width = 1044
    frame.height = 588
    frame.color = "0x03060DFF"

    art = preview.CreateChild("Poster")
    art.translation = [307, 149]
    SetupPoster(art, it, 430, 290, "scaleToFit")

    shade = preview.CreateChild("Rectangle")
    shade.width = 1044
    shade.height = 208
    shade.translation = [0, 588]
    shade.color = "0x0B152AFF"

    divider = preview.CreateChild("Rectangle")
    divider.width = 1044
    divider.height = 2
    divider.translation = [0, 588]
    divider.color = "0x1B345EFF"

    livePill = preview.CreateChild("Rectangle")
    livePill.width = 112
    livePill.height = 28
    livePill.translation = [28, 608]
    livePill.color = Tern(isSelectedPlaying, THEME_LIVE(), "0x182A4AFF")
    livePillLbl = preview.CreateChild("Label")
    livePillLbl.text = Tern(isSelectedPlaying, "EN VIVO", "CANAL " + (m.gridIdx + 1).ToStr())
    livePillLbl.font = ThemeFont(12, true)
    livePillLbl.color = "0xFFFFFFFF"
    livePillLbl.translation = [28, 608]
    livePillLbl.width = 112
    livePillLbl.height = 28
    livePillLbl.horizAlign = "center"
    livePillLbl.vertAlign = "center"

    catTagTxt = "XUPERTV"
    if IsValidStr(SafeStr(it._favCategoryName)) and (m.NAV[m.navIdx].id = "favs" or (m.catIdx >= 0 and m.catIdx < m.categories.Count() and IsFavCat(m.categories[m.catIdx])))
        catTagTxt = UCase(SafeStr(it._favCategoryName))
    else if m.catIdx >= 0 and m.catIdx < m.categories.Count()
        catTagTxt = UCase(SafeStr(m.categories[m.catIdx].name))
    end if
    catTag = preview.CreateChild("Label")
    catTag.text = catTagTxt
    catTag.font = ThemeFont(14, true)
    catTag.color = THEME_ACCENT_LT()
    catTag.translation = [152, 608]
    catTag.width = 660
    catTag.height = 28
    catTag.vertAlign = "center"

    if isFav
        favPillBg = preview.CreateChild("Rectangle")
        favPillBg.width = 190
        favPillBg.height = 28
        favPillBg.translation = [826, 608]
        favPillBg.color = "0x382B0FFF"
        favPillIc = preview.CreateChild("Poster")
        favPillIc.uri = "pkg:/images/ui/star_gold.png"
        favPillIc.width = 16 : favPillIc.height = 16
        favPillIc.translation = [836, 614]
        favPillIc.loadDisplayMode = "scaleToFit"
        favPillLbl = preview.CreateChild("Label")
        favPillLbl.text = "EN FAVORITOS"
        favPillLbl.font = ThemeFont(12, true)
        favPillLbl.color = THEME_GOLD()
        favPillLbl.translation = [858, 608]
        favPillLbl.width = 152
        favPillLbl.height = 28
        favPillLbl.vertAlign = "center"
    end if

    name = preview.CreateChild("Label")
    name.text = SafeStr(it.name)
    name.font = ThemeFont(29, true)
    name.color = THEME_TEXT()
    name.translation = [28, 646]
    name.width = 988
    name.height = 44
    name.ellipsisText = "..."

    btnCount = PreviewBtnCount()
    if m.previewBtnIdx >= btnCount then m.previewBtnIdx = btnCount - 1
    if m.previewBtnIdx < 0 then m.previewBtnIdx = 0

    btnTexts = [
        Tern(isSelectedPlaying, "Pantalla completa", "Sintonizar canal"),
        Tern(isFav, "Quitar favorito", "Agregar favorito")
    ]
    btnIcons = [
        Tern(isSelectedPlaying, "pkg:/images/ui/fullscreen.png", "pkg:/images/ui/play.png"),
        Tern(isFav, "pkg:/images/ui/star_gold.png", "pkg:/images/ui/star_outline.png")
    ]
    btnWidths = [332, 320]
    if btnCount = 3
        btnTexts.Push("Categorías")
        btnIcons.Push("pkg:/images/ui/categories.png")
        btnWidths.Push(248)
    end if

    bx = 28
    for b = 0 to btnCount - 1
        bfoc = (m.region = "preview" and m.previewBtnIdx = b)
        bw = btnWidths[b]
        if bfoc
            ring = preview.CreateChild("Rectangle")
            ring.translation = [bx - 2, 708]
            ring.width = bw + 4
            ring.height = 60
            ring.color = "0xFFFFFFFF"
        end if
        bbg = preview.CreateChild("Rectangle")
        bbg.translation = [bx, 710]
        bbg.width = bw
        bbg.height = 56
        if bfoc
            bbg.color = Tern(b = 1 and isFav, THEME_GOLD(), THEME_ACCENT())
        else if b = 1 and isFav
            bbg.color = "0x2E2410FF"
        else
            bbg.color = "0x132240FF"
        end if

        bic = preview.CreateChild("Poster")
        iconUri = btnIcons[b]
        if b = 1 and bfoc and isFav
            iconUri = "pkg:/images/ui/star_dark.png"
        else if b = 1 and bfoc and not isFav
            iconUri = "pkg:/images/ui/star_white.png"
        end if
        bic.uri = iconUri
        bic.width = 24
        bic.height = 24
        bic.translation = [bx + 20, 726]
        bic.loadDisplayMode = "scaleToFit"

        btxt = preview.CreateChild("Label")
        btxt.translation = [bx + 54, 710]
        btxt.width = bw - 66
        btxt.height = 56
        btxt.text = btnTexts[b]
        btxt.font = ThemeFont(17, true)
        if bfoc and b = 1 and isFav
            btxt.color = "0x060B18FF"
        else if not bfoc and b = 1 and isFav
            btxt.color = THEME_GOLD()
        else
            btxt.color = "0xFFFFFFFF"
        end if
        btxt.vertAlign = "center"
        bx = bx + bw + 16
    end for

    list = m.gridArea.CreateChild("Group")
    list.translation = [1108, 122]

    catName = "TV"
    if m.catIdx >= 0 and m.catIdx < m.categories.Count() then catName = SafeStr(m.categories[m.catIdx].name)
    title = list.CreateChild("Label")
    title.text = UCase(catName) + "  •  " + m.items.Count().ToStr() + Tern(m.items.Count() = 1, " CANAL", " CANALES")
    title.font = ThemeFont(16, true)
    title.color = Tern(m.NAV[m.navIdx].id = "favs", THEME_GOLD(), THEME_ACCENT_LT())
    title.width = 396
    title.height = 36

    favHdrBg = list.CreateChild("Rectangle")
    favHdrBg.translation = [406, 2]
    favHdrBg.width = 62
    favHdrBg.height = 28
    favHdrBg.color = Tern(m.region = "grid_fav", "0x362A10FF", "0x0D162BFF")
    favHdrLbl = list.CreateChild("Label")
    favHdrLbl.text = "FAV"
    favHdrLbl.font = ThemeFont(13, true)
    favHdrLbl.color = Tern(m.region = "grid_fav", THEME_GOLD(), THEME_MUTED())
    favHdrLbl.translation = [406, 2]
    favHdrLbl.width = 62
    favHdrLbl.height = 28
    favHdrLbl.horizAlign = "center"
    favHdrLbl.vertAlign = "center"

    VISIBLE = 11
    startI = m.rowOffset
    if startI < 0 then startI = 0
    maxStart = m.items.Count() - VISIBLE
    if maxStart < 0 then maxStart = 0
    if startI > maxStart then startI = maxStart
    lastI = startI + VISIBLE - 1
    if lastI > m.items.Count() - 1 then lastI = m.items.Count() - 1

    for i = startI to lastI
        channel = m.items[i]
        y = 44 + (i - startI) * 72
        rowFocused = (m.region = "grid") and (i = m.gridIdx)
        favFocused = (m.region = "grid_fav") and (i = m.gridIdx)
        isPlayingNow = (m.player.visible and playingCode <> "" and SafeStr(channel.channelCode) = playingCode)
        chFav = IsChannelFav(channel)

        row = list.CreateChild("Group")
        row.translation = [0, y]

        bg = row.CreateChild("Rectangle")
        bg.width = 400
        bg.height = 64
        bg.color = Tern(rowFocused, THEME_ACCENT(), Tern(favFocused, "0x152748FF", Tern(isPlayingNow, "0x0F2647FF", "0x0B1427FF")))

        bar = row.CreateChild("Rectangle")
        bar.width = 4
        bar.height = 64
        bar.color = Tern(rowFocused, "0xFFFFFFFF", Tern(isPlayingNow, THEME_ACCENT_LT(), "0x00000000"))

        numLbl = row.CreateChild("Label")
        numStr = (i + 1).ToStr()
        if i + 1 < 10 then numStr = "0" + numStr
        numLbl.text = numStr
        numLbl.font = ThemeFont(14, true)
        numLbl.color = Tern(rowFocused, "0xFFFFFFFF", Tern(isPlayingNow, THEME_ACCENT_LT(), THEME_MUTED2()))
        numLbl.translation = [12, 0]
        numLbl.width = 28
        numLbl.height = 64
        numLbl.vertAlign = "center"

        logoBg = row.CreateChild("Rectangle")
        logoBg.width = 54
        logoBg.height = 46
        logoBg.translation = [44, 9]
        logoBg.color = "0x050A14CC"

        logo = row.CreateChild("Poster")
        logo.translation = [46, 11]
        SetupPoster(logo, channel, 50, 42, "scaleToFit")

        label = row.CreateChild("Label")
        label.text = SafeStr(channel.name)
        label.font = ThemeFont(17, rowFocused or favFocused or isPlayingNow)
        label.color = THEME_TEXT()
        label.translation = [108, 0]
        label.width = 282
        label.height = 64
        label.vertAlign = "center"
        label.ellipsisText = "..."

        if favFocused
            favRing = row.CreateChild("Rectangle")
            favRing.translation = [404, -2]
            favRing.width = 66
            favRing.height = 68
            favRing.color = "0xFFFFFFFF"
        end if

        favBtnBg = row.CreateChild("Rectangle")
        favBtnBg.translation = [406, 0]
        favBtnBg.width = 62
        favBtnBg.height = 64
        if favFocused
            favBtnBg.color = Tern(chFav, THEME_GOLD(), THEME_ACCENT())
        else if chFav
            favBtnBg.color = "0x2E2410FF"
        else
            favBtnBg.color = "0x0B1427FF"
        end if

        favStar = row.CreateChild("Poster")
        if favFocused and chFav
            favStar.uri = "pkg:/images/ui/star_dark.png"
        else if favFocused
            favStar.uri = "pkg:/images/ui/star_white.png"
        else if chFav
            favStar.uri = "pkg:/images/ui/star_gold.png"
        else
            favStar.uri = "pkg:/images/ui/star_outline.png"
        end if
        favStar.width = 28
        favStar.height = 28
        favStar.translation = [423, 18]
        favStar.loadDisplayMode = "scaleToFit"
    end for

    if m.items.Count() > VISIBLE
        trackH = VISIBLE * 72 - 8
        track = list.CreateChild("Rectangle")
        track.translation = [476, 44]
        track.width = 4
        track.height = trackH
        track.color = "0x15233EFF"
        thumbH = Int(trackH * VISIBLE / m.items.Count())
        if thumbH < 36 then thumbH = 36
        maxScroll = m.items.Count() - VISIBLE
        thumbY = 44
        if maxScroll > 0
            thumbY = 44 + Int((trackH - thumbH) * startI / maxScroll)
        end if
        thumb = list.CreateChild("Rectangle")
        thumb.translation = [476, thumbY]
        thumb.width = 4
        thumb.height = thumbH
        thumb.color = THEME_ACCENT()
    end if
end sub
sub EnsureLiveChannelVisible()
    VISIBLE = 11
    if m.gridIdx < m.rowOffset
        m.rowOffset = m.gridIdx
    else if m.gridIdx > m.rowOffset + VISIBLE - 1
        m.rowOffset = m.gridIdx - VISIBLE + 1
    end if
end sub
sub MakeStatusLabel(msg as String)
    id = m.NAV[m.navIdx].id
    tileH = Tern(IsVodSection(id) or id = "search" or id = "history", POSTER_TILE_H(), CH_TILE_H())
    stepX = TILE_W() + GRID_GAP()
    stepY = tileH + TILE_LABEL_H() + GRID_GAP()
    for row = 0 to VisRows() - 1
        for col = 0 to GRID_COLS() - 1
            sk = m.gridArea.CreateChild("Rectangle")
            sk.width  = TILE_W()
            sk.height = tileH + TILE_LABEL_H()
            sk.translation = [col * stepX, row * stepY]
            sk.color = "0x0B1426FF"
        end for
    end for
    lbl = m.gridArea.CreateChild("Label")
    lbl.text = msg
    lbl.font = ThemeFont(19, true)
    lbl.color = THEME_MUTED()
    lbl.translation = [0, 640]
    lbl.width = 1682
    lbl.horizAlign = "center"
end sub
sub MakeLockedState()
    g = m.gridArea.CreateChild("Group")
    g.translation = [0, 130]
    lockBg = g.CreateChild("Rectangle")
    lockBg.width  = 104
    lockBg.height = 104
    lockBg.translation = [789, 0]
    lockBg.color = "0x0E1930FF"
    lockPic = g.CreateChild("Poster")
    lockPic.uri = "pkg:/images/ui/lock.png"
    lockPic.width = 58
    lockPic.height = 58
    lockPic.translation = [812, 23]
    lockPic.loadDisplayMode = "scaleToFit"
    title = g.CreateChild("Label")
    title.text = "Contenido protegido (+18)"
    title.font = ThemeFont(32, true)
    title.color = THEME_TEXT()
    title.translation = [0, 128]
    title.width = 1682
    title.horizAlign = "center"
    sub1 = g.CreateChild("Label")
    sub1.text = "Esta sección requiere control parental para mayores de edad."
    sub1.font = ThemeFont(20, false)
    sub1.color = THEME_MUTED()
    sub1.translation = [341, 178]
    sub1.width = 1000
    sub1.horizAlign = "center"
    sub1.wrap = true
    sub2 = g.CreateChild("Label")
    sub2.text = "Presiona OK e ingresa tu PIN de 4 dígitos para desbloquear."
    sub2.font = ThemeFont(19, false)
    sub2.color = THEME_MUTED()
    sub2.translation = [341, 214]
    sub2.width = 1000
    sub2.horizAlign = "center"
    sub2.wrap = true
    btn = g.CreateChild("Rectangle")
    btn.width  = 310
    btn.height = 58
    btn.translation = [686, 276]
    btn.color = THEME_ACCENT()
    btnLbl = g.CreateChild("Label")
    btnLbl.text = "Desbloquear con PIN  ·  OK"
    btnLbl.font = ThemeFont(19, true)
    btnLbl.color = "0xFFFFFFFF"
    btnLbl.translation = [686, 276]
    btnLbl.width  = 310
    btnLbl.height = 58
    btnLbl.horizAlign = "center"
    btnLbl.vertAlign  = "center"
end sub
sub MakeNoHevcState()
    g = m.gridArea.CreateChild("Group")
    g.translation = [0, 150]
    title = g.CreateChild("Label")
    title.text = "Este equipo no puede reproducir peliculas"
    title.font = ThemeFont(30, true)
    title.color = THEME_TEXT()
    title.translation = [0, 110]
    title.width = 1682
    title.horizAlign = "center"
    sub_ = g.CreateChild("Label")
    sub_.text = "El Roku no pudo decodificar el formato de este título. Esto no significa que todas las películas o series utilicen el mismo códec."
    sub_.font = ThemeFont(18, false)
    sub_.color = THEME_MUTED()
    sub_.translation = [431, 158]
    sub_.width = 820
    sub_.horizAlign = "center"
    sub_.wrap = true
end sub
sub MakeErrorState()
    g = m.gridArea.CreateChild("Group")
    g.translation = [0, 150]
    badge = g.CreateChild("Rectangle")
    badge.width = 84
    badge.height = 84
    badge.translation = [799, 0]
    badge.color = THEME_ERR_BG()
    icon = g.CreateChild("Label")
    icon.text = "!"
    icon.font = ThemeFont(46, true)
    icon.color = THEME_ERR_ICON()
    icon.translation = [799, 0]
    icon.width = 84
    icon.height = 84
    icon.horizAlign = "center"
    icon.vertAlign  = "center"
    title = g.CreateChild("Label")
    nav = m.NAV[m.navIdx]
    title.text = Tern(IsLiveSection(nav.id), "No pudimos cargar esta sección", "No pudimos cargar el contenido")
    title.font = ThemeFont(30, true)
    title.color = THEME_TEXT()
    title.translation = [0, 110]
    title.width = 1682
    title.horizAlign = "center"
    sub_ = g.CreateChild("Label")
    sub_.text = "Revisa la red o vuelve a intentar. Debajo está el detalle técnico para diagnosticarlo."
    sub_.font = ThemeFont(18, false)
    sub_.color = THEME_MUTED()
    sub_.translation = [431, 158]
    sub_.width = 820
    sub_.horizAlign = "center"
    sub_.wrap = true
    detailBg = g.CreateChild("Rectangle")
    detailBg.width = 1000
    detailBg.height = 96
    detailBg.translation = [341, 210]
    detailBg.color = "0x0A1224FF"
    detail = g.CreateChild("Label")
    detail.text = m.errorDetail
    detail.font = ThemeFont(16, false)
    detail.color = "0xFF8B92FF"
    detail.translation = [365, 224]
    detail.width = 952
    detail.height = 70
    detail.wrap = true
    detail.maxLines = 3
    btn = g.CreateChild("Rectangle")
    btn.width = 240
    btn.height = 54
    btn.translation = [721, 334]
    btn.color = THEME_ACCENT()
    btnLbl = g.CreateChild("Label")
    btnLbl.text = "Reintentar  .  OK"
    btnLbl.font = ThemeFont(18, true)
    btnLbl.color = "0xFFFFFFFF"
    btnLbl.translation = [721, 334]
    btnLbl.width = 240
    btnLbl.height = 54
    btnLbl.horizAlign = "center"
    btnLbl.vertAlign  = "center"
end sub
sub MakeEmptyState()
    nav = m.NAV[m.navIdx]
    isFavEmpty = (nav.id = "favs" or (nav.id = "vivo" and m.catIdx >= 0 and m.catIdx < m.categories.Count() and IsFavCat(m.categories[m.catIdx])))
    g = m.gridArea.CreateChild("Group")
    g.translation = [0, 170]
    badge = g.CreateChild("Rectangle")
    badge.width = 92
    badge.height = 92
    badge.translation = [795, 0]
    badge.color = THEME_SURFACE()
    if isFavEmpty
        starEmpty = g.CreateChild("Poster")
        starEmpty.uri = "pkg:/images/ui/star_gold.png"
        starEmpty.width = 48
        starEmpty.height = 48
        starEmpty.translation = [817, 22]
        starEmpty.loadDisplayMode = "scaleToFit"
    else
        icon = g.CreateChild("Label")
        icon.text = "—"
        icon.font = ThemeFont(38, true)
        icon.color = THEME_ACCENT_LT()
        icon.translation = [795, 0]
        icon.width = 92
        icon.height = 92
        icon.horizAlign = "center"
        icon.vertAlign  = "center"
    end if
    title = g.CreateChild("Label")
    title.font = ThemeFont(30, true)
    title.color = THEME_TEXT()
    title.translation = [0, 116]
    title.width = 1682
    title.horizAlign = "center"
    if isFavEmpty
        title.text = "Tu lista de Favoritos está vacía"
    else
        title.text = Tern(nav.id = "history", "Aún no has reproducido contenido", "Sin contenido por aquí")
    end if
    sub_ = g.CreateChild("Label")
    sub_.font = ThemeFont(18, false)
    sub_.color = THEME_MUTED()
    sub_.translation = [381, 166]
    sub_.width = 920
    sub_.horizAlign = "center"
    sub_.wrap = true
    if isFavEmpty
        sub_.text = "En TV en vivo, mueve con la flecha Derecha hacia la estrella de cualquier canal (o al botón Agregar favorito debajo del video) y presiona OK."
    else
        sub_.text = Tern(nav.id = "history", "Lo que veas en XuperTV aparecerá aquí para retomarlo rápidamente.", "No encontramos contenido en esta categoría. Prueba con otra.")
    end if
end sub
sub MakeTileGrid(isPoster as Boolean)
    tileH   = Tern(isPoster, POSTER_TILE_H(), CH_TILE_H())
    labelH  = TILE_LABEL_H()
    stepX   = TILE_W() + GRID_GAP()
    stepY   = tileH + labelH + GRID_GAP()
    cols    = GRID_COLS()
    firstIdx = m.rowOffset * cols
    lastIdx  = firstIdx + (VisRows() * cols) - 1
    if lastIdx > m.items.Count() - 1 then lastIdx = m.items.Count() - 1

    navId = m.NAV[m.navIdx].id
    sig = navId + "|" + m.catIdx.ToStr() + "|" + SafeStr(m.vodFilter) + "|" + m.seriesMode.ToStr() + "|" + m.seriesContentId + "|" + m.rowOffset.ToStr() + "|" + m.items.Count().ToStr() + "|" + isPoster.ToStr()
    if m.renderedTiles <> invalid and m.renderedTiles.Count() > 0 and m.tileGridSignature = sig
        for each rt in m.renderedTiles
            focused = (m.region = "grid") and (rt.idx = m.gridIdx)
            rt.ring.visible = focused
            rt.wrap.blendColor = Tern(focused, "0x152546FF", "0x0B1326FF")
            if rt.nameLbl <> invalid then rt.nameLbl.color = Tern(focused, "0xFFFFFFFF", "0xCBD5E1FF")
        end for
        if isPoster then ScheduleGridCodecProbe()
        return
    end if

    m.gridArea.RemoveChildren(m.gridArea.GetChildren(-1, 0))
    m.renderedTiles = []
    m.tileGridSignature = sig

    for i = firstIdx to lastIdx
        it = m.items[i]
        col = i mod cols
        row = Int(i / cols) - m.rowOffset
        focused = (m.region = "grid") and (i = m.gridIdx)
        tile = m.gridArea.CreateChild("Group")
        tile.translation = [col * stepX, row * stepY]

        ring = tile.CreateChild("Poster")
        ring.uri = "pkg:/images/ui/focus_ring.9.png"
        ring.width  = TILE_W() + 10
        ring.height = tileH + labelH + 10
        ring.translation = [-5, -5]
        ring.blendColor = THEME_ACCENT()
        ring.visible = focused

        wrap = tile.CreateChild("Poster")
        wrap.uri = "pkg:/images/ui/card_white.9.png"
        wrap.width = TILE_W()
        wrap.height = tileH + labelH
        wrap.blendColor = Tern(focused, "0x152546FF", "0x0B1326FF")

        ph = tile.CreateChild("Poster")
        ph.uri = "pkg:/images/ui/poster_placeholder.png"
        ph.width = 76
        ph.height = 76
        ph.loadWidth = 76
        ph.loadHeight = 76
        ph.translation = [Int((TILE_W() - 76) / 2), Int((tileH - 76) / 2)]
        ph.loadDisplayMode = "scaleToFit"

        img = tile.CreateChild("Poster")
        SetupPoster(img, it, TILE_W(), tileH, Tern(isPoster, "scaleToFill", "scaleToFit"))

        codecBg = invalid
        codecLbl = invalid
        if isPoster
            codecBg = tile.CreateChild("Poster")
            codecBg.uri = "pkg:/images/ui/badge_pill.9.png"
            codecBg.width = 128
            codecBg.height = 26
            codecBg.translation = [TILE_W() - 136, 10]
            codecLbl = tile.CreateChild("Label")
            codecLbl.font = ThemeFont(12, true)
            codecLbl.translation = [TILE_W() - 136, 10]
            codecLbl.width = 128
            codecLbl.height = 26
            codecLbl.horizAlign = "center"
            codecLbl.vertAlign = "center"
            ApplyTileCodecBadge(codecBg, codecLbl, VodCodecForItem(it))
        end if
        if not isPoster
            liveBg = tile.CreateChild("Poster")
            liveBg.uri = "pkg:/images/ui/badge_pill.9.png"
            liveBg.width = 76
            liveBg.height = 24
            liveBg.translation = [10, 10]
            liveBg.blendColor = THEME_LIVE()
            liveLbl = tile.CreateChild("Label")
            liveLbl.text = "EN VIVO"
            liveLbl.font = ThemeFont(10, true)
            liveLbl.color = "0xFFFFFFFF"
            liveLbl.translation = [10, 10]
            liveLbl.width = 76
            liveLbl.height = 24
            liveLbl.horizAlign = "center"
            liveLbl.vertAlign  = "center"
            if IsLocked(it)
                lockBg = tile.CreateChild("Poster")
                lockBg.uri = "pkg:/images/ui/badge_pill.9.png"
                lockBg.width = 40
                lockBg.height = 24
                lockBg.translation = [TILE_W() - 50, 10]
                lockBg.blendColor = "0x08090CCC"
                lockLbl = tile.CreateChild("Label")
                lockLbl.text = "+18"
                lockLbl.font = ThemeFont(10, true)
                lockLbl.color = THEME_GOLD()
                lockLbl.translation = [TILE_W() - 50, 10]
                lockLbl.width = 40
                lockLbl.height = 24
                lockLbl.horizAlign = "center"
                lockLbl.vertAlign  = "center"
            end if
        end if
        code = ItemCode(it)
        isFav = (code <> "" and m.favs[code] <> invalid)
        name = tile.CreateChild("Label")
        name.text = SafeStr(it.name)
        name.font = ThemeFont(20, true)
        name.color = Tern(focused, "0xFFFFFFFF", "0xCBD5E1FF")
        name.translation = [12, tileH]
        name.width  = TILE_W() - Tern(isFav, 42, 24)
        name.height = labelH
        name.vertAlign = "center"
        name.ellipsisText = "..."
        if isFav
            favPic = tile.CreateChild("Poster")
            favPic.uri = "pkg:/images/ui/star_gold.png"
            favPic.width = 20
            favPic.height = 20
            favPic.loadWidth = 20
            favPic.loadHeight = 20
            favPic.translation = [TILE_W() - 32, tileH + 17]
            favPic.loadDisplayMode = "scaleToFit"
        end if
        m.renderedTiles.Push({
            idx: i,
            code: code,
            key: VodCodecKey(it),
            ring: ring,
            wrap: wrap,
            nameLbl: name,
            codecBg: codecBg,
            codecLbl: codecLbl
        })
    end for
    if isPoster then ScheduleGridCodecProbe()
end sub

sub ApplyTileCodecBadge(bg as Object, lbl as Object, codecText as String)
    if bg = invalid or lbl = invalid then return
    if codecText = ""
        bg.visible = false
        lbl.visible = false
        return
    end if
    hevcSupported = (m.top.hardwareInfo <> invalid and m.top.hardwareInfo.hevc = true)
    if codecText = "H.264/AVC"
        bg.blendColor = "0x0A3628EB"
        lbl.color = "0x34D399FF"
        lbl.text = "H.264 ✓"
    else if codecText = "H.265/HEVC"
        if hevcSupported
            bg.blendColor = "0x0A3628EB"
            lbl.color = "0x34D399FF"
            lbl.text = "HEVC ✓"
        else
            bg.blendColor = "0x45121CEB"
            lbl.color = "0xFF6B7DFF"
            lbl.text = "HEVC · 4K"
        end if
    else
        bg.blendColor = "0x090B11EB"
        lbl.color = "0xE4E7EDFF"
        lbl.text = codecText.Replace("H.264/", "").Replace("H.265/", "")
    end if
    bg.visible = true
    lbl.visible = true
end sub

function UrlHost(url as String) as String
    u = LCase(SafeStr(url).Trim())
    if Left(u, 8) = "https://"
        rest = Mid(u, 9)
    else if Left(u, 7) = "http://"
        rest = Mid(u, 8)
    else
        return ""
    end if
    sp = Instr(1, rest, "/")
    if sp > 0 then return Left(rest, sp - 1)
    return rest
end function

function RewriteUrlHost(url as String, newHost as String) as String
    u = SafeStr(url).Trim()
    schemeLen = 0
    if Left(LCase(u), 8) = "https://"
        schemeLen = 8
    else if Left(LCase(u), 7) = "http://"
        schemeLen = 7
    else
        return ""
    end if
    rest = Mid(u, schemeLen + 1)
    sp = Instr(1, rest, "/")
    if sp <= 0 then return ""
    return Left(u, schemeLen) + newHost + Mid(rest, sp)
end function

function ExpandPosterFallbacks(rawUrls as Object) as Object
    out = []
    seen = {}
    if rawUrls = invalid then return out
    for each raw in rawUrls
        u = SafeStr(raw).Trim()
        if u <> ""
            h = UrlHost(u)
            isDead = (h <> "" and m.deadImageHosts <> invalid and m.deadImageHosts[h] <> invalid)
            hasPublicPath = (Instr(1, LCase(u), "/public/") > 0)
            if isDead and hasPublicPath and m.workingImageHosts <> invalid
                for each wh in m.workingImageHosts
                    if wh <> h
                        alt = RewriteUrlHost(u, wh)
                        if alt <> "" and seen[alt] = invalid
                            seen[alt] = true
                            out.Push(alt)
                        end if
                    end if
                end for
            end if
            if seen[u] = invalid
                seen[u] = true
                out.Push(u)
            end if
            if not isDead and hasPublicPath and m.workingImageHosts <> invalid
                for each wh in m.workingImageHosts
                    if wh <> h
                        alt = RewriteUrlHost(u, wh)
                        if alt <> "" and seen[alt] = invalid
                            seen[alt] = true
                            out.Push(alt)
                        end if
                    end if
                end for
            end if
        end if
    end for
    return out
end function

sub SetupPoster(p as Object, itemOrUri as Dynamic, w as Integer, h as Integer, displayMode as String)
    if p = invalid then return
    p.width = w
    p.height = h
    p.loadWidth = w
    p.loadHeight = h
    p.loadDisplayMode = displayMode
    rawUrls = []
    if GetInterface(itemOrUri, "ifString") <> invalid
        u = SafeStr(itemOrUri).Trim()
        if u <> "" then rawUrls.Push(u)
    else if itemOrUri <> invalid
        rawUrls = ImageUrlsForItem(itemOrUri)
    end if
    urls = ExpandPosterFallbacks(rawUrls)
    if urls.Count() = 0
        p.uri = ""
        return
    end if
    p.AddField("fallbackUrls", "stringarray", false)
    p.AddField("fallbackIdx", "integer", false)
    p.AddField("retried", "boolean", false)
    p.AddField("origHost", "string", false)
    p.fallbackUrls = urls
    p.fallbackIdx = 0
    p.retried = false
    p.origHost = UrlHost(rawUrls[0])
    p.ObserveField("loadStatus", "OnPosterLoadStatus")
    p.uri = urls[0]
end sub

sub OnPosterLoadStatus(event as Object)
    p = event.GetRoSGNode()
    if p = invalid then return
    st = SafeStr(event.GetData())
    if st = "ready"
        curHost = UrlHost(p.uri)
        if curHost <> "" and m.workingImageHostSet <> invalid and m.workingImageHostSet[curHost] = invalid
            m.workingImageHostSet[curHost] = true
            m.workingImageHosts.Push(curHost)
        end if
        if p.origHost <> "" and curHost <> "" and curHost <> p.origHost
            m.deadImageHosts[p.origHost] = true
        end if
        return
    end if
    if st <> "failed" then return
    urls = p.fallbackUrls
    if urls = invalid or urls.Count() = 0 then return
    nextIdx = p.fallbackIdx + 1
    if nextIdx < urls.Count()
        p.fallbackIdx = nextIdx
        p.uri = urls[nextIdx]
    else if not p.retried
        p.retried = true
        cur = SafeStr(urls[0])
        if cur <> ""
            p.uri = ""
            p.uri = cur
        end if
    end if
end sub

function ImageUrlsForItem(it as Object) as Object
    urls = []
    seen = {}
    if it = invalid then return urls
    for each field in ["showIconUrl", "posterUrl", "showPosterUrl", "poster", "image", "iconUrl", "icon", "coverUrl", "cover", "imageUrl", "backdropUrl", "backdrop", "landscapeUrl", "landscape", "wideImage", "bannerImage", "showBackdropUrl"]
        v = it[field]
        if v <> invalid and GetInterface(v, "ifString") <> invalid
            u = SafeStr(v).Trim()
            if u <> "" and seen[u] = invalid
                seen[u] = true
                urls.Push(u)
            end if
        end if
    end for
    if it.posterList <> invalid and it.posterList.Count() > 0
        icons = []
        others = []
        for each p in it.posterList
            if p <> invalid and p.fileUrl <> invalid
                u = SafeStr(p.fileUrl).Trim()
                if u <> "" and seen[u] = invalid
                    seen[u] = true
                    if LCase(SafeStr(p.fileType)) = "icon"
                        icons.Push(u)
                    else
                        others.Push(u)
                    end if
                end if
            end if
        end for
        for each u in icons : urls.Push(u) : end for
        for each u in others : urls.Push(u) : end for
    end if
    return urls
end function

function FirstImageUrl(it as Object) as String
    urls = ImageUrlsForItem(it)
    if urls.Count() > 0 then return urls[0]
    return ""
end function

function IsLocked(it as Object) as Boolean
    if it.isLock = true then return true
    if SafeStr(it.restricted) = "1" then return true
    return false
end function
function ItemCode(it as Object) as String
    if it.channelCode <> invalid then return SafeStr(it.channelCode)
    if it.contentId <> invalid then return SafeStr(it.contentId)
    if it.id <> invalid then return SafeStr(it.id)
    return ""
end function
function VodContentVersion(it as Object) as String
    for each key in ["contentVersion", "mediaVersion", "assetVersion", "updateTime", "modifyTime", "version"]
        value = SafeStr(it[key])
        if value <> "" then return value
    end for
    return ""
end function
function VodCodecKey(it as Object) as String
    id = ItemCode(it)
    if id = "" then return ""
    return id + "|" + VodContentVersion(it)
end function
function VodCodecForItem(it as Object) as String
    if it = invalid then return ""
    fromApi = Hardware_CodecFromMetadata(it)
    if fromApi <> "" then return fromApi
    key = VodCodecKey(it)
    if key <> "" and m.vodCodecCache[key] <> invalid then return SafeStr(m.vodCodecCache[key])
    id = ItemCode(it)
    if id <> "" and m.vodCodecCache[id] <> invalid then return SafeStr(m.vodCodecCache[id])
    return ""
end function
sub SaveVodCodec(key as String, itemId as String, codec as String)
    if codec = "" then return
    if key <> "" then m.vodCodecCache[key] = codec
    if itemId <> ""
        m.vodCodecCache[itemId] = codec
        CodecCache_Save(itemId, codec)
    end if
end sub
sub OnDetectedVideoCodec(event as Object)
    codec = Hardware_CodecLabel(event.GetData())
    if codec = "" then return
    itemId = ""
    if m.lastVodPlaybackItem <> invalid then itemId = ItemCode(m.lastVodPlaybackItem)
    SaveVodCodec(m.activeVodCodecKey, itemId, codec)
end sub

function IsVodFilterContext() as Boolean
    if m.NAV = invalid or m.navIdx < 0 or m.navIdx >= m.NAV.Count() then return false
    navId = m.NAV[m.navIdx].id
    return (IsVodSection(navId) or navId = "home" or navId = "search" or navId = "history")
end function

function VodFilterLabel() as String
    if m.vodFilter = "hide_hevc" then return "Ocultar HEVC"
    if m.vodFilter = "only_h264" then return "Solo H.264"
    return "Todas"
end function

sub CycleVodFilter()
    if m.vodFilter = "all"
        m.vodFilter = "hide_hevc"
    else if m.vodFilter = "hide_hevc"
        m.vodFilter = "only_h264"
    else
        m.vodFilter = "all"
    end if
    VodFilterPref_Save(m.vodFilter)
    m.vodAutoFetchCount = 0
    ApplyVodFilter(true)
    ShowUiNotice("Filtro: " + VodFilterLabel() + " (" + m.items.Count().ToStr() + " títulos)")
    RenderHeader() : RenderGrid()
    MaybeLoadMoreVod()
end sub

sub ApplyVodFilter(keepSelection as Boolean)
    if not IsVodFilterContext()
        m.items = m.rawItems
        m.gridState = Tern(m.items.Count() > 0, "ready", "empty")
        return
    end if
    prevId = ""
    if keepSelection and m.gridIdx >= 0 and m.gridIdx < m.items.Count()
        prevId = ItemCode(m.items[m.gridIdx])
    end if
    filtered = []
    for each it in m.rawItems
        c = VodCodecForItem(it)
        keep = true
        if m.vodFilter = "hide_hevc"
            if c = "H.265/HEVC" then keep = false
        else if m.vodFilter = "only_h264"
            if c <> "H.264/AVC" then keep = false
        end if
        if keep then filtered.Push(it)
    end for
    m.items = filtered
    if m.items.Count() = 0
        m.gridIdx = 0
        m.rowOffset = 0
        m.gridState = "empty"
    else
        m.gridState = "ready"
        newIdx = 0
        if prevId <> ""
            for j = 0 to m.items.Count() - 1
                if ItemCode(m.items[j]) = prevId
                    newIdx = j
                    exit for
                end if
            end for
        else if keepSelection and m.gridIdx >= 0
            newIdx = m.gridIdx
        end if
        if newIdx >= m.items.Count() then newIdx = m.items.Count() - 1
        m.gridIdx = newIdx
        EnsureRowVisible()
    end if
end sub

sub ScheduleGridCodecProbe()
    if m.codecProbeTimer <> invalid then m.codecProbeTimer.control = "stop"
    m.codecProbeTimer = CreateObject("roSGNode", "Timer")
    m.codecProbeTimer.duration = 0.65
    m.codecProbeTimer.repeat = false
    m.codecProbeTimer.ObserveField("fire", "OnGridCodecProbeTimer")
    m.codecProbeTimer.control = "start"
end sub

sub OnGridCodecProbeTimer(event as Object)
    if m.codecProbeTimer <> invalid then m.codecProbeTimer.control = "stop"
    m.codecProbeTimer = invalid
    if not IsVodFilterContext() or m.items.Count() = 0 then return
    cols = GRID_COLS()
    firstIdx = m.rowOffset * cols
    lastIdx = firstIdx + (VisRows() * cols) - 1
    if lastIdx > m.items.Count() - 1 then lastIdx = m.items.Count() - 1
    queue = []
    seenQ = {}
    ' 1) Prioridad: los visibles en pantalla ahora
    for i = firstIdx to lastIdx
        it = m.items[i]
        if VodCodecForItem(it) = ""
            cid = SafeStr(it.contentId)
            if cid <> "" and seenQ[cid] = invalid
                seenQ[cid] = true
                queue.Push({
                    key: VodCodecKey(it),
                    id: ItemCode(it),
                    contentId: cid,
                    seriesContentId: Tern(m.seriesMode, m.seriesContentId, ""),
                    columnId: Tern(m.seriesMode, 0, 87026),
                    isSeries: (not m.seriesMode and IsSeries(it))
                })
            end if
        end if
    end for
    ' 2) Segundo plano: hasta 20 titulos adicionales desconocidos de la lista cargada
    bgList = m.rawItems
    if bgList = invalid or bgList.Count() = 0 then bgList = m.items
    for each it in bgList
        if queue.Count() >= 30 then exit for
        if VodCodecForItem(it) = ""
            cid = SafeStr(it.contentId)
            if cid <> "" and seenQ[cid] = invalid
                seenQ[cid] = true
                queue.Push({
                    key: VodCodecKey(it),
                    id: ItemCode(it),
                    contentId: cid,
                    seriesContentId: Tern(m.seriesMode, m.seriesContentId, ""),
                    columnId: Tern(m.seriesMode, 0, 87026),
                    isSeries: (not m.seriesMode and IsSeries(it))
                })
            end if
        end if
    end for
    if queue.Count() > 0 then StartGridCodecProbe(queue)
end sub

sub StartGridCodecProbe(queue as Object)
    m.codecProbeGen = m.codecProbeGen + 1
    if m.codecProbeTask <> invalid
        m.codecProbeTask.UnobserveField("probeResult")
        m.codecProbeTask.UnobserveField("done")
        m.codecProbeTask.control = "STOP"
    end if
    t = CreateObject("roSGNode", "CodecProbeTask")
    if t = invalid then return
    t.generation = m.codecProbeGen
    t.items = queue
    t.ObserveField("probeResult", "OnCodecProbeResult")
    t.ObserveField("done", "OnGridCodecProbeDone")
    m.codecProbeTask = t
    t.control = "RUN"
end sub

sub OnGridCodecProbeDone(event as Object)
    src = event.GetRoSGNode()
    if src = invalid or src.generation <> m.codecProbeGen then return
    if event.GetData() <> true then return
    if not IsVodFilterContext() then return
    if m.vodFilter <> "all"
        ApplyVodFilter(true)
        RenderHeader() : RenderGrid()
    end if
    bgList = m.rawItems
    if bgList = invalid or bgList.Count() = 0 then bgList = m.items
    hasPending = false
    for each it in bgList
        if VodCodecForItem(it) = "" and SafeStr(it.contentId) <> ""
            hasPending = true
            exit for
        end if
    end for
    if hasPending
        ScheduleGridCodecProbe()
    end if
end sub

sub ProbeDetailItemCodec(item as Object, seriesMode = false as Boolean, seriesId = "" as String)
    if item = invalid then return
    if VodCodecForItem(item) <> "" then return
    cid = SafeStr(item.contentId)
    if cid = "" then return
    m.detailProbeGen = m.detailProbeGen + 1
    if m.detailProbeTask <> invalid
        m.detailProbeTask.UnobserveField("probeResult")
        m.detailProbeTask.control = "STOP"
    end if
    t = CreateObject("roSGNode", "CodecProbeTask")
    if t = invalid then return
    t.generation = m.detailProbeGen
    t.items = [{
        key: VodCodecKey(item),
        id: ItemCode(item),
        contentId: cid,
        seriesContentId: Tern(seriesMode, seriesId, ""),
        columnId: Tern(seriesMode, 0, 87026),
        isSeries: (not seriesMode and IsSeries(item))
    }]
    t.ObserveField("probeResult", "OnDetailCodecProbeResult")
    m.detailProbeTask = t
    t.control = "RUN"
end sub

sub OnCodecProbeResult(event as Object)
    res = event.GetData()
    if res = invalid or res.generation <> m.codecProbeGen then return
    codec = SafeStr(res.codec)
    if codec = "" then return
    SaveVodCodec(SafeStr(res.key), SafeStr(res.id), codec)
    if m.renderedTiles <> invalid
        for each rt in m.renderedTiles
            if rt.code = SafeStr(res.id) or rt.key = SafeStr(res.key)
                ApplyTileCodecBadge(rt.codecBg, rt.codecLbl, codec)
            end if
        end for
    end if
    if m.vodDetailMode <> "" and m.vodDetailItem <> invalid and ItemCode(m.vodDetailItem) = SafeStr(res.id)
        RenderVodDetail()
    end if
end sub

sub OnDetailCodecProbeResult(event as Object)
    res = event.GetData()
    if res = invalid or res.generation <> m.detailProbeGen then return
    codec = SafeStr(res.codec)
    if codec = "" then return
    SaveVodCodec(SafeStr(res.key), SafeStr(res.id), codec)
    if m.renderedTiles <> invalid
        for each rt in m.renderedTiles
            if rt.code = SafeStr(res.id) or rt.key = SafeStr(res.key)
                ApplyTileCodecBadge(rt.codecBg, rt.codecLbl, codec)
            end if
        end for
    end if
    if m.vodDetailMode <> ""
        RenderVodDetail()
    end if
end sub
sub OnDetectedAudioFormat(event as Object)
    audio = SafeStr(event.GetData())
    if audio = "" or m.activeVodCodecKey = "" then return
    m.vodAudioCache[m.activeVodCodecKey] = audio
end sub
function VodAudioForItem(it as Object, data as Dynamic) as String
    fromApi = VodTextValue(data, it, ["audioCodec", "audioFormat", "audio_codec", "soundFormat"])
    if fromApi <> "" then return fromApi
    key = VodCodecKey(it)
    if key <> "" and m.vodAudioCache[key] <> invalid then return SafeStr(m.vodAudioCache[key])
    return ""
end function
function VodRawValue(primary as Dynamic, secondary as Dynamic, keys as Object) as Dynamic
    for each source in [primary, secondary]
        if source <> invalid
            for each key in keys
                value = source[key]
                if value <> invalid
                    if GetInterface(value, "ifArray") <> invalid then return value
                    if SafeStr(value) <> "" then return value
                end if
            end for
        end if
    end for
    return invalid
end function
function VodTextValue(primary as Dynamic, secondary as Dynamic, keys as Object) as String
    value = VodRawValue(primary, secondary, keys)
    if value = invalid then return ""
    if GetInterface(value, "ifArray") <> invalid
        out = ""
        for each part in value
            text = SafeStr(part)
            if text <> ""
                if out <> "" then out = out + " · "
                out = out + text
            end if
        end for
        return out
    end if
    return SafeStr(value)
end function
function VodSynopsis(item as Object, data as Dynamic) as String
    return VodTextValue(data, item, ["synopsis", "summary", "description", "introduce", "introduction", "plot", "programDesc"])
end function
function VodSecondaryLine(item as Object, data as Dynamic) as String
    out = ""
    year = VodTextValue(data, item, ["releaseYear", "year", "premiereYear", "publishYear"])
    genre = VodTextValue(data, item, ["genres", "genre", "genreName", "categoryName"])
    duration = VodTextValue(data, item, ["duration", "timeLen", "totalTime", "playTime", "length"])
    for each value in [year, genre, duration]
        if value <> ""
            if out <> "" then out = out + "  ·  "
            out = out + value
        end if
    end for
    return out
end function
function AddVodTag(root as Object, text as String, x as Integer, y as Integer, bgColor = "0x132444FF" as String, txtColor = "0xE8EAF0FF" as String) as Integer
    if text = "" then return x
    width = TextW(text, 15) + 36
    if width < 92 then width = 92
    bg = root.CreateChild("Poster")
    bg.uri = "pkg:/images/ui/badge_pill.9.png"
    bg.translation = [x, y] : bg.width = width : bg.height = 38 : bg.blendColor = bgColor
    label = root.CreateChild("Label")
    label.translation = [x, y] : label.width = width : label.height = 38
    label.text = text : label.font = ThemeFont(15, true) : label.color = txtColor
    label.horizAlign = "center" : label.vertAlign = "center"
    return x + width + 12
end function
sub AddVodTechnicalTags(root as Object, item as Object, data as Dynamic, x as Integer, y as Integer)
    codec = Hardware_CodecFromMetadata(data)
    if codec = "" then codec = VodCodecForItem(item)
    resolution = VodTextValue(data, item, ["resolution", "videoResolution", "definition", "quality"])
    audio = VodAudioForItem(item, data)
    duration = VodTextValue(data, item, ["duration", "timeLen", "totalTime", "playTime", "length"])
    hevcSupported = (m.top.hardwareInfo <> invalid and m.top.hardwareInfo.hevc = true)
    if codec = "H.264/AVC"
        x = AddVodTag(root, "H.264/AVC · Compatible ✓", x, y, "0x0A3628FF", "0x34D399FF")
    else if codec = "H.265/HEVC"
        if hevcSupported
            x = AddVodTag(root, "H.265/HEVC · Compatible ✓", x, y, "0x0A3628FF", "0x34D399FF")
        else
            x = AddVodTag(root, "H.265/HEVC · Solo Roku 4K ✕", x, y, "0x45121CFF", "0xFF6B7DFF")
        end if
    else if codec <> ""
        x = AddVodTag(root, codec, x, y)
    else if m.vodDetailMode = "movie" or m.vodDetailMode = "episode"
        x = AddVodTag(root, "Verificando códec...", x, y, "0x152342FF", "0x94A3B8FF")
    end if
    x = AddVodTag(root, resolution, x, y)
    x = AddVodTag(root, audio, x, y)
    x = AddVodTag(root, duration, x, y)
end sub
function EpisodeSeasonKey(ep as Object) as String
    return VodTextValue(ep, invalid, ["seasonNumber", "season", "seasonNum", "seasonNo", "seriesNo"])
end function
function EpisodeNumberText(ep as Object) as String
    return VodTextValue(ep, invalid, ["episodeNumber", "episode", "episodeNum", "episodeNo", "seriesEpisode"])
end function
sub BuildVodSeasons(episodes as Object)
    groups = []
    positions = {}
    for each ep in episodes
        key = EpisodeSeasonKey(ep)
        mapKey = key
        if mapKey = "" then mapKey = "__episodes"
        idxValue = positions[mapKey]
        if idxValue = invalid
            label = "Episodios"
            if key <> "" then label = "Temporada " + key
            groups.Push({ key: key, name: label, episodes: [] })
            idxValue = groups.Count() - 1
            positions[mapKey] = idxValue
        end if
        groups[idxValue].episodes.Push(ep)
    end for
    m.vodDetailSeasons = groups
    if m.vodDetailSeasonIdx >= groups.Count() then m.vodDetailSeasonIdx = 0
    m.vodDetailEpisodeIdx = 0
end sub
sub OpenVodDetail(item as Object)
    m.vodDetailItem = item
    m.vodDetailData = invalid
    m.vodDetailSeries = invalid
    m.vodDetailSeriesData = invalid
    m.vodDetailEpisodes = []
    m.vodDetailSeasons = []
    m.vodDetailSeasonIdx = 0
    m.vodDetailEpisodeIdx = 0
    m.vodDetailRetried = false
    m.vodDetailMode = Tern(IsSeries(item), "series", "movie")
    if m.vodDetailMode = "series" then m.vodDetailSeries = item
    m.vodDetailRegion = Tern(m.vodDetailMode = "series", "seasons", "play")
    m.vodDetailLoading = true
    m.content.visible = false
    m.rail.visible = false
    m.vodDetailOverlay.visible = true
    RenderVodDetail()
    ProbeDetailItemCodec(item, false, "")
    if m.detailTask <> invalid then m.detailTask.control = "STOP"
    m.detailTask = Api_OpTask("itemData", { contentId: SafeStr(item.contentId) })
    if m.detailTask = invalid
        m.vodDetailLoading = false
        RenderVodDetail()
        return
    end if
    m.detailTask.ObserveField("rawResp", "OnVodDetailResp")
    m.detailTask.ObserveField("error", "OnVodDetailError")
    m.detailTask.control = "RUN"
end sub
sub OnVodDetailResp(event as Object)
    data = Api_ParseOp(event.GetData())
    if data <> invalid
        ad = data.assetData
        if ad = invalid then ad = data
        m.vodDetailData = ad
        if m.vodDetailMode = "series" and ad.simpleProgramList <> invalid
            m.vodDetailSeriesData = ad
            m.vodDetailEpisodes = ad.simpleProgramList
            for each ep in m.vodDetailEpisodes
                if FirstImageUrl(ep) = "" then ep.posterUrl = FirstImageUrl(m.vodDetailSeries)
            end for
            BuildVodSeasons(m.vodDetailEpisodes)
        end if
    end if
    m.vodDetailLoading = false
    RenderVodDetail()
end sub
sub OnVodDetailError(event as Object)
    if m.vodDetailRetried <> true and m.vodDetailItem <> invalid and m.vodDetailMode <> ""
        m.vodDetailRetried = true
        if m.detailTask <> invalid then m.detailTask.control = "STOP"
        m.detailTask = Api_OpTask("itemData", { contentId: SafeStr(m.vodDetailItem.contentId) })
        if m.detailTask <> invalid
            m.detailTask.ObserveField("rawResp", "OnVodDetailResp")
            m.detailTask.ObserveField("error", "OnVodDetailError")
            m.detailTask.control = "RUN"
            return
        end if
    end if
    m.vodDetailLoading = false
    RenderVodDetail()
end sub
sub CloseVodDetail()
    if m.detailTask <> invalid then m.detailTask.control = "STOP"
    m.detailTask = invalid
    if m.detailProbeTask <> invalid
        m.detailProbeTask.UnobserveField("probeResult")
        m.detailProbeTask.control = "STOP"
        m.detailProbeTask = invalid
    end if
    m.vodDetailMode = ""
    m.vodDetailOverlay.visible = false
    m.vodDetailOverlay.RemoveChildren(m.vodDetailOverlay.GetChildren(-1, 0))
    m.seriesMode = false
    m.seriesContentId = ""
    m.content.visible = true
    m.rail.visible = true
    m.top.SetFocus(true)
end sub
sub RenderVodDetail()
    g = m.vodDetailOverlay
    g.RemoveChildren(g.GetChildren(-1, 0))
    if m.vodDetailMode = "" then g.visible = false : return
    g.visible = true
    bg = g.CreateChild("Rectangle")
    bg.width = 1920 : bg.height = 1080 : bg.color = "0x040814FF"
    card = g.CreateChild("Poster")
    card.uri = "pkg:/images/ui/card_white.9.png"
    card.translation = [64, 54] : card.width = 1792 : card.height = 972 : card.blendColor = "0x0A1326FF"
    if m.vodDetailMode = "series"
        RenderVodSeriesDetail(g)
    else
        RenderVodPlayableDetail(g)
    end if
    if m.vodErrorActive then RenderVodErrorPanel(g)
end sub
sub RenderVodErrorPanel(g as Object)
    help = Help_Get(m.vodErrorCode)
    shade = g.CreateChild("Rectangle")
    shade.width = 1920 : shade.height = 1080 : shade.color = "0x00000099"
    panel = g.CreateChild("Rectangle")
    panel.translation = [350, 220] : panel.width = 1220 : panel.height = 680
    panel.color = "0x0B152AFF"
    accent = g.CreateChild("Rectangle")
    accent.translation = [350, 220] : accent.width = 8 : accent.height = 680
    accent.color = THEME_ACCENT()
    warningBg = g.CreateChild("Rectangle")
    warningBg.translation = [410, 252] : warningBg.width = 46 : warningBg.height = 46
    warningBg.color = THEME_ACCENT()
    warning = g.CreateChild("Label")
    warning.translation = [410, 252] : warning.width = 46 : warning.height = 46
    warning.text = "!" : warning.font = ThemeFont(29, true) : warning.color = "0xFFFFFFFF"
    warning.horizAlign = "center" : warning.vertAlign = "center"
    brandIcon = g.CreateChild("Poster")
    brandIcon.translation = [1408, 240]
    brandIcon.width = 128 : brandIcon.height = 80
    brandIcon.uri = "pkg:/images/brand_rail.png"
    brandIcon.loadDisplayMode = "scaleToFit"
    title = g.CreateChild("Label")
    title.translation = [480, 248] : title.width = 920 : title.height = 58
    title.text = "Error de reproducción"
    title.font = ThemeFont(31, true) : title.color = THEME_TEXT()
    errorName = g.CreateChild("Label")
    errorName.translation = [430, 326] : errorName.width = 1060 : errorName.height = 42
    errorName.text = SafeStr(help.title)
    errorName.font = ThemeFont(24, true) : errorName.color = THEME_TEXT()
    message = g.CreateChild("Label")
    message.translation = [430, 374] : message.width = 1060 : message.height = 70
    message.text = SafeStr(help.description)
    message.font = ThemeFont(18, false) : message.color = THEME_MUTED()
    message.wrap = true : message.maxLines = 2
    codeBg = g.CreateChild("Rectangle")
    codeBg.translation = [430, 454] : codeBg.width = 148 : codeBg.height = 36
    codeBg.color = "0x2A2E39FF"
    codeLabel = g.CreateChild("Label")
    codeLabel.translation = [430, 454] : codeLabel.width = 148 : codeLabel.height = 36
    codeLabel.text = SafeStr(help.code) : codeLabel.font = ThemeFont(16, true)
    codeLabel.color = "0xFFFFFFFF" : codeLabel.horizAlign = "center" : codeLabel.vertAlign = "center"
    localHelpBg = g.CreateChild("Rectangle")
    localHelpBg.translation = [430, 510] : localHelpBg.width = 1060 : localHelpBg.height = 190
    localHelpBg.color = "0x101E38FF"
    causeTitle = g.CreateChild("Label")
    causeTitle.translation = [458, 524] : causeTitle.width = 1004 : causeTitle.height = 30
    causeTitle.text = "POSIBLE CAUSA"
    causeTitle.font = ThemeFont(16, true) : causeTitle.color = THEME_ACCENT()
    causeText = g.CreateChild("Label")
    causeText.translation = [458, 554] : causeText.width = 1004 : causeText.height = 48
    causeText.text = SafeStr(help.cause)
    causeText.font = ThemeFont(17, false) : causeText.color = "0xCDD1DAFF"
    causeText.wrap = true : causeText.maxLines = 2
    actionTitle = g.CreateChild("Label")
    actionTitle.translation = [458, 610] : actionTitle.width = 1004 : actionTitle.height = 30
    actionTitle.text = "QUÉ HACER"
    actionTitle.font = ThemeFont(16, true) : actionTitle.color = THEME_ACCENT()
    actionText = g.CreateChild("Label")
    actionText.translation = [458, 640] : actionText.width = 1004 : actionText.height = 48
    actionText.text = SafeStr(help.action)
    actionText.font = ThemeFont(17, false) : actionText.color = "0xCDD1DAFF"
    actionText.wrap = true : actionText.maxLines = 2
    retryBg = g.CreateChild("Rectangle")
    retryBg.translation = [430, 754] : retryBg.width = 350 : retryBg.height = 68
    retryBg.color = Tern(m.vodErrorChoice = 0, THEME_ACCENT(), "0x152544FF")
    retry = g.CreateChild("Label")
    retry.translation = [430, 754] : retry.width = 350 : retry.height = 68
    retry.text = "Reintentar" : retry.font = ThemeFont(22, true) : retry.color = "0xFFFFFFFF"
    retry.horizAlign = "center" : retry.vertAlign = "center"
    backBg = g.CreateChild("Rectangle")
    backBg.translation = [810, 754] : backBg.width = 470 : backBg.height = 68
    backBg.color = Tern(m.vodErrorChoice = 1, THEME_ACCENT(), "0x152544FF")
    back = g.CreateChild("Label")
    back.translation = [810, 754] : back.width = 470 : back.height = 68
    back.text = "Volver a detalles" : back.font = ThemeFont(22, true) : back.color = "0xFFFFFFFF"
    back.horizAlign = "center" : back.vertAlign = "center"
    hint = g.CreateChild("Label")
    hint.translation = [430, 844] : hint.width = 1060 : hint.height = 30
    hint.text = "◀ ▶ Elegir  ·  OK Confirmar  ·  Atrás Volver a detalles"
    hint.font = ThemeFont(16, false) : hint.color = THEME_MUTED()
end sub
sub RenderVodPlayableDetail(g as Object)
    item = m.vodDetailItem
    data = m.vodDetailData
    poster = g.CreateChild("Poster")
    poster.translation = [104, 92]
    SetupPoster(poster, item, 400, 600, "scaleToFill")
    title = g.CreateChild("Label")
    title.translation = [560, 104] : title.width = 1190 : title.height = 76
    title.text = SafeStr(item.name) : title.font = ThemeFont(42, true) : title.color = THEME_TEXT()
    title.ellipsisText = "..."
    meta = g.CreateChild("Label")
    meta.translation = [560, 180] : meta.width = 1190 : meta.height = 38
    meta.text = VodSecondaryLine(item, data) : meta.font = ThemeFont(19, false) : meta.color = THEME_MUTED()
    synopsis = g.CreateChild("Label")
    synopsis.translation = [560, 238] : synopsis.width = 1190 : synopsis.height = 300
    synopsis.text = VodSynopsis(item, data)
    if synopsis.text = "" then synopsis.text = "Sin sinopsis disponible."
    synopsis.font = ThemeFont(20, false) : synopsis.color = "0xD5D8E0FF"
    synopsis.wrap = true : synopsis.maxLines = 10
    AddVodTechnicalTags(g, item, data, 560, 570)
    if m.vodDetailMode = "episode"
        ep = EpisodeNumberText(item) : season = EpisodeSeasonKey(item)
        episodeLine = ""
        if season <> "" then episodeLine = "Temporada " + season
        if ep <> ""
            if episodeLine <> "" then episodeLine = episodeLine + "  ·  "
            episodeLine = episodeLine + "Episodio " + ep
        end if
        info = g.CreateChild("Label")
        info.translation = [560, 650] : info.width = 1000 : info.height = 42
        info.text = episodeLine : info.font = ThemeFont(20, true) : info.color = THEME_MUTED()
    end if
    playBg = g.CreateChild("Poster")
    playBg.uri = "pkg:/images/ui/pill_white.9.png"
    playBg.translation = [560, 820] : playBg.width = 340 : playBg.height = 72
    playBg.blendColor = Tern(m.vodDetailRegion = "play", THEME_ACCENT(), "0x152544FF")
    playIc = g.CreateChild("Poster")
    playIc.uri = "pkg:/images/ui/play.png"
    playIc.translation = [632, 842] : playIc.width = 28 : playIc.height = 28
    playIc.loadWidth = 28 : playIc.loadHeight = 28 : playIc.loadDisplayMode = "scaleToFit"
    play = g.CreateChild("Label")
    play.translation = [664, 820] : play.width = 210 : play.height = 72
    play.text = "Reproducir" : play.font = ThemeFont(24, true) : play.color = "0xFFFFFFFF"
    play.horizAlign = "center" : play.vertAlign = "center"
    hint = g.CreateChild("Label")
    hint.translation = [560, 922] : hint.width = 900 : hint.height = 34
    hint.text = "OK Reproducir  ·  Atrás Regresar" : hint.font = ThemeFont(16, false) : hint.color = THEME_MUTED()
end sub
sub RenderVodSeriesDetail(g as Object)
    item = m.vodDetailSeries
    data = m.vodDetailData
    poster = g.CreateChild("Poster")
    poster.translation = [104, 92]
    SetupPoster(poster, item, 260, 390, "scaleToFill")
    title = g.CreateChild("Label")
    title.translation = [410, 96] : title.width = 1340 : title.height = 68
    title.text = SafeStr(item.name) : title.font = ThemeFont(38, true) : title.color = THEME_TEXT()
    meta = g.CreateChild("Label")
    meta.translation = [410, 164] : meta.width = 1340 : meta.height = 34
    meta.text = VodSecondaryLine(item, data) : meta.font = ThemeFont(18, false) : meta.color = THEME_MUTED()
    synopsis = g.CreateChild("Label")
    synopsis.translation = [410, 212] : synopsis.width = 1340 : synopsis.height = 190
    synopsis.text = VodSynopsis(item, data)
    if synopsis.text = "" then synopsis.text = "Sin sinopsis disponible."
    synopsis.font = ThemeFont(19, false) : synopsis.color = "0xD5D8E0FF"
    synopsis.wrap = true : synopsis.maxLines = 6
    AddVodTechnicalTags(g, item, data, 410, 420)
    seasonsTitle = g.CreateChild("Label")
    seasonsTitle.translation = [104, 520] : seasonsTitle.width = 330 : seasonsTitle.height = 40
    seasonsTitle.text = "TEMPORADAS" : seasonsTitle.font = ThemeFont(20, true) : seasonsTitle.color = THEME_TEXT()
    episodesTitle = g.CreateChild("Label")
    episodesTitle.translation = [470, 520] : episodesTitle.width = 1240 : episodesTitle.height = 40
    episodesTitle.text = "EPISODIOS" : episodesTitle.font = ThemeFont(20, true) : episodesTitle.color = THEME_TEXT()
    if m.vodDetailLoading
        loading = g.CreateChild("Label")
        loading.translation = [104, 590] : loading.width = 900 : loading.height = 48
        loading.text = "Cargando información..." : loading.font = ThemeFont(20, false) : loading.color = THEME_MUTED()
        return
    end if
    if m.vodDetailSeasons.Count() = 0
        empty = g.CreateChild("Label")
        empty.translation = [104, 590] : empty.width = 1100 : empty.height = 48
        empty.text = "No se recibieron episodios para esta serie." : empty.font = ThemeFont(20, false) : empty.color = THEME_MUTED()
        return
    end if
    firstSeason = m.vodDetailSeasonIdx - 3
    if firstSeason < 0 then firstSeason = 0
    lastSeason = firstSeason + 6
    if lastSeason >= m.vodDetailSeasons.Count() then lastSeason = m.vodDetailSeasons.Count() - 1
    for i = firstSeason to lastSeason
        row = g.CreateChild("Poster")
        row.uri = "pkg:/images/ui/pill_white.9.png"
        row.translation = [104, 570 + (i - firstSeason) * 58] : row.width = 320 : row.height = 50
        focused = (m.vodDetailRegion = "seasons" and i = m.vodDetailSeasonIdx)
        row.blendColor = Tern(focused, THEME_ACCENT(), Tern(i = m.vodDetailSeasonIdx, "0x14305CFF", "0x0E1B34FF"))
        label = g.CreateChild("Label")
        label.translation = [122, 570 + (i - firstSeason) * 58] : label.width = 282 : label.height = 50
        label.text = SafeStr(m.vodDetailSeasons[i].name) : label.font = ThemeFont(17, focused) : label.color = "0xFFFFFFFF"
        label.vertAlign = "center" : label.ellipsisText = "..."
    end for
    eps = m.vodDetailSeasons[m.vodDetailSeasonIdx].episodes
    if m.vodDetailEpisodeIdx >= eps.Count() then m.vodDetailEpisodeIdx = 0
    firstEp = m.vodDetailEpisodeIdx - 3
    if firstEp < 0 then firstEp = 0
    lastEp = firstEp + 5
    if lastEp >= eps.Count() then lastEp = eps.Count() - 1
    for i = firstEp to lastEp
        ep = eps[i]
        y = 570 + (i - firstEp) * 70
        row = g.CreateChild("Poster")
        row.uri = "pkg:/images/ui/card_white.9.png"
        row.translation = [470, y] : row.width = 1240 : row.height = 62
        focused = (m.vodDetailRegion = "episodes" and i = m.vodDetailEpisodeIdx)
        row.blendColor = Tern(focused, THEME_ACCENT(), "0x0E1B34FF")
        thumb = g.CreateChild("Poster")
        thumb.translation = [482, y + 6]
        SetupPoster(thumb, ep, 86, 50, "scaleToFill")
        epNo = EpisodeNumberText(ep)
        epName = SafeStr(ep.name)
        if epNo <> "" then epName = "E" + epNo + "  ·  " + epName
        label = g.CreateChild("Label")
        label.translation = [586, y] : label.width = 820 : label.height = 62
        label.text = epName : label.font = ThemeFont(17, focused) : label.color = "0xFFFFFFFF"
        label.vertAlign = "center" : label.ellipsisText = "..."
        codec = VodCodecForItem(ep)
        if codec <> ""
            tag = g.CreateChild("Label")
            tag.translation = [1430, y] : tag.width = 250 : tag.height = 62
            tag.text = codec : tag.font = ThemeFont(14, true) : tag.color = "0xD8DBE4FF"
            tag.horizAlign = "right" : tag.vertAlign = "center"
        end if
    end for
end sub
sub OpenVodEpisodeDetail(ep as Object)
    m.vodDetailSeriesData = m.vodDetailData
    m.vodDetailItem = ep
    m.vodDetailData = ep
    m.vodDetailMode = "episode"
    m.vodDetailRegion = "play"
    RenderVodDetail()
    seriesId = ""
    if m.vodDetailSeries <> invalid then seriesId = SafeStr(m.vodDetailSeries.contentId)
    ProbeDetailItemCodec(ep, true, seriesId)
end sub
sub ReturnToVodSeriesDetail()
    m.vodDetailMode = "series"
    m.vodDetailItem = m.vodDetailSeries
    m.vodDetailData = m.vodDetailSeriesData
    m.vodDetailRegion = "episodes"
    RenderVodDetail()
end sub
sub StartVodDetailPlayback()
    it = m.vodDetailItem
    seriesPlayback = (m.vodDetailMode = "episode")
    seriesId = ""
    if seriesPlayback and m.vodDetailSeries <> invalid then seriesId = SafeStr(m.vodDetailSeries.contentId)
    m.vodDetailOverlay.visible = false
    StartVodPlayback(it, seriesPlayback, seriesId)
end sub
sub PlayVodDetail()
    codec = VodCodecForItem(m.vodDetailItem)
    supported = Hardware_CodecSupported(m.top.hardwareInfo, codec)
    if codec <> "" and supported = false and PcBridge_LoadHost() = ""
        dlg = CreateObject("roSGNode", "StandardMessageDialog")
        dlg.title = "Compatibilidad de video"
        dlg.message = [codec + " está confirmado para este contenido, pero este Roku informó que no puede decodificarlo."]
        dlg.buttons = ["Intentar reproducir", "Cancelar"]
        m.vodDetailWarning = dlg
        dlg.ObserveField("buttonSelected", "OnVodDetailWarning")
        m.top.GetScene().dialog = dlg
        return
    end if
    StartVodDetailPlayback()
end sub
sub OnVodDetailWarning(event as Object)
    if event.GetData() = 0 then StartVodDetailPlayback()
    if m.vodDetailWarning <> invalid then m.vodDetailWarning.UnobserveField("buttonSelected")
    m.vodDetailWarning = invalid
end sub
function HandleVodDetailKey(key as String) as Boolean
    if m.vodErrorActive then return HandleVodErrorKey(key)
    if m.vodDetailMode = "movie" or m.vodDetailMode = "episode"
        if key = "OK" or key = "play"
            PlayVodDetail()
        else if key = "back"
            if m.vodDetailMode = "episode" then ReturnToVodSeriesDetail() else CloseVodDetail()
        end if
        return true
    end if
    if m.vodDetailMode <> "series" then return false
    if key = "back"
        CloseVodDetail()
        return true
    end if
    if m.vodDetailSeasons.Count() = 0 then return true
    if key = "left"
        m.vodDetailRegion = "seasons"
    else if key = "right"
        m.vodDetailRegion = "episodes"
    else if key = "up"
        if m.vodDetailRegion = "seasons" and m.vodDetailSeasonIdx > 0
            m.vodDetailSeasonIdx = m.vodDetailSeasonIdx - 1 : m.vodDetailEpisodeIdx = 0
        else if m.vodDetailRegion = "episodes" and m.vodDetailEpisodeIdx > 0
            m.vodDetailEpisodeIdx = m.vodDetailEpisodeIdx - 1
        end if
    else if key = "down"
        if m.vodDetailRegion = "seasons" and m.vodDetailSeasonIdx < m.vodDetailSeasons.Count() - 1
            m.vodDetailSeasonIdx = m.vodDetailSeasonIdx + 1 : m.vodDetailEpisodeIdx = 0
        else if m.vodDetailRegion = "episodes"
            eps = m.vodDetailSeasons[m.vodDetailSeasonIdx].episodes
            if m.vodDetailEpisodeIdx < eps.Count() - 1 then m.vodDetailEpisodeIdx = m.vodDetailEpisodeIdx + 1
        end if
    else if key = "OK"
        if m.vodDetailRegion = "seasons"
            m.vodDetailRegion = "episodes"
            m.vodDetailEpisodeIdx = 0
        else
            eps = m.vodDetailSeasons[m.vodDetailSeasonIdx].episodes
            if m.vodDetailEpisodeIdx >= 0 and m.vodDetailEpisodeIdx < eps.Count()
                OpenVodEpisodeDetail(eps[m.vodDetailEpisodeIdx])
                return true
            end if
        end if
    end if
    RenderVodDetail()
    return true
end function
function HandleVodErrorKey(key as String) as Boolean
    if key = "left" or key = "right" or key = "up" or key = "down"
        m.vodErrorChoice = 1 - m.vodErrorChoice
        RenderVodDetail()
    else if key = "OK" or key = "play"
        if m.vodErrorChoice = 0
            m.vodErrorActive = false
            StartVodPlayback(m.lastVodPlaybackItem, m.lastVodPlaybackSeriesMode, m.lastVodPlaybackSeriesId)
        else
            m.vodErrorActive = false
            CloseVodDetail()
        end if
    else if key = "back"
        m.vodErrorActive = false
        RenderVodDetail()
        m.top.SetFocus(true)
    end if
    return true
end function
function IsSeries(it as Object) as Boolean
    return LCase(SafeStr(it.programType)) = "teleplay"
end function
sub OpenSeries(it as Object)
    m.savedGrid = { items: m.items, rawItems: m.rawItems, gridIdx: m.gridIdx, rowOffset: m.rowOffset, title: m.sectionTitle.text }
    m.seriesContentId = SafeStr(it.contentId)
    m.seriesPoster    = FirstImageUrl(it)
    m.seriesMode      = true
    m.gridIdx   = 0
    m.rowOffset = 0
    m.gridState = "loading"
    m.sectionTitle.text = SafeStr(it.name)
    RenderHeader() : RenderGrid()
    if m.itemTask <> invalid then m.itemTask.control = "STOP"
    m.itemTask = Api_OpTask("itemData", { contentId: m.seriesContentId })
    if m.itemTask = invalid
        SetGridError("itemData", "operación ausente en kit") : return
    end if
    m.itemTask.ObserveField("rawResp", "OnEpisodesResp")
    m.itemTask.ObserveField("error",   "OnItemsError")
    m.itemTask.control = "RUN"
end sub
sub OnEpisodesResp(event as Object)
    data = Api_ParseOp(event.GetData())
    eps = []
    if data <> invalid
        ad = data.assetData
        if ad = invalid then ad = data
        if ad.simpleProgramList <> invalid then eps = ad.simpleProgramList
    end if
    for each e in eps
        if FirstImageUrl(e) = "" then e.posterUrl = m.seriesPoster
    end for
    m.rawItems  = eps
    m.gridIdx   = 0
    m.rowOffset = 0
    ApplyVodFilter(false)
    RenderHeader() : RenderGrid()
end sub
sub ExitSeries()
    m.seriesMode      = false
    m.seriesContentId = ""
    if m.savedGrid <> invalid
        m.rawItems  = m.savedGrid.rawItems
        m.items     = m.savedGrid.items
        m.gridIdx   = m.savedGrid.gridIdx
        m.rowOffset = m.savedGrid.rowOffset
        m.sectionTitle.text = m.savedGrid.title
        m.savedGrid = invalid
        ApplyVodFilter(true)
    end if
    m.gridState = Tern(m.items.Count() > 0, "ready", "empty")
    RenderHeader() : RenderGrid()
end sub
sub OpenItem(idx as Integer)
    if idx < 0 or idx >= m.items.Count() then return
    it = m.items[idx]
    nav = m.NAV[m.navIdx]
    vodContext = IsVodSection(nav.id) or nav.id = "search"
    if nav.id = "history" then vodContext = SafeStr(it._historyKind) = "vod"
    if vodContext and not CanPlayVod()
        m.gridState = "nohevc"
        RenderGrid()
        return
    end if
    if vodContext and not m.seriesMode
        OpenVodDetail(it)
        return
    end if
    if vodContext
        codec = VodCodecForItem(it)
        codecKey = VodCodecKey(it)
        supported = Hardware_CodecSupported(m.top.hardwareInfo, codec)
        if codec <> "" and supported = false and m.codecWarningAcceptedKey <> codecKey and PcBridge_LoadHost() = ""
            ShowCodecWarning(idx, codec, codecKey)
            return
        end if
    end if
    if IsLocked(it) and not m.adultUnlocked
        m.adultPendingIdx = idx
        if not v4a10()
            PinShowCreate()   ' primera vez: crear PIN
        else
            PinShowVerify()   ' ya tiene PIN: verificar
        end if
        return
    end if
    DoOpenItem(idx)
end sub
sub DoOpenItem(idx as Integer)
    if idx < 0 or idx >= m.items.Count() then return
    it = m.items[idx]
    nav = m.NAV[m.navIdx]
    vodContext = IsVodSection(nav.id) or nav.id = "search"
    if nav.id = "history" then vodContext = SafeStr(it._historyKind) = "vod"
    if not vodContext
        if not IsLiveSection(nav.id)
            PlayLiveItem(idx, true)
            return
        end if
        samePlaying = (m.player.visible and not m.liveFullscreen and SafeStr(m.player.channelCode) <> "" and SafeStr(m.player.channelCode) = SafeStr(it.channelCode))
        if samePlaying
            m.liveFullscreen = true
            m.fullPanelMode = ""
            m.fullPanelFavFocus = false
            m.fullPanelWaiting = false
            m.content.visible = false
            m.rail.visible = false
            m.liveCatOverlay.visible = false
            m.player.displayMode = "fullscreen"
            m.player.poke = true
        else
            PlayLiveItem(idx, false)
            RenderGrid()
        end if
        return
    end if
    seriesMode = m.seriesMode
    seriesId = m.seriesContentId
    if nav.id = "history"
        seriesMode = (it._historySeriesMode = true)
        seriesId = SafeStr(it._historySeriesContentId)
    end if
    StartVodPlayback(it, seriesMode, seriesId)
end sub
sub StartVodPlayback(it as Object, seriesMode as Boolean, seriesId as String)
    m.lastVodPlaybackItem = it
    m.lastVodPlaybackSeriesMode = seriesMode
    m.lastVodPlaybackSeriesId = seriesId
    m.vodErrorActive = false
    m.seriesMode = seriesMode
    m.seriesContentId = seriesId
    m.activeVodCodecKey = VodCodecKey(it)
    m.player.displayMode = "fullscreen"
    m.liveFullscreen = false
    m.content.visible = false
    m.rail.visible = false
    m.liveCatOverlay.visible = false
    m.vodDetailOverlay.visible = false
    m.player.visible = true
    m.player.channelName = SafeStr(it.name)
    m.player.channelLogo = FirstImageUrl(it)
    m.player.channelCategory = m.sectionTitle.text
    m.player.channelNumber = ""
    m.player.columnId = Tern(seriesMode, 0, 87026)
    m.player.vodSeriesContentId = Tern(seriesMode, seriesId, "")
    m.player.vodContentId = SafeStr(it.contentId)
    it["_historySeriesMode"] = seriesMode
    it["_historySeriesContentId"] = seriesId
    HistoryAdd(it, "vod")
end sub
sub ShowCodecWarning(idx as Integer, codec as String, codecKey as String)
    dlg = CreateObject("roSGNode", "StandardMessageDialog")
    dlg.title = "Compatibilidad de video"
    dlg.message = [codec + " fue identificado para este contenido, pero este Roku informó que no puede decodificarlo."]
    dlg.buttons = ["Intentar reproducir", "Cancelar"]
    m.codecPendingIdx = idx
    m.codecPendingKey = codecKey
    m.codecWarningDlg = dlg
    dlg.ObserveField("buttonSelected", "OnCodecWarningButton")
    dlg.ObserveField("wasClosed", "OnCodecWarningClosed")
    m.top.GetScene().dialog = dlg
end sub
sub OnCodecWarningButton(event as Object)
    dlg = event.GetRoSGNode()
    if dlg = invalid or m.codecWarningDlg = invalid then return
    if not dlg.isSameNode(m.codecWarningDlg) then return
    idx = m.codecPendingIdx
    accepted = (event.GetData() = 0)
    dlg.UnobserveField("buttonSelected")
    dlg.UnobserveField("wasClosed")
    dlg.close = true
    m.codecWarningDlg = invalid
    m.codecPendingIdx = -1
    if accepted
        m.codecWarningAcceptedKey = m.codecPendingKey
        DoOpenItem(idx)
    else
        m.top.SetFocus(true)
    end if
end sub
sub OnCodecWarningClosed(event as Object)
    dlg = event.GetRoSGNode()
    if dlg = invalid or m.codecWarningDlg = invalid then return
    if not dlg.isSameNode(m.codecWarningDlg) then return
    dlg.UnobserveField("buttonSelected")
    dlg.UnobserveField("wasClosed")
    m.codecWarningDlg = invalid
    m.codecPendingIdx = -1
    m.top.SetFocus(true)
end sub
sub PlayLiveItem(idx as Integer, fullscreen as Boolean)
    if idx < 0 or idx >= m.items.Count() then return
    if not m.recoveryInternal
        RecoveryCancel()
        m.recoveryTried = {}
        m.recoveryRetryUsed = false
    end if
    it = m.items[idx]
    m.gridIdx = idx
    m.player.displayMode = Tern(fullscreen, "fullscreen", "embedded")
    m.liveFullscreen = fullscreen
    m.content.visible = not fullscreen
    m.rail.visible = not fullscreen
    m.player.visible = true
    m.player.channelName = SafeStr(it.name)
    m.player.channelLogo = FirstImageUrl(it)
    catName = "TV en vivo"
    columnId = 76182
    inFavContext = (m.NAV[m.navIdx].id = "favs")
    if m.catIdx >= 0 and m.catIdx < m.categories.Count()
        catName = SafeStr(m.categories[m.catIdx].name)
        columnId = GetCatId(m.categories[m.catIdx])
        if IsFavCat(m.categories[m.catIdx]) then inFavContext = true
    end if
    if columnId <= 0
        if it._favColumnId <> invalid and AsInt(it._favColumnId) > 0
            columnId = AsInt(it._favColumnId)
        else if it._historyColumnId <> invalid and AsInt(it._historyColumnId) > 0
            columnId = AsInt(it._historyColumnId)
        else
            columnId = 76182
        end if
        if IsValidStr(SafeStr(it._favCategoryName)) then catName = SafeStr(it._favCategoryName)
    end if
    m.player.isFavorite = IsChannelFav(it)
    protected = IsLocked(it)
    if m.catIdx >= 0 and m.catIdx < m.categories.Count()
        if IsCatAdult(m.categories[m.catIdx]) then protected = true
    end if
    m.pendingLiveSave = invalid
    if not protected
        saveCatId = Tern(inFavContext, "-99", columnId.ToStr())
        m.pendingLiveSave = {
            channelId: LiveStableId(it), channelCode: SafeStr(it.channelCode), apiId: SafeStr(it.id),
            categoryId: saveCatId, categoryName: catName, provider: LiveProviderId(), protected: false
        }
    end if
    m.player.channelCategory = catName
    m.player.channelNumber = (idx + 1).ToStr()
    m.player.columnId = columnId
    m.recoveryGeneration = m.recoveryGeneration + 1
    m.player.requestGeneration = m.recoveryGeneration
    m.recoveryState = "LOADING"
    m.recoveryWasPlaying = false
    m.switchingLive = true
    RecoveryWatch("startup", 15)
    m.player.channelCode = it.channelCode
    it["_historyColumnId"] = columnId
    HistoryAdd(it, "live")
    if fullscreen then m.player.poke = true
end sub
sub StopRecoveryTimers()
    if m.watchTimer <> invalid then m.watchTimer.control = "stop"
    if m.recoveryTimer <> invalid then m.recoveryTimer.control = "stop"
    m.watchTimer = invalid
    m.recoveryTimer = invalid
end sub
sub RecoveryCancel()
    StopRecoveryTimers()
    m.recoveryGeneration = m.recoveryGeneration + 1
    m.recoveryState = "IDLE"
    m.player.statusMessage = ""
end sub
sub RecoveryWatch(kind as String, seconds as Integer)
    if m.watchTimer <> invalid then m.watchTimer.control = "stop"
    t = CreateObject("roSGNode", "Timer")
    t.AddField("generation", "integer", false)
    t.AddField("kind", "string", false)
    t.generation = m.recoveryGeneration
    t.kind = kind
    t.duration = seconds
    t.repeat = false
    t.ObserveField("fire", "OnRecoveryWatch")
    m.watchTimer = t
    t.control = "start"
end sub
sub OnRecoveryWatch(event as Object)
    t = event.GetRoSGNode()
    if t = invalid then return
    if t.generation <> m.recoveryGeneration then return
    if m.recoveryState <> "LOADING" and m.recoveryState <> "PLAYING" then return
    RecoveryQueue("timeout_" + SafeStr(t.kind))
end sub
function RecoveryKey(idx as Integer) as String
    if idx < 0 or idx >= m.items.Count() then return ""
    k = LiveStableId(m.items[idx])
    if k = "" then k = "i" + idx.ToStr()
    return k
end function
function RecoveryEligible(idx as Integer) as Boolean
    if idx < 0 or idx >= m.items.Count() then return false
    it = m.items[idx]
    if SafeStr(it.channelCode) = "" then return false
    if m.recoveryTried[RecoveryKey(idx)] <> invalid then return false
    locked = IsLocked(it)
    if m.catIdx >= 0 and m.catIdx < m.categories.Count() and IsCatAdult(m.categories[m.catIdx]) then locked = true
    return not locked or m.adultUnlocked
end function
sub RecoveryQueue(reason as String)
    if not m.liveFullscreen or not m.player.visible then return
    if m.recoveryState = "RECOVERING" or m.recoveryState = "FAILED" then return
    if m.watchTimer <> invalid then m.watchTimer.control = "stop"
    m.watchTimer = invalid
    m.pendingLiveSave = invalid
    m.recoveryTried[RecoveryKey(m.gridIdx)] = true
    m.recoveryState = "RECOVERING"
    m.player.statusMessage = "Canal no disponible · Probando siguiente"
    t = CreateObject("roSGNode", "Timer")
    t.AddField("generation", "integer", false)
    t.AddField("reason", "string", false)
    t.generation = m.recoveryGeneration
    t.reason = reason
    t.duration = 0.05
    t.repeat = false
    t.ObserveField("fire", "OnRecoveryTransition")
    m.recoveryTimer = t
    t.control = "start"
end sub
sub OnRecoveryTransition(event as Object)
    t = event.GetRoSGNode()
    if t = invalid then return
    if t.generation <> m.recoveryGeneration or m.recoveryState <> "RECOVERING" then return
    current = m.gridIdx
    if m.recoveryWasPlaying and not m.recoveryRetryUsed
        m.recoveryRetryUsed = true
        m.recoveryInternal = true
        PlayLiveItem(current, true)
        m.recoveryInternal = false
        return
    end if
    for offset = 1 to m.items.Count()
        idx = (current + offset) mod m.items.Count()
        if RecoveryEligible(idx)
            m.recoveryRetryUsed = false
            m.recoveryInternal = true
            PlayLiveItem(idx, true)
            m.recoveryInternal = false
            return
        end if
    end for
    m.recoveryState = "FAILED"
    m.switchingLive = false
    m.player.control = "stop"
    m.player.statusMessage = "LIVE-003 · No hay canales disponibles · OK Opciones · Atrás Regresar"
end sub
sub OnPlayerState(event as Object)
    state = event.GetData()
    liveFull = (IsLiveSection(m.NAV[m.navIdx].id) and m.liveFullscreen and m.player.visible)
    if liveFull and m.player.stateGeneration <> m.recoveryGeneration then return
    if state = "playing"
        if m.watchTimer <> invalid then m.watchTimer.control = "stop"
        m.watchTimer = invalid
        m.recoveryState = "PLAYING"
        m.recoveryWasPlaying = true
        m.recoveryTried = {}
        m.player.statusMessage = ""
        m.switchingLive = false
        if m.pendingLiveSave <> invalid then SavePendingLive()
        m.startupPlayback = false
    else if state = "buffering" and liveFull
        if m.recoveryWasPlaying then RecoveryWatch("buffering", 20)
    else if state = "nocodec"
        m.switchingLive = false
        if liveFull then RecoveryQueue("codec") : return
        if IsLiveSection(m.NAV[m.navIdx].id)
            ClosePlayer()
            m.gridState = "nohevc"
            RenderGrid()
            return
        end if
        if m.vodErrorActive then return
        m.vodErrorActive = true
        ClosePlayer()
        ShowVodPlaybackError(true)
    else if state = "error"
        m.switchingLive = false
        m.pendingLiveSave = invalid
        if liveFull then RecoveryQueue("error") : return
        if m.startupPlayback and TryStartupFallback() then return
        m.startupPlayback = false
        if IsLiveSection(m.NAV[m.navIdx].id)
            ClosePlayer()
            return
        end if
        if m.vodErrorActive then return
        m.vodErrorActive = true
        ClosePlayer()
        ShowVodPlaybackError(false)
    else if (state = "stopped" or state = "closed" or state = "finished") and m.player.visible
        if liveFull and not m.switchingLive and m.recoveryState <> "FAILED"
            RecoveryQueue("interrupted")
            return
        end if
        if not m.switchingLive then ClosePlayer()
    end if
end sub
sub ShowVodPlaybackError(formatError as Boolean)
    if formatError and m.lastVodPlaybackItem <> invalid and m.top.hardwareInfo <> invalid and m.top.hardwareInfo.hevc = false
        if VodCodecForItem(m.lastVodPlaybackItem) = ""
            SaveVodCodec(VodCodecKey(m.lastVodPlaybackItem), ItemCode(m.lastVodPlaybackItem), "H.265/HEVC")
        end if
    end if
    m.vodErrorFormat = formatError
    m.vodErrorCode = Tern(formatError, "VOD-005", "VOD-002")
    m.vodErrorChoice = 0
    if m.vodDetailMode <> ""
        m.vodDetailOverlay.visible = true
        m.content.visible = false
        m.rail.visible = false
        RenderVodDetail()
    else
        m.content.visible = true
        m.rail.visible = true
        RenderGrid()
    end if
    m.top.SetFocus(true)
end sub
sub ClosePlayer()
    if not m.player.visible or m.closingPlayer then return
    m.closingPlayer = true
    RecoveryCancel()
    m.player.visible = false
    m.switchingLive = false
    m.pendingLiveSave = invalid
    m.startupPlayback = false
    m.player.control = "stop"
    m.player.detectedVideoFormat = ""
    m.player.detectedVideoCodec = ""
    m.player.detectedAudioFormat = ""
    m.activeVodCodecKey = ""
    m.player.displayMode = "fullscreen"
    m.liveFullscreen = false
    m.fullPanelMode = ""
    m.fullPanelWaiting = false
    m.liveCatOverlay.visible = false
    if m.vodDetailMode <> ""
        m.vodDetailOverlay.visible = true
        m.content.visible = false
        m.rail.visible = false
    else
        m.content.visible = true
        m.rail.visible = true
    end if
    m.adultUnlocked = false   ' al cerrar el player se vuelve a pedir el PIN
    if m.catIdx >= 0 and m.catIdx < m.categories.Count() and IsCatAdult(m.categories[m.catIdx])
        m.gridState = "locked"
    end if
    m.top.SetFocus(true)
    if m.vodDetailMode <> "" then RenderVodDetail() else RenderGrid()
    m.closingPlayer = false
end sub
function PinLoad() as String
    if v4a10() then return "configured"
    return ""
end function
sub PinSave(pin as String)
    if v4a11(pin) then m.adultPin = "configured"
end sub
sub PinShowCreate()
    dlg = CreateObject("roSGNode", "PinDialog")
    dlg.title     = "Contenido +18 — Crear PIN"
    dlg.message   = "Escribe un PIN de 4 digitos para proteger este canal."
    dlg.buttons   = ["Aceptar", "Cancelar"]
    m.pinDlg      = dlg
    if m.pinMode <> "create_confirm" then m.pinMode = "create"
    dlg.ObserveField("buttonSelected", "OnPinCreateButton")
    dlg.ObserveField("wasClosed", "OnPinCreateClosed")
    m.top.GetScene().dialog = dlg
end sub
sub OnPinCreateChange(event as Object)
end sub
sub OnPinCreateButton(event as Object)
    dlg = event.GetRoSGNode()
    if dlg = invalid or m.pinDlg = invalid or not dlg.isSameNode(m.pinDlg) then return
    btn = event.GetData()
    if btn = 0 ' Aceptar
        pin = SafeStr(dlg.pin)
        if Len(pin) = 4
            if m.pinMode = "create"
                dlg.UnobserveField("buttonSelected")
                dlg.UnobserveField("wasClosed")
                dlg.close = true
                m.pinDlg = invalid
                m.pinEntry1 = pin
                m.pinMode = "create_confirm"
                PinShowCreate()
                if m.pinDlg <> invalid
                    m.pinDlg.title = "Contenido +18 — Confirmar PIN"
                    m.pinDlg.message = "Repite el PIN de 4 dígitos."
                end if
            else if pin = m.pinEntry1 and v4a11(pin)
                dlg.UnobserveField("buttonSelected")
                dlg.UnobserveField("wasClosed")
                dlg.close = true
                m.pinDlg = invalid
                m.adultPin = "configured"
                m.pinEntry1 = ""
                v4a15()
                UnlockAndOpenPending()
            else
                PinScheduleReset(dlg, "Los PIN no coinciden. Repite el PIN de confirmación.")
            end if
        else
            PinScheduleReset(dlg, "El PIN debe tener 4 dígitos.")
        end if
    else ' Cancelar
        dlg.UnobserveField("pin")
        dlg.UnobserveField("buttonSelected")
        dlg.UnobserveField("wasClosed")
        dlg.close = true
        m.pinDlg = invalid
        PinCancel()
    end if
end sub
sub OnPinCreateClosed(event as Object)
    dlg = event.GetRoSGNode()
    if dlg <> invalid and m.pinDlg <> invalid and dlg.isSameNode(m.pinDlg)
        dlg.UnobserveField("pin")
        dlg.UnobserveField("buttonSelected")
        dlg.UnobserveField("wasClosed")
    else
        return
    end if
    m.pinDlg = invalid
    PinCancel()
end sub
sub PinShowVerify()
    remain = v4a13()
    if remain > 0
        PinShowError("Demasiados intentos. Espera " + remain.ToStr() + " segundos.")
        return
    end if
    dlg = CreateObject("roSGNode", "PinDialog")
    dlg.title     = "Contenido +18"
    dlg.message   = "Ingresa tu PIN de 4 digitos."
    dlg.buttons   = ["Aceptar", "Cancelar"]
    m.pinDlg      = dlg
    m.pinMode     = "verify"
    dlg.ObserveField("buttonSelected", "OnPinVerifyButton")
    dlg.ObserveField("wasClosed", "OnPinVerifyClosed")
    m.top.GetScene().dialog = dlg
end sub
sub OnPinVerifyChange(event as Object)
end sub
sub OnPinVerifyButton(event as Object)
    dlg = event.GetRoSGNode()
    if dlg = invalid or m.pinDlg = invalid or not dlg.isSameNode(m.pinDlg) then return
    btn = event.GetData()
    if btn = 0 ' Aceptar
        pin = SafeStr(dlg.pin)
        if Len(pin) = 4
            remain = v4a13()
            if remain > 0
                PinScheduleReset(dlg, "Demasiados intentos. Espera " + remain.ToStr() + " segundos.")
            else if v4a12(pin)
                dlg.UnobserveField("buttonSelected")
                dlg.UnobserveField("wasClosed")
                dlg.close = true
                m.pinDlg = invalid
                v4a15()
                UnlockAndOpenPending()
            else
                remain = v4a14()
                if remain > 0
                    PinScheduleReset(dlg, "Demasiados intentos. Espera " + remain.ToStr() + " segundos.")
                else
                    PinScheduleReset(dlg, "PIN incorrecto. Inténtalo nuevamente.")
                end if
            end if
        else
            PinScheduleReset(dlg, "El PIN debe tener 4 dígitos.")
        end if
    else ' Cancelar
        dlg.UnobserveField("pin")
        dlg.UnobserveField("buttonSelected")
        dlg.UnobserveField("wasClosed")
        dlg.close = true
        m.pinDlg = invalid
        PinCancel()
    end if
end sub
sub OnPinVerifyClosed(event as Object)
    dlg = event.GetRoSGNode()
    if dlg <> invalid and m.pinDlg <> invalid and dlg.isSameNode(m.pinDlg)
        dlg.UnobserveField("pin")
        dlg.UnobserveField("buttonSelected")
        dlg.UnobserveField("wasClosed")
    else
        return
    end if
    m.pinDlg = invalid
    PinCancel()
end sub
sub PinScheduleReset(dlg as Object, message as String)
    if dlg = invalid or m.pinDlg = invalid or not dlg.isSameNode(m.pinDlg) then return
    if m.pinResetTimer <> invalid then m.pinResetTimer.control = "stop"
    m.pinResetDlg = dlg
    m.pinResetMessage = message
    timer = CreateObject("roSGNode", "Timer")
    timer.duration = 0.05
    timer.repeat = false
    timer.ObserveField("fire", "OnPinResetFire")
    m.pinResetTimer = timer
    timer.control = "start"
end sub
sub OnPinResetFire(event as Object)
    timer = event.GetRoSGNode()
    if timer <> invalid then timer.UnobserveField("fire")
    m.pinResetTimer = invalid
    dlg = m.pinResetDlg
    m.pinResetDlg = invalid
    if dlg = invalid or m.pinDlg = invalid or not dlg.isSameNode(m.pinDlg) then return
    dlg.message = m.pinResetMessage
    dlg.messageColor = "0xE96A72FF"
    dlg.pin = ""
    dlg.pinPadFocused = true
    if dlg.pinPad <> invalid then dlg.pinPad.SetFocus(true)
end sub
sub UnlockAndOpenPending()
    m.adultUnlocked = true
    idx = m.adultPendingIdx
    cat = m.adultPendingCat
    context = m.pinContext
    m.pinContext = ""
    m.adultPendingIdx = -1
    m.adultPendingCat = -1
    m.pinMode = ""
    m.top.SetFocus(true)
    if context = "fullchannel"
        PlayLiveItem(idx, true)
        return
    else if context = "fullcategory"
        if cat >= 0 and cat < m.categories.Count()
            m.catIdx = cat
            m.savedLiveCatIdx = cat
            m.fullPanelMode = "loading"
            m.fullPanelWaiting = true
            RenderFullLivePanel()
            LoadItemsForCurrentCategory()
        end if
        return
    end if
    if idx >= 0
        DoOpenItem(idx)
    else
        targetCat = cat
        if targetCat < 0 then targetCat = m.catIdx
        if targetCat >= 0 and targetCat < m.categories.Count()
            m.catIdx = targetCat
            m.savedLiveCatIdx = targetCat
        end if
        m.gridState = "loading"
        m.region    = "grid"
        m.gridIdx   = 0
        m.rowOffset = 0
        RenderRail()
        RenderCategories()
        RenderGrid()
        LoadItemsForCurrentCategory()
    end if
end sub
sub PinCancel()
    if m.pinResetTimer <> invalid then m.pinResetTimer.control = "stop"
    m.pinResetTimer = invalid
    m.pinResetDlg = invalid
    m.adultPendingIdx = -1
    m.adultPendingCat = -1
    m.pinMode         = ""
    pinWasFullscreen = (m.pinContext = "fullchannel" or m.pinContext = "fullcategory")
    m.pinContext = ""
    if IsLiveSection(m.NAV[m.navIdx].id) and m.gridState = "locked"
        m.catIdx = m.savedLiveCatIdx
        m.liveCatCursor = m.catIdx
        m.gridState = Tern(m.items.Count() > 0, "ready", "empty")
    end if
    m.top.SetFocus(true)
    if pinWasFullscreen
        RenderFullLivePanel()
    else
        RenderCategories() : RenderGrid()
    end if
end sub
sub PinShowError(msg as String)
    dlg = CreateObject("roSGNode", "StandardMessageDialog")
    dlg.title   = "PIN incorrecto"
    dlg.message = msg
    dlg.buttons = ["OK"]
    dlg.ObserveField("wasClosed", "OnErrorDlgClosed")
    dlg.ObserveField("buttonSelected", "OnErrorDlgClosed")
    m.top.GetScene().dialog = dlg
end sub
sub OnErrorDlgClosed(event as Object)
    dlg = event.GetRoSGNode()
    if dlg <> invalid
        dlg.UnobserveField("wasClosed")
        dlg.UnobserveField("buttonSelected")
        dlg.close = true
    end if
    PinCancel()
end sub
sub ClearHistoryMemory()
    if m.NAV[m.navIdx].id = "history"
        m.items = []
        m.gridIdx = 0 : m.rowOffset = 0 : m.gridState = "empty"
        RenderHeader() : RenderGrid()
    end if
    m.lastSearch = invalid
end sub
sub ClearFavoritesMemory()
    m.favList = []
    m.favs = {}
    RefreshFavCategoryLabel()
    if m.player.visible then m.player.isFavorite = false
    inFavList = (m.NAV[m.navIdx].id = "favs" or (m.NAV[m.navIdx].id = "vivo" and m.catIdx >= 0 and m.catIdx < m.categories.Count() and IsFavCat(m.categories[m.catIdx])))
    if inFavList
        if m.player.visible and not m.liveFullscreen then ClosePlayer()
        m.items = []
        m.gridIdx = 0 : m.rowOffset = 0 : m.gridState = "empty"
    end if
    RenderRail() : RenderHeader() : RenderGrid()
end sub
sub ToggleFav()
    navId = m.NAV[m.navIdx].id
    if (m.region <> "grid" and m.region <> "grid_fav" and m.region <> "preview") or IsVodSection(navId) or navId = "search" then return
    if m.gridIdx < 0 or m.gridIdx >= m.items.Count() then return
    it = m.items[m.gridIdx]
    if navId = "history" and SafeStr(it._historyKind) = "vod" then return
    if IsLocked(it) then return
    if m.catIdx >= 0 and m.catIdx < m.categories.Count() and IsCatAdult(m.categories[m.catIdx]) then return
    added = ToggleFavItem(it)
    if m.player.visible and SafeStr(m.player.channelCode) <> "" and SafeStr(m.player.channelCode) = SafeStr(it.channelCode)
        m.player.isFavorite = added
    end if
    ShowUiNotice(Tern(added, "Agregado a Favoritos: " + SafeStr(it.name), "Quitado de Favoritos: " + SafeStr(it.name)))
    viewingFavs = (navId = "favs" or (navId = "vivo" and m.catIdx >= 0 and m.catIdx < m.categories.Count() and IsFavCat(m.categories[m.catIdx])))
    if viewingFavs
        m.items = FavItems()
        if m.items.Count() = 0
            if m.player.visible and not m.liveFullscreen then ClosePlayer()
            m.gridIdx = 0
            m.rowOffset = 0
            m.gridState = "empty"
            m.region = "nav"
        else
            if m.gridIdx >= m.items.Count() then m.gridIdx = m.items.Count() - 1
            EnsureLiveChannelVisible()
        end if
    end if
    RenderRail() : RenderCategories() : RenderGrid()
end sub
sub SetSection(i as Integer)
    leavingLive = (IsLiveSection(m.NAV[m.navIdx].id) and not IsLiveSection(m.NAV[i].id))
    if m.NAV[m.navIdx].id = "vivo" and m.catIdx >= 0 and m.catIdx < m.categories.Count()
        if not IsCatAdult(m.categories[m.catIdx]) then m.savedLiveCatIdx = m.catIdx
    end if
    if leavingLive and m.player.visible then ClosePlayer()
    m.navIdx     = i
    m.navCursor  = i
    m.section    = m.NAV[i].id
    m.catIdx     = Tern(m.NAV[i].id = "vivo", m.savedLiveCatIdx, 0)
    m.liveCatCursor = m.catIdx
    if m.NAV[i].id = "vivo" and not m.player.visible and m.liveSessionChannelId <> "" then m.resumeLiveOnLoad = true
    m.gridIdx    = 0
    m.region     = "nav"
    m.adultUnlocked   = false   ' al cambiar de sección se resetea el desbloqueo
    m.adultPendingCat = -1
    RenderRail()
    LoadCategoriesForSection()
end sub
sub EnterContent()
    if m.region = "nav" and m.navCursor <> m.navIdx
        target = m.NAV[m.navCursor]
        if target.id = "search"
            m.navIdx = m.navCursor
            m.section = target.id
            RenderRail() : RenderHeader()
            ShowSearchDialog()
            return
        else if target.id = "settings"
            m.navIdx = m.navCursor
            m.section = target.id
            RenderRail() : RenderHeader()
            scene = m.top.GetScene()
            if scene <> invalid then scene.showSettings = true
            return
        end if
        m.pendingEnter = true
        SetSection(m.navCursor)
        return
    end if
    id = m.NAV[m.navIdx].id
    if id = "search"
        ShowSearchDialog()
        return
    else if id = "settings"
        scene = m.top.GetScene()
        if scene <> invalid then scene.showSettings = true
        return
    else if id = "home" or id = "history"
        if m.gridState <> "ready" or m.items.Count() = 0 then return
        m.region  = "grid"
        m.gridIdx = 0
        m.rowOffset = 0
    else if IsLiveSection(id)
        if m.gridState <> "ready" or m.items.Count() = 0 then return
        m.region = "grid"
        if m.gridIdx < 0 or m.gridIdx >= m.items.Count() then m.gridIdx = 0
        EnsureLiveChannelVisible()
    else
        if m.categories.Count() = 0 then return
        m.region = "cats"
    end if
    RenderRail()
    RenderCategories()
    RenderGrid()
end sub
sub MaybeEnterPending()
    if not m.pendingEnter then return
    if m.gridState = "loading" then return
    m.pendingEnter = false
    if m.gridState = "ready" then EnterContent()
end sub
sub ShowSearchDialog()
    dlg = CreateObject("roSGNode", "KeyboardDialog")
    dlg.title = "Buscar pelicula o serie (escribe y pulsa Buscar o Back)"
    dlg.buttons = ["Buscar", "Cancelar"]
    m.searchText = ""
    if m.lastSearch <> invalid
        dlg.text = m.lastSearch
        m.searchText = m.lastSearch
    end if
    m.searchCancel = false
    m.searchDlg = dlg
    dlg.ObserveField("text",           "OnSearchText")
    dlg.ObserveField("buttonSelected", "OnSearchButton")
    dlg.ObserveField("wasClosed",      "OnSearchClosed")
    m.top.GetScene().dialog = dlg
end sub
sub OnSearchText(event as Object)
    m.searchText = SafeStr(event.GetData())
end sub
sub OnSearchButton(event as Object)
    idx = event.GetData()
    if idx = 1 then m.searchCancel = true   ' "Cancelar"
    if m.searchDlg <> invalid then m.searchDlg.close = true
end sub
sub OnSearchClosed(event as Object)
    term = m.searchText
    cancel = m.searchCancel
    m.searchDlg = invalid
    m.top.SetFocus(true)   ' devolver el foco a HomeScreen tras cerrar el teclado
    if not cancel and term <> invalid and Len(term) > 0 then RunSearch(term)
end sub
sub RunSearch(term as String)
    m.lastSearch = term
    m.region = "grid"
    m.gridIdx = 0
    m.rowOffset = 0
    m.items = []
    m.gridState = "loading"
    m.sectionTitle.text = "Buscar: " + term
    RenderHeader() : RenderRail() : RenderGrid()
    if m.searchTask <> invalid then m.searchTask.control = "STOP"
    m.searchTask = Api_OpTask("search", { value: term, page: 1 })
    if m.searchTask = invalid
        SetGridError("search", "operación ausente en kit") : return
    end if
    m.searchTask.ObserveField("rawResp", "OnSearchResp")
    m.searchTask.ObserveField("error",   "OnSearchErr")
    m.searchTask.control = "RUN"
end sub
sub OnSearchResp(event as Object)
    raw = event.GetData()
    data = Api_ParseOp(raw)
    if data = invalid
        SetGridError("search", "respuesta inválida: " + Left(SafeStr(raw), 220))
        return
    end if
    items = []
    if data <> invalid and data.resourceResult <> invalid and data.resourceResult.resourceList <> invalid
        items = data.resourceResult.resourceList
    end if
    if data <> invalid and data.seriesResult <> invalid and data.seriesResult.seriesList <> invalid
        for each s in data.seriesResult.seriesList
            items.Push(s)
        end for
    end if
    safeItems = []
    for each result in items
        if not IsLocked(result) then safeItems.Push(result)
    end for
    items = safeItems
    m.rawItems = items
    m.gridIdx = 0
    m.rowOffset = 0
    ApplyVodFilter(false)
    RenderHeader() : RenderGrid()
end sub
sub OnSearchErr(event as Object)
    if Api_LicenseGone(event.GetData()) then return
    SetGridError("search", event.GetData())
end sub
function IsCatAdult(cat as Object) as Boolean
    name = LCase(SafeStr(cat.name))
    if InStr(name, "18") > 0 then return true
    if InStr(name, "adult") > 0 then return true
    if InStr(name, "xxx") > 0 then return true
    return false
end function
sub ChooseCat(i as Integer)
    if i < 0 or i >= m.categories.Count() then return
    cat = m.categories[i]
    if m.catIdx >= 0 and m.catIdx < m.categories.Count()
        if IsCatAdult(m.categories[m.catIdx]) and i <> m.catIdx then m.adultUnlocked = false
    end if
    if IsCatAdult(cat) and not m.adultUnlocked
        if m.player.visible and not m.liveFullscreen then ClosePlayer()
        m.catIdx = i
        m.adultPendingCat = i
        m.adultPendingIdx = -1
        m.gridState = "locked"
        RenderCategories()
        RenderGrid()
        return
    end if
    m.catIdx = i
    RenderCategories()
    LoadItemsForCurrentCategory()
end sub
function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then return false
    return HandleRemoteKey(key)
end function
sub RequestFullLiveChannel(idx as Integer)
    RecoveryCancel()
    if m.items.Count() = 0 then return
    if idx < 0 then idx = m.items.Count() - 1
    if idx >= m.items.Count() then idx = 0
    protected = false
    if m.catIdx >= 0 and m.catIdx < m.categories.Count()
        protected = IsCatAdult(m.categories[m.catIdx])
    end if
    if IsLocked(m.items[idx]) then protected = true
    if protected and not m.adultUnlocked
        m.pinContext = "fullchannel"
        m.adultPendingIdx = idx
        PinDispatch()
        return
    end if
    PlayLiveItem(idx, true)
end sub
sub SelectFullLiveCategory()
    RecoveryCancel()
    idx = m.fullPanelCursor
    if idx < 0 or idx >= m.categories.Count() then return
    if m.catIdx >= 0 and m.catIdx < m.categories.Count()
        if IsCatAdult(m.categories[m.catIdx]) and idx <> m.catIdx then m.adultUnlocked = false
    end if
    if IsCatAdult(m.categories[idx]) and not m.adultUnlocked
        m.pinContext = "fullcategory"
        m.adultPendingCat = idx
        m.adultPendingIdx = -1
        PinDispatch()
        return
    end if
    if idx = m.catIdx and m.items.Count() > 0
        m.fullPanelMode = "channels"
        CalculateFullPanelWidth("channels")
        m.fullPanelWaiting = false
        m.fullPanelCursor = m.gridIdx
        key = GetCatId(m.categories[idx]).ToStr()
        if m.fullPanelPositions[key] <> invalid then m.fullPanelCursor = m.fullPanelPositions[key]
        if m.fullPanelCursor < 0 or m.fullPanelCursor >= m.items.Count() then m.fullPanelCursor = 0
        RenderFullLivePanel()
        return
    end if
    m.catIdx = idx
    m.savedLiveCatIdx = idx
    m.fullPanelMode = "loading"
    m.fullPanelWaiting = true
    RenderFullLivePanel()
    LoadItemsForCurrentCategory()
end sub
sub ExitLiveFullscreen()
    RecoveryCancel()
    CloseFullLivePanel()
    m.liveFullscreen = false
    m.player.displayMode = "embedded"
    m.content.visible = true
    m.rail.visible = true
    m.top.SetFocus(true)
end sub
function HandleFullLiveKey(key as String) as Boolean
    if m.player.menuOpen = true
        return m.player.CallFunc("HandleMenuKey", key)
    end if
    if m.fullPanelMode = ""
        if key = "up"
            RequestFullLiveChannel(m.gridIdx - 1)
        else if key = "down"
            RequestFullLiveChannel(m.gridIdx + 1)
        else if key = "OK"
            m.player.CallFunc("OpenPlayerMenu", "live")
        else if key = "left"
            OpenFullLivePanel(false)
        else if key = "right"
            OpenFullLivePanel(true)
        else if key = "options"
            if m.gridIdx >= 0 and m.gridIdx < m.items.Count()
                cur = m.items[m.gridIdx]
                if not IsLocked(cur) and not (m.catIdx >= 0 and m.catIdx < m.categories.Count() and IsCatAdult(m.categories[m.catIdx]))
                    added = ToggleFavItem(cur)
                    m.player.isFavorite = added
                    m.player.poke = true
                    ShowFavToast(Tern(added, "Agregado a Favoritos: " + SafeStr(cur.name), "Quitado de Favoritos: " + SafeStr(cur.name)))
                end if
            end if
        else if key = "back"
            ExitLiveFullscreen()
            RenderRail() : RenderHeader() : RenderGrid()
        else
            m.player.poke = true
        end if
        return true
    end if
    if key = "back"
        if m.fullPanelMode = "channels" and m.fullPanelFavFocus
            m.fullPanelFavFocus = false
            RenderFullLivePanel()
            return true
        end if
        if m.NAV[m.navIdx].id = "favs"
            CloseFullLivePanel()
            return true
        end if
        if m.fullPanelMode = "channels" or m.fullPanelMode = "loading"
            m.fullPanelFavFocus = false
            if m.fullPanelMode = "channels" and m.catIdx >= 0 and m.catIdx < m.categories.Count()
                m.fullPanelPositions[GetCatId(m.categories[m.catIdx]).ToStr()] = m.fullPanelCursor
            end if
            m.fullPanelMode = "categories"
            CalculateFullPanelWidth("categories")
            m.fullPanelWaiting = false
            m.fullPanelCursor = m.catIdx
            RenderFullLivePanel()
        else
            CloseFullLivePanel()
        end if
        return true
    end if
    if m.fullPanelMode = "loading" then return true
    count = m.categories.Count()
    if m.fullPanelMode = "channels" then count = m.items.Count()
    if key = "up" and m.fullPanelCursor > 0
        m.fullPanelCursor = m.fullPanelCursor - 1
        RenderFullLivePanel()
    else if key = "down" and m.fullPanelCursor < count - 1
        m.fullPanelCursor = m.fullPanelCursor + 1
        RenderFullLivePanel()
    else if key = "right" and m.fullPanelMode = "channels" and m.items.Count() > 0
        m.fullPanelFavFocus = true
        RenderFullLivePanel()
    else if key = "left" and m.fullPanelMode = "channels"
        if m.fullPanelFavFocus
            m.fullPanelFavFocus = false
            RenderFullLivePanel()
        else if m.NAV[m.navIdx].id = "vivo"
            m.fullPanelPositions[GetCatId(m.categories[m.catIdx]).ToStr()] = m.fullPanelCursor
            m.fullPanelMode = "categories"
            CalculateFullPanelWidth("categories")
            m.fullPanelWaiting = false
            m.fullPanelCursor = m.catIdx
            RenderFullLivePanel()
        end if
    else if key = "right" and m.fullPanelMode = "categories"
        SelectFullLiveCategory()
    else if key = "OK"
        if m.fullPanelMode = "categories"
            SelectFullLiveCategory()
        else if m.fullPanelMode = "channels" and m.items.Count() > 0
            if m.fullPanelFavFocus
                cur = m.items[m.fullPanelCursor]
                if not IsLocked(cur) and not (m.catIdx >= 0 and m.catIdx < m.categories.Count() and IsCatAdult(m.categories[m.catIdx]))
                    added = ToggleFavItem(cur)
                    if SafeStr(m.player.channelCode) = SafeStr(cur.channelCode) then m.player.isFavorite = added
                    ShowFavToast(Tern(added, "Agregado a Favoritos: " + SafeStr(cur.name), "Quitado de Favoritos: " + SafeStr(cur.name)))
                    if m.NAV[m.navIdx].id = "favs" or (m.catIdx >= 0 and m.catIdx < m.categories.Count() and IsFavCat(m.categories[m.catIdx]))
                        m.items = FavItems()
                        if m.items.Count() = 0
                            ExitLiveFullscreen()
                            ClosePlayer()
                            m.gridState = "empty"
                            m.region = "nav"
                            RenderRail() : RenderHeader() : RenderGrid()
                            return true
                        else if m.fullPanelCursor >= m.items.Count()
                            m.fullPanelCursor = m.items.Count() - 1
                        end if
                    end if
                    RenderFullLivePanel()
                end if
            else
                idx = m.fullPanelCursor
                if m.catIdx >= 0 and m.catIdx < m.categories.Count()
                    m.fullPanelPositions[GetCatId(m.categories[m.catIdx]).ToStr()] = idx
                end if
                CloseFullLivePanel()
                RequestFullLiveChannel(idx)
            end if
        end if
    end if
    return true
end function
sub OnPlayerMenuAction(event as Object)
    act = SafeStr(event.GetData())
    if act = "openGuide"
        if IsLiveSection(m.NAV[m.navIdx].id) and m.liveFullscreen
            OpenFullLivePanel(false)
        end if
    else if act = "toggleFav"
        if m.gridIdx >= 0 and m.gridIdx < m.items.Count()
            cur = m.items[m.gridIdx]
            if not IsLocked(cur) and not (m.catIdx >= 0 and m.catIdx < m.categories.Count() and IsCatAdult(m.categories[m.catIdx]))
                added = ToggleFavItem(cur)
                m.player.isFavorite = added
                ShowFavToast(Tern(added, "Agregado a Favoritos: " + SafeStr(cur.name), "Quitado de Favoritos: " + SafeStr(cur.name)))
            end if
        end if
    else if act = "exitPlayer"
        if IsLiveSection(m.NAV[m.navIdx].id) and m.liveFullscreen
            ExitLiveFullscreen()
            RenderRail() : RenderHeader() : RenderGrid()
        else
            ClosePlayer()
        end if
    end if
end sub
function HandleRemoteKey(key as String) as Boolean
    if key = "back"
    end if
    if m.player.visible
        if m.player.menuOpen = true
            return m.player.CallFunc("HandleMenuKey", key)
        end if
        navId = m.NAV[m.navIdx].id
        isVod = IsVodSection(navId) or navId = "search"
        if navId = "history" and m.gridIdx >= 0 and m.gridIdx < m.items.Count()
            isVod = SafeStr(m.items[m.gridIdx]._historyKind) = "vod"
        end if
        if IsLiveSection(navId) and m.liveFullscreen
            return HandleFullLiveKey(key)
        end if
        embeddedLive = (IsLiveSection(navId) and not m.liveFullscreen)
        if embeddedLive
            keepNavigating = true
        else if key = "back"
            ClosePlayer()
        else if isVod and (key = "OK" or key = "options")
            m.player.CallFunc("OpenPlayerMenu", "vod")
        else if isVod and key = "play"
            m.player.transport = "playpause"
        else if isVod and key = "right"
            m.player.transport = "seekfwd"
        else if isVod and key = "left"
            m.player.transport = "seekback"
        else if isVod and (key = "up" or key = "down")
            m.player.transport = "cyclesub"
        else if isVod and key = "rewind"
            m.player.transport = "subearlier"
        else if isVod and key = "fastforward"
            m.player.transport = "sublater"
        else if key = "OK"
            m.player.CallFunc("OpenPlayerMenu", "live")
        else if key = "play"
            m.player.poke = true
        end if
        if not embeddedLive then return true
    end if
    if m.vodDetailMode <> "" then return HandleVodDetailKey(key)
    if key = "options"
        if m.region = "nav"
            if CountStarPress() then return true
        else if IsVodFilterContext()
            CycleVodFilter()
        else
            ToggleFav()
        end if
        return true
    else if key = "back"
        return MoveBack()
    else if key = "OK"
        Select_()
        return true
    else if key = "up"
        Move("up")
        return true
    else if key = "down"
        Move("down")
        return true
    else if key = "left"
        Move("left")
        return true
    else if key = "right"
        Move("right")
        return true
    end if
    return false
end function
sub Select_()
    if m.region = "nav"
        if m.NAV[m.navIdx].id = "vivo" and m.navCursor = m.navIdx and m.categories.Count() > 0
            m.liveCatCursor = m.catIdx
            m.region = "cats"
            RenderRail() : RenderCategories() : RenderGrid()
        else
            EnterContent()
        end if
    else if m.region = "cats"
        if m.NAV[m.navIdx].id = "vivo"
            target = m.liveCatCursor
            ChooseCat(target)
            if m.gridState = "locked"
                m.adultPendingCat = target
                PinDispatch()
            else
                m.savedLiveCatIdx = target
                m.region = "grid"
                m.gridIdx = 0
                m.rowOffset = 0
                RenderRail() : RenderCategories() : RenderGrid()
            end if
            return
        end if
        if m.gridState = "locked"
            if m.adultUnlocked
                m.region    = "grid"
                m.gridState = "loading"
                RenderGrid()
                LoadItemsForCurrentCategory()
            else
                m.adultPendingCat = m.catIdx
                PinDispatch()
            end if
        else if m.gridState = "ready" and m.items.Count() > 0
            m.region  = "grid"
            m.gridIdx = 0
            m.rowOffset = 0
            RenderRail()
            RenderCategories()
            RenderGrid()
        end if
    else if m.region = "grid_fav"
        ToggleFav()
    else if m.region = "preview"
        if IsLiveSection(m.NAV[m.navIdx].id)
            if m.previewBtnIdx = 1
                ToggleFav()
            else if m.previewBtnIdx = 2 and m.NAV[m.navIdx].id = "vivo" and m.categories.Count() > 0
                m.liveCatCursor = m.catIdx
                m.region = "cats"
                RenderRail() : RenderCategories() : RenderGrid()
            else if m.player.visible and m.gridIdx >= 0 and m.gridIdx < m.items.Count() and SafeStr(m.player.channelCode) <> "" and SafeStr(m.player.channelCode) = SafeStr(m.items[m.gridIdx].channelCode)
                m.liveFullscreen = true
                m.fullPanelMode = ""
                m.fullPanelFavFocus = false
                m.fullPanelWaiting = false
                m.content.visible = false
                m.rail.visible = false
                m.liveCatOverlay.visible = false
                m.player.displayMode = "fullscreen"
                m.player.poke = true
            else if m.gridState = "ready"
                OpenItem(m.gridIdx)
            end if
        end if
    else if m.region = "grid"
        if m.gridState = "locked"
            if m.adultUnlocked
                m.gridState = "loading"
                RenderGrid()
                LoadItemsForCurrentCategory()
            else
                m.adultPendingCat = m.catIdx
                PinDispatch()
            end if
        else if m.gridState = "error"
            LoadItemsForCurrentCategory()
        else if m.gridState = "ready"
            OpenItem(m.gridIdx)
        end if
    end if
end sub
sub PinDispatch()
    if m.adultPendingCat < 0
        m.adultPendingCat = m.catIdx
    end if
    if not v4a10()
        PinShowCreate()
    else
        PinShowVerify()
    end if
end sub
function MoveBack() as Boolean
    if m.region = "grid_fav"
        m.region = "grid"
        RenderGrid()
        return true
    else if m.region = "grid"
        if m.seriesMode
            ExitSeries()
            return true
        end if
        if IsLiveSection(m.NAV[m.navIdx].id)
            m.region = "nav"
        else if m.NAV[m.navIdx].id = "home" or m.NAV[m.navIdx].id = "history" or m.NAV[m.navIdx].id = "search"
            m.region = "nav"
        else
            m.region = "cats"
        end if
    else if m.region = "cats"
        if m.NAV[m.navIdx].id = "vivo"
            m.liveCatCursor = m.catIdx
            m.region = "grid"
        else
            m.region = "nav"
        end if
    else if m.region = "preview"
        m.region = "nav"
    else
        return false ' ya estamos en "nav": dejar que suba (salir de la app)
    end if
    RenderRail()
    RenderCategories()
    RenderGrid()
    return true
end function
sub Move(d as String)
    r = m.region
    if r = "nav"
        if d = "up"
            if m.navCursor > 0
                m.navCursor = m.navCursor - 1
                RenderRail()
            end if
        else if d = "down"
            if m.navCursor < m.NAV.Count() - 1
                m.navCursor = m.navCursor + 1
                RenderRail()
            end if
        else if d = "right"
            if IsLiveSection(m.NAV[m.navIdx].id) and m.navCursor = m.navIdx and m.gridState = "ready" and m.items.Count() > 0
                m.region = "preview"
                m.previewBtnIdx = 0
                RenderRail() : RenderCategories() : RenderGrid()
            else
                EnterContent()
            end if
        end if
        return
    end if
    if r = "cats"
        maxI = m.categories.Count() - 1
        if m.NAV[m.navIdx].id = "vivo"
            if d = "up" and m.liveCatCursor > 0
                m.liveCatCursor = m.liveCatCursor - 1
                RenderCategories()
            else if d = "down" and m.liveCatCursor < maxI
                m.liveCatCursor = m.liveCatCursor + 1
                RenderCategories()
            else if d = "right"
                Select_()
            end if
            return
        else if d = "left"
            if m.catIdx > 0
                ChooseCat(m.catIdx - 1)
            else
                MoveBack()
            end if
        else if d = "right"
            if m.catIdx < maxI then ChooseCat(m.catIdx + 1)
        else if d = "down"
            if m.gridState = "locked"
                PinDispatch()
            else if m.gridState = "ready"
                m.region  = "grid"
                m.gridIdx = 0
                m.rowOffset = 0
                RenderRail()
                RenderCategories()
                RenderGrid()
            end if
        end if
        return
    end if
    if r = "grid_fav"
        n = m.items.Count()
        if d = "left"
            m.region = "grid"
            RenderGrid()
        else if d = "up" and m.gridIdx > 0
            m.gridIdx = m.gridIdx - 1
            EnsureLiveChannelVisible()
            RenderGrid()
        else if d = "down" and m.gridIdx < n - 1
            m.gridIdx = m.gridIdx + 1
            EnsureLiveChannelVisible()
            RenderGrid()
        end if
        return
    end if
    if r = "grid"
        if m.gridState <> "ready"
            if d = "left"
                m.region = "nav"
                RenderRail()
                RenderCategories()
                RenderGrid()
            end if
            return
        end if
        n = m.items.Count()
        if IsLiveSection(m.NAV[m.navIdx].id)
            if d = "left"
                m.region = "preview"
                m.previewBtnIdx = PreviewBtnCount() - 1
                RenderRail() : RenderCategories() : RenderGrid()
            else if d = "right"
                m.region = "grid_fav"
                RenderGrid()
            else if d = "up" and m.gridIdx > 0
                m.gridIdx = m.gridIdx - 1
                EnsureLiveChannelVisible()
                RenderGrid()
            else if d = "down" and m.gridIdx < n - 1
                m.gridIdx = m.gridIdx + 1
                EnsureLiveChannelVisible()
                RenderGrid()
            end if
            return
        end if
        cols = GRID_COLS()
        i = m.gridIdx
        col = i mod cols
        if d = "left"
            if col > 0
                m.gridIdx = i - 1
                EnsureRowVisible()
                RenderGrid()
            else
                MoveBack()
            end if
        else if d = "right"
            if col < cols - 1 and i + 1 < n
                m.gridIdx = i + 1
                EnsureRowVisible()
                RenderGrid()
            end if
        else if d = "up"
            if i - cols >= 0
                m.gridIdx = i - cols
                EnsureRowVisible()
                RenderGrid()
            end if
        else if d = "down"
            if i + cols < n
                m.gridIdx = i + cols
                EnsureRowVisible()
                RenderGrid()
            end if
        end if
        return
    end if
    if r = "preview"
        maxBtn = PreviewBtnCount() - 1
        if d = "left"
            if m.previewBtnIdx > 0
                m.previewBtnIdx = m.previewBtnIdx - 1
            else
                m.region = "nav"
            end if
        else if d = "right"
            if m.previewBtnIdx < maxBtn
                m.previewBtnIdx = m.previewBtnIdx + 1
            else
                m.region = "grid"
            end if
        else if d = "up" and m.gridIdx > 0
            m.gridIdx = m.gridIdx - 1
            EnsureLiveChannelVisible()
        else if d = "down" and m.gridIdx < m.items.Count() - 1
            m.gridIdx = m.gridIdx + 1
            EnsureLiveChannelVisible()
        end if
        RenderRail() : RenderCategories() : RenderGrid()
        return
    end if
end sub
function Max(a as Integer, b as Integer) as Integer
    if a > b then return a
    return b
end function
function Min(a as Integer, b as Integer) as Integer
    if a < b then return a
    return b
end function
