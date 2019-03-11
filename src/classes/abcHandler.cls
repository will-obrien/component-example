public without sharing class AbcHandler implements Triggers.Handler {
    public void handle() {
    	try{
    		Set<Visit__c> setVisit = new Set<Visit__c>();
    		Map<Id, List<Decimal>> visSeq = new Map<Id, List<Decimal>>();
    		for (Visit__c newVis : (List<Visit__c>) Trigger.new) {
                Visit__c oldVis = (Visit__c) Trigger.oldMap.get(newVis.Id);
                if (oldVis.Sequence__c == newVis.Sequence__c && 
                	oldVis.Check_In_Date_Time__c == newVis.Check_In_Date_Time__c && 
                	oldVis.Check_Out_Date_Time__c == newVis.Check_Out_Date_Time__c) 
                	continue;
                visSeq.put(newVis.Id, new Decimal[]{
                        oldVis.Sequence__c, 
                        newVis.Sequence__c 
                });
            }
            List<Visit__c> allVisits = [SELECT Visit_List__c FROM Visit__c WHERE Id IN :visSeq.keySet()];
            for (Visit__c visItem: allVisits) {
            	setVisit.add(visItem);
            }
            for (Visit__c visList:setVisit) {
            	Long count=0; 
            	Long avg;
            	Long tem;
            	List<Visit__c> visLis=[select Check_In_Date_Time__c,
            	                                Check_Out_Date_Time__c
            	                                from Visit__c where 
            	                                Visit_List__c=:visList.Visit_List__c Order by Sequence__c ASC];
            	for (Integer i =0;i<visLis.size()-1;i++) {
            		if (visLis[i+1].Check_In_Date_Time__c != null && visLis[i].Check_Out_Date_Time__c != null) {
            			System.debug(LoggingLevel.INFO, '*** visLis[i+1].Check_In_Date_Time__c: ' +visLis[i+1].Check_In_Date_Time__c.getTime()); 
            			System.debug(LoggingLevel.INFO, '*** visLis[i].Check_Out_Date_Time__c: ' +visLis[i].Check_Out_Date_Time__c.getTime()); 
            		    Tem = visLis[i+1].Check_In_Date_Time__c.getTime() - visLis[i].Check_Out_Date_Time__c.getTime();
            		    System.debug(LoggingLevel.INFO, '*** temValue: ' +Tem);
            		    Tem += Tem;
            		    count +=1;
            		}
            	}
            	System.debug(LoggingLevel.INFO, '*** tem: ' +tem); 
            	System.debug(LoggingLevel.INFO, '*** count: ' +count); 
            	avg=(tem/count)/(3600*1000);
            	System.debug(LoggingLevel.INFO, '*** avg: ' +avg); 
            	List<Visit_List__c> addTime = [SELECT Driving_Time__c FROM Visit_List__c where Id=:visList.Visit_List__c];
            	for (Visit_List__c numTime:addTime) {
            		numTime.Driving_Time__c=avg;
            		update addTime;
            	}
            }

    	}catch(Exception e) {
            AbcLogger.log('abcTimeHandler', e, String.valueOf(Trigger.New));
        }
        
    }
}