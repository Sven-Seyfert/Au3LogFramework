Func _createScreenshot()
    Local $hProgram = _getWindowHandle( $aCmdArg[$eSystemUnderTestTitle] )
    WinActivate( $hProgram )
    WinSetState( $hProgram, '', @SW_MAXIMIZE )
    _ScreenCapture_CaptureWnd( $aIni[$eOutputPath] & $sScreenshotTime & $sImageExtension, $hProgram )
EndFunc

Func _getWindowHandle( $sTitle )
    Local $aListOfOpenWindows = WinList()

    For $i = 1 To $aListOfOpenWindows[0][0] Step 1
        If StringInStr( $aListOfOpenWindows[$i][0], 'Blank Page - ' & $sTitle, 2 ) <> 0 Then ContinueLoop
        If StringInStr( $aListOfOpenWindows[$i][0], $sTitle, 2 ) <> 0 Then Return $aListOfOpenWindows[$i][1]
    Next

    Return False
EndFunc
