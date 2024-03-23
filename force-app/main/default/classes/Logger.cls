/** @format */

/**
 * This class is for use with the Log__c object
 *
 * Usage:
 *
 * Use `start` and `stop` to capture specific timings if necessary
 * (helpful for identifying long processing)
 *
 * Use the various `log()` methods to write to the database
 *
 * N.B. these methods do DML. take care when using http callouts and other things.
 * use the `doDML` flag to control automatic inserts on logging.
 * When you use this, you are responsible for inserting the logs in the db.
 *
 *
 * Future enhancements / inspo :
 * Log stash and flusher
 * Use platform events to decouple the log insert from the main transaction
 * A mature dml transaction framework can also tie into this and implement automatic logging
 *
 *
 */

public class Logger {
    public static Boolean doDml = true;
    static Long startTime;
    static Long finishTime;
    static DateTime startDT;
    static DateTime finishDT;
    static String endpoint;
    static String result;

    static String formatException(Exception e) {
        return e.getTypeName() +
            ': ' +
            e.getMessage() +
            ' @ ' +
            e.getStackTraceString();
    }

    public static void start() {
        startDT = DateTime.now();
        startTime = startDT.getTime();
    }

    public static void stop() {
        finish();
    }

    public static void finish() {
        finishDT = DateTime.now();
        finishTime = finishDT.getTime();
    }

    public static Long getDuration() {
        if (startTime != null && finishTime == null) {
            finish();
        }
        if (startTime != null && finishTime != null) {
            return finishTime - startTime;
        } else {
            return null;
        }
    }

    public static Log__c log(String logName, String body) {
        return log(logName, body, '');
    }

    public static Log__c log(String logName, Exception e) {
        return log(logName, null, e);
    }

    public static Log__c log(String logName, String body, Exception e) {
        return log(logName, body, formatException(e));
    }

    public static Log__c log(String logName, String body, String ex) {
        return log(logName, body, null, ex);
    }

    public static Log__c log(
        String logName,
        HttpRequest myRequest,
        HttpResponse myResponse
    ) {
        endpoint = myRequest.getEndpoint();
        result = myResponse.getStatusCode() + myResponse.getStatus();
        return log(logName, myRequest.getBody(), myResponse.getBody(), '');
    }

    public static Log__c log(
        String logName,
        String logBody,
        String response,
        String myException
    ) {
        Log__c logToInsert = buildLogEvent(
            logName,
            logBody,
            response,
            myException
        );
        if (doDml) {
            Database.SaveResult result = Database.insert(logToInsert, false);

            if (result.isSuccess()) {
                // Successful insertion
            } else {
                // Failed insertion
                for (Database.Error error : result.getErrors()) {
                    // Handle each error
                    System.debug('Error message: ' + error.getMessage());
                }
            }
        }
        return logToInsert;
    }

    static Log__c buildLogEvent(
        String logName,
        String logBody,
        String response,
        String myException
    ) {
        //truncate values (this rarely is a problem)
        if (endpoint != null && endpoint.length() > 255)
            endpoint = endpoint.left(255);
        if (logBody != null && logBody.length() > 131027)
            logBody = logBody.left(131027);
        if (response != null && response.length() > 131027)
            response = response.left(131027);

        Log__c myLog = new Log__c(
            Duration__c = getDuration(),
            Endpoint__c = endpoint,
            Exception__c = myException,
            Finish_Time__c = finishDT,
            Log_Body__c = logBody,
            Log_Name__c = logName,
            Response__c = response,
            Result__c = result,
            Start_Time__c = startDT
            /*
            inspiration for other fields to help with monitoring
            must be thoughtful in implementing this!

            LimitsSoqlQueriesUsed__c = Limits.getQueries(),
            LimitsSoqlQueryLocatorRowsUsed__c = Limits.getQueryLocatorRows(),
            LimitsSoqlQueryRowsUsed__c = Limits.getQueryRows(),
            */
        );

        return myLog;
    }

    public static void setResult(String s) {
        result = s;
    }

    public static void setEndpoint(String s) {
        endpoint = s;
    }
}
