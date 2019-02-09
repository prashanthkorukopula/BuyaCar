/**
*  @Class Name: OpportunityTriggerTest  
*  @Description: This is a test class for OpportunityTrigger.
*  @CreatedDate: 07/08/2018
*
*  Change Log
*  -----------------------------------------------------------
*  Developer           Modification Date           Comments
*  -----------------------------------------------------------
*  K.Prashanth kumar   07/08/2018              Original Version
*
*/
@isTest
private class OpportunityTriggerTest {
    /**
     *  Method Name: testOpportunityTrigger
     *  Description: This method is to test Opportunity trigger
     *  Param : NA
     *  Return: void
     */
	private static testMethod void testOpportunityTrigger() {
	    List<Account> lstAccounts= new List<Account>();
	    for(Integer i=0; i<10;i++){
	        Account acc = new Account();
	        acc.Name = 'test_'+i;
	        lstAccounts.add(acc);
	    }
	   insert lstAccounts;
       List<Opportunity> lstOpportunity = new List<Opportunity>();
       for(Integer i=0; i<10; i++){
           Opportunity opp = new Opportunity();
           opp.Name = 'Test_'+i;
           opp.StageName = 'Order';
           opp.AccountId = lstAccounts[i].Id;
           opp.Cost__c = 77;
           opp.Finance_Margin__c = 78;
           opp.Goodwill__c = 79;
           opp.Invoice_Date__c = system.today();
           opp.Lend_Amount__c = 68;
           opp.Vehicle_Type__c = 'New';
           opp.CloseDate = system.today().addDays(10);
           opp.Special_Requirements__c = 'test';
           lstOpportunity.add(opp);
       }
       insert lstOpportunity;
       
       Id pricebookId = Test.getStandardPricebookId();

        //Create your product
        Product2 prod = new Product2(Name = 'Product X',ProductCode = 'Pro-X',isActive = true);
        insert prod;
        
        //Create your pricebook entry
        PricebookEntry pbEntry = new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = prod.Id,UnitPrice = 100.00,IsActive = true);
        insert pbEntry;
        
        //create your opportunity line item.
        List<OpportunityLineItem> lstOppLineItems = new List<OpportunityLineItem>();
        for(Integer i=0; i< 10 ; i++){
            OpportunityLineItem item = new OpportunityLineItem();
            item.OpportunityId = lstOpportunity[i].Id;
            item.Quantity = i+1;
            item.PricebookEntryId = pbEntry.Id;
            item.TotalPrice = i*pbEntry.UnitPrice;
            item.Vehicle__c = 'Car_'+i;
            item.Derivative__c = 'test_'+i;
            item.Age__c = String.valueOf(i);
            item.Transmission__c = 'test';
            item.Fuel__c = 'test';
            item.Colours__c = 'blue';
            item.Budget__c = i;
            item.Door_Seats__c = 'Door';
            lstOppLineItems.add(item);
        }
        insert lstOppLineItems;  
        
       Test.startTest();
       List<Opportunity> updateList = new List<Opportunity>();
       for(Integer i=0; i<2; i++){
            lstOpportunity[i].StageName = 'Car Delivered';
            lstOpportunity[i].Car_Delivered__c = true;
            lstOpportunity[i].Order_Complete__c = true;
            updateList.add(lstOpportunity[i]);
       }
        update updateList;   
       
       List<Contract> lstContracts = [Select Id,Name,ContractTerm from Contract where AccountId = :lstAccounts[0].Id];
       System.assertEquals(lstContracts.size(), 1);
       System.assertEquals(lstContracts[0].ContractTerm, 1);
       Test.stopTest();
	}

}