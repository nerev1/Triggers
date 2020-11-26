@IsTest
public with sharing class TestCallouts {
    private static String TEST_ACCOUNT_NAME = 'Test Name';
    private static String TEST_EXTERNAL_ID = '0015g000002eTkyAAE';

    private static String ERROR_WRONG_EXTERNAL_ID = 'Actual external id does not equal to expectected.';
    private static String ERROR_EXPECTED_EMPTY_LIST = 'Actual accounts list size does not equal to exptected.';
    private static String ERROR_INVALID_NAME = 'Actual account name does not equal to exptected.';
    private static String ERROR_WRONG_TRIGGER_STATUS = 'Wrong account trigger disabled status.';

    @TestSetup
    public static void makeData(){
        Account account = new Account(Name = TEST_ACCOUNT_NAME);

        Test.setMock(HttpCalloutMock.class, new TestCalloutsMock()); 

        Test.startTest();
        insert account;
        Test.stopTest();
    }

    @IsTest
    public static void testInsert() {
        Account account = new Account(Name = TEST_ACCOUNT_NAME);

        Test.setMock(HttpCalloutMock.class, new TestCalloutsMock()); 

        Test.startTest();
        insert account;
        Test.stopTest();

        Account resultAccount = [SELECT Id, Name, External_Id__c, Is_Disabled_For_Trigger__c FROM Account WHERE Id = :account.Id];
        System.assertEquals(false, resultAccount.Is_Disabled_For_Trigger__c, ERROR_WRONG_TRIGGER_STATUS);
        System.assertEquals(TEST_EXTERNAL_ID, resultAccount.External_Id__c, ERROR_WRONG_EXTERNAL_ID);
    }

    @IsTest
    public static void testInsertWithoutCallout() {
        Account account = new Account(Name = TEST_ACCOUNT_NAME,
                                      Is_Disabled_For_Trigger__c = true);

        Test.setMock(HttpCalloutMock.class, new TestCalloutsMock()); 

        Test.startTest();
        insert account;
        Test.stopTest();

        Account resultAccount = [SELECT Id, Name, External_Id__c FROM Account WHERE Id = :account.Id];
        System.assertEquals(TEST_ACCOUNT_NAME, resultAccount.Name, ERROR_INVALID_NAME);
    }

    @IsTest
    public static void testUpdate() {
        Account account = [SELECT Id, Name FROM Account LIMIT 1];
        account.Name = TEST_ACCOUNT_NAME + '1';

        Test.setMock(HttpCalloutMock.class, new TestCalloutsMock()); 

        Test.startTest();
        upsert account;
        Test.stopTest();

        Account resultAccount = [SELECT Id, Name FROM Account WHERE Id = :account.Id];
        System.assertEquals(account.Name, resultAccount.Name, ERROR_INVALID_NAME);
    }

   @IsTest
    public static void testDelete() {
        Account account = [SELECT Id, Name FROM Account LIMIT 1];

        Test.setMock(HttpCalloutMock.class, new TestCalloutsMock()); 

        Test.startTest();
        delete account;
        Test.stopTest();

        List<Account> accounts = [SELECT Id, Name FROM Account];
        System.assertEquals(0, accounts.size(), ERROR_EXPECTED_EMPTY_LIST);
    }
}