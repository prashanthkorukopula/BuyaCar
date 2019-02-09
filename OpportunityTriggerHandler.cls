/**
*  @Class Name: OpportunityTriggerHandler  
*  @Description: This is a trigger handler for OpportunityTrigger.
*  @CreatedDate: 07/08/2018
*
*  Change Log
*  -----------------------------------------------------------
*  Developer           Modification Date           Comments
*  -----------------------------------------------------------
*  K.Prashanth kumar   07/08/2018              Original Version
*
*/
public class OpportunityTriggerHandler{
	/**
    * Method Name: updateOpportunity
    * Description : This method is to insert contracts if Opportunity stage is closed-won 
    * Param: Trigger.newMap,trigger.Oldmap
    * return : void
    */
	public static void updateOpportunity(Map<Id,Opportunity> mapOpportunityNew,Map<Id,Opportunity> mapOpportunityOld){
		// get the opportunity Id's for which stage is changed.
        Map<Id,Opportunity> mapOpportunities = new Map<Id,Opportunity>(); 
        for(Opportunity opportunity : mapOpportunityNew.values()){
            if(mapOpportunityOld.get(opportunity.Id).IsWon == false && mapOpportunityNew.get(opportunity.Id).IsWon == true){
                mapOpportunities.put(opportunity.Id,opportunity);
            }
        }
        // list of contracts to be inserted
		List<Contract> lstContracts = new List<Contract>();
		
        // list of Opp line Items for Trigger.NewMap Opportunities
		List<OpportunityLineItem> lstOppLineItems = new List<OpportunityLineItem>();
        if(!mapOpportunities.isEmpty())
		lstOppLineItems = [Select Id,Name,ServiceDate,Quantity,ListPrice,Age__c,Budget__c,Colours__c,Derivative__c,Door_Seats__c,Fuel__c,Registration_Number__c	,Transmission__c,Vehicle__c,Vehicle_Type__c,OpportunityId from OpportunityLineItem where OpportunityId IN:mapOpportunities.keySet()];
        
        // map of Opportunity and their Opportunity products.
        Map<Id,List<OpportunityLineItem>> mapLineItems = new Map<Id,List<OpportunityLineItem>>();
        for(OpportunityLineItem item : lstOppLineItems){
            if(mapLineItems.containsKey(item.OpportunityId)){
                mapLineItems.get(item.OpportunityId).add(item);
            }else{
                mapLineItems.put(item.OpportunityId,new List<OpportunityLineItem>{item});
            }
        }
        
        // access fields from Custom metadata type
        Opportunity_Mapping__mdt[] metadata = [Select From_Field__c,To_Field__c,SObjectName__c from Opportunity_Mapping__mdt];
        if(!mapOpportunities.isEmpty()){
            for(Opportunity opp : mapOpportunities.values()){
                // opportunity line items list for that opportunity
                List<OpportunityLineItem> lstLineItems = new List<OpportunityLineItem>();
                if(!mapLineItems.isEmpty())
                    lstLineItems = mapLineItems.get(opp.Id);

                if(!lstLineItems.isEmpty()){
                    for(OpportunityLineItem item : lstLineItems){
                        if(item.OpportunityId == opp.Id){
                            // new contract for each line item
                            Contract con = new Contract();                      
                            for(Opportunity_Mapping__mdt mdt : metadata){
                                // populate the fields from Opportunity
                                if(mdt.SObjectName__c == 'Opportunity'){
                                    con.put(mdt.To_Field__c,opp.get(mdt.From_Field__c));
                                }else if(mdt.SObjectName__c == 'OpportunityLineItem'){
                                    // populate the fields from Opportunity Products.
                                    con.put(mdt.To_Field__c,item.get(mdt.From_Field__c));
                                }
                                
                            }
                            //can't add to metadata type as field types are different(Integer,Decimal)  
                            con.ContractTerm = Integer.valueOf(item.Quantity);
                            
                            lstContracts.add(con);
                        }
                            
                    }
                }
                
            }
        }
    		
		//insert lstContracts
		try{
		    if(!lstContracts.isEmpty())
			    insert lstContracts;
		}catch(Exception e){
		    for(Contract con : lstContracts){
		        con.addError('There was a problem inserting the Contracts');
		    }
		}
	}
}