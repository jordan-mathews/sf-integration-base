# sf-integration-Base

Lightweight package which aims decrease the development time of new integrations. 

## Installation

1. Install [npm](https://nodejs.org/en/download/)
1. Install [Salesforce DX CLI](https://developer.salesforce.com/tools/sfdxcli)
    - Alternative: `npm install sfdx-cli --global`
1. Clone this repository ([GitHub Desktop](https://desktop.github.com) is recommended for non-developers)
1. Run `npm install` from the project root folder
1. Install [SSDX](https://github.com/navikt/ssdx)
    - **Non-developers may stop after this step**
1. Install [VS Code](https://code.visualstudio.com) (recommended)
    - Install [Salesforce Extension Pack](https://marketplace.visualstudio.com/items?itemName=salesforce.salesforcedx-vscode)
    - **Install recommended plugins!** A notification should appear when opening VS Code. It will prompt you to install recommended plugins.
1. Install [AdoptOpenJDK](https://adoptopenjdk.net) (only version 8 or 11)
1. Open VS Code settings and search for `salesforcedx-vscode-apex`
1. Under `Java Home`, add the following:
    - macOS: `/Library/Java/JavaVirtualMachines/adoptopenjdk-[VERSION_NUMBER].jdk/Contents/Home`
    - Windows: `C:\\Program Files\\AdoptOpenJDK\\jdk-[VERSION_NUMBER]-hotspot`

## Build

To build the project locally follow these steps:

1. If you have not authenticated to a DevHub run `sfdx auth:web:login -d -a production` and the log in.
2. Create scratch org and push project source.

```
npm install
npm run mac:build
```


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
