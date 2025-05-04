import 'package:flutter/material.dart';
import 'package:password_manager/screens/profile_page.dart';
import '../widgets/custom_bottom_nav_bar.dart';

class PasswordGeneratorWidget extends StatefulWidget {
  @override
  _PasswordGeneratorWidgetState createState() => _PasswordGeneratorWidgetState();
}

class _PasswordGeneratorWidgetState extends State<PasswordGeneratorWidget> {
  double _passwordLength = 15;
  bool _includeUppercase = true;
  bool _includeLowercase = false;
  bool _includeDigits = true;
  bool _includeSpecial = false;

  String _generatedPassword = "TI65431EQYQFA9";
  int _selectedIndex = 3;

  void _onTabTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF328E6E),
        leading: const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Icon(Icons.inventory_2_outlined, color: Colors.deepPurple),
        ),
        title: const Text(
          'ConceptX',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
              child: const CircleAvatar(
                backgroundImage: AssetImage('assets/user.jpg'),
                radius: 18,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            top: -150,
            left: -100,
            right: -100,
            child: Container(
              height: 250,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.elliptical(300, 100),
                ),
                color: Color(0xFF328E6E),
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFFE1EEBC),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      _generatedPassword,
                      style: const TextStyle(
                          color: Color(0xFF328E6E),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[400],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    "Poor password strength",
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "Customize password",
                  style: TextStyle(color: Color(0xFF328E6E), fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Password length",
                      style: TextStyle(color: Color(0xFF328E6E)),
                    ),
                    Text(
                      _passwordLength.toInt().toString(),
                      style: const TextStyle(color: Color(0xFF328E6E)),
                    ),
                  ],
                ),
                Slider(
                  value: _passwordLength,
                  min: 4,
                  max: 32,
                  divisions: 28,
                  activeColor: Color(0xFF328E6E),
                  inactiveColor: Colors.grey,
                  onChanged: (value) {
                    setState(() {
                      _passwordLength = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                _buildCheckboxTile("Lowercase letters (a-z)", _includeLowercase,
                        (val) => setState(() => _includeLowercase = val)),
                _buildCheckboxTile("Uppercase letters (A-Z)", _includeUppercase,
                        (val) => setState(() => _includeUppercase = val)),
                _buildCheckboxTile("Digits (0-9)", _includeDigits,
                        (val) => setState(() => _includeDigits = val)),
                _buildCheckboxTile("Special characters (@*\$#!/)", _includeSpecial,
                        (val) => setState(() => _includeSpecial = val)),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF328E6E),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.white, size: 30),
                        onPressed: () {
                          // Add logic to generate a new password
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Copy password logic
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF328E6E),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20), // Bigger padding
                        minimumSize: const Size(250, 56), // Minimum size for consistent button sizing
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                      child: const Text(
                        "Copy password",
                        style: TextStyle(fontSize: 18, color: Colors.white), // Bigger text
                      ),
                    ),

                  ],
                ),
                const SizedBox(height: 80), // For spacing above bottom nav
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onTabTapped,
      ),
    );
  }

  Widget _buildCheckboxTile(String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(color: Color(0xFF328E6E))),
      value: value,
      onChanged: onChanged,
      activeColor: Color(0xFF328E6E),
    );
  }
}
