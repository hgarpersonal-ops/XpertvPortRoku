sub init()
    m.video       = m.top.FindNode("video")
    m.playerBg    = m.top.FindNode("playerBg")
    m.spinner     = m.top.FindNode("spinner")
    m.osd         = m.top.FindNode("osd")
    m.liveOsd     = m.top.FindNode("liveOsd")
    m.liveOsdLogo = m.top.FindNode("liveOsdLogo")
    m.liveOsdTitle = m.top.FindNode("liveOsdTitle")
    m.liveOsdCategory = m.top.FindNode("liveOsdCategory")
    m.liveStatus = m.top.FindNode("liveStatus")
    m.liveStatusLabel = m.top.FindNode("liveStatusLabel")
    m.osdTitle    = m.top.FindNode("osdTitle")
    m.osdProgram  = m.top.FindNode("osdProgram")
    m.osdLogo     = m.top.FindNode("osdLogo")
    m.osdCategory = m.top.FindNode("osdCategory")
    m.osdClock    = m.top.FindNode("osdClock")
    m.osdChNumber = m.top.FindNode("osdChNumber")
    m.liveBadge   = m.top.FindNode("liveBadge")
    m.liveBadgeLbl= m.top.FindNode("liveBadgeLbl")
    m.directoBadge= m.top.FindNode("directoBadge")
    m.directoLbl  = m.top.FindNode("directoLbl")
    m.progressFill= m.top.FindNode("progressFill")
    m.avInfo      = m.top.FindNode("avInfo")
    m.subGroup    = m.top.FindNode("subGroup")
    m.subLabel    = m.top.FindNode("subLabel")
    m.subShadow   = m.top.FindNode("subShadow")
    m.vodSubs     = []
    m.subTracks   = []
    m.subCues     = []
    m.subCache    = {}
    m.subLangIdx  = -1        ' -1 = apagado
    m.subCueIdx   = 0         ' cursor: última cue mostrada
    m.subOffset   = 2.0
    m.srtTask     = invalid
    m.slbTask    = invalid
    m.licTask    = invalid
    m.streamTask = invalid
    m.probeTask  = invalid
    m.proxyTask  = invalid
    m.slbData    = invalid
    m.liveAddr   = invalid
    m.streamHeaders = invalid
    m.lastDirectUrl = ""
    m.osdMode = "live"
    m.playGeneration = 0
    m.playStartedAt = 0
    m.previousVideoState = "none"
    m.liveGen = 0
    m.vodGen = 0
    m.vodPlaybackState = "PLAYBACK_CANCELLED"
    m.top.vodPlaybackState = m.vodPlaybackState
    m.acceptLiveVideoEvents = true
    m.video.enableUI = false
    m.video.enableTrickPlay = false
    m.clockTimer = CreateObject("roSGNode", "Timer")
    m.clockTimer.duration = 15
    m.clockTimer.repeat   = true
    m.clockTimer.ObserveField("fire", "UpdateClock")
    m.clockTimer.control  = "start"
    m.playingVod   = false
    m.vodUrls      = invalid
    m.vodUrlIdx    = 0
    m.slbDataVod   = invalid
    m.vodLicense   = invalid
    m.vodMediaCode = ""
    m.vodVariants = []
    m.vodVariantIdx = 0
    m.vodProbeAttempt = 0
    m.vodFallbackTimer = invalid
    m.vodIgnoreTerminal = false
    m.hardwareInfo = Hardware_Detect()
    m.video.ObserveField("state", "OnVideoState")
    m.video.ObserveField("position", "OnPosition")
    m.video.ObserveField("videoFormat", "OnVideoFormat")
    m.video.ObserveField("audioFormat", "OnAudioFormat")
    m.top.ObserveField("channelCode",  "OnChannelCodeSet")
    m.top.ObserveField("vodContentId", "OnVodContentSet")
    m.top.ObserveField("vodUrl",       "OnVodUrlSet")
    m.top.ObserveField("control",      "OnControlChanged")
    m.top.ObserveField("poke",         "OnPoke")
    m.top.ObserveField("transport",    "OnTransport")
    m.top.ObserveField("displayMode",  "OnDisplayMode")
    m.liveOsdFavGroup = m.top.FindNode("liveOsdFavGroup")
    m.top.ObserveField("statusMessage", "OnStatusMessage")
    m.top.ObserveField("isFavorite", "OnFavoriteChanged")
    m.vodDuration = 0
    m.slbCacheData = invalid
    m.slbCacheAt = 0
    m.liveChannelCode = ""
    m.liveColumnId = 76182
    m.liveLicAttempt = 0
    m.liveBackupUrls = []
    m.liveBackupHeaders = []
    m.bridgeTask = invalid
    m.bridgeStopTask = invalid
    m.bridgeUsed = false
    m.playingBridge = false
    m.bestBridgeVariant = invalid
end sub
sub OnFavoriteChanged(event as Object)
    isFav = (event.GetData() = true)
    if m.liveOsdFavGroup <> invalid
        m.liveOsdFavGroup.visible = isFav
        if m.liveOsdCategory <> invalid
            m.liveOsdCategory.translation = Tern(isFav, [446, 929], [298, 929])
            m.liveOsdCategory.width = Tern(isFav, 560, 708)
        end if
    end if
end sub
sub OnStatusMessage(event as Object)
    msg = SafeStr(event.GetData())
    m.liveStatusLabel.text = msg
    m.liveStatus.visible = (msg <> "" and m.top.displayMode = "fullscreen")
end sub
sub OnVideoFormat(event as Object)
    raw = SafeStr(event.GetData())
    m.top.detectedVideoFormat = raw
    codec = Hardware_CodecLabel(raw)
    if codec <> "" and not m.bridgeUsed then m.top.detectedVideoCodec = codec
end sub
sub OnAudioFormat(event as Object)
    raw = SafeStr(event.GetData())
    if raw <> "" then m.top.detectedAudioFormat = raw
end sub
sub OnDisplayMode(event as Object)
    mode = SafeStr(event.GetData())
    if mode = "embedded"
        m.playerBg.translation = [340, 146]
        m.playerBg.width = 1044
        m.playerBg.height = 588
        m.video.translation = [340, 146]
        m.video.width = 1044
        m.video.height = 588
        m.osd.visible = false
        m.liveOsd.visible = false
        m.liveStatus.visible = false
        m.spinner.translation = [832, 410]
    else
        m.playerBg.translation = [0, 0]
        m.playerBg.width = 1920
        m.playerBg.height = 1080
        m.video.translation = [0, 0]
        m.video.width = 1920
        m.video.height = 1080
        m.liveStatus.visible = (SafeStr(m.top.statusMessage) <> "")
        m.spinner.translation = [920, 490]
    end if
end sub
sub OnTransport(event as Object)
    cmd = event.GetData()
    if cmd = "cyclesub"
        CycleSub()
    else if cmd = "playpause"
        if m.video.state = "paused"
            m.video.control = "resume"
            FlashAV("Reproduciendo")
        else
            m.video.control = "pause"
            FlashAV("Pausa")
        end if
    else if cmd = "seekfwd"
        SeekBy(15)
    else if cmd = "seekback"
        SeekBy(-15)
    else if cmd = "sublater"
        NudgeSub(0.5)
    else if cmd = "subearlier"
        NudgeSub(-0.5)
    end if
    ShowOSD()
end sub
sub NudgeSub(delta as Float)
    m.subOffset = m.subOffset + delta
    RenderSubAt(CurPos())
    sign = "+"
    if m.subOffset < 0 then sign = ""
    FlashAV("Sub sync: " + sign + Str(m.subOffset).Trim() + "s")
end sub
sub SeekBy(secs as Integer)
    posn = m.video.position
    if posn = invalid then posn = 0
    target = posn + secs
    if target < 0 then target = 0
    if m.vodDuration > 0 and target > m.vodDuration - 2 then target = m.vodDuration - 2
    m.video.seek = target
    FlashAV(Tern(secs > 0, "Avance +", "Retroceso -") + Abs(secs).ToStr() + "s")
end sub
sub OnVodContentSet(event as Object)
    contentId = event.GetData()
    if contentId = "" then return
    m.vodGen = m.vodGen + 1
    SetVodPlaybackState("PLAYBACK_LOADING")
    ClearPlaybackError()
    m.acceptLiveVideoEvents = false
    m.osdMode = "vod"
    m.top.detectedVideoCodec = ""
    m.liveOsd.visible = false
    m.spinner.visible = true
    m.osdTitle.text    = m.top.channelName
    m.osdCategory.text = SafeStr(m.top.channelCategory)
    m.osdChNumber.text = ""
    m.osdLogo.uri       = SafeStr(m.top.channelLogo)
    m.liveBadge.visible = false
    m.liveBadgeLbl.visible = false
    m.directoBadge.visible = false
    m.directoLbl.visible = false
    m.progressFill.visible = false
    backHint = m.top.FindNode("backHint")
    if backHint <> invalid then backHint.text = "OK Pausa   <> Avanzar   Arriba Subtitulos   << >> Ajustar sync   Back Salir"
    m.vodUrls           = invalid
    m.vodUrlHeaders     = invalid
    m.slbDataVod        = invalid
    m.vodLicense        = invalid
    m.bridgeUsed        = false
    m.playingBridge     = false
    m.bestBridgeVariant = invalid
    if m.bridgeTask <> invalid then m.bridgeTask.control = "STOP"
    columnId = m.top.columnId
    if columnId = invalid then columnId = 87026
    seriesContentId = SafeStr(m.top.vodSeriesContentId)   ' "" = película; <serie> = episodio
    op = "playVod"
    args = { contentId: contentId, columnId: columnId }
    if IsValidStr(seriesContentId)
        op = "playVodEp"
        args.seriesContentId = seriesContentId
    end if
    cachedSlb = GetCachedSlb()
    if cachedSlb <> invalid
        m.slbDataVod = cachedSlb
    else
        slb = Api_OpTask("slbInfo", {})
        if slb = invalid
            m.top.state = "error"
            return
        end if
        slb.generation = m.vodGen
        if m.slbTask <> invalid then m.slbTask.control = "STOP"
        m.slbTask = slb
        m.slbTask.ObserveField("rawResp", "OnVodSlbResp")
        m.slbTask.ObserveField("error",   "OnVodStreamError")
        m.slbTask.control = "RUN"
    end if
    lic = Api_OpTask(op, args)
    if lic = invalid
        m.top.state = "error"
        return
    end if
    lic.generation = m.vodGen
    if m.licTask <> invalid then m.licTask.control = "STOP"
    m.licTask = lic
    m.licTask.ObserveField("rawResp", "OnVodLicResp")
    m.licTask.ObserveField("error",   "OnVodStreamError")
    m.licTask.control = "RUN"
end sub
function GetCachedSlb() as Dynamic
    if m.slbCacheData = invalid then return invalid
    nowSec = CreateObject("roDateTime").AsSeconds()
    if nowSec - m.slbCacheAt > 300
        m.slbCacheData = invalid
        return invalid
    end if
    return m.slbCacheData
end function
sub SaveCachedSlb(data as Object)
    if data = invalid or data.cdn_list = invalid then return
    m.slbCacheData = data
    m.slbCacheAt = CreateObject("roDateTime").AsSeconds()
end sub
sub OnVodSlbResp(event as Object)
    src = event.GetRoSGNode()
    if src = invalid or src.generation <> m.vodGen then return
    data = Api_ParseOp(event.GetData())
    if data = invalid or data.cdn_list = invalid
        m.slbCacheData = invalid
        m.top.state = "error"
        return
    end if
    SaveCachedSlb(data)
    m.slbDataVod = data
    TryStartVod()
end sub
sub OnVodLicResp(event as Object)
    src = event.GetRoSGNode()
    if src = invalid or src.generation <> m.vodGen then return
    lic = ExtractVodLicense(Api_ParseOp(event.GetData()))
    if lic = invalid
        m.top.state = "error"
        return
    end if
    m.vodVariants  = lic.variants
    m.vodLicense   = lic.variants
    m.vodSubs      = lic.subs        ' [{lang, url}] subtítulos .srt externos
    m.vodDuration  = lic.duration
    TryStartVod()
end sub
function ExtractVodLicense(data as Object) as Dynamic
    if data = invalid or data.episodeList = invalid or data.episodeList.Count() = 0 then return invalid
    ep = data.episodeList[0]
    if ep.totalMovieList = invalid or ep.totalMovieList.Count() = 0 then return invalid
    subs = []
    if ep.subtitleList <> invalid
        for each s in ep.subtitleList
            if s <> invalid and s.file <> invalid and s.file.Count() > 0
                subUrl = SafeStr(s.file[0].url).Trim()
                if subUrl <> ""
                    subs.Push({ lang: SafeStr(s.language), url: subUrl })
                end if
            end if
        end for
    end if
    variants = []
    seen = {}
    duration = 0
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
                    codec = Hardware_CodecFromMetadata(mv)
                    if codec = "" then codec = Hardware_CodecFromMetadata(tm)
                    if codec = "" then codec = Hardware_CodecFromMetadata(ep)
                    itemDuration = VodDurationOf(mv, ep)
                    if duration = 0 and itemDuration > 0 then duration = itemDuration
                    rawEnc = LCase(SafeStr(mv.encodeFormat))
                    vfmt = LCase(SafeStr(mv.videoFormat))
                    audioInfo = VodFirstStr(mv, tm, ep, ["audioInfo", "audio", "language", "lang"])
                    qText = VodFirstStr(mv, tm, ep, ["quality", "resolution", "videoResolution"])
                    variants.Push({
                        mediaCode: mediaCode,
                        license: license,
                        codec: codec,
                        rawEncode: rawEnc,
                        videoFormat: vfmt,
                        audioInfo: audioInfo,
                        quality: qText,
                        height: VodTrackHeight(mv, tm, qText),
                        bitrateKbps: VodTrackBitrate(mv),
                        frameRate: VodTrackNumber(mv, ["frameRate", "fps", "videoFps"]),
                        duration: itemDuration
                    })
                end if
            end for
        end if
    end for
    if variants.Count() = 0 then return invalid
    return { variants: variants, subs: subs, duration: duration }
end function
function VodFirstStr(mv as Object, tm as Object, ep as Object, keys as Object) as String
    for each src in [mv, tm, ep]
        if src <> invalid
            for each k in keys
                v = SafeStr(src[k]).Trim()
                if v <> "" then return v
            end for
        end if
    end for
    return ""
end function
function VodTrackNumber(src as Object, keys as Object) as Float
    if src = invalid then return 0.0
    for each k in keys
        s = SafeStr(src[k]).Trim()
        if s <> ""
            n = Val(s)
            if n > 0 then return n
        end if
    end for
    return 0.0
end function
function VodTrackBitrate(mv as Object) as Float
    if mv = invalid then return 0.0
    for each k in ["videoBitrate", "videoBitRate", "bitrate", "bitRate", "rate"]
        s = SafeStr(mv[k]).Trim()
        if s <> ""
            n = Val(s)
            if n > 0
                l = LCase(s)
                if Instr(1, l, "mbps") > 0 or Right(l, 1) = "m" then return n * 1000.0
                if n > 10000 then return n / 1000.0
                return n
            end if
        end if
    end for
    return 0.0
end function
function VodTrackHeight(mv as Object, tm as Object, qText as String) as Integer
    h = Int(VodTrackNumber(mv, ["videoHeight", "height", "pixelHeight"]))
    if h > 0 then return h
    h = Int(VodTrackNumber(tm, ["videoHeight", "height", "pixelHeight"]))
    if h > 0 then return h
    q = LCase(qText)
    if Instr(1, q, "2160") > 0 or Instr(1, q, "4k") > 0 or Instr(1, q, "uhd") > 0 then return 2160
    if Instr(1, q, "1440") > 0 then return 1440
    if Instr(1, q, "1080") > 0 or Instr(1, q, "fhd") > 0 then return 1080
    if Instr(1, q, "720") > 0 or Instr(1, q, "hd") > 0 then return 720
    if Instr(1, q, "480") > 0 or Instr(1, q, "sd") > 0 then return 480
    return 0
end function
function VodDurationOf(mv as Object, ep as Object) as Integer
    for each src in [mv, ep]
        if src <> invalid
            for each k in ["duration", "timeLen", "totalTime", "time", "playTime", "length"]
                v = src[k]
                if v <> invalid
                    s = SafeStr(v).Trim()
                    if s <> ""
                        if Instr(1, s, ":") > 0
                            parts = s.Split(":")
                            if parts.Count() = 3
                                secs = Int(Val(parts[0])) * 3600 + Int(Val(parts[1])) * 60 + Int(Val(parts[2]))
                                if secs > 0 then return secs
                            else if parts.Count() = 2
                                secs = Int(Val(parts[0])) * 60 + Int(Val(parts[1]))
                                if secs > 0 then return secs
                            end if
                        end if
                        n = Val(s)
                        if n > 100000 then n = n / 1000
                        ni = Int(n)
                        if ni > 0 then return ni
                    end if
                end if
            end for
        end if
    end for
    return 0
end function
function VodCollectCdns(slbData as Object) as Object
    out = []
    seen = {}
    if slbData = invalid or slbData.cdn_list = invalid then return out
    for pass = 0 to 2
        for each entry in slbData.cdn_list
            if entry <> invalid and SafeStr(entry.tag) = "vod" and entry.url_list <> invalid and entry.url_list.Count() > 0
                authUrl = ""
                for each ul in entry.url_list
                    u = SafeStr(ul.url).Trim()
                    if u <> ""
                        isFree = (LCase(SafeStr(ul.tag)) = "free" or Instr(1, u, "tag=free") > 0)
                        isCfl  = (LCase(SafeStr(ul.sign_type)) = "cfl" or Instr(1, u, "sign_type=cfl") > 0)
                        if pass = 0 and isFree and isCfl
                            authUrl = u : exit for
                        else if pass = 1 and isFree
                            authUrl = u : exit for
                        else if pass = 2 and authUrl = ""
                            authUrl = u
                        end if
                    end if
                end for
                if authUrl <> ""
                    for each rawAddr in [SafeStr(entry.main_addr), SafeStr(entry.spared_addr)]
                        h = HostOf(rawAddr)
                        if h <> "" and seen[h] = invalid
                            seen[h] = true
                            out.Push({ host: h, auth: authUrl })
                        end if
                    end for
                end if
            end if
        end for
        if out.Count() > 0 and pass < 2 then exit for
    end for
    return out
end function
function VodAudioPenalty(audioText as String) as Integer
    a = LCase(audioText)
    if a = "" then return 0
    if Instr(1, a, "latino") > 0 or Instr(1, a, "latam") > 0 or Instr(1, a, "419") > 0 or Instr(1, a, "america") > 0 then return 0
    if Instr(1, a, "es") = 1 or Instr(1, a, "spa") = 1 or Instr(1, a, "espa") > 0 or Instr(1, a, "spanish") > 0
        if Instr(1, a, "castellano") > 0 or Instr(1, a, "espana") > 0 or Instr(1, a, "españa") > 0 then return 400
        return 50
    end if
    if Instr(1, a, "en") = 1 or Instr(1, a, "english") > 0 or Instr(1, a, "ingles") > 0 or Instr(1, a, "inglés") > 0 then return 250
    if Instr(1, a, "pt") = 1 or Instr(1, a, "por") = 1 or Instr(1, a, "portug") > 0 or Instr(1, a, "brasil") > 0 then return 1500
    return 300
end function
function VodVariantScore(v as Object, hw as Object, containerPenalty as Integer) as Integer
    score = containerPenalty
    codecName = SafeStr(v.codec)
    rawEnc = SafeStr(v.rawEncode)
    supported = Hardware_CodecSupported(hw, codecName)
    hevcOk = (hw <> invalid and hw.hevc = true)
    if supported = false
        score = score + 20000
    else if Instr(1, codecName, "H.264") > 0 or Instr(1, codecName, "AVC") > 0
        score = score + 0
    else if Instr(1, codecName, "HEVC") > 0 or Instr(1, codecName, "H.265") > 0
        score = score + Tern(hevcOk, 80, 20000)
    else
        score = score + 160
    end if
    if Instr(1, rawEnc, "av1") > 0 or Instr(1, rawEnc, "vp9") > 0 or Instr(1, rawEnc, "10bit") > 0 or Instr(1, rawEnc, "hdr") > 0
        score = score + 500
    end if
    score = score + VodAudioPenalty(SafeStr(v.audioInfo))
    h = 0
    if v.height <> invalid then h = v.height
    if hevcOk
        if h >= 2000 then score = score + 0 else if h >= 1000 then score = score + 120 else if h >= 700 then score = score + 240 else if h > 0 then score = score + 360
    else
        if h >= 1000 and h < 2000
            score = score + 0
        else if h >= 700 and h < 1000
            score = score + 150
        else if h > 0 and h < 700
            score = score + 300
        else if h >= 2000
            score = score + 800
        end if
    end if
    if v.frameRate <> invalid and v.frameRate > 30 then score = score + 300
    if v.bitrateKbps <> invalid and v.bitrateKbps > 9000 then score = score + 250
    return score
end function
sub TryStartVod()
    if m.slbDataVod = invalid or m.vodLicense = invalid then return
    k = v4a21()
    if k = invalid
        m.top.state = "error"
        return
    end if
    cdns = VodCollectCdns(m.slbDataVod)
    if cdns.Count() = 0
        m.slbCacheData = invalid
        m.top.state = "error"
        return
    end if
    playable = []
    for each variant in m.vodVariants
        exts = [{ ext: "ts", pen: 150 }]
        if SafeStr(variant.videoFormat) = "mp4"
            exts = [{ ext: "mp4", pen: 0 }, { ext: "ts", pen: 500 }]
        end if
        for each spec in exts
            urls = []
            urlHeaders = []
            format = ""
            for each proto in ["http://", "https://"]
                for each cdn in cdns
                    baseTpl = SafeStr(k.vodUrl)
                    if proto = "https://" then baseTpl = baseTpl.Replace("http://", "https://")
                    if spec.ext = "mp4" then baseTpl = baseTpl.Replace("_media.ts", "_media.mp4")
                    url = v4a28(baseTpl, { host: cdn.host, code: variant.mediaCode })
                    if format = "" then format = StreamFormatForUrl(url)
                    urls.Push(url)
                    urlHeaders.Push(StreamHeaders(k, cdn.auth, variant.license))
                end for
            end for
            if format <> "" and urls.Count() > 0
                score = VodVariantScore(variant, m.hardwareInfo, spec.pen)
                entry = {
                    mediaCode: variant.mediaCode,
                    codec: variant.codec,
                    duration: variant.duration,
                    urls: urls,
                    urlHeaders: urlHeaders,
                    headers: urlHeaders[0],
                    format: format,
                    score: score
                }
                playable.Push(entry)
                print "[XuperVOD] variant code="; variant.mediaCode; " codec="; variant.codec; " fmt="; format; " audio="; variant.audioInfo; " q="; variant.quality; " score="; score
            end if
        end for
    end for
    if playable.Count() = 0
        print "[XuperVOD] No playable variants found"
        m.top.state = "error"
        return
    end if
    ' Ordenar ascendente por score (menor = mas compatible y mejor pista)
    n = playable.Count()
    for i = 0 to n - 2
        for j = i + 1 to n - 1
            if playable[j].score < playable[i].score
                tmp = playable[i]
                playable[i] = playable[j]
                playable[j] = tmp
            end if
        end for
    end for
    m.vodVariants = playable
    m.vodVariantIdx = 0
    m.vodUrlIdx = 0
    m.bestBridgeVariant = playable[0]
    hevcOk = (m.hardwareInfo <> invalid and m.hardwareInfo.hevc = true)
    if not hevcOk and playable[0].score >= 20000 and PcBridge_LoadHost() <> ""
        print "[XuperBridge] Sin pista H.264 nativa; usando Puente PC"
        TryStartVodViaBridge(playable[0])
        return
    end if
    PlayVodUrl()
end sub
sub TryStartVodViaBridge(variant as Object)
    host = PcBridge_LoadHost()
    if host = "" or variant = invalid
        SetVodPlaybackState("PLAYBACK_FAILED")
        m.top.state = "nocodec"
        return
    end if
    m.bridgeUsed = true
    m.playingVod = false
    m.playingBridge = false
    m.spinner.visible = true
    SetVodPlaybackState("PLAYBACK_LOADING")
    FlashAV("Conectando con Puente PC (" + host + ")...")
    if m.bridgeTask <> invalid then m.bridgeTask.control = "STOP"
    t = CreateObject("roSGNode", "BridgeTask")
    t.generation = m.vodGen
    t.action = "session"
    t.bridgeHost = host
    t.payload = {
        urls: variant.urls,
        headerList: variant.urlHeaders,
        headers: variant.headers,
        title: SafeStr(m.top.channelName),
        startSec: 0
    }
    t.ObserveField("result", "OnBridgeSessionResult")
    m.bridgeTask = t
    t.control = "RUN"
end sub
sub OnBridgeSessionResult(event as Object)
    res = event.GetData()
    if res = invalid or res.generation <> m.vodGen then return
    if res.ok = true and SafeStr(res.playUrl) <> ""
        m.spinner.visible = false
        m.playingBridge = true
        enc = SafeStr(res.encoder)
        if enc = "" then enc = "H.264"
        FlashAV("Puente PC activo (" + enc + ")")
        print "[XuperBridge] Playing HLS "; res.playUrl; " enc="; enc
        PlayUrl(SafeStr(res.playUrl), invalid, false, "hls")
        return
    end if
    print "[XuperBridge] Error: "; SafeStr(res.error)
    m.spinner.visible = false
    m.playingBridge = false
    SetVodPlaybackState("PLAYBACK_FAILED")
    m.top.lastErrorCode = -1005
    m.top.lastErrorMessage = "Puente PC no disponible (" + SafeStr(res.error) + ")"
    m.top.state = "nocodec"
end sub
sub StopPcBridge()
    host = PcBridge_LoadHost()
    if host = "" then return
    t = CreateObject("roSGNode", "BridgeTask")
    t.action = "stop"
    t.bridgeHost = host
    m.bridgeStopTask = t
    t.control = "RUN"
end sub
function StreamFormatForUrl(url as String) as String
    path = LCase(url)
    queryPos = Instr(1, path, "?")
    if queryPos > 0 then path = Left(path, queryPos - 1)
    if Right(path, 5) = ".m3u8" then return "hls"
    if Right(path, 4) = ".mpd" then return "dash"
    if Right(path, 4) = ".mp4" or Right(path, 4) = ".m4v" then return "mp4"
    if Right(path, 4) = ".mkv" then return "mkv"
    if Right(path, 3) = ".ts" then return "ts"
    if Right(path, 4) = ".ism" then return "smooth"
    return "hls"
end function
sub PlayVodUrl()
    if m.vodVariants = invalid or m.vodVariantIdx < 0 or m.vodVariantIdx >= m.vodVariants.Count()
        m.top.state = "error"
        return
    end if
    variant = m.vodVariants[m.vodVariantIdx]
    m.vodUrls = variant.urls
    m.vodUrlHeaders = variant.urlHeaders
    m.vodHeaders = variant.headers
    m.vodDuration = variant.duration
    if SafeStr(variant.codec) <> "" then m.top.detectedVideoCodec = SafeStr(variant.codec)
    if m.probeTask <> invalid then m.probeTask.control = "STOP"
    m.vodProbeAttempt = m.vodProbeAttempt + 1
    m.probeTask = createObject("roSGNode", "ProbeTask")
    m.probeTask.generation = m.vodGen
    m.probeTask.attempt = m.vodProbeAttempt
    m.probeTask.ObserveField("okUrl", "OnVodHostPicked")
    m.probeTask.urls       = m.vodUrls
    m.probeTask.headers    = m.vodHeaders
    m.probeTask.headerList = m.vodUrlHeaders
    m.probeTask.control = "RUN"
end sub
sub OnVodHostPicked(event as Object)
    src = event.GetRoSGNode()
    if src = invalid or src.generation <> m.vodGen or src.attempt <> m.vodProbeAttempt then return
    url = SafeStr(event.GetData())
    if url = ""
        m.top.state = "error"
        return
    end if
    m.vodUrlIdx = 0
    for i = 0 to m.vodUrls.Count() - 1
        if m.vodUrls[i] = url then m.vodUrlIdx = i
    end for
    h = m.vodHeaders
    if m.vodUrlHeaders <> invalid and m.vodUrlIdx < m.vodUrlHeaders.Count() and m.vodUrlHeaders[m.vodUrlIdx] <> invalid
        h = m.vodUrlHeaders[m.vodUrlIdx]
    end if
    m.spinner.visible = false
    m.playingVod = true
    PlayUrl(url, h, false, m.vodVariants[m.vodVariantIdx].format)
end sub
sub PlayVodUrlAt(idx as Integer)
    if m.vodUrls = invalid or idx < 0 or idx >= m.vodUrls.Count()
        m.top.state = "error"
        return
    end if
    h = m.vodHeaders
    if m.vodUrlHeaders <> invalid and idx < m.vodUrlHeaders.Count() and m.vodUrlHeaders[idx] <> invalid
        h = m.vodUrlHeaders[idx]
    end if
    m.playingVod = true
    PlayUrl(m.vodUrls[idx], h, false, m.vodVariants[m.vodVariantIdx].format)
end sub
function TryNextVodVariant(reason as String) as Boolean
    nextIdx = m.vodVariantIdx + 1
    if m.vodVariants = invalid then return false
    if nextIdx < m.vodVariants.Count()
        m.vodVariantIdx = nextIdx
        m.vodUrlIdx = 0
        m.vodIgnoreTerminal = true
        m.playingVod = false
        SetVodPlaybackState("PLAYBACK_LOADING")
        m.spinner.visible = true
        if m.vodFallbackTimer <> invalid then m.vodFallbackTimer.control = "stop"
        m.vodFallbackTimer = CreateObject("roSGNode", "Timer")
        m.vodFallbackTimer.duration = 0.25
        m.vodFallbackTimer.repeat = false
        m.vodFallbackTimer.ObserveField("fire", "OnVodFallbackTimer")
        m.vodFallbackTimer.control = "start"
        return true
    end if
    if not m.bridgeUsed and m.bestBridgeVariant <> invalid and PcBridge_LoadHost() <> ""
        print "[XuperBridge] Pistas directas fallaron ("; reason; "); intentando Puente PC"
        TryStartVodViaBridge(m.bestBridgeVariant)
        return true
    end if
    return false
end function
sub OnVodFallbackTimer(event as Object)
    if m.vodFallbackTimer <> invalid then m.vodFallbackTimer.control = "stop"
    m.vodFallbackTimer = invalid
    PlayVodUrl()
end sub
function LangName(code as String) as String
    c = LCase(code)
    if c = "es" or c = "spa" then return "Español"
    if c = "en" or c = "eng" then return "English"
    if c = "pt" or c = "por" then return "Português"
    if c = "fr" or c = "fra" then return "Français"
    if c = "" then return "Idioma"
    return UCase(code)
end function
sub OnChannelCodeSet(event as Object)
    channelCode = event.GetData()
    if channelCode = "" then return
    m.liveGen = m.top.requestGeneration
    m.vodGen = m.vodGen + 1
    if m.probeTask <> invalid
        m.probeTask.control = "STOP"
        m.probeTask = invalid
    end if
    if m.vodFallbackTimer <> invalid
        m.vodFallbackTimer.control = "stop"
        m.vodFallbackTimer = invalid
    end if
    m.acceptLiveVideoEvents = false
    m.video.control = "stop"
    m.video.content = invalid
    m.playGeneration = m.playGeneration + 1
    m.playStartedAt = CreateObject("roDateTime").AsSeconds()
    m.osdMode = "live"
    m.top.detectedVideoCodec = ""
    m.osd.visible = false
    m.spinner.visible = true
    m.liveOsdTitle.text = m.top.channelName
    m.liveOsdCategory.text = SafeStr(m.top.channelCategory)
    m.liveOsdLogo.uri = SafeStr(m.top.channelLogo)
    m.osdTitle.text    = m.top.channelName
    m.osdCategory.text = SafeStr(m.top.channelCategory)
    m.osdChNumber.text = "Canal " + SafeStr(m.top.channelNumber)
    m.osdLogo.uri       = SafeStr(m.top.channelLogo)
    m.liveBadge.visible = true
    m.liveBadgeLbl.visible = true
    m.directoBadge.visible = true
    m.directoLbl.visible = true
    m.progressFill.visible = true
    m.slbData  = invalid
    m.liveAddr = invalid
    m.liveChannelCode = channelCode
    columnId = m.top.columnId
    if columnId = invalid then columnId = 76182
    m.liveColumnId = columnId
    m.liveLicAttempt = 0
    cachedSlb = GetCachedSlb()
    if cachedSlb <> invalid
        m.slbData = cachedSlb
    else
        slb = Api_OpTask("slbInfo", {})
        if slb = invalid
            m.top.stateGeneration = m.liveGen
            m.top.state = "error"
            return
        end if
        slb.generation = m.liveGen
        if m.slbTask <> invalid then m.slbTask.control = "STOP"
        m.slbTask = slb
        m.slbTask.ObserveField("rawResp", "OnSlbResp")
        m.slbTask.ObserveField("error",   "OnStreamError")
        m.slbTask.control = "RUN"
    end if
    lic = Api_OpTask("startPlayLive", { channelCode: channelCode, columnId: columnId })
    if lic = invalid
        m.top.stateGeneration = m.liveGen
        m.top.state = "error"
        return
    end if
    lic.generation = m.liveGen
    if m.licTask <> invalid then m.licTask.control = "STOP"
    m.licTask = lic
    m.licTask.ObserveField("rawResp", "OnLicResp")
    m.licTask.ObserveField("error",   "OnStreamError")
    m.licTask.control = "RUN"
end sub
function RetryLiveLicenseFallback() as Boolean
    if m.liveLicAttempt >= 1 or SafeStr(m.liveChannelCode) = "" then return false
    if m.liveColumnId = 0 then return false
    m.liveLicAttempt = m.liveLicAttempt + 1
    lic = Api_OpTask("startPlayLive", { channelCode: m.liveChannelCode, columnId: 0 })
    if lic = invalid then return false
    lic.generation = m.liveGen
    if m.licTask <> invalid then m.licTask.control = "STOP"
    m.licTask = lic
    m.licTask.ObserveField("rawResp", "OnLicResp")
    m.licTask.ObserveField("error",   "OnStreamError")
    m.licTask.control = "RUN"
    return true
end function
function IsFormatError() as Boolean
    msg = LCase(SafeStr(m.video.errorMsg))
    if Instr(1, msg, "unsupported") > 0 then return true
    if Instr(1, msg, "format") > 0 then return true
    return false
end function
sub OnStreamError(event as Object)
    src = event.GetRoSGNode()
    if src = invalid then return
    if src.generation <> m.liveGen then return
    if m.licTask <> invalid and src.isSameNode(m.licTask) and RetryLiveLicenseFallback() then return
    m.spinner.visible = false
    m.top.stateGeneration = m.liveGen
    m.top.state = "error"
end sub
sub OnVodStreamError(event as Object)
    src = event.GetRoSGNode()
    if src = invalid or src.generation <> m.vodGen then return
    m.spinner.visible = false
    m.playingVod = false
    m.top.state = "error"
end sub
sub OnSlbResp(event as Object)
    src = event.GetRoSGNode()
    if src = invalid then return
    if src.generation <> m.liveGen then return
    data = Api_ParseOp(event.GetData())
    if data = invalid or data.cdn_list = invalid
        m.slbCacheData = invalid
        m.top.stateGeneration = m.liveGen
        m.top.state = "error"
        return
    end if
    SaveCachedSlb(data)
    m.slbData = data
    TryStartPlayback()
end sub
sub OnLicResp(event as Object)
    src = event.GetRoSGNode()
    if src = invalid then return
    if src.generation <> m.liveGen then return
    data = Api_ParseOp(event.GetData())
    if data = invalid or data.liveAddressList = invalid or data.liveAddressList.Count() = 0
        if RetryLiveLicenseFallback() then return
        m.top.stateGeneration = m.liveGen
        m.top.state = "error"
        return
    end if
    chosen = invalid
    for each la in data.liveAddressList
        if la <> invalid and IsValidStr(SafeStr(la.playCode)) and IsValidStr(SafeStr(la.license))
            chosen = la
            exit for
        end if
    end for
    if chosen = invalid then chosen = data.liveAddressList[0]
    m.liveAddr = chosen
    TryStartPlayback()
end sub
sub TryStartPlayback()
    if m.slbData = invalid or m.liveAddr = invalid then return
    reqs = BuildStreamRequests(m.slbData, m.liveAddr)
    m.spinner.visible = false
    if reqs = invalid or reqs.Count() = 0
        m.slbCacheData = invalid
        m.top.stateGeneration = m.liveGen
        m.top.state = "error"
        return
    end if
    fbUrls = []
    fbHeaders = []
    for i = 1 to reqs.Count() - 1
        fbUrls.Push(reqs[i].url)
        fbHeaders.Push(reqs[i].headers)
    end for
    m.liveBackupUrls = fbUrls
    m.liveBackupHeaders = fbHeaders
    StartLive(reqs[0].url, reqs[0].headers, fbUrls, fbHeaders)
end sub
sub StartLive(url as String, headers as Object, fbUrls = invalid as Dynamic, fbHeaders = invalid as Dynamic)
    m.lastDirectUrl = url
    m.streamHeaders = headers
    if m.proxyTask <> invalid then m.proxyTask.control = "STOP"
    m.proxyTask = createObject("roSGNode", "ManifestProxy")
    m.proxyTask.generation = m.liveGen
    m.proxyTask.ObserveField("ready", "OnProxyReady")
    m.proxyTask.ObserveField("error", "OnProxyError")
    m.proxyTask.srcUrl  = url
    m.proxyTask.headers = headers
    if fbUrls <> invalid then m.proxyTask.fallbackUrls = fbUrls
    if fbHeaders <> invalid then m.proxyTask.fallbackHeaders = fbHeaders
    m.proxyTask.control = "RUN"
end sub
sub OnProxyReady(event as Object)
    src = event.GetRoSGNode()
    if src = invalid then return
    if src.generation <> m.liveGen then return
    if event.GetData() <> true then return
    url = "http://127.0.0.1:" + PROXY_PORT().ToStr() + "/live.m3u8"
    PlayUrl(url, m.streamHeaders)
end sub
sub OnProxyError(event as Object)
    src = event.GetRoSGNode()
    if src = invalid then return
    if src.generation <> m.liveGen then return
    if m.lastDirectUrl <> invalid and m.lastDirectUrl <> ""
        PlayUrl(m.lastDirectUrl, m.streamHeaders)
    end if
end sub
function BuildStreamRequests(slbData as Object, liveAddr as Object) as Object
    out = []
    k = v4a21()
    if k = invalid or slbData.cdn_list = invalid or liveAddr = invalid then return out
    mediaCode = SafeStr(liveAddr.playCode)
    license = SafeStr(liveAddr.license)
    if mediaCode = "" or license = "" then return out
    seen = {}

    ' 1) Prioridad: cdn_type = "4" (comportamiento nativo Roku + spared_addr)
    for each entry in slbData.cdn_list
        if entry <> invalid and SafeStr(entry.tag) = "live" and SafeStr(entry.cdn_type) = "4" and entry.url_list <> invalid and entry.url_list.Count() > 0
            authUrl = SafeStr(entry.url_list[0].url).Trim()
            if authUrl <> ""
                for each rawAddr in [SafeStr(entry.main_addr), SafeStr(entry.spared_addr)]
                    h = HostOf(rawAddr)
                    if h <> "" and seen[h] = invalid
                        seen[h] = true
                        hdrs = StreamHeaders(k, authUrl, license)
                        hdrs["X-Buffer"] = "0"
                        out.Push({
                            url: v4a28(k.liveUrl, { host: h, code: mediaCode }),
                            headers: hdrs
                        })
                    end if
                end for
            end if
        end if
    end for

    ' 2) Respaldo: entradas tag="live" con sign_type=cfl / token= y firma sign_o3
    for pass = 0 to 1
        for each entry in slbData.cdn_list
            if entry <> invalid and SafeStr(entry.tag) = "live" and entry.url_list <> invalid
                for each ul in entry.url_list
                    authBase = SafeStr(ul.url).Trim()
                    if authBase <> ""
                        isCfl = (LCase(SafeStr(ul.sign_type)) = "cfl" or Instr(1, authBase, "sign_type=cfl") > 0)
                        hasTok = (Instr(1, authBase, "token=") > 0)
                        if (pass = 0 and isCfl) or (pass = 1 and hasTok)
                            signedAuth = SignLiveAuthO3(authBase)
                            for each rawAddr in [SafeStr(entry.main_addr), SafeStr(entry.spared_addr)]
                                h = HostOf(rawAddr)
                                if h <> "" and seen[h] = invalid
                                    seen[h] = true
                                    hdrs = StreamHeaders(k, signedAuth, license)
                                    hdrs["X-Buffer"] = "0"
                                    out.Push({
                                        url: v4a28(k.liveUrl, { host: h, code: mediaCode }),
                                        headers: hdrs
                                    })
                                end if
                            end for
                        end if
                    end if
                end for
            end if
        end for
    end for
    return out
end function
function SignLiveAuthO3(authBase as String) as String
    if authBase = "" or Instr(1, authBase, "sign2=") > 0 then return authBase
    rx = CreateObject("roRegex", "token=([0-9a-fA-F]{32})", "")
    mm = rx.Match(authBase)
    if mm.Count() < 2 then return authBase
    tok = mm[1]
    dt = CreateObject("roDateTime")
    tsMs = dt.AsSeconds().ToStr() + Right("00" + dt.GetMilliseconds().ToStr(), 3)
    sig = LiveSignO3(tok, tsMs)
    if sig = "" then return authBase
    return authBase + "&sign2_method=sign_o3&instance=0&start_moment=" + tsMs + "&sign2=" + sig
end function
function LivePairAdd(a as Object, b as Object) as Object
    lo = a[0] + b[0]
    hi = a[1] + b[1] + Int(lo / 65536)
    return [lo and &hFFFF, hi and &hFFFF]
end function
function LiveRotl(a as Object, s as Integer, pow2 as Object) as Object
    lo = a[0]
    hi = a[1]
    if s >= 16
        t = lo : lo = hi : hi = t
        s = s - 16
    end if
    if s = 0 then return [lo, hi]
    p1 = pow2[s]
    p2 = pow2[16 - s]
    nlo = ((lo * p1) or Int(hi / p2)) and &hFFFF
    nhi = ((hi * p1) or Int(lo / p2)) and &hFFFF
    return [nlo, nhi]
end function
function LiveBitXor(a as Integer, b as Integer) as Integer
    return ((a or b) and (not (a and b))) and &hFFFF
end function
function LiveSignO3(token as String, tsMs as String) as String
    ba = CreateObject("roByteArray")
    ba.FromAsciiString("token=" + token + "&sign2_method=sign_o3&instance=0&start_moment=" + tsMs)
    salt = [115,97,108,116,51,51,51,51,61,52,152,13,10,21,50,201,195,130,23,8,192]
    for each b in salt
        ba.Push(b)
    end for
    t = ba.Count()
    padZero = (56 - ((t + 1) mod 64) + 64) mod 64
    ba.Push(128)
    for pi = 1 to padZero
        ba.Push(0)
    end for
    bitLen = t * 8
    ba.Push(bitLen and 255)
    ba.Push(Int(bitLen / 256) and 255)
    ba.Push(Int(bitLen / 65536) and 255)
    ba.Push(Int(bitLen / 16777216) and 255)
    for pi = 1 to 4
        ba.Push(0)
    end for

    kLo = [42104,46934,28891,52974,4015,50730,17939,38145,39128,63407,23473,55230,4386,29075,17294,2081,9570,45888,23121,51114,4189,5203,59009,64456,52710,2006,3463,5357,59653,41976,729,19594,14658,63105,24866,14348,59972,53161,19296,48240,32454,10234,12421,7429,53305,39397,31992,22117,8772,65431,9127,41017,22979,52370,50301,24017,32335,59104,17172,4513,32386,62005,53947,54161]
    kHi = [55146,59591,9248,49597,62844,18311,43056,64838,27008,35652,65535,35164,27536,64920,42617,18868,63006,49216,9822,59830,54831,580,55457,59347,8673,49975,62677,17754,43491,64751,26479,36138,65530,34673,28061,64997,42174,19422,63163,48831,10395,60065,54383,1160,55764,59069,8098,50348,62505,17194,43924,64659,25947,36620,65516,34180,28584,65068,41729,19976,63315,48442,11687,60294]
    sArr = [7,12,17,22,7,12,17,22,7,12,17,22,7,12,17,22,5,9,14,20,5,9,14,20,5,9,14,20,5,9,14,20,4,11,16,23,4,11,16,23,4,11,16,23,4,11,16,23,6,10,15,21,6,10,15,21,6,10,15,21,6,10,15,21]
    gArr = [10,11,12,13,14,15,6,7,8,9,0,1,2,3,4,5, 1,6,11,0,5,10,15,4,9,14,3,8,13,2,7,12, 5,8,11,14,1,4,7,10,13,0,3,6,9,12,15,2, 0,7,14,5,12,3,10,1,8,15,6,13,4,11,2,9]
    pow2 = [1,2,4,8,16,32,64,128,256,512,1024,2048,4096,8192,16384,32768,65536]

    r = [[9089, 26437], [60889, 61389], [56574, 39098], [21622, 4146]]
    totalBytes = ba.Count()
    off = 0
    while off < totalBytes
        mArr = []
        for wi = 0 to 15
            bOff = off + (wi * 4)
            mArr.Push([ba[bOff] + ba[bOff + 1] * 256, ba[bOff + 2] + ba[bOff + 3] * 256])
        end for
        o = [r[0][0], r[0][1]]
        i = [r[1][0], r[1][1]]
        ll = [r[2][0], r[2][1]]
        u = [r[3][0], r[3][1]]
        for d = 0 to 63
            if d < 16
                f0 = ((i[0] and ll[0]) or (((not i[0]) and &hFFFF) and u[0])) and &hFFFF
                f1 = ((i[1] and ll[1]) or (((not i[1]) and &hFFFF) and u[1])) and &hFFFF
            else if d < 32
                f0 = ((u[0] and i[0]) or (((not u[0]) and &hFFFF) and ll[0])) and &hFFFF
                f1 = ((u[1] and i[1]) or (((not u[1]) and &hFFFF) and ll[1])) and &hFFFF
            else if d < 48
                f0 = LiveBitXor(LiveBitXor(i[0], ll[0]), u[0])
                f1 = LiveBitXor(LiveBitXor(i[1], ll[1]), u[1])
            else
                f0 = LiveBitXor(ll[0], (i[0] or ((not u[0]) and &hFFFF)) and &hFFFF)
                f1 = LiveBitXor(ll[1], (i[1] or ((not u[1]) and &hFFFF)) and &hFFFF)
            end if
            km = LivePairAdd([kLo[d], kHi[d]], mArr[gArr[d]])
            c = LivePairAdd(LivePairAdd([f0, f1], o), km)
            rot = LiveRotl(c, sArr[d], pow2)
            nxt = LivePairAdd(i, rot)
            o = u
            u = ll
            ll = i
            i = nxt
        end for
        r[0] = LivePairAdd(r[0], o)
        r[1] = LivePairAdd(r[1], i)
        r[2] = LivePairAdd(r[2], ll)
        r[3] = LivePairAdd(r[3], u)
        off = off + 64
    end while
    hex = ""
    for wi = 0 to 3
        lo = r[wi][0] : hi = r[wi][1]
        for each bv in [lo and 255, Int(lo / 256) and 255, hi and 255, Int(hi / 256) and 255]
            hex = hex + LCase(Right("0" + StrI(bv, 16), 2))
        end for
    end for
    return hex
end function
function StreamHeaders(k as Object, contentAuth as String, license as String) as Object
    h = {}
    if k.streamHeaders <> invalid
        for each name in k.streamHeaders
            h[name] = k.streamHeaders[name]
        end for
    end if
    h["Content-Auth"]    = contentAuth
    h["Content-License"] = license
    return h
end function
function HostOf(mainAddr as String) as String
    h = mainAddr.Replace("https://", "").Replace("http://", "")
    sp = Instr(1, h, "/")
    if sp > 0 then h = Left(h, sp - 1)
    return h
end function
sub OnVodUrlSet(event as Object)
    url = event.GetData()
    if url = "" or url = invalid then return
    m.vodGen = m.vodGen + 1
    SetVodPlaybackState("PLAYBACK_LOADING")
    ClearPlaybackError()
    m.osdMode = "vod"
    m.liveOsd.visible = false
    m.osdTitle.text = m.top.vodTitle
    m.osdCategory.text = ""
    m.osdChNumber.text = ""
    m.liveBadge.visible = false
    m.liveBadgeLbl.visible = false
    PlayUrl(url, invalid, false)
end sub
sub PlayUrl(url as String, headers = invalid as Dynamic, isLive = true as Boolean, fmt = "hls" as String)
    if m.video.state = "error" or m.video.state = "finished"
        m.video.control = "stop"
    end if
    if headers <> invalid
        agent = CreateObject("roHttpAgent")
        agent.SetCertificatesFile("common:/certs/ca-bundle.crt")
        agent.InitClientCertificates()
        agent.SetHeaders(headers)
        m.video.SetHttpAgent(agent)
    end if
    content = CreateObject("roSGNode", "ContentNode")
    content.url          = url
    content.streamformat = fmt
    content.live = isLive
    print "[XuperPlay] isLive="; isLive; " fmt="; fmt; " codec="; m.top.detectedVideoCodec; " url="; url
    if isLive
        content.playStart = 0
        m.video.enableTrickPlay = false
    else
        m.video.enableTrickPlay = true
        m.video.notificationInterval = 0.1
        if m.vodDuration > 0 then content.length = m.vodDuration
    end if
    if not isLive then SubOff()
    m.subLangIdx = -1      ' -1 = subtítulos apagados
    m.audioIdx = 0
    if not isLive and m.vodDuration > 0
        m.progressFill.width = 0
        m.progressFill.visible = true
    end if
    if isLive then m.acceptLiveVideoEvents = true
    m.video.content = content
    m.video.control = "play"
    ShowOSD()
end sub
sub CycleSub()
    n = 0
    if m.vodSubs <> invalid then n = m.vodSubs.Count()
    if n = 0
        FlashAV("Sin subtítulos")
        return
    end if
    m.subLangIdx = m.subLangIdx + 1
    if m.subLangIdx >= n
        m.subLangIdx = -1
        SubOff()
        FlashAV("Subtítulos: Off")
    else
        sub_ = m.vodSubs[m.subLangIdx]
        lang = SafeStr(sub_.lang)
        FlashAV("Subtítulos: " + LangName(lang))
        LoadSub(SafeStr(sub_.url))
    end if
end sub
sub SubOff()
    m.subCues = []
    m.subCueIdx = 0
    m.subLabel.text = ""
    m.subShadow.text = ""
    m.subGroup.visible = false
end sub
sub LoadSub(url as String)
    if url = "" then return
    m.subCueIdx = 0
    m.subLabel.text = ""
    m.subShadow.text = ""
    cached = m.subCache[url]
    if cached <> invalid
        m.subCues = cached
        m.subGroup.visible = true
        RenderSubAt(CurPos())
        return
    end if
    m.subPendingUrl = url
    m.srtTask = CreateObject("roSGNode", "SrtTask")
    m.srtTask.ObserveField("cues", "OnSrtParsed")
    m.srtTask.url = url
    m.srtTask.control = "RUN"
end sub
sub OnSrtParsed(event as Object)
    cues = event.GetData()
    if cues = invalid then cues = []
    if m.subPendingUrl <> invalid then m.subCache[m.subPendingUrl] = cues
    m.subCues = cues
    m.subCueIdx = 0
    if cues.Count() = 0
        FlashAV("Subtítulo vacío")
        m.subGroup.visible = false
        return
    end if
    m.subGroup.visible = true
    RenderSubAt(CurPos())
end sub
function CurPos() as Integer
    p = m.video.position
    if p = invalid then return 0
    return p
end function
sub RenderSubAt(posn as Integer)
    if m.subLangIdx < 0 or m.subCues.Count() = 0 then return
    look = posn - m.subOffset
    if look < 0 then look = 0
    if m.subCueIdx >= m.subCues.Count() then m.subCueIdx = 0
    if m.subCues[m.subCueIdx].s > look then m.subCueIdx = 0
    txt = ""
    i = m.subCueIdx
    while i < m.subCues.Count()
        c = m.subCues[i]
        if look < c.s
            exit while
        else if look <= c.e
            txt = c.t
            m.subCueIdx = i
            exit while
        end if
        i = i + 1
    end while
    if m.subLabel.text <> txt
        m.subLabel.text = txt
        m.subShadow.text = txt
    end if
end sub
sub FlashAV(msg as String)
    m.avInfo.text = msg
    m.avInfo.visible = true
    ShowOSD()
    m.avTimer = CreateObject("roSGNode", "Timer")
    m.avTimer.duration = 3
    m.avTimer.repeat = false
    m.avTimer.ObserveField("fire", "HideAV")
    m.avTimer.control = "start"
end sub
sub HideAV(event as Object)
    m.avInfo.visible = false
end sub
sub ShowOSD()
    if m.top.displayMode = "embedded"
        m.osd.visible = false
        m.liveOsd.visible = false
        return
    end if
    if m.osdMode = "live"
        m.osd.visible = false
        m.liveOsd.visible = true
    else
        m.liveOsd.visible = false
        m.osd.visible = true
        UpdateClock(invalid)
    end if
    if m.osdTimer <> invalid then m.osdTimer.control = "stop"
    m.osdTimer = CreateObject("roSGNode", "Timer")
    m.osdTimer.duration = 4
    m.osdTimer.repeat   = false
    m.osdTimer.ObserveField("fire", "HideOSD")
    m.osdTimer.control  = "start"
end sub
sub UpdateClock(event as Object)
    t = CreateObject("roDateTime")
    t.ToLocalTime()
    m.osdClock.text = Right("0" + t.GetHours().ToStr(), 2) + ":" + Right("0" + t.GetMinutes().ToStr(), 2)
end sub
sub HideOSD(event as Object)
    m.osd.visible = false
    m.liveOsd.visible = false
end sub
sub OnVideoState(event as Object)
    state = event.GetData()
    if state = "error"
        print "[XuperVideo] state=error mode="; m.osdMode; " errCode="; m.video.errorCode; " errMsg="; m.video.errorMsg
    else if state = "playing"
        print "[XuperVideo] state=playing mode="; m.osdMode; " videoFormat="; m.video.videoFormat; " audioFormat="; m.video.audioFormat
    end if
    if m.osdMode = "live" and not m.acceptLiveVideoEvents then return
    elapsed = 0
    if m.playStartedAt > 0 then elapsed = CreateObject("roDateTime").AsSeconds() - m.playStartedAt
    opLabel = "LIVE"
    opGen = m.liveGen
    if m.osdMode = "vod"
        opLabel = "VOD"
        opGen = m.vodGen
    end if
    m.previousVideoState = state
    if m.osdMode = "vod" and m.vodIgnoreTerminal
        if state = "error" or state = "finished" or state = "stopped" or state = "closed"
            return
        end if
    end if
    if m.osdMode = "vod" and (state = "buffering" or state = "playing") then m.vodIgnoreTerminal = false
    if m.osdMode = "vod" and m.vodPlaybackState = "PLAYBACK_FAILED"
        if state = "finished" or state = "stopped" or state = "closed"
            return
        end if
    end if
    if state = "error" and m.playingVod = true and IsFormatError()
        CapturePlaybackError()
        m.playingVod = false
        if TryNextVodVariant("format") then return
        SetVodPlaybackState("PLAYBACK_FAILED")
        m.top.state = "nocodec"
        return
    end if
    if state = "error" and m.playingVod = true and m.vodUrls <> invalid
        m.vodUrlIdx = m.vodUrlIdx + 1
        if m.vodUrlIdx < m.vodUrls.Count()
            m.spinner.visible = true
            PlayVodUrlAt(m.vodUrlIdx)
            return
        end if
        if TryNextVodVariant("hosts_agotados") then return
    end if
    if state = "error" and m.osdMode = "live" and m.liveBackupUrls <> invalid and m.liveBackupUrls.Count() > 0
        nextLiveUrl = m.liveBackupUrls.Shift()
        nextLiveHeaders = m.streamHeaders
        if m.liveBackupHeaders <> invalid and m.liveBackupHeaders.Count() > 0
            nextLiveHeaders = m.liveBackupHeaders.Shift()
        end if
        if nextLiveUrl <> invalid and nextLiveUrl <> ""
            m.spinner.visible = true
            PlayUrl(nextLiveUrl, nextLiveHeaders)
            return
        end if
    end if
    if state = "playing" or state = "error" or state = "closed" then m.playingVod = false
    if m.osdMode = "vod"
        if state = "playing"
            SetVodPlaybackState("PLAYBACK_PLAYING")
        else if state = "error"
            CapturePlaybackError()
            SetVodPlaybackState("PLAYBACK_FAILED")
        else if state = "finished"
            SetVodPlaybackState("PLAYBACK_FINISHED")
        end if
    end if
    if state = "playing"
        at = m.video.availableAudioTracks
        st = m.video.availableSubtitleTracks
        na = 0 : ns = 0
        if at <> invalid then na = at.Count()
        if st <> invalid then ns = st.Count()
        if at <> invalid
            for each t in at
            end for
        end if
        if st <> invalid
            for each t in st
            end for
        end if
    end if
    m.top.stateGeneration = m.liveGen
    m.top.state = state
    if state = "playing"
        m.spinner.visible = false
    else if state = "buffering"
        m.spinner.visible = true
    end if
end sub
sub OnPosition(event as Object)
    posn = event.GetData()
    if posn = invalid then posn = 0
    RenderSubAt(posn)
    if m.vodDuration = invalid or m.vodDuration <= 0 then return
    if not m.osd.visible then return
    frac = posn / m.vodDuration
    if frac < 0 then frac = 0
    if frac > 1 then frac = 1
    m.progressFill.width = Int(1500 * frac)
    m.osdProgram.text = FmtTime(posn) + " / " + FmtTime(m.vodDuration)
end sub
function FmtTime(s as Integer) as String
    if s < 0 then s = 0
    h = s \ 3600
    mn = (s mod 3600) \ 60
    sec = s mod 60
    ss = Right("0" + sec.ToStr(), 2)
    if h > 0
        return h.ToStr() + ":" + Right("0" + mn.ToStr(), 2) + ":" + ss
    end if
    return mn.ToStr() + ":" + ss
end function
sub OnControlChanged(event as Object)
    if event.GetData() = "stop"
        m.vodGen = m.vodGen + 1
        m.liveGen = m.liveGen + 1
        m.acceptLiveVideoEvents = false
        if m.vodPlaybackState <> "PLAYBACK_FAILED" then SetVodPlaybackState("PLAYBACK_CANCELLED")
        if m.slbTask <> invalid then m.slbTask.control = "STOP"
        if m.licTask <> invalid then m.licTask.control = "STOP"
        if m.probeTask <> invalid then m.probeTask.control = "STOP"
        if m.bridgeTask <> invalid then m.bridgeTask.control = "STOP"
        if m.vodFallbackTimer <> invalid then m.vodFallbackTimer.control = "stop"
        m.slbTask = invalid
        m.licTask = invalid
        m.probeTask = invalid
        m.bridgeTask = invalid
        m.vodFallbackTimer = invalid
        m.vodIgnoreTerminal = false
        m.video.control = "stop"
        m.video.content = invalid
        SubOff()
        m.subLangIdx = -1
        if m.bridgeUsed
            m.bridgeUsed = false
            m.playingBridge = false
            StopPcBridge()
        end if
        if m.proxyTask <> invalid
            m.proxyTask.control = "STOP"
            m.proxyTask = invalid
        end if
    end if
end sub
sub SetVodPlaybackState(value as String)
    m.vodPlaybackState = value
    m.top.vodPlaybackState = value
end sub
sub ClearPlaybackError()
    m.top.lastErrorCode = 0
    m.top.lastErrorMessage = ""
    m.top.lastErrorDetail = ""
end sub
sub CapturePlaybackError()
    m.top.lastErrorCode = m.video.errorCode
    m.top.lastErrorMessage = SafeStr(m.video.errorMsg)
    detail = ""
    if m.video.HasField("errorStr") then detail = SafeStr(m.video.GetField("errorStr"))
    if detail = "" and m.video.HasField("errorInfo") then detail = SafeStr(m.video.GetField("errorInfo"))
    m.top.lastErrorDetail = detail
end sub
sub OnPoke(event as Object)
    ShowOSD()
end sub
