# sf-integration-Base

Lightweight package which aims decrease the development time of new integrations. 

## Installation

Clone this repository and push to your desired environment.


## Configuration
The integration can be configured by creating new records on the following Custom Metadata Objects:
```IntegrationConfiguration__mdt```
```IntegrationService__mdt```

## Buiding HTTP Clients
Below is a simple example of how to use the CalloutController. Provide the API names of the Custom Metadata records when initializing the request.

### Example of using the Callout Controller in a HTTP Cient.

````
CalloutController callout = new CalloutController();
callout.initRequest('TEST_CONFIG', 'TEST_SERVICE');
callout.sendRequest();
````

## Testing HTTP Clients with CalloutMock

Salesforce does not allow HTTP Callouts in a Test Context. Therefor we need to use Mocks. 

In your ```IntegrationService__mdt``` it is possible provide a mock response that can be used in a test class. 

### Example of mock response data structure

````
{
"200": {
"body": <Add your expected response here>,
"headers": null

},
"500": {
"body": "Internal Server Error",
"headers": null
}

}
````

### Example of testing a HTTP Client
````
CalloutMock mock = new CalloutMock();
mock.setMock(200, 'OK', 'TEST_SERVICE');

CalloutController callout = new CalloutController();

Test.startTest();
callout.initRequest('TEST_CONFIG', 'TEST_SERVICE');
callout.sendRequest();
Test.stopTest();
````


## Limitations

- This tool currently only supports REST.
