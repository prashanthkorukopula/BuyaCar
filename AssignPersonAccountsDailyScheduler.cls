/**
 *  @ClassName: AssignPersonAccountsDailyScheduler  
 *  @Description: This is a Scheduler class for AssignPersonAccountsBatch class.
 *  @Company: Standav
 *  @CreatedDate: 22/08/2018
 *
 *  Change Log
 *  -----------------------------------------------------------
 *  Developer           Modification Date           Comments
 *  -----------------------------------------------------------
 *  K.Prashanth Kumar     22/08/2018                Original Version
 *
 */
global with sharing class AssignPersonAccountsDailyScheduler implements Schedulable {
    /**
     *  Method Name: execute
     *  Description: execute method of AssignPersonAccountsBatch. execute schedulable context method to run batch class
     *  Param:  SchedulableContext SC 
     *  Return: void
     */ 
    global void execute(SchedulableContext sc) {        
        Database.executeBatch(new AssignPersonAccountsBatch());
    }
    /**
     *  Method Name: SchedulerMethod
     *  Description: scheduling the batch class to run every 15 minutes.
     *  Param:  NA
     *  Return: void
     */ 
    public static void SchedulerMethod() {
        // scheduling the class to run at every 15 min duration
        System.schedule('Scheduled Job 1', '0 0 9,10,11,12,13,14,15,16,17,18,19,20 ? * MON-FRI', new AssignPersonAccountsDailyScheduler());
		System.schedule('Scheduled Job 2', '0 15 9,10,11,12,13,14,15,16,17,18,19 ? * MON-FRI', new AssignPersonAccountsDailyScheduler());
		System.schedule('Scheduled Job 3', '0 30 9,10,11,12,13,14,15,16,17,18,19 ? * MON-FRI', new AssignPersonAccountsDailyScheduler());
		System.schedule('Scheduled Job 4', '0 45 9,10,11,12,13,14,15,16,17,18,19 ? * MON-FRI', new AssignPersonAccountsDailyScheduler());
    }
    
}