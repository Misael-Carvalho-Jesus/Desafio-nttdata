trigger AccountTrigger on Account (before insert, after insert, before update, after update) {    
    List<Opportunity> lstOpp = new List<Opportunity>();
    list<Task> lstTk = new List<Task>();
    List<SObject> listObjects = new List<SObject>();
    
    Id recordTypeParceiro = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Parceiro').getRecordTypeId();
    Id recordTypeConsumidorFinal = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('ConsumidorFinal').getRecordTypeId();
    
    if(Trigger.isBefore) {
        for(Account a: Trigger.new) {
            if(a.AccountNumber != null) {
                if(!Utils.ValidaCNPJ(a.AccountNumber) && !Utils.ValidaCPF(a.AccountNumber)) {
                    a.addError('Número do cliente é inválido');
                }
            }
        }
    }
    
    if(Trigger.isAfter) {
        for(Account a: Trigger.new) {
            if (a.RecordTypeId == recordTypeParceiro) {
                Opportunity opp = new Opportunity();
                opp.Name = a.Name + ' - opp Parceiro';
                opp.CloseDate = Date.today().addDays(30);
                opp.StageName = 'Qualification';
                opp.AccountId = a.id;
                lstOpp.add(opp);
            } else if (a.RecordTypeId == recordTypeConsumidorFinal) {
                Task tk = new Task();
                tk.Subject = 'Consumidor final';
                tk.WhatId  = a.Id;
                tk.Status = 'Not Started';
                tk.Priority = 'Normal';
                lstTk.add(tk);
            }
        } 
    }
    
    if(!lstOpp.isEmpty())
        listObjects.addAll(lstOpp);
    
    if(!lstTk.isEmpty())
        listObjects.addAll(lstTk);
    
    if(!listObjects.isEmpty())
        insert listObjects;
}