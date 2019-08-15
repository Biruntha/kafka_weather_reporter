import ballerina/cache;
import ballerina/config;
import ballerina/http;
import ballerina/internal;
import ballerina/io;
import ballerina/kafka;
import ballerina/task;

task:TimerConfiguration timerConfiguration = {
    intervalInMillis: 1000,
    initialDelayInMillis: 300,
    noOfRecurrences: 2
};
listener task:Listener timer = new(timerConfiguration);

// Kafka producer configurations
kafka:ProducerConfig producerConfigs = {
    bootstrapServers: "localhost:9092",
    clientId: "basic-producer",
    acks: "all"
};

kafka:Producer kafkaProducer = new(producerConfigs);
http:Client clientEndpoint = new("http://api.openweathermap.org");
string apiKey = config:getAsString("WEATHERMAP_API_KEY");

service timerService on timer {
    resource function onTrigger() {
        callWeatherService();
    }
}

function callWeatherService(){
    io:println("REST");
    var response = clientEndpoint->get("/data/2.5/weather?q=London&APPID=" + apiKey);
    handleResponse(response);
}

function handleResponse(http:Response|error response) {
    if (response is http:Response) {
        var msg = response.getJsonPayload();
        if (msg is json) {
            io:println("[INFO] Successfully received weather update");
            byte[] serializedMsg = internal:toByteArray(msg.toJsonString(), "UTF-8");
            var sendResult = kafkaProducer->send(serializedMsg, "test-kafka-topic", partition = 0); 
            // Send internal server error if the sending has failed
            if (sendResult is error) {
                io:println("[ERROR] Kafka producer failed to send data" );
            } else {
                io:println("[INFO] Successfull send weather updates to Kafka topic" );
            }
        } else {
            io:println("[ERROR] Invalid payload received:" , msg.reason());
        }
    } else {
        io:println("[ERROR] Error when calling the backend: ", response.reason());
    }
}
