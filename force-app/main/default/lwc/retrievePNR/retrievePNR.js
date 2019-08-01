import { LightningElement, track,wire} from 'lwc';
import getDatabyPNR  from '@salesforce/apex/PNR_RetrieveClass.getDatabyPNR';
//import printMessage  from '@salesforce/apex/PNR_RetrieveClass.printMessage';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

export default class retreivePNR extends LightningElement {
    @track lastName='CAN';
    @track pnr='CRHBXV';
    @track output='';

    @track passengerName=[];
    
    @wire(getDatabyPNR, {lastName:'CAN', pnr:'CRHBXV'})
    passNames;

    @track error; // to show error message from apex controller.
    @track success; // to show succes message in ui.

    // method for get  accounts.
    handleRandomClick() 
    {
        var i;
        getDatabyPNR({lastName:this.lastName, pnr:this.pnr})
            .then(result => {
                this.output  = result;
                for (i=0; i < this.passNames.data.length; i++) {
                    this.passengerName.push({key:this.passNames.data[i]});
                    console.log('Passenger Name = '+this.passNames.data[i]);
                }
                this.error = undefined;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: ' PNR Retrieve successfully',
                        message: 'PNR Retrieve success ->' + this.passNames.data.length,
                        variant: 'success',
                    }),
                );
            })
            .catch(error => {
                this.error = error;
                console.log('this.error--'+this.error.message);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error while retrieving PNR==>'+ error.message,
                        message: error.message,
                        variant: 'error',
                    }),
                );
                this.output = undefined;
            });
    }
}