/**
*  @Class Name: AccountTriggerHandler  
*  @Description: This is a trigger handler for AccountTrigger.
*  @CreatedDate: 13/08/2018
*
*  Change Log
*  -----------------------------------------------------------
*  Developer           Modification Date           Comments
*  -----------------------------------------------------------
*  K.Prashanth kumar   13/08/2018              Original Version
*
*/
public class AccountTriggerHandler {
	/**
    * Method Name: afterInsertAccounts
    * Description : This method is to assign Accounts to Sales Reps who are in online in a Round Robin fashion.  
    * Param: Trigger.New
    * return : void
    */
    public static void beforeInsertAccounts(List<Account> triggerNewList){
        Time currentTime = Datetime.now().time();
        Time startTime = Time.newInstance(9, 0, 0, 0);
        Time endTime = Time.newInstance(20, 0, 0, 0);
        //Add only person accounts
        List<Account> lstAccounts = new List<Account>();
        for(Account acc : triggerNewList){
            if(acc.IsPersonAccount == true){
                lstAccounts.add(acc);
            }
        }
        //To make sure trigger is running between 9:15 am to 8 pm
        if(startTime <= currentTime && currentTime <= endTime){            
            RoundRobinAssignment.assignAccounts(lstAccounts);
        }else{
            // get userId from custom setting as default owner if ther are no online omni channel users.
            if(!lstAccounts.isEmpty()){
                Default_Account_Owner__c defaultOwner = new Default_Account_Owner__c();
                defaultOwner = Default_Account_Owner__c.getValues('Account Owner');
                for(Account acc : lstAccounts){
                    //assign default owner                    
                    acc.OwnerId = Id.valueOf(defaultOwner.Owner__c);
                    //final list to update
                } 
            }
                
        }
        	
    }

}