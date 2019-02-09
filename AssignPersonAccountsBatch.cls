/**
*  @Class Name: AssignPersonAccountsBatch  
*  @Description: This is a Batch Class for assignining Person Accounts to Sales Reps.
*  @CreatedDate: 16/08/2018
*
*  Change Log
*  -----------------------------------------------------------
*  Developer           Modification Date           Comments
*  -----------------------------------------------------------
*  K.Prashanth kumar   16/08/2018              Original Version
*
*/
global class AssignPersonAccountsBatch implements Database.Batchable<sObject> {
    // get userId from custom setting
    Default_Account_Owner__c defaultOwner;
    /**
     *  Constructor Name: AssignPersonAccountsBatch
     *  Description: Constructor which gets the value of default owner
     *  Param: Na
     *  return : NA
     */
    public AssignPersonAccountsBatch(){
        defaultOwner = Default_Account_Owner__c.getValues('Account Owner');
    }
	 /**
     *  Method Name: start
     *  Description: Start method of AssignPersonAccountsBatch. The method returns the result of the query on Account.
     *  Param:  Database.BatchableContext BC 
     *  Return: Database.QueryLocator
     */
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator([SELECT Id,Status__c,OwnerId,CreatedDate FROM Account WHERE RecordType.Name = 'Person Account' AND Status__c = false AND OwnerId =:Id.valueOf(defaultOwner.Owner__c) ORDER BY CreatedDate ASC]);
	}
	/**
     *  Method Name: execute
     *  Description: Execute method of AssignPersonAccountsBatch. The method will assign the Accounts to Salesreps.
     *  Param:  Database.BatchableContext BC 
     *  Param:  List<Account> scope -> List of accounts that will be assigned to sales reps
     *  Return: void
     */
   	global void execute(Database.BatchableContext BC, List<Account> scope) {
        System.debug('--scope--'+scope);
   		if(scope != null && !scope.isEmpty()){
            List<Account> lstAccounts = new List<Account>();
            //assign online users to Accounts
   			lstAccounts = RoundRobinAssignment.assignAccounts(scope);
            //update the accounts after Assignment
            try{
               if(!lstAccounts.isEmpty())
                update lstAccounts; 
            }catch(Exception e){
                System.debug('Dml Exception:'+e);
            }
            
   		}

	}
	/**
     *  Method Name: finish
     *  Description: finish method of AssignPersonAccountsBatch. The method is not performing any action for this batch process
     *  Param:  Database.BatchableContext BC 
     *  Return: void
     */
	global void finish(Database.BatchableContext BC) {
		
	}
	
}