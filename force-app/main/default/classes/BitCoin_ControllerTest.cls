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
public Class BitCoin_ControllerTest
{
	/* --------------------------------------------------------------------
    * Author:  Asok Kumar Sampath
    * Date:  28 Apr 2018
    * Purpose: Test Method to fetch the data from static resource and test
    ----------------------------------------------------------------------- */ 
    @isTest static void testBitCoinConversion() 
    {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('Resource_BitCoin');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
		Test.setMock(HttpCalloutMock.class, mock);
        
        // Call the method that performs the callout
        List<BitCoin_Controller.BitCoinWrapperClass> wrapList = BitCoin_Controller.bitCoinConversion();
		BitCoin_Controller cont = new BitCoin_Controller();
        cont.getCurrList();
        System.assert(BitCoin_Controller.deserializeDataList.size() > 0);
        System.assert(BitCoin_Controller.deserializeDataList.size() != 0);
        
        BitCoin_Controller.BitCoinWrapperClass wrap =  new BitCoin_Controller.BitCoinWrapperClass('BTC','BitCoin','1');
    }   
    
    /* --------------------------------------------------------------------
    * Author:  Asok Kumar Sampath
    * Date:  28 Apr 2018
    * Purpose: Test Method to test the calculated other currency value against Bit coin
    ----------------------------------------------------------------------- */ 
    @isTest static void testCalculateOtherValue() 
    {
		StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('Resource_BitCoin');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
		Test.setMock(HttpCalloutMock.class, mock);
        
        // Call the method that performs the callout
        List<BitCoin_Controller.BitCoinWrapperClass> wrapList = BitCoin_Controller.bitCoinConversion();
        BitCoin_Controller cont = new BitCoin_Controller();
        cont.currencyCodeTwo = 'USD-US Dollar';
        cont.getCurrList();
        cont.calculateOtherValue();
        String otherValue = cont.mapOfCurrency.get('USD');
        System.assertEquals(Decimal.valueOf(otherValue),cont.inputAmtTwo);
        
        //To test if the record is inserted for reporting
        List<Bit_Coin_Comparison__c> compList = [select Id, Name, Other_Value__c from Bit_Coin_Comparison__c LIMIT 1];
        System.assertEquals(Decimal.valueOf(otherValue), compList[0].Other_Value__c);
    }
    
    /* --------------------------------------------------------------------
    * Author:  Asok Kumar Sampath
    * Date:  28 Apr 2018
    * Purpose: Test Method to test the calculated Bitcoin currency value against other currency
    ----------------------------------------------------------------------- */ 
    @isTest static void testCalculateBitCoinValue() 
    {
		StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('Resource_BitCoin');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
		Test.setMock(HttpCalloutMock.class, mock);
        
        // Call the method that performs the callout
        List<BitCoin_Controller.BitCoinWrapperClass> wrapList = BitCoin_Controller.bitCoinConversion();
        BitCoin_Controller cont = new BitCoin_Controller();
        cont.currencyCodeTwo = 'USD-US Dollar';
        cont.getCurrList();
        cont.calculateBitCoinValue();
        String otherValue = cont.mapOfCurrency.get('USD');
        System.assertEquals((cont.inputAmtOne / Decimal.valueOf(otherValue)),cont.inputAmtOne);
        
        //To test if the record is inserted for reporting
        List<Bit_Coin_Comparison__c> compList = [select Id, Name, Other_Value__c,Bit_Coin_Value__c from Bit_Coin_Comparison__c LIMIT 1];
        System.assertEquals((cont.inputAmtOne / Decimal.valueOf(otherValue)), compList[0].Bit_Coin_Value__c);
    }
    
}