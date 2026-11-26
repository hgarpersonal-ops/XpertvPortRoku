function v4a16(s as String) as String
    ba = CreateObject("roByteArray")
    ba.FromAsciiString(s)
    d = CreateObject("roEVPDigest")
    d.Setup("md5")
    return LCase(d.Process(ba))
end function
function v4a17() as String
    info = CreateObject("roAppInfo")
    return info.GetValue("major_version") + "." + info.GetValue("minor_version") + "." + info.GetValue("build_version")
end function
