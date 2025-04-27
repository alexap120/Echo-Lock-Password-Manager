import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/screens/home.dart';
import 'package:password_manager/screens/login.dart';
import 'package:password_manager/screens/overview.dart';
import 'package:password_manager/screens/settings.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 70,
          child: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 8,
            color: Color(0xFFF3F4F6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavBarItem(Icons.home, 'Home', 0, context),
                _buildNavBarItem(Icons.data_usage_rounded, 'Overview', 1, context),
                const SizedBox(width: 50), // space for FAB
                _buildNavBarItem(Icons.search, 'Search', 3, context),
                _buildNavBarItem(Icons.settings, 'Settings', 4, context),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 15,
          child: SizedBox(
            width: 65,  // Make it bigger
            height: 65, // Make it bigger
            child: FloatingActionButton(
              shape: const CircleBorder(),
              backgroundColor: const Color(0xFF328E6E),
              elevation: 8,
              onPressed: () {},
              child: const Icon(
                Icons.add,
                size: 34, // Also make the icon a bit bigger
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavBarItem(IconData icon, String label, int index, BuildContext context) {
    return InkWell(
      onTap: () {
        onItemTapped(index);  // Update the selected index when an item is tapped
        _handleNavBarAction(index, context);  // Call the function to perform actions based on the index
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: selectedIndex == index
                ? const Color(0xFF90C67C) // Selected icon color
                : Colors.grey, // Unselected icon color (Change this to any color you want)
          ),
          Text(
            label,
            style: TextStyle(
              color: selectedIndex == index
                  ? const Color(0xFF90C67C) // Selected text color
                  : Colors.grey, // Unselected text color (Change this too)
            ),
          ),
        ],
      ),
    );
  }
}

// Handle the action for each navbar item
void _handleNavBarAction(int index, BuildContext context) {
  switch (index) {
    case 0:
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
      break;
    case 1:
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );
      break;
    case 2:
    // Search action
      print("Search tapped");
      // Navigate to Search screen or perform any action
      break;
    case 4:
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SettingsScreen()),
      );
      break;
    default:
      break;
  }
}