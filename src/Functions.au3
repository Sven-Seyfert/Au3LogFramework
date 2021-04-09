Func _readIniValue( $sKey )
    Return IniRead( $aFile[$eConfig], 'Storage', $sKey, '' )
EndFunc

Func _writeIniValue( $sKey, $sValue )
    Return IniWrite( $aFile[$eConfig], 'Storage', $sKey, $sValue )
EndFunc

Func _renewIniValue( $sKey, $sValue )
    _writeIniValue( $sKey, $sValue )
    _getStoredIniValues()
EndFunc

Func _createReportStructure()
    Local $iYear = @YEAR, $iMonth = @MON, $iDay = @MDAY
    Local $iHour = @HOUR, $iMin   = @MIN, $iSec = @SEC

    Local $sFullDay = $iYear & '-' & $iMonth & '-' & $iDay

    Local $sFileHtmlReport  = $aPath[$eReports] & $aCmdArg[$eTestObject] & ' ' & $sFullDay & ' ' & $iHour & '''' & $iMin & '''' & $iSec & '.html'
    Local $sHtmlReportTitle = $aCmdArg[$eTestObject] & ' ' & $sFullDay & ' ' & $iHour & ':' & $iMin & ':' & $iSec
    Local $sReportStart     = ' ' & $aCmdArg[$eTestObject] & ' ' & $sFullDay & ' ' & $iHour & ':' & $iMin & ':' & $iSec
    Local $sOutputPath      = StringReplace( StringReplace( $sFileHtmlReport, '\reports\', '\output\' ), '.html', '' )

    $sHtmlHead   = StringReplace( $sHtmlHead, '#{$sHtmlReportTitle}#', $sHtmlReportTitle )
    $sHtmlMain   = StringReplace( $sHtmlMain, '#{$sReportStart}#', $sReportStart )
    $sHtmlFooter = StringReplace( $sHtmlFooter, '#{$sReportStart}#', $sReportStart )

    _createIniStorageSection( $sFileHtmlReport, $sOutputPath )
    _writeFile( $sFileHtmlReport, $sHtmlHead & $sHtmlMain & $sHtmlFooter )

    DirCreate( $sOutputPath )
EndFunc

Func _createIniStorageSection( $sFileHtmlReportString, $sOutputPathString )
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

    IniWriteSection( $aFile[$eConfig], 'Storage', $aSection )
EndFunc

Func _getStoredIniValues()
    $aIni[$eCountError]                            = _readIniValue( 'CountError' )
    $aIni[$eCountOk]                               = _readIniValue( 'CountOk' )
    $aIni[$eCountWarn]                             = _readIniValue( 'CountWarn' )
    $aIni[$eIsNewTestScenario]                     = _readIniValue( 'IsNewTestScenario' )
    $aIni[$eLineOfDataForFirstChart]               = _readIniValue( 'LineOfDataForFirstChart' )
    $aIni[$eLineOfDataForSecondChart]              = _readIniValue( 'LineOfDataForSecondChart' )
    $aIni[$eLineOfDuration]                        = _readIniValue( 'LineOfDuration' )
    $aIni[$eLineOfLogEndTime]                      = _readIniValue( 'LineOfLogEndTime' )
    $aIni[$eLineOfTitleTag]                        = _readIniValue( 'LineOfTitleTag' )
    $aIni[$eOutputPath]                            = _readIniValue( 'OutputPath' )
    $aIni[$eReportFile]                            = _readIniValue( 'ReportFile' )
    $aIni[$eScenarioStepMaxNumber]                 = _readIniValue( 'ScenarioStepMaxNumber' )
    $aIni[$eScenarioStepNumber]                    = _readIniValue( 'ScenarioStepNumber' )
    $aIni[$eTestScenarioName]                      = _readIniValue( 'TestScenarioName' )
    $aIni[$eTestScenarioNumber]                    = _readIniValue( 'TestScenarioNumber' )
    $aIni[$eWasThereAWarnInTheCurrentTestScenario] = _readIniValue( 'WasThereAWarnInTheCurrentTestScenario' )
EndFunc

Func _createTestScenarioOrScenarioStep( $sColor, $sTestScenarioState )
    _getStoredIniValues()

    If $aIni[$eTestScenarioName] <> $aCmdArg[$eTestScenario] Then
        _renewIniValue( 'IsNewTestScenario', 'true' )
        _renewIniValue( 'TestScenarioName', $aCmdArg[$eTestScenario] )
        _renewIniValue( 'TestScenarioNumber', $aIni[$eTestScenarioNumber] + 1 )
        _renewIniValue( 'WasThereAWarnInTheCurrentTestScenario', 'false' )
        Local $iRowsToAdd = _writeNewTestScenario( $sColor, $sTestScenarioState )
    Else
        _renewIniValue( 'IsNewTestScenario', 'false' )
        Local $iRowsToAdd = _writeNewScenarioStepOfAGivenTestScenario( $sColor, $sTestScenarioState )
    EndIf

    _renewIniValue( 'LineOfLogEndTime', $aIni[$eLineOfLogEndTime] + $iRowsToAdd )
    _renewIniValue( 'ScenarioStepMaxNumber', $aIni[$eScenarioStepMaxNumber] + 1 )
    _renewIniValue( 'ScenarioStepNumber', $aIni[$eScenarioStepNumber] + 1 )

    _renewChartSectionValues()
    _renewResultSectionValues()
    _renewTheEndLogDateAndTheTestDurationTime()
EndFunc

Func _writeNewTestScenario( $sColor, $sTestScenarioState )
    _renewIniValue( 'ScenarioStepNumber', 0 )
    $sHtmlNewTestScenario = _replaceHtmlPlaceholder( $sColor, $sHtmlNewTestScenario )
    $sHtmlNewTestScenario = _addScreenshot( $sTestScenarioState, $sHtmlNewTestScenario )

    Local $iLine = _getFileLineNumberForLastSearchMatch( $aIni[$eReportFile], '<hr data-hr>' )

    _writeToFileLine( $aIni[$eReportFile], $iLine , $sHtmlNewTestScenario, False )

    Local $iLinesOfHtmlNewTestScenario = 7

    Return $iLinesOfHtmlNewTestScenario
EndFunc

Func _writeNewScenarioStepOfAGivenTestScenario( $sColor, $sTestScenarioState )
    $sHtmlNewScenarioStep = _replaceHtmlPlaceholder( $sColor, $sHtmlNewScenarioStep )
    $sHtmlNewScenarioStep = _addScreenshot( $sTestScenarioState, $sHtmlNewScenarioStep )

    Local $iLine = _getFileLineNumberForLastSearchMatch( $aIni[$eReportFile], '</table>' )

    _writeToFileLine( $aIni[$eReportFile], $iLine, $sHtmlNewScenarioStep, False )

    If $sColor <> $aColor[$eError] Then
        If $aIni[$eIsNewTestScenario] == 'false' And $aIni[$eWasThereAWarnInTheCurrentTestScenario] == 'true'  Then $sColor = $aColor[$eWarn]
        If $aIni[$eIsNewTestScenario] == 'true'  And $aIni[$eWasThereAWarnInTheCurrentTestScenario] == 'false' Then $sColor = $sColor
    EndIf

    _replaceLine( _getFileLineNumberForLastSearchMatch( $aIni[$eReportFile], '<h4 data-h4>' ), 'color: #.+?;', 'color: #' & $sColor & ';' )

    Local $iLinesOfHtmlNewScenarioStep = 1

    Return $iLinesOfHtmlNewScenarioStep
EndFunc

Func _replaceHtmlPlaceholder( $sColor, $sText )
    $sText = StringReplace( $sText, '#{$sColor}#', $sColor )
    $sText = StringReplace( $sText, '#{$eTestScenarioNumber}#', $aIni[$eTestScenarioNumber] )
    $sText = StringReplace( $sText, '#{$eTestScenario}#', $aCmdArg[$eTestScenario] )
    $sText = StringReplace( $sText, '#{$eScenarioStepNumber}#', $aIni[$eScenarioStepNumber] + 1 )
    $sText = StringReplace( $sText, '#{$sExecutionTime}#', $sExecutionTime )
    $sText = StringReplace( $sText, '#{$eTestScenarioStepType}#', $aCmdArg[$eTestScenarioStepType] )
    $sText = StringReplace( $sText, '#{$eTestScenarioStepDescription}#', $aCmdArg[$eTestScenarioStepDescription] )

    Return   StringReplace( $sText, '#{$eTestScenarioAdditionalInfo}#', $aCmdArg[$eTestScenarioAdditionalInfo] )
EndFunc

Func _addScreenshot( $sState, $sText )
    Switch $sState
        Case 'screenshot', 'error'
            $sText = StringReplace( $sText, '#{_setScreenshotFileToHtml()}#', _setScreenshotFileToHtml() )

        Case 'warn'
            $sText = StringReplace( $sText, '#{_setScreenshotFileToHtml()}#', _setScreenshotFileToHtml() )
            _renewIniValue( 'WasThereAWarnInTheCurrentTestScenario', 'true' )

        Case Else
            $sText = StringReplace( $sText, '#{_setScreenshotFileToHtml()}#', '' )
    EndSwitch

    Return $sText
EndFunc

Func _setScreenshotFileToHtml()
    $sScreenshotTime = @YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & '''' & @MIN & '''' & @SEC & '''' & @MSEC
    Local $sScreenshotFile = StringReplace( $aIni[$eOutputPath] & $sScreenshotTime & $sImageExtension, '\', '/' )

    Return StringRegExpReplace( $sScreenshotFile, '(.+?)output', '../output', 1 )
EndFunc

Func _replaceLine( $iLine, $sPattern, $sReplace )
    Local $sLineContent = FileReadLine( $aIni[$eReportFile], $iLine )
          $sLineContent = StringRegExpReplace( $sLineContent, $sPattern, $sReplace )

    _writeToFileLine( $aIni[$eReportFile], $iLine, $sLineContent )
EndFunc

Func _renewChartSectionValues()
    Switch $aCmdArg[$eTestScenarioState]
        Case 'ok'
            _renewIniValue( 'CountOk', $aIni[$eCountOk] + 1 )

        Case 'screenshot'
            _renewIniValue( 'CountOk', $aIni[$eCountOk] + 1 )
            _createScreenshot()

        Case 'warn'
            _renewIniValue( 'CountWarn', $aIni[$eCountWarn] + 1 )
            _createScreenshot()

        Case 'error'
            _renewIniValue( 'CountError', $aIni[$eCountError] + 1 )
            _createScreenshot()
    EndSwitch

    Local $iFirstChartPercentageForOk     = Round( 100 / $aIni[$eTestScenarioNumber] * ( $aIni[$eTestScenarioNumber] - $aIni[$eCountError] ), 1 )
    Local $iFirstChartPercentageForError  = Round( 100 / $aIni[$eTestScenarioNumber] * $aIni[$eCountError], 1 )
    Local $iSecondChartPercentageForOk    = Round( 100 / $aIni[$eScenarioStepMaxNumber] * $aIni[$eCountOk], 1 )
    Local $iSecondChartPercentageForError = Round( 100 / $aIni[$eScenarioStepMaxNumber] * $aIni[$eCountError], 1 )
    Local $iSecondChartPercentageForWarn  = Round( 100 / $aIni[$eScenarioStepMaxNumber] * $aIni[$eCountWarn], 1 )

    _writeToFileLine( $aFile[$eJs], $aIni[$eLineOfDataForFirstChart]  - 4, _StringRepeat( ' ', 12 ) & 'labels: ["OK (' & $iFirstChartPercentageForOk & '%)", "ERROR (' & $iFirstChartPercentageForError & '%)"],' )
    _writeToFileLine( $aFile[$eJs], $aIni[$eLineOfDataForSecondChart] - 4, _StringRepeat( ' ', 12 ) & 'labels: ["OK (' & $iSecondChartPercentageForOk & '%)", "ERROR (' & $iSecondChartPercentageForError & '%)", "WARN (' & $iSecondChartPercentageForWarn & '%)"],' )
    _writeToFileLine( $aFile[$eJs], $aIni[$eLineOfDataForFirstChart],  _StringRepeat( ' ', 20 ) & 'data: [' & $aIni[$eTestScenarioNumber] - $aIni[$eCountError] & ', ' & $aIni[$eCountError] & '],' )
    _writeToFileLine( $aFile[$eJs], $aIni[$eLineOfDataForSecondChart], _StringRepeat( ' ', 20 ) & 'data: [' & $aIni[$eCountOk] & ', ' & $aIni[$eCountError] & ', ' & $aIni[$eCountWarn] & '],' )
EndFunc

Func _renewResultSectionValues()
    _replaceLine( $aIni[$eLineOfLogEndTime] - 8, '</span><strong>\d{1,}</strong></div><hr>', '</span><strong>' & $aIni[$eTestScenarioNumber] & '</strong></div><hr>' )
    _replaceLine( $aIni[$eLineOfLogEndTime] - 7, 'OK</span>\d{1,}</div><hr>', 'OK</span>' & $aIni[$eTestScenarioNumber] - $aIni[$eCountError] & '</div><hr>' )
    _replaceLine( $aIni[$eLineOfLogEndTime] - 6, 'ERRORS</span>\d{1,}</div><hr>', 'ERRORS</span>' & $aIni[$eCountError] & '</div><hr>' )
    _replaceLine( $aIni[$eLineOfLogEndTime] - 4, '</span><strong>\d{1,}</strong></div><hr>', '</span><strong>' & $aIni[$eScenarioStepMaxNumber] & '</strong></div><hr>' )
    _replaceLine( $aIni[$eLineOfLogEndTime] - 3, 'OK</span>\d{1,}</div><hr>', 'OK</span>' & $aIni[$eCountOk] & '</div><hr>' )
    _replaceLine( $aIni[$eLineOfLogEndTime] - 2, 'ERRORS</span>\d{1,}</div><hr>', 'ERRORS</span>' & $aIni[$eCountError] & '</div><hr>' )
    _replaceLine( $aIni[$eLineOfLogEndTime] - 1, 'WARN</span>\d{1,}</div><hr>', 'WARN</span>' & $aIni[$eCountWarn] & '</div><hr>' )
EndFunc

Func _renewTheEndLogDateAndTheTestDurationTime()
    Local $iEndYear = @YEAR, $iEndMon = @MON, $iEndMday = @MDAY
    Local $iEndHour = @HOUR, $iEndMin = @MIN, $iEndSec  = @SEC

    Local $sTimestamp = $iEndYear & '-' & $iEndMon & '-' & $iEndMday & ' ' & $iEndHour & ':' & $iEndMin & ':' & $iEndSec

    _replaceLine( $aIni[$eLineOfLogEndTime], '\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}', $sTimestamp )

    Local $sStartDate = StringRegExpReplace( FileReadLine( $aIni[$eReportFile], $aIni[$eLineOfTitleTag] ), '.+?(\d{4})-(\d{2})-(\d{2}) (\d{2}:\d{2}:\d{2}).+?$', '$1/$2/$3 $4' )
    Local $sEndDate   = $iEndYear & '/' & $iEndMon & '/' & $iEndMday & ' ' & $iEndHour & ':' & $iEndMin & ':' & $iEndSec

    _replaceLine( $aIni[$eLineOfDuration], 'TEST DURATION:</b> .+?$', 'TEST DURATION:</b> ' & _getDiffTime( $sStartDate, $sEndDate ) )
EndFunc

Func _setTestScenarioExecutionTime( $sFilePath )
    Local $aFileContent = FileReadToArray( $sFilePath )
    Local $iFileCount   = UBound( $aFileContent )

    _ArrayInsert( $aFileContent, 0, $iFileCount )

    For $i = 1 To $iFileCount Step 1
        If StringInStr( $aFileContent[$i], '<table>', 2 ) <> 0 Then
            Local $sStartDate = _getDateTime( $aFileContent[$i + 2] )

            For $j = 1 To 200 Step 1
                If StringInStr( $aFileContent[$i + 2 + $j], '</table>', 2 ) <> 0 Then
                    Local $sEndDate = _getDateTime( $aFileContent[$i + 2 + $j - 1] )

                    ExitLoop
                EndIf
            Next

            Local $sDiffTime = _getDiffTime( $sStartDate, $sEndDate )
            _writeToFileLine( $sFilePath, $i - 1, StringReplace( $aFileContent[$i - 1], '<i class="fa fa-caret-down"></i></h4>', '(' & $sDiffTime & ') <i class="fa fa-caret-down"></i></h4>' ) )
        EndIf
    Next
EndFunc

Func _getDateTime( $sText )
    Local $aDateTime = StringRegExp( $sText, '^.+?<td>(\d{4})(.+?)</td>', 3 )

    Return StringTrimRight( StringReplace( $aDateTime[0] & $aDateTime[1], '-', '/' ), 4 )
EndFunc

Func _debug( $sFilePath, $iFileLine, $sContent, $bOverwrite )
    Local $aFileContent = FileReadToArray( $sFilePath )
    Local $iFileCount   = UBound( $aFileContent )

    _ArrayInsert( $aFileContent, 0, $iFileCount )

    Local $aLines  = StringSplit( $sContent, @LF )
    Local $iCountContent = $aLines[0]

    For $i = 1 To $iCountContent Step 1
        _ArrayInsert( $aFileContent, $iFileLine + $i - 1, '==>' & $aLines[$i] )
    Next

    _ArrayDisplay( $aFileContent, '$iFileLine: ' & $iFileLine & ' | $bOverwrite: ' & $bOverwrite )
EndFunc
