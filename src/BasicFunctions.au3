Func _showErrorMessage( $sText )
    If StringLower( $bSilentModeWithoutMsgBoxes ) == 'false' Then MsgBox( $iMsgBoxErrorIcon, 'Error', $sText, 30 )
EndFunc

Func _setMaxDirectories( $sPath, $i = 20 )
    Local $aDirectories = _FileListToArray( $sPath, '*', 2, True )
    If IsArray( $aDirectories ) Then
        Local $iDirectoriesCount = $aDirectories[0]
        If $iDirectoriesCount > $i Then
            For $j = 1 To $iDirectoriesCount - $i Step 1
                DirRemove( $aDirectories[$j], 1 )
            Next
        EndIf
    EndIf
EndFunc

Func _setMaxFiles( $sPath, $i = 20 )
    Local $aFiles = _FileListToArray( $sPath, '*.html', 1, True )
    If IsArray( $aFiles ) Then
        Local $iFilesCount = $aFiles[0]
        If $iFilesCount > $i Then
            For $j = 1 To $iFilesCount - $i Step 1
                FileDelete( $aFiles[$j] )
            Next
        EndIf
    EndIf
EndFunc

Func _writeFile( $sFile, $sText )
    Local $hFile = FileOpen( $sFile, $iFileOpenMode )
    FileWrite( $hFile, $sText )
    FileClose( $hFile )
EndFunc

Func _writeToFileLine( $sFilePath, $iLine, $sText, $bOverWrite = True )
    If StringLower( $bDebug ) == 'true' Then _debug( $sFilePath, $iLine, $sText, $bOverWrite )

    Local $aFileContent    = FileReadToArray( $sFilePath )
    Local $iLineCount      = UBound( $aFileContent ) - 1
    Local $hFile           = FileOpen( $sFilePath, $iFileOpenMode )
    Local $sData           = ''
    Local $iZeroBasedArray = 1

    $iLine -= $iZeroBasedArray

    For $i = 0 To $iLineCount Step 1
        If $i == $iLine Then
            If $bOverWrite     Then $sData &= $sText & @CRLF
            If Not $bOverWrite Then $sData &= $sText & @CRLF & $aFileContent[$i] & @CRLF
        ElseIf $i < $iLineCount Then
            $sData &= $aFileContent[$i] & @CRLF
        ElseIf $i == $iLineCount Then
            $sData &= $aFileContent[$i]
        EndIf
    Next

    FileWrite( $hFile, $sData )
    FileClose( $hFile )
EndFunc

Func _getFileLineNumberForLastSearchMatch( $sFilePath, $sText )
    Local $aFileContent = FileReadToArray( $sFilePath )
    Local $iLineCount   = UBound( $aFileContent ) - 1

    For $i = $iLineCount To 0 Step -1
        If StringInStr( $aFileContent[$i], $sText, 2 ) <> 0 Then Return $i + 1
    Next
EndFunc

Func _getDiffTime( $sFrom, $sTo )
    Return _secondsToMinutes( _DateDiff( 's', $sFrom, $sTo ) )
EndFunc

Func _secondsToMinutes( $iGivenSeconds )
    Local $iHours   = Int( $iGivenSeconds / 3600 )
    Local $iMinutes = Int( Mod( $iGivenSeconds, 3600 ) / 60 )
    Local $iSeconds = Mod( $iGivenSeconds, 60 )

    If $iHours   >  0  Then Return StringFormat( '%02d:%02d:%02d', $iHours, $iMinutes, $iSeconds ) & ' hours'
    If $iMinutes >= 1  Then Return StringFormat( '%02d:%02d', $iMinutes, $iSeconds ) & ' minutes'
    If $iSeconds <= 59 Then Return StringFormat( '%02d', $iSeconds ) & ' seconds'
EndFunc
