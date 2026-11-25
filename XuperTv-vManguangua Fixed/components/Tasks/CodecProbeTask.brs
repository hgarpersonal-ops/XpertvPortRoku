sub init()
    m.top.functionName = "RunCodecProbe"
end sub

sub RunCodecProbe()
    gen = m.top.generation
    items = m.top.items
    if items = invalid or items.Count() = 0
        m.top.done = true
        return
    end if
    k = v4a21()
    if k = invalid
        m.top.done = true
        return
    end if
    slb = ProbeOp(k, "slbInfo", {})
    if slb = invalid or slb.cdn_list = invalid
        m.top.done = true
        return
    end if
    cdns = ProbeCollectVodCdns(slb)
    if cdns.Count() = 0
        m.top.done = true
        return
    end if

    for each item in items
        codec = ProbeSingleItem(k, cdns, item)
        if codec <> ""
            print "[XuperProbe] key="; item.key; " codec="; codec
            m.top.probeResult = { generation: gen, key: item.key, id: item.id, codec: codec }
        end if
        sleep(100)
    end for
    m.top.done = true
end sub

function ProbeCollectVodCdns(slb as Object) as Object
    out = []
    seen = {}
    if slb = invalid or slb.cdn_list = invalid then return out
    for pass = 0 to 1
        for each entry in slb.cdn_list
            if entry <> invalid and SafeStr(entry.tag) = "vod" and entry.url_list <> invalid and entry.url_list.Count() > 0
                authUrl = ""
                for each ul in entry.url_list
                    u = SafeStr(ul.url)
                    if u <> ""
                        isFree = (LCase(SafeStr(ul.tag)) = "free" or Instr(1, u, "tag=free") > 0)
                        isCfl = (LCase(SafeStr(ul.sign_type)) = "cfl" or Instr(1, u, "sign_type=cfl") > 0)
                        if pass = 0 and isFree and isCfl
                            authUrl = u : exit for
                        else if pass = 1 and authUrl = ""
                            authUrl = u
                        end if
                    end if
                end for
                if authUrl <> ""
                    for each rawAddr in [SafeStr(entry.main_addr), SafeStr(entry.spared_addr)]
                        h = ProbeHostOf(rawAddr)
                        if h <> "" and seen[h] = invalid
                            seen[h] = true
                            out.Push({ host: h, auth: authUrl })
                        end if
                    end for
                end if
            end if
        end for
        if out.Count() > 0 and pass = 0 then exit for
    end for
    return out
end function

function ProbeSingleItem(k as Object, cdns as Object, item as Object) as String
    contentId = SafeStr(item.contentId)
    if contentId = "" then return ""
    seriesContentId = SafeStr(item.seriesContentId)
    columnId = AsInt(item.columnId)
    if columnId <= 0 then columnId = 87026

    if item.isSeries = true and seriesContentId = ""
        detail = ProbeOp(k, "itemData", { contentId: contentId })
        if detail = invalid then return ""
        ad = detail.assetData
        if ad = invalid then ad = detail
        if ad.simpleProgramList = invalid or ad.simpleProgramList.Count() = 0 then return ""
        ep0 = ad.simpleProgramList[0]
        epId = SafeStr(ep0.contentId)
        if epId = "" then return ""
        seriesContentId = contentId
        contentId = epId
        columnId = 0
    end if

    op = "playVod"
    args = { contentId: contentId, columnId: columnId }
    if seriesContentId <> ""
        op = "playVodEp"
        args.seriesContentId = seriesContentId
    end if
    licData = ProbeOp(k, op, args)
    if licData = invalid or licData.episodeList = invalid or licData.episodeList.Count() = 0 then return ""
    ep = licData.episodeList[0]
    if ep.totalMovieList = invalid or ep.totalMovieList.Count() = 0 then return ""

    detectedFallback = ""
    seen = {}
    for each tm in ep.totalMovieList
        if tm.movieList <> invalid
            for each mv in tm.movieList
                mediaCode = SafeStr(mv.contentId)
                license = ""
                if mv.licenseList <> invalid and mv.licenseList.Count() > 0
                    license = SafeStr(mv.licenseList[0].license)
                end if
                if mediaCode <> "" and license <> "" and seen[mediaCode] = invalid
                    seen[mediaCode] = true
                    metaCodec = Hardware_CodecFromMetadata(mv)
                    if metaCodec = "" then metaCodec = Hardware_CodecFromMetadata(tm)
                    if metaCodec = "" then metaCodec = Hardware_CodecFromMetadata(ep)
                    if metaCodec = "H.264/AVC" then return "H.264/AVC"
                    if metaCodec <> "" and detectedFallback = "" then detectedFallback = metaCodec

                    if metaCodec = ""
                        vfmt = LCase(SafeStr(mv.videoFormat))
                        c = ProbeVariantBytes(k, cdns, mediaCode, license, vfmt)
                        if c = "H.264/AVC" then return "H.264/AVC"
                        if c <> "" and detectedFallback = "" then detectedFallback = c
                    end if
                end if
            end for
        end if
    end for
    return detectedFallback
end function

function ProbeVariantBytes(k as Object, cdns as Object, mediaCode as String, license as String, videoFmt = "" as String) as String
    exts = ["ts"]
    if videoFmt = "mp4" then exts = ["mp4", "ts"]
    for each ext in exts
        for each cdn in cdns
            url = v4a28(k.vodUrl, { host: cdn.host, code: mediaCode })
            if ext = "mp4"
                url = url.Replace("_media.ts", "_media.mp4")
            end if
            headers = ProbeStreamHeaders(k, cdn.auth, license)
            lower = LCase(url)
            qPos = Instr(1, lower, "?")
            path = lower
            if qPos > 0 then path = Left(lower, qPos - 1)
            if Right(path, 5) = ".m3u8"
                c = ProbeHlsManifest(url, headers)
                if c <> "" then return c
            else if ProbeSupportsRange(url, headers)
                ba = FetchByteRange(url, headers, 0, 65535)
                if ba <> invalid and ba.Count() >= 376
                    c = DetectCodecFromBytes(ba)
                    if c <> "" then return c
                end if
            end if
        end for
    end for
    return ""
end function

function ProbeHlsManifest(url as String, headers as Object) as String
    req = NewHttpReq(url, headers)
    port = CreateObject("roMessagePort")
    req.SetMessagePort(port)
    if not req.AsyncGetToString() then return ""
    msg = wait(4000, port)
    if type(msg) <> "roUrlEvent" or msg.GetResponseCode() < 200 or msg.GetResponseCode() >= 300 then return ""
    body = LCase(SafeStr(msg.GetString()))
    if Instr(1, body, "avc1") > 0 or Instr(1, body, "avc3") > 0 then return "H.264/AVC"
    if Instr(1, body, "hvc1") > 0 or Instr(1, body, "hev1") > 0 then return "H.265/HEVC"
    return ""
end function

function ProbeSupportsRange(url as String, headers as Object) as Boolean
    req = NewHttpReq(url, headers)
    req.AddHeader("Range", "bytes=0-0")
    port = CreateObject("roMessagePort")
    req.SetMessagePort(port)
    if not req.AsyncGetToString() then return false
    msg = wait(4000, port)
    if msg = invalid
        req.AsyncCancel()
        return false
    end if
    if type(msg) <> "roUrlEvent" then return false
    return msg.GetResponseCode() = 206
end function

function FetchByteRange(url as String, headers as Object, startByte as Integer, endByte as Integer) as Dynamic
    tmp = "tmp:/cprobe_" + Str(Rnd(2147483647)).Trim() + ".bin"
    req = NewHttpReq(url, headers)
    req.AddHeader("Range", "bytes=" + startByte.ToStr() + "-" + endByte.ToStr())
    port = CreateObject("roMessagePort")
    req.SetMessagePort(port)
    if not req.AsyncGetToFile(tmp) then return invalid
    msg = wait(5000, port)
    if msg = invalid
        req.AsyncCancel()
        DeleteFile(tmp)
        return invalid
    end if
    if type(msg) <> "roUrlEvent"
        DeleteFile(tmp)
        return invalid
    end if
    code = msg.GetResponseCode()
    if code <> 206
        DeleteFile(tmp)
        return invalid
    end if
    ba = CreateObject("roByteArray")
    ok = ba.ReadFile(tmp)
    DeleteFile(tmp)
    if not ok then return invalid
    return ba
end function

function DetectCodecFromBytes(ba as Object) as String
    n = ba.Count()
    if n < 376 then return ""
    ' 1. Try MPEG-TS sync alignment (0x47 = 71)
    syncOff = -1
    for i = 0 to 187
        if i + 376 < n and ba[i] = 71 and ba[i + 188] = 71 and ba[i + 376] = 71
            syncOff = i
            exit for
        end if
    end for
    if syncOff >= 0
        c = ParseMpegTsCodec(ba, syncOff)
        if c <> "" then return c
    end if
    ' 2. Fallback: MP4/ISO-BMFF FourCC scan in first bytes
    ascii = LCase(ba.ToAsciiString())
    if Instr(1, ascii, "avc1") > 0 or Instr(1, ascii, "avc3") > 0 then return "H.264/AVC"
    if Instr(1, ascii, "hvc1") > 0 or Instr(1, ascii, "hev1") > 0 then return "H.265/HEVC"
    return ""
end function

function ParseMpegTsCodec(ba as Object, startOff as Integer) as String
    n = ba.Count()
    pmtPids = {}
    pktOff = startOff
    while pktOff + 188 <= n
        if ba[pktOff] <> 71 then exit while
        b1 = ba[pktOff + 1]
        b2 = ba[pktOff + 2]
        b3 = ba[pktOff + 3]
        pid = ((b1 and 31) * 256) + b2
        pusi = (b1 and 64) <> 0
        afc = Int(b3 / 16) and 3
        if (afc and 1) <> 0 and pusi
            p = pktOff + 4
            if (afc and 2) <> 0 and p < pktOff + 188
                p = p + 1 + ba[p]
            end if
            if p < pktOff + 188
                pointer = ba[p]
                p = p + 1 + pointer
                if p + 8 < pktOff + 188
                    if pid = 0 and ba[p] = 0
                        secLen = ((ba[p + 1] and 15) * 256) + ba[p + 2]
                        endSec = p + 3 + secLen - 4
                        if endSec > pktOff + 188 then endSec = pktOff + 188
                        k = p + 8
                        while k + 4 <= endSec
                            progNum = (ba[k] * 256) + ba[k + 1]
                            pmtPid = ((ba[k + 2] and 31) * 256) + ba[k + 3]
                            if progNum <> 0 then pmtPids[pmtPid.ToStr()] = true
                            k = k + 4
                        end while
                    else if pmtPids[pid.ToStr()] = true and ba[p] = 2 and p + 12 < pktOff + 188
                        secLen = ((ba[p + 1] and 15) * 256) + ba[p + 2]
                        progInfoLen = ((ba[p + 10] and 15) * 256) + ba[p + 11]
                        esPos = p + 12 + progInfoLen
                        endSec = p + 3 + secLen - 4
                        if endSec > pktOff + 188 then endSec = pktOff + 188
                        while esPos + 5 <= endSec
                            st = ba[esPos]
                            if st = 27 then return "H.264/AVC"
                            if st = 36 then return "H.265/HEVC"
                            if st = 2 or st = 1 then return "MPEG-2"
                            esInfoLen = ((ba[esPos + 3] and 15) * 256) + ba[esPos + 4]
                            esPos = esPos + 5 + esInfoLen
                        end while
                    end if
                end if
            end if
        end if
        pktOff = pktOff + 188
    end while
    return ""
end function

function ProbeOp(k as Object, op as String, args as Object) as Dynamic
    body = v4a32(op, args)
    if body = "" then return invalid
    urls = Api_BuildPortalUrls(op, k)
    if urls.Count() = 0 then return invalid
    maxTry = urls.Count()
    if maxTry > 4 then maxTry = 4
    for i = 0 to maxTry - 1
        targetUrl = urls[i]
        req = NewHttpReq(targetUrl, k.headers)
        req.EnableEncodings(true)
        port = CreateObject("roMessagePort")
        req.SetMessagePort(port)
        if req.AsyncPostFromString(body)
            msg = wait(6500, port)
            if msg = invalid
                req.AsyncCancel()
            else if type(msg) = "roUrlEvent" and msg.GetResponseCode() = 200
                outer = ParseJSON(msg.GetString())
                if outer <> invalid
                    if i > 0 then Api_SavePreferredPortalHost(Api_HostFromUrl(targetUrl))
                    if SafeStr(outer.returnCode) <> "0" then return invalid
                    if Type(outer.data) = "String" or Type(outer.data) = "roString"
                        if outer.data <> ""
                            plain = v4a05(outer.data, k.key)
                            if plain = "" then return invalid
                            return ParseJSON(plain)
                        end if
                    end if
                    return outer.data
                end if
            end if
        end if
    end for
    return invalid
end function

function NewHttpReq(url as String, headers as Object) as Object
    req = CreateObject("roUrlTransfer")
    req.SetUrl(url)
    if headers <> invalid
        for each h in headers
            req.AddHeader(h, headers[h])
        end for
    end if
    req.SetCertificatesFile("common:/certs/ca-bundle.crt")
    req.InitClientCertificates()
    return req
end function

function ProbeStreamHeaders(k as Object, contentAuth as String, license as String) as Object
    h = {}
    if k.streamHeaders <> invalid
        for each name in k.streamHeaders
            h[name] = k.streamHeaders[name]
        end for
    end if
    h["Content-Auth"] = contentAuth
    h["Content-License"] = license
    return h
end function

function ProbeHostOf(mainAddr as String) as String
    h = mainAddr.Replace("https://", "").Replace("http://", "")
    sp = Instr(1, h, "/")
    if sp > 0 then h = Left(h, sp - 1)
    return h
end function
