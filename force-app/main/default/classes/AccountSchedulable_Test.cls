@isTest
public class AccountSchedulable_Test {
    
    @TestSetup 
    static void setup() {
        List<sObject> lstSObject = new List<sObject>();
        List<sObject> lstSObject2 = new List<sObject>();
        List<Account> lstAcc = new List<Account>();
        
        Account objAcc = TestSetup.getAccount('Test Account', '123.456.789/345-10');
        lstAcc.add(objAcc);
        
        Account objAcc2 = TestSetup.getAccount('Test Account 2', '123.456.789/345-10');
        lstAcc.add(objAcc2);
        insert lstAcc;  
        
        Task objTask = TestSetup.getTask('Test Task');
        objTask.WhatId = objAcc.Id;
        lstSObject.add(objTask) ;
        
        Task objTask2 = TestSetup.getTask('Test Task 2');
        objTask2.WhatId = objAcc2.Id;
        lstSObject2.add(objTask2);
        
        Opportunity objOpportunity = TestSetup.getOpportunity('Test Opportunity', 'Qualification', Date.today().addDays(100));
        objOpportunity.AccountId = objAcc.Id;
        lstSObject.add(objOpportunity);
        
        Opportunity objOpportunity2 = TestSetup.getOpportunity('Test Opportunity 2', 'Closed/Won', Date.today());
        objOpportunity2.AccountId = objAcc2.Id;
        lstSObject2.add(objOpportunity2);
        
        lstSObject.addAll(lstSObject2);
        insert lstSObject ;
        
        Datetime yesterday = Datetime.now().addDays(-130);
        Test.setCreatedDate(objTask2.Id, yesterday);
        Test.setCreatedDate(objOpportunity2.Id, yesterday);
        
        update lstSObject2;
    }
    
    @isTest
    static void testAccountBatch() {
        
        Test.startTest();
        	Database.executeBatch(new AccountBatch(), 200);
        Test.stopTest();
        
        List<Account> updatedAccounts = [SELECT Id, Inativa__c FROM Account WHERE Inativa__c = false];
        System.assertEquals(false, updatedAccounts[0].Inativa__c);
    }
    
}