@RestResource(urlMapping='/AccountManager/v1/*')

global with sharing class AccountManager {
    @HttpPost
    global static Id createNewAccount(String Name) {
        Account thisAccount = new Account(Name = Name);
        insert thisAccount;
        return thisAccount.Id;
    }    
    
    @HttpPut
    global static Id updateAccount(String Name){
        //Add Account Id as parameter in URL
        RestRequest request = RestContext.request;
        String id = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        
        //Retrieve the Account based on the Id
        Account result = [SELECT Id FROM Account WHERE Id = :id];
        Account thisAccount = new Account(); 
        thisAccount.Id = id;  
        thisAccount.Name = Name;
        
        update thisAccount;
        
        return thisAccount.Id;
    }
}