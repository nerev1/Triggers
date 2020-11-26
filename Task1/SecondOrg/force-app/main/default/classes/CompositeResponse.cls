public class CompositeResponse {
  private List<String> ids;
  
  public CompositeResponse(String recordsJSON) {
    this.ids = new List<String>();
    List<Object> records = (List<Object>) JSON.deserializeUntyped(recordsJSON);
    for (Object record : records) {
      Map<String, Object> mapRes = (Map<String, Object>) record;
      this.ids.add(String.valueOf(mapRes.get('id')));
    }
  }

  public List<String> getIds() {
    return this.ids;
  }
}