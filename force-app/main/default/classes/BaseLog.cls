public with sharing class BaseLog {

    Object data;


    private void emit() {

    }

    private Log__e create(String title, Object Data) {
        return new Log__e();
    }

    class TraceStringHelper {

        String trace;

        public void createTrace() {
            this.trace = new DmlException().getStackTraceString();
        }

        public string getClassName() {
            return trace;
        }
    }
}
