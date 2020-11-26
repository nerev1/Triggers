public class CompositeRequest {
  private List<Map<String, Object>> records;
  private Boolean allOrNone;
  
  public CompositeRequest(List<Account> recordList) {
    this.allOrNone = false;
    this.records = new List<Map<String, Object>>();

    for (Account record : recordList) {
      Map<String, Object> newRecord = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(record));
      Map<String, String> attributes = new Map<String, String>{'type' => 'Account'};
      newRecord.put('attributes', attributes);
      this.records.add(new Map<String, Object>(newRecord));
    }
  }
}