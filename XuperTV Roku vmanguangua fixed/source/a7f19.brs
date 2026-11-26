function Q(s as String) as String
    return Chr(34) + JsonEsc(s) + Chr(34)
end function
function JsonEsc(s as String) as String
    bs = Chr(92)
    out = s.Replace(bs, bs + bs)
    out = out.Replace(Chr(34), bs + Chr(34))
    out = out.Replace(Chr(13), " ")
    out = out.Replace(Chr(10), " ")
    out = out.Replace(Chr(9), " ")
    return out
end function
function AsInt(v as Dynamic) as Integer
    if v = invalid then return 0
    if Type(v) = "String" or Type(v) = "roString" then return Int(Val(v))
    return Int(v)
end function
function Api_PortalHosts() as Object
    return [
        "edastu.udigkkrc.com",
        "brkhzs.udigkkrc.com",
        "mptec.dhkrxuzcy.com",
        "ftmrmy.jdfey0cd.com",
        "fuxok.nguvmqhpk.com",
        "eajmnp.hcgv1dt8.com",
        "hinumz.a878kkoyc.com",
        "krdwvd.swcaw7qx.com",
        "osuhk.m3x8o50te.com",
        "oogoy.f30c96w8.com"
    ]
end function
function Api_HostFromUrl(u as String) as String
    s = SafeStr(u).Replace("https://", "").Replace("http://", "")
    sp = Instr(1, s, "/")
    if sp > 0 then s = Left(s, sp - 1)
    return s.Trim()
end function
function Api_BasePathOf(baseUrl as String) as String
    s = SafeStr(baseUrl).Replace("https://", "").Replace("http://", "")
    sp = Instr(1, s, "/")
    if sp > 0 then return Mid(s, sp)
    return "/api/portalCore"
end function
function Api_PreferredPortalHost() as String
    reg = CreateObject("roRegistrySection", "xuper_prefs")
    if reg <> invalid and reg.Exists("portal_host")
        return SafeStr(reg.Read("portal_host")).Trim()
    end if
    return ""
end function
sub Api_SavePreferredPortalHost(host as String)
    h = SafeStr(host).Trim()
    if h = "" then return
    reg = CreateObject("roRegistrySection", "xuper_prefs")
    if reg = invalid then return
    if reg.Exists("portal_host") and reg.Read("portal_host") = h then return
    reg.Write("portal_host", h)
    reg.Flush()
end sub
function Api_PortalHeaders(k as Object) as Object
    h = {}
    if k <> invalid and k.headers <> invalid
        for each name in k.headers
            h[name] = k.headers[name]
        end for
    end if
    di = CreateObject("roDeviceInfo")
    traceId = ""
    if di <> invalid then traceId = LCase(di.GetRandomUUID())
    if traceId = "" then traceId = "00000000-0000-4000-8000-000000000000"
    h["X-Request-Trace"] = traceId
    h["X-Client-Meta"]   = v4a16(traceId + "213f24ac-14b7-4c03-a209-383ead1b014f")
    return h
end function
function Api_BuildPortalUrls(op as String, k as Object) as Object
    urls = []
    if k = invalid or k.ops = invalid then return urls
    entry = k.ops[op]
    if entry = invalid then return urls
    basePath = Api_BasePathOf(SafeStr(k.base))
    paths = [SafeStr(entry.path)]
    if op = "slbInfo" and SafeStr(entry.path) <> "/v14/getSlbInfo"
        paths.Push("/v14/getSlbInfo")
    else if op = "vodRows" and SafeStr(entry.path) <> "/getNextColumns"
        paths.Push("/getNextColumns")
    end if
    orderedHosts = []
    seenHost = {}
    pref = Api_PreferredPortalHost()
    if pref <> ""
        orderedHosts.Push(pref)
        seenHost[pref] = true
    end if
    baseHost = Api_HostFromUrl(SafeStr(k.base))
    if baseHost <> "" and seenHost[baseHost] = invalid
        orderedHosts.Push(baseHost)
        seenHost[baseHost] = true
    end if
    for each h in Api_PortalHosts()
        if seenHost[h] = invalid
            orderedHosts.Push(h)
            seenHost[h] = true
        end if
    end for
    for each opPath in paths
        for each h in orderedHosts
            urls.Push("https://" + h + basePath + opPath)
        end for
    end for
    if orderedHosts.Count() > 0
        urls.Push("http://" + orderedHosts[0] + basePath + paths[0])
    end if
    return urls
end function
function Api_OpTask(op as String, args as Object) as Dynamic
    k = v4a21()
    if k = invalid then return invalid
    body = v4a32(op, args)
    if body = "" then return invalid
    urls = Api_BuildPortalUrls(op, k)
    if urls.Count() = 0 then return invalid
    t = createObject("roSGNode", "XuperTask")
    t.url     = urls[0]
    t.urls    = urls
    t.headers = Api_PortalHeaders(k)
    t.body    = body
    return t
end function
function Api_ParseOp(rawResp as String) as Dynamic
    outer = ParseJSON(rawResp)
    if outer = invalid then return invalid
    rc = SafeStr(outer.returnCode)
    if rc <> "0"
        if v4a37(rc)
            sc = m.top.getScene()
            if sc <> invalid then sc.sessionStale = true
        end if
        return invalid
    end if
    if Type(outer.data) = "String" and outer.data <> ""
        k = v4a21()
        if k = invalid then return invalid
        plain = v4a05(outer.data, k.key)
        if plain = "" then return invalid
        return ParseJSON(plain)
    end if
    return outer.data
end function
function Api_LicenseGone(err as Dynamic) as Boolean
    return false
end function
