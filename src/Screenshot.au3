Func _CreateScreenshot()
    Local $hProgram = _GetWindowHandle($aCmdArg[$eSystemUnderTestTitle])
    WinActivate($hProgram)

    If StringLower($bMaximizeWindowInCaseOfTakenScreenshot) == 'true' Then
        WinSetState($hProgram, '', @SW_MAXIMIZE)
    EndIf

    _ScreenCapture_CaptureWnd($aIni[$eOutputPath] & $sScreenshotTime & $sImageExtension, $hProgram)
EndFunc

Func _GetWindowHandle($sTitle)
    Local $aListOfOpenWindows = WinList()

    For $i = 1 To $aListOfOpenWindows[0][0] Step 1
        If StringInStr($aListOfOpenWindows[$i][0], 'Blank Page - ' & $sTitle, 2) <> 0 Then ContinueLoop
        If StringInStr($aListOfOpenWindows[$i][0], $sTitle, 2) <> 0 Then Return $aListOfOpenWindows[$i][1]
    Next

    Return False
EndFunc
