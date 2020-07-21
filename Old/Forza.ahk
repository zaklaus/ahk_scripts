; Forza Horizon 4
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

States := Array()
ControlStates := ["Hand", "Wheel"]

; State indices
State_Control   := 1

; Push all toggle states
Loop, 1 {
    States.Push(0)
}

StillUnfocused := 1

; Check for status
Loop {
    if !WinExist("Forza Horizon 4") {
        Continue
    }

    if !WinActive("Forza Horizon 4") {
        For index in States {
            States[index] := 0
        }

        if (StillUnfocused = 0) {
            StillUnfocused := 1

            SendInput, {Click up left}
        }
    } else {
        StillUnfocused := 0
    }
}

#IfWinActive Forza Horizon 4

$`::
    States[State_Control] := !States[State_Control]
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

; RMB used for reverse
RButton::
    if (States[State_Control] = 1) {
        Send, {s down}
    } else {
        SendInput, {Click down right}
    }
Return

RButton up::
    if (States[State_Control] = 1) {
        Send, {s up}
    } else {
        SendInput, {Click up right}
    }
Return

#IfWinActive
