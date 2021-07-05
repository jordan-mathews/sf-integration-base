@isTest
global class CalloutMock implements HttpCalloutMock {

  protected Integer code;
  protected String status;
	protected String bodyAsString;
	protected Blob bodyAsBlob;
	protected Map<String, String> responseHeaders;

  public CalloutMock(Integer code, String status, 
  String serviceName, Map<String, String> responseHeaders) {
		this.code = code;
		this.status = status;
		this.bodyAsString = getCalloutServiceMock(serviceName);
		this.bodyAsBlob = null;
		this.responseHeaders = responseHeaders;
	}
    
  public HTTPResponse respond(HTTPRequest req){
         
    HttpResponse resp = new HttpResponse();
		resp.setStatusCode(code);
    resp.setStatus(status);
    
		if(bodyAsBlob != null) {
			resp.setBodyAsBlob(bodyAsBlob);     
		} else {
			resp.setBody(bodyAsString);
    }
    
		if(responseHeaders == null || responseHeaders.isEmpty()) {
      return resp;
    }
    for(String key :responseHeaders.keySet()) {
      resp.setHeader(key, responseHeaders.get(key));
    }
		return resp;
  }

  private String getCalloutServiceMock(String serviceName){
    IntegrationService__mdt service = [SELECT Id, DeveloperName, HttpMethod__c, Path__c, IntegrationConfiguration__c FROM IntegrationService__mdt WHERE DeveloperName = :serviceName LIMIT 1];
    if(service == null){
      throw new ServiceMockNotFoundException();
    }
    return service.MockResponse__c;
  }

  public class ServiceMockNotFoundException extends Exception{}
}