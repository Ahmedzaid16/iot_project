import 'package:flutter/material.dart';
import 'package:iot_project/pages/Gas.dart';
import 'package:iot_project/pages/Temperature.dart';
import 'package:iot_project/pages/fire.dart';
import 'package:iot_project/pages/lock.dart';

import '../util/app_colors.dart';
import 'mqtt.dart';


class Services extends StatefulWidget {
  const Services({super.key});

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  late MQTTManager mqttManager;
  bool togle = true;
  @override
  void initState() {
    super.initState();
    mqttManager = MQTTManager(
      server: '192.168.137.1',
      topic: 'home/Motion',
      clientIdentifier: 'Flutter11',
    );
    _connectToMQTT();
  }

  Future<void> _connectToMQTT() async {
    try {
      await mqttManager.connect();
      print('Connected to MQTT Broker');
    } catch (e) {
      print('Failed to connect to MQTT Broker: $e');
      // Handle connection failure
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            cardItems(
                title: "GAS",
                image: "assets/icons/gas.png",


               onTab: (){   Navigator.push(context, MaterialPageRoute(builder: (context)=>Gas()));},

            ),
            cardItems(
               onTab: (){   Navigator.push(context, MaterialPageRoute(builder: (context)=>Temperature()));},

              title: "TEMPERATURE",
              image: "assets/icons/temp.png",
              //color: primary,
              //fontColor: Colors.white,
            ),
          ],
        ),
        const SizedBox(height: 25,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            cardItems(
                title: "Fire",
                image: "assets/icons/img_2.png",
              onTab: (){   Navigator.push(context, MaterialPageRoute(builder: (context)=>Fire()));},

            ),
            cardItems(
              fontColor: togle ? Colors.grey : Colors.black,
              title: "Lock",
              color: togle ? Colors.white : Colors.red,
              image: "assets/icons/img.png",
              onTab: (){
                if(togle) {
                  togle =false;
                  _publishMessage("0");
                  print("published 0");
                } else{
                  togle = true;
                  _publishMessage("1");
                  print("published 1");
                }
                setState(() {

                });
                },

            ),
          ],
        ),
      ],
    );
  }

  GestureDetector cardItems({
    required title,
    required String image,
    VoidCallback? onTab,
    Color color = Colors.white,
    Color fontColor = Colors.grey,
  }) {
    return GestureDetector(
      onTap: onTab,
      child: Material(
        elevation: 15,
        shadowColor: Colors.white38,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: 150,
          padding: const EdgeInsets.symmetric(vertical: 35),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              Image.asset(
                image,
                height: 80,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: fontColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Future<void> _publishMessage(String message) async {
    try {
      mqttManager.publish(message);
      print('Published message: $message');
    } catch (e) {
      print('Failed to publish message: $e');
      // Handle publish failure
    }
  }

  @override
  void dispose() {
    mqttManager.disconnect();
    print('Disconnected from MQTT Broker');
    super.dispose();
  }
}