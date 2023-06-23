import 'dart:io';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<Stream<List<MqttReceivedMessage<MqttMessage>>>> Do() async {
  // create mqtt client with pair key and cert
  // Your AWS IoT Core endpoint url
  const url = 'a2r6t1vyhdq7sz-ats.iot.us-west-2.amazonaws.com';
  // AWS IoT MQTT default port
  const port = 8883;
  // The client id unique to your device
  const clientId = 'ignacio';

  // Create the client
  final client = MqttServerClient.withPort(url, clientId, port);

  // Set secure
  client.secure = true;
  // Set Keep-Alive
  client.keepAlivePeriod = 20;
  // Set the protocol to V3.1.1 for AWS IoT Core, if you fail to do this you will not receive a connect ack with the response code
  client.setProtocolV311();
  // logging if you wish
  client.logging(on: false);

  // check if exist certificate and key
  var fileCert = await rootBundle.load('sampledata/certificate.pem.crt');
  var fileKey = await rootBundle.load('sampledata/private.pem.key');
  if (fileCert == null || fileKey == null) {
    print('MQTT client exception - certificate or key not found');
    exit(-1);
  }

  // Set the security context as you need, note this is the standard Dart SecurityContext class.
  // If this is incorrect the TLS handshake will abort and a Handshake exception will be raised,
  // no connect ack message will be received and the broker will disconnect.
  // For AWS IoT Core, we need to set the AWS Root CA, device cert & device private key
  // Note that for Flutter users the parameters above can be set in byte format rather than file paths
  final context = SecurityContext.defaultContext;
  //context.setClientAuthorities('path/to/rootCA.pem');
  context.useCertificateChainBytes(fileCert.buffer.asUint8List());
  context.usePrivateKeyBytes(fileKey.buffer.asUint8List());
  client.securityContext = context;

  // Setup the connection Message
  final connMess =
      MqttConnectMessage().withClientIdentifier('ignacio').startClean();
  client.connectionMessage = connMess;

  // Connect the client
  try {
    print('MQTT client connecting to AWS IoT using certificates....');
    await client.connect();
  } on Exception catch (e) {
    print('MQTT client exception - $e');
    client.disconnect();
    exit(-1);
  }

  if (client.connectionStatus!.state == MqttConnectionState.connected) {
    print('MQTT client connected to AWS IoT');

    client.subscribe("topic", MqttQos.atLeastOnce);
    // Print incoming messages from another client on this topic
    /*
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final recMess = c[0].payload as MqttPublishMessage;
      final p =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      print(p);
    });
     */

    print("returning");
    return client.updates!;
  } else {
    print(
        'ERROR MQTT client connection failed - disconnecting, state is ${client.connectionStatus!.state}');
    client.disconnect();

    exit(-1);
  }
}
