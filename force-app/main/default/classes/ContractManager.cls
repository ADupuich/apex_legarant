@RestResource(urlMapping='/ContractManager/v1/*')
global with sharing class ContractManager {
    
    @HttpPost
    global static Id createNewContract(String Name, String Status, Id AccountId, Date StartDate, Integer ContractTerm) {
        
        Contract thisContract = new Contract(
            Name = Name,
            Status = Status,
            AccountId = AccountId,
            StartDate = StartDate,
            ContractTerm = ContractTerm);
        insert thisContract;
        
        return thisContract.Id;
    }
    
    @HttpPatch
    global static Id updateContract(String Name, String Status, Id AccountId, Date StartDate, Integer ContractTerm){
        
        RestRequest request = RestContext.request;
        String id = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        
        Contract result = [SELECT Id FROM Contract WHERE Id = :id];
        Contract thisContract = new Contract(); 
        thisContract.Id = id;  
        thisContract.Name = Name;
        thisContract.Status = Status;
        thisContract.AccountId = AccountId;
        thisContract.StartDate = StartDate;
        thisContract.ContractTerm = ContractTerm;

        update thisContract;

        return thisContract.Id;
    }
}