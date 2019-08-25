import { LightningElement, track } from 'lwc';
import BTC from '@salesforce/label/c.BTC';

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
    @track selectedYear;
    //isPopulated="false";

    constructor()
    {
        super();
        fetch('https://bitpay.com/api/rates')
        .then(function(response) {
            return response.json();
        })
        .then((myJson) => {
            for(let i=0; i < myJson.length; i++)
            {
                this.listItems = [...this.listItems,{value: myJson[i].code , label: myJson[i].code + '-' + myJson[i].name} ];                        
            }
            this.error = undefined;
        })
        .catch(e=>window.console.log('error is '+ e));
    }

    get currencyList()
    {   
        return this.listItems;
    }   
    
    //To calculate while the currency code changes
    handleChange(event) {
        // Get the string of the "value" attribute on the selected option
        this.selectedOption = event.detail.value;
    }

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
}