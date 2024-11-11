public with sharing class CaseCreationController {
    @AuraEnabled
    public static void createCase(String subject, String description) {
            if(!detectPII(subject, description)){
                Case newCase = new Case();
                newCase.Subject = subject;
                newCase.Description = description;
                insert newCase;
            }else{
                throw new AuraHandledException('Your subject or description contains some PII. Please remove PII before submitting the case.');
            }
    }

    private static boolean detectPII(String subject, String description){
        boolean piiDetected = false;

        // Create Prompt Input Parameter Variables
        ConnectApi.WrappedValue inputValueMapSubject = new ConnectApi.WrappedValue();
        inputValueMapSubject.value = subject;
        ConnectApi.WrappedValue inputValueMapDescription = new ConnectApi.WrappedValue();
        inputValueMapDescription.value = description;

        //Add Prompt input variables to a Map
        Map<String, ConnectApi.WrappedValue> inputParams = new Map<String, ConnectApi.WrappedValue>();        
        inputParams.put('Input:subject', inputValueMapSubject);
        inputParams.put('Input:description', inputValueMapDescription);      

        //Invoke the Prompt 
        String response = PromptUtils.invokePrompt('Case_PII_Detection', inputParams);

        //Check if prompt contained PII
        if(!response.containsIgnoreCase('NO PII DETECTED')){ 
            piiDetected = true;
        }
        return piiDetected;
    }
}
