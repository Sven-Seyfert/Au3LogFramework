Global $iFileOpenMode                          = $FO_OVERWRITE + $FO_CREATEPATH + $FO_UTF8_NOBOM
Global $iMsgBoxErrorIcon                       = $MB_ICONERROR
Global $iMsgBoxQuestionIcon                    = $MB_ICONQUESTION + $MB_YESNO
Global $sProgramName                           = 'Au3LogFramework'
Global $sExecutionTime                         = @YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC & '.' & @MSEC
Global $sImageExtension                        = '.jpg'
Global $sScreenshotTime                        = ''

Global $aPath[$iMaxEnumIndex]
       $aPath[$eConfig]                        = _PathFull('..\config\')
       $aPath[$eJs]                            = _PathFull('..\js\')
       $aPath[$eOutput]                        = _PathFull('..\output\')
       $aPath[$eReports]                       = _PathFull('..\reports\')

Global $aFile[$iMaxEnumIndex]
       $aFile[$eConfig]                        = $aPath[$eConfig] & 'config.ini'
       $aFile[$eJs]                            = $aPath[$eJs] & 'script.js'

Global $iDisplayWidth                          = @DesktopWidth
Global $iDisplayHeight                         = @DesktopHeight

Global $iAmountOfLastReportsToStore            = IniRead($aFile[$eConfig], 'Settings', 'AmountOfLastReportsToStore', '20')
Global $bDebug                                 = IniRead($aFile[$eConfig], 'Settings', 'Debug', 'False')
Global $sDisplayResolutionForScreenshots       = StringStripWS(IniRead($aFile[$eConfig], 'Settings', 'DisplayResolutionForScreenshots', '1920x1080'), 8)
Global $bMaximizeWindowInCaseOfTakenScreenshot = IniRead($aFile[$eConfig], 'Settings', 'MaximizeWindowInCaseOfTakenScreenshot', 'True')
Global $bShouldDisplayResolutionBeAdjusted     = IniRead($aFile[$eConfig], 'Settings', 'ShouldDisplayResolutionBeAdjusted', 'False')
Global $bSilentModeWithoutMsgBoxes             = IniRead($aFile[$eConfig], 'Settings', 'SilentModeWithoutMsgBoxes', 'False')
Global $sTestRunner                            = IniRead($aFile[$eConfig], 'Settings', 'TestRunner', '')

If StringLower($bShouldDisplayResolutionBeAdjusted) == 'true' Then
       $iDisplayWidth  = StringSplit($sDisplayResolutionForScreenshots, 'x')[1]
       $iDisplayHeight = StringSplit($sDisplayResolutionForScreenshots, 'x')[2]
EndIf

Global $aColor[$iMaxEnumIndex]
       $aColor[$eOk]                           = '41B3A3'
       $aColor[$eWarn]                         = 'FBC02D'
       $aColor[$eError]                        = 'E7717D'

Global $aIni[$iMaxEnumIndex]
       $aIni[$eCountError]                     = ''
       $aIni[$eCountOk]                        = ''
       $aIni[$eCountWarn]                      = ''
       $aIni[$eLineOfDataForFirstChart]        = ''
       $aIni[$eLineOfDataForSecondChart]       = ''
       $aIni[$eLineOfDuration]                 = ''
       $aIni[$eLineOfLogEndTime]               = ''
       $aIni[$eLineOfTitleTag]                 = ''
       $aIni[$eOutputPath]                     = ''
       $aIni[$eReportFile]                     = ''
       $aIni[$eScenarioStepMaxNumber]          = ''
       $aIni[$eScenarioStepNumber]             = ''
       $aIni[$eTestScenarioName]               = ''
       $aIni[$eTestScenarioNumber]             = ''

Global $aCmdArg[$iMaxEnumIndex]
       $aCmdArg[$eAu3LogFrameworkAction]       = ''
       $aCmdArg[$eTestObject]                  = ''
       $aCmdArg[$eTestScenario]                = ''
       $aCmdArg[$eTestScenarioState]           = ''
       $aCmdArg[$eTestScenarioStepType]        = ''
       $aCmdArg[$eTestScenarioStepDescription] = ''
       $aCmdArg[$eTestScenarioAdditionalInfo]  = ''
       $aCmdArg[$eSystemUnderTestTitle]        = ''

Global $iArgumentCount                         = $CmdLine[0]
Switch $iArgumentCount
    Case 1
       $aCmdArg[$eAu3LogFrameworkAction]       = StringLower($CmdLine[1])

    Case 2
       $aCmdArg[$eAu3LogFrameworkAction]       = StringLower($CmdLine[1])
       $aCmdArg[$eTestObject]                  = $CmdLine[2]

    Case 6
       $aCmdArg[$eAu3LogFrameworkAction]       = StringLower($CmdLine[1])
       $aCmdArg[$eTestObject]                  = $CmdLine[2]
       $aCmdArg[$eTestScenario]                = $CmdLine[3]
       $aCmdArg[$eTestScenarioState]           = StringLower($CmdLine[4])
       $aCmdArg[$eTestScenarioStepType]        = _StringProper($CmdLine[5])
       $aCmdArg[$eTestScenarioStepDescription] = $CmdLine[6]

    Case 8
       $aCmdArg[$eAu3LogFrameworkAction]       = StringLower($CmdLine[1])
       $aCmdArg[$eTestObject]                  = $CmdLine[2]
       $aCmdArg[$eTestScenario]                = $CmdLine[3]
       $aCmdArg[$eTestScenarioState]           = StringLower($CmdLine[4])
       $aCmdArg[$eTestScenarioStepType]        = _StringProper($CmdLine[5])
       $aCmdArg[$eTestScenarioStepDescription] = $CmdLine[6]
       $aCmdArg[$eTestScenarioAdditionalInfo]  = $CmdLine[7]
       $aCmdArg[$eSystemUnderTestTitle]        = $CmdLine[8]

    Case Else
       _ShowErrorMessage('Wrong count of arguments is used while calling ' & $sProgramName & '. Please read the documentation (README.md).')

       Exit -1
EndSwitch
