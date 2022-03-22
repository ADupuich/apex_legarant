@isTest
private class ContactManagerTest {
    @TestSetup
    static void createNewContact(){
        Id thisContactId = ContactManager.createNewContact('John', 'Doe', '+33123456789', 'jdoeadh@gmail.com');
    }

    @isTest 
    static void testCreateNewContact() {
        test.startTest();
        Contact thisContact = [SELECT Id, Email FROM Contact LIMIT 1];
        test.stopTest();

        System.assertEquals(thisContact.Email, 'jdoeadh@gmail.com');
    }
    
    @isTest static void testUpdateContact() {
        //Ameliorer le test en passant la requete en paramètre et pas les infos directement
        Id recordId = [SELECT Id FROM Contact LIMIT 1].Id;
        RestRequest request = new RestRequest();
        request.requestURI = 'https://my.salesforce.com/services/apexrest/ContactManager/v1/' + recordId;
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"Phone":"+0123456789"}');
        RestContext.request = request;
        
        Id thisContactId = ContactManager.updateContact('John', 'Doe','+0123456789' ,'jdoeadh@gmail.com');
       
        Contact thisContact = [SELECT Id, Phone FROM Contact WHERE Id=:thisContactId];

        System.assertEquals(thisContact.Phone, '+0123456789');    
    }
    
    @isTest static void testDeactivateContact() {
        
        // Set up a test request
        Id recordId = [SELECT Id FROM Contact LIMIT 1].Id;
        RestRequest request = new RestRequest();
        request.requestURI =  'https://my.salesforce.com/services/apexrest/ContactManager/v1/' + recordId;
        request.httpMethod = 'DELETE';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"Unactive__c" : "true"}');
        RestContext.request = request;
        
        // Call the method to test
        Id thisContactId = ContactManager.deactivateContact();
        
        Contact thisContact = [SELECT Id, Unactive__c FROM Contact WHERE Id =:thisContactId];
       
        System.assertEquals(thisContact.Unactive__c, true);
    }        
}