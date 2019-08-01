/******************************************************************************************
 *  Purpose : To create mock test         
 *  Name    : BitCoin_ControllerTest
 *  Author  : Asok Kumar Sampath
 *  Date    : 28 Apr 2018
 *  Version : 1.0 
 *  
 *  Modification History
 *  Date         Who         Description  
 *  28 Apr 2018  Asok       Initial version
 ***********************************************************************************************/ 
@isTest
public Class UtilityClassTest
{
    /* --------------------------------------------------------------------
    * Author:  Asok Kumar Sampath
    * Date:  28 Apr 2018
    * Purpose: To test the error log creation
    ----------------------------------------------------------------------- */ 
    static testMethod void testCreateErrorLog()
    {
		Error_Log__c err = UtilityClass.createErrorLog('Error_Log__c','createErrorLog','Error while testing');
		System.assertEquals('Error_Log__c',err.Object__c);        
    }
}