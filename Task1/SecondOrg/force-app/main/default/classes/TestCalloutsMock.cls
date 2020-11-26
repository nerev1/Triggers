@IsTest
global class TestCalloutsMock implements HttpCalloutMock {
    global static String TEST_EXTERNAL_ID = '0015g000002eTkyAAE';

    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('[{ "id": "' + TEST_EXTERNAL_ID + '", "success": true, "errors": [ ] }]');
        response.setStatusCode(200);
        return response; 
    }
}
