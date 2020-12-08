public class AccountPDFGenerator implements Queueable, Database.AllowsCallouts {
  private List<Account> accounts;
  
  private final String VISUALFORCE_EXCEPTION_MESSAGE = 'Visualforce exception occured.';

  public AccountPDFGenerator(List<Account> accounts) {
    this.accounts = accounts;
  }

  public void execute(QueueableContext context) {
    this.attachPDF();
  }

  private void attachPDF() {
    List<Attachment> attachments = new List<Attachment>();
    for (Account account : this.accounts) {
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