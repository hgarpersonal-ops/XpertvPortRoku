sub init()
    m.top.functionName = "XuperTask"
end sub
sub XuperTask()
    cand = []
    if m.top.urls <> invalid and m.top.urls.Count() > 0
        for each u in m.top.urls
            if u <> invalid and Type(u) = "String" and u <> "" then cand.Push(u)
        end for
    end if
    if cand.Count() = 0 and m.top.url <> invalid and m.top.url <> ""
        cand.Push(m.top.url)
    end if
    if cand.Count() = 0
        m.top.error = "sin_url"
        return
    end if

    headers = m.top.headers
    body = m.top.body
    maxTry = cand.Count()
    if maxTry > 6 then maxTry = 6
    timeoutMs = 20000
    if maxTry > 1 then timeoutMs = 11000
    lastErr = "sin_respuesta"

    for i = 0 to maxTry - 1
        targetUrl = cand[i]
        req = CreateObject("roUrlTransfer")
        req.SetUrl(targetUrl)
        if headers <> invalid
            for each k in headers
                req.AddHeader(k, headers[k])
            end for
        end if
        req.EnableEncodings(true)
        req.SetCertificatesFile("common:/certs/ca-bundle.crt")
        req.InitClientCertificates()
        port = CreateObject("roMessagePort")
        req.SetMessagePort(port)
        if not req.AsyncPostFromString(body)
            lastErr = "async_fallo"
        else
            msg = wait(timeoutMs, port)
            if msg = invalid
                req.AsyncCancel()
                lastErr = "timeout_" + Int(timeoutMs / 1000).ToStr() + "s"
            else if type(msg) <> "roUrlEvent"
                lastErr = "evento_inesperado"
            else
                code = msg.GetResponseCode()
                if code = 200
                    resp = msg.GetString()
                    if resp <> invalid and Left(resp.Trim(), 1) = "{"
                        if i > 0 then XuperSaveHost(targetUrl)
                        m.top.rawResp = resp
                        return
                    end if
                    lastErr = "respuesta_no_json"
                else
                    lastErr = "http_" + code.ToStr()
                end if
            end if
        end if
    end for

    m.top.error = lastErr
end sub

sub XuperSaveHost(targetUrl as String)
    s = targetUrl.Replace("https://", "").Replace("http://", "")
    sp = Instr(1, s, "/")
    if sp > 0 then s = Left(s, sp - 1)
    h = s.Trim()
    if h = "" then return
    reg = CreateObject("roRegistrySection", "xuper_prefs")
    if reg = invalid then return
    if reg.Exists("portal_host") and reg.Read("portal_host") = h then return
    reg.Write("portal_host", h)
    reg.Flush()
end sub
