public class AccountBatch implements Database.Batchable<sObject>{
    
    public Iterable<sObject> start(Database.BatchableContext BC) {
        /* String query = 'SELECT Id FROM Account ' +
            'WHERE Inativa__c = false ' +
            'AND (Id NOT IN (SELECT WhatId FROM Task WHERE CreatedDate = LAST_N_DAYS:90) ' +
            'AND Id NOT IN (SELECT AccountId FROM Opportunity WHERE IsClosed = true AND CloseDate = LAST_N_DAYS:120) ' +
            'AND Id NOT IN (SELECT AccountId FROM Opportunity WHERE StageName != \'Fechado\'))';*/

        Set<Id> taskIds = new Set<Id>();
        for(Task t : [SELECT WhatId FROM Task WHERE CreatedDate = LAST_N_DAYS:90]) {
            taskIds.add(t.WhatId);
        }
        
        List<Account> lstAcc = new List<Account>();
        for(Account acc : [SELECT Id FROM Account WHERE Inativa__c = false AND Id NOT IN (SELECT AccountId FROM Opportunity WHERE  StageName = 'Closed Won' AND CloseDate = LAST_N_DAYS:120) AND Id NOT IN (SELECT AccountId FROM Opportunity WHERE (StageName != 'Closed/Won' AND StageName != 'Closed/Lost' ))]) {
            if(!taskIds.contains(acc.Id)){
                lstAcc.add(acc);        
            }
        }
           
        return lstAcc;
    }
    
    public void execute(Database.BatchableContext BC, List<Account> scope) {
        for(Account acc : scope) {
            acc.Inativa__c = true;
        }
        update scope;
    }
    
    public void finish(Database.BatchableContext BC) {}
}