/** @format */
@isTest
public class Logger_Test {
    static String x125_chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

    @isTest
    static void it_should_write_to_the_db() {
        // Test successful log insertion
        Log__c insertedLog = Logger.log('Test Log', 'Test Body');
        Logger.stop(); //run for coverage
        insertedLog = [
            SELECT Log_Name__c, Log_Body__c
            FROM Log__c
            WHERE Id = :insertedLog.Id
        ];
        System.assertEquals(
            'Test Log',
            insertedLog.Log_Name__c,
            'it should write the field properly'
        );
        System.assertEquals(
            'Test Body',
            insertedLog.Log_Body__c,
            'it should write the field properly'
        );
    }

    @isTest
    static void test_http_logging() {
        //make some large absurd string
        List<String> myStrings = new List<String>();
        for (Integer i = 0; i < 1500; i++) {
            myStrings.add(x125_chars);
        }

        String myBigString = String.join(myStrings, '');

        // Simulate HTTP request and response
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://example.com/api');
        request.setBody(myBigString);
        request.setMethod('GET');
        HttpResponse response = new HttpResponse();
        response.setStatusCode(200);
        response.setBody(myBigString);

        // Test log insertion with request and response

        Log__c httpLog = Logger.log('HTTP Log', request, response);

        httpLog = [
            SELECT Log_Name__c, Log_Body__c, Endpoint__c, Response__c
            FROM Log__c
            WHERE Id = :httpLog.Id
        ];

        System.assertEquals('HTTP Log', httpLog.Log_Name__c);
        System.assertEquals(
            request.getEndpoint(),
            httpLog.Endpoint__c,
            'it should log the endpoint from the response'
        );
    }

    @isTest
    static void testLogWithoutDml() {
        // Set doDml to false
        Logger.doDml = false;

        // Test log method without DML
        Log__c logWithoutDml = Logger.log('No DML Log', 'Test Body');
        System.assertEquals(
            null,
            logWithoutDml.Id,
            'it should not have an id because we disabled dml'
        );
    }

    @isTest
    static void exercise_exception_handling() {
        //run these methods just for coverage
        Logger.start();
        Logger.setResult('test');
        Logger.setEndpoint('s');
        // Test log insertion with exception
        try {
            Integer i = 1 / 0; // Division by zero to generate an exception
        } catch (Exception e) {
            Log__c exceptionLog = Logger.log('Exception Log', e);
            exceptionLog = [
                SELECT Log_Name__c, Exception__c
                FROM Log__c
                WHERE Id = :exceptionLog.Id
            ];

            System.assertEquals('Exception Log', exceptionLog.Log_Name__c);
            System.assertNotEquals(null, exceptionLog.Exception__c);
        }
    }

    @isTest
    static void it_should_truncate_the_endpoint() {
        String x375_chars = x125_chars + x125_chars + x125_chars;

        Logger.setEndpoint(x375_chars);
        Log__c myLog = Logger.log('Test', 'Test');

        myLog = [SELECT Endpoint__c FROM Log__c WHERE Id = :myLog.Id];

        system.assertEquals(
            x375_chars.left(255),
            myLog.Endpoint__c,
            'it should truncate the endpoint field to 255 chars due to field limits'
        );
    }
}
