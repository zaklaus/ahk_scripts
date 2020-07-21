#NoEnv
#SingleInstance Force
#installKeybdHook
#Persistent
SendMode Input
SetWorkingDir %A_ScriptDir%
GroupAdd, ThisScript, %A_ScriptName%
Menu, Tray, Icon, Icons\icon.ico

;;;; Run add-ons

#include Libs\WindowDrag.ahk

;;;; General

^!m::edit %A_ScriptName%
^!+m::run explorer.exe %A_ScriptDir%

; Pause / Resume script
Pause::Suspend

; Reloads script if active window is the script editor
; Reloads on Ctrl-S in the editor window

#IfWinActive ahk_group ThisScript
~^s::
	TrayTip, Reloading updated script, %A_ScriptName%
	SetTimer, RemoveTrayTip, 2000
	Sleep, 2000
	Reload
return

#IfWinActive

;;;; Clipboard cut/paste simulated keys

ScrollLock::SendRaw %clipboard%

;;;; Mouse emulation

; Revised - Mouse Middle controls
F2::WheelDown
F3::MButton
F4::WheelUp

RShift & F2::F2
RShift & F3::F3
RShift & F4::F4

;;;; Keyboard states

; Default state of lock keys
SetNumlockState, AlwaysOn
SetCapsLockState, AlwaysOff
SetScrollLockState, AlwaysOff
return

; Caps Lock acts as Shift
Capslock::Shift

; Alternative Caps Lock toggle
RShift & CapsLock::SetCapsLockState % !GetKeyState("CapsLock", "T")

; Insert undescore
^SPACE:: Send _
Return

;;;; Window tweaks

; Go Up folder in Windows Explorer
#IfWinActive, ahk_class CabinetWClass
`::Send !{Up} 
#IfWinActive
return

;;;; Utilities

RemoveTrayTip:
    SetTimer, RemoveTrayTip, Off 
    TrayTip 
return 
