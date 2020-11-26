public class SyncAccountsUpdateCallout implements Queueable, Database.AllowsCallouts {
 
  private Map<Id, Account> accountsMap;
  private String ENDPOINT = 'callout:First_Org_Named_Creds/services/data/v50.0/composite/sobjects/';
  
  public SyncAccountsUpdateCallout(Map<Id, Account> accountsMap) {
    this.accountsMap = accountsMap;
  }

  public void execute(QueueableContext context) {
    Map<Id, Account> accountsMapForCallout = new Map<Id, Account>();
    Set<Id> accountsIdsForTriggerUpdate = new Set<Id>();

    for (Id id : this.accountsMap.keySet()) {
      if (!this.accountsMap.get(id).Is_Disabled_For_Trigger__c) {
        Account account = this.createAccount(this.accountsMap.get(id));
        account.Is_Disabled_For_Trigger__c = true;
        accountsMapForCallout.put(id, account);
      } else {
        accountsIdsForTriggerUpdate.add(id);
      }
    }

    if (accountsMapForCallout.size() > 0) {

      CompositeRequestUpdate compositeRequest = new CompositeRequestUpdate(accountsMapForCallout);
      String requestBody = JSON.serialize(compositeRequest);

      Http http = new Http();
      HttpRequest request = new HttpRequest();
      request.setHeader('Content-Type', 'application/json;charset=UTF-8');
      request.setMethod('PATCH');
      request.setEndpoint(ENDPOINT);
      request.setBody(requestBody);
      HttpResponse response = http.send(request);
    }

  }



  private List<Account> getAccountsById(Set<Id> ids) {
    return [SELECT Name,
            AccountNumber,
            Phone, 
            BillingStreet, 
            BillingCity, 
            BillingCountry, 
            BillingState, 
            BillingPostalCode, 
            BillingLatitude, 
            BillingLongitude, 
            ShippingStreet, 
            ShippingCity, 
            ShippingCountry, 
            ShippingState, 
            ShippingPostalCode, 
            ShippingLatitude, 
            ShippingLongitude, 
            External_Id__c,
            Is_Disabled_For_Trigger__c
            FROM Account WHERE Id IN :ids];
  }

  private Account createAccount(Account account) {
    return new Account(
      Id = account.External_Id__c,
      External_Id__c = account.Id,
      Is_Disabled_For_Trigger__c = account.Is_Disabled_For_Trigger__c,
      Name = account.Name,
      AccountNumber = account.AccountNumber,
      Phone = account.Phone,
      BillingStreet = account.BillingStreet,
      BillingCity = account.BillingCity,
      BillingCountry = account.BillingCountry,
      BillingState = account.BillingState,
      BillingPostalCode = account.BillingPostalCode,
      BillingLatitude = account.BillingLatitude,
      BillingLongitude = account.BillingLongitude,
      ShippingStreet = account.ShippingStreet,
      ShippingCity = account.ShippingCity,
      ShippingCountry = account.ShippingCountry,
      ShippingState = account.ShippingState,
      ShippingPostalCode = account.ShippingPostalCode,
      ShippingLatitude = account.ShippingLatitude,
      ShippingLongitude = account.ShippingLongitude
    );
  }
}