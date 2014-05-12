﻿; ===================================================================================
; AHK Version ...: AHK_L 1.1.13.01 x64 Unicode
; Win Version ...: Windows 7 Professional x64 SP1
; Description ...: htopmini v0.7.0
; Version .......: 2013.10.17-2030
; Author ........: jNizM
; License .......: WTFPL
; License URL ...: http://www.wtfpl.net/txt/copying/
; ===================================================================================
;@Ahk2Exe-SetName htopmini
;@Ahk2Exe-SetDescription htopmini
;@Ahk2Exe-SetVersion 2013.10.17-2030
;@Ahk2Exe-SetCopyright Copyright (c) 2013`, jNizM
;@Ahk2Exe-SetOrigFilename htopmini.ahk


; ###################################################################################
; ### GLOBAL SETTINGS                                                             ###
; ###################################################################################

;#Warn
#NoEnv
#SingleInstance Force
global Kernel32 := LoadLibrary("Kernel32")
global varPerc := 0
global Weather_ID := "693838"       ; Yahoo Weather Location ID
global Weather_DG := "c"            ; Celius = c | Fahrenheit = f
global OSBuild := GetVersionEx()
global mylogData := ""
global ownPID := DllCall(Kernel32.GetCurrentProcessId)


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

Gui, Add, Text,     xm+40   y+4 w80 0x202, Used
Gui, Add, Text,     xm+130  yp w80 0x202, Free
Gui, Add, Text,     xm+220  yp w80 0x202, Total

Gui, Font, cFFFFFF,
Gui, Add, Text,     xm     y+3 w30 0x200, RAM:
Gui, Font, c00FF00,
Gui, Add, Text,     xm+40  yp   w80 0x202 vRAM1,
Gui, Add, Text,     xm+130 yp   w80 0x202 vRAM2,
Gui, Font, cFFFFFF,
Gui, Add, Text,     xm+220 yp   w80 0x202 vRAM3,
Gui, Add, Progress, xm+310 yp+1 h10 BackgroundF0F0F0 vRAM4,
Gui, Font, c000000 s7,
Gui, Add, Text,     xm+310 yp w120 h11 0x201 +BackgroundTrans vRAM5,
Gui, Font, cFFFFFF s8,
Gui, Add, Text,     xm     y+3  w430 h1 0x7

DriveGet, DrvLstFxd, List, FIXED
loop, Parse, DrvLstFxd
{
    Gui, Font, cFFFFFF,
    Gui, Add, Text,     xm     y+1 w30 0x200, F_%A_Loopfield%:\
    Gui, Font, c00FF00,
    Gui, Add, Text,     xm+40  yp w80 0x202 vD%A_Loopfield%1,
    Gui, Add, Text,     xm+130 yp w80 0x202 vD%A_Loopfield%2,
    Gui, Font, cFFFFFF,
    Gui, Add, Text,     xm+220 yp w80 0x202 vD%A_Loopfield%3,
    Gui, Add, Progress, xm+310 yp+1 h10 vD%A_Loopfield%4,
    Gui, Font, c000000 s7,
    Gui, Add, Text,     xm+310 yp w120 h11 0x201 +BackgroundTrans vD%A_Loopfield%5,
    Gui, Font, cFFFFFF s8,
}
DriveGet, DrvLstRmvbl, List, REMOVABLE
loop, Parse, DrvLstRmvbl
{
    Gui, Font, cFFFFFF,
    Gui, Add, Text,     xm     y+1 w30 0x200, R_%A_Loopfield%:\
    Gui, Font, c00FF00,
    Gui, Add, Text,     xm+40  yp w80 0x202 vD%A_Loopfield%1,
    Gui, Add, Text,     xm+130 yp w80 0x202 vD%A_Loopfield%2,
    Gui, Font, cFFFFFF,
    Gui, Add, Text,     xm+220 yp w80 0x202 vD%A_Loopfield%3,
    Gui, Add, Progress, xm+310 yp+1 h10 vD%A_Loopfield%4,
    Gui, Font, c000000 s7,
    Gui, Add, Text,     xm+310 yp w120 h11 0x201 +BackgroundTrans vD%A_Loopfield%5,
    Gui, Font, cFFFFFF s8,
}
DriveGet, DrvLstNtwrk, List, NETWORK
loop, Parse, DrvLstNtwrk
{
    Gui, Font, cFFFFFF,
    Gui, Add, Text,     xm     y+1 w30 0x200, N_%A_Loopfield%:\
    Gui, Font, c00FF00,
    Gui, Add, Text,     xm+40  yp w80 0x202 vD%A_Loopfield%1,
    Gui, Add, Text,     xm+130 yp w80 0x202 vD%A_Loopfield%2,
    Gui, Font, cFFFFFF,
    Gui, Add, Text,     xm+220 yp w80 0x202 vD%A_Loopfield%3,
    Gui, Add, Progress, xm+310 yp+1 h10 vD%A_Loopfield%4,
    Gui, Font, c000000 s7,
    Gui, Add, Text,     xm+310 yp w120 h11 0x201 +BackgroundTrans vD%A_Loopfield%5,
    Gui, Font, cFFFFFF s8,
}
Gui, Add, Text,     xm     y+3  w430 h1 0x7

Gui, Font, cFFFFFF,
Gui, Add, Text,     xm     y+1  w30 0x200, IN:
Gui, Font, c00FF00,
Gui, Add, Text,     xm+40  yp   w80 0x202 vIN1,
Gui, Add, Progress, xm+130 yp+1 w170 h10 c00FF00 Range0-32000 -0x1 vIN2,

Gui, Font, cFFFFFF,
Gui, Add, Text,     xm     y+1  w30 0x200, OUT:
Gui, Font, cFF0000,
Gui, Add, Text,     xm+40  yp   w80 0x202 vOU1,
Gui, Add, Progress, xm+130 yp+1 w170 h10 cFF0000 Range0-2000 -0x1 vOU2,

Gui, Font, c00FF00,
Gui, Add, Edit,     xm     y+7 0x0800 w430 r10 vMyLog
Gui, Font, cFFFFFF,
Gui, Add, Text,     xm     y+15 w150 0x200 vOwnMem,
Gui, Add, Button,   xm+170 yp-10 w80 -Theme 0x8000 gClearM, ClearMem
Gui, Add, Button,   xm+260 yp w80 -Theme 0x8000 gClearL, ClearLog
Gui, Add, Button,   xm+350 yp w80 -Theme 0x8000 gClose, Close
Gui, Show, AutoSize, htopmini
WinSet, Transparent, 150, htopmini

SetTimer, UpdateTime, 1000
SetTimer, UpdateWeather, -1000
SetTimer, UpdateMemory, -1000
SetTimer, UpdateTraffic, 1000
SetTimer, UpdateDrive, -1000
SetTimer, UpdateMemHtop, -1000
;SetTimer, ClearM, 60000

OnMessage(0x201, "WM_LBUTTONDOWN")
WM_LBUTTONDOWN(wParam, lParam, msg, hwnd)
{
    global hMain
    if (hwnd = hMain)
        PostMessage, 0xA1, 2,,, htopmini
}
return


; ###################################################################################
; ### SCRIPT                                                                      ###
; ###################################################################################

UpdateTime:
    GuiControl,, Time01, % "Time: " A_Hour ":" A_Min ":" A_Sec " | Uptime: " FormatSeconds(DllCall(Kernel32.GetTickCount64) / 1000)
return

UpdateWeather:
    url := DownloadToString("http://weather.yahooapis.com/forecastrss?w=" Weather_ID "&u=" Weather_DG)
    RegExMatch(url, "(?<=Weather for )(.*)(?=\<\/description\>\s\<language\>)", varCity)
    RegExMatch(url, "(?<=temp="")(.*)(?=""  date)", varTemp)
    RegExMatch(url, "(?<=temperature="")(.*)(?=""\s*distance)", varUnits)
    GuiControl,, Temp01, % varCity " | " varTemp " °" varUnits
    SetTimer, UpdateWeather, 60000
return

UpdateMemory:
    GMSEx1 := Round(GlobalMemoryStatusEx(1) / 1024**2, 2)
    GMSEx2 := Round(GlobalMemoryStatusEx(2) / 1024**2, 2)
    GMSEx3 := Round(GMSEx1 - GMSEx2, 2)
    GuiControl,, RAM1, % GMSEx3 " MB"
    GMSEx3 := Round((GMSEx1 - GMSEx2) / GMSEx1 * 100, 2)
    GuiControl,, RAM2, % GMSEx2 " MB"
    GuiControl,, RAM3, % GMSEx1 " MB"
    GuiControl, % (GMSEx3 <= "75") ? "+c00FF00" : (GMSEx3 <= "90") ? "+cFFA500" : "+cFF0000", RAM4
    GuiControl,, RAM4, % GMSEx3
    GuiControl,, RAM5, % (varPerc = "1") ? GMSEx3 " %" : ""
    SetTimer, UpdateMemory, 2000
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
    GuiControl,, In2, % dnRate
    GuiControl,, Ou1, % upRate " kb/s"
    GuiControl,, Ou2, % upRate
    dnOld := dnNew
    upOld := upNew
return

UpdateDrive:
    loop, Parse, DrvLstFxd
    {
        DriveGet, cap%A_Loopfield%, Capacity, %A_Loopfield%:\
        DriveSpaceFree, free%A_Loopfield%, %A_Loopfield%:\
        GuiControl,, D%A_Loopfield%1, % Round((cap%A_Loopfield% - free%A_Loopfield%) / 1024, 2) " GB"
        GuiControl,, D%A_Loopfield%2, % Round(free%A_Loopfield% / 1024, 2) " GB"
        GuiControl,, D%A_Loopfield%3, % Round(cap%A_Loopfield% / 1024, 2) " GB"
        GuiControl, % "+Range0-" cap%A_Loopfield%, D%A_Loopfield%4
        GuiControl, % ((cap%A_Loopfield% - free%A_Loopfield%) / cap%A_Loopfield% * 100 <= "80") ? "+c00FF00"
                    : ((cap%A_Loopfield% - free%A_Loopfield%) / cap%A_Loopfield% * 100 <= "90") ? "+cFFA500" : "+cFF0000", D%A_Loopfield%4
        GuiControl,, D%A_Loopfield%4, % cap%A_Loopfield% - free%A_Loopfield%
        GuiControl,, D%A_Loopfield%5, %  (varPerc = "1") ? Round((cap%A_Loopfield% - free%A_Loopfield%) / cap%A_Loopfield% * 100, 2) " %" : ""
    }
    loop, Parse, DrvLstRmvbl
    {
        DriveGet, cap%A_Loopfield%, Capacity, %A_Loopfield%:\
        DriveSpaceFree, free%A_Loopfield%, %A_Loopfield%:\
        GuiControl,, D%A_Loopfield%1, % Round((cap%A_Loopfield% - free%A_Loopfield%) / 1024, 2) " GB"
        GuiControl,, D%A_Loopfield%2, % Round(free%A_Loopfield% / 1024, 2) " GB"
        GuiControl,, D%A_Loopfield%3, % Round(cap%A_Loopfield% / 1024, 2) " GB"
        GuiControl, % "+Range0-" cap%A_Loopfield%, D%A_Loopfield%4
        GuiControl, % ((cap%A_Loopfield% - free%A_Loopfield%) / cap%A_Loopfield% * 100 <= "80") ? "+c00FF00"
                    : ((cap%A_Loopfield% - free%A_Loopfield%) / cap%A_Loopfield% * 100 <= "90") ? "+cFFA500" : "+cFF0000", D%A_Loopfield%4
        GuiControl,, D%A_Loopfield%4, % cap%A_Loopfield% - free%A_Loopfield%
        GuiControl,, D%A_Loopfield%5, %  (varPerc = "1") ? Round((cap%A_Loopfield% - free%A_Loopfield%) / cap%A_Loopfield% * 100, 2) " %" : ""
    }
    loop, Parse, DrvLstNtwrk
    {
        DriveGet, cap%A_Loopfield%, Capacity, %A_Loopfield%:\
        DriveSpaceFree, free%A_Loopfield%, %A_Loopfield%:\
        GuiControl,, D%A_Loopfield%1, % Round((cap%A_Loopfield% - free%A_Loopfield%) / 1024, 2) " GB"
        GuiControl,, D%A_Loopfield%2, % Round(free%A_Loopfield% / 1024, 2) " GB"
        GuiControl,, D%A_Loopfield%3, % Round(cap%A_Loopfield% / 1024, 2) " GB"
        GuiControl, % "+Range0-" cap%A_Loopfield%, D%A_Loopfield%4
        GuiControl, % ((cap%A_Loopfield% - free%A_Loopfield%) / cap%A_Loopfield% * 100 <= "80") ? "+c00FF00"
                    : ((cap%A_Loopfield% - free%A_Loopfield%) / cap%A_Loopfield% * 100 <= "90") ? "+cFFA500" : "+cFF0000", D%A_Loopfield%4
        GuiControl,, D%A_Loopfield%4, % cap%A_Loopfield% - free%A_Loopfield%
        GuiControl,, D%A_Loopfield%5, %  (varPerc = "1") ? Round((cap%A_Loopfield% - free%A_Loopfield%) / cap%A_Loopfield% * 100, 2) " %" : ""
    }
    SetTimer, UpdateDrive, 5000
return

UpdateMemHtop:
    PUsage := Round(GetProcessMemoryInfo(ownPID) / 1024, 0)
    GuiControl,, OwnMem, % "PID: " ownPID " | " PUsage " K"
    SetTimer, UpdateMemHtop, 2000
return

ClearM:
    GMSEx_A := GlobalMemoryStatusEx(2) / 1024**2
    ClearMemory()
    FreeMemory()
    GMSEx_B := GlobalMemoryStatusEx(2) / 1024**2
    LogLn(A_Hour ":" A_Min ":" A_Sec " | Cleared Memory: " Round(GMSEx_B - GMSEx_A, 2) " MB")
return

ClearL:
    LogClear()
return

Menu_Percentage:
    varPerc := (varPerc = "0") ? "1" : "0"
    Menu, Tray, ToggleCheck, Toggle Percentage
return

Menu_Transparency:
    WinGet, ct, Transparent, htopmini
    WinSet, Transparent, % ct = "150" ? "Off" : "150", htopmini
    Menu, Tray, ToggleCheck, Toggle Transparency
return

Menu_AlwaysOnTop:
    WinSet, AlwaysOnTop, Toggle, htopmini
    Menu, Tray, ToggleCheck, Toggle AlwaysOnTop
return

Menu_ShowHide:
    WinGet, winStyle, Style, htopmini
    if (winStyle & 0x10000000)
        WinHide, htopmini
    else
    {
        WinShow, htopmini
        WinSet, AlwaysOnTop, Toggle, htopmini
        WinSet, AlwaysOnTop, Toggle, htopmini
    }
return

Close:
    ExitApp
return

+WheelUp::   AdjustBrightness(+1)
+XButton2::  DisplaySetBrightness(128)
+WheelDown:: AdjustBrightness(-1)


; ###################################################################################
; ### FUNCTIONS                                                                   ###
; ###################################################################################

; DownloadToString ==================================================================
DownloadToString(url, encoding="utf-8")
{
    static a := "AutoHotkey/" A_AhkVersion
    if (!DllCall("LoadLibrary", "str", "wininet") || !(h := DllCall("wininet\InternetOpen", "str", a, "uint", 1, "ptr", 0, "ptr", 0, "uint", 0, "ptr")))
        return 0
    c := s := 0, o := ""
    if (f := DllCall("wininet\InternetOpenUrl", "ptr", h, "str", url, "ptr", 0, "uint", 0, "uint", 0x80003000, "ptr", 0, "ptr"))
    {
        while (DllCall("wininet\InternetQueryDataAvailable", "ptr", f, "uint*", s, "uint", 0, "ptr", 0) && s > 0)
        {
            VarSetCapacity(b, s, 0)
            DllCall("wininet\InternetReadFile", "ptr", f, "ptr", &b, "uint", s, "uint*", r)
            o .= StrGet(&b, r >> (encoding = "utf-16" || encoding = "cp1200"), encoding)
        }
        DllCall("wininet\InternetCloseHandle", "ptr", f)
    }
    DllCall("wininet\InternetCloseHandle", "ptr", h)
    return o
}

; GetVersionEx ======================================================================
GetVersionEx() {
    VarSetCapacity(OSVerEX, 284, 0), Numput(284, OSVerEX)
    DllCall("GetVersionEx", "Ptr", &OSVerEX)
    return, NumGet(OSVerEX, 12, "UInt")
}

; GlobalMemoryStatus ================================================================
GlobalMemoryStatusEx(GMS = 1) {
    VarSetCapacity(MEMORYSTATUSEX, 64, 0), NumPut(64, MEMORYSTATUSEX)
    DllCall(Kernel32.GlobalMemoryStatusEx, "Ptr", &MEMORYSTATUSEX)
    return, % (GMS = "1") ? NumGet(MEMORYSTATUSEX,  8, "Int64") : (GMS = "2") ? NumGet(MEMORYSTATUSEX, 16, "Int64") : "FAIL"
}

; GetProcessMemoryInfo ==============================================================
GetProcessMemoryInfo(PID) {
    size := (A_PtrSize = 8 ? 80 : 44)
    VarSetCapacity(PMCEX, size, 0), NumPut(size, PMCEX)
    pu := ""

    hProcess := DllCall("OpenProcess", "UInt", 0x001F0FFF, "Int", 0, "UInt", PID)
    if (hProcess) {
        if (OSBuild >= "7600") {
            if (DllCall("psapi.dll\GetProcessMemoryInfo", "Ptr", hProcess, "UInt", &PMCEX, "UInt", size)) {
                pu := NumGet(PMCEX, (A_PtrSize = 8 ? 72 : 40), "Int64")
            }
        else
            pu := "old OS"
        }
        DllCall("CloseHandle", "UInt", hProcess)
    }
    return % pu
}

; FormatSeconds =====================================================================
FormatSeconds(NumberOfSeconds, TimeFormat = "") {
    if !TimeFormat
        TimeFormat = HH:mm:ss
    Time = 19990101
    Time += %NumberOfSeconds%, Seconds
    FormatTime, Output1, %Time%, %TimeFormat%
    return Output1
}

; LogLn =============================================================================
LogLn(line) {
    global
    mylogData .= line "`n"
    GuiControl,, MyLog, % mylogData
}
LogClear() {
    global
    mylogData := ""
    GuiControl,, MyLog, % mylogData
}

; NetTraffic ========================================================================
GetIfTable(ByRef tb, bOrder = True) {
    nSize := 4 + 860 * GetNumberOfInterfaces() + 8
    VarSetCapacity(tb, nSize)
    return DllCall("iphlpapi\GetIfTable", "Uint", &tb, "UintP", nSize, "int", bOrder)
}
GetIfEntry(ByRef tb, idx) {
    VarSetCapacity(tb, 860)
    DllCall("ntdll\RtlFillMemoryUlong", "Uint", &tb + 512, "Uint", 4, "Uint", idx)
    return DllCall("iphlpapi\GetIfEntry", "Uint", &tb)
}
GetNumberOfInterfaces() {
    DllCall("iphlpapi\GetNumberOfInterfaces", "UintP", nIf)
    return nIf
}
DecodeInteger(ptr) {
    return *ptr | *++ptr << 8 | *++ptr << 16 | *++ptr << 24
}

; ClearMemory =======================================================================
ClearMemory() {
    for process in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process") {
        handle := DllCall("OpenProcess", "UInt", 0x001F0FFF, "Int", 0, "Int", process.ProcessID)
        DllCall("SetProcessWorkingSetSize", "UInt", handle, "Int", -1, "Int", -1)
        DllCall("psapi.dll\EmptyWorkingSet", "UInt", handle)
        DllCall("CloseHandle", "UInt", handle)
    }
    return
}
FreeMemory() {
    return, DllCall("psapi.dll\EmptyWorkingSet", "UInt", -1)
}

; DisplayBrightness =================================================================
AdjustBrightness(V = 0) {
    V := (GetKeyState("XButton1") && V > 0) ? V + 9 : (GetKeyState("XButton1") && V < 0) ? V - 9 : V
    SB := (SB := DisplayGetBrightness() + V) > 255 ? 255 : SB < 0 ? 0 : SB
    DisplaySetBrightness(SB)
}
DisplaySetBrightness(SB = 128) {
    loop, % VarSetCapacity(GB, 1536) / 6
        NumPut((N := (SB + 128) * (A_Index - 1)) > 65535 ? 65535 : N, GB, 2 * (A_Index - 1), "UShort")
    DllCall("RtlMoveMemory", UInt, &GB +  512, UInt, &GB, UInt, 512)
    DllCall("RtlMoveMemory", UInt, &GB + 1024, UInt, &GB, UInt, 512)
    return DllCall("SetDeviceGammaRamp", UInt, hDC := DllCall("GetDC", UInt, 0), UInt, &GB), DllCall("ReleaseDC", UInt, 0, UInt, hDC)
}
DisplayGetBrightness(ByRef GB = "") {
    VarSetCapacity(GB, 1536, 0)
    DllCall("GetDeviceGammaRamp", UInt, hDC := DllCall("GetDC", UInt, 0), UInt, &GB)
    return NumGet(GB, 2, "UShort") - 128, DllCall("ReleaseDC", UInt, 0, UInt, hDC)
}

; LoadLibrary =======================================================================
LoadLibrary(filename) {
    static ref := {}
    if (!(ptr := p := DllCall("LoadLibrary", "str", filename, "ptr")))
        return 0
    ref[ptr, "count"] := (ref[ptr]) ? ref[ptr, "count"] + 1 : 1
    p += NumGet(p + 0, 0x3c, "int") + 24
    o := {_ptr:ptr, __delete:func("FreeLibrary"), _ref:ref[ptr]}
    if (NumGet(p + 0, (A_PtrSize = 4) ? 92 : 108, "uint") < 1 || (ts := NumGet(p + 0, (A_PtrSize = 4) ? 96 : 112, "uint") + ptr) = ptr || (te := NumGet(p + 0, (A_PtrSize = 4) ? 100 : 116, "uint") + ts) = ts)
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

GuiClose:
GuiEscape:
    ExitApp