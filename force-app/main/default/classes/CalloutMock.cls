@isTest
global class CalloutMock implements HttpCalloutMock {
  protected Integer code;
  protected String status;
  protected String bodyAsString;
  protected Blob bodyAsBlob;
  protected Map<String, String> responseHeaders;

  public CalloutMock() {
    this.code = null;
    this.status = null;
    this.bodyAsString = null;
    this.bodyAsBlob = null;
    this.responseHeaders = new Map<String, String>();
  }

  public HTTPResponse respond(HTTPRequest req) {
    HttpResponse resp = new HttpResponse();
    resp.setStatusCode(code);
    resp.setStatus(status);

    if (bodyAsBlob != null) {
      resp.setBodyAsBlob(bodyAsBlob);
    } else {
      resp.setBody(bodyAsString);
    }

    if (responseHeaders == null || responseHeaders.isEmpty()) {
      return resp;
    }
    for (String key : responseHeaders.keySet()) {
      resp.setHeader(key, responseHeaders.get(key));
    }
    return resp;
  }

  public void setMock(Integer code, String status, String serviceName) {
    Map<String, Object> mock = (Map<String, Object>) JSON.deserializeUntyped(getMock(serviceName));
    Map<String, Object> mockResponse = (Map<String, Object>) mock.get(String.valueOf(code));

    this.code = code;
    this.status = status;
    this.bodyAsString = String.valueOf(mockResponse.get('body'));

    Test.setMock(HttpCalloutMock.class, this);
  }

  private String getMock(String serviceName) {
    List<IntegrationService__mdt> service = [
      SELECT Id, DeveloperName, HttpMethod__c, Path__c, IntegrationConfiguration__c, MockResponse__c
      FROM IntegrationService__mdt
      WHERE DeveloperName = :serviceName
      LIMIT 1
    ];
    if (service.isEmpty()) {
      throw new MockNotFoundException();
    }
    return service[0].MockResponse__c;
  }

  public class MockNotFoundException extends Exception {
  }
}
