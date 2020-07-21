#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force
#installKeybdHook
#Persistent
SetTitleMatchMode, 2

#IfWinActive, Fallout76

$f1::
	etog := !etog

	if (etog = 0) {
		Send, {f1 up}
	}
	else {
		Send, {f1 down}
	}
return

#IfWinActive