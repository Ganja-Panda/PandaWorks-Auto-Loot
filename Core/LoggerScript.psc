ScriptName LPAL:Core:LoggerScript extends Quest

; ==============================================================
; Ganja Panda’s Auto Loot (LPAL) – A Lazy Panda’s Looting Framework
; Author: Ganja Panda
; Version: 1.00
; License: Copyright (c) 2026 PandaWorks Studios. All rights reserved.
; Script: LoggerScript
; Type: Core / Diagnostic Utility
; Purpose:
;   Central diagnostic and logging utility for the LPAL framework.
;   Provides standardized info, warning, error, and verbose debug
;   trace output when the LPAL logging utility toggle is enabled.
;
; Responsibilities:
;   - Format log messages consistently
;   - Respect the existing LPAL logging toggle global
;   - Provide centralized diagnostic trace helpers
;   - Normalize log source/message values
;   - Support verbose runtime inspection during development/testing
;
; Non-Responsibilities:
;   - No install/update logic
;   - No runtime management
;   - No UI messaging
;   - No side effects beyond trace output
; ==============================================================

; ==============================================================
; Properties
; ==============================================================

GlobalVariable Property LPAL_GLOB_Utilities_Toggle_Logging Auto
String Property sLogPrefix = "[LPAL]" Auto

; ==============================================================
; Public Logging API
; ==============================================================

Function Info(String asSource, String asMessage)
	Log("INFO", asSource, asMessage, False)
EndFunction

Function Warn(String asSource, String asMessage)
	Log("WARN", asSource, asMessage, False)
EndFunction

Function Error(String asSource, String asMessage)
	Log("ERROR", asSource, asMessage, True)
EndFunction

Function DebugLog(String asSource, String asMessage)
	Log("DEBUG", asSource, asMessage, False)
EndFunction

Function TraceDecision(String asSource, String asContext, Bool abDecision, String asReason)
	String sDecision = "FALSE"

	If abDecision
		sDecision = "TRUE"
	EndIf

	Log("DEBUG", asSource, asContext + " => " + sDecision + " | " + NormalizeMessage(asReason), False)
EndFunction

Function TraceValue(String asSource, String asLabel, String asValue)
	Log("DEBUG", asSource, NormalizeMessage(asLabel) + " = " + NormalizeMessage(asValue), False)
EndFunction

; ==============================================================
; Public State Helpers
; ==============================================================

Bool Function IsLoggingEnabled()
	If LPAL_GLOB_Utilities_Toggle_Logging == None
		Return True
	EndIf

	Return (LPAL_GLOB_Utilities_Toggle_Logging.GetValueInt() != 0)
EndFunction

; ==============================================================
; Internal Logging Pipeline
; ==============================================================

Function Log(String asLevel, String asSource, String asMessage, Bool abForce)
	If !ShouldLog(abForce)
		Return
	EndIf

	WriteTrace(BuildMessage(asLevel, asSource, asMessage))
EndFunction

Bool Function ShouldLog(Bool abForce)
	If abForce
		Return True
	EndIf

	Return IsLoggingEnabled()
EndFunction

Function WriteTrace(String asFinalMessage)
	Debug.Trace(asFinalMessage)
EndFunction

String Function BuildMessage(String asLevel, String asSource, String asMessage)
	String sLevel = NormalizeLevel(asLevel)
	String sSource = NormalizeSource(asSource)
	String sMessage = NormalizeMessage(asMessage)

	Return sLogPrefix + "[" + sLevel + "][" + sSource + "] " + sMessage
EndFunction

String Function NormalizeLevel(String asLevel)
	If asLevel == ""
		Return "INFO"
	EndIf

	Return asLevel
EndFunction

String Function NormalizeSource(String asSource)
	If asSource == ""
		Return "UnknownSource"
	EndIf

	Return asSource
EndFunction

String Function NormalizeMessage(String asMessage)
	If asMessage == ""
		Return "<empty message>"
	EndIf

	Return asMessage
EndFunction