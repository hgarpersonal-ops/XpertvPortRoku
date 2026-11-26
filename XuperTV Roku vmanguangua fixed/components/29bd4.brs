sub init()
    m.setupScreen = m.top.FindNode("setupScreen")
    m.homeScreen  = m.top.FindNode("homeScreen")
    m.debugScreen = m.top.FindNode("debugScreen")
    m.introAudio  = m.top.FindNode("introAudio")
    m.debugScreen.ObserveField("action", "OnDebugAction")
    m.top.ObserveField("showDebug", "OnShowDebug")
    m.settingsScreen = m.top.FindNode("settingsScreen")
    m.settingsScreen.ObserveField("action", "OnSettingsAction")
    m.top.ObserveField("showSettings", "OnShowSettings")
    m.top.ObserveField("sessionStale", "OnSessionStale")

    m.introDone    = false
    m.enteredHome  = false
    m.introTimer   = invalid
    m.otaChecking  = false
    m.lastOtaAt    = 0
    m.otaTask      = invalid
    m.authDone     = v4a26()
    m.homeScreen.visible  = false
    m.setupScreen.visible = true
    m.setupScreen.SetFocus(true)
    if m.authDone
        m.setupScreen.busy   = false
        m.setupScreen.status = ""
    else
        m.setupScreen.busy   = true
        m.setupScreen.status = "Conectando con XuperTV..."
        m.renewing = false
        m.retryDelay = 0
        RegisterAccount()
    end if
    PlayStartupIntro()
    CheckOtaKit(false)
end sub
sub PlayStartupIntro()
    if m.introTimer <> invalid then m.introTimer.control = "stop"
    m.introTimer = CreateObject("roSGNode", "Timer")
    m.introTimer.duration = 4.2
    m.introTimer.repeat   = false
    m.introTimer.ObserveField("fire", "OnIntroTimeout")
    m.introTimer.control  = "start"

    if m.introAudio = invalid
        FinishIntro()
        return
    end if
    content = CreateObject("roSGNode", "ContentNode")
    content.url          = "pkg:/rsc/intro.mp3"
    content.streamformat = "mp3"
    m.introAudio.ObserveField("state", "OnIntroAudioState")
    m.introAudio.content = content
    m.introAudio.control = "play"
end sub
sub OnIntroAudioState(event as Object)
    st = SafeStr(event.GetData())
    print "[XuperIntro] audio state="; st
    if st = "finished" or st = "error"
        FinishIntro()
    end if
end sub
sub OnIntroTimeout(event as Object)
    FinishIntro()
end sub
sub FinishIntro()
    if m.introDone then return
    m.introDone = true
    if m.introTimer <> invalid
        m.introTimer.control = "stop"
        m.introTimer = invalid
    end if
    if m.introAudio <> invalid
        m.introAudio.UnobserveField("state")
        m.introAudio.control = "stop"
        m.introAudio.content = invalid
    end if
    TryEnterHome()
end sub
sub TryEnterHome()
    if m.introDone and m.authDone and not m.enteredHome
        m.enteredHome = true
        ShowHome()
    end if
end sub
function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then return false
    if not m.introDone and (key = "OK" or key = "play" or key = "select")
        FinishIntro()
        return true
    end if
    return false
end function
sub OnShowSettings(event as Object)
    if event.GetData() <> true then return
    m.top.showSettings = false
    m.homeScreen.halt = true
    m.settingsScreen.visible = true
    m.settingsScreen.SetFocus(true)
end sub
sub OnSettingsAction(event as Object)
    action = SafeStr(event.GetData())
    if action = "historyCleared"
        m.homeScreen.CallFunc("ClearHistoryMemory")
    else if action = "favoritesCleared"
        m.homeScreen.CallFunc("ClearFavoritesMemory")
    else if action = "close"
        m.settingsScreen.visible = false
        m.homeScreen.visible = true
        m.homeScreen.SetFocus(true)
    end if
end sub
sub ShowSetup()
    m.enteredHome = false
    m.authDone    = false
    m.introDone   = true
    m.homeScreen.visible  = false
    m.setupScreen.visible = true
    m.setupScreen.busy    = true
    m.setupScreen.SetFocus(true)
    m.setupScreen.status  = "Conectando con XuperTV..."
    m.renewing = false
    m.retryDelay = 0
    RegisterAccount()
end sub
sub ShowHome()
    m.enteredHome = true
    m.setupScreen.busy    = false
    m.setupScreen.visible = false
    m.homeScreen.visible  = true
    m.homeScreen.SetFocus(true)
    m.homeScreen.start = true
end sub
sub OnShowDebug(event as Object)
    if event.GetData() <> true then return
    m.top.showDebug = false
    m.homeScreen.halt = true          ' que no siga sonando nada de fondo
    m.debugScreen.visible = true
    m.debugScreen.SetFocus(true)
end sub
sub OnDebugAction(event as Object)
    action = SafeStr(event.GetData())
    if action = "renew"
        CloseDebug()
        m.top.sessionStale = true      ' re-registra y recarga el Home
    else if action = "wipe"
        v4a24()
        CloseDebug()
        ShowSetup()
    else if action = "close"
        CloseDebug()
        ShowHome()
    end if
end sub
sub CloseDebug()
    m.debugScreen.visible = false
end sub
sub OnSessionStale(event as Object)
    if event.GetData() <> true then return
    m.top.sessionStale = false
    CheckOtaKit(true)
    if m.renewing = true then return
    if not v4a26() then return
    RegisterAccount()
end sub
sub RegisterAccount()
    m.renewing = true
    v4a27()
    m.fp = v4a34()
    t = Api_OpTask("snToken", m.fp)
    if t = invalid
        RenewFailed("sin plantilla de alta")
        return
    end if
    if m.regTask <> invalid then m.regTask.control = "STOP"
    m.regTask = t
    m.regTask.ObserveField("rawResp", "OnRenewSnToken")
    m.regTask.ObserveField("error",   "OnRenewError")
    m.regTask.control = "RUN"
end sub
sub OnRenewSnToken(event as Object)
    data = Api_ParseOp(event.GetData())
    if data = invalid or not IsValidStr(data.snToken)
        RenewFailed("snToken sin token")
        return
    end if
    if IsValidStr(data.sn)
        m.newSn = data.sn
    else
        k = v4a21()
        m.newSn = v4a16(data.snToken + SafeStr(k.snSecret))
    end if
    m.newSnToken = data.snToken
    t = Api_OpTask("active", { snToken: m.newSnToken, sn: m.newSn })
    if t = invalid
        RenewFailed("sin plantilla de activacion")
        return
    end if
    if m.actTask <> invalid then m.actTask.control = "STOP"
    m.actTask = t
    m.actTask.ObserveField("rawResp", "OnRenewActive")
    m.actTask.ObserveField("error",   "OnRenewError")
    m.actTask.control = "RUN"
end sub
sub OnRenewActive(event as Object)
    data = Api_ParseOp(event.GetData())
    if data = invalid or not IsValidStr(data.userId)
        RenewFailed("active sin userId")
        return
    end if
    portalCode = "masnew"
    if data.portalCodeList <> invalid and data.portalCodeList.Count() > 0
        portalCode = data.portalCodeList[0].portalCode
    else if IsValidStr(data.portalCode)
        portalCode = data.portalCode
    end if
    id = v4a27()
    v4a23({
        sn:         m.newSn,
        snToken:    m.newSnToken,
        drmId:      id.drmId,
        reserve1:   id.reserve1,
        userId:     data.userId,
        userToken:  SafeStr(data.userToken),
        portalCode: portalCode,
        kv:         v4a21_activeKv()
    })
    m.renewing = false
    if m.retryTimer <> invalid then m.retryTimer.control = "stop"
    m.authDone = true
    if m.enteredHome
        ShowHome()
    else
        m.setupScreen.busy = false
        TryEnterHome()
    end if
end sub
sub OnRenewError(event as Object)
    RenewFailed(SafeStr(event.GetData()))
end sub
sub RenewFailed(why as String)
    m.renewing = false
    CheckOtaKit(true)
    if v4a26() then return
    if m.retryDelay = invalid or m.retryDelay < 5
        m.retryDelay = 5
    else
        m.retryDelay = m.retryDelay * 2
        if m.retryDelay > 60 then m.retryDelay = 60
    end if
    m.setupScreen.status = "Sin conexion. Reintentando en " + m.retryDelay.ToStr() + " s..."
    if m.retryTimer = invalid
        m.retryTimer = CreateObject("roSGNode", "Timer")
        m.retryTimer.repeat = false
        m.retryTimer.ObserveField("fire", "OnRetryTick")
    end if
    m.retryTimer.control = "stop"
    m.retryTimer.duration = m.retryDelay
    m.retryTimer.control = "start"
end sub
sub OnRetryTick(event as Object)
    if v4a26() then return
    m.setupScreen.status = "Conectando con XuperTV..."
    RegisterAccount()
end sub
sub CheckOtaKit(forceRenew as Boolean)
    nowSec = CreateObject("roDateTime").AsSeconds()
    if m.otaChecking = true then return
    if m.lastOtaAt <> invalid and m.lastOtaAt > 0 and (nowSec - m.lastOtaAt) < 60 then return
    m.lastOtaAt = nowSec
    m.otaChecking = true
    t = CreateObject("roSGNode", "OtaKitTask")
    t.forceRenew = forceRenew
    t.ObserveField("done", "OnOtaDone")
    m.otaTask = t
    t.control = "RUN"
end sub
sub OnOtaDone(event as Object)
    m.otaChecking = false
    t = m.otaTask
    if t = invalid then return
    st = SafeStr(t.status)
    updated = (t.kitUpdated = true)
    needsRenew = (t.needsRenew = true)
    rBuild = AsInt(t.remoteBuild)
    lBuild = AsInt(CreateObject("roAppInfo").GetValue("build_version"))
    print "[XuperOTA] status="; st; " updated="; updated; " needsRenew="; needsRenew; " kitVer="; t.kitVer; " remoteBuild="; rBuild
    v4a21_resetCache()
    msg = "al dia"
    if updated
        Api_ClearPreferredPortalHost()
        msg = "actualizado v" + AsInt(t.kitVer).ToStr()
    else if st = "error_red"
        msg = "sin red"
    end if
    if rBuild > lBuild
        msg = msg + " · ZIP v" + rBuild.ToStr() + " disponible en GitHub"
    end if
    m.top.otaInfo = msg
    if updated and (needsRenew or not v4a26()) and not m.renewing
        RegisterAccount()
    end if
end sub
