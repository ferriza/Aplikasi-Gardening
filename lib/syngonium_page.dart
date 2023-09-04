import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:gardening_app/syngonium_log.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Syngonium',
      home: SyngoniumPage(),
    );
  }
}

class SyngoniumPage extends StatefulWidget {
  @override
  _SyngoniumPageState createState() => _SyngoniumPageState();
}

class _SyngoniumPageState extends State<SyngoniumPage> {
  final DatabaseReference _sensorDataRef =
      FirebaseDatabase.instance.reference().child('sensor_data');
  final DatabaseReference _pompa1Ref =
      FirebaseDatabase.instance.reference().child('sensor_data').child('pompa_1');
  final DatabaseReference _pompa2Ref =
      FirebaseDatabase.instance.reference().child('sensor_data').child('pompa_2');

  @override
  void initState() {
    super.initState();
    _sensorDataRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        var sensorData = event.snapshot.value as Map<dynamic, dynamic>;

        setState(() {
          _soilMoisture = (sensorData['soil_moisture'] ?? 0).toString();
          _phValue = (sensorData['ph_value'] ?? 0).toString();
          _temperature = (sensorData['temperature'] ?? 0).toString();
        });
      }
    });

    _pompa1Ref.onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          _pompa1Status = event.snapshot.value.toString();
        });
      }
    });

    _pompa2Ref.onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          _pompa2Status = event.snapshot.value.toString();
        });
      }
    });
  }

  String _soilMoisture = '';
  String _phValue = '';
  String _temperature = '';
  String _pompa1Status = '';
  String _pompa2Status = '';

  String _getAlertText() {
    String alertText = '';

    double temperature = double.tryParse(_temperature) ?? 0;
    double phValue = double.tryParse(_phValue) ?? 0;
    double soilMoisture = double.tryParse(_soilMoisture) ?? 0;

    if (temperature > 35) {
      alertText += 'Suhu sangat panas\n';
    } else if (temperature < 18) {
      alertText += 'Suhu dingin\n';
    }

    if (phValue > 9) {
      alertText += 'PH Tanah Basa\n';
    } else if (phValue < 4) {
      alertText += 'PH Tanah Asam\n';
    }

    if (soilMoisture > 75) {
      alertText += 'Tanah sangat kering\n';
    } else if (soilMoisture < 25) {
      alertText += 'Tanah sangat basah\n';
    }

    return alertText;
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final screenSize = MediaQuery.of(context).size;
    // ignore: unused_local_variable
    final isSmallScreen = screenSize.width <= 600;
    final isMediumScreen = screenSize.width > 600 && screenSize.width <= 1000;
    final isLargeScreen = screenSize.width > 1000;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 70),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xffffffff),
            borderRadius: BorderRadius.circular(21),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 20),
                width: double.infinity,
                height: 38,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xbf5a8c5c),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(21),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(10, 7, 15, 8),
                        height: double.infinity,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 9),
                              width: 5,
                              height: 11,
                              child: Image.asset(
                                'assets/images/vector_back.png',
                                width: 5,
                                height: 11,
                              ),
                            ),
                            Text(
                              'Back',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                height: 1.5,
                                color: Color(0xffffffff),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SyngoniumLog(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xbf5a8c5c),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(21),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(10, 7, 15, 8),
                        height: double.infinity,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 15),
                              width: 5,
                              height: 11,
                              child: Image.asset(
                                'assets/images/vector_log.png',
                                width: 5,
                                height: 11,
                              ),
                            ),
                            Text(
                              'Log',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                height: 1.5,
                                color: Color(0xffffffff),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Center the "Syngonium" text and image
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 30),
                      child: Text(
                        'Syngonium',
                        style: TextStyle(
                          fontFamily: 'Overlock',
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          height: 1.22,
                          color: Color(0xff346336),
                        ),
                      ),
                    ),
                    Container(
                      width: 157,
                      height: 157,
                      child: Image.asset(
                        'assets/images/syngonium.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: isMediumScreen || isLargeScreen
                    ? EdgeInsets.fromLTRB(0, 0, 230, 9)
                    : EdgeInsets.fromLTRB(0, 40, 0, 10),
                child: Text(
                  'Status Sensor',
                  style: TextStyle(
                    fontFamily: 'Overlock',
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    height: 1.22,
                    color: Color(0xff1b2c1c),
                  ),
                ),
              ),
              Container(
                margin: isMediumScreen || isLargeScreen
                    ? EdgeInsets.fromLTRB(0, 0, 0, 43)
                    : EdgeInsets.fromLTRB(0, 0, 0, 15),
                width: double.infinity,
                height: isMediumScreen || isLargeScreen ? 107 : 80,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(18, 15, 0, 0),
                        decoration: BoxDecoration(
                          color: Color(0xffb4e4c1),
                          borderRadius: BorderRadius.circular(17),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: Text(
                                'Kelembapan Tanah : $_soilMoisture %',
                                style: TextStyle(
                                  fontFamily: 'Overlock',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  height: 1.22,
                                  color: Color(0xff1b2b1b),
                                ),
                              ),
                            ),
                            Text(
                              'PH tanah : $_phValue',
                              style: TextStyle(
                                fontFamily: 'Overlock',
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                height: 1.22,
                                color: Color(0xff1b2b1b),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(18, 20, 18, 20),
                        decoration: BoxDecoration(
                          color: Color(0xffb4e5c2),
                          borderRadius: BorderRadius.circular(17),
                        ),
                        child: Text(
                          'Suhu : $_temperature °C',
                          style: TextStyle(
                            fontFamily: 'Overlock',
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            height: 1.22,
                            color: Color(0xff1b2b1b),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: isMediumScreen || isLargeScreen
                    ? EdgeInsets.fromLTRB(0, 0, 230, 9)
                    : EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Text(
                  'Status Pompa',
                  style: TextStyle(
                    fontFamily: 'Overlock',
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    height: 1.22,
                    color: Color(0xff1b2c1c),
                  ),
                ),
              ),
              Container(
                margin: isMediumScreen || isLargeScreen
                    ? EdgeInsets.fromLTRB(0, 0, 150, 0)
                    : EdgeInsets.fromLTRB(0, 0, 0, 10),
                padding: EdgeInsets.fromLTRB(18, 20, 10, 35),
                width: isMediumScreen || isLargeScreen ? 188 : 150,
                decoration: BoxDecoration(
                  color: Color(0xffb4e4c1),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Text(
                        'Pompa 1 : $_pompa1Status',
                        style: TextStyle(
                          fontFamily: 'Overlock',
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          height: 1.22,
                          color: Color(0xff1b2b1b),
                        ),
                      ),
                    ),
                    Text(
                      'Pompa 2 : $_pompa2Status',
                      style: TextStyle(
                        fontFamily: 'Overlock',
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        height: 1.22,
                        color: Color(0xff1b2b1b),
                      ),
                    ),
                  ],
                ),
              ),
              if (_getAlertText().isNotEmpty)
                Container(
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getAlertText(),
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
