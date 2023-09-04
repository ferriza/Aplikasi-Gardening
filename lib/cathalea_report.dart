import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:charts_flutter/flutter.dart' as charts;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: CathaleaReport(),
    );
  }
}

class CathaleaReport extends StatefulWidget {
  @override
  _CathaleaReportState createState() => _CathaleaReportState();
}

class _CathaleaReportState extends State<CathaleaReport> {
  List<charts.Series<LogData, String>> temperatureSeriesList = [];
  List<charts.Series<LogData, String>> phValueSeriesList = [];
  List<charts.Series<LogData, String>> soilMoistureSeriesList = [];
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  String convertTimestamp(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    String timeString = '${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
    return timeString;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        fetchData();
      });
    }
  }

  void fetchData() async {
    DatabaseReference logRef = FirebaseDatabase.instance.reference().child('log_data/Cathalea');
    DatabaseEvent snapshot = await logRef.once();
    if (snapshot.snapshot.value != null) {
      Map<dynamic, dynamic> logData = snapshot.snapshot.value as Map<dynamic, dynamic>;
      // Sort data by timestamp
      logData = Map.fromEntries(logData.entries.toList()..sort((e1, e2) => e1.value['timestamp'].compareTo(e2.value['timestamp'])));
      selectedDate ??= DateTime.parse(logData.values.last['timestamp']);
      List<LogData> temperatureData = [];
      List<LogData> phValueData = [];
      List<LogData> soilMoistureData = [];

      logData.forEach((key, value) {
        DateTime logDate = DateTime.parse(value['timestamp']);
        if (DateUtils.isSameDay(selectedDate, logDate)) {
          temperatureData.add(LogData(convertTimestamp(value['timestamp']),
              double.tryParse(value['temperature']) ?? 0.0,
              0.0,
              0.0,
          ));
          phValueData.add(LogData(convertTimestamp(value['timestamp']),
              0.0,
              double.tryParse(value['ph_value']) ?? 0.0,
              0.0,
          ));
          soilMoistureData.add(LogData(convertTimestamp(value['timestamp']),
              0.0,
              0.0,
              double.tryParse(value['soil_moisture']) ?? 0.0,
          ));
        }
      });

      // Take 5 latest data
      temperatureData = temperatureData.take(5).toList();
      phValueData = phValueData.take(5).toList();
      soilMoistureData = soilMoistureData.take(5).toList();

      setState(() {
        temperatureSeriesList = [
          charts.Series<LogData, String>(
            id: 'Temperature',
            domainFn: (LogData log, _) => log.timestamp,
            measureFn: (LogData log, _) => log.temperature,
            data: temperatureData,
            colorFn: (_, __) => charts.Color.fromHex(code: '#4caf50'),
          ),
        ];

        phValueSeriesList = [
          charts.Series<LogData, String>(
            id: 'pH Value',
            domainFn: (LogData log, _) => log.timestamp,
            measureFn: (LogData log, _) => log.phValue,
            data: phValueData,
            colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          ),
        ];

        soilMoistureSeriesList = [
          charts.Series<LogData, String>(
            id: 'Soil Moisture',
            domainFn: (LogData log, _) => log.timestamp,
            measureFn: (LogData log, _) => log.soilMoisture,
            data: soilMoistureData,
            colorFn: (_, __) => charts.Color.fromHex(code: '#795548'),
          ),
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Align(
                      child: SizedBox(
                        width: screenWidth,
                        height: 177,
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
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: screenWidth * 0.4,
                    top: 88,
                    child: Align(
                      child: SizedBox(
                        width: 580,
                        height: 35,
                        child: Text(
                          ' Report',
                          style: TextStyle(
                            fontFamily: 'Overlock',
                            fontSize: 27,
                            fontWeight: FontWeight.w900,
                            height: 1.22,
                            color: Color(0xffffffff),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: screenWidth * 0.75,
                    top: 80,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 65,
                        height: 40,
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
                        child: Center(
                          child: Text(
                            'Back',
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
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20, left: 20, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    selectedDate == null ? '' : '${selectedDate?.day}/${selectedDate?.month}/${selectedDate?.year}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      height: 1.22,
                      color: Color(0xff000000),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: const Text('Select Date'),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: SizedBox(
                width: screenWidth - 40,
                height: 200,
                child: charts.BarChart(
                  temperatureSeriesList,
                  animate: true,
                  behaviors: [charts.SeriesLegend()],
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: SizedBox(
                width: screenWidth - 40,
                height: 200,
                child: charts.BarChart(
                  phValueSeriesList,
                  animate: true,
                  behaviors: [charts.SeriesLegend()],
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: SizedBox(
                width: screenWidth - 40,
                height: 200,
                child: charts.BarChart(
                  soilMoistureSeriesList,
                  animate: true,
                  behaviors: [charts.SeriesLegend()],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LogData {
  final String timestamp;
  final double temperature;
  final double phValue;
  final double soilMoisture;

  LogData(this.timestamp, this.temperature, this.phValue, this.soilMoisture);
}
