import 'package:flutter/material.dart';
import 'package:password_manager/screens/profile/profile_page.dart';
import 'package:password_manager/screens/settings/update_password.dart';
import 'package:password_manager/widgets/custom_bottom_nav_bar.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'delete_account.dart';

// The main Settings Screen Widget
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isBiometricEnabled = false; // State for the switch
  int _selectedIndex = 4;
  int _autoLockMinutes = 1;
  dynamic _profileImage;

  void _onTabTapped(int index) {
    setState(() => _selectedIndex = index);
  }


  @override
  void initState() {
    super.initState();
    _loadBiometricPreference();
  }


  Future<void> _loadBiometricPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isBiometricEnabled = prefs.getBool('biometric_enabled') ?? false;
    });
  }

  Future<void> _updateBiometricPreference(bool enabled) async {
    final auth = LocalAuthentication();
    bool canCheck = await auth.canCheckBiometrics;

    if (!canCheck) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Biometric authentication not available')),
      );
      return;
    }

    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: enabled
            ? 'Enable biometric login'
            : 'Authenticate to disable biometric login',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      print("Auth error: $e");
    }

    if (authenticated) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('biometric_enabled', enabled);
      setState(() => _isBiometricEnabled = enabled);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Authentication failed')),
      );
    }
  }

  void _showAutoLockBottomSheet() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Select Auto-Lock Timer',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF328E6E),
                ),
              ),
            ),
            _buildAutoLockOptionTile(context, 1),
            _buildAutoLockOptionTile(context, 3),
            _buildAutoLockOptionTile(context, 5),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildAutoLockOptionTile(BuildContext context, int minutes) {
    return ListTile(
      title: Text(
        '$minutes minute${minutes > 1 ? 's' : ''}',
        style: TextStyle(
          color: _autoLockMinutes == minutes ? Color(0xFF328E6E) : Colors.black87,
          fontWeight: _autoLockMinutes == minutes ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      leading: _autoLockMinutes == minutes
          ? const Icon(Icons.check_circle, color: Color(0xFF328E6E))
          : const Icon(Icons.circle_outlined, color: Colors.grey),
      onTap: () {
        setState(() => _autoLockMinutes = minutes);
        Navigator.of(context).pop();
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      extendBody: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF3F4F6),
        leading: const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Icon(Icons.inventory_2_outlined, color: Colors.deepPurple),
        ),
        title: const Text(
          'ConceptX',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF328E6E),
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
                  builder: (context) => ProfilePopup(),
                );
              },
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[300],
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!) // User-selected image
                    :null, // Default image
                child: _profileImage == null
                    ? Icon(Icons.person, size: 30, color: Colors.grey[600])
                    : null,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          // Header Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Settings',
                  style: textTheme.titleLarge?.copyWith(
                    color: const Color(0xFF328E6E),
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Manage your account and security preferences',
                  style: textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          // Security Section Header
          _buildSectionHeader('Security'),

          // Change Master Password Card
          _buildSettingsCard(
            context: context,
            title: 'Change Master Password',
            subtitle: 'Update your vault\'s master password',
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () async {
              final LocalAuthentication auth = LocalAuthentication();
              bool isAuthenticated = false;

              try {
                isAuthenticated = await auth.authenticate(
                  localizedReason: 'Please authenticate to update your password',
                  options: const AuthenticationOptions(
                    biometricOnly: true,
                    stickyAuth: true,
                  ),
                );
              } catch (e) {
                print('Authentication error: $e');
              }

              if (isAuthenticated) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  builder: (context) => Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: const SingleChildScrollView(child: UpdatePassword()),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Authentication failed')),
                );
              }
            },
            titleColor: Color(0xFF67AE6E), // Set title color
          ),

          // Biometric Login Card
          _buildSettingsCard(
            context: context,
            title: 'Biometric Login',
            subtitle: 'Use Fingerprint',
            trailing: Switch(
              value: _isBiometricEnabled,
              onChanged: (bool value) {
                _updateBiometricPreference(value);
              },
              activeColor: Color(0xFF328E6E),
            ),
            onTap: () {
              _updateBiometricPreference(!_isBiometricEnabled);
            },
            titleColor: Color(0xFF67AE6E),
          ),


          // 2FA Card
          _buildSettingsCard(
            context: context,
            title: '2-Step Verification',
            subtitle: 'Setup Two-Factor Authentication',
            trailing: const Icon(Icons.close, color: Colors.red),
            onTap: () {
              print('Biometric Login toggled by card tap: $_isBiometricEnabled');
            },
            titleColor: Color(0xFF67AE6E),
          ),

          // Auto-Lock Timer Card
          _buildSettingsCard(
            context: context,
            title: 'Auto-Lock Timer',
            subtitle: 'Currently set to $_autoLockMinutes minute${_autoLockMinutes > 1 ? 's' : ''}',
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () => _showAutoLockBottomSheet(),
            titleColor: Color(0xFF67AE6E),
          ),

          // Data Section Header
          _buildSectionHeader('Data'),

          // Export Vault Card
          _buildSettingsCard(
            context: context,
            title: 'Export Vault',
            subtitle: 'Download encrypted backup',
            trailing: Icon(Icons.download_outlined, color: Colors.grey[600]),
            onTap: () {
              // Perform export action
              print('Export Vault tapped');
            },
            titleColor: Color(0xFF67AE6E),
          ),

          // Delete Account Card
          _buildSettingsCard(
            context: context,
            // Apply red color to the title text
            titleWidget: Text(
              'Delete Account',
              style: textTheme.titleMedium?.copyWith(color: Colors.red),
            ),
            subtitle: 'Permanently remove all data',
            // Apply red color to the icon
            trailing: const Icon(Icons.delete_outline, color: Colors.red),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => const DeleteAccount(),
                );
              }
          ),

          const SizedBox(height: 20), // Add some padding at the bottom
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onTabTapped,
      ),
    );
  }

  // Helper Widget for Section Headers
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0, bottom: 8.0),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelLarge?.
        copyWith(color: const Color(0xFF328E6E)),
      ),
    );
  }

  // Helper Widget for creating the setting item cards
  Widget _buildSettingsCard({
    required BuildContext context,
    String? title, // Use String for title by default
    Widget? titleWidget, // Allow custom widget for title (e.g., for red text)
    required String subtitle,
    required Widget trailing,
    required VoidCallback? onTap, // Make onTap nullable for switch case
    Color? titleColor, // Added titleColor parameter
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: -1,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Material( // Use Material for InkWell splash effect
        color: Colors.transparent, // Ensure Material is transparent
        child: InkWell(
          onTap: onTap, // Assign the onTap handler
          borderRadius: BorderRadius.circular(10.0), // Match container's border radius
          child: ListTile(
            // Use titleWidget if provided, otherwise use default Text with title
            title: titleWidget ??
                Text(
                  title ?? '',
                  style: textTheme.titleMedium?.copyWith(color: titleColor), // Apply title color
                ),
            subtitle: Text(subtitle, style: textTheme.bodyMedium),
            trailing: trailing,
            // onTap for ListTile should be null if InkWell handles it,
            // but it's needed here if the trailing widget itself isn't interactive
            // However, for consistency with the Switch case, keep it null if the InkWell handles it.
            // If the entire row should be tappable *even with the switch*, keep the InkWell.
            // If only the switch should be interactive, remove InkWell and assign onTap to ListTile
            onTap: (trailing is Switch) ? null : onTap,
          ),
        ),
      ),
    );
  }
}

