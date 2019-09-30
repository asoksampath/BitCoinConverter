public with sharing class GetAccount 
{
    @AuraEnabled(cacheable=true)
    public static List<Account> fetchAccount( String searchString){
        String abc = '%' + searchString + '%';
        return [select id,Name from Account where Name like:abc LIMIT 5];   
    }
}
