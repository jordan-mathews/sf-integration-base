public without sharing class IntegrationController {

  private HttpRequest request;
  private HttpResponse response;
  private String requestEndpoint;
  private String baseEndpoint;
  private String requestMethod;
  private Integer timeout;


  public IntegrationController() {
    this.request = new HttpRequest();
    this.timeout = 60000;
  }

  public void initRequest(String integrationConfigName, String integrationServiceName){
    IntegrationConfiguration__mdt config = getIntegrationConfig(integrationConfigName);
    IntegrationService__mdt service = getIntegrationService(integrationConfigName, integrationServiceName);

    if(!String.isBlank(config.NamedCredential__c)){
      setNamedCredential(config.NamedCredential__c, service.Path__c);
    } else {
      setRequestEndpoint(config.BaseEndpoint__c, service.Path__c);
    }
    setRequestMethod(service.HttpMethod__c);
  }

  public void sendRequest(){
    this.request.setEndpoint(requestEndpoint);
    this.request.setMethod(requestMethod);
    this.response = new Http().send(request);
  }

  private IntegrationConfiguration__mdt getIntegrationConfig(String configName){
    return [SELECT Id, DeveloperName, NamedCredential__c, BaseEndpoint__c FROM IntegrationConfiguration__mdt WHERE DeveloperName = :configName LIMIT 1];
  }

  private IntegrationService__mdt getIntegrationService(String configName, String serviceName){
    return [SELECT Id, DeveloperName, HttpMethod__c, Path__c, IntegrationConfiguration__c FROM IntegrationService__mdt WHERE DeveloperName = :serviceName LIMIT 1];
  }

  public HttpRequest getRequest(){
    return this.request;
  }

  public HttpResponse getResponse(){
    return this.response;
  }

  public String getRequestEndpoint(){
    return this.requestEndpoint;
  }

  public String getBaseEndpoint(){
    return this.baseEndpoint;
  }

  public String getRequestMethod(){
    return this.requestMethod;
  }

  public String getResponseBody(){
    return this.response.getBody();
  }


  public void setRequest(HttpRequest request){
    this.request = request;
  }

  public void setRequestEndpoint(String baseEndpoint, String serviceEndpoint){
    this.requestEndpoint = baseEndpoint + serviceEndpoint;
  }

  public void setTimeout(Integer timeout){
    this.timeout = timeout;
  }


  public void setRequestMethod(String requestMethod){
    this.requestMethod = requestMethod;
  }

  public void setBody(String body){
    this.request.setBody(body);
  }

  public void setNamedCredential(String NamedCredential, String serviceEndpoint){
    this.requestEndpoint = ('callout:'+NamedCredential+serviceEndpoint);
  }

  public void setUrlParams(String params){
    this.requestEndpoint = requestEndpoint+params;
  }

  public void setHeaders(Map<String, String> headers){
    for(String header :headers.keySet()){
      this.request.setHeader(header, headers.get(header));
    }
  }

}
