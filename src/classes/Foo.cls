public class FooTest {

    private String id = '0050Y000002NZYFQA4';

    public void badExample(Integer param){
        Account.Id = '0050Y000002NZYFQA4';
        param =6;
        
    }   

    public void paramScrewup(Integer param, Country country){
        param = 6;

        country = acctSites.Account__r.country__r.Alpha2Code__c; // comment \ca for TST3 as domain data was loaded with \ca and \ us

    }

    public void dmlOperation (String param){
    Account newAcct = new Account(name = param);
        try {
            insert newAcct;
        } catch (DmlException e) {
            // Process exception here
        }
    }

    public String getCalloutResponseContents(String url) {

        // Instantiate a new http object
        Http h = new Http();

        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');

        // Send the request, and return a response
        HttpResponse res = h.send(req);
        return res.getBody();
    }
     
    public void loopMethod(){
        for(Integer i=0; i < 10; i++) {
            dmlOperation('coolname');
        }
    }

}