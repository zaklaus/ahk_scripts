#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force
#installKeybdHook
#Persistent
SetTitleMatchMode, 2

;#IfWinActive, Star Citizen

CapsLock & w::
 MouseClick,WheelUp,,,1,0,D,R
return

CapsLock & q::
 MouseClick,WheelDown,,,1,0,D,R
return

;#IfWinActive