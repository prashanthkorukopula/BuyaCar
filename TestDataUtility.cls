/**
*  @Class Name: TestDataUtility  
*  @Description: This is a Class for creating test data.
*  @CreatedDate: 19/08/2018
*
*  Change Log
*  -----------------------------------------------------------
*  Developer           Modification Date           Comments
*  -----------------------------------------------------------
*  K.Prashanth kumar   19/08/2018              Original Version
*
*/
public with sharing class TestDataUtility {
	// person accounts recordtype id
	public static Id RECORDTYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
	/**
     *  Method Name: createAccounts
     *  Description: This method is to insert Accounts
     *  Param : numberToInsert
     *  Return: List of Accounts
     */
	public static List<Account> createPersonAccounts(Integer numToInsert) {
        List<Account> acnts = new List<Account>();
        for (Integer i = 0; i < numToInsert; i++) {
            Account acnt = new Account(
                FirstName = 'test',
                LastName = 'Account_' + i,
                RecordTypeId = RECORDTYPE_ID,
                Phone = '999-999-' + (1000 + i),
                Industry = 'High Technology');
            acnts.add(acnt);
        }
        return acnts;
    }
    /**
     *  Method Name: createUsers
     *  Description: This method is to insert Users
     *  Param : numberToInsert
     *  Return: List of Users
     */
    public static List<User> createUsers(Integer numToInsert) {
        List<User> users = new List<User>();
        for (Integer i = 0; i < numToInsert; i++) {
            String orgId = UserInfo.getOrganizationId();
            String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
            Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
            String uniqueName = orgId + dateString + randomInt;
            User user = new User(
                LastName = 'LastName_' + i,
                Alias = uniqueName.substring(18, 23),
                Email = 'test_' + i + '@gmail.com',
                UserName =  uniqueName + '@test'+i+ orgId + '.org',
                CommunityNickname = orgId + '_'+Math.random(),
                Department = 'Some Department',
                EmailEncodingKey = 'ISO-8859-1',
                TimeZoneSidKey = 'Europe/London',
                LocaleSidKey = 'en_GB',
                LanguageLocaleKey = 'en_US',
                IsActive = true);
            users.add(user);
        }
        return users;
    }
}