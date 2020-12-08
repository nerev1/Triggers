public class AccountPDFTriggerHelper {
  public List<Account> accounts;
  public List<Id> accountIds;

  public AccountPDFTriggerHelper(List<Account> accounts) {
    this.accountIds = new List<Id>();
    for (Account account : accounts) {
      if (account.Create_PDF__c) {
        this.accountIds.add(account.Id);
      }
    }
    this.accounts = [SELECT Name, Create_PDF__c FROM Account WHERE Id IN :this.accountIds];
  }
  
  public void generatePDF() {
    if (this.accounts.size() == 0) return;
    AccountPDFGenerator generatePDFJob = new AccountPDFGenerator(this.accounts);
    Id jobId = System.enqueueJob(generatePDFJob);
  }

  public void uncheckPDFFlag() {
    if (this.accounts.size() == 0) return;
    for (Account account : this.accounts) {
      account.Create_PDF__C = false;
    }
    update this.accounts;
  }
}