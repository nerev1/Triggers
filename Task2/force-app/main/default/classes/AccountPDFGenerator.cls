public with sharing class AccountPDFGenerator implements Queueable, Database.AllowsCallouts {
  private List<Account> accounts;
  
  private static final String VISUALFORCE_EXCEPTION_MESSAGE = 'Visualforce exception occured.';

  public AccountPDFGenerator(List<Account> accounts) {
    this.accounts = accounts;
  }
  
  public void execute(QueueableContext context) {
    this.attachPDF();
  }

  private void attachPDF() {
    attachPDFToAccounts(this.accounts);
  }

  @AuraEnabled
  public static void attachPDFToAccountById(String accountId) {
    List<Account> accounts = [SELECT Name FROM Account WHERE Id = :accountId];
    AccountPDFGenerator.attachPDFToAccounts(accounts);
  }

  public static void attachPDFToAccounts(List<Account> accounts) {
    List<Attachment> attachments = new List<Attachment>();
    for (Account account : accounts) {
      PageReference accountDetails = Page.AccountDetails;
      accountDetails.getParameters().put('id', account.Id);
      Attachment attachment = new Attachment();
      Blob body;
      try {
        body = accountDetails.getContentAsPDF();
      } catch (VisualforceException error) {
        body = Blob.valueOf(VISUALFORCE_EXCEPTION_MESSAGE);
      }
      attachment.Body = body;
      attachment.Name = 'Account Details - ' + account.Name + '.pdf';
      attachment.ParentId = account.Id;
      attachment.IsPrivate = false;
      attachments.add(attachment);
    }
    insert attachments;
  }
}