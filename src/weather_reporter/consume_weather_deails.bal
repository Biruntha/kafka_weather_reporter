import ballerina/io;
import ballerina/kafka;
import ballerina/encoding;

kafka:ConsumerConfig consumerConfig = {
    bootstrapServers:"localhost:9092",
    groupId:"group-id",
    offsetReset:"earliest",
    topics:["test-kafka-topic"],
    pollingIntervalInMillis: 1000
};

// Create kafka listener
listener kafka:Consumer consumer = new(consumerConfig);


service kafkaService on consumer {
    // Triggered whenever a message added to the subscribed topic
    resource function onMessage(kafka:Consumer simpleConsumer, kafka:ConsumerRecord[] records) {
        // Dispatched set of Kafka records to service, We process each one by one.
        foreach var entry in records {
            byte[] serializedMsg = entry.value;
            // Convert the serialized message to string message
            string msg = encoding:byteArrayToString(serializedMsg);
            io:println("[INFO] New message received to the Topic: " + entry.topic);
            // log the retrieved Kafka record
            io:println("[INFO] Received Message: " + msg);
        }
    }
}
