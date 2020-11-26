public class CompositeRequestUpdate {
  private List<Map<String, Object>> records;
  private Boolean allOrNone;
  
  public CompositeRequestUpdate(Map<Id, Account> recordsMap) {
    this.allOrNone = false;
    this.records = new List<Map<String, Object>>();

    for (Id recordId : recordsMap.keySet()) {
      Map<String, Object> newRecord = 
        (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(recordsMap.get(recordId)));
      Map<String, String> attributes = new Map<String, String>{'type' => 'Account'};
      newRecord.put('attributes', attributes);
      this.records.add(new Map<String, Object>(newRecord));
    }
  }
}