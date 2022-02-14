; compiler information for AutoIt
#pragma compile(CompanyName, © SOLVE SMART)
#pragma compile(FileVersion, 1.5.0)
#pragma compile(LegalCopyright, © Sven Seyfert)
#pragma compile(ProductName, Example)
#pragma compile(ProductVersion, 1.5.0 - 2022-02-14)

#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#AutoIt3Wrapper_Icon=..\..\media\favicon.ico
#AutoIt3Wrapper_Outfile_x64=Example.exe
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_UseX64=y



; opt and just singleton -------------------------------------------------------
Opt('MustDeclareVars', 1)
Global $aInst = ProcessList('Example.exe')
If $aInst[0][0] > 1 Then Exit



; includes ---------------------------------------------------------------------
#include-once
#include <File.au3>



; declaration ------------------------------------------------------------------
Global $iFileOpenMode                 = $FO_OVERWRITE + $FO_CREATEPATH + $FO_UTF8_NOBOM

Global $sAu3LogFrameworkPath          = _PathFull('..\..\build')
Global $sAu3LogFrameworkExe           = 'Au3LogFramework.exe'
Global $sAu3LogFrameworkOutputPath    = '..\..\output\'
Global $sAu3LogFrameworkReportPath    = '..\..\reports\'

ConsoleWrite($sAu3LogFrameworkPath & @CRLF)
ConsoleWrite($sAu3LogFrameworkExe & @CRLF)
ConsoleWrite($sAu3LogFrameworkOutputPath & @CRLF)
ConsoleWrite($sAu3LogFrameworkReportPath & @CRLF)

Global $sTestObjectName               = 'Example'
Global $sScreenshotWindow             = 'Firefox'
Global $iIndex                        = 1
Global $sFileCurrentReport



; functions --------------------------------------------------------------------
Func _CallAu3LogFramework($iAu3LogFrameworkAction, $sTestObject = '', $sTestScenario = '', $sTestScenarioState = '', $sTestScenarioStepType = '', $sTestScenarioStepDescription = '', $sTestScenarioAdditionalInfo = '', $sSystemUnderTestTitle = '')
    Local $sArguments = _
        '"' & $iAu3LogFrameworkAction & '" ' & _
        '"' & $sTestObject & '" ' & _
        '"' & $sTestScenario & '" ' & _
        '"' & $sTestScenarioState & '" ' & _
        '"' & $sTestScenarioStepType & '" ' & _
        '"' & $sTestScenarioStepDescription & '" ' & _
        '"' & $sTestScenarioAdditionalInfo & '" ' & _
        '"' & $sSystemUnderTestTitle & '"'

    ToolTip($iIndex & ' of 26: ' & $sArguments, 10, 10)
    $iIndex += 1

    ShellExecuteWait(@ComSpec, ' /C cd "' & $sAu3LogFrameworkPath & '" && ' & $sAu3LogFrameworkExe & ' ' & $sArguments, '', '', @SW_HIDE)

    _RandomSleep()
EndFunc

Func _GetCurrentCreatedReport()
    Local $aFileList  = _FileListToArray($sAu3LogFrameworkReportPath, '*.html', 1, True)
    Local $iFileCount = $aFileList[0]

    Return $aFileList[$iFileCount]
EndFunc

Func _WriteFile($sFolderReport, $sText)
    Local $hFile = FileOpen($sFolderReport, $iFileOpenMode)
    FileWrite($hFile, $sText)
    FileClose($hFile)
EndFunc

Func _GetJustFileName($sFilePath)
    Return StringRegExpReplace($sFilePath, '(.+?)\\', '', 0)
EndFunc

Func _CreateAdditionalInfosFile($sFile, $sText)
    Local $sFolderReport        = StringReplace(_GetJustFileName($sFile), '.html', '\')
    Local $sTimestamp           = @YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & '''' & @MIN & '''' & @SEC & '''' & @MSEC
    Local $sFileAdditionalInfos = $sAu3LogFrameworkOutputPath & $sFolderReport & $sTimestamp & '.txt'

    ConsoleWrite($sFileAdditionalInfos & @CRLF)

    _WriteFile($sFileAdditionalInfos, $sText)

    Return $sFileAdditionalInfos
EndFunc

Func _GetHtmlATagWithAdditionalInfosFileLink($sFile)
    Local $sHtmlHref = StringReplace($sFile, '\', '/')
          $sHtmlHref = StringReplace($sHtmlHref, '../../', '../')
    Local $sHtmlATag = '"<a href="' & $sHtmlHref & '" title="Additional infos" style="color: #DC3912;" target="_blank"><i class="fa fa-info-circle"></i></a>'

    Return StringReplace($sHtmlATag, '"', '""')
EndFunc

Func _GetAdditionalInfoHtmlATag()
    Local $sFileAdditionalInfos = _CreateAdditionalInfosFile($sFileCurrentReport, 'FailureMessage:' & @CRLF & _RandomWords() & @CRLF & @CRLF & 'StackTrace:' & @CRLF & _RandomWords())
    Return _GetHtmlATagWithAdditionalInfosFileLink($sFileAdditionalInfos)
EndFunc

Func _RandomWords($iWords = 30)
    Local $sText = ''

    For $i = 1 To $iWords Step 1
        Local $iLength = Random(3, 18, 1)

        Dim $aChr[3]
        For $j = 1 To $iLength Step 1
            $aChr[0] = Chr(Random(65, 90, 1))  ; A-Z
            $aChr[1] = Chr(Random(97, 122, 1)) ; a-z
            $aChr[2] = Chr(Random(48, 57, 1))  ; 0-9
            $sText  &= $aChr[Random(0, 2, 1)]
        Next

        $sText &= ' '
    Next

    Return $sText
EndFunc

Func _RandomSleep()
    Sleep(Random(500, 1250, 1))
EndFunc



; processing -------------------------------------------------------------------
_CallAu3LogFramework('start', $sTestObjectName)

Global $sFileCurrentReport = _GetCurrentCreatedReport()

_CallAu3LogFramework('test', $sTestObjectName, 'First test name', 'Ok', 'Given', 'Test with status Ok')
_CallAu3LogFramework('test', $sTestObjectName, 'First test name', 'Screenshot', 'When', 'Test with status Screenshot', '', $sScreenshotWindow)
_CallAu3LogFramework('test', $sTestObjectName, 'First test name', 'Ok', 'Then', 'Test with status Ok')

_CallAu3LogFramework('test', $sTestObjectName, 'Second test name', 'Ok', 'Given', 'Test with status Ok')
_CallAu3LogFramework('test', $sTestObjectName, 'Second test name', 'Ok', 'When', 'Test with status Ok')
_CallAu3LogFramework('test', $sTestObjectName, 'Second test name', 'Ok', 'When', 'Test with status Ok')
_CallAu3LogFramework('test', $sTestObjectName, 'Second test name', 'Screenshot', 'When', 'Test with status Screenshot', '', $sScreenshotWindow)
_CallAu3LogFramework('test', $sTestObjectName, 'Second test name', 'Warn', 'Then', 'Test with status Warn', _GetAdditionalInfoHtmlATag(), $sScreenshotWindow)

_CallAu3LogFramework('test', $sTestObjectName, 'Third test name', 'Ok', 'Given', 'Test with status Ok')
_CallAu3LogFramework('test', $sTestObjectName, 'Third test name', 'Ok', 'When', 'Test with status Ok')
_CallAu3LogFramework('test', $sTestObjectName, 'Third test name', 'Warn', 'Then', 'Test with status Warn', _GetAdditionalInfoHtmlATag(), $sScreenshotWindow)
_CallAu3LogFramework('test', $sTestObjectName, 'Third test name', 'Screenshot', 'When', 'Test with status Screenshot', '', $sScreenshotWindow)
_CallAu3LogFramework('test', $sTestObjectName, 'Third test name', 'Error', 'Then', 'Test with status Error', _GetAdditionalInfoHtmlATag(), $sScreenshotWindow)

_CallAu3LogFramework('test', $sTestObjectName, 'Fourth test name', 'Warn', 'Given', 'Test with status Warn', '', $sScreenshotWindow)
_CallAu3LogFramework('test', $sTestObjectName, 'Fourth test name', 'Ok', 'When', 'Test with status Ok')
_CallAu3LogFramework('test', $sTestObjectName, 'Fourth test name', 'Ok', 'Then', 'Test with status Ok')

_CallAu3LogFramework('test', $sTestObjectName, 'Sixth test name', 'Warn', 'Given', 'Test with status Warn', _GetAdditionalInfoHtmlATag(), $sScreenshotWindow)
_CallAu3LogFramework('test', $sTestObjectName, 'Sixth test name', 'Error', 'Then', 'Test with status Error', _GetAdditionalInfoHtmlATag(), $sScreenshotWindow)

_CallAu3LogFramework('test', $sTestObjectName, 'Seventh test name', 'Ok', 'Given', 'Test with status Ok')
_CallAu3LogFramework('test', $sTestObjectName, 'Seventh test name', 'Ok', 'When', 'Test with status Ok')
_CallAu3LogFramework('test', $sTestObjectName, 'Seventh test name', 'Ok', 'Then', 'Test with status Ok')

_CallAu3LogFramework('test', $sTestObjectName, 'Eighth test name', 'Ok', 'Given', 'Test with status Ok')
_CallAu3LogFramework('test', $sTestObjectName, 'Eighth test name', 'Ok', 'When', 'Test with status Ok')
_CallAu3LogFramework('test', $sTestObjectName, 'Eighth test name', 'Ok', 'Then', 'Test with status Ok')

_CallAu3LogFramework('stop')
