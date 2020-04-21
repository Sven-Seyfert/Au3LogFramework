Global $iFileOpenMode                          = $FO_OVERWRITE + $FO_CREATEPATH + $FO_UTF8_NOBOM
Global $iMsgBoxErrorIcon                       = $MB_ICONERROR
Global $iMsgBoxQuestionIcon                    = $MB_ICONQUESTION + $MB_YESNO
Global $sProgramName                           = 'Au3LogFramework'
Global $sExecutionTime                         = @YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC & '.' & @MSEC
Global $sImageExtension                        = '.jpg'
Global $sScreenshotTime                        = ''

Global $aPath[$iEnumVariables]
       $aPath[$eConfig]                        = _PathFull( '..\config\' )
       $aPath[$eJs]                            = _PathFull( '..\js\' )
       $aPath[$eOutput]                        = _PathFull( '..\output\' )
       $aPath[$eReports]                       = _PathFull( '..\reports\' )

Global $aFile[$iEnumVariables]
       $aFile[$eConfig]                        = $aPath[$eConfig] & 'config.ini'
       $aFile[$eJs]                            = $aPath[$eJs] & 'script.js'

Global $iAmountOfLastReportsToStore            = IniRead( $aFile[$eConfig], 'Settings', 'AmountOfLastReportsToStore', '20' )
Global $bDebug                                 = IniRead( $aFile[$eConfig], 'Settings', 'Debug', 'False' )
Global $bSilentModeWithoutMsgBoxes             = IniRead( $aFile[$eConfig], 'Settings', 'SilentModeWithoutMsgBoxes', 'False' )
Global $sTestRunner                            = IniRead( $aFile[$eConfig], 'Settings', 'TestRunner', '' )

Global $aColor[$iEnumVariables]
       $aColor[$eOk]                           = '41B3A3'
       $aColor[$eWarn]                         = 'FBC02D'
       $aColor[$eError]                        = 'E7717D'

Global $aIni[$iEnumVariables]
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

Global $aCmdArg[$iEnumVariables]
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
       $aCmdArg[$eAu3LogFrameworkAction]       = StringLower( $CmdLine[1] )

    Case 2
       $aCmdArg[$eAu3LogFrameworkAction]       = StringLower( $CmdLine[1] )
       $aCmdArg[$eTestObject]                  = $CmdLine[2]

    Case 6
       $aCmdArg[$eAu3LogFrameworkAction]       = StringLower( $CmdLine[1] )
       $aCmdArg[$eTestObject]                  = $CmdLine[2]
       $aCmdArg[$eTestScenario]                = $CmdLine[3]
       $aCmdArg[$eTestScenarioState]           = StringLower( $CmdLine[4] )
       $aCmdArg[$eTestScenarioStepType]        = _StringProper( $CmdLine[5] )
       $aCmdArg[$eTestScenarioStepDescription] = $CmdLine[6]

    Case 8
       $aCmdArg[$eAu3LogFrameworkAction]       = StringLower( $CmdLine[1] )
       $aCmdArg[$eTestObject]                  = $CmdLine[2]
       $aCmdArg[$eTestScenario]                = $CmdLine[3]
       $aCmdArg[$eTestScenarioState]           = StringLower( $CmdLine[4] )
       $aCmdArg[$eTestScenarioStepType]        = _StringProper( $CmdLine[5] )
       $aCmdArg[$eTestScenarioStepDescription] = $CmdLine[6]
       $aCmdArg[$eTestScenarioAdditionalInfo]  = $CmdLine[7]
       $aCmdArg[$eSystemUnderTestTitle]        = $CmdLine[8]

    Case Else
       _showErrorMessage( 'Wrong count of arguments is used while calling ' & $sProgramName & '. Please read the documentation (README.md).' )
       Exit -1
EndSwitch
