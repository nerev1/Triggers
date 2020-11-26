public class SyncAccountsDeleteCallout implements Queueable, Database.AllowsCallouts {

  private List<Account> accountsForCallout;
  private String endpoint;

  public SyncAccountsDeleteCallout(List<Account> accountsList) {
    this.endpoint = 'callout:First_Org_Named_Creds/services/data/v50.0/composite/sobjects?ids=';

    List<Id> accountsIdsForCallout = new List<Id>();

    for (Account account : accountsList) {
      if (!account.Is_Disabled_For_Trigger__c) {
        accountsIdsForCallout.add(account.Id);
      }
    }
    this.accountsForCallout = this.getAccountsById(accountsIdsForCallout);
  }

  public void execute(QueueableContext context) {
    if (this.accountsForCallout.size() > 0) {
      for (Account account : this.accountsForCallout) {
        this.endpoint += account.External_Id__c + ',';
      }
      this.endpoint = this.endpoint.replaceAll(',$', '');
      this.endpoint += '&allOrNone=false';
      Http http = new Http();
      HttpRequest request = new HttpRequest();
      request.setHeader('Content-Type', 'application/json;charset=UTF-8');
      request.setMethod('DELETE');
      request.setEndpoint(endpoint);
      HttpResponse response = http.send(request);
    }
  }

  private List<Account> getAccountsById(List<Id> ids) {
    return [SELECT Name, Is_Disabled_For_Trigger__c, External_Id__c
            FROM Account WHERE Id IN :ids];
  }
}