sub init()
    m.top.functionName = "RunBridgeTask"
end sub

sub RunBridgeTask()
    gen = m.top.generation
    act = LCase(SafeStr(m.top.action))
    host = SafeStr(m.top.bridgeHost).Trim()
    if host = ""
        m.top.result = { ok: false, generation: gen, error: "sin_host" }
        return
    end if
    if Left(host, 7) <> "http://" and Left(host, 8) <> "https://"
        baseUrl = "http://" + host
    else
        baseUrl = host
    end if

    req = CreateObject("roUrlTransfer")
    port = CreateObject("roMessagePort")
    req.SetMessagePort(port)

    if act = "ping"
        req.SetUrl(baseUrl + "/ping")
        if not req.AsyncGetToString()
            m.top.result = { ok: false, generation: gen, error: "async_fallo" }
            return
        end if
        msg = wait(2000, port)
        if msg = invalid
            req.AsyncCancel()
            m.top.result = { ok: false, generation: gen, error: "timeout" }
            return
        end if
        if type(msg) <> "roUrlEvent" or msg.GetResponseCode() <> 200
            m.top.result = { ok: false, generation: gen, error: "offline" }
            return
        end if
        data = ParseJSON(msg.GetString())
        if data = invalid or data.ok <> true
            m.top.result = { ok: false, generation: gen, error: "respuesta_invalida" }
            return
        end if
        m.top.result = {
            ok: true,
            generation: gen,
            encoder: SafeStr(data.encoder),
            ip: SafeStr(data.ip)
        }
        return
    end if

    if act = "stop"
        req.SetUrl(baseUrl + "/stop")
        req.AddHeader("Content-Type", "application/json")
        if req.AsyncPostFromString("{}")
            wait(1200, port)
        end if
        m.top.result = { ok: true, generation: gen }
        return
    end if

    if act = "session"
        req.SetUrl(baseUrl + "/session")
        req.AddHeader("Content-Type", "application/json; charset=utf-8")
        body = "{}"
        if m.top.payload <> invalid then body = FormatJson(m.top.payload)
        if not req.AsyncPostFromString(body)
            m.top.result = { ok: false, generation: gen, error: "async_fallo" }
            return
        end if
        msg = wait(18000, port)
        if msg = invalid
            req.AsyncCancel()
            m.top.result = { ok: false, generation: gen, error: "timeout" }
            return
        end if
        if type(msg) <> "roUrlEvent"
            m.top.result = { ok: false, generation: gen, error: "evento_inesperado" }
            return
        end if
        code = msg.GetResponseCode()
        if code <> 200
            m.top.result = { ok: false, generation: gen, error: "http_" + code.ToStr() }
            return
        end if
        data = ParseJSON(msg.GetString())
        if data = invalid or data.ok <> true or SafeStr(data.playUrl) = ""
            errStr = "transcode_fallo"
            if data <> invalid and SafeStr(data.error) <> "" then errStr = SafeStr(data.error)
            m.top.result = { ok: false, generation: gen, error: errStr }
            return
        end if
        m.top.result = {
            ok: true,
            generation: gen,
            playUrl: SafeStr(data.playUrl),
            encoder: SafeStr(data.encoder),
            sid: SafeStr(data.sid)
        }
        return
    end if

    m.top.result = { ok: false, generation: gen, error: "accion_desconocida" }
end sub
