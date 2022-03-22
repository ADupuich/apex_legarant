@isTest
private class AccountManagerTest {
    @TestSetup
    static void CreateNewAccount(){
        ID thisAccountId = AccountManager.createNewAccount('TestAccountREST'); 
    }
    
    @isTest 
    static void testCreateNewAccount() {
        //Is job down correctly by createNewAccount Method ?
        test.startTest();
        Account thisAccount = [SELECT Name FROM Account LIMIT 1];
        test.stopTest();
        
        System.assertEquals(thisAccount.Name, 'TestAccountREST');
    }
    
    @isTest static void testUpdateAccount() {
        Account thisAccount = [SELECT Name FROM Account LIMIT 1];
        Id thisAccountId = thisAccount.Id;
        //Set up test request that will change the name of our account
        RestRequest request = new RestRequest();
        request.requestURI = 'https://my.salesforce.com/services/apexrest/AccountManager/v1/' + thisAccountId;
        request.httpMethod = 'PUT';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"Name":"TestAccountRESTupdt"}');
        RestContext.request = request;

        test.startTest();
        Id accountUpdatedId = AccountManager.updateAccount('TestAccountRESTupdt');
        test.stopTest();
        
        Account thisAccountUpdated = [SELECT Id,Name FROM Account WHERE Id=:accountUpdatedId];
        System.assertEquals(thisAccountUpdated.Name, 'TestAccountRESTupdt');
    }    
}
