trigger AccountPDFGeneration on Account (after update) {
  AccountPDFTriggerHelper helper;

  if (Trigger.isUpdate) {
    helper = new AccountPDFTriggerHelper(Trigger.new);
    helper.generatePDF();
    helper.uncheckPDFFlag();
  }
}