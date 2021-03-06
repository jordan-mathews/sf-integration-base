public inherited sharing class CalloutController {
  private HttpRequest request;
  private HttpResponse response;
  private String requestEndpoint;
  private String requestMethod;
  private Integer timeout;

  public CalloutController() {
    this.request = new HttpRequest();
    this.timeout = 60000;
  }

  public void initRequest(String integrationConfigName, String integrationServiceName) {
    IntegrationConfiguration__mdt config = getIntegrationConfig(integrationConfigName);
    IntegrationService__mdt service = getIntegrationService(integrationConfigName, integrationServiceName);

    if (String.isNotBlank(config.NamedCredential__c)) {
      setNamedCredential(config.NamedCredential__c, service.Path__c);
    } else {
      setRequestEndpoint(config.BaseEndpoint__c, service.Path__c);
    }
    this.requestMethod = service.HttpMethod__c;
  }

  public void sendRequest() {
    this.request.setEndpoint(requestEndpoint);
    this.request.setMethod(requestMethod);
    this.response = new Http().send(request);
  }

  private IntegrationConfiguration__mdt getIntegrationConfig(String configName) {
    List<IntegrationConfiguration__mdt> config = [
      SELECT Id, DeveloperName, NamedCredential__c, BaseEndpoint__c
      FROM IntegrationConfiguration__mdt
      WHERE DeveloperName = :configName
      LIMIT 1
    ];
    if (config.isEmpty()) {
      throw new IntegrationConfigNotFoundException();
    }
    return config[0];
  }

  private IntegrationService__mdt getIntegrationService(String configName, String serviceName) {
    List<IntegrationService__mdt> service = [
      SELECT Id, DeveloperName, HttpMethod__c, Path__c, IntegrationConfiguration__c
      FROM IntegrationService__mdt
      WHERE DeveloperName = :serviceName
      LIMIT 1
    ];
    if (service.isEmpty()) {
      throw new IntegrationServiceNotFoundException();
    }
    return service[0];
  }

  public HttpResponse getResponse() {
    return this.response;
  }

  public String getRequestEndpoint() {
    return this.requestEndpoint;
  }

  public Map<String, String> getHeaders(Set<String> headerKeys) {
    Map<String, String> headers = new Map<String, String>();

    for (String key : headerKeys) {
      String value = this.request.getHeader(key);
      if (value != null) {
        headers.put(key, value);
      }
    }
    return headers;
  }

  public void setRequestEndpoint(String baseEndpoint, String serviceEndpoint) {
    this.requestEndpoint = baseEndpoint + serviceEndpoint;
  }

  public void setTimeout(Integer timeout) {
    this.timeout = timeout;
  }

  public void setBody(String body) {
    this.request.setBody(body);
  }

  public void setNamedCredential(String namedCredential, String serviceEndpoint) {
    this.requestEndpoint = ('callout:' + namedCredential + serviceEndpoint);
  }

  public void setUrlParams(String params) {
    this.requestEndpoint = requestEndpoint + params;
  }

  public void setHeaders(Map<String, String> headers) {
    for (String header : headers.keySet()) {
      this.request.setHeader(header, headers.get(header));
    }
  }

  public class IntegrationConfigNotFoundException extends Exception {
  }

  public class IntegrationServiceNotFoundException extends Exception {
  }
}
