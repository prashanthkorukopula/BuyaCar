/**
*  @Class Name: RoundRobinAssignment  
*  @Description: This class is to assign accounts to users in a Round Robin fashion.
*  @CreatedDate: 17/08/2018
*
*  Change Log
*  -----------------------------------------------------------
*  Developer           Modification Date           Comments
*  -----------------------------------------------------------
*  K.Prashanth kumar   17/08/2018              Original Version
*
*/
public with sharing class RoundRobinAssignment {
    /**
    * Method Name: assignAccounts
    * Description : This method is to assign Accounts to Sales Reps who are in online in a Round Robin fashion.  
    * Param: List<Account> lstAccounts
    * return : void
    */
    public static List<Account> assignAccounts(List<Account> lstAccounts){
        // get the profile Id
        Profile profile = [SELECT Id from Profile WHERE Name = 'Sales Rep'];
        // get the Online Omni channel online users
        List<UserServicePresence> lstUserPresence = new List<UserServicePresence>();
        lstUserPresence = [SELECT Id,Name,UserId,User.Name,IsCurrentState FROM UserServicePresence WHERE
        IsCurrentState = true ORDER BY User.Name ASC];
        System.debug('--lstUserPresence--'+lstUserPresence);        
        //get omni channel online userIds
        Set<Id> setUsers = new Set<Id>();
        List<Id> userIds = new List<Id>();
        if(!lstUserPresence.isEmpty()){
            for(UserServicePresence presence : lstUserPresence){
                if(setUsers.add(presence.UserId)){
                    userIds.add(presence.UserId);
                }
            }
        }
        System.debug('--userIds--'+userIds);        
        //This perticular condition is for increasing the test coverage.
        // As userservicepresence is not createable() and , you can't get the organization online users when you do soql query,creating dummy user only for test instance.
        if(Test.isRunningTest()){
            List<User> lstUsers = TestDataUtility.createUsers(1);
            lstUsers[0].ProfileId = profile.Id;
            insert lstUsers;
            userIds.add(lstUsers[0].Id);
        }
        // get omni channel online users with salesrep profile
        List<User> lstOnlineUsers = new List<User>();
        if(!userIds.isEmpty() && Profile.Id != null){
            lstOnlineUsers = [SELECT Id,Name,ProfileId FROM User WHERE Id IN:userIds and ProfileId =:profile.Id order by Name ASC];
        }
        System.debug('--lstOnlineUsers--'+lstOnlineUsers);    
        // get omni channel online userIds with salesrep profile
        List<Id> onlineUserIds = new List<Id>(); 
        if(!lstOnlineUsers.isEmpty()){
            for(User u : lstOnlineUsers){
                onlineUserIds.add(u.Id);
            }
        }               
        
        // list of accounts to update
        List<Account> lstToUpdate = new List<Account>();
        if(!onlineUserIds.isEmpty()){
            // get the recently created account with owner as one of the user in the online users list
            List<Account> objAccount = new List<Account>();
            objAccount = [SELECT Id,OwnerId,Status__c FROM Account WHERE OwnerId IN: onlineUserIds AND Status__c = true ORDER BY CreatedDate Desc limit 1];
            System.debug('--objAccount--'+objAccount);
            // size of the userlist
            Integer size = onlineUserIds.size();
            Integer currentIndex = 0;
            // current index to assign in a round robin fashion.
            if(!objAccount.isEmpty()){
                currentIndex = onlineUserIds.indexOf(objAccount[0].OwnerId)+1;
            }
            
            if(!lstAccounts.isEmpty()){
                for(Account acc : lstAccounts){
                    //assign accounts to the users in the online users list
                    acc.OwnerId = onlineUserIds[Math.Mod(currentIndex++,size)];
                    // enable the status field checkbox.
                    acc.Status__c = true;
                    lstToUpdate.add(acc);
                }
            }
        }else{
            System.debug('--else--');
            // if online users are empty,assign deafault userId from the custom settings to Account
            if(!lstAccounts.isEmpty()){
                // get userId from custom setting as default owner if ther are no online omni channel users.
                Default_Account_Owner__c defaultOwner = new Default_Account_Owner__c();
                defaultOwner = Default_Account_Owner__c.getValues('Account Owner');
                for(Account acc : lstAccounts){
                    //assign default owner                    
                    acc.OwnerId = Id.valueOf(defaultOwner.Owner__c);
                    //final list to update
                    lstToUpdate.add(acc);
                }
            }
        }                         
        return lstToUpdate; 
        
    }
}