@RestResource(urlMapping='/ContactManager/v1/*')
global with sharing class ContactManager {
    
    @HttpPost
    global static Id createNewContact(String FirstName, String LastName, String Phone, String Email) {
        //si on a le temps on tentera un upsert des familles ici
        List<Contact> contactList = [SELECT Id FROM Contact WHERE Email =: Email] ;
       
        Contact ctc = (contactList != null&&contactList.size()>0)?contactList[0]:null;
        if (ctc != null) {
            return ctc.Id;
        }
        
        else{
            Contact thisContact = new Contact(
                FirstName       = FirstName,
                LastName        = LastName,
                Phone           = Phone,
                Email           = Email);
            
            insert thisContact;

            return thisContact.Id;
        }
    }
    
    @HttpPut
    global static Id updateContact(String FirstName, String LastName, String Phone, String Email){
        
        RestRequest request = RestContext.request;
        String id = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        
        Contact result = [SELECT Id FROM Contact WHERE Id = :id];
        Contact thisContact = new Contact(); 
        thisContact.Id = id;  
        thisContact.FirstName = FirstName;
        thisContact.LastName = LastName ;
        thisContact.Phone = Phone ;
        thisContact.Email = Email;
        
        update thisContact;

        return thisContact.Id;
    }
    
    @HttpDelete
    global static Id deactivateContact(){
        
        RestRequest request = RestContext.request;
        String id = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        
        Contact result = [SELECT Unactive__c FROM Contact WHERE Id = :id];
        Contact thisContact = new Contact(); 
        thisContact.Id = id; 
        thisContact.Unactive__c = true;  
        
        update thisContact;
        
        return thisContact.Id;
    }
    
}