import { LightningElement,wire, track } from 'lwc';
import fetchAccount from '@salesforce/apex/GetAccount.fetchAccount';


export default class ShowAccount extends LightningElement {
@track searchString='LWC';
@track accountList=[];
    
@wire(fetchAccount,{searchString: this.searchString}) accounts;
handleSearch(event){
    this.searchString=event.target.value;
}
}