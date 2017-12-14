public with sharing class Logger {

    public static String getClassName(String line) {
        if (line.startsWith('Class.')) {
            line = line.substringAfter('Class.');
        }
        return line.substringBefore(':').substringBeforeLast('.');
    }

    public static String getMethod(String line) {
        return line.substringBefore(':').substringAfterLast('.');
    }

    public static String getStackTrace() {
        return new DmlException().getStackTraceString().split('\n').get(3);
    }
    public static void log(LoggingLevel level, String title, Object data) {
        log(level, title, Json.serialize(data)) ;
    }

    public static void log(LoggingLevel level, String title, List<Object> data) {
        log(level, title, Json.serialize(data)) ;
    }

    public static void log(LoggingLevel level, String title, String message) {
        String className = getClassName(getStackTrace());
        String method = getMethod(getStackTrace());
        Log__e log = new Log__e(level__c = level.name(), scope__c = (className +':' + method), title__c = title, message__c = message );
        Eventbus.publish(log);
    }

    public static void log(Exception e) {
        log(LoggingLevel.ERROR, e.getTypeName(), e.getStackTraceString().split('\n'));
    }


}
