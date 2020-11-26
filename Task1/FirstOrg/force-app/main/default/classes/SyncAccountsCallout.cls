public class SyncAccountsCallout implements Queueable, Database.AllowsCallouts {
  
  private List<Account> accountsForCallout;
  private List<Account> accountsForEnableTrigger;
  private String ENDPOINT = 'callout:First_Org_Named_Creds/services/data/v50.0/composite/sobjects/';
  
  public SyncAccountsCallout(List<Account> accountsList) {
    List<Id> accountsIdsForCallout = new List<Id>();
    List<Id> accountsIdsForEnableTrigger = new List<Id>();
    for (Account account : accountsList) {
      if (!account.Is_Disabled_For_Trigger__c) {
        accountsIdsForCallout.add(account.Id);
      } else {
        accountsIdsForEnableTrigger.add(account.Id);
      }
    }
    this.accountsForCallout = this.getAccountsById(accountsIdsForCallout);
    this.accountsForEnableTrigger = this.getAccountsById(accountsIdsForEnableTrigger);
  }

  public void execute(QueueableContext context) {

    if (this.accountsForCallout.size() > 0) {
      List<Account> newAccounts = new List<Account>();
      for (Account account : accountsForCallout) {
        Account newAccount = createAccount(account);
        newAccount.Is_Disabled_For_Trigger__c = true;
        newAccounts.add(newAccount);
      }

      CompositeRequest compositeRequest = new CompositeRequest(newAccounts);
      String requestBody = JSON.serialize(compositeRequest);

      Http http = new Http();
      HttpRequest request = new HttpRequest();
      request.setHeader('Content-Type', 'application/json;charset=UTF-8');
      request.setMethod('POST');
      request.setEndpoint(ENDPOINT);
      request.setBody(requestBody);
      HttpResponse response = http.send(request);
      
      CompositeResponse compResponse = new CompositeResponse(response.getBody());
      List<String> externalIds = compResponse.getIds();

      for(Account account : this.accountsForCallout) {
        account.External_Id__c = externalIds.get(this.accountsForCallout.indexOf(account));
      }
      update accountsForCallout;
    }

    if (this.accountsForEnableTrigger.size() > 0) {
      for (Account account : this.accountsForEnableTrigger) {
        account.Is_Disabled_For_Trigger__c = false;
      }
      update accountsForEnableTrigger;
    }
  }

  private List<Account> getAccountsById(List<Id> ids) {
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