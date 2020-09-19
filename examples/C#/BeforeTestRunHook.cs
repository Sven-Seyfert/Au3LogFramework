using BehaviorDrivenTesting.ThirdParty;
using OpenQA.Selenium;
using System.Drawing;
using TechTalk.SpecFlow;

namespace BehaviorDrivenTesting.SpecFlow.Hooks
{
    [Binding]
    public class BeforeTestRunHook
    {
        private static IWebDriver WebDriver => Core.WebDriver.Instance;

        [BeforeTestRun]
        public static void BeforeTestRun()
        {
            Au3LogFramework.StartAu3LogFramework();

            WebDriver.Manage().Window.Maximize();
        }
    }
}
