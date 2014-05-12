; ===================================================================================
; AHK Version ...: AHK_L 1.1.13.01 x64 Unicode
; Win Version ...: Windows 7 Professional x64 SP1
; Description ...: htopmini v0.8.0
; Version .......: 2013.11.05-1240
; Author ........: jNizM
; License .......: WTFPL
; License URL ...: http://www.wtfpl.net/txt/copying/
; ===================================================================================
;@Ahk2Exe-SetName htopmini
;@Ahk2Exe-SetDescription htopmini
;@Ahk2Exe-SetVersion 2013.11.05-1240
;@Ahk2Exe-SetCopyright Copyright (c) 2013`, jNizM
;@Ahk2Exe-SetOrigFilename htopmini.ahk


; ###################################################################################
; ### GLOBAL SETTINGS                                                             ###
; ###################################################################################

;#Warn
#NoEnv
#SingleInstance Force
global Kernel32     := LoadLibrary("Kernel32")
global WinTitel     := "htopmini " A_Now
global Today        := A_DD "." A_MM "." A_YYYY
global OldFormat    := A_FormatInteger
global varPerc      := 0
global Weather_ID   := "693838"                                      ; Yahoo Weather Location ID
global Weather_DG   := "c"                                           ; Celius = c | Fahrenheit = f
global ownPID       := DllCall(Kernel32.GetCurrentProcessId)         ; Get Process ID of this tool
global BuildVersion := DllCall(Kernel32.GetVersion) >> 16 & 0xffff   ; Get Windows Build Version


; ###################################################################################
; ### MENU                                                                        ###
; ###################################################################################

Menu, Tray, DeleteAll
Menu, Tray, NoStandard
Menu, Tray, Add, Toggle Percentage, Menu_Percentage
Menu, Tray, Add,
Menu, Tray, Add, Toggle Transparency, Menu_Transparency
Menu, Tray, Add, Toggle AlwaysOnTop, Menu_AlwaysOnTop
Menu, Tray, Add, Show/Hide, Menu_ShowHide
Menu, Tray, Add,
Menu, Tray, Add, Exit, Close
Menu, Tray, Default, Show/Hide
Menu, Tray, ToggleCheck, Toggle Transparency


; ###################################################################################
; ### GUI MAIN                                                                    ###
; ###################################################################################

Gui +LastFound -Caption +ToolWindow +hwndhMain
Gui, Margin, 10, 10
Gui, Color, 000000
Gui, Font, cFFFFFF, Consolas
Gui, Add, Text,     xm     ym w250 vTime01
Gui, Add, Text,     xm+260 ym w170 0x202 vTemp01,
Gui, Add, Text,     xm     y+2  w430 h1 0x7

Gui, Font, cFFFFFF,
Gui, Add, Text,     xm     y+4 w30 0x200, CPU:
Gui, Font, c00FF00,
Gui, Add, Text,     xm+40  yp w80 0x202 vCPU1,
Gui, Add, Text,     xm+140 yp   w80 0x202 vCPU2,
Gui, Add, Progress, xm+250 yp+1 w180 h10 BackgroundF0F0F0 vCPU3,
Gui, Add, Text,     xm     y+3  w430 h1 0x7

Gui, Font, cFFFFFF,
Gui, Add, Text,     xm     y+3 w30 0x200, Mem:
Gui, Font, c00FF00,
Gui, Add, Text,     xm+40  yp   w80 0x202 vMEM01,
Gui, Font, cFFFFFF,
Gui, Add, Text,     xm+140 yp   w80 0x202 vMEM02,
Gui, Add, Progress, xm+250 yp+1 w180 h10 BackgroundF0F0F0 vMEM03,
Gui, Font, c000000 s7,
Gui, Add, Text,     xm+250 yp w180 h11 0x202 +BackgroundTrans vMEM04,

Gui, Font, cFFFFFF s8,
Gui, Add, Text,     xm     y+3 w30 0x200, Swp:
Gui, Font, c00FF00,
Gui, Add, Text,     xm+40  yp   w80 0x202 vSWP01,
Gui, Font, cFFFFFF,
Gui, Add, Text,     xm+140 yp   w80 0x202 vSWP02,
Gui, Add, Progress, xm+250 yp+1 w180 h10 BackgroundF0F0F0 vSWP03,
Gui, Font, c000000 s7,
Gui, Add, Text,     xm+250 yp w180 h11 0x202 +BackgroundTrans vSWP04,
Gui, Font, cFFFFFF s8,
Gui, Add, Text,     xm     y+3  w430 h1 0x7

DriveGet, DrvLstFxd, List, FIXED
loop, Parse, DrvLstFxd
{
    Gui, Font, cFFFFFF,
    Gui, Add, Text,     xm     y+1 w30 0x200, F_%A_Loopfield%:\
    Gui, Font, c00FF00,
    Gui, Add, Text,     xm+40  yp w80 0x202 vD%A_Loopfield%1,
    Gui, Font, cFFFFFF,
    Gui, Add, Text,     xm+140 yp w80 0x202 vD%A_Loopfield%2,
    Gui, Add, Progress, xm+250 yp+1 w180 h10 vD%A_Loopfield%3,
    Gui, Font, c000000 s7,
    Gui, Add, Text,     xm+250 yp w180 h11 0x202 +BackgroundTrans vD%A_Loopfield%4,
    Gui, Font, cFFFFFF s8,
}
DriveGet, DrvLstRmvbl, List, REMOVABLE
loop, Parse, DrvLstRmvbl
{
    Gui, Font, cFFFFFF,
    Gui, Add, Text,     xm     y+1 w30 0x200, R_%A_Loopfield%:\
    Gui, Font, c00FF00,
    Gui, Add, Text,     xm+40  yp w80 0x202 vD%A_Loopfield%1,
    Gui, Font, cFFFFFF,
    Gui, Add, Text,     xm+140 yp w80 0x202 vD%A_Loopfield%2,
    Gui, Add, Progress, xm+250 yp+1 w180 h10 vD%A_Loopfield%3,
    Gui, Font, c000000 s7,
    Gui, Add, Text,     xm+250 yp w180 h11 0x202 +BackgroundTrans vD%A_Loopfield%4,
    Gui, Font, cFFFFFF s8,
}
DriveGet, DrvLstNtwrk, List, NETWORK
loop, Parse, DrvLstNtwrk
{
    Gui, Font, cFFFFFF,
    Gui, Add, Text,     xm     y+1 w30 0x200, N_%A_Loopfield%:\
    Gui, Font, c00FF00,
    Gui, Add, Text,     xm+40  yp w80 0x202 vD%A_Loopfield%1,
    Gui, Font, cFFFFFF,
    Gui, Add, Text,     xm+140 yp w80 0x202 vD%A_Loopfield%2,
    Gui, Add, Progress, xm+250 yp+1 w180 h10 vD%A_Loopfield%3,
    Gui, Font, c000000 s7,
    Gui, Add, Text,     xm+250 yp w180 h11 0x202 +BackgroundTrans vD%A_Loopfield%4,
    Gui, Font, cFFFFFF s8,
}
Gui, Add, Text,     xm     y+3  w430 h1 0x7

Gui, Font, cFFFFFF,
Gui, Add, Text,     xm     y+1  w30 0x200, IN\OUT:
Gui, Font, c00FF00,
Gui, Add, Text,     xm+40  yp   w80 0x202 vIN1,
Gui, Font, cFF0000,
Gui, Add, Text,     xm+140 yp   w80 0x202 vOU1,
Gui, Add, Text,     xm     y+3  w430 h1 0x7

Gui, Font, cFFFFFF,
Gui, Add, Text,     xm     y+10 w150 0x200 vOwnMem,
Gui, Add, Button,   xm+240 yp-6 w60 h20 -Theme 0x8000 gClear, Clear
Gui, Add, Button,   xm+305 yp   w60 h20 -Theme 0x8000 gMinimi, Minimi
Gui, Add, Button,   xm+370 yp   w60 h20 -Theme 0x8000 gClose, Close
Gui, Show, AutoSize, %WinTitel%
WinSet, Transparent, 150, %WinTitel%

SetTimer, UpdateTime, 1000
SetTimer, UpdateWeather, -1000
SetTimer, UpdateCPULoad, -1000
SetTimer, UpdateMemory, -1000
SetTimer, UpdateTraffic, 1000
SetTimer, UpdateDrive, -1000
SetTimer, UpdateMemHtop, -1000

OnMessage(0x201, "WM_LBUTTONDOWN")
WM_LBUTTONDOWN(wParam, lParam, msg, hwnd)
{
    global hMain
    if (hwnd = hMain)
        PostMessage, 0xA1, 2,,, %WinTitel%
}
return


; ###################################################################################
; ### SCRIPT                                                                      ###
; ###################################################################################

UpdateTime:
    GuiControl,, Time01, % Today "  " A_Hour ":" A_Min ":" A_Sec " | Up: " FormatSeconds(((A_Is64bitOS = "1") ? DllCall(Kernel32.GetTickCount64) : DllCall(Kernel32.GetTickCount)) / 1000)
return

UpdateWeather:
    url := DownloadToString("http://weather.yahooapis.com/forecastrss?w=" Weather_ID "&u=" Weather_DG)
    RegExMatch(url, "(?<=Weather for )(.*)(?=\<\/description\>\s\<language\>)", varCity)
    RegExMatch(url, "(?<=temp="")(.*)(?=""  date)", varTemp)
    RegExMatch(url, "(?<=temperature="")(.*)(?=""\s*distance)", varUnits)
    GuiControl,, Temp01, % varCity " | " varTemp " °" varUnits
    SetTimer, UpdateWeather, 60000
return

UpdateCPULoad:
    GuiControl,, CPU1, % GetProcessCount() " proc"
    SetFormat, Float, 02
    CPU := GetSystemTimes()
    GuiControl,, CPU2, % CPU " % "
    GuiControl, % (CPU <= "50") ? "+c00FF00" : (CPU <= "80") ? "+cFFA500" : "+cFF0000", CPU3
    GuiControl,, CPU3, % CPU
    SetFormat, Integer, %OldFormat%
    SetTimer, UpdateCPULoad, 1000
return

UpdateMemory:
    GMSEx := GlobalMemoryStatusEx()
    GMSExM01 := Round(GMSEx[2] / 1024**2, 2)               ; Total Physical Memory in MB
    GMSExM02 := Round(GMSEx[3] / 1024**2, 2)               ; Available Physical Memory in MB
    GMSExM03 := Round(GMSExM01 - GMSExM02, 2)              ; Used Physical Memory in MB
    GMSExM04 := Round(GMSExM03 / GMSExM01 * 100, 2)        ; Used Physical Memory in %
    GMSExS01 := Round(GMSEx[4] / 1024**2, 2)               ; Total PageFile in MB
    GMSExS02 := Round(GMSEx[5] / 1024**2, 2)               ; Available PageFile in MB
    GMSExS03 := Round(GMSExS01 - GMSExS02, 2)              ; Used PageFile in MB
    GMSExS04 := Round(GMSExS03 / GMSExS01 * 100, 2)        ; Used PageFile in %
    
    GuiControl,, MEM01, % GMSExM03 " MB"
    GuiControl,, MEM02, % GMSExM01 " MB"
    GuiControl, % (GMSExM04 <= "75") ? "+c00FF00" : (GMSExM04 <= "90") ? "+cFFA500" : "+cFF0000", MEM03
    GuiControl,, MEM03, % GMSExM04
    GuiControl,, MEM04, % (varPerc = "1") ? GMSExM04 " % " : ""

    GuiControl,, SWP01, % GMSExS03 " MB"
    GuiControl,, SWP02, % GMSExS01 " MB"
    GuiControl, % (GMSExS04 <= "75") ? "+c00FF00" : (GMSExS04 <= "90") ? "+cFFA500" : "+cFF0000", SWP03
    GuiControl,, SWP03, % GMSExS04
    GuiControl,, SWP04, % (varPerc = "1") ? GMSExS04 " % " : ""
    
    SetTimer, UpdateMemory, 2000
return

UpdateDrive:
    loop, Parse, DrvLstFxd
    {
        DriveGet, cap%A_Loopfield%, Capacity, %A_Loopfield%:\
        DriveSpaceFree, free%A_Loopfield%, %A_Loopfield%:\
        used%A_Loopfield% := cap%A_Loopfield% - free%A_Loopfield%
        perc%A_Loopfield% := used%A_Loopfield% / cap%A_Loopfield% * 100
        GuiControl,, D%A_Loopfield%1, % Round(used%A_Loopfield% / 1024, 2) " GB"
        GuiControl,, D%A_Loopfield%2, % Round(cap%A_Loopfield% / 1024, 2) " GB"
        GuiControl, % "+Range0-" cap%A_Loopfield%, D%A_Loopfield%3
        GuiControl, % (perc%A_Loopfield% <= "80") ? "+c00FF00" : (perc%A_Loopfield% <= "90") ? "+cFFA500" : "+cFF0000", D%A_Loopfield%3
        GuiControl,, D%A_Loopfield%3, % used%A_Loopfield%
        GuiControl,, D%A_Loopfield%4, % (varPerc = "1") ? Round(perc%A_Loopfield%, 2) " % " : ""
    }
    loop, Parse, DrvLstRmvbl
    {
        DriveGet, cap%A_Loopfield%, Capacity, %A_Loopfield%:\
        DriveSpaceFree, free%A_Loopfield%, %A_Loopfield%:\
        used%A_Loopfield% := cap%A_Loopfield% - free%A_Loopfield%
        perc%A_Loopfield% := used%A_Loopfield% / cap%A_Loopfield% * 100
        GuiControl,, D%A_Loopfield%1, % Round(used%A_Loopfield% / 1024, 2) " GB"
        GuiControl,, D%A_Loopfield%2, % Round(cap%A_Loopfield% / 1024, 2) " GB"
        GuiControl, % "+Range0-" cap%A_Loopfield%, D%A_Loopfield%3
        GuiControl, % (perc%A_Loopfield% <= "80") ? "+c00FF00" : (perc%A_Loopfield% <= "90") ? "+cFFA500" : "+cFF0000", D%A_Loopfield%3
        GuiControl,, D%A_Loopfield%3, % used%A_Loopfield%
        GuiControl,, D%A_Loopfield%4, % (varPerc = "1") ? Round(perc%A_Loopfield%, 2) " % " : ""
    }
    loop, Parse, DrvLstNtwrk
    {
        DriveGet, cap%A_Loopfield%, Capacity, %A_Loopfield%:\
        DriveSpaceFree, free%A_Loopfield%, %A_Loopfield%:\
        used%A_Loopfield% := cap%A_Loopfield% - free%A_Loopfield%
        perc%A_Loopfield% := used%A_Loopfield% / cap%A_Loopfield% * 100
        GuiControl,, D%A_Loopfield%1, % Round(used%A_Loopfield% / 1024, 2) " GB"
        GuiControl,, D%A_Loopfield%2, % Round(cap%A_Loopfield% / 1024, 2) " GB"
        GuiControl, % "+Range0-" cap%A_Loopfield%, D%A_Loopfield%3
        GuiControl, % (perc%A_Loopfield% <= "80") ? "+c00FF00" : (perc%A_Loopfield% <= "90") ? "+cFFA500" : "+cFF0000", D%A_Loopfield%3
        GuiControl,, D%A_Loopfield%3, % used%A_Loopfield%
        GuiControl,, D%A_Loopfield%4, % (varPerc = "1") ? Round(perc%A_Loopfield%, 2) " % " : ""
    }
    SetTimer, UpdateDrive, 5000
return

UpdateTraffic:
    dnNew := 0
    upNew := 0
    GetIfTable(tb)
    loop, % DecodeInteger(&tb)
    {
        dnNew += DecodeInteger(&tb + 4 + 860 * (A_Index - 1) + 552)
        upNew += DecodeInteger(&tb + 4 + 860 * (A_Index - 1) + 576)
    }
    dnRate := Round((dnNew - dnOld) / 1024)
    upRate := Round((upNew - upOld) / 1024)
    GuiControl,, In1, % dnRate " kb/s"
    GuiControl,, Ou1, % upRate " kb/s"
    dnOld := dnNew
    upOld := upNew
return

UpdateMemHtop:
    if (BuildVersion >= "7600") {
        GPMI := GetProcessMemoryInfo_PMCEX(ownPID)
        PUsage := Round(GPMI[10] / 1024, 0)
    } else {
        GPMI := GetProcessMemoryInfo_PMC(ownPID)
        PUsage := Round(GPMI[8] / 1024, 0)
    }
    GuiControl,, OwnMem, % "PID: " ownPID " | " PUsage " K"
    SetTimer, UpdateMemHtop, 2000
return

Clear:
    ClearMemory()
    FreeMemory()
return

Minimi:
    Gui, Hide
return

Menu_Percentage:
    varPerc := (varPerc = "0") ? "1" : "0"
    Menu, Tray, ToggleCheck, Toggle Percentage
return

Menu_Transparency:
    WinGet, ct, Transparent, %WinTitel%
    WinSet, Transparent, % ct = "150" ? "Off" : "150", %WinTitel%
    Menu, Tray, ToggleCheck, Toggle Transparency
return

Menu_AlwaysOnTop:
    WinSet, AlwaysOnTop, Toggle, %WinTitel%
    Menu, Tray, ToggleCheck, Toggle AlwaysOnTop
return

Menu_ShowHide:
    WinGet, winStyle, Style, %WinTitel%
    if (winStyle & 0x10000000)
        WinHide, %WinTitel%
    else
    {
        WinShow, %WinTitel%
        WinSet, AlwaysOnTop, Toggle, %WinTitel%
        WinSet, AlwaysOnTop, Toggle, %WinTitel%
    }
return


; ###################################################################################
; ### FUNCTIONS                                                                   ###
; ###################################################################################

; DownloadToString ==================================================================
DownloadToString(url, encoding="utf-8") {
    static a := "AutoHotkey/" A_AhkVersion
    if (!DllCall("LoadLibrary", "str", "wininet") || !(h := DllCall("wininet\InternetOpen", "str", a, "uint", 1, "ptr", 0, "ptr", 0, "uint", 0, "ptr")))
        return 0
    c := s := 0, o := ""
    if (f := DllCall("wininet\InternetOpenUrl", "ptr", h, "str", url, "ptr", 0, "uint", 0, "uint", 0x80003000, "ptr", 0, "ptr")) {
        while (DllCall("wininet\InternetQueryDataAvailable", "ptr", f, "uint*", s, "uint", 0, "ptr", 0) && s > 0) {
            VarSetCapacity(b, s, 0)
            DllCall("wininet\InternetReadFile", "ptr", f, "ptr", &b, "uint", s, "uint*", r)
            o .= StrGet(&b, r >> (encoding = "utf-16" || encoding = "cp1200"), encoding)
        }
        DllCall("wininet\InternetCloseHandle", "ptr", f)
    }
    DllCall("wininet\InternetCloseHandle", "ptr", h)
    return o
}

; ProcessCount ======================================================================
GetProcessCount() {
    proc := ""
    for process in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process")
        proc++
    return proc
}

; GetSystemTimes ====================================================================
GetSystemTimes() {
   static oldIdleTime, oldKernelTime, oldUserTime
   static lpIdleTime, lpKernelTime, lpUserTime
   oldIdleTime := lpIdleTime, oldKernelTime := lpKernelTime, oldUserTime := lpUserTime
   DllCall(Kernel32.GetSystemTimes, "int64P", lpIdleTime, "int64P", lpKernelTime, "int64P", lpUserTime)
   return (1 - (lpIdleTime - oldIdleTime) / (lpKernelTime - oldKernelTime + lpUserTime - oldUserTime)) * 100
}

; GlobalMemoryStatus ================================================================
GlobalMemoryStatusEx() {
    static MSEx, init := VarSetCapacity(MSEx, 64, 0) && NumPut(64, MSEx, "UInt")
    DllCall(Kernel32.GlobalMemoryStatusEx, "Ptr", &MSEx)
    return { 2 : NumGet(MSEx,  8, "UInt64"), 3 : NumGet(MSEx, 16, "UInt64"), 4 : NumGet(MSEx, 24, "UInt64"), 5 : NumGet(MSEx, 32, "UInt64") }
}

; GetProcessMemoryInfo ==============================================================
GetProcessMemoryInfo_PMCEX(PID) {
    pu := ""
    hProcess := DllCall(Kernel32.OpenProcess, "UInt", 0x001F0FFF, "UInt", 0, "UInt", PID)
    if (hProcess) {
        static PMCEX, size := (A_PtrSize = 8 ? 80 : 44), init := VarSetCapacity(PMCEX, size, 0) && NumPut(size, PMCEX)
        if (DllCall(Kernel32.K32GetProcessMemoryInfo, "Ptr", hProcess, "UInt", &PMCEX, "UInt", size))
            pu := { 10 : NumGet(PMCEX, (A_PtrSize = 8 ? 72 : 40), "Ptr") }
        DllCall(Kernel32.CloseHandle, "Ptr", hProcess)
    }
    return pu
}
GetProcessMemoryInfo_PMC(PID) {
    pu := ""
    hProcess := DllCall(Kernel32.OpenProcess, "UInt", 0x001F0FFF, "UInt", 0, "UInt", PID)
    if (hProcess) {
        static PMC, size := (A_PtrSize = 8 ? 72 : 40), init := VarSetCapacity(PMC, size, 0) && NumPut(size, PMC)
        if (DllCall("psapi.dll\GetProcessMemoryInfo", "Ptr", hProcess, "UInt", &PMC, "UInt", size))
            pu := { 8 : NumGet(PMC, (A_PtrSize = 8 ? 56 : 32), "Ptr") }
        DllCall(Kernel32.CloseHandle, "Ptr", hProcess)
    }
    return pu
}

; FormatSeconds =====================================================================
FormatSeconds(NumberOfSeconds) {
    Time = 19990101
    Time += %NumberOfSeconds%, Seconds
    FormatTime, Output1, %Time%, HH:mm:ss
    FormatTime, Output2, %Time%, YDay
    if (Output2 >= "2")
        return Output2-1 "d:" Output1
    return Output1
}

; NetTraffic ========================================================================
GetIfTable(ByRef tb, bOrder = True) {
    nSize := 4 + 860 * GetNumberOfInterfaces() + 8
    VarSetCapacity(tb, nSize)
    return DllCall("Iphlpapi.dll\GetIfTable", "UInt", &tb, "UInt*", nSize, "UInt", bOrder)
}
GetIfEntry(ByRef tb, idx) {
    VarSetCapacity(tb, 860)
    DllCall("ntdll\RtlFillMemoryUlong", "Ptr", &tb + 512, "Ptr", 4, "UInt", idx)
    return DllCall("Iphlpapi.dll\GetIfEntry", "UInt", &tb)
}
GetNumberOfInterfaces() {
    DllCall("Iphlpapi.dll\GetNumberOfInterfaces", "UInt*", nIf)
    return nIf
}
DecodeInteger(ptr) {
    return *ptr | *++ptr << 8 | *++ptr << 16 | *++ptr << 24
}

; ClearMemory =======================================================================
ClearMemory() {
    for process in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process") {
        handle := DllCall(Kernel32.OpenProcess, "UInt", 0x001F0FFF, "UInt", 0, "UInt", process.ProcessID)
        DllCall("SetProcessWorkingSetSize", "UInt", handle, "Int", -1, "Int", -1)
        DllCall("psapi.dll\EmptyWorkingSet", "UInt", handle)
        DllCall(Kernel32.CloseHandle, "Ptr", handle)
    }
    return
}
FreeMemory() {
    return DllCall("psapi.dll\EmptyWorkingSet", "UInt", -1)
}

; LoadLibrary =======================================================================
LoadLibrary(filename) {
    static ref := {}
    if (!(ptr := p := DllCall("LoadLibrary", "str", filename, "ptr")))
        return 0
    ref[ptr, "count"] := (ref[ptr]) ? ref[ptr, "count"] + 1 : 1
    p += NumGet(p + 0, 0x3c, "int") + 24
    o := {_ptr:ptr, __delete:func("FreeLibrary"), _ref:ref[ptr]}
    if (NumGet(p + 0, (A_PtrSize = 8) ? 108 : 92, "uint") < 1 || (ts := NumGet(p + 0, (A_PtrSize = 8) ? 112 : 96, "uint") + ptr) = ptr || (te := NumGet(p + 0, (A_PtrSize = 8) ? 116 : 100, "uint") + ts) = ts)
        return o
    n := ptr + NumGet(ts + 0, 32, "uint")
    loop, % NumGet(ts + 0, 24, "uint") {
        if (p := NumGet(n + 0, (A_Index - 1) * 4, "uint")) {
            o[f := StrGet(ptr + p, "cp0")] := DllCall("GetProcAddress", "ptr", ptr, "astr", f, "ptr")
            if (Substr(f, 0) == ((A_IsUnicode) ? "W" : "A"))
                o[Substr(f, 1, -1)] := o[f]
        }
    }
    return o
}
FreeLibrary(lib) {
    if (lib._ref.count >= 1)
        lib._ref.count -= 1
    if (lib._ref.count < 1)
        DllCall("FreeLibrary", "ptr", lib._ptr)
}


; ###################################################################################
; ### EXIT                                                                        ###
; ###################################################################################

Close:
GuiClose:
GuiEscape:
    ExitApp