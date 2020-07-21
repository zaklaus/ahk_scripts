; My Summer Car helper script
; Author: ZaKlaus
; Date: 8/14/2019 11:29:13 PM
; Desc: I made this script primarily due to my handicap limitations. It helps me
; experience the game without pain or difficulties. It doesn't make the game anyhow easier.
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
#SingleInstance Force
#InstallKeybdHook
#Persistent

WinX = 0
WinY = 0

Loop {
    If WinExist("ahk_exe mysummercar.exe") {
        Break
    }
}

; Find out where My Summer Car window is located
; WinGetPos, WinX, WinY, WinW, WinH, ahk_exe mysummercar.exe

; Create a GUI indicator for our MSC control mode
;OSDColourBG = 000000
;Gui, MscOSD: +LastFound +AlwaysOnTop -Caption +ToolWindow
;Gui, MscOSD:Margin, 0, 0
;Gui, MscOSD:Font, s8 cWhite Bold, Firacode
;Gui, MscOSD:Add, Text, vOSDControl cWhite w40 h15 x0 y0,
;Gui, MscOSD:Color, %OSDColourBG%
;Gui, MscOSD:Show, NoActivate, My Summer Car OSD
;Gui, MscOSD:Show, Hide

ShowControlType(Text="Control")
{
    Return ; disabled
    global WinX, WinY
    Gui, MscOSD:Font, s8 cWhite Bold, Firacode
    GuiControl, MscOSD:Font, OSDControl
    GuiControl, MscOSD:, OSDControl, %Text%
    Gui, MscOSD:Show, % "x" WinX+75 "y" WinY+67 "NoActivate", My Summer Car OSD
    Return
}

ShowControlType()

States := Array()
ControlStates := ["Hand", "Wheel", "Text"]
ControlState_Text := 2

; State indices
State_Zoom      := 1
State_Bend      := 2
State_Lean      := 3
State_Control   := 4

; Push all toggle states
Loop, 4 {
    States.Push(0)
}

StillUnfocused := 1

SetTimer, ControlDraw, On

; Check for status
Loop {
    if !WinExist("ahk_exe mysummercar.exe") {
            Gui, MscOSD:Show, Hide
        Continue
    }

    if !WinActive("ahk_exe mysummercar.exe") {
        For index in States {
            States[index] := 0
        }

        if (StillUnfocused = 0) {
            StillUnfocused := 1

            SendInput, {Click up left}
            ; SendInput, {Click up right}
            Gui, MscOSD:Show, Hide
        }
    } else {
        StillUnfocused := 0
        Gui, MscOSD:Show, NoActivate
    }

    WinGetPos, WinX, WinY, WinW, WinH, ahk_exe mysummercar.exe
}

ControlDraw:
    if WinActive("ahk_exe mysummercar.exe") {
        ShowControlType(ControlStates[States[State_Control]+1])
    }
Return

#IfWinActive ahk_exe mysummercar.exe

CapsLock & w::
 MouseClick,WheelUp,,,10,0,D,R
return

CapsLock & q::
 MouseClick,WheelDown,,,10,0,D,R
return

$c::
    if (States[State_Control] = ControlState_Text) {
        Send {c down}
        Send {c up}
        Return
    }

    States[State_Lean] := !States[State_Lean]

    if (States[State_Lean] = 0) {
        Send, {c up}
    }
    else {
        Send, {c down}
    }
Return

$9::
    if (States[State_Control] = ControlState_Text) {
        Send {9 down}
        Send {9 up}
        Return
    }

    States[State_Zoom] := !States[State_Zoom]

    if (States[State_Zoom] = 0) {
        Send, {9 up}
    }
    else {
        Send, {9 down}
    }
Return

$e::
	if (States[State_Control] = ControlState_Text) {
        Send {e down}
        Send {e up}
        Return
    }

    States[State_Bend] := !States[State_Bend]

	if (States[State_Bend] = 0) {
		Send, {e up}
	}
	else {
		Send, {e down}
	}
Return

$Tab::
    States[State_Control] := !States[State_Control]
Return

; Enable special Text mode (when using the computer)
$=::
    States[State_Control] := ControlState_Text
    Send, {=}
Return

; LMB used for acceleration
LButton::
    if (States[State_Control] = 1) {
        Send, {w down}
    } else {
        SendInput, {Click down left}
    }
Return

LButton up::
    if (States[State_Control] = 1) {
        Send, {w up}
    } else {
        SendInput, {Click up left}
    }
Return

; RMB used for clutch
RButton::
    if (States[State_Control] = 1) {
        Send, {v down}
    } else {
        SendInput, {Click down right}
    }
Return

RButton up::
    if (States[State_Control] = 1) {
        Send, {v up}
    } else {
        SendInput, {Click up right}
    }
Return

#IfWinActive
