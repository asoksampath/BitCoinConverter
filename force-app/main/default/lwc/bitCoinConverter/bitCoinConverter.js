import { LightningElement,wire, track } from 'lwc';
import BitCoinAPIURL from '@salesforce/label/c.BitCoinAPIURL';
import BTC from '@salesforce/label/c.BTC';
import Default_BTC_Value from '@salesforce/label/c.Default_BTC_Value';
import Default_Other_Value from '@salesforce/label/c.Default_Other_Value';
import USD from '@salesforce/label/c.USD';
//import getMapOfData from '@salesforce/apex/BitCoin_Controller.currList';
import getCurrValue from '@salesforce/apex/BitCoin_Controller.calculateOtherValue';
import BitCoinConversion from '@salesforce/apex/BitCoin_Controller.bitCoinConversion';

let i=0;
export default class BitCoinConverter extends LightningElement {
    label = {
        BitCoinAPIURL,
        BTC,
        Default_BTC_Value,
        Default_Other_Value,
        USD
    };

   
    @track listitems =[];
    @track value = ''; //initialize combo box value

    @track BitCoinValue = 1;
    @track otherValue = 0;
    selectedOption;

    @wire(BitCoinConversion)
    coversionValue({data, error}){
        if(data){
            for(i=0; i<data.length; i++) 
            {  
                this.listitems = [...this.listitems,{value: data[i].code , label: data[i].code + '-' +data[i].name} ]; 
            }
            this.error = undefined;
        }
        else if(error){
            this.error = error;
        }
    }

    //gettter to return items which is mapped with options attribute
    get currValueOptions() {
        return this.listitems;
    }

    //To calculate while the currency code changes
    handleChange(event) {
        // Get the string of the "value" attribute on the selected option
        this.selectedOption = event.detail.value;
        this.callMethod();
    }

    //To pass the value and calculate the other currency value
    handleKeyPress(event) 
    {
        // Get the string of the "value" attribute on the selected option
        this.BitCoinValue = event.detail.value;
        this.callMethod();
    }

    //to calculate the value based on the currency selected
    callMethod()
    {
        getCurrValue({currencyCodeTwo:this.selectedOption,inputAmtOne:this.BitCoinValue, inputAmtTwo: this.otherValue})
        .then(result => 
        {
            this.otherValue = result;            
        })
        .catch(error => 
        {
            this.error = error;
        }); 
    }

    
}