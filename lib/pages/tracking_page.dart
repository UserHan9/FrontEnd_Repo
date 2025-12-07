import 'dart:async';
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage({super.key});

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  bool _isTracking = false;
  Timer? _timer;
  String _statusMessage = "Ready to track";
  String _lastLocation = "Unknown";
  final ApiService _apiService = ApiService();

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggleTracking() {
    if (_isTracking) {
      _stopTracking();
    } else {
      _startTracking();
    }
  }

  void _startTracking() {
    setState(() {
      _isTracking = true;
      _statusMessage = "Tracking Active";
    });

    // Simulate location updates every 5 seconds
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _sendLocationUpdate();
    });

    // Send immediate first update
    _sendLocationUpdate();
  }

  void _stopTracking() {
    _timer?.cancel();
    setState(() {
      _isTracking = false;
      _statusMessage = "Tracking Stopped";
    });
  }

  Future<void> _sendLocationUpdate() async {
    // Mock location data (Jakarta area)
    final lat = -6.1754 + (DateTime.now().second * 0.0001);
    final lng = 106.8272 + (DateTime.now().second * 0.0001);

    // API Integration disabled as per request
    /*
    try {
      final response = await _apiService.updateTracking(
        "VENDOR_001", // Hardcoded for demo
        lat,
        lng,
      );

      if (mounted) {
        setState(() {
          _lastLocation =
              "${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}";
          // Flash a snackbar or just update UI? Let's just update UI text
        });
        print("Tracking update: $response");
      }
    } catch (e) {
      print("Tracking error: $e");
    }
    */

    // Simulation only
    if (mounted) {
      setState(() {
        _lastLocation =
            "${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)} (Simulated)";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FC),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(25.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 50, // Subtract padding
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // Header
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.arrow_back_ios,
                                size: 20, color: Colors.blueGrey),
                          ),
                          const Expanded(
                            child: Text(
                              "START LOCATION\nTRACKING",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF263238),
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(width: 40), // Balance the back button
                        ],
                      ),
                      const SizedBox(height: 40),

                      // QR Box
                      Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(35),
                          boxShadow: [
                            BoxShadow(
                              color: _isTracking
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.blue.withOpacity(0.08),
                              blurRadius: 25,
                              offset: const Offset(0, 10),
                            ),
                          ],
                          border: _isTracking
                              ? Border.all(
                                  color: Colors.green.shade200, width: 2)
                              : null,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Corner markers
                            Positioned(
                                top: 20,
                                left: 20,
                                child: _CornerMarker(
                                    quarterTurns: 0, isActive: _isTracking)),
                            Positioned(
                                top: 20,
                                right: 20,
                                child: _CornerMarker(
                                    quarterTurns: 1, isActive: _isTracking)),
                            Positioned(
                                bottom: 20,
                                right: 20,
                                child: _CornerMarker(
                                    quarterTurns: 2, isActive: _isTracking)),
                            Positioned(
                                bottom: 20,
                                left: 20,
                                child: _CornerMarker(
                                    quarterTurns: 3, isActive: _isTracking)),

                            // QR Icon
                            Icon(
                              Icons.qr_code_2,
                              size: 100,
                              color: _isTracking
                                  ? Colors.green.shade300
                                  : Colors.blue.shade300,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Recent Transactions Label
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "STATUS",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Status Item
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: _isTracking
                                    ? Colors.green.shade50
                                    : Colors.blue.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                  _isTracking
                                      ? Icons.gps_fixed
                                      : Icons.gps_not_fixed,
                                  color:
                                      _isTracking ? Colors.green : Colors.blue,
                                  size: 20),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Location: $_lastLocation",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF37474F),
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    _statusMessage,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _isTracking
                                          ? Colors.green
                                          : Colors.blueGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // Start Tracking Button
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: _toggleTracking,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isTracking
                                ? const Color(0xFFEF5350)
                                : const Color(0xFF90CAF9),
                            elevation: 5,
                            shadowColor:
                                (_isTracking ? Colors.red : Colors.blue)
                                    .withOpacity(0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            _isTracking ? "STOP TRACKING" : "START TRACKING",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // View History Text
                      TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("History feature coming soon!"),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                        child: Text(
                          "VIEW HISTORY",
                          style: TextStyle(
                            color: Colors.blueGrey.shade400,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CornerMarker extends StatelessWidget {
  final int quarterTurns;
  final bool isActive;

  const _CornerMarker({required this.quarterTurns, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    final color = isActive ? Colors.green.shade200 : Colors.blue.shade200;
    return RotatedBox(
      quarterTurns: quarterTurns,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: color, width: 3),
            left: BorderSide(color: color, width: 3),
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
          ),
        ),
      ),
    );
  }
}
