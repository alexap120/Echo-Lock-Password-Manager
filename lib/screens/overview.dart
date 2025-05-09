import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:password_manager/screens/profile_page.dart';

import '../widgets/custom_bottom_nav_bar.dart';
import 'add_card.dart';
import 'add_login.dart';
import 'add_note.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 1;

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Color(0xFF328E6E),
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Icon(Icons.inventory_2_outlined, color: Colors.deepPurple),
        ),
        title: const Text(
          'ConceptX',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => ProfilePopup(
                    fullName: 'Alexandre Pereira',
                    username: 'AlexP123',
                    email: 'alex@example.com',
                    memberSince: 'March 2024',
                    profileImageUrl: 'https://your-image-url.com/photo.jpg',
                  ),
                );
              },
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/user.jpg'),
                radius: 18,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Circular green background (oversized and positioned)
          Positioned(
            top: -150,
            left: -100,
            right: -100,
            child: Container(
              height: 500,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.elliptical(300, 100), // controls arc curvature
                ),
                color: Color(0xFF328E6E),
              ),
            ),
          ),

          // Main content
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [ // Adjust for visual space below the arc
                const SizedBox(height: 30),
                const Text(
                  'Password Health',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.8,
                  children: [
                    _buildHealthCard(Icons.key, '42', 'Total', Colors.blue),
                    _buildHealthCard(Icons.warning_amber_rounded, '8', 'Weak', Colors.orange),
                    _buildHealthCard(Icons.error_outline, '3', 'Compromised', Colors.red),
                    _buildHealthCard(Icons.refresh, '5', 'Reused', Colors.orange),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Most Used Logins',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF328E6E),
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 12),
                _buildLoginTile('Google Account', 'john.doe@gmail.com', Icons.g_mobiledata),
                _buildLoginTile('Amazon', 'john.doe@email.com', Icons.shopping_bag_outlined),
                _buildLoginTile('Netflix', 'john.doe@email.com', Icons.tv),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onTabTapped,
      ),

      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Color(0xFF328E6E),
        foregroundColor: Colors.white,
        spacing: 8,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.key),
            backgroundColor: Color(0xFF67AE6E),
            foregroundColor: Colors.white,
            label: 'Add Login',
            labelStyle: const TextStyle(
              color: Color(0xFF90C67C), // Custom text color
              fontWeight: FontWeight.bold, // Custom font weight
              fontSize: 16.0, // Custom font size
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddLoginPopup()),
              );
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.note_add_outlined),
            backgroundColor: Color(0xFF67AE6E),
            foregroundColor: Colors.white,
            label: 'Add Note',
            labelStyle: const TextStyle(
              color: Color(0xFF90C67C), // Custom text color
              fontWeight: FontWeight.bold, // Custom font weight
              fontSize: 16.0, // Custom font size
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddNotePopup()),
              );
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.add_card_outlined),
            foregroundColor: Colors.white,
            backgroundColor: Color(0xFF67AE6E),
            label: 'Add Card',
            labelStyle: const TextStyle(
              color: Color(0xFF90C67C), // Custom text color
              fontWeight: FontWeight.bold, // Custom font weight
              fontSize: 16.0, // Custom font size
            ),
            onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                  ),
                  builder: (context) => const AddCardPopup(),
                );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHealthCard(IconData icon, String number, String label, Color iconColor) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.5),
            spreadRadius: -1,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: iconColor, size: 28),
              const SizedBox(width: 8),
              Text(
                number,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }


  Widget _buildLoginTile(String title, String email, IconData leadingIcon) {
    return Container(

      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.5),
            spreadRadius: -1,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey[300],
          child: Icon(leadingIcon, color: Colors.black),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF67AE6E)),
        ),
        subtitle: Text(email),
        onTap: () {},
      ),
    );
  }

}
