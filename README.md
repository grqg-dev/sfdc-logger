# Logger Class

## Hype
🎉💻 Attention all developers, coders, and Salesforce enthusiasts! Are you ready to take your logging game to the next level? Introducing the Logger Class - the EPIC solution you've been waiting for! 🌠🚀

💼🔑 Don't miss out on the opportunity to revolutionize your coding experience. The Logger Class will unlock the door to coding greatness! 🌟🔓

🤖🌈🛸🔥🧠 Dive into the future of logging with the Logger Class and watch your code come to life in ways you've never imagined! 🚀💫

## Overview
The Logger class is designed for use with the Log__c custom object in Salesforce. It provides methods to facilitate logging operations within Apex code, allowing developers to track and monitor various events and activities.

## Purpose
The primary purpose of the Logger class is to streamline the process of logging events and exceptions in Salesforce applications. 

By utilizing this class, developers can easily capture important information and store it as records in the Log__c object.

## Log__c Object Documentation
### Description
The Log__c custom object is used for logging various events and activities within a Salesforce application. It provides fields to store information such as duration, endpoint, exception details, log body, log name, response, result, and start time.


### Fields

- **Duration__c**
  - API Name: `Duration__c`
  - Data Type: Number(18, 0)
  - Description: Represents the duration of the logged event.

- **Endpoint__c**
  - API Name: `Endpoint__c`
  - Data Type: Text(255)
  - Description: Stores the endpoint or URL associated with the logged event.

- **Exception__c**
  - API Name: `Exception__c`
  - Data Type: Long Text Area(32768)
  - Description: Stores any exception details encountered during the logged event.

- **Finish_Time__c**
  - API Name: `Finish_Time__c`
  - Data Type: Date/Time
  - Description: Indicates the finish time of the logged event.

- **Log_Body__c**
  - API Name: `Log_Body__c`
  - Data Type: Long Text Area(131027)
  - Description: Contains the body or content associated with the logged event.

- **Log_Name__c**
  - API Name: `Log_Name__c`
  - Data Type: Text(255)
  - Description: Represents the name or title of the logged event.

- **Response__c**
  - API Name: `Response__c`
  - Data Type: Long Text Area(131027)
  - Description: Stores the response content associated with the logged event.

- **Result__c**
  - API Name: `Result__c`
  - Data Type: Text(255)
  - Description: Represents the result or outcome of the logged event.

- **Start_Time__c**
  - API Name: `Start_Time__c`
  - Data Type: Date/Time
  - Description: Indicates the start time of the logged event.


## Usage
To use the Logger class in your Salesforce Apex code, follow these guidelines:

1. **Start and Stop Timers**: Utilize the `start()` and `stop()` methods to capture specific timings if necessary. These methods are helpful for identifying long processing durations.

2. **Logging Methods**: Use the various `log()` methods to write logs to the database. These methods accept parameters such as log name, log body, exceptions, HTTP request, and response details. Ensure to provide relevant information based on the type of log you're creating.

3. **DML Control**: Be cautious when using the logging methods, as they perform DML operations. The `doDml` flag controls automatic inserts on logging. Set this flag to `false` if you want to handle log insertion manually.

## Notes
- Ensure to handle exceptions appropriately when using the logging methods, especially during HTTP callouts or other potentially error-prone operations.
- Take care when logging large data sets to avoid hitting Salesforce governor limits, particularly concerning heap size and DML statements.
- Customize the Logger class as needed to fit the specific logging requirements of your Salesforce application.

## Future Enhancements
The Logger class can be enhanced in various ways to improve functionality and usability. Some potential enhancements include:
- Implementing a log stash and flusher mechanism for more efficient log handling.
- Integrating with platform events to decouple log insertion from the main transaction and provide real-time event-driven logging.
- Developing a mature DML transaction framework to automate logging operations and ensure consistency across transactions.
- Adding additional fields to the Log__c object for enhanced monitoring and analysis, such as SOQL query usage metrics.


