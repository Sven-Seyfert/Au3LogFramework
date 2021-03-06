; compiler information for AutoIt
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#AutoIt3Wrapper_Icon=..\media\favicon.ico
#AutoIt3Wrapper_Outfile_x64=..\build\Au3LogFramework.exe
#AutoIt3Wrapper_Res_Description=Au3LogFramework (2021-07-07)
#AutoIt3Wrapper_Res_Fileversion=0.51
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_UseX64=y



; includes ---------------------------------------------------------------------
#include-once
#include <Date.au3>
#include <File.au3>
#include <ScreenCapture.au3>
#include <String.au3>



; opt and just singleton -------------------------------------------------------
Opt( 'MustDeclareVars', 1 )
Global $aInst = ProcessList( 'Au3LogFramework.exe' )
If $aInst[0][0] > 1 Then Exit



; references -------------------------------------------------------------------
#include "Enum.au3"
#include "Declaration.au3"
#include "HtmlStructure.au3"
#include "BasicFunctions.au3"
#include "Screenshot.au3"
#include "Functions.au3"



; processing -------------------------------------------------------------------
Switch $aCmdArg[$eAu3LogFrameworkAction]
    Case 'start'
        If StringLower( $bShouldDisplayResolutionBeAdjusted ) == 'true' Then
            _setDisplayResolution()
            Sleep( 1500 )
        EndIf

        _createReportStructure()

    Case 'test'
        Switch $aCmdArg[$eTestScenarioState]
            Case 'ok', 'screenshot'
                _createTestScenarioOrScenarioStep( $aColor[$eOk], $aCmdArg[$eTestScenarioState] )

            Case 'warn'
                _createTestScenarioOrScenarioStep( $aColor[$eWarn], $aCmdArg[$eTestScenarioState] )

            Case 'error'
                _createTestScenarioOrScenarioStep( $aColor[$eError], $aCmdArg[$eTestScenarioState] )
        EndSwitch

    Case 'stop'
        $aIni[$eReportFile] = _readIniValue( 'ReportFile' )
        _setTestScenarioExecutionTime( $aIni[$eReportFile] )

        If StringLower( $bSilentModeWithoutMsgBoxes ) == 'false' Then
            If MsgBox( $iMsgBoxQuestionIcon, 'Question', 'Processing done.' & @CRLF & 'Open log report in default browser?', 30 ) == 6 Then
                ShellExecute( $aIni[$eReportFile] )
            EndIf
        EndIf

        _setMaxDirectories( $aPath[$eOutput], $iAmountOfLastReportsToStore )
        _setMaxFiles( $aPath[$eReports], $iAmountOfLastReportsToStore)

        Exit
EndSwitch
