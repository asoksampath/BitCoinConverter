/* eslint-disable no-alert */
import { LightningElement, track } from 'lwc';
import BTC from '@salesforce/label/c.BTC';
import createRecordForComparison from '@salesforce/apex/BitCoin_Controller.createRecordForComparison';
     

export default class BitCoinConverterWithoutController extends LightningElement 
{
    label = {
        BTC,
    };
    @track listItems=[];
    @track myYears=[];
    @track value = '';
    @track myValue = '';
    @track BitCoinValue = 1;
    @track otherValue = 0;
    selectedOption;
    bitValue;
    otherCurrValue;
    @track selectedYear;
    mapOfCurrency = new Map();

    constructor()
    {
        super();
        fetch('https://bitpay.com/api/rates')
        .then(function(response) {
            return response.json();
        })
        .then((myJson) => 
        {
            for(let i=0; i < myJson.length; i++)
            {
                this.listItems = [...this.listItems,{value: myJson[i].code , label: myJson[i].code + '-' + myJson[i].name} ];                        
                this.mapOfCurrency.set(myJson[i].code, myJson[i]);
            }
            this.error = undefined;
        })
        .catch(e=>window.console.log('error is '+ e));
    }


    get currencyList()
    {
        return this.listItems;
    }   
    
    //to calculate other value while changing bit coin value
    handleCurrencyValue(event)
    {
        this.bitValue = event.detail.value;
        if(this.selectedOption === undefined || this.bitValue === "NaN" || this.selectedOption === "-Selelct-" )
        {
            alert("Please select currency");
        }
        else{
            this.calculateCurrencyValue(this.selectedOption, this.bitValue);
        }
               
    }

    //To calculate while the currency code changes
    handleChange(event) 
    {
        // Get the string of the "value" attribute on the selected option
        this.selectedOption = event.detail.value;    
        this.calculateCurrencyValue(this.selectedOption,this.BitCoinValue);
    }


    //to calculate other value
    calculateCurrencyValue(selectedCurrency, bitcoin)
    {
        this.otherValue = this.mapOfCurrency.get(selectedCurrency).rate * bitcoin ;
        /*
        const allValid = [...this.template.querySelectorAll('lightning-input')]
            .reduce((validSoFar, inputCmp) => {
                        inputCmp.reportValidity();
                        return validSoFar && inputCmp.checkValidity();
            }, true);
        if (allValid) {
        }   
        */   
    }

    //to calculate bitcoinvalue
    handleBitCoinValue(event)
    {
        this.otherCurrValue = event.detail.value;
        this.BitCoinValue = this.otherCurrValue / this.mapOfCurrency.get(this.selectedOption).rate;
        createRecordForComparison({bitCoinValue: this.BitCoinValue, otherCurrency:this.selectedOption , otherCurrencyValue: this.otherCurrValue, rep: BTC + ' to ' + this.selectedOption});
    }
    /*
    get yearsList()
    {   
        var d = new Date();
        this.myYears=[];
        this.selectedYear = '-None-';
        for(let i=0; i < 5; i++)
        {
            this.myYears = [...this.myYears, { label: d.getFullYear() + i, value: d.getFullYear() + i } ];
        }
        return this.myYears;

    } 

    //To populate the year
    handleYearChange(event) {
        // Get the string of the "value" attribute on the selected option
        this.selectedYear = event.detail.value;
    }
    

    get options() {
        return [
            { label: 'New', value: 'new' },
            { label: 'In Progress', value: 'inProgress' },
            { label: 'Finished', value: 'finished' },
        ];
    }
    */
}