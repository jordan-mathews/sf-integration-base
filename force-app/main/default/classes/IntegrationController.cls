public class IntegrationController {

  private HttpRequest request;
  private HttpResponse response;
  private String baseEndpoint;
  private String serviceEndpoint;
  private String requestMethod;


  public IntegrationController() {
    this.request = new HttpRequest();
  }

  public void initRequest(String integrationConfigName, String integrationServiceName){
    IntegrationConfiguration__mdt config = getIntegrationConfig(integrationConfigName);
    IntegrationService__mdt service = getIntegrationService(integrationConfigName, integrationServiceName);
    if(config != null){
      setBaseEndpoint(config.BaseEndpoint__c);
    }
    if(service != null){
      setServiceEndpoint(service.Path__c);
    }
  }

  public void sendRequest(){
    response = new Http().send(request);
  }

  private IntegrationConfiguration__mdt getIntegrationConfig(String configName){
    return [SELECT Id, DeveloperName, BaseEndpoint__c FROM IntegrationConfiguration__mdt WHERE DeveloperName = :configName LIMIT 1];
  }

  private IntegrationService__mdt getIntegrationService(String configName, String serviceName){
    return [SELECT Id, DeveloperName, Path__c,IntegrationConfiguration__c FROM IntegrationService__mdt WHERE DeveloperName = :serviceName AND IntegrationConfiguration__c = :configName LIMIT 1];
  }

  public HttpRequest getRequest(){
    return this.request;
  }

  public HttpResponse getResponse(){
    return this.response;
  }

  public String getBaseEndpoint(){
    return this.baseEndpoint;
  }

  public String getServiceEndpoint(){
    return this.serviceEndpoint;
  }

  public String getRequestMethod(){
    return this.requestMethod;
  }

  public void setRequest(HttpRequest request){
    this.request = request;
  }

  public void setBaseEndpoint(String baseEndpoint){
    this.baseEndpoint = baseEndpoint;
  }

  public void setServiceEndpoint(String serviceEndpoint){
    this.serviceEndpoint = serviceEndpoint;
  }

  public void setRequestMethod(String requestMethod){
    this.requestMethod = requestMethod;
  }

  public void setNamedCredential(){
    
  }

}
