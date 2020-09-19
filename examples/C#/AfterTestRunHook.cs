using BehaviorDrivenTesting.ThirdParty;
using OpenQA.Selenium;
using TechTalk.SpecFlow;

namespace BehaviorDrivenTesting.SpecFlow.Hooks
{
    [Binding]
    public class AfterTestRunHook
    {
        private static IWebDriver WebDriver => Core.WebDriver.Instance;

        [AfterTestRun]
        public static void AfterTestRun()
        {
            WebDriver.Quit();

            Au3LogFramework.StopAu3LogFramework();
        }
    }
}
