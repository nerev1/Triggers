trigger AccountTrigger on Account (after insert, before update, before delete) {

  if (Trigger.isInsert) {
    TriggerHelper.syncInsert(Trigger.new);
  }

  if (Trigger.isUpdate) {
    TriggerHelper.syncUpdate(Trigger.newMap);
  }

  if (Trigger.isDelete) {
    TriggerHelper.syncDelete(Trigger.old);
  }
}