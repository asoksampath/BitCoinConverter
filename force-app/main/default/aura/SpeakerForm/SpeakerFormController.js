({
	onSuccess : function(component, event, helper) {
		//Show Success message on upsertion of record
        var resultToast = $A.get("e.force:showToast");
        resultToast.setParams({
            "title": "Success!",	
            "message": "The record has been updated successfully."
        });
        resultToast.fire();
        
        //Navigate to sObject home page
        var homeEvent = $A.get("e.force:navigateToObjectHome");
        homeEvent.setParams({
            "scope": "Speaker__c"
        });
        homeEvent.fire();
	}
})