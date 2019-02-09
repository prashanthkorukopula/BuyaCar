/**
*  @Class Name: AccountTriggerTest  
*  @Description: This is a test class for AccountTrigger.
*  @CreatedDate: 14/08/2018
*
*  Change Log
*  -----------------------------------------------------------
*  Developer           Modification Date           Comments
*  -----------------------------------------------------------
*  K.Prashanth kumar   14/08/2018              Original Version
*
*/
@isTest
private class AccountTriggerTest {
    /**
     *  Method Name: setupTestData
     *  Description: create test data for testing SmartApprovalsBatch
     *  Param : NA
     *  Return: void
     */
    @testSetup
    private static void setupTestData() {
        
        //insert test users
        Profile profile = [SELECT Id from Profile WHERE Name = 'Sales Rep'];
        List<User> lstUsers = TestDataUtility.createUsers(2);
        lstUsers[0].ProfileId = profile.Id;
        lstUsers[1].ProfileId = profile.Id;
        insert lstUsers;
    }
    /**
     *  Method Name: testAccountTrigger
     *  Description: This method is to test Account trigger
     *  Param : NA
     *  Return: void
     */
	private static testMethod void testAccountTrigger() {
        Default_Account_Owner__c defaultOwner = new Default_Account_Owner__c();
        defaultOwner.Name = 'Account Owner';
        defaultOwner.Owner__c = String.valueOf([Select id from User limit 1].Id);
        insert defaultOwner;
	    //insert test Accounts
        List<Account> lstAccounts = TestDataUtility.createPersonAccounts(9);
        // get users
        Profile profile = [SELECT Id from Profile WHERE Name = 'Sales Rep'];
        List<User> users = new List<User>();
        users = [SELECT Id,Name,TimeZoneSidKey,ProfileId from User WHERE ProfileId =: profile.Id and Name = 'LastName_1'];
    
        if(!users.isEmpty()){
            System.runAs(users[0]){
                Test.startTest();       
                insert lstAccounts;
                Test.stopTest(); 
            }
        }        
                
	}

}