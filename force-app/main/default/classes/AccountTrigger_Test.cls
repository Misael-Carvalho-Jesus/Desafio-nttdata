@isTest
public class AccountTrigger_Test {
    
    @TestSetup 
    static void setup() {        
        Id recordTypeConsumidorFinal = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('ConsumidorFinal').getRecordTypeId();
        
        Account acc = TestSetup.getAccount('Test Account', '123.456.789-10');
        
        Account acc2 = TestSetup.getAccount('Test Account 2', '123.456.789/345-10');
        acc2.RecordTypeId = recordTypeConsumidorFinal;
        
        List<Account> lstAcc = new List<Account>();
        lstAcc.add(acc);
        lstAcc.add(acc2);
        
        insert lstAcc;
    }
    
    
    @isTest
    static void testValidAccountNumber() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        acc.AccountNumber = '1';
        Test.startTest();
        try {
            update acc;
        } catch (Exception e) {
            System.assert(e.getMessage().contains('Número do cliente é inválido'));
        }
        Test.stopTest();
    }
    
    @isTest
    static void testOpportunityCreation() {
        Account acc = [SELECT Id, Name FROM Account LIMIT 1];
        acc.AccountNumber = '123.456.789.010-11';
        
        Test.startTest();
        update acc;
        Test.stopTest();
        
        List<Opportunity> oppList = [SELECT Id, Name, CloseDate, StageName, AccountId FROM Opportunity WHERE AccountId =: acc.Id];
        System.assertEquals(1, oppList.size(), 'Opportunity deve ser criada para o Parceiro.');
        System.assertEquals(acc.Name + ' - opp Parceiro', oppList[0].Name);
        System.assertEquals(System.today().addDays(30), oppList[0].CloseDate);
        System.assertEquals('Qualification', oppList[0].StageName);
    }
    
    @isTest
    static void testTaskCreation() {
        Account acc = [SELECT Id FROM Account WHERE RecordType.DeveloperName = 'ConsumidorFinal'];
        acc.Name = 'Test Name';
        Test.startTest();
        update acc;
        Test.stopTest();
        
        List<Task> taskList = [SELECT Id, Subject, WhatId, Status, Priority FROM Task WHERE WhatId =: acc.Id];
        System.assertEquals(1, taskList.size(), 'Task deve ser criada para o consumidor final.');
        System.assertEquals('Consumidor final', taskList[0].Subject);
        System.assertEquals('Not Started', taskList[0].Status);
        System.assertEquals('Normal', taskList[0].Priority);
    }
    
    @isTest
    static void testOpportunityCreationBulk() {
        List<Account> lstAcc = TestSetup.createBulkAccounts('Account Test', '123.456.789.010-11');
        
        Test.startTest();
        insert lstAcc;
        Test.stopTest();
        
        List<Task> taskList = [SELECT Id FROM Task];
        System.assertEquals(251, taskList.size());
    }
}