import { LightningElement,track,api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const FIELDS = [
    'Account.Name',
    'Account.Type',
    'Account.BillingCity',
    'Account.BillingCountry'
];

export default class Accview extends LightningElement {

    @api recordId;
    @api objectname;

    //To display the value in the UI
    @track greeting = 'Hello World';
    changeHandler(event){
        this.greeting = event.target.value;
    }

    _title = 'Success';
    message = 'Record got updated successfully!';
    variant = 'Success';
    variantOptions = [
        { label: 'error', value: 'error' },
        { label: 'warning', value: 'warning' },
        { label: 'success', value: 'success' },
        { label: 'info', value: 'info' },
    ];

    showNotification() {
        const evt = new ShowToastEvent({
            title: this._title,
            message: this.message,
            variant: this.variant,
        });
        this.dispatchEvent(evt);
    }

    //To read the value from database and display in the frontend
    @wire(getRecord, {recordId: '$recordId', fields: FIELDS})
    account;

    get name() {
        return this.account.data.fields.Name.value;
    }

    get type() {
        return this.account.data.fields.Type.value;
    }

    get billingcity() {
        return this.account.data.fields.BillingCity.value;
    }

    get billingcountry() {
        return this.account.data.fields.BillingCountry.value;
    }
}