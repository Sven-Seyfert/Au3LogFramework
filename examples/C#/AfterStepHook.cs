using BehaviorDrivenTesting.Shared;
using BehaviorDrivenTesting.ThirdParty;
using System;
using TechTalk.SpecFlow;

namespace BehaviorDrivenTesting.SpecFlow.Hooks
{
    [Binding]
    public class AfterStepHook
    {
        private readonly ScenarioContext _scenarioContext;

        public AfterStepHook(ScenarioContext scenarioContext)
        {
            _scenarioContext = scenarioContext;
        }

        [AfterStep]
        public void AfterStep()
        {
            var testScenario = GlobalStore.TestScenario;
            var testScenarioStepType = _scenarioContext.StepContext.StepInfo.StepDefinitionType.ToString();
            var testScenarioStepDescription = _scenarioContext.StepContext.StepInfo.Text;

            if (_scenarioContext.TestError == null)
            {
                Au3LogFramework.WriteOkToReport(testScenario, testScenarioStepType, testScenarioStepDescription);
            }
            else
            {
                var errorMessage = _scenarioContext.TestError.Message;
                var stackTrace = _scenarioContext.TestError.StackTrace;
                var targetSite = _scenarioContext.TestError.TargetSite;
                var source = _scenarioContext.TestError.Source;
                var innerException = _scenarioContext.TestError.InnerException;
                var innerExceptionMessage = "-";

                if (innerException != null)
                {
                    innerExceptionMessage = innerException.Message;
                }

                var testScenarioAdditionalInfo =
                    $"Error message:{Environment.NewLine}{errorMessage}{Environment.NewLine}{Environment.NewLine}" +
                    $"Stack trace:{Environment.NewLine}{stackTrace}{Environment.NewLine}{Environment.NewLine}" +
                    $"Target site:{Environment.NewLine}{targetSite}{Environment.NewLine}{Environment.NewLine}" +
                    $"Source:{Environment.NewLine}{source}{Environment.NewLine}{Environment.NewLine}" +
                    $"Inner exception:{Environment.NewLine}{innerExceptionMessage}";

                Au3LogFramework.WriteErrorToReport(testScenario, testScenarioStepType, testScenarioStepDescription, testScenarioAdditionalInfo);
            }
        }
    }
}
