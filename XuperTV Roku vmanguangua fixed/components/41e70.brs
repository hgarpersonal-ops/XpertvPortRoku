sub init()
    m.info = m.top.FindNode("deviceInfo")
    m.codec = m.top.FindNode("codecStatus")
    m.codec2 = m.top.FindNode("codecStatus2")
    m.avcMark = m.top.FindNode("avcMark")
    m.hevcMark = m.top.FindNode("hevcMark")
    m.status = m.top.FindNode("status")
    m.labels = [m.top.FindNode("opt0"), m.top.FindNode("opt1"), m.top.FindNode("opt2"), m.top.FindNode("opt3"), m.top.FindNode("opt4")]
    m.bgs = [m.top.FindNode("optBg0"), m.top.FindNode("optBg1"), m.top.FindNode("optBg2"), m.top.FindNode("optBg3"), m.top.FindNode("optBg4")]
    m.idx = 0
    m.confirmAction = ""
    m.pinDlg = invalid
    m.pinStage = ""
    m.firstPin = ""
    m.pinResetTimer = invalid
    m.pinResetDlg = invalid
    m.pinResetMessage = ""
    m.bridgeDlg = invalid
    m.bridgePingTask = invalid
    m.top.ObserveField("visible", "OnSettingsShown")
end sub
sub OnSettingsShown(event as Object)
    if event.GetData() <> true then return
    hw = Hardware_Detect()
    name = SafeStr(hw.modelName)
    if name = "" then name = "Roku " + SafeStr(hw.model)
    mode = SafeStr(hw.videoMode)
    if mode = "" then mode = "No determinado"
    m.info.text = "Modelo: " + name + "   ·   Resolución: " + mode
    m.avcMark.text = "H.264 " + Hardware_Mark(hw.avc)
    m.hevcMark.text = "HEVC/H.265 " + Hardware_Mark(hw.hevc)
    m.avcMark.color = CodecMarkColor(hw.avc)
    m.hevcMark.color = CodecMarkColor(hw.hevc)
    m.codec2.text = ""
    if hw.avc = true and hw.hevc = true
        m.codec.color = "0x34D399FF"
        m.codec.text = "Esta TV puede reproducir películas y series H.264/H.265 compatibles."
    else if hw.avc = true and hw.hevc = false
        m.codec.color = "0x34D399FF"
        m.codec.text = "Esta TV reproduce H.264 directo. Para HEVC (H.265) usa el Puente PC."
        m.codec2.color = "0x56CCF2FF"
        m.codec2.text = "Abre XuperTV-Puente-PC.exe en tu PC para ver películas y series HEVC en esta TV."
    else if hw.avc = invalid or hw.hevc = invalid
        m.codec.color = "0x94A3B8FF"
        m.codec.text = "No se pudo determinar la compatibilidad de video."
    else
        m.codec.color = "0xFF5A6EFF"
        m.codec.text = "El Roku informó incompatibilidad con los perfiles H.264 y HEVC probados; otros formatos o perfiles pueden variar."
    end if
    m.labels[2].text = Tern(v4a10(), "   PIN +18 configurado", "   Configurar PIN +18")
    m.labels[3].visible = v4a10()
    m.bgs[3].visible = m.labels[3].visible
    if not m.labels[3].visible and m.idx = 3 then m.idx = 4
    RefreshBridgeLabel()
    m.status.text = ""
    HighlightSettings()
end sub
sub RefreshBridgeLabel()
    bh = PcBridge_LoadHost()
    if bh = ""
        m.labels[4].text = "   Puente PC (para HEVC): Desactivado   (OK para configurar)"
    else
        m.labels[4].text = "   Puente PC (para HEVC): " + bh + "   (OK probar / cambiar IP)"
    end if
end sub
function CodecMarkColor(value as Dynamic) as String
    if value = invalid then return "0x94A3B8FF"
    if value = true then return "0x34D399FF"
    return "0xFF5A6EFF"
end function
sub HighlightSettings()
    for i = 0 to 4
        active = (i = m.idx and m.labels[i].visible)
        m.bgs[i].color = Tern(active, THEME_ACCENT(), "0x0D162BFF")
        m.labels[i].color = Tern(active, "0xFFFFFFFF", "0xE2E8F0FF")
    end for
end sub
function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then return false
    if key = "back" then m.top.action = "close" : return true
    if key = "up"
        nxt = m.idx - 1
        while nxt >= 0 and not m.labels[nxt].visible
            nxt = nxt - 1
        end while
        if nxt >= 0 then m.idx = nxt : HighlightSettings()
        return true
    end if
    if key = "down"
        nxt = m.idx + 1
        while nxt <= 4 and not m.labels[nxt].visible
            nxt = nxt + 1
        end while
        if nxt <= 4 then m.idx = nxt : HighlightSettings()
        return true
    end if
    if key = "OK" then ActivateSetting() : return true
    return false
end function
sub ActivateSetting()
    if m.idx = 0
        m.confirmAction = "history"
        dlg = CreateObject("roSGNode", "StandardMessageDialog")
        dlg.title = "Borrar historial"
        dlg.message = "¿Quieres eliminar todo el historial guardado en este dispositivo? (Tus canales favoritos se conservarán)."
        dlg.buttons = ["Cancelar", "Sí, borrar historial"]
        m.confirmDlg = dlg
        dlg.ObserveField("buttonSelected", "OnConfirmChoice")
        dlg.ObserveField("wasClosed", "OnConfirmClosed")
        m.top.GetScene().dialog = dlg
    else if m.idx = 1
        m.confirmAction = "favorites"
        dlg = CreateObject("roSGNode", "StandardMessageDialog")
        dlg.title = "Vaciar canales favoritos"
        dlg.message = "¿Quieres quitar todos los canales guardados en tu lista de Favoritos?"
        dlg.buttons = ["Cancelar", "Sí, vaciar favoritos"]
        m.confirmDlg = dlg
        dlg.ObserveField("buttonSelected", "OnConfirmChoice")
        dlg.ObserveField("wasClosed", "OnConfirmClosed")
        m.top.GetScene().dialog = dlg
    else if m.idx = 2 and not v4a10()
        OpenPin("create1", "Crear PIN +18", "Escribe un PIN numérico de 4 dígitos.")
    else if m.idx = 4
        OpenBridgeDialog()
    else
        OpenPin("current", "Cambiar PIN +18", "Escribe el PIN actual.")
    end if
end sub
sub OpenBridgeDialog()
    dlg = CreateObject("roSGNode", "StandardKeyboardDialog")
    dlg.title = "Puente PC para HEVC"
    cur = PcBridge_LoadHost()
    if cur = "" then cur = PcBridge_DefaultHost()
    dlg.message = ["Escribe IP:puerto de tu PC con XuperTV-Puente-PC.exe abierto (ej: " + PcBridge_DefaultHost() + ")."]
    dlg.text = cur
    dlg.buttons = ["Probar y Guardar", "Desactivar", "Cancelar"]
    m.bridgeDlg = dlg
    dlg.ObserveField("buttonSelected", "OnBridgeDlgButton")
    dlg.ObserveField("wasClosed", "OnBridgeDlgClosed")
    m.top.GetScene().dialog = dlg
end sub
sub OnBridgeDlgButton(event as Object)
    dlg = event.GetRoSGNode()
    if dlg = invalid or m.bridgeDlg = invalid or not dlg.isSameNode(m.bridgeDlg) then return
    idx = event.GetData()
    textVal = SafeStr(dlg.text).Trim()
    CloseBridgeDlg(dlg)
    if idx = 0
        PcBridge_SaveHost(textVal)
        RefreshBridgeLabel()
        TestBridgeConnection()
    else if idx = 1
        PcBridge_SaveHost("off")
        RefreshBridgeLabel()
        m.status.color = "0x94A3B8FF"
        m.status.text = "Puente PC desactivado."
    end if
end sub
sub OnBridgeDlgClosed(event as Object)
    dlg = event.GetRoSGNode()
    if dlg = invalid or m.bridgeDlg = invalid or not dlg.isSameNode(m.bridgeDlg) then return
    CloseBridgeDlg(dlg)
end sub
sub CloseBridgeDlg(dlg as Object)
    dlg.UnobserveField("buttonSelected")
    dlg.UnobserveField("wasClosed")
    dlg.close = true
    m.bridgeDlg = invalid
    m.top.SetFocus(true)
end sub
sub TestBridgeConnection()
    host = PcBridge_LoadHost()
    if host = "" then return
    m.status.color = "0x56CCF2FF"
    m.status.text = "Probando conexión con Puente PC (" + host + ")..."
    if m.bridgePingTask <> invalid then m.bridgePingTask.control = "STOP"
    t = CreateObject("roSGNode", "BridgeTask")
    t.action = "ping"
    t.bridgeHost = host
    t.ObserveField("result", "OnBridgePingResult")
    m.bridgePingTask = t
    t.control = "RUN"
end sub
sub OnBridgePingResult(event as Object)
    res = event.GetData()
    if res <> invalid and res.ok = true
        enc = SafeStr(res.encoder)
        m.status.color = "0x34D399FF"
        m.status.text = "✓ Puente PC conectado en " + PcBridge_LoadHost() + " (codificador: " + enc + "). Listo para películas HEVC."
    else
        m.status.color = "0xFF5A6EFF"
        m.status.text = "No responde el Puente PC en " + PcBridge_LoadHost() + ". Abre XuperTV-Puente-PC.exe en tu PC (y permite puerto 8787 en Firewall)."
    end if
end sub
sub OnConfirmChoice(event as Object)
    dlg = event.GetRoSGNode()
    if dlg = invalid or m.confirmDlg = invalid or not dlg.isSameNode(m.confirmDlg) then return
    if event.GetData() = 1
        if m.confirmAction = "favorites"
            ClearLocalFavorites()
        else
            ClearLocalHistory()
        end if
    end if
    CloseConfirm(dlg)
end sub
sub OnConfirmClosed(event as Object)
    dlg = event.GetRoSGNode()
    if dlg = invalid or m.confirmDlg = invalid or not dlg.isSameNode(m.confirmDlg) then return
    CloseConfirm(dlg)
end sub
sub CloseConfirm(dlg as Object)
    dlg.UnobserveField("buttonSelected") : dlg.UnobserveField("wasClosed")
    m.confirmDlg = invalid
    m.confirmAction = ""
    m.top.SetFocus(true)
end sub
sub ClearLocalHistory()
    reg = CreateObject("roRegistrySection", "jglcustoms")
    for each key in ["history", "searchHistory", "lastSearch", "continueWatching", "playbackPositions", "watchProgress"]
        if reg.Exists(key) then reg.Delete(key)
    end for
    if reg.Flush()
        m.status.color = "0x34D399FF"
        m.status.text = "Historial eliminado correctamente. Tus canales favoritos se mantuvieron intactos."
        m.top.action = "historyCleared"
    else
        m.status.color = "0xFF5A6EFF" : m.status.text = "No se pudo eliminar el historial local."
    end if
end sub
sub ClearLocalFavorites()
    reg = CreateObject("roRegistrySection", "jglcustoms")
    if reg.Exists("favorites") then reg.Delete("favorites")
    if reg.Flush()
        m.status.color = "0x34D399FF"
        m.status.text = "Lista de canales favoritos vaciada correctamente."
        m.top.action = "favoritesCleared"
    else
        m.status.color = "0xFF5A6EFF" : m.status.text = "No se pudo vaciar la lista de favoritos."
    end if
end sub
sub OpenPin(stage as String, title as String, message as String)
    wait = v4a13()
    if wait > 0
        m.status.color = "0xFF5A6EFF" : m.status.text = "Demasiados intentos. Espera " + wait.ToStr() + " segundos."
        return
    end if
    dlg = CreateObject("roSGNode", "PinDialog")
    dlg.title = title : dlg.message = message : dlg.buttons = ["Aceptar", "Cancelar"]
    m.pinStage = stage : m.pinDlg = dlg
    dlg.ObserveField("buttonSelected", "OnSettingsPinButton")
    dlg.ObserveField("wasClosed", "OnSettingsPinClosed")
    m.top.GetScene().dialog = dlg
end sub
sub OnSettingsPinButton(event as Object)
    dlg = event.GetRoSGNode()
    if dlg = invalid or m.pinDlg = invalid or not dlg.isSameNode(m.pinDlg) then return
    if event.GetData() <> 0
        CloseSettingsPin(dlg)
        return
    end if
    pin = SafeStr(dlg.pin)
    if Len(pin) <> 4
        SettingsPinScheduleReset(dlg, "El PIN debe tener 4 dígitos.")
        return
    end if
    stage = m.pinStage
    if stage = "current"
        if v4a12(pin)
            v4a15()
            CloseSettingsPin(dlg)
            OpenPin("new1", "PIN nuevo", "Escribe el PIN nuevo de 4 dígitos.")
        else
            wait = v4a14()
            m.status.color = "0xFF5A6EFF"
            if wait > 0
                msg = "Demasiados intentos. Espera " + wait.ToStr() + " segundos."
                m.status.text = msg
            else
                msg = "PIN incorrecto. Inténtalo nuevamente."
                m.status.text = msg
            end if
            SettingsPinScheduleReset(dlg, msg)
        end if
        return
    end if
    CloseSettingsPin(dlg)
    if stage = "create1" or stage = "new1"
        m.firstPin = pin
        OpenPin(Tern(stage = "create1", "create2", "new2"), "Confirmar PIN +18", "Repite el PIN nuevo.")
    else if stage = "create2" or stage = "new2"
        if pin <> m.firstPin
            m.firstPin = "" : m.status.color = "0xFF5A6EFF" : m.status.text = "Los PIN no coinciden. Inténtalo nuevamente."
            OpenPin(Tern(stage = "create2", "create1", "new1"), "PIN +18", "Escribe nuevamente el PIN nuevo.")
        else if v4a11(pin)
            m.firstPin = "" : v4a15()
            m.status.color = "0x34D399FF" : m.status.text = "PIN +18 guardado correctamente."
            RefreshParentalOptions()
        else
            m.status.color = "0xFF5A6EFF" : m.status.text = "No se pudo guardar el PIN."
        end if
    end if
end sub
sub RefreshParentalOptions()
    configured = v4a10()
    m.labels[2].text = Tern(configured, "   PIN +18 configurado", "   Configurar PIN +18")
    m.labels[3].visible = configured
    m.bgs[3].visible = configured
    HighlightSettings()
end sub
sub OnSettingsPinClosed(event as Object)
    dlg = event.GetRoSGNode()
    if dlg = invalid or m.pinDlg = invalid or not dlg.isSameNode(m.pinDlg) then return
    CloseSettingsPin(dlg)
end sub
sub CloseSettingsPin(dlg as Object)
    if m.pinResetTimer <> invalid then m.pinResetTimer.control = "stop"
    m.pinResetTimer = invalid : m.pinResetDlg = invalid
    dlg.UnobserveField("buttonSelected") : dlg.UnobserveField("wasClosed")
    dlg.close = true : m.pinDlg = invalid : m.top.SetFocus(true)
end sub
sub SettingsPinScheduleReset(dlg as Object, message as String)
    if dlg = invalid or m.pinDlg = invalid or not dlg.isSameNode(m.pinDlg) then return
    if m.pinResetTimer <> invalid then m.pinResetTimer.control = "stop"
    m.pinResetDlg = dlg : m.pinResetMessage = message
    timer = CreateObject("roSGNode", "Timer")
    timer.duration = 0.05 : timer.repeat = false
    timer.ObserveField("fire", "OnSettingsPinResetFire")
    m.pinResetTimer = timer
    timer.control = "start"
end sub
sub OnSettingsPinResetFire(event as Object)
    timer = event.GetRoSGNode()
    if timer <> invalid then timer.UnobserveField("fire")
    m.pinResetTimer = invalid
    dlg = m.pinResetDlg : m.pinResetDlg = invalid
    if dlg = invalid or m.pinDlg = invalid or not dlg.isSameNode(m.pinDlg) then return
    dlg.message = m.pinResetMessage
    dlg.messageColor = "0xFF5A6EFF"
    dlg.pin = ""
    dlg.pinPadFocused = true
    if dlg.pinPad <> invalid then dlg.pinPad.SetFocus(true)
end sub
