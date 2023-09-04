import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:gardening_app/syngonium_report.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Syngonium',
      home: SyngoniumLog(),
      routes: {
        '/reportsyngonium': (context) => SyngoniumReport(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/reportsyngonium') {
          return MaterialPageRoute(
            builder: (context) => SyngoniumReport(),
          );
        }
        return null;
      },
    );
  }
}

class SyngoniumLog extends StatefulWidget {
  const SyngoniumLog({Key? key}) : super(key: key);

  @override
  _SyngoniumLogState createState() => _SyngoniumLogState();
}

class _SyngoniumLogState extends State<SyngoniumLog> {
  List<MapEntry<dynamic, dynamic>> logList = [];

  @override
  void initState() {
    super.initState();
    fetchLogData();
  }

  void fetchLogData() {
    DatabaseReference logRef = FirebaseDatabase.instance.reference().child('log_data/Syngonium');
    logRef.get().then((DataSnapshot snapshot) {
      if (snapshot.exists) {
        Map<dynamic, dynamic>? logData = snapshot.value as Map<dynamic, dynamic>?;
        if (logData != null) {
          setState(() {
            logList = logData.entries.toList();
            logList.sort((a, b) {
              DateTime aTimestamp = DateTime.parse(a.value['timestamp']);
              DateTime bTimestamp = DateTime.parse(b.value['timestamp']);
              return bTimestamp.compareTo(aTimestamp);
            });
          });
        }
      }
    }, onError: (error) {
      print('Error fetching log data: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff5fa86b),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(84),
                  bottomLeft: Radius.circular(84),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x3f000000),
                    offset: Offset(0, 5),
                    blurRadius: 2,
                  ),
                ],
              ),
              padding: EdgeInsets.only(left: 25, right: 25, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x3f000000),
                            offset: Offset(0, 2),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.arrow_back),
                          SizedBox(width: 4),
                          Text(
                            'Back',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              height: 1.5,
                              color: Color(0xff315a37),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    'LOG',
                    style: TextStyle(
                      fontFamily: 'Overlock',
                      fontSize: 27,
                      fontWeight: FontWeight.w900,
                      height: 1.22,
                      color: Color(0xffffffff),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SyngoniumReport()),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Color(0xffffffff),
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x3f000000),
                            offset: Offset(0, 4),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: Text(
                        'Report',
                        style: TextStyle(
                          fontFamily: 'Overlock',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          height: 1.22,
                          color: Color(0xff315a37),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(21),
              ),
              padding: EdgeInsets.all(16),
              child: ListView.builder(
                itemCount: logList.length,
                itemBuilder: (context, index) {
                  var logEntry = logList[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: 5),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Timestamp: ${logEntry.value['timestamp']}'),
                          SizedBox(height: 8),
                          Text('pH Value: ${logEntry.value['ph_value']}'),
                          SizedBox(height: 8),
                          Text('Pompa 1: ${logEntry.value['pompa_1']}'),
                          SizedBox(height: 8),
                          Text('Pompa 2: ${logEntry.value['pompa_2']}'),
                          SizedBox(height: 8),
                          Text('Soil Moisture: ${logEntry.value['soil_moisture']}'),
                          SizedBox(height: 8),
                          Text('Temperature: ${logEntry.value['temperature']}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
