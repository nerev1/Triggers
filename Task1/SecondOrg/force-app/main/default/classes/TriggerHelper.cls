public class TriggerHelper {

  public static void syncInsert(List<Account> accounts) {
    SyncAccountsCallout insertJob = new SyncAccountsCallout(accounts);
    ID jobID = System.enqueueJob(insertJob);
  }

  public static void syncUpdate(Map<Id, Account> accounts) {
    SyncAccountsUpdateCallout updateJob = new SyncAccountsUpdateCallout(accounts);
    ID jobID = System.enqueueJob(updateJob);

    for(Id id : accounts.keySet()) {
      accounts.get(id).Is_Disabled_For_Trigger__c = false;
    }
  }

  public static void syncDelete(List<Account> accounts) {
    SyncAccountsDeleteCallout deleteJob = new SyncAccountsDeleteCallout(accounts);
    ID jobID = System.enqueueJob(deleteJob);
  }
}