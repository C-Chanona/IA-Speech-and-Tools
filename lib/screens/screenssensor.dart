import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'snake.dart';

class Screenssensor extends StatefulWidget {
  const Screenssensor({super.key, this.title});

  final String? title;

  @override
  State<Screenssensor> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Screenssensor> {
  static const Duration _ignoreDuration = Duration(milliseconds: 20);

  static const int _snakeRows = 20;
  static const int _snakeColumns = 20;
  static const double _snakeCellSize = 10.0;

  UserAccelerometerEvent? _userAccelerometerEvent;
  AccelerometerEvent? _accelerometerEvent;
  GyroscopeEvent? _gyroscopeEvent;
  MagnetometerEvent? _magnetometerEvent;
  BarometerEvent? _barometerEvent;

  DateTime? _userAccelerometerUpdateTime;
  DateTime? _accelerometerUpdateTime;
  DateTime? _gyroscopeUpdateTime;
  DateTime? _magnetometerUpdateTime;
  DateTime? _barometerUpdateTime;

  int? _userAccelerometerLastInterval;
  int? _accelerometerLastInterval;
  int? _gyroscopeLastInterval;
  int? _magnetometerLastInterval;
  int? _barometerLastInterval;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  Duration sensorInterval = SensorInterval.normalInterval;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Sensors Plus',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
        backgroundColor: Colors.cyan,
        elevation: 4,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: Colors.black38),
              ),
              child: SizedBox(
                height: _snakeRows * _snakeCellSize,
                width: _snakeColumns * _snakeCellSize,
                child: Snake(
                  rows: _snakeRows,
                  columns: _snakeColumns,
                  cellSize: _snakeCellSize,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(4),
                4: FlexColumnWidth(2),
              },
              children: [
                const TableRow(
                  children: [
                    SizedBox.shrink(),
                    Text('X'),
                    Text('Y'),
                    Text('Z'),
                    Text('Interval'),
                  ],
                ),
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('Acelerómetro de usuario'),
                    ),
                    Text(_userAccelerometerEvent?.x.toStringAsFixed(1) ?? '?'),
                    Text(_userAccelerometerEvent?.y.toStringAsFixed(1) ?? '?'),
                    Text(_userAccelerometerEvent?.z.toStringAsFixed(1) ?? '?'),
                    Text(
                        '${_userAccelerometerLastInterval?.toString() ?? '?'} ms'),
                  ],
                ),
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('Acelerómetro'),
                    ),
                    Text(_accelerometerEvent?.x.toStringAsFixed(1) ?? '?'),
                    Text(_accelerometerEvent?.y.toStringAsFixed(1) ?? '?'),
                    Text(_accelerometerEvent?.z.toStringAsFixed(1) ?? '?'),
                    Text('${_accelerometerLastInterval?.toString() ?? '?'} ms'),
                  ],
                ),
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('Giroscopio'),
                    ),
                    Text(_gyroscopeEvent?.x.toStringAsFixed(1) ?? '?'),
                    Text(_gyroscopeEvent?.y.toStringAsFixed(1) ?? '?'),
                    Text(_gyroscopeEvent?.z.toStringAsFixed(1) ?? '?'),
                    Text('${_gyroscopeLastInterval?.toString() ?? '?'} ms'),
                  ],
                ),
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('Magnetómetro'),
                    ),
                    Text(_magnetometerEvent?.x.toStringAsFixed(1) ?? '?'),
                    Text(_magnetometerEvent?.y.toStringAsFixed(1) ?? '?'),
                    Text(_magnetometerEvent?.z.toStringAsFixed(1) ?? '?'),
                    Text('${_magnetometerLastInterval?.toString() ?? '?'} ms'),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(4),
                1: FlexColumnWidth(3),
                2: FlexColumnWidth(2),
              },
              children: [
                const TableRow(
                  children: [
                    SizedBox.shrink(),
                    Text('Pressure'),
                    Text('Interval'),
                  ],
                ),
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('Barómetro'),
                    ),
                    Text(
                        '${_barometerEvent?.pressure.toStringAsFixed(1) ?? '?'} hPa'),
                    Text('${_barometerLastInterval?.toString() ?? '?'} ms'),
                  ],
                ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Intervalo de actualización:'),
              SegmentedButton(
                segments: [
                  ButtonSegment(
                    value: SensorInterval.gameInterval,
                    label: Text('Game\n'
                        '(${SensorInterval.gameInterval.inMilliseconds}ms)'),
                  ),
                  ButtonSegment(
                    value: SensorInterval.uiInterval,
                    label: Text('UI\n'
                        '(${SensorInterval.uiInterval.inMilliseconds}ms)'),
                  ),
                  ButtonSegment(
                    value: SensorInterval.normalInterval,
                    label: Text('Normal\n'
                        '(${SensorInterval.normalInterval.inMilliseconds}ms)'),
                  ),
                  const ButtonSegment(
                    value: Duration(milliseconds: 500),
                    label: Text('500ms'),
                  ),
                  const ButtonSegment(
                    value: Duration(seconds: 1),
                    label: Text('1s'),
                  ),
                ],
                selected: {sensorInterval},
                showSelectedIcon: false,
                onSelectionChanged: (value) {
                  setState(() {
                    sensorInterval = value.first;
                    userAccelerometerEventStream(
                        samplingPeriod: sensorInterval);
                    accelerometerEventStream(samplingPeriod: sensorInterval);
                    gyroscopeEventStream(samplingPeriod: sensorInterval);
                    magnetometerEventStream(samplingPeriod: sensorInterval);
                    barometerEventStream(samplingPeriod: sensorInterval);
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  void initState() {
    super.initState();
    _streamSubscriptions.add(
      userAccelerometerEventStream(samplingPeriod: sensorInterval).listen(
        (UserAccelerometerEvent event) {
          final now = event.timestamp;
          setState(() {
            _userAccelerometerEvent = event;
            if (_userAccelerometerUpdateTime != null) {
              final interval = now.difference(_userAccelerometerUpdateTime!);
              if (interval > _ignoreDuration) {
                _userAccelerometerLastInterval = interval.inMilliseconds;
              }
            }
          });
          _userAccelerometerUpdateTime = now;
        },
        onError: (e) {
          showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Text("Sensor Not Found"),
                  content: Text(
                      "It seems that your device doesn't support User Accelerometer Sensor"),
                );
              });
        },
        cancelOnError: true,
      ),
    );
    _streamSubscriptions.add(
      accelerometerEventStream(samplingPeriod: sensorInterval).listen(
        (AccelerometerEvent event) {
          final now = event.timestamp;
          setState(() {
            _accelerometerEvent = event;
            if (_accelerometerUpdateTime != null) {
              final interval = now.difference(_accelerometerUpdateTime!);
              if (interval > _ignoreDuration) {
                _accelerometerLastInterval = interval.inMilliseconds;
              }
            }
          });
          _accelerometerUpdateTime = now;
        },
        onError: (e) {
          showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Text("Sensor Not Found"),
                  content: Text(
                      "It seems that your device doesn't support Accelerometer Sensor"),
                );
              });
        },
        cancelOnError: true,
      ),
    );
    _streamSubscriptions.add(
      gyroscopeEventStream(samplingPeriod: sensorInterval).listen(
        (GyroscopeEvent event) {
          final now = event.timestamp;
          setState(() {
            _gyroscopeEvent = event;
            if (_gyroscopeUpdateTime != null) {
              final interval = now.difference(_gyroscopeUpdateTime!);
              if (interval > _ignoreDuration) {
                _gyroscopeLastInterval = interval.inMilliseconds;
              }
            }
          });
          _gyroscopeUpdateTime = now;
        },
        onError: (e) {
          showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Text("Sensor Not Found"),
                  content: Text(
                      "It seems that your device doesn't support Gyroscope Sensor"),
                );
              });
        },
        cancelOnError: true,
      ),
    );
    _streamSubscriptions.add(
      magnetometerEventStream(samplingPeriod: sensorInterval).listen(
        (MagnetometerEvent event) {
          final now = event.timestamp;
          setState(() {
            _magnetometerEvent = event;
            if (_magnetometerUpdateTime != null) {
              final interval = now.difference(_magnetometerUpdateTime!);
              if (interval > _ignoreDuration) {
                _magnetometerLastInterval = interval.inMilliseconds;
              }
            }
          });
          _magnetometerUpdateTime = now;
        },
        onError: (e) {
          showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Text("Sensor Not Found"),
                  content: Text(
                      "It seems that your device doesn't support Magnetometer Sensor"),
                );
              });
        },
        cancelOnError: true,
      ),
    );
    _streamSubscriptions.add(
      barometerEventStream(samplingPeriod: sensorInterval).listen(
        (BarometerEvent event) {
          final now = event.timestamp;
          setState(() {
            _barometerEvent = event;
            if (_barometerUpdateTime != null) {
              final interval = now.difference(_barometerUpdateTime!);
              if (interval > _ignoreDuration) {
                _barometerLastInterval = interval.inMilliseconds;
              }
            }
          });
          _barometerUpdateTime = now;
        },
        onError: (e) {
          showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Text("Sensor no encontrado"),
                  content: Text(
                      "Parece que su dispositivo no es compatible con el sensor barómetro"),
                );
              });
        },
        cancelOnError: true,
      ),
    );
  }
}
