#NoEnv
IniRead, watchFolder, % A_ScriptDir "\config.ini", Settings, watchFolder
IniRead, discordWebhook, % A_ScriptDir "\config.ini", Settings, discordWebhook
IniRead, pixeldrainApiKey, % A_ScriptDir "\config.ini", Settings, pixeldrainApiKey
IniRead, maxCatboxMB, % A_ScriptDir "\config.ini", Settings, maxCatboxMB
IniRead, maxPixelMB, % A_ScriptDir "\config.ini", Settings, maxPixelMB

#SingleInstance, Force
#Persistent
SetBatchLines, -1

uploadedFolder      := watchFolder . "\uploaded"

FileCreateDir, %watchFolder%
FileCreateDir, %uploadedFolder%

processed := Object()

SetTimer, CheckNew, 1000
return

CheckNew() {
    global processed, watchFolder, uploadedFolder
    now := A_TickCount

    for path, t in processed
        if (now - t > 86400000)
            processed.Delete(path)

    Loop, Files, % watchFolder "\*.*", F
    {
        full := A_LoopFileFullPath
        localFileName := A_LoopFileName

        if processed.HasKey(full)
            continue

        if (A_LoopIsFolder)
            continue

        if (InStr(FileExist(full), "D"))
            continue

        if (SubStr(full, 1, StrLen(uploadedFolder)) = uploadedFolder)
            continue

        FileGetSize, sz1, %full%
        Sleep, 2000
        FileGetSize, sz2, %full%

        if (sz1 == sz2) {
            processed[full] := now
            doUpload(full, sz2, localFileName)
        }
    }
}

doUpload(filePath, szBytes, fileNameOnly) {
    global maxCatboxMB, maxPixelMB, discordWebhook, pixeldrainApiKey, uploadedFolder

    szMB := Round(szBytes/1048576, 2)

    host := szMB <= maxCatboxMB ? "catbox"
          : szMB <= maxPixelMB  ? "pixeldrain"
          : ""

    if !host
        return

    if (host = "catbox")
        cmd_upload := "curl -s -F ""reqtype=fileupload"" -F ""fileToUpload=@""" . filePath . """"" https://catbox.moe/user/api.php 2>&1"
    else
        cmd_upload := "curl -s -u :" . pixeldrainApiKey . " -F ""file=@""" . filePath . """"" https://pixeldrain.com/api/file 2>&1"

    output := execStdoutHidden(cmd_upload)
    if !output
        return

    if (host = "pixeldrain") {
        if !RegExMatch(output, """id""\s*:\s*""([^""]+)""", m)
            return
        url := "https://pixeldrain.com/u/" . m1
    } else
        url := output

    if !RegExMatch(url, "^https?://")
        return

    content := url
    esc := escapeJson(content)
    payload := "{""content"":""" . esc . """}"

    tempPayloadFile := A_Temp . "\" . A_YYYY . A_MM . A_DD . A_Hour . A_Min . A_Sec . A_MSec . "_payload.json"
    FileDelete, %tempPayloadFile%
    FileAppend, %payload%, *%tempPayloadFile%, UTF-8-RAW

    cmd_discord := "curl -s -H ""Content-Type: application/json"" -X POST -d @""" . tempPayloadFile . """ " . discordWebhook . " 2>&1"
    
    res := execStdoutHidden(cmd_discord)
    FileDelete, %tempPayloadFile%

    if (!res) {
        FileMove, %filePath%, %uploadedFolder%\%fileNameOnly%, 1 
    } else if (InStr(res, "error") || InStr(res, "bad request") || InStr(res, "400") || InStr(res, "401") || InStr(res, "403") || InStr(res, "curl:")) {
        return
    } else {
        FileMove, %filePath%, %uploadedFolder%\%fileNameOnly%, 1 
    }
}

execStdoutHidden(cmd) {
    shell := ComObjCreate("WScript.Shell")
    DetectHiddenWindows, On
    Run, %ComSpec%,, Hide, pid 
    WinWait, ahk_pid %pid%,, 5 
    If ErrorLevel {
        Process, Close, %pid% 
        return "ERROR: Hidden console not ready."
    }
    DllCall("AttachConsole", "UInt", pid)
    proc := shell.Exec(ComSpec . " /c " . cmd)
    output := proc.StdOut.ReadAll()
    DllCall("FreeConsole")
    Process, Close, %pid%
    return output
}

escapeJson(str) {
    StringReplace, str, str, \, \\, All
    StringReplace, str, str, ", \", All
    return str
}