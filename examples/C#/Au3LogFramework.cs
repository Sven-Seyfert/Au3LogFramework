using BehaviorDrivenTesting.Shared;
using OpenQA.Selenium;
using System;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;

namespace BehaviorDrivenTesting.ThirdParty
{
    public class Au3LogFramework
    {
        private const string AU3_LOG_FRAMEWORK_EXE = "Au3LogFramework.exe";
        private const string TEST_OBJECT = "Example";

        private static readonly string _codeBaseFolderPath = Path.GetDirectoryName(Assembly.GetExecutingAssembly().GetName().CodeBase)?
            .Replace("file:\\", string.Empty);

        private static IWebDriver WebDriver => Chrome.Instance;

        public static void StartAu3LogFramework()
        {
            const string au3LogFrameworkAction = "start";

            var driveCharacter = GetProjectFolderPath()[0];

            var startInfo = new ProcessStartInfo
            {
                WindowStyle = ProcessWindowStyle.Hidden,
                FileName = "cmd.exe",
                Arguments = $@" /C {driveCharacter}: && cd ""{GetAu3LogFrameworkExeFilePath()}"" && {AU3_LOG_FRAMEWORK_EXE} " +
                            $@"""{au3LogFrameworkAction}"" " +
                            $@"""{TEST_OBJECT}"""
            };

            StartAndWaitForProcess(startInfo);
            StoreCurrentCreatedReportToGlobalStore();
        }

        public static void StopAu3LogFramework()
        {
            const string au3LogFrameworkAction = "stop";

            var driveCharacter = GetProjectFolderPath()[0];

            var startInfo = new ProcessStartInfo
            {
                WindowStyle = ProcessWindowStyle.Hidden,
                FileName = "cmd.exe",
                Arguments = $@" /C {driveCharacter}: && cd ""{GetAu3LogFrameworkExeFilePath()}"" && {AU3_LOG_FRAMEWORK_EXE} " +
                            $@"""{au3LogFrameworkAction}"""
            };

            StartAndWaitForProcess(startInfo);
        }

        private static void TestAu3LogFramework(string testScenario, string testScenarioState, string testScenarioStepType, string testScenarioStepDescription, string testScenarioAdditionalInfo)
        {
            const string au3LogFrameworkAction = "test";

            var lastTwoParameter = string.Empty;
            var systemUnderTestTitle = WebDriver.Title;

            if (testScenarioState != "ok")
            {
                lastTwoParameter = $@" ""{testScenarioAdditionalInfo}"" ""{systemUnderTestTitle}""";
            }

            var driveCharacter = GetProjectFolderPath()[0];

            var startInfo = new ProcessStartInfo
            {
                WindowStyle = ProcessWindowStyle.Hidden,
                FileName = "cmd.exe",
                Arguments = $@" /C {driveCharacter}: && cd ""{GetAu3LogFrameworkExeFilePath()}"" && {AU3_LOG_FRAMEWORK_EXE} " +
                            $@"""{au3LogFrameworkAction}"" " +
                            $@"""{TEST_OBJECT}"" " +
                            $@"""{testScenario}"" " +
                            $@"""{testScenarioState}"" " +
                            $@"""{testScenarioStepType}"" " +
                            $@"""{testScenarioStepDescription}""" +
                            lastTwoParameter
            };

            StartAndWaitForProcess(startInfo);
        }

        public static void WriteOkToReport(string testScenario, string testScenarioStepType, string testScenarioStepDescription, string testScenarioAdditionalInfo = "")
        {
            TestAu3LogFramework(testScenario, "ok", testScenarioStepType, testScenarioStepDescription, testScenarioAdditionalInfo);
        }

        public static void WriteScreenshotToReport(string testScenario, string testScenarioStepDescription, string testScenarioAdditionalInfo = "")
        {
            TestAu3LogFramework(testScenario, "screenshot", "Screenshot", testScenarioStepDescription, testScenarioAdditionalInfo);
        }

        public static void WriteWarnToReport(string testScenario, string testScenarioStepType, string testScenarioStepDescription, string testScenarioAdditionalInfo)
        {
            TestAu3LogFramework(testScenario, "warn", testScenarioStepType, testScenarioStepDescription, GetAdditionalInfoHtmlATag(testScenarioAdditionalInfo));
        }

        public static void WriteErrorToReport(string testScenario, string testScenarioStepType, string testScenarioStepDescription, string testScenarioAdditionalInfo)
        {
            TestAu3LogFramework(testScenario, "error", testScenarioStepType, testScenarioStepDescription, GetAdditionalInfoHtmlATag(testScenarioAdditionalInfo));
        }

        private static void StartAndWaitForProcess(ProcessStartInfo startInfo)
        {
            var process = new Process { StartInfo = startInfo };

            process.Start();
            process.WaitForExit();
        }

        private static string GetProjectFolderPath()
        {
            var parentFolderPath = GetParentFolderPath(_codeBaseFolderPath);

            const int parentDirectoryAttempts = 4;

            for (var i = 0; i < parentDirectoryAttempts; i++)
            {
                var subDirectories = Directory.GetDirectories(parentFolderPath);

                if (Array.Exists(subDirectories, directory => directory.EndsWith("ThirdParty")))
                {
                    return parentFolderPath;
                }

                parentFolderPath = GetParentFolderPath(parentFolderPath);
            }

            throw new DirectoryNotFoundException();
        }

        private static string GetParentFolderPath(string frameworkVersionFolderPath)
        {
            return Directory
                .GetParent(frameworkVersionFolderPath?.Replace("file:\\", string.Empty) ?? throw new DirectoryNotFoundException())?
                .FullName;
        }

        private static string GetAu3LogFrameworkExeFilePath()
        {
            return $@"{GetProjectFolderPath()}\ThirdParty\Au3LogFramework\build";
        }

        private static void StoreCurrentCreatedReportToGlobalStore()
        {
            var projectFolderPath = GetProjectFolderPath();
            var au3LogFrameworkReportFolder = $@"{projectFolderPath}\ThirdParty\Au3LogFramework\reports";

            StaticContext.CurrentCreatedReport = Directory
                .GetFiles(au3LogFrameworkReportFolder, "*.html")
                .Last();
        }

        private static string GetJustFileNameOfFilePath(string filePath)
        {
            return Regex.Replace(filePath, @"(.+?)\\", string.Empty);
        }

        private static string GetFormatedDateTime()
        {
            return DateTime.Now.ToString("yyyy-MM-dd HHmmssfff")
                .Insert(13, "'")
                .Insert(16, "'")
                .Insert(19, "'");
        }

        private static string CreateAdditionalInfoFile(string content)
        {
            var projectFolderPath = GetProjectFolderPath();
            var au3LogFrameworkOutputFolder = $@"{projectFolderPath}\ThirdParty\Au3LogFramework\output";

            var fileName = GetJustFileNameOfFilePath(StaticContext.CurrentCreatedReport);
            var reportSubFolderName = fileName.Replace(".html", string.Empty);

            var additionalInformationFile = $@"{au3LogFrameworkOutputFolder}\{reportSubFolderName}\{GetFormatedDateTime()}.txt";
            File.WriteAllText(additionalInformationFile, content);

            return additionalInformationFile;
        }

        private static string GetHtmlATagWithAdditionalInfoFileLink(string filePath)
        {
            var relativeFilePath = Regex.Match(filePath.Replace(@"\", "/"), @".+?/output/(.+?)$").Groups[1].Value;
            var htmlATag = $@"<a href=""../output/{relativeFilePath}"" title=""Additional infos"" style=""color: #DC3912;"" target=""_blank""><i class=""fa fa-info-circle""></i></a>";

            return htmlATag.Replace(@"""", @"""""");
        }

        private static string GetAdditionalInfoHtmlATag(string testScenarioAdditionalInfo)
        {
            var additionalInformationFile = CreateAdditionalInfoFile(testScenarioAdditionalInfo);

            return GetHtmlATagWithAdditionalInfoFileLink(additionalInformationFile);
        }
    }
}
