sub init()
    m.info    = m.top.FindNode("dbgInfo")
    m.items   = [m.top.FindNode("dbgOpt0"), m.top.FindNode("dbgOpt1"), m.top.FindNode("dbgOpt2")]
    m.bgs     = [m.top.FindNode("dbgBg0"),  m.top.FindNode("dbgBg1"),  m.top.FindNode("dbgBg2")]
    m.note    = m.top.FindNode("dbgNote")
    m.idx     = 0
    m.top.ObserveField("visible", "OnShown")
end sub
sub OnShown(event as Object)
    if event.GetData() <> true then return
    m.idx = 0
    m.note.text = ""
    Fill()
    Highlight()
end sub
sub Fill()
    di = CreateObject("roDeviceInfo")
    ai = CreateObject("roAppInfo")
    s  = v4a25()
    k  = v4a21()
    otaSrc = "paquete local"
    if k <> invalid and SafeStr(k._source) = "ota" then otaSrc = "GitHub OTA"
    kitV = ""
    if k <> invalid and k.kitVersion <> invalid then kitV = " v" + AsInt(k.kitVersion).ToStr()
    otaTxt = SafeStr(m.top.GetScene().otaInfo)
    modo = "auto-activado (" + otaSrc + kitV + ")"
    if otaTxt <> "" then modo = modo + " · " + otaTxt
    sn = SafeStr(s.sn)
    if Len(sn) > 12 then sn = Left(sn, 12) + "..."
    drm = SafeStr(s.drmId)
    if Len(drm) > 10 then drm = Left(drm, 10) + "..."
    t = ""
    t = t + "Equipo (drmId):     " + drm + Chr(10)
    t = t + "Version del canal:  " + ai.GetValue("major_version") + "." + ai.GetValue("minor_version") + "." + ai.GetValue("build_version") + " · Edición Manguangua (by wastrike)" + Chr(10)
    t = t + "Modo:               " + modo + Chr(10)
    t = t + "Cuenta (userId):    " + SafeStr(s.userId) + Chr(10)
    t = t + "Serie (sn):         " + sn + Chr(10)
    t = t + "Portal:             " + SafeStr(s.portalCode) + Chr(10)
    home = m.top.GetScene().FindNode("homeScreen")
    hw = invalid
    currentFormat = ""
    if home <> invalid
        hw = home.hardwareInfo
        player = home.FindNode("player")
        if player <> invalid then currentFormat = SafeStr(player.detectedVideoFormat)
    end if
    if hw = invalid then hw = Hardware_Detect()
    t = t + Hardware_DetailText(hw, currentFormat)
    m.info.text = t
end sub
sub Highlight()
    for i = 0 to m.items.Count() - 1
        sel = (i = m.idx)
        m.bgs[i].color = Tern(sel, THEME_ACCENT(), THEME_SURFACE2())
        m.items[i].color = Tern(sel, "0x0D0E12FF", THEME_TEXT())
    end for
end sub
function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then return false
    if key = "up"
        if m.idx > 0 then m.idx = m.idx - 1
        Highlight()
        return true
    else if key = "down"
        if m.idx < m.items.Count() - 1 then m.idx = m.idx + 1
        Highlight()
        return true
    else if key = "back"
        m.top.action = "close"
        return true
    else if key = "OK"
        Activate()
        return true
    end if
    return false
end function
sub Activate()
    if m.idx = 0
        m.note.text = "Renovando cuenta..."
        m.top.action = "renew"
    else if m.idx = 1
        m.note.text = "Creando una cuenta nueva..."
        m.top.action = "wipe"
    else
        m.top.action = "close"
    end if
end sub
