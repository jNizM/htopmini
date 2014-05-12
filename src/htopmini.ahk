; ===================================================================================
; AHK Version ...: AHK_L 1.1.13.00 x64 Unicode
; Win Version ...: Windows 7 Professional x64 SP1
; Description ...: htopmini v0.5.1
; Version .......: 2013.10.14-1159
; Author ........: jNizM
; License .......: WTFPL
; License URL ...: http://www.wtfpl.net/txt/copying/
; ===================================================================================
;@Ahk2Exe-SetName htopmini
;@Ahk2Exe-SetDescription htopmini
;@Ahk2Exe-SetVersion 2013.10.14-1159
;@Ahk2Exe-SetCopyright Copyright (c) 2013`, jNizM
;@Ahk2Exe-SetOrigFilename htopmini.ahk

; GLOBAL SETTINGS ===================================================================

;#Warn
#NoEnv
#SingleInstance Force
global Kernel32 := LoadLibrary("Kernel32")

; SCRIPT ============================================================================

Menu, Tray, DeleteAll
Menu, Tray, NoStandard
Menu, Tray, Add, Toggle Trans, Transparency
Menu, Tray, Add,
Menu, Tray, Add, Toggle on Top, OnTop
Menu, Tray, Add, Show/Hide, ShowHide
Menu, Tray, Add,
Menu, Tray, Add, Exit, Close
Menu, Tray, Default, Show/Hide

Gui +LastFound -Caption +ToolWindow
GuiID := WinExist()
Gui, Margin, 10, 10
Gui, Color, 000000
Gui, Font, cFFFFFF, Consolas
Gui, Add, Text,     xm     ym w300 gMove vTime01
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
Gui, Add, Progress, xm+310 yp+1 h10 vRAM4,
Gui, Add, Text,     xm     y+2  w430 h1 0x7

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
}
Gui, Add, Text,     xm     y+2  w430 h1 0x7

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
Gui, Add, Button,   xm+170 y+5 w80 -Theme 0x8000 gClearM, ClearMem
Gui, Add, Button,   xm+260 yp w80 -Theme 0x8000 gClearL, ClearLog
Gui, Add, Button,   xm+350 yp w80 -Theme 0x8000 gClose, Close
Gui, Show, AutoSize, htopmini
WinSet, Transparent, 150, htopmini
SetTimer, UpdateTime, 1000
SetTimer, UpdateMemory, 2000
SetTimer, UpdateTraffic, 2000
SetTimer, UpdateDrive, -1000
SetTimer, ClearM, 60000
return

Move:
    PostMessage, 0xA1, 2,,, A
return

UpdateTime:
    GuiControl,, Time01, % "Time: " A_Hour ":" A_Min ":" A_Sec " | Uptime: " FormatSeconds(DllCall("GetTickCount64") / 1000)
return

UpdateMemory:
    GuiControl,, RAM1, % Round(GlobalMemoryStatusEx(2) - GlobalMemoryStatusEx(3), 2) " MB"
    GuiControl,, RAM2, % GlobalMemoryStatusEx(3) " MB"
    GuiControl,, RAM3, % GlobalMemoryStatusEx(2) " MB"
    GuiControl, % (GlobalMemoryStatusEx(1) <= "75") ? "+c00FF00" : (GlobalMemoryStatusEx(1) <= "90") ? "+cFFA500" : "+cFF0000", RAM4
    GuiControl,, RAM4, % GlobalMemoryStatusEx(1)
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
    }
	SetTimer, UpdateDrive, 2000
return

ClearM:
    MemA := GlobalMemoryStatusEx(3)
    ClearMemory()
    FreeMemory()
    MemB := GlobalMemoryStatusEx(3)
    LogLn(A_Hour ":" A_Min ":" A_Sec " | Cleared Memory: " Round(MemB - MemA, 2) " MB")
return

ClearL:
    LogClear()
return

Transparency:
	WinGet, curtrans, Transparent, ahk_id %GuiID%
	if (curtrans = 150)
		WinSet, Transparent, Off, htopmini
	else
		WinSet, Transparent, 150, htopmini
return

ShowHide:
    if WinExist("htopmini")
        WinHide, ahk_id %GuiID%
    else
        WinShow, ahk_id %GuiID%
Return

OnTop:
	WinSet, AlwaysOnTop, Toggle, ahk_id %GuiID%
return

Close:
    ExitApp
return

+WheelUp::   AdjustBrightness(+1)
+XButton2::  DisplaySetBrightness(128)
+WheelDown:: AdjustBrightness(-1)

; FUNCTIONS =========================================================================

; GlobalMemoryStatus ================================================================
GlobalMemoryStatusEx(GMS = 1) {
    VarSetCapacity(MEMORYSTATUSEX, 64, 0)
    NumPut(64, MEMORYSTATUSEX)
    DllCall(Kernel32.GlobalMemoryStatusEx, "ptr", &MEMORYSTATUSEX)
    return, % (GMS = "0") ? NumGet(MEMORYSTATUSEX, 0, "Int")
            : (GMS = "1") ? NumGet(MEMORYSTATUSEX, 4, "Int")
            : (GMS = "2") ? Round((NumGet(MEMORYSTATUSEX,  8, "Int64") / 1024**2), 2)
            : (GMS = "3") ? Round((NumGet(MEMORYSTATUSEX, 16, "Int64") / 1024**2), 2)
            : (GMS = "4") ? Round((NumGet(MEMORYSTATUSEX, 24, "Int64") / 1024**2), 2)
            : (GMS = "5") ? Round((NumGet(MEMORYSTATUSEX, 32, "Int64") / 1024**2), 2)
            : (GMS = "6") ? Round((NumGet(MEMORYSTATUSEX, 40, "Int64") / 1024**2), 2)
            : (GMS = "7") ? Round((NumGet(MEMORYSTATUSEX, 48, "Int64") / 1024**2), 2)
            : (GMS = "8") ? NumGet(MEMORYSTATUSEX, 56, "Int")
            : "FAIL"
}

; GetDrive ==========================================================================
GetDriveType(driveLetter) {
    return, % DllCall(Kernel32.GetDriveType, "Str", driveLetter) = "0" ? "UNKNWON"
            : DllCall(Kernel32.GetDriveType, "Str", driveLetter) = "1" ? "NO_ROOT_DIR"
            : DllCall(Kernel32.GetDriveType, "Str", driveLetter) = "2" ? "REMOVABLE"
            : DllCall(Kernel32.GetDriveType, "Str", driveLetter) = "3" ? "FIXED"
            : DllCall(Kernel32.GetDriveType, "Str", driveLetter) = "4" ? "REMOTE"
            : DllCall(Kernel32.GetDriveType, "Str", driveLetter) = "5" ? "CDROM"
            : DllCall(Kernel32.GetDriveType, "Str", driveLetter) = "6" ? "RAMDISK"
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

; CalcBytes =========================================================================
CalcBytes(kb, decimal = 2)
{ 
    return, (kb > 1048575) ? Round((kb / 1048576), decimal) " GB" : ((kb > 1023) ? Round((kb / 1024), decimal) " MB" : kb " KB")
}

; LogLn =============================================================================
global mylogData := ""
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
        DllCall("CloseHandle", "Int", handle)
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

; EXIT ==============================================================================
 
GuiClose:
GuiEscape:
    ExitApp