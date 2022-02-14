Func _ReadIniValue($sKey)
    Return IniRead($aFile[$eConfig], 'Storage', $sKey, '')
EndFunc

Func _WriteIniValue($sKey, $sValue)
    Return IniWrite($aFile[$eConfig], 'Storage', $sKey, $sValue)
EndFunc

Func _RenewIniValue($sKey, $sValue)
    _WriteIniValue($sKey, $sValue)
    _GetStoredIniValues()
EndFunc

Func _CreateReportStructure()
    Local $iYear = @YEAR, $iMonth = @MON, $iDay = @MDAY
    Local $iHour = @HOUR, $iMin   = @MIN, $iSec = @SEC

    Local $sFullDay = $iYear & '-' & $iMonth & '-' & $iDay

    Local $sFileHtmlReport  = $aPath[$eReports] & $aCmdArg[$eTestObject] & ' ' & $sFullDay & ' ' & $iHour & '''' & $iMin & '''' & $iSec & '.html'
    Local $sHtmlReportTitle = $aCmdArg[$eTestObject] & ' ' & $sFullDay & ' ' & $iHour & ':' & $iMin & ':' & $iSec
    Local $sReportStart     = ' ' & $aCmdArg[$eTestObject] & ' ' & $sFullDay & ' ' & $iHour & ':' & $iMin & ':' & $iSec
    Local $sOutputPath      = StringReplace(StringReplace($sFileHtmlReport, '\reports\', '\output\'), '.html', '')

    $sHtmlHead   = StringReplace($sHtmlHead, '#{$sHtmlReportTitle}#', $sHtmlReportTitle)
    $sHtmlMain   = StringReplace($sHtmlMain, '#{$sReportStart}#', $sReportStart)
    $sHtmlFooter = StringReplace($sHtmlFooter, '#{$sReportStart}#', $sReportStart)

    _CreateIniStorageSection($sFileHtmlReport, $sOutputPath)
    _WriteFile($sFileHtmlReport, $sHtmlHead & $sHtmlMain & $sHtmlFooter)

    DirCreate($sOutputPath)
EndFunc

Func _CreateIniStorageSection($sFileHtmlReportString, $sOutputPathString)
    Local $aSection[17][2] = _
    [ _
        [16,                                      ''], _
        ['CountError',                            '0'], _
        ['CountOk',                               '0'], _
        ['CountWarn',                             '0'], _
        ['IsNewTestScenario',                     'false'], _
        ['LineOfDataForFirstChart',               '36'], _
        ['LineOfDataForSecondChart',              '63'], _
        ['LineOfDuration',                        '17'], _
        ['LineOfLogEndTime',                      '38'], _
        ['LineOfTitleTag',                        '4'], _
        ['OutputPath',                            $sOutputPathString & '\' ], _
        ['ReportFile',                            $sFileHtmlReportString ], _
        ['ScenarioStepMaxNumber',                 '0' ], _
        ['ScenarioStepNumber',                    '0' ], _
        ['TestScenarioName',                      '-' ], _
        ['TestScenarioNumber',                    '0' ], _
        ['WasThereAWarnInTheCurrentTestScenario', 'false' ] _
    ]

    IniWriteSection($aFile[$eConfig], 'Storage', $aSection)
EndFunc

Func _GetStoredIniValues()
    $aIni[$eCountError]                            = _ReadIniValue('CountError')
    $aIni[$eCountOk]                               = _ReadIniValue('CountOk')
    $aIni[$eCountWarn]                             = _ReadIniValue('CountWarn')
    $aIni[$eIsNewTestScenario]                     = _ReadIniValue('IsNewTestScenario')
    $aIni[$eLineOfDataForFirstChart]               = _ReadIniValue('LineOfDataForFirstChart')
    $aIni[$eLineOfDataForSecondChart]              = _ReadIniValue('LineOfDataForSecondChart')
    $aIni[$eLineOfDuration]                        = _ReadIniValue('LineOfDuration')
    $aIni[$eLineOfLogEndTime]                      = _ReadIniValue('LineOfLogEndTime')
    $aIni[$eLineOfTitleTag]                        = _ReadIniValue('LineOfTitleTag')
    $aIni[$eOutputPath]                            = _ReadIniValue('OutputPath')
    $aIni[$eReportFile]                            = _ReadIniValue('ReportFile')
    $aIni[$eScenarioStepMaxNumber]                 = _ReadIniValue('ScenarioStepMaxNumber')
    $aIni[$eScenarioStepNumber]                    = _ReadIniValue('ScenarioStepNumber')
    $aIni[$eTestScenarioName]                      = _ReadIniValue('TestScenarioName')
    $aIni[$eTestScenarioNumber]                    = _ReadIniValue('TestScenarioNumber')
    $aIni[$eWasThereAWarnInTheCurrentTestScenario] = _ReadIniValue('WasThereAWarnInTheCurrentTestScenario')
EndFunc

Func _CreateTestScenarioOrScenarioStep($sColor, $sTestScenarioState)
    _GetStoredIniValues()

    If $aIni[$eTestScenarioName] <> $aCmdArg[$eTestScenario] Then
        _RenewIniValue('IsNewTestScenario', 'true')
        _RenewIniValue('TestScenarioName', $aCmdArg[$eTestScenario])
        _RenewIniValue('TestScenarioNumber', $aIni[$eTestScenarioNumber] + 1)
        _RenewIniValue('WasThereAWarnInTheCurrentTestScenario', 'false')
        Local $iRowsToAdd = _WriteNewTestScenario($sColor, $sTestScenarioState)
    Else
        _RenewIniValue('IsNewTestScenario', 'false')
        Local $iRowsToAdd = _WriteNewScenarioStepOfAGivenTestScenario($sColor, $sTestScenarioState)
    EndIf

    _RenewIniValue('LineOfLogEndTime', $aIni[$eLineOfLogEndTime] + $iRowsToAdd)
    _RenewIniValue('ScenarioStepMaxNumber', $aIni[$eScenarioStepMaxNumber] + 1)
    _RenewIniValue('ScenarioStepNumber', $aIni[$eScenarioStepNumber] + 1)

    _RenewChartSectionValues()
    _RenewResultSectionValues()
    _RenewTheEndLogDateAndTheTestDurationTime()
EndFunc

Func _WriteNewTestScenario($sColor, $sTestScenarioState)
    _RenewIniValue('ScenarioStepNumber', 0)
    $sHtmlNewTestScenario = _ReplaceHtmlPlaceholder($sColor, $sHtmlNewTestScenario)
    $sHtmlNewTestScenario = _AddScreenshot($sTestScenarioState, $sHtmlNewTestScenario)

    Local $iLine = _GetFileLineNumberForLastSearchMatch($aIni[$eReportFile], '<hr data-hr>')

    _WriteToFileLine($aIni[$eReportFile], $iLine , $sHtmlNewTestScenario, False)

    Local $iLinesOfHtmlNewTestScenario = 7

    Return $iLinesOfHtmlNewTestScenario
EndFunc

Func _WriteNewScenarioStepOfAGivenTestScenario($sColor, $sTestScenarioState)
    $sHtmlNewScenarioStep = _ReplaceHtmlPlaceholder($sColor, $sHtmlNewScenarioStep)
    $sHtmlNewScenarioStep = _AddScreenshot($sTestScenarioState, $sHtmlNewScenarioStep)

    Local $iLine = _GetFileLineNumberForLastSearchMatch($aIni[$eReportFile], '</table>')

    _WriteToFileLine($aIni[$eReportFile], $iLine, $sHtmlNewScenarioStep, False)

    If $sColor <> $aColor[$eError] Then
        If $aIni[$eIsNewTestScenario] == 'false' And $aIni[$eWasThereAWarnInTheCurrentTestScenario] == 'true'  Then $sColor = $aColor[$eWarn]
        If $aIni[$eIsNewTestScenario] == 'true'  And $aIni[$eWasThereAWarnInTheCurrentTestScenario] == 'false' Then $sColor = $sColor
    EndIf

    _ReplaceLine(_GetFileLineNumberForLastSearchMatch($aIni[$eReportFile], '<h4 data-h4>'), 'color: #.+?;', 'color: #' & $sColor & ';')

    Local $iLinesOfHtmlNewScenarioStep = 1

    Return $iLinesOfHtmlNewScenarioStep
EndFunc

Func _ReplaceHtmlPlaceholder($sColor, $sText)
    $sText = StringReplace($sText, '#{$sColor}#', $sColor)
    $sText = StringReplace($sText, '#{$eTestScenarioNumber}#', $aIni[$eTestScenarioNumber])
    $sText = StringReplace($sText, '#{$eTestScenario}#', $aCmdArg[$eTestScenario])
    $sText = StringReplace($sText, '#{$eScenarioStepNumber}#', $aIni[$eScenarioStepNumber] + 1)
    $sText = StringReplace($sText, '#{$sExecutionTime}#', $sExecutionTime)
    $sText = StringReplace($sText, '#{$eTestScenarioStepType}#', $aCmdArg[$eTestScenarioStepType])
    $sText = StringReplace($sText, '#{$eTestScenarioStepDescription}#', $aCmdArg[$eTestScenarioStepDescription])

    Return   StringReplace($sText, '#{$eTestScenarioAdditionalInfo}#', $aCmdArg[$eTestScenarioAdditionalInfo])
EndFunc

Func _AddScreenshot($sState, $sText)
    Switch $sState
        Case 'screenshot', 'error'
            $sText = StringReplace($sText, '#{_SetScreenshotFileToHtml()}#', _SetScreenshotFileToHtml())

        Case 'warn'
            $sText = StringReplace($sText, '#{_SetScreenshotFileToHtml()}#', _SetScreenshotFileToHtml())
            _RenewIniValue('WasThereAWarnInTheCurrentTestScenario', 'true')

        Case Else
            $sText = StringReplace($sText, '#{_SetScreenshotFileToHtml()}#', '')
    EndSwitch

    Return $sText
EndFunc

Func _SetScreenshotFileToHtml()
    $sScreenshotTime = @YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & '''' & @MIN & '''' & @SEC & '''' & @MSEC
    Local $sScreenshotFile = StringReplace($aIni[$eOutputPath] & $sScreenshotTime & $sImageExtension, '\', '/')

    Return StringRegExpReplace($sScreenshotFile, '(.+?)output', '../output', 1)
EndFunc

Func _ReplaceLine($iLine, $sPattern, $sReplace)
    Local $sLineContent = FileReadLine($aIni[$eReportFile], $iLine)
          $sLineContent = StringRegExpReplace($sLineContent, $sPattern, $sReplace)

    _WriteToFileLine($aIni[$eReportFile], $iLine, $sLineContent)
EndFunc

Func _RenewChartSectionValues()
    Switch $aCmdArg[$eTestScenarioState]
        Case 'ok'
            _RenewIniValue('CountOk', $aIni[$eCountOk] + 1)

        Case 'screenshot'
            _RenewIniValue('CountOk', $aIni[$eCountOk] + 1)
            _CreateScreenshot()

        Case 'warn'
            _RenewIniValue('CountWarn', $aIni[$eCountWarn] + 1)
            _CreateScreenshot()

        Case 'error'
            _RenewIniValue('CountError', $aIni[$eCountError] + 1)
            _CreateScreenshot()
    EndSwitch

    Local $iFirstChartPercentageForOk     = Round(100 / $aIni[$eTestScenarioNumber] * ($aIni[$eTestScenarioNumber] - $aIni[$eCountError]), 1)
    Local $iFirstChartPercentageForError  = Round(100 / $aIni[$eTestScenarioNumber] * $aIni[$eCountError], 1)
    Local $iSecondChartPercentageForOk    = Round(100 / $aIni[$eScenarioStepMaxNumber] * $aIni[$eCountOk], 1)
    Local $iSecondChartPercentageForError = Round(100 / $aIni[$eScenarioStepMaxNumber] * $aIni[$eCountError], 1)
    Local $iSecondChartPercentageForWarn  = Round(100 / $aIni[$eScenarioStepMaxNumber] * $aIni[$eCountWarn], 1)

    _WriteToFileLine($aFile[$eJs], $aIni[$eLineOfDataForFirstChart]  - 4, _StringRepeat(' ', 12) & 'labels: ["OK (' & $iFirstChartPercentageForOk & '%)", "ERROR (' & $iFirstChartPercentageForError & '%)"],')
    _WriteToFileLine($aFile[$eJs], $aIni[$eLineOfDataForSecondChart] - 4, _StringRepeat(' ', 12) & 'labels: ["OK (' & $iSecondChartPercentageForOk & '%)", "ERROR (' & $iSecondChartPercentageForError & '%)", "WARN (' & $iSecondChartPercentageForWarn & '%)"],')
    _WriteToFileLine($aFile[$eJs], $aIni[$eLineOfDataForFirstChart],  _StringRepeat(' ', 20) & 'data: [' & $aIni[$eTestScenarioNumber] - $aIni[$eCountError] & ', ' & $aIni[$eCountError] & '],')
    _WriteToFileLine($aFile[$eJs], $aIni[$eLineOfDataForSecondChart], _StringRepeat(' ', 20) & 'data: [' & $aIni[$eCountOk] & ', ' & $aIni[$eCountError] & ', ' & $aIni[$eCountWarn] & '],')
EndFunc

Func _RenewResultSectionValues()
    _ReplaceLine($aIni[$eLineOfLogEndTime] - 8, '</span><strong>\d{1,}</strong></div><hr>', '</span><strong>' & $aIni[$eTestScenarioNumber] & '</strong></div><hr>')
    _ReplaceLine($aIni[$eLineOfLogEndTime] - 7, 'OK</span>\d{1,}</div><hr>', 'OK</span>' & $aIni[$eTestScenarioNumber] - $aIni[$eCountError] & '</div><hr>')
    _ReplaceLine($aIni[$eLineOfLogEndTime] - 6, 'ERRORS</span>\d{1,}</div><hr>', 'ERRORS</span>' & $aIni[$eCountError] & '</div><hr>')
    _ReplaceLine($aIni[$eLineOfLogEndTime] - 4, '</span><strong>\d{1,}</strong></div><hr>', '</span><strong>' & $aIni[$eScenarioStepMaxNumber] & '</strong></div><hr>')
    _ReplaceLine($aIni[$eLineOfLogEndTime] - 3, 'OK</span>\d{1,}</div><hr>', 'OK</span>' & $aIni[$eCountOk] & '</div><hr>')
    _ReplaceLine($aIni[$eLineOfLogEndTime] - 2, 'ERRORS</span>\d{1,}</div><hr>', 'ERRORS</span>' & $aIni[$eCountError] & '</div><hr>')
    _ReplaceLine($aIni[$eLineOfLogEndTime] - 1, 'WARN</span>\d{1,}</div><hr>', 'WARN</span>' & $aIni[$eCountWarn] & '</div><hr>')
EndFunc

Func _RenewTheEndLogDateAndTheTestDurationTime()
    Local $iEndYear = @YEAR, $iEndMon = @MON, $iEndMday = @MDAY
    Local $iEndHour = @HOUR, $iEndMin = @MIN, $iEndSec  = @SEC

    Local $sTimestamp = $iEndYear & '-' & $iEndMon & '-' & $iEndMday & ' ' & $iEndHour & ':' & $iEndMin & ':' & $iEndSec

    _ReplaceLine($aIni[$eLineOfLogEndTime], '\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}', $sTimestamp)

    Local $sStartDate = StringRegExpReplace(FileReadLine($aIni[$eReportFile], $aIni[$eLineOfTitleTag]), '.+?(\d{4})-(\d{2})-(\d{2}) (\d{2}:\d{2}:\d{2}).+?$', '$1/$2/$3 $4')
    Local $sEndDate   = $iEndYear & '/' & $iEndMon & '/' & $iEndMday & ' ' & $iEndHour & ':' & $iEndMin & ':' & $iEndSec

    _ReplaceLine($aIni[$eLineOfDuration], 'TEST DURATION:</b> .+?$', 'TEST DURATION:</b> ' & _GetDiffTime($sStartDate, $sEndDate))
EndFunc

Func _SetTestScenarioExecutionTime($sFilePath)
    Local $aFileContent = FileReadToArray($sFilePath)
    Local $iFileCount   = UBound($aFileContent)

    _ArrayInsert($aFileContent, 0, $iFileCount)

    For $i = 1 To $iFileCount Step 1
        If StringInStr($aFileContent[$i], '<table>', 2) <> 0 Then
            Local $sStartDate = _GetDateTime($aFileContent[$i + 2])

            For $j = 1 To 200 Step 1
                If StringInStr($aFileContent[$i + 2 + $j], '</table>', 2) <> 0 Then
                    Local $sEndDate = _GetDateTime($aFileContent[$i + 2 + $j - 1])

                    ExitLoop
                EndIf
            Next

            Local $sDiffTime = _GetDiffTime($sStartDate, $sEndDate)
            _WriteToFileLine($sFilePath, $i - 1, StringReplace($aFileContent[$i - 1], '<i class="fa fa-caret-down"></i></h4>', '(' & $sDiffTime & ') <i class="fa fa-caret-down"></i></h4>'))
        EndIf
    Next
EndFunc

Func _GetDateTime($sText)
    Local $aDateTime = StringRegExp($sText, '^.+?<td>(\d{4})(.+?)</td>', 3)

    Return StringTrimRight(StringReplace($aDateTime[0] & $aDateTime[1], '-', '/'), 4)
EndFunc

Func _Debug($sFilePath, $iFileLine, $sContent, $bOverwrite)
    Local $aFileContent = FileReadToArray($sFilePath)
    Local $iFileCount   = UBound($aFileContent)

    _ArrayInsert($aFileContent, 0, $iFileCount)

    Local $aLines  = StringSplit($sContent, @LF)
    Local $iCountContent = $aLines[0]

    For $i = 1 To $iCountContent Step 1
        _ArrayInsert($aFileContent, $iFileLine + $i - 1, '==>' & $aLines[$i])
    Next

    _ArrayDisplay($aFileContent, '$iFileLine: ' & $iFileLine & ' | $bOverwrite: ' & $bOverwrite)
EndFunc
