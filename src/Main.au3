; compiler information for AutoIt
#pragma compile(CompanyName, © SOLVE SMART)
#pragma compile(FileVersion, 1.8.0)
#pragma compile(LegalCopyright, © Sven Seyfert)
#pragma compile(ProductName, Au3LogFramework)
#pragma compile(ProductVersion, 1.8.0 - 2023-05-16)

#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#AutoIt3Wrapper_Icon=..\media\icons\favicon.ico
#AutoIt3Wrapper_Outfile_x64=..\build\Au3LogFramework.exe
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_UseX64=y



; includes ---------------------------------------------------------------------
#include-once
#include <Date.au3>
#include <File.au3>
#include <ScreenCapture.au3>
#include <String.au3>



; opt and just singleton -------------------------------------------------------
Opt('MustDeclareVars', 1)
Global $aInst = ProcessList('Au3LogFramework.exe')
If $aInst[0][0] > 1 Then Exit



; modules ----------------------------------------------------------------------
#include "Enum.au3"
#include "Initializer.au3"
#include "HtmlStructure.au3"
#include "BasicFunctions.au3"
#include "Screenshot.au3"
#include "Functions.au3"



; processing -------------------------------------------------------------------
Switch $aCmdArg[$eAu3LogFrameworkAction]
    Case 'start'
        If StringLower($bShouldDisplayResolutionBeAdjusted) == 'true' Then
            _SetDisplayResolution()
            Sleep(1500)
        EndIf

        _CreateReportStructure()

    Case 'test'
        Switch $aCmdArg[$eTestScenarioState]
            Case 'ok', 'screenshot'
                _CreateTestScenarioOrScenarioStep($aColor[$eOk], $aCmdArg[$eTestScenarioState])

            Case 'warn'
                _CreateTestScenarioOrScenarioStep($aColor[$eWarn], $aCmdArg[$eTestScenarioState])

            Case 'error'
                _CreateTestScenarioOrScenarioStep($aColor[$eError], $aCmdArg[$eTestScenarioState])
        EndSwitch

    Case 'stop'
        $aIni[$eReportFile] = _ReadIniValue('ReportFile')
        _SetTestScenarioExecutionTime($aIni[$eReportFile])

        If StringLower($bSilentModeWithoutMsgBoxes) == 'false' Then
            If MsgBox($iMsgBoxQuestionIcon, 'Question', 'Processing done.' & @CRLF & 'Open log report in default browser?', 30) == 6 Then
                ShellExecute($aIni[$eReportFile])
            EndIf
        EndIf

        _SetMaxDirectories($aPath[$eOutput], $iAmountOfLastReportsToStore)
        _SetMaxFiles($aPath[$eReports], $iAmountOfLastReportsToStore)

        Exit
EndSwitch
