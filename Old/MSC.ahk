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
#include CvJoyInterface.ahk

vJoyInterface := new CvJoyInterface()

if (!vJoyInterface.vJoyEnabled()){
	; Remind us we need to install it
	Msgbox % vJoyInterface.LoadLibraryLog
	ExitApp
}

wheelCtrl := vJoyInterface.Devices[1]

Loop {
    If WinExist("ahk_exe mysummercar.exe") {
        Break
    }
}

States := Array()
ControlStates := ["Hand", "Wheel", "Text"]
ControlState_Text := 2

; State indices
State_Zoom      := 1
State_Bend      := 2
State_Lean      := 3
State_Control   := 4

; Driving wheel
WheelAngle := 100
PedalPressure := 0
BrakePressure := 0
ClutchPressure := 0
WheelSteeringSpeed := 0.5
WheelMomentum := 100
LButtonIsDown := 0
BrakeKeyIsDown := 0
ClutchKeyIsDown := 0

; Math

Lerp(a,b,t) {
    return a * (1.0 - t) + b * t
}

; Push all toggle states
Loop, 4 {
    States.Push(0)
}

StillUnfocused := 1

; Check for status
Loop {
    if !WinActive("ahk_exe mysummercar.exe") {
        For index in States {
            States[index] := 0
        }

        if (StillUnfocused = 0) {
            StillUnfocused := 1
            SendInput, {Click up left}
        }
    } else {
        StillUnfocused := 0
        
        ; Handle wheel steering
        if (States[State_Control] = 1) {
            WheelAngle := Lerp(WheelAngle, WheelMomentum, 0.00125)

            if (WheelAngle < 0)
                WheelAngle = 0

            if (WheelAngle > 200)
                WheelAngle = 200

            if (LButtonIsDown = 1) {
                PedalPressure := Lerp(PedalPressure, 200, 0.0095)
            } else {
                PedalPressure := Lerp(PedalPressure, 0, 0.0095)
            }

            if (BrakeKeyIsDown = 1) {
                BrakePressure := Lerp(BrakePressure, 200, 0.0065)
            } else {
                BrakePressure := Lerp(BrakePressure, 0, 0.0099)
            }
            
            if (ClutchKeyIsDown = 1) {
                ClutchPressure := Lerp(ClutchPressure, 200, 1)
            } else {
                ClutchPressure := Lerp(ClutchPressure, 0, 1)
            }

            wheelCtrl.SetAxisByName(vJoyInterface.PercentTovJoy(WheelAngle/2),"x")
            wheelCtrl.SetAxisByName(vJoyInterface.PercentTovJoy(BrakePressure/2),"Rx")
            wheelCtrl.SetAxisByName(vJoyInterface.PercentTovJoy(PedalPressure/2),"Ry")
            wheelCtrl.SetAxisByName(vJoyInterface.PercentTovJoy(ClutchPressure/2),"Rz")
        }
    }

    ; ToolTip, %WheelAngle%
}

#IfWinActive ahk_exe mysummercar.exe

CapsLock & w::
 MouseClick,WheelUp,,,10,0,D,R
return

CapsLock & q::
 MouseClick,WheelDown,,,10,0,D,R
return

$Tab::
    States[State_Control] := !States[State_Control]
Return

; LMB used for acceleration
LButton::
    if (States[State_Control] = 1) {
        LButtonIsDown := 1
    } else {
        SendInput, {Click down left}
    }
Return

s::
    if (States[State_Control] = 1) {
        BrakeKeyIsDown := 1
    } else {
        Send, {s down}
    }
Return

s up::
    if (States[State_Control] = 1) {
        BrakeKeyIsDown := 0
    } else {
        Send, {s up}
    }
Return

LButton up::
    if (States[State_Control] = 1) {
        LButtonIsDown := 0
    } else {
        SendInput, {Click up left}
    }
Return

; RMB used for clutch
RButton::
    if (States[State_Control] = 1) {
        ClutchKeyIsDown := 1
    } else {
        SendInput, {Click down right}
    }
Return

RButton up::
    if (States[State_Control] = 1) {
        ClutchKeyIsDown := 0
    } else {
        SendInput, {Click up right}
    }
Return

~a::
    if (States[State_Control] = 1)
        WheelMomentum = 0
Return


~a up::
    if (States[State_Control] = 1)
        WheelMomentum = 100
Return

~d::
    if (States[State_Control] = 1)
        WheelMomentum = 200
Return


~d up::
    if (States[State_Control] = 1)
        WheelMomentum = 100
Return

#IfWinActive
