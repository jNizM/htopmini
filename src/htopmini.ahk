; ===================================================================================
; AHK Version ...: AHK_L 1.1.15.00 x64 Unicode
; Win Version ...: Windows 7 Professional x64 SP1
; Description ...: htopmini
; Version .......: v0.8.3
; Modified ......: 2014.04.11-2027
; Author ........: jNizM
; Licence .......: WTFPL (http://www.wtfpl.net/txt/copying/)
; ===================================================================================
;@Ahk2Exe-SetName htopmini
;@Ahk2Exe-SetDescription htopmini
;@Ahk2Exe-SetVersion v0.8.3
;@Ahk2Exe-SetCopyright Copyright (c) 2013-2014`, jNizM
;@Ahk2Exe-SetOrigFilename htopmini.ahk
; ===================================================================================


; ###################################################################################
; ### GLOBAL SETTINGS                                                             ###
; ###################################################################################

;#Warn
#NoEnv
#SingleInstance Force
SetBatchLines -1

global WinTitel     := "htopmini " A_Now
global Today        := A_DD "." A_MM "." A_YYYY
global OldFormat    := A_FormatInteger
global varPerc      := 0
global Weather_ID   := "693838"                                                      ; Yahoo Weather Location ID
global Weather_DG   := "c"                                                           ; Celius = c | Fahrenheit = f
global ownPID       := DllCall("Kernel32.dll\GetCurrentProcessId")
global BuildVersion := DllCall("Kernel32.dll\GetVersion") >> 16 & 0xffff


; ###################################################################################
; ### MENU                                                                        ###
; ###################################################################################

Menu, Tray, DeleteAll
Menu, Tray, NoStandard
Menu, Tray, Add, Toggle Percentage, Menu_Percentage
Menu, Tray, Add,
Menu, Tray, Add, Reset Transparency, Menu_Transparency
Menu, Tray, Add, Toggle AlwaysOnTop, Menu_AlwaysOnTop
Menu, Tray, Add, Show/Hide, Menu_ShowHide
Menu, Tray, Add,
Menu, Tray, Add, Exit, Close
Menu, Tray, Default, Show/Hide


; ###################################################################################
; ### GUI MAIN                                                                    ###
; ###################################################################################

MakeGui:
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
    Gui, Add, Text,     xm     y+1 w30 0x200 gDriveClick, F_%A_Loopfield%:\
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
    Gui, Add, Text,     xm     y+1 w30 0x200 gDriveClick, R_%A_Loopfield%:\
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
    Gui, Add, Text,     xm     y+1 w30 0x200 gDriveClick, N_%A_Loopfield%:\
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
Gui, Add, Text,     xm     y+1  w30 0x200, IN/OUT:
Gui, Font, c00FF00,
Gui, Add, Text,     xm+40  yp   w80 0x202 vIN1,
Gui, Font, cFF0000,
Gui, Add, Text,     xm+140 yp   w80 0x202 vOU1,
Gui, Add, Text,     xm     y+3  w430 h1 0x7

Gui, Font, cFFFFFF,
Gui, Add, Text,     xm     y+10 w150 0x200 vOwnMem,
Gui, Add, Button,   xm+240 yp-6 w60 h20 -Theme 0x8000 gClear, Clear
Gui, Add, Button,   xm+305 yp   w60 h20 -Theme 0x8000 gMinimi, Minimize
Gui, Add, Button,   xm+370 yp   w60 h20 -Theme 0x8000 gClose, Close
Gui, Show, % "AutoSize" (htopx ? " x" htopx " y" htopy : ""), % WinTitel
WinSet, Transparent, 170, % WinTitel

SetTimer, UpdateTime, 1000
SetTimer, UpdateWeather, -1000
SetTimer, UpdateCPULoad, -1000
SetTimer, UpdateMemory, -1000
SetTimer, UpdateTraffic, 1000
SetTimer, UpdateDrive, -1000
SetTimer, UpdateMemHtop, -1000

OnMessage(0x201, "WM_LBUTTONDOWN")
OnMessage(0x219, "WM_DEVICECHANGE")

return


; ###################################################################################
; ### SCRIPT                                                                      ###
; ###################################################################################

UpdateTime:
    GuiControl,, Time01, % Today "  " A_Hour ":" A_Min ":" A_Sec " | Up: " GetDurationFormat(A_TickCount / 1000)
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
    CPU := CPULoad()
    GuiControl,, CPU2, % CPU " % "
    GuiControl, % ((CPU <= "50") ? "+c00FF00" : ((CPU <= "80") ? "+cFFA500" : "+cFF0000")), CPU3
    GuiControl,, CPU3, % CPU
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
        i := A_LoopField
        DriveGet, cap%i%, Capacity, %i%:\
        DriveSpaceFree, free%i%, %i%:\
        used%i% := cap%i% - free%i%
        perc%i% := used%i% / cap%i% * 100
        GuiControl,, D%i%1, % Round(used%i% / 1024, 2) " GB"
        GuiControl,, D%i%2, % Round(cap%i% / 1024, 2) " GB"
        GuiControl, % "+Range0-" cap%i%, D%i%3
        GuiControl, % (perc%i% <= "80") ? "+c00FF00" : (perc%i% <= "90") ? "+cFFA500" : "+cFF0000", D%i%3
        GuiControl,, D%i%3, % used%i%
        GuiControl,, D%i%4, % (varPerc = "1") ? Round(perc%i%, 2) " % " : ""
    }
    loop, Parse, DrvLstRmvbl
    {
        j := A_LoopField
        DriveGet, cap%j%, Capacity, %j%:\
        DriveSpaceFree, free%j%, %j%:\
        used%j% := cap%j% - free%j%
        perc%j% := used%j% / cap%j% * 100
        GuiControl,, D%j%1, % Round(used%j% / 1024, 2) " GB"
        GuiControl,, D%j%2, % Round(cap%j% / 1024, 2) " GB"
        GuiControl, % "+Range0-" cap%j%, D%j%3
        GuiControl, % (perc%j% <= "80") ? "+c00FF00" : (perc%j% <= "90") ? "+cFFA500" : "+cFF0000", D%j%3
        GuiControl,, D%j%3, % used%j%
        GuiControl,, D%j%4, % (varPerc = "1") ? Round(perc%j%, 2) " % " : ""
    }
    loop, Parse, DrvLstNtwrk
    {
        k := A_LoopField
        DriveGet, cap%k%, Capacity, %k%:\
        DriveSpaceFree, free%k%, %k%:\
        used%k% := cap%k% - free%k%
        perc%k% := used%k% / cap%k% * 100
        GuiControl,, D%k%1, % Round(used%k% / 1024, 2) " GB"
        GuiControl,, D%k%2, % Round(cap%k% / 1024, 2) " GB"
        GuiControl, % "+Range0-" cap%k%, D%k%3
        GuiControl, % (perc%k% <= "80") ? "+c00FF00" : (perc%k% <= "90") ? "+cFFA500" : "+cFF0000", D%k%3
        GuiControl,, D%k%3, % used%k%
        GuiControl,, D%k%4, % (varPerc = "1") ? Round(perc%k%, 2) " % " : ""
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
    if (BuildVersion >= "7600")
    {
        GPMI := GetProcessMemoryInfo_PMCEX(ownPID)
        PUsage := Round(GPMI[10] / 1024, 0)
    }
    else
    {
        GPMI := GetProcessMemoryInfo_PMC(ownPID)
        PUsage := Round(GPMI[8] / 1024, 0)
    }
    GuiControl,, OwnMem, % "PID: " ownPID " | " PUsage " K"
    SetTimer, UpdateMemHtop, 2000
return

DriveClick:
    Run, % SubStr(A_GuiControl, 3)
Return

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
    WinSet, Transparent, 170, % name
return

Menu_AlwaysOnTop:
    WinSet, AlwaysOnTop, Toggle, %WinTitel%
    Menu, Tray, ToggleCheck, Toggle AlwaysOnTop
return

Menu_ShowHide:
    WinGet, winStyle, Style, %WinTitel%
    if (winStyle & 0x10000000)
    {
        WinHide, %WinTitel%
    }
    else
    {
        WinShow, %WinTitel%
        WinSet, AlwaysOnTop, Toggle, %WinTitel%
        WinSet, AlwaysOnTop, Toggle, %WinTitel%
    }
return

^WheelUp::GUITrans(1)
^WheelDown::GUITrans(0)


; ###################################################################################
; ### FUNCTIONS                                                                   ###
; ###################################################################################

WM_LBUTTONDOWN(wParam, lParam, msg, hwnd)
{
    global hMain
    if (hwnd = hMain)
    {
        PostMessage, 0xA1, 2,,, % WinTitel
    }
}

WM_DEVICECHANGE(wParam, lParam, msg, hwnd)
{
    global hmain, htopx, htopy
    if (wParam = 0x8000 || wParam = 0x8004)
    {
        Thread, NoTimers
        WinGetPos, htopx, htopy,,, ahk_id %hmain%
        Gui, Destroy
        Gosub, MakeGui
    }
}

; GUITrans ==========================================================================
GUITrans(b := 1)
{
    WinGet, ct, Transparent, % WinTitel
    WinSet, Transparent, % ((b = 1) ? ct + 1 : ct - 1), % WinTitel
}

; DownloadToString ==================================================================
DownloadToString(url, encoding := "utf-8")
{
    static a := "AutoHotkey/" A_AhkVersion
    if (!DllCall("LoadLibrary", "Str", "wininet") || !(h := DllCall("wininet\InternetOpen", "Str", a, "UInt", 1, "Ptr", 0, "Ptr", 0, "UInt", 0, "Ptr")))
    {
        return 0
    }
    c := s := 0, o := ""
    if (f := DllCall("wininet\InternetOpenUrl", "Ptr", h, "Str", url, "Ptr", 0, "UInt", 0, "UInt", 0x80003000, "Ptr", 0, "Ptr"))
    {
        while (DllCall("wininet\InternetQueryDataAvailable", "Ptr", f, "UInt*", s, "UInt", 0, "Ptr", 0) && s > 0)
        {
            VarSetCapacity(b, s, 0)
            DllCall("wininet\InternetReadFile", "Ptr", f, "Ptr", &b, "UInt", s, "UInt*", r)
            o .= StrGet(&b, r >> (encoding = "utf-16" || encoding = "cp1200"), encoding)
        }
        DllCall("wininet\InternetCloseHandle", "Ptr", f)
    }
    DllCall("wininet\InternetCloseHandle", "Ptr", h)
    return o
}

; ProcessCount ======================================================================
GetProcessCount()
{
    proc := ""
    for process in ComObjGet("winmgmts:\\.\root\CIMV2").ExecQuery("SELECT * FROM Win32_Process")
    {
        proc++
    }
    return proc
}

; CPULoad ===========================================================================
CPULoad()
{
    static PIT, PKT, PUT
    if (Pit = "")
    {
        return 0, DllCall("GetSystemTimes", "Int64P", PIT, "Int64P", PKT, "Int64P", PUT)
    }
    DllCall("GetSystemTimes", "Int64P", CIT, "Int64P", CKT, "Int64P", CUT)
    IdleTime := PIT - CIT, KernelTime := PKT - CKT, UserTime := PUT - CUT
    SystemTime := KernelTime + UserTime 
    return ((SystemTime - IdleTime) * 100) // SystemTime, PIT := CIT, PKT := CKT, PUT := CUT 
}

; GlobalMemoryStatus ================================================================
GlobalMemoryStatusEx()
{
    static MEMORYSTATUSEX, init := VarSetCapacity(MEMORYSTATUSEX, 64, 0) && NumPut(64, MEMORYSTATUSEX, "UInt")
    if (DllCall("Kernel32.dll\GlobalMemoryStatusEx", "Ptr", &MEMORYSTATUSEX))
    {
        return { 2 : NumGet(MEMORYSTATUSEX,  8, "UInt64")
               , 3 : NumGet(MEMORYSTATUSEX, 16, "UInt64")
               , 4 : NumGet(MEMORYSTATUSEX, 24, "UInt64")
               , 5 : NumGet(MEMORYSTATUSEX, 32, "UInt64") }
    }
}

; GetProcessMemoryInfo ==============================================================
GetProcessMemoryInfo_PMCEX(PID)
{
    pu := ""
    hProcess := DllCall("Kernel32.dll\OpenProcess", "UInt", 0x001F0FFF, "UInt", 0, "UInt", PID)
    if (hProcess)
    {
        static PMCEX, size := (A_PtrSize = 8 ? 80 : 44), init := VarSetCapacity(PMCEX, size, 0) && NumPut(size, PMCEX)
        if (DllCall("Kernel32.dll\K32GetProcessMemoryInfo", "Ptr", hProcess, "UInt", &PMCEX, "UInt", size))
        {
            pu := { 10 : NumGet(PMCEX, (A_PtrSize = 8 ? 72 : 40), "Ptr") }
        }
        DllCall("Kernel32.dll\CloseHandle", "Ptr", hProcess)
    }
    return pu
}
GetProcessMemoryInfo_PMC(PID)
{
    pu := ""
    hProcess := DllCall("Kernel32.dll\OpenProcess", "UInt", 0x001F0FFF, "UInt", 0, "UInt", PID)
    if (hProcess)
    {
        static PMC, size := (A_PtrSize = 8 ? 72 : 40), init := VarSetCapacity(PMC, size, 0) && NumPut(size, PMC)
        if (DllCall("psapi.dll\GetProcessMemoryInfo", "Ptr", hProcess, "UInt", &PMC, "UInt", size))
        {
            pu := { 8 : NumGet(PMC, (A_PtrSize = 8 ? 56 : 32), "Ptr") }
        }
        DllCall("Kernel32.dll\CloseHandle", "Ptr", hProcess)
    }
    return pu
}

; secsToStr =========================================================================
GetDurationFormat(ullDuration, lpFormat := "d'd 'hh:mm:ss")
{
    VarSetCapacity(lpDurationStr, 128, 0)
    DllCall("Kernel32.dll\GetDurationFormat", "UInt",  0x400
                                            , "UInt",  0
                                            , "Ptr",   0
                                            , "Int64", ullDuration * 10000000
                                            , "WStr",  lpFormat
                                            , "WStr",  lpDurationStr
                                            , "Int",   64)
    return lpDurationStr
}

; NetTraffic ========================================================================
GetIfTable(ByRef tb, bOrder = True)
{
    nSize := 4 + 860 * GetNumberOfInterfaces() + 8
    VarSetCapacity(tb, nSize)
    return DllCall("Iphlpapi.dll\GetIfTable", "UInt", &tb, "UInt*", nSize, "UInt", bOrder)
}
GetIfEntry(ByRef tb, idx)
{
    VarSetCapacity(tb, 860)
    DllCall("ntdll\RtlFillMemoryUlong", "Ptr", &tb + 512, "Ptr", 4, "UInt", idx)
    return DllCall("Iphlpapi.dll\GetIfEntry", "UInt", &tb)
}
GetNumberOfInterfaces()
{
    DllCall("Iphlpapi.dll\GetNumberOfInterfaces", "UInt*", nIf)
    return nIf
}
DecodeInteger(ptr)
{
    return *ptr | *++ptr << 8 | *++ptr << 16 | *++ptr << 24
}

; ClearMemory =======================================================================
ClearMemory()
{
    for process in ComObjGet("winmgmts:\\.\root\CIMV2").ExecQuery("SELECT * FROM Win32_Process")
    {
        handle := DllCall("Kernel32.dll\OpenProcess", "UInt", 0x001F0FFF, "Int", 0, "Int", process.ProcessID)
        DllCall("Kernel32.dll\SetProcessWorkingSetSize", "UInt", handle, "Int", -1, "Int", -1)
        DllCall("Psapi.dll\EmptyWorkingSet", "UInt", handle)
        DllCall("Kernel32.dll\CloseHandle", "Int", handle)
    }
    return
}
FreeMemory()
{
    return DllCall("Psapi.dll\EmptyWorkingSet", "UInt", -1)
}


; ###################################################################################
; ### EXIT                                                                        ###
; ###################################################################################

Close:
GuiClose:
GuiEscape:
    ExitApp