/**
*  @Class Name: AssignPersonAccountsBatchTest  
*  @Description: This is a test class for AssignPersonAccountsBatch.
*  @CreatedDate: 17/08/2018
*
*  Change Log
*  -----------------------------------------------------------
*  Developer           Modification Date           Comments
*  -----------------------------------------------------------
*  K.Prashanth kumar   17/08/2018              Original Version
*
*/
@isTest
private class AssignPersonAccountsBatchTest{
	/**
     *  Method Name: testAssignPersonAccountsBatch
     *  Description: This method is to test AssignPersonAccountsBatch class
     *  Param : NA
     *  Return: void
     */
	@isTest
	static void testAssignPersonAccountsBatch(){
        Default_Account_Owner__c defaultOwner = new Default_Account_Owner__c();
        defaultOwner.Name = 'Account Owner';
        defaultOwner.Owner__c = String.valueOf([Select id from User limit 1].Id);
        insert defaultOwner;
		//insert test Accounts
	    List<Account> lstAccounts = TestDataUtility.createPersonAccounts(9);
	    insert lstAccounts;
	    //insert test users
        Profile profile = [SELECT Id from Profile WHERE Name = 'Sales Rep'];
        List<User> lstUsers = TestDataUtility.createUsers(2);
        lstUsers[0].ProfileId = profile.Id;
        lstUsers[1].ProfileId = profile.Id;
        insert lstUsers;

        Test.startTest();
        //call the batch class   
        // Calling the scheduled class
        AssignPersonAccountsDailyScheduler scheduleClass = new AssignPersonAccountsDailyScheduler();
        String sch = '0 0 23 * * ?';
        system.schedule('Test Territory Check', sch, scheduleClass);    
        Test.stopTest();
	}
}