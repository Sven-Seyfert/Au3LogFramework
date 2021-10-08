Global $sHtmlHead = _
    '<!DOCTYPE html>' & @CRLF & _
    '<html>' & @CRLF & _
    '<head>' & @CRLF & _
    _spaces(4) & '<title>#{$sHtmlReportTitle}#</title>' & @CRLF & _
    _spaces(4) & '<meta charset="UTF-8" />' & @CRLF & _
    _spaces(4) & '<link rel="shortcut icon" href="../media/favicon.ico" type="image/x-icon" />' & @CRLF & _
    _spaces(4) & '<link rel="stylesheet" href="../css/fontAwesome.css">' & @CRLF & _
    _spaces(4) & '<link rel="stylesheet" href="../css/style.css">' & @CRLF & _
    _spaces(4) & '<script src="../js/jQuery.min.js"></script>' & @CRLF & _
    _spaces(4) & '<script src="../js/chartJs.min.js"></script>' & @CRLF & _
    _spaces(4) & '<script src="../js/script.js"></script>' & @CRLF & _
    '</head>' & @CRLF & _
    '<body>' & @CRLF

Global $sHtmlMain = _
    _spaces(4) & '<img src="../images/icon.png" class="logo" />' & @CRLF & _
    _spaces(4) & '<h2 id="headline">' & $sProgramName & '</h2><br />' & @CRLF & _
    _spaces(4) & '<div class="information">' & @CRLF & _
    _spaces(8) & '<b><i class="fa fa-laptop"></i> COMPUTER:</b> ' & @ComputerName & '&nbsp;&nbsp;&nbsp;' & _
                   '<b><i class="fa fa-flag-o"></i> OS:</b> ' & @OSVersion & ' ' & @OSArch & '&nbsp;&nbsp;&nbsp;' & _
                   '<b><i class="fa fa-user-o"></i> USER:</b> ' & @UserName & '&nbsp;&nbsp;&nbsp;' & _
                   '<b><i class="fa fa-window-maximize"></i> RESOLUTION:</b> ' & $iDisplayWidth & 'x' & $iDisplayHeight & '&nbsp;&nbsp;&nbsp;' & _
                   '<b><i class="fa fa-linode"></i> TestRunner:</b> ' & $sTestRunner & '&nbsp;&nbsp;&nbsp;' & _
                   '<b><i class="fa fa-hourglass-half"></i> TEST DURATION:</b> 0 minutes' & @CRLF & _
    _spaces(4) & '</div>' & @CRLF & _
    _spaces(4) & '<p>Test Report Start:&nbsp;#{$sReportStart}#</p>' & @CRLF & _
    _spaces(4) & '<button id="button1"><i class="fa fa-caret-down"></i>&nbsp;&nbsp;Show Details</button>&nbsp;' & @CRLF & _
    _spaces(4) & '<button id="button2"><i class="fa fa-sort"></i><span id="toggle">&nbsp;&nbsp;Fold|Unfold</span></button>' & @CRLF & _
    _spaces(4) & '<section>' & @CRLF & _
    _spaces(8) & '<hr>' & @CRLF

Global $sHtmlFooter = _
    _spaces(8) & '<hr data-hr>' & @CRLF & _
    _spaces(4) & '</section>' & @CRLF & _
    _spaces(4) & '<p>Result:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p>' & @CRLF & _
    _spaces(4) & '<hr><div><span class="graphView"><i class="fa fa-area-chart"></i>&nbsp;GRAPH VIEWS</span></div>' & @CRLF & _
    _spaces(4) & '<div id="firstChartDiv"><canvas id="firstChart"></canvas></div>' & @CRLF & _
    _spaces(4) & '<div id="secondChartDiv"><canvas id="secondChart"></canvas></div><hr>' & @CRLF & _
    _spaces(4) & '<hr><div><span class="result"><i class="fa fa-list"></i>&nbsp;TEST SCENARIOS</span><strong>0</strong></div><hr>' & @CRLF & _
    _spaces(4) & '<hr><div><span class="result" style="color: #' & $aColor[$eOk] & ';"><i class="fa fa-check-circle"></i>&nbsp;OK</span>0</div><hr>' & @CRLF & _
    _spaces(4) & '<hr><div><span class="result" style="color: #' & $aColor[$eError] & ';"><i class="fa fa-bug"></i>&nbsp;ERRORS</span>0</div><hr>' & @CRLF & _
    _spaces(4) & '<br />' & @CRLF & _
    _spaces(4) & '<hr><div><span class="result"><i class="fa fa-indent"></i>&nbsp;TEST STEPS</span><strong>0</strong></div><hr>' & @CRLF & _
    _spaces(4) & '<hr><div><span class="result" style="color: #' & $aColor[$eOk] & ';"><i class="fa fa-check-circle"></i>&nbsp;OK</span>0</div><hr>' & @CRLF & _
    _spaces(4) & '<hr><div><span class="result" style="color: #' & $aColor[$eError] & ';"><i class="fa fa-bug"></i>&nbsp;ERRORS</span>0</div><hr>' & @CRLF & _
    _spaces(4) & '<hr><div><span class="result" style="color: #' & $aColor[$eWarn] & ';"><i class="fa fa-exclamation-triangle"></i>&nbsp;WARN</span>0</div><hr>' & @CRLF & _
    _spaces(4) & '<p>Test Report End:&nbsp;&nbsp;&nbsp;#{$sReportStart}#</p>' & @CRLF & _
    _spaces(4) & '<button id="scroll"><i class="fa fa-caret-up"></i>&nbsp;&nbsp;To The Top</button>' & @CRLF & _
    _spaces(4) & '<div id="footerText">' & $sProgramName & ' ' & @YEAR & ' <i class="fa fa-copyright"></i> Sven Seyfert // <a href="https://github.com/Sven-Seyfert" target="_blank"><i class="fa fa-github"></i> github</a></div>' & @CRLF & _
    _spaces(4) & '<script>showCharts();</script>' & @CRLF & _
    '</body>' & @CRLF & _
    '</html>' & @CRLF

Global $sHtmlNewTestScenario = _
    _spaces(8)  & '<div>' & @CRLF & _
    _spaces(12) & '<h4 data-h4><strong style="color: ##{$sColor}#;"><i class="fa fa-list"></i></strong>&nbsp;TEST SCENARIO #{$eTestScenarioNumber}#: #{$eTestScenario}# <i class="fa fa-caret-down"></i></h4>' & @CRLF & _
    _spaces(12) & '<table><col width="130px"><col width="195px"><col width="115px"><col width="*"><col width="70px"><col width="200xp">' & @CRLF & _
    _spaces(16) & '<tr class="bold"><td>' & '<i class="fa fa-indent"></i>&nbsp;STEP NUMBER</td><td>' & '<i class="fa fa-clock-o"></i>&nbsp;EXECUTION TIME</td><td>' & '<i class="fa fa-code"></i>&nbsp;STEP TYPE</td><td>' & '<i class="fa fa-sticky-note-o"></i>&nbsp;STEP DESCRIPTION</td><td>' & '<i class="fa fa-eye"></i>&nbsp;INFO</td><td>' & '<i class="fa fa-desktop"></i>&nbsp;PROGRAM SCREENSHOT</td></tr>' & @CRLF & _
    _spaces(16) & '<tr><td>' & '<strong style="color: ##{$sColor}#;"><i class="fa fa-indent"></i></strong>&nbsp; #{$eTestScenarioNumber}#.#{$eScenarioStepNumber}#</td><td>' & '#{$sExecutionTime}#</td><td>' & '#{$eTestScenarioStepType}#</td><td>' & '#{$eTestScenarioStepDescription}#</td><td class="alginCenter">' & '#{$eTestScenarioAdditionalInfo}#</td><td>' & '<a href="#{_setScreenshotFileToHtml()}#" target="_blank">' & $aCmdArg[$eSystemUnderTestTitle] & '</a></td></tr>' & @CRLF & _
    _spaces(12) & '</table>' & @CRLF & _
    _spaces(8)  & '</div>'

Global $sHtmlNewScenarioStep = _
    _spaces(16) & '<tr><td>' & '<strong style="color: ##{$sColor}#;"><i class="fa fa-indent"></i></strong>&nbsp; #{$eTestScenarioNumber}#.#{$eScenarioStepNumber}#</td><td>' & '#{$sExecutionTime}#</td><td>' & '#{$eTestScenarioStepType}#</td><td>' & '#{$eTestScenarioStepDescription}#</td><td class="alginCenter">' & '#{$eTestScenarioAdditionalInfo}#</td><td>' & '<a href="#{_setScreenshotFileToHtml()}#" target="_blank">' & $aCmdArg[$eSystemUnderTestTitle] & '</a></td></tr>'
