@isTest
public class CalloutControllerTest {
  @isTest
  static void testMissingConfigRequest() {
    String exceptionName = '';

    Test.startTest();
    CalloutController callout = new CalloutController();
    try {
      callout.initRequest(null, null);
    } catch (Exception ex) {
      exceptionName = ex.getTypeName();
    }
    Test.stopTest();

    System.assertEquals(
      'CalloutController.IntegrationConfigNotFoundException',
      exceptionName,
      'Exception is thrown for missing Integration Config.'
    );
  }

  @isTest
  static void testMissingServiceRequest() {
    String exceptionName = '';

    Test.startTest();
    CalloutController callout = new CalloutController();
    try {
      callout.initRequest('TEST_CONFIG', null);
    } catch (Exception ex) {
      exceptionName = ex.getTypeName();
    }
    Test.stopTest();

    System.assertEquals(
      'CalloutController.IntegrationServiceNotFoundException',
      exceptionName,
      'Exception is thrown for missing Integration Service.'
    );
  }

  @isTest
  static void testNoNamedCredentialRequest() {
    CalloutMock mock = new CalloutMock();
    mock.setMock(200, 'OK', 'TEST_SERVICE');
    CalloutController callout = new CalloutController();

    Test.startTest();
    callout.initRequest('TEST_CONFIG', 'TEST_SERVICE');
    callout.sendRequest();
    Test.stopTest();

    System.assertEquals('Test', callout.getResponse().getBody(), 'Recieved Expected Response');
  }

  @isTest
  static void testNamedCredentialRequest() {
    CalloutMock mock = new CalloutMock();
    mock.setMock(500, 'Internal Server Error', 'TEST_NAMED_CREDENTIAL_SERVICE');
    CalloutController callout = new CalloutController();

    Test.startTest();
    callout.initRequest('TEST_NAMED_CREDENTIAL_CONFIG', 'TEST_NAMED_CREDENTIAL_SERVICE');
    callout.sendRequest();
    Test.stopTest();

    System.assertEquals('Internal Server Error', callout.getResponse().getBody(), 'Recieved Expected Response');
  }

  @isTest
  static void testSetHeaders() {
    CalloutController callout = new CalloutController();
    Map<String, String> headers = new Map<String, String>();
    headers.put('test1', 'test1');
    headers.put('test2', 'test2');

    Test.startTest();
    callout.initRequest('TEST_CONFIG', 'TEST_SERVICE');
    callout.setHeaders(headers);
    Test.stopTest();

    System.assertEquals(headers, callout.getHeaders(headers.keySet()), 'Request headers set correctly');
  }

  @isTest
  static void testEndpoints() {
    CalloutController callout = new CalloutController();

    Test.startTest();
    callout.initRequest('TEST_CONFIG', 'TEST_SERVICE');
    callout.setUrlParams('?name=test');
    callout.setTimeout(70000);
    callout.setBody('{"Name": "John Doe"}');
    Test.stopTest();

    System.assertEquals(
      'https://www.salesforce.com/test?name=test',
      callout.getRequestEndpoint(),
      'Request endpoint set from Custom Metadata'
    );
  }
}
