import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:heart_flutter/camera.dart';

class HeartRateData {
  final String date;
  final int bpm;
  final DateTime timestamp;
  final String displayTime;

  const HeartRateData(this.date, this.bpm, this.timestamp, this.displayTime);
}

class HeartRateScreen extends StatefulWidget {
  const HeartRateScreen({super.key});

  @override
  State<HeartRateScreen> createState() => _HeartRateScreenState();
}

class _HeartRateScreenState extends State<HeartRateScreen> {
  final List<HeartRateData> _data = [];

  void _measureHeartRate() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HeartRateCameraScreen(
          onResult: (int bpm) {
            DateTime now = DateTime.now();
            String formattedDate = DateFormat('MM.dd').format(now);
            String displayTime = DateFormat('HH:mm').format(now);

            setState(() {
              _data.add(HeartRateData(formattedDate, bpm, now, displayTime));
            });
          },
        ),
      ),
    );
  }

  int get max => _data.isEmpty ? 0 : _data.map((e) => e.bpm).reduce(maxFunction);
  int get min => _data.isEmpty ? 0 : _data.map((e) => e.bpm).reduce(minFunction);
  int get avg => _data.isEmpty
      ? 0
      : (_data.map((e) => e.bpm).reduce((a, b) => a + b) / _data.length).round();

  int maxFunction(int a, int b) => a > b ? a : b;
  int minFunction(int a, int b) => a < b ? a : b;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Heart Rate',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 24, 23, 23),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 147, 91, 237),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(12),
        color: Colors.white,
        child: ElevatedButton.icon(
          onPressed: _measureHeartRate,
          icon: const Icon(Icons.favorite, color: Colors.white),
          label: const Text(
            'Measure Now',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            backgroundColor: const Color.fromARGB(255, 147, 91, 237),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _statCard("Max", "$max", const Color(0xFFB47EE5)),
                _statCard("Min", "$min", const Color(0xFFB47EE5)),
                _statCard("Avg", "$avg", const Color(0xFFB47EE5)),
              ],
            ),
            const SizedBox(height: 20),
            SfCartesianChart(
              title: ChartTitle(text: 'Heart Rate Over Time'),
              primaryXAxis: CategoryAxis(
                title: AxisTitle(text: 'Time'),
                majorGridLines: const MajorGridLines(width: 0),
              ),
              primaryYAxis: NumericAxis(
                title: AxisTitle(text: 'BPM'),
                minimum: 50,
                maximum: 150,
                interval: 10,
                majorGridLines: const MajorGridLines(width: 0),
              ),
              series: <CartesianSeries<HeartRateData, String>>[
                LineSeries<HeartRateData, String>(
                  dataSource: _data,
                  xValueMapper: (HeartRateData hr, _) => hr.displayTime,
                  yValueMapper: (HeartRateData hr, _) => hr.bpm,
                  color: Colors.deepPurple,
                  markerSettings: const MarkerSettings(
                    isVisible: true,
                    color: Colors.deepPurple,
                    shape: DataMarkerType.circle,
                  ),
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    textStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text('History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (_data.isEmpty) const Center(child: Text('No measurements yet')),
            ..._data.reversed.map(
              (hr) => heartRateTile(
                hr.bpm.toString(),
                hr.bpm < 60 ? 'Slow' : (hr.bpm > 100 ? 'High' : 'Normal'),
                hr.displayTime,
              ),
            ),
            const SizedBox(height: 24),
            const Text('Statistics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Center(
              child: SizedBox(
                height: 200,
                child: SfCircularChart(
                  legend: Legend(isVisible: true),
                  series: <CircularSeries>[
                    DoughnutSeries<MapEntry<String, int>, String>(
                      dataSource: _buildPieData(),
                      xValueMapper: (entry, _) => entry.key,
                      yValueMapper: (entry, _) => entry.value,
                      dataLabelSettings: const DataLabelSettings(isVisible: true),
                      pointColorMapper: (entry, _) {
                        if (entry.key == 'Normal') return Colors.green;
                        if (entry.key == 'Slow') return Colors.blue;
                        return Colors.red;
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String label, String value, Color color) {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.2), blurRadius: 6, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }

  List<MapEntry<String, int>> _buildPieData() {
    int normal = _data.where((e) => e.bpm >= 60 && e.bpm <= 100).length;
    int slow = _data.where((e) => e.bpm < 60).length;
    int high = _data.where((e) => e.bpm > 100).length;
    return [
      MapEntry('Normal', normal),
      MapEntry('Slow', slow),
      MapEntry('High', high),
    ];
  }

  Widget heartRateTile(String bpm, String status, String time) {
    return ListTile(
      leading: Text(
        bpm,
        style: TextStyle(
          fontSize: 20,
          color: status == 'Slow' ? Colors.blue : status == 'High' ? Colors.red : Colors.green,
        ),
      ),
      title: Text(status),
      subtitle: Text("Measured at $time"),
    );
  }
}

/*import 'package:flutter/material.dart';

class HeartRatePage extends StatelessWidget {
  const HeartRatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Heart Rate")),
      body: const Center(child: Text("Heart Rate Page")),
    );
  }
}*/