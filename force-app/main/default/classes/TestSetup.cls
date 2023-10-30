@isTest
public class TestSetup {
    
    public static Account getAccount(String name, String accountNumber){
        Id recordTypeParceiro = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Parceiro').getRecordTypeId();
        
        Account objAccount = new Account();
        objAccount.Name = name;
        objAccount.RecordTypeId = recordTypeParceiro;
        objAccount.AccountNumber = accountNumber;
        
        return objAccount;
    }
    
    public static List<Account> createBulkAccounts(String name, String accountNumber) {
        List<Account> accountList = new List<Account>();
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('ConsumidorFinal').getRecordTypeId();
        
        for (Integer i = 0; i < 250; i++) {
            Account newAccount = new Account();
            newAccount.Name = name + ' ' + i;
            newAccount.RecordTypeId = recordTypeId;
            newAccount.AccountNumber = accountNumber;
            
            accountList.add(newAccount);
        }
        
        return accountList;
    }
    
    
    public static Task getTask(String subject){
        Task objTask = new Task();
        objTask.Subject = subject;
        
        return objTask;
    }
    
    public static Opportunity getOpportunity(String name, String stageName, Date closedate){
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name = name;
        objOpportunity.StageName = stageName;
        objOpportunity.CloseDate = closedate; 
        
        return objOpportunity;
    }
}