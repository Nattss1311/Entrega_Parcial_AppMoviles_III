import 'package:flutter/material.dart';
import '../appointments/presentation/screens/agenda_screen.dart';
import '../clients/presentation/screens/clients_screen.dart';
import '../dashboard/presentation/screens/dashboard_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    AgendaScreen(),
    ClientsScreen(),
    DashboardScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.route_outlined),
            selectedIcon: Icon(Icons.route_rounded),
            label: 'Agenda / Rutas',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline_rounded),
            selectedIcon: Icon(Icons.people_rounded),
            label: 'Clientes',
          ),
          NavigationDestination(
            icon: Icon(Icons.query_stats_rounded),
            selectedIcon: Icon(Icons.analytics_rounded),
            label: 'Métricas',
          ),
        ],
      ),
    );
  }
}
