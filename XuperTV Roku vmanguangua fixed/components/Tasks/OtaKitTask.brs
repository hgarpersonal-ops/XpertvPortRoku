sub init()
    m.top.functionName = "RunOtaCheck"
end sub

sub RunOtaCheck()
    defaultOtaUrl = "https://raw.githubusercontent.com/hgarpersonal-ops/XpertvPortRoku/main/XuperTV%20Roku%20vmanguangua%20fixed/rsc/4d91.dat"
    defaultManUrl = "https://raw.githubusercontent.com/hgarpersonal-ops/XpertvPortRoku/main/XuperTV%20Roku%20vmanguangua%20fixed/manifest"

    curKit = v4a21()
    otaUrl = defaultOtaUrl
    manUrl = defaultManUrl
    curKv  = v4a21_activeKv()
    curKitVer = 0
    if curKit <> invalid
        if IsValidStr(SafeStr(curKit.otaUrl)) then otaUrl = SafeStr(curKit.otaUrl).Trim()
        if IsValidStr(SafeStr(curKit.manifestUrl)) then manUrl = SafeStr(curKit.manifestUrl).Trim()
        curKitVer = AsInt(curKit.kitVersion)
    end if

    ts = CreateObject("roDateTime").AsSeconds().ToStr()
    sep = "?"
    if Instr(1, otaUrl, "?") > 0 then sep = "&"
    rawHex = FetchOtaText(otaUrl + sep + "_t=" + ts, 7000)

    kitUpdated = false
    needsRenew = false
    outKitVer  = curKitVer
    statusMsg  = "error_red"

    if rawHex <> ""
        res = v4a21_saveOta(rawHex)
        if res.ok = true
            outKitVer = AsInt(res.kit.kitVersion)
            kitUpdated = (res.updated = true)
            newKv = SafeStr(res.kit.kv)
            if newKv <> "" and newKv <> curKv
                needsRenew = true
            else if kitUpdated and m.top.forceRenew = true
                needsRenew = true
            end if
            if kitUpdated
                statusMsg = "ok_actualizado"
            else
                statusMsg = "ok_al_dia"
            end if
        else
            statusMsg = "kit_invalido"
        end if
    end if

    ' Revisar manifest remoto para saber si hay una compilación ZIP más reciente
    sepM = "?"
    if Instr(1, manUrl, "?") > 0 then sepM = "&"
    manTxt = FetchOtaText(manUrl + sepM + "_t=" + ts, 5000)
    rBuild = ParseManifestBuild(manTxt)

    m.top.kitVer      = outKitVer
    m.top.remoteBuild = rBuild
    m.top.kitUpdated  = kitUpdated
    m.top.needsRenew  = needsRenew
    m.top.status      = statusMsg
    m.top.done        = true
end sub

function FetchOtaText(url as String, timeoutMs as Integer) as String
    req = CreateObject("roUrlTransfer")
    req.SetUrl(url)
    req.AddHeader("User-Agent", "XuperTV-Roku-OTA/1.0")
    req.AddHeader("Cache-Control", "no-cache")
    req.EnableEncodings(true)
    req.SetCertificatesFile("common:/certs/ca-bundle.crt")
    req.InitClientCertificates()
    port = CreateObject("roMessagePort")
    req.SetMessagePort(port)
    if not req.AsyncGetToString() then return ""
    msg = wait(timeoutMs, port)
    if msg = invalid
        req.AsyncCancel()
        return ""
    end if
    if type(msg) <> "roUrlEvent" then return ""
    if msg.GetResponseCode() <> 200 then return ""
    s = msg.GetString()
    if s = invalid then return ""
    return s.Trim()
end function

function ParseManifestBuild(txt as String) as Integer
    if txt = "" then return 0
    lines = txt.Replace(Chr(13), "").Split(Chr(10))
    for each ln in lines
        t = ln.Trim()
        if Left(t, 14) = "build_version="
            return AsInt(Mid(t, 15))
        end if
    end for
    return 0
end function
