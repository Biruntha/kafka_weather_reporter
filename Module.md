# Kafka Based weather reporter


1. Download the Kafka from the (official site)[https://kafka.apache.org/downloads]. Then extract the content and do the following steps.
2. Start the ZooKeeper server:
    ```
    bin/zookeeper-server-start.sh -daemon config/zookeeper.properties
    ```
3. Start the Kafka server:
    ```
    bin/kafka-server-start.sh -daemon config/server.properties
    ```

4. Create a Topic:
    ```
    bin/kafka-topics.sh --create --topic test-kafka-topic --zookeeper localhost:2181 --replication-factor 1 --partitions 2
    ```

## Testing the sample

1. Update the `ballerina.conf` file with required credencials.

2. Navigate to `kafka_weather_reporter` directory and execute the following command to publish weather updates to kafka topic and consume those      updates.

    ```
    ballerina run weather_reporter
    ```