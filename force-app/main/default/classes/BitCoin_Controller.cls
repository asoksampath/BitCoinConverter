/******************************************************************************************
 *  Purpose : To fetch rates from API and calculate equivalent currency            
 *  Name    : BitCoin_Controller
 *  Author  : Asok Kumar Sampath
 *  Date    : 26 Apr 2018
 *  Version : 1.0 
 *  
 *  Modification History
 *  Date         Who         Description  
 *  26 Apr 2018  Asok       Initial version
 ***********************************************************************************************/ 
public class BitCoin_Controller
{
    
    // this list to collect the deserialized response
    public static List < BitCoinWrapperClass > deserializeDataList;
    
    public Decimal inputAmtOne{get;set;}
    
    public Decimal inputAmtTwo{get;set;}
    
    public String currencyCodeOne{get;set;}
    public String currencyCodeTwo{get;set;}
    
    //To hold the currency code and its corresponding rate
    @AuraEnabled
    public Map<String, String> mapOfCurrency = new Map<String, String>();
    
    /* --------------------------------------------------------------------
    * Author:  Asok Kumar Sampath
    * Date:  26 Apr 2018
    * Purpose: Constructor and to define default values
    ----------------------------------------------------------------------- */ 
    public BitCoin_Controller()
    {
        inputAmtOne = Decimal.valueOf(System.Label.Default_BTC_Value);
        inputAmtTwo = Decimal.valueOf(System.Label.Default_Other_Value);
        currencyCodeOne = System.Label.BTC;
    }
    
    /* --------------------------------------------------------------------
    * Author:  Asok Kumar Sampath
    * Date:  26 Apr 2018
    * Param: None
    * Return:  List<SelectOption>
    * Purpose: Method to form the list of currencies dynamically
    ----------------------------------------------------------------------- */ 
    //To fetch the available current code and display in visualforce page
    @AuraEnabled(cacheable=true)
    public static List<String> currList() 
    {      
        List<String> currListValues = new List<String>();
        Map<String, String> mapOfCurrency = new Map<String, String>();

        //to fetch the currency list from API
        deserializeDataList = bitCoinConversion();
        for(BitCoinWrapperClass wrap : deserializeDataList)
        {
             currListValues.add(wrap.code+'-'+wrap.Name);
             mapOfCurrency.put(wrap.code, wrap.rate);
        }
        return currListValues;
    }

    /* --------------------------------------------------------------------
    * Author:  Asok Kumar Sampath
    * Date:  26 Apr 2018
    * Param: None
    * Return:  List<WrapperClass>
    * Purpose: Method to get the response from API and deserialize for use
    ----------------------------------------------------------------------- */ 
    @AuraEnabled(cacheable=true)
    public static List < BitCoinWrapperClass > bitCoinConversion() 
    {
    
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndPoint(System.Label.BitCoinAPIURL);
        request.setMethod('GET');
        HttpResponse res = http.send(request);
        
        // Deserialize the response from JSON format to Wrapper class
        try 
        {
            deserializeDataList = (List <BitCoinWrapperClass>) JSON.deserialize(res.getBody(), List <BitCoinWrapperClass>.class);
        } 
        catch (Exception e) 
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error occured while retreiving data'));
            String trace = 'Type: ' + e.getTypeName() + '\n' + 'Cause: ' + e.getCause() + '\n' + 'Message: '+ e.getMessage() + '\n' + 'Line #: ' + e.getLineNumber() + '\n' + e.getStackTraceString();
            insert UtilityClass.createErrorLog('Bit_Coin_Comparison__c','Deserialize JSON', trace);
        }

        return deserializeDataList;
    }
    
    /* --------------------------------------------------------------------
    * Author:  Asok Kumar Sampath
    * Date:  26 Apr 2018
    * Purpose: Wrapper class to hold the data from the response
    ----------------------------------------------------------------------- */ 
    public class BitCoinWrapperClass
    {   
        @AuraEnabled
        public String rate;
        @AuraEnabled
        public String name;
        @AuraEnabled
        public String code;
        
        public BitCoinWrapperClass(string rate, string name, string code)
        {
            this.rate = rate;
            this.name = name;
            this.code = code;
        }
    }
    
    /* --------------------------------------------------------------------
    * Author:  Asok Kumar Sampath
    * Date:  26 Apr 2018
    * Param: None
    * Return:  None
    * Purpose: Method to calculate the other currency value against Bitcoin
    ----------------------------------------------------------------------- */ 
    @AuraEnabled
    public Static Decimal calculateOtherValue(String currencyCodeTwo, Decimal inputAmtOne, Decimal inputAmtTwo)
    {
        Decimal currValue = 0;
        try
        {
            
            Map<String, String> mapOfCurrency = new Map<String, String>();

            //to fetch the currency list from API
            deserializeDataList = bitCoinConversion();
            for(BitCoinWrapperClass wrap : deserializeDataList)
            {
                mapOfCurrency.put(wrap.code, wrap.rate);
            }
            String currCode = currencyCodeTwo.subString(0,3);

            if(mapOfCurrency.containsKey(currCode))
            {
                inputAmtTwo = Decimal.valueOf(mapOfCurrency.get(currCode.subString(0,3))) * inputAmtOne;
                currValue =   inputAmtTwo;  
            }
            
            //To create record for comparison
            createRecordForComparison(inputAmtOne, currencyCodeTwo,inputAmtTwo ,System.Label.BTC + ' to ' + CurrencyCodeTwo);
            
        }
        catch(Exception e)
        {
            String trace = 'Type: ' + e.getTypeName() + '\n' + 'Cause: ' + e.getCause() + '\n' + 'Message: '+ e.getMessage() + '\n' + 'Line #: ' + e.getLineNumber() + '\n' + e.getStackTraceString();
            insert UtilityClass.createErrorLog('Bit_Coin_Comparison__c','calculateOtherValue', trace);
        }

        return currValue;
    }
       
    
    /* --------------------------------------------------------------------
    * Author:  Asok Kumar Sampath
    * Date:  26 Apr 2018
    * Param: None
    * Return:  None
    * Purpose: Method to calculate the corresponding bitcoin value against other currency
    ----------------------------------------------------------------------- */ 
    public void calculateBitCoinValue()
    {  
        try
        {
            String currCode = currencyCodeTwo.subString(0,3);
            if(mapOfCurrency.containsKey(currCode))
            {
                inputAmtOne = (inputAmtTwo / Decimal.valueOf(mapOfCurrency.get(currCode)));   
            }
            //To create record for comparison
            createRecordForComparison(inputAmtOne, currencyCodeTwo,inputAmtTwo ,CurrencyCodeTwo + ' to ' + System.Label.BTC);   
        }
        catch(Exception e)
        {
            String trace = 'Type: ' + e.getTypeName() + '\n' + 'Cause: ' + e.getCause() + '\n' + 'Message: ' + e.getMessage() + '\n' + 'Line #: ' + e.getLineNumber() + '\n' + e.getStackTraceString();
            insert UtilityClass.createErrorLog('Bit_Coin_Comparison__c','calculateBitCoinValue', trace);
        }      
    }
    
    /* --------------------------------------------------------------------
    * Author:  Asok Kumar Sampath
    * Date:  26 Apr 2018
    * Param: Decimal, String, Decimal, String
    * Return:  None
    * Purpose: Method to create the records for reporting
    ----------------------------------------------------------------------- */ 
    public static void createRecordForComparison(Decimal bitCoinValue, String otherCurrency, Decimal otherCurrencyValue, String rep)
    {
        Bit_Coin_Comparison__c comp = new Bit_Coin_Comparison__c();
        comp.Bit_Coin_Value__c  = bitCoinValue;
        comp.Other_Currency__c = otherCurrency;
        comp.Other_Value__c = otherCurrencyValue;
        comp.Description__c = rep;
        
        try
        {
            insert comp;
        }
        catch(DMLException e)
        {
            String trace = 'Type: ' + e.getTypeName() + '\n' + 'Cause: ' + e.getCause() + '\n' + 'Message: ' + e.getMessage() + '\n' + 'Line #: ' + e.getLineNumber() + '\n' + e.getStackTraceString();
            insert UtilityClass.createErrorLog('Bit_Coin_Comparison__c','Create Comparison Record', trace);
        }
    }
}