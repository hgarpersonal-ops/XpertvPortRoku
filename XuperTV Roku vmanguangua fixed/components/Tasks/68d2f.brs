sub init()
    m.top.functionName = "RunProxy"
end sub
sub RunProxy()
    srcUrl  = m.top.srcUrl
    headers = m.top.headers
    if srcUrl = "" or srcUrl = invalid
        m.top.error = "sin_url"
        return
    end if
    mp = CreateObject("roMessagePort")
    listener = CreateObject("roStreamSocket")
    listener.SetMessagePort(mp)
    addr = CreateObject("roSocketAddress")
    addr.SetPort(PROXY_PORT())
    listener.SetAddress(addr)
    listener.NotifyReadable(true)
    listener.Listen(4)
    if not listener.eOK()
        m.top.error = "socket_fallo"
        return
    end if
    m.top.ready = true
    m.buf = CreateObject("roByteArray")
    m.buf[4096] = 0
    m.srcUrl   = srcUrl
    m.headers  = headers
    m.candUrls = [srcUrl]
    m.candHeaders = [headers]
    fbUrls = m.top.fallbackUrls
    fbHeaders = m.top.fallbackHeaders
    if fbUrls <> invalid
        for i = 0 to fbUrls.Count() - 1
            u = fbUrls[i]
            if u <> invalid and Type(u) = "String" and u <> "" and u <> srcUrl
                m.candUrls.Push(u)
                if fbHeaders <> invalid and i < fbHeaders.Count() and fbHeaders[i] <> invalid
                    m.candHeaders.Push(fbHeaders[i])
                else
                    m.candHeaders.Push(headers)
                end if
            end if
        end for
    end if
    m.candIdx  = 0
    m.hits     = 0
    m.segKeys  = []       ' contadores (string) vistos, ordenados ascendente
    m.segBlk   = {}       ' contador -> bloque de texto del segmento (#EXTINF + url, etc.)
    m.idxOf    = {}       ' contador -> indice de secuencia (MEDIA-SEQUENCE monotono)
    m.hiNum    = -1.0     ' contador mas alto visto (Float)
    m.nextIdx  = 0        ' proximo indice a asignar
    m.headerTpl = ""      ' lineas de cabecera del origen (sin MEDIA-SEQUENCE)
    while true
        wait(250, mp)
        if listener.IsReadable()
            c = listener.Accept()
            if c <> invalid
                ServeOne(c)
            end if
        end if
    end while
end sub
sub ServeOne(c as Object)
    got = false
    for i = 1 to 100
        if c.IsReadable()
            n = c.Receive(m.buf, 0, 4096)
            if n > 0
                got = true
                exit for
            else if n = 0
                exit for
            end if
        end if
        sleep(5)
    end for
    if got
        body = AccumulateAndBuild()
        m.hits = m.hits + 1
        SendManifest(c, body)
    end if
    c.Close()
end sub
function AccumulateAndBuild() as String
    WINDOW_N = 6
    MAX_KEEP = 24
    MAX_TRIES = 3
    gotAny = false
    candCount = m.candUrls.Count()
    for ci = 0 to candCount - 1
        idx = (m.candIdx + ci) mod candCount
        curUrl = m.candUrls[idx]
        curHeaders = m.candHeaders[idx]
        for attempt = 1 to MAX_TRIES
            body = FetchManifest(curUrl, curHeaders)
            if body <> ""
                gotAny = true
                IngestManifest(body)
                if idx <> m.candIdx
                    m.candIdx = idx
                    m.srcUrl = curUrl
                    m.headers = curHeaders
                end if
            end if
        end for
        if gotAny then exit for
    end for
    while m.segKeys.Count() > MAX_KEEP
        oldKey = m.segKeys.Shift()
        m.segBlk.Delete(oldKey)
        m.idxOf.Delete(oldKey)
    end while
    n = m.segKeys.Count()
    if n = 0
        m.servedSeq = -1
        m.servedN   = 0
        return ""
    end if
    startI = n - WINDOW_N
    if startI < 0 then startI = 0
    firstKey = m.segKeys[startI]
    seqBase = m.idxOf[firstKey]
    out = m.headerTpl
    out = out + "#EXT-X-MEDIA-SEQUENCE:" + seqBase.ToStr() + Chr(10)
    for i = startI to n - 1
        out = out + m.segBlk[m.segKeys[i]]
    end for
    m.servedSeq = seqBase
    m.servedN   = n - startI
    return out
end function
sub IngestManifest(body as String)
    lines = body.Split(Chr(10))
    header  = ""
    pending = ""      ' tags del segmento en curso (#EXT-SEGMENT, #EXTINF)
    sawSeg  = false
    for each raw in lines
        ln = raw
        if Right(ln, 1) = Chr(13) then ln = Left(ln, Len(ln) - 1)
        if ln <> ""
            if Left(ln, 7) = "#EXTM3U" or Left(ln, 7) = "#EXT-X-"
                if not sawSeg and Left(ln, 22) <> "#EXT-X-MEDIA-SEQUENCE:"
                    header = header + ln + Chr(10)
                end if
            else if IsSegmentLine(ln)
                sawSeg = true
                block = pending + ln + Chr(10)
                pending = ""
                key = SegKey(ln)
                if key <> "" then AddSeg(key, block)
            else
                pending = pending + ln + Chr(10)
            end if
        end if
    end for
    if header <> "" then m.headerTpl = header
end sub
function IsSegmentLine(ln as String) as Boolean
    if Left(ln, 1) = "#" then return false
    if ln = "" then return false
    lower = LCase(ln)
    if Instr(1, lower, ".ts") > 0 then return true
    if Instr(1, lower, ".aac") > 0 then return true
    if Instr(1, lower, ".m4s") > 0 then return true
    if Instr(1, lower, ".fmp4") > 0 then return true
    if Instr(1, lower, ".mp4") > 0 then return true
    if Instr(1, lower, "http") > 0 or Instr(1, lower, "/") > 0 then return true
    return false
end function
sub AddSeg(key as String, block as String)
    num = Val(key)
    if num <= m.hiNum then return          ' viejo o duplicado: ignorar
    m.segBlk[key]  = block
    m.idxOf[key]   = m.nextIdx
    m.segKeys.Push(key)
    m.nextIdx = m.nextIdx + 1
    m.hiNum   = num
end sub
function SegKey(urlLine as String) as String
    lower = LCase(urlLine)
    for each ext in [".ts", ".m4s", ".fmp4", ".aac", ".mp4"]
        p = Instr(1, lower, ext)
        if p > 0
            base = Left(urlLine, p - 1)
            for j = Len(base) to 1 step -1
                c = Mid(base, j, 1)
                if c = "_" or c = "-" or c = "/" then return Mid(base, j + 1)
            end for
            return base
        end if
    end for
    return ""
end function
function FetchManifest(url as String, headers as Object) as String
    ut = CreateObject("roUrlTransfer")
    ut.SetUrl(url)
    ut.SetCertificatesFile("common:/certs/ca-bundle.crt")
    ut.InitClientCertificates()
    if headers <> invalid
        for each k in headers
            ut.AddHeader(k, headers[k])
        end for
    end if
    ut.AddHeader("Cache-Control", "no-cache")
    ut.SetMinimumTransferRate(100, 8)
    body = ut.GetToString()
    if body = invalid then return ""
    if Instr(1, body, "#EXTM3U") = 0 then return ""
    return body
end function
sub SendManifest(c as Object, body as String)
    CRLF = Chr(13) + Chr(10)
    if body = ""
        out = "HTTP/1.1 503 Service Unavailable" + CRLF + "Content-Length: 0" + CRLF + "Connection: close" + CRLF + CRLF
    else
        head = "HTTP/1.1 200 OK" + CRLF
        head = head + "Content-Type: application/vnd.apple.mpegurl" + CRLF
        head = head + "Content-Length: " + Len(body).ToStr() + CRLF
        head = head + "Cache-Control: no-cache" + CRLF
        head = head + "Connection: close" + CRLF + CRLF
        out = head + body
    end if
    ba = CreateObject("roByteArray")
    ba.FromAsciiString(out)
    total = ba.Count()
    sent  = 0
    while sent < total
        n = c.Send(ba, sent, total - sent)
        if n <= 0 then exit while
        sent = sent + n
    end while
end sub
