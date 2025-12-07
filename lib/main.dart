import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/home_page.dart';
import 'pages/recommended_routes_page.dart';
import 'pages/tracking_page.dart';
import 'pages/login_page.dart';
import 'services/api_service.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter UI Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F9FC),
        useMaterial3: true,
      ),
      home: FutureBuilder<String?>(
        future: ApiService().getToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          }
          if (snapshot.hasData && snapshot.data != null) {
            return const MainScreen();
          }
          return const LoginPage();
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // 0: Recommended, 1: Home (QRIS), 2: Tracking
  int _currentIndex = 1;
  int _bottomIndex = 0;

  final List<Widget> _pages = [
    const RecommendedRoutesPage(),
    const HomePage(),
    const TrackingPage(),
  ];

  void _onFloatingMenuTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // We use a Stack to float the menu above the bottom nav
      body: Stack(
        children: [
          // 1. The Main Page Content
          Positioned.fill(
            bottom: kBottomNavigationBarHeight +
                140, // Reserve space for floating menu + nav
            child: IndexedStack(
              index: _currentIndex,
              children: _pages,
            ),
          ),

          // 2. The Floating Menu (3 Big Buttons)
          Positioned(
            bottom: kBottomNavigationBarHeight,
            left: 0,
            right: 0,
            child: Container(
              height: 140,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFFF5F9FC).withOpacity(0.0),
                    const Color(0xFFF5F9FC),
                  ],
                  stops: const [0.0, 0.3],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _FloatingMenuButton(
                    label: "RECOMMENDED\nROUTES",
                    icon: Icons.map_outlined,
                    isSelected: _currentIndex == 0,
                    onTap: () => _onFloatingMenuTapped(0),
                  ),
                  _FloatingMenuButton(
                    label: "QRIS\nTRACKING",
                    icon: Icons.qr_code_scanner,
                    isSelected: _currentIndex == 1,
                    onTap: () => _onFloatingMenuTapped(1),
                  ),
                  _FloatingMenuButton(
                    label: "START LOCATION\nTRACKING",
                    icon: Icons.satellite_alt,
                    isSelected: _currentIndex == 2,
                    onTap: () => _onFloatingMenuTapped(2),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // 3. Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 0,
        selectedItemColor: Colors.blue.shade300,
        unselectedItemColor: Colors.blueGrey.shade200,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        currentIndex:
            _bottomIndex, // Always highlight Home for this demo structure
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "HOME",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "SEARCH",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: "SETTINGS",
          ),
        ],
        onTap: (index) {
          setState(() {
            _bottomIndex = index;
          });
          if (index == 0) {
            _onFloatingMenuTapped(1); // Go to Home (QRIS Tracking)
          } else {
            // Placeholder for Search (1) and Settings (2)
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  index == 1 ? "Search coming soon!" : "Settings coming soon!",
                ),
                duration: const Duration(seconds: 1),
              ),
            );
          }
        },
      ),
    );
  }
}

class _FloatingMenuButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _FloatingMenuButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(color: Colors.blue.shade200, width: 2)
              : Border.all(color: Colors.transparent),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color:
                  isSelected ? Colors.blue.shade400 : Colors.blueGrey.shade300,
            ),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.blue.shade400 : Colors.blueGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
