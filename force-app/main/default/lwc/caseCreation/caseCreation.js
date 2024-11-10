import { LightningElement, track } from 'lwc';
import createCase from '@salesforce/apex/CaseCreationController.createCase';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CreateCaseComponent extends LightningElement {
    @track subject = '';
    @track description = '';

    handleSubjectChange(event) {
        this.subject = event.target.value;
    }

    handleDescriptionChange(event) {
        this.description = event.target.value;
    }

    handleCreateCase() {
        createCase({ subject: this.subject, description: this.description })
            .then(result => {
                this.showToast('Success', result, 'success');
                this.subject = '';
                this.description = '';
            })
            .catch(error => {
                this.showToast('Error', error.body.message, 'error');
            });
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        }));
    }
}
