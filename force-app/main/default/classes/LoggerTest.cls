public with sharing class LoggerTest {

    public LoggerTest() {
        Logger.log(LoggingLevel.DEBUG, 'Some simple debug message', new List<String> {'some data', 'more data'});
    }

    public void foo() {
        Logger.log(LoggingLevel.INFO, 'some message', new List<String> {'some data'});
    }

    public void bar() {

        List<LoginHistory> data = [SELECT Id, UserId, SourceIp, LoginUrl, LoginGeoId, Browser, CountryIso FROM LoginHistory LIMIT 10];
        Logger.log(LoggingLevel.INFO, 'login history', data);

        Logger.log(new DmlException('Exception'));

    }

    public static void fooStat() {
        LoggerTest test = new LoggerTest();
        test.bar();
    }
}

