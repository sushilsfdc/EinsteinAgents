public with sharing class CaseCreationController {
    @AuraEnabled
    public static void createCase(String subject, String description) {
            if(!detectPII(subject, description)){
                Case newCase = new Case();
                newCase.Subject = subject;
                newCase.Description = description;
                insert newCase;
            }else{
                throw new AuraHandledException('Your subject or description contains some PII');
            }
    }

    private static boolean detectPII(String subject, String description){
        boolean piiDetected = false;
        // Map for holding input parameters
        Map<String, ConnectApi.WrappedValue> inputParams = new Map<String, ConnectApi.WrappedValue>();
        Map<String, String> input = new Map<String, String>();

        // Add wrapped values
        ConnectApi.WrappedValue inputValueMap = new ConnectApi.WrappedValue();
        inputValueMap.value = subject;
        inputParams.put('Input:subject', inputValueMap);

        ConnectApi.WrappedValue inputValueMapDesc = new ConnectApi.WrappedValue();
        inputValueMapDesc.value = description;
        inputParams.put('Input:description', inputValueMapDesc);      
        String response = PromptUtils.invokePrompt('Case_PII_Detection', inputParams);
        System.debug('response - ' + response);
        if(!response.containsIgnoreCase('NO PII DETECTED')){ 
            piiDetected = true;
        }
        return piiDetected;
    }
}
