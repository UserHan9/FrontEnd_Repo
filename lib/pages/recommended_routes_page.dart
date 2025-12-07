import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RecommendedRoutesPage extends StatefulWidget {
  const RecommendedRoutesPage({super.key});

  @override
  State<RecommendedRoutesPage> createState() => _RecommendedRoutesPageState();
}

class _RecommendedRoutesPageState extends State<RecommendedRoutesPage> {
  Future<Map<String, dynamic>>? _adviceFuture;

  @override
  void initState() {
    super.initState();
    // Fetch advice for a dummy vendor ID
    _adviceFuture = ApiService().getRouteAdvice('VENDOR_001');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_back_ios,
                        size: 20, color: Colors.blueGrey),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "RECOMMENDED\nROUTES",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF263238),
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // AI Advice Section (Dynamic)
              FutureBuilder<Map<String, dynamic>>(
                future: _adviceFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('Error loading advice: ${snapshot.error}',
                          style: TextStyle(color: Colors.red.shade900)),
                    );
                  }

                  final data = snapshot.data!;
                  final recommendation =
                      data['aiRecommendation'] ?? 'No advice';
                  final model = data['aiModelUsed'] ?? 'Unknown AI';

                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade400, Colors.blue.shade600],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.auto_awesome, color: Colors.white),
                            const SizedBox(width: 10),
                            Text(
                              "AI ADVICE ($model)",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          recommendation,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 25),

              // Section Title
              const Text(
                "RECENT ROUTES",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueGrey,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 15),

              // Route List
              Expanded(
                child: ListView(
                  children: const [
                    _RouteTile(
                      title: "Route A - City Park",
                      subtitle: "Busy, Sunny",
                      count: "301",
                      icon: Icons.location_on_outlined,
                    ),
                    _RouteTile(
                      title: "Downtown Market",
                      subtitle: "Moderate, Cloudy",
                      count: "207",
                      icon: Icons.storefront_outlined,
                    ),
                    _RouteTile(
                      title: "Snack Area",
                      subtitle: "2 successful",
                      count: "102",
                      icon: Icons.fastfood_outlined,
                    ),
                    _RouteTile(
                      title: "Residential Zone",
                      subtitle: "Quiet",
                      count: "089",
                      icon: Icons.home_work_outlined,
                    ),
                  ],
                ),
              ),

              // Start Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF90CAF9),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    "START",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
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

class _RouteTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String count;
  final IconData icon;

  const _RouteTile({
    required this.title,
    required this.subtitle,
    required this.count,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: Colors.blue.shade400, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF37474F),
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.blueGrey.shade300,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            count,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey.shade400,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
