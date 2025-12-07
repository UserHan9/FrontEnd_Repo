import 'package:flutter/material.dart';
import '../services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _greeting = "Hi, User!";
  String _weatherCondition = "Sunny";
  String _temperature = "30°C";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final api = ApiService();

      // Fetch Greeting
      final hello = await api.getHelloUser();

      if (mounted) {
        setState(() {
          _greeting = hello;
          // Weather integration disabled as per request
          // Defaulting to static data for now
          _weatherCondition = "Sunny";
          _temperature = "30°C";
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching home data: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF5F9FC),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              // Header / Greeting
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        radius: 20,
                        child: Icon(Icons.person, color: Colors.blue.shade400),
                      ),
                      const SizedBox(width: 15),
                      Text(
                        _greeting,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF263238),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_none,
                        color: Colors.blueGrey),
                    onPressed: () {},
                  )
                ],
              ),
              const SizedBox(height: 30),

              // Weather Main Icon
              Center(
                child: Column(
                  children: [
                    Icon(
                      _weatherCondition.toLowerCase().contains('rain')
                          ? Icons.thunderstorm_outlined
                          : Icons.wb_sunny_outlined,
                      size: 80,
                      color: Colors.blue.shade300,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "CURRENT WEATHER",
                      style: TextStyle(
                        fontSize: 14,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF455A64),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Weather Cards Row
              Row(
                children: [
                  Expanded(
                    child: _WeatherCard(
                      day: "TODAY",
                      temp: _temperature,
                      condition: _weatherCondition,
                      icon: _weatherCondition.toLowerCase().contains('rain')
                          ? Icons.thunderstorm_outlined
                          : Icons.wb_sunny_outlined,
                      isPrimary: true,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _WeatherCard(
                      day: "TOMORROW",
                      temp: "28°C", // Dummy forecast
                      condition: "Cloudy",
                      icon: Icons.cloud_outlined,
                      isPrimary: false,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Chart Area
              Container(
                height: 120,
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: CustomPaint(
                  painter: _ChartPainter(),
                ),
              ),
              const SizedBox(height: 30),

              // Merchant Tools Section
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "MERCHANT TOOLS",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: Color(0xFF455A64),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Placeholder for merchant tools grid
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _ToolIcon(Icons.inventory_2_outlined, "Stock"),
                  _ToolIcon(
                    Icons.analytics_outlined,
                    "Sales",
                    onTap: () => _recordSale(context),
                  ),
                  _ToolIcon(Icons.people_outline, "Staff"),
                  _ToolIcon(Icons.settings_outlined, "Manage"),
                ],
              ),

              // Extra space for bottom nav
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _recordSale(BuildContext context) async {
    try {
      final msg = await ApiService().recordSale('VENDOR_001');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class _ToolIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _ToolIcon(this.icon, this.label, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ]),
            child: Icon(icon, color: Colors.blue.shade300),
          ),
          const SizedBox(height: 8),
          Text(label,
              style: const TextStyle(fontSize: 12, color: Colors.blueGrey))
        ],
      ),
    );
  }
}

class _WeatherCard extends StatelessWidget {
  final String day;
  final String temp;
  final String condition;
  final IconData icon;
  final bool isPrimary;

  const _WeatherCard({
    required this.day,
    required this.temp,
    required this.condition,
    required this.icon,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        border: isPrimary
            ? Border.all(color: Colors.blue.withOpacity(0.1), width: 1)
            : null,
      ),
      child: Column(
        children: [
          Text(
            day,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 15),
          Icon(icon, size: 32, color: Colors.blue.shade300),
          const SizedBox(height: 15),
          Text(
            temp,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF263238),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            condition,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.blueGrey.shade300,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.shade200
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.8,
      size.width * 0.5,
      size.height * 0.4,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.1,
      size.width,
      size.height * 0.5,
    );

    canvas.drawPath(path, paint);

    // Draw dots
    final dotPaint = Paint()..color = Colors.blue.shade400;
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.4), 4, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
