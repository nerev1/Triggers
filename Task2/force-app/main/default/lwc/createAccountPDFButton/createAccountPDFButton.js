import { LightningElement, track, api } from 'lwc';
import attachPDFToAccount from '@salesforce/apex/AccountPDFGenerator.attachPDFToAccountById';

export default class CreateAccountPDFButton extends LightningElement {
  @api accountId;
  @track message;
  SUCCESS_MESSAGE = 'PDF file created successfully';
  PROCESSING_MESSAGE = 'Processing...';

  connectedCallback() {
    this.attachPDF();
  }

  attachPDF() {
    this.message = this.PROCESSING_MESSAGE;
    attachPDFToAccount({
      accountId: this.accountId
    })
      .then(() => {
        this.message = this.SUCCESS_MESSAGE;
      })
      .catch((error) => {
        this.message = error.body.message;
      });
  }
}