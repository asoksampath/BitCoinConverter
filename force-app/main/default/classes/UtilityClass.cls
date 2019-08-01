/******************************************************************************************
 *  Purpose : Utility Class to use across applications            
 *  Name    : Utility Class
 *  Author  : Asok Kumar Sampath
 *  Date    : 28 Apr 2018
 *  Version : 1.0 
 *  
 *  Modification History
 *  Date         Who         Description  
 *  28 Apr 2018  Asok       Initial version
 ***********************************************************************************************/ 
public Class UtilityClass
{
    /* --------------------------------------------------------------------
    * Author:  Asok Kumar Sampath
    * Date:  29 Apr 2018
    * Param: String, String, String
    * Return:  Error_Log__c
    * Purpose: Method to insert the exceptions occuring during any transactions
    ----------------------------------------------------------------------- */ 
    public static Error_Log__c createErrorLog(String obj, String module, String trace)
    {
        Error_Log__c errLog = new Error_Log__c(); 
        errLog.Object__c = obj;
        errLog.Module__c = module;
        errLog.Trace__c = trace;
        return errLog;  
    }
}