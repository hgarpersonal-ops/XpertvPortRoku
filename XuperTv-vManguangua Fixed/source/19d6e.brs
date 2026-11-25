function Hardware_Decode(di as Object, spec as Object) as Dynamic
    if di = invalid then return invalid
    answer = di.CanDecodeVideo(spec)
    if answer = invalid or answer.result = invalid then return invalid
    return (answer.result = true)
end function
function Hardware_YesNo(value as Dynamic) as String
    if value = invalid then return "No determinado"
    if value = true then return "Sí"
    return "No"
end function
function Hardware_Mark(value as Dynamic) as String
    if value = invalid then return "?"
    if value = true then return "✓"
    return "✕"
end function
function Hardware_CodecLabel(raw as Dynamic) as String
    value = LCase(SafeStr(raw)).Replace("_", " ").Replace("-", " ")
    if value = "" or value = "unknown" or value = "none" then return ""
    if Instr(1, value, "hevc") > 0 or Instr(1, value, "h265") > 0 or Instr(1, value, "h.265") > 0 or Instr(1, value, "hvc1") > 0 or Instr(1, value, "hev1") > 0 then return "H.265/HEVC"
    if Instr(1, value, "avc") > 0 or Instr(1, value, "h264") > 0 or Instr(1, value, "h.264") > 0 or Instr(1, value, "mpeg4 10") > 0 or Instr(1, value, "mpeg4 15") > 0 then return "H.264/AVC"
    if Instr(1, value, "mpeg2") > 0 or Instr(1, value, "mpeg 2") > 0 then return "MPEG-2"
    if Instr(1, value, "av1") > 0 then return "AV1"
    if Instr(1, value, "vp9") > 0 then return "VP9"
    if Instr(1, value, "mpeg4 2") > 0 or Instr(1, value, "mpeg 4 part 2") > 0 then return "MPEG-4 Part 2"
    return ""
end function
function Hardware_CodecFromMetadata(data as Dynamic) as String
    if data = invalid or GetInterface(data, "ifAssociativeArray") = invalid then return ""
    for each key in ["encodeFormat", "videoCodec", "video_codec", "vCodec", "videoEncoding", "videoCoding", "codec", "videoFormat"]
        label = Hardware_CodecLabel(data[key])
        if label <> "" then return label
    end for
    for each key in ["videoInfo", "videoTrack", "technicalInfo", "mediaInfo", "selectedTrack"]
        nested = data[key]
        if nested <> invalid and GetInterface(nested, "ifAssociativeArray") <> invalid
            label = Hardware_CodecFromMetadata(nested)
            if label <> "" then return label
        end if
    end for
    return ""
end function
function Hardware_CodecSupported(info as Object, codecLabel as String) as Dynamic
    if info = invalid or codecLabel = "" then return invalid
    if codecLabel = "H.264/AVC" then return info.avc
    if codecLabel = "H.265/HEVC" then return info.hevc
    if codecLabel = "MPEG-2" then return info.mpeg2
    if codecLabel = "AV1" then return info.av1
    return invalid
end function
function Hardware_Detect() as Object
    di = CreateObject("roDeviceInfo")
    if di = invalid then return { modelName: "Roku no determinado", model: "", videoMode: "No determinado" }
    details = di.GetModelDetails()
    display = di.GetDisplayProperties()
    model = SafeStr(di.GetModel())
    displayName = SafeStr(di.GetModelDisplayName())
    vendor = ""
    modelNumber = ""
    if details <> invalid
        vendor = SafeStr(details.VendorName)
        modelNumber = SafeStr(details.ModelNumber)
    end if
    modelName = displayName
    if vendor <> "" and Instr(1, LCase(modelName), LCase(vendor)) = 0 then modelName = vendor + " " + modelName
    if modelName = ""
        if vendor <> "" then modelName = vendor + " Roku" else modelName = "Roku " + model
    end if
    avc = Hardware_Decode(di, { "codec": "mpeg4 avc" })
    hevc = Hardware_Decode(di, { "codec": "hevc" })
    avc720 = Hardware_Decode(di, { "codec": "mpeg4 avc", "profile": "high", "level": "4.1", "width": 1280, "height": 720 })
    avc1080 = Hardware_Decode(di, { "codec": "mpeg4 avc", "profile": "high", "level": "4.1", "width": 1920, "height": 1080 })
    hevcMain1080 = Hardware_Decode(di, { "codec": "hevc", "profile": "main", "level": "4.1", "width": 1920, "height": 1080 })
    hevcMain4k = Hardware_Decode(di, { "codec": "hevc", "profile": "main", "level": "5.1", "width": 3840, "height": 2160 })
    hevc10 = Hardware_Decode(di, { "codec": "hevc", "profile": "main 10", "level": "5.1", "width": 3840, "height": 2160 })
    mpeg2 = Hardware_Decode(di, { "codec": "mpeg2", "width": 1920, "height": 1080 })
    av1 = Hardware_Decode(di, { "codec": "av1", "profile": "main", "level": "5.1", "width": 3840, "height": 2160 })
    hevcHls = Hardware_Decode(di, { "codec": "hevc", "container": "hls" })
    hevcTs = Hardware_Decode(di, { "codec": "hevc", "container": "ts" })
    hevcMp4 = Hardware_Decode(di, { "codec": "hevc", "container": "mp4" })
    avcHls = Hardware_Decode(di, { "codec": "mpeg4 avc", "container": "hls" })
    avcTs = Hardware_Decode(di, { "codec": "mpeg4 avc", "container": "ts" })
    avcMp4 = Hardware_Decode(di, { "codec": "mpeg4 avc", "container": "mp4" })
    hdr10 = invalid : hlg = invalid : dolbyVision = invalid : hdr10Plus = invalid
    if display <> invalid
        hdr10 = display.Hdr10
        hlg = display.HLG
        dolbyVision = display.DolbyVision
        hdr10Plus = display.Hdr10Plus
    end if
    os = di.GetOSVersion()
    osText = "No determinado"
    if os <> invalid
        osText = SafeStr(os.major) + "." + SafeStr(os.minor) + "." + SafeStr(os.revision) + " build " + SafeStr(os.build)
    end if
    return {
        model: model, modelName: modelName, modelNumber: modelNumber,
        modelType: SafeStr(di.GetModelType()), os: osText,
        videoMode: SafeStr(di.GetVideoMode()), display: display,
        avc: avc, hevc: hevc, avc720: avc720, avc1080: avc1080,
        hevcMain1080: hevcMain1080, hevcMain4k: hevcMain4k, hevcMain10: hevc10,
        mpeg2: mpeg2, av1: av1,
        hevcHls: hevcHls, hevcTs: hevcTs, hevcMp4: hevcMp4,
        avcHls: avcHls, avcTs: avcTs, avcMp4: avcMp4,
        hdr10: hdr10, hdr10Plus: hdr10Plus, hlg: hlg, dolbyVision: dolbyVision
    }
end function
function Hardware_Summary(info as Object) as String
    if info = invalid then return "Hardware no determinado"
    name = SafeStr(info.modelName)
    if name = "" then name = "Roku " + SafeStr(info.model)
    mode = SafeStr(info.videoMode)
    if mode = "" then mode = "No determinado"
    return name + "  ·  H.264 " + Hardware_Mark(info.avc) + "  ·  HEVC " + Hardware_Mark(info.hevc) + "  ·  " + mode
end function
function Hardware_DetailText(info as Object, currentFormat as String) as String
    if info = invalid then return "Información de hardware no determinada."
    t = "Modelo:             " + SafeStr(info.modelName) + " [" + SafeStr(info.model) + "]" + Chr(10)
    t = t + "Modelo específico:  " + SafeStr(info.modelNumber) + "   Tipo: " + SafeStr(info.modelType) + Chr(10)
    t = t + "Roku OS:            " + SafeStr(info.os) + "   Salida: " + SafeStr(info.videoMode) + Chr(10)
    t = t + "H.264: 720p " + Hardware_YesNo(info.avc720) + " · 1080p " + Hardware_YesNo(info.avc1080) + Chr(10)
    t = t + "HEVC Main: 1080p " + Hardware_YesNo(info.hevcMain1080) + " · 4K " + Hardware_YesNo(info.hevcMain4k) + Chr(10)
    t = t + "HEVC Main 10: " + Hardware_YesNo(info.hevcMain10) + "   MPEG-2: " + Hardware_YesNo(info.mpeg2) + "   AV1: " + Hardware_YesNo(info.av1) + Chr(10)
    t = t + "HDR10: " + Hardware_YesNo(info.hdr10) + " · HDR10+: " + Hardware_YesNo(info.hdr10Plus) + " · HLG: " + Hardware_YesNo(info.hlg) + " · Dolby Vision: " + Hardware_YesNo(info.dolbyVision) + Chr(10)
    if currentFormat = "" then currentFormat = "No determinado (sin reproducción activa)"
    return t + "Formato detectado del video actual: " + currentFormat
end function
function CodecCache_CodeToLabel(code as String) as String
    if code = "4" then return "H.264/AVC"
    if code = "6" then return "H.265/HEVC"
    if code = "2" then return "MPEG-2"
    if code = "A" then return "AV1"
    if code = "V" then return "VP9"
    return Hardware_CodecLabel(code)
end function
function CodecCache_LabelToCode(label as String) as String
    if label = "H.264/AVC" then return "4"
    if label = "H.265/HEVC" then return "6"
    if label = "MPEG-2" then return "2"
    if label = "AV1" then return "A"
    if label = "VP9" then return "V"
    return ""
end function
function CodecCache_Load() as Object
    out = {}
    rawStatic = ReadAsciiFile("pkg:/rsc/vod_codecs.json")
    if rawStatic <> ""
        staticMap = ParseJSON(rawStatic)
        if staticMap <> invalid
            if staticMap["4"] <> invalid
                for each cid in staticMap["4"]
                    idStr = SafeStr(cid)
                    if idStr <> "" then out[idStr] = "H.264/AVC"
                end for
            end if
            if staticMap["6"] <> invalid
                for each cid in staticMap["6"]
                    idStr = SafeStr(cid)
                    if idStr <> "" then out[idStr] = "H.265/HEVC"
                end for
            end if
        end if
    end if
    reg = CreateObject("roRegistrySection", "xuper_vod_codecs")
    if reg = invalid or not reg.Exists("map") then return out
    parsed = ParseJSON(reg.Read("map"))
    if parsed = invalid or parsed.items = invalid then return out
    for each k in parsed.items
        lbl = CodecCache_CodeToLabel(SafeStr(parsed.items[k]))
        if lbl <> "" then out[k] = lbl
    end for
    return out
end function
sub CodecCache_Save(key as String, codecLabel as String)
    if key = "" then return
    code = CodecCache_LabelToCode(codecLabel)
    if code = "" then return
    reg = CreateObject("roRegistrySection", "xuper_vod_codecs")
    if reg = invalid then return
    data = invalid
    if reg.Exists("map") then data = ParseJSON(reg.Read("map"))
    if data = invalid or data.items = invalid or data.order = invalid
        data = { order: [], items: {} }
    end if
    if data.items[key] = code then return
    if data.items[key] = invalid
        data.order.Push(key)
        while data.order.Count() > 200
            oldKey = data.order.Shift()
            if oldKey <> invalid then data.items.Delete(oldKey)
        end while
    end if
    data.items[key] = code
    reg.Write("map", FormatJson(data))
    reg.Flush()
end sub
function VodFilterPref_Load(defaultMode = "all" as String) as String
    reg = CreateObject("roRegistrySection", "xuper_prefs")
    if reg = invalid or not reg.Exists("vod_filter") then return defaultMode
    v = SafeStr(reg.Read("vod_filter"))
    if v = "all" or v = "hide_hevc" or v = "only_h264" then return v
    return defaultMode
end function
sub VodFilterPref_Save(mode as String)
    reg = CreateObject("roRegistrySection", "xuper_prefs")
    if reg = invalid then return
    reg.Write("vod_filter", mode)
    reg.Flush()
end sub
