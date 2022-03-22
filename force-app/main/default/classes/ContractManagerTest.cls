@isTest
private class ContractManagerTest {
    @isTest 
    static void testCreateNewContract() {
        
        Account account = new Account();
        account.Name ='TestAccount';
        insert account;
        
        Id thisContractId = ContractManager.createNewContract('TestContract','Draft',account.Id, Date.valueOf('2022-01-01'),12);

        Contract thisContract = [SELECT Id, ContractTerm FROM Contract WHERE Id =:thisContractId];

        System.assertEquals(thisContract.ContractTerm, 12);
    }
    
    @isTest 
    static void testUpdateContract(){

        Id recordId = createTestRecord();
        RestRequest request = new RestRequest();
        request.requestURI = 'https://my.salesforce.com/services/apexrest/ContractManager/v1/' + recordId;
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"Status":"Activated"}');
        RestContext.request = request;

        Contract ctc = [SELECT Name ,AccountId, StartDate, ContractTerm FROM Contract WHERE Id =: recordId];
        
        Id thisContractId = ContractManager.updateContract(ctc.Name, 'Activated', ctc.AccountId, ctc.StartDate , ctc.ContractTerm);
        
        Contract thisContract = [SELECT Id, Status FROM Contract WHERE Id=:thisContractId];

        System.assertEquals(thisContract.Status, 'Activated'); 
    }

    static Id CreateTestRecord(){
        Account accountTest = new Account();
        accountTest.Name ='TestAccount';
        insert accountTest;
        
        Contract contractTest = new Contract(
            Name = 'TestContract',
            Status = 'Draft',
            AccountId = accountTest.Id,
            StartDate = Date.valueOf('2022-01-01'),
            ContractTerm = 12
        );
        insert contractTest;
        return contractTest.Id;
    }
}