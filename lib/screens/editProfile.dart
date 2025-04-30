import 'package:flutter/material.dart';

import '../widgets/custom_input_field.dart';
// To handle image picking (add 'image_picker' to your pubspec.yaml)
// import 'package:image_picker/image_picker.dart';
// import 'dart:io'; // Required if using File for image

// Define the primary color from the design (adjust hex code if needed)
const Color primaryColor = Color(0xFF1ABC9C); // Example Teal color
const Color textFieldBackgroundColor = Color(0xFFF2F2F7); // Light greyish background
const Color labelColor = Colors.black87;
const Color hintTextColor = Colors.black54;

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Controllers for text fields
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;


  // Placeholder for the selected image file (uncomment if using image_picker)
  // File? _profileImage;
  // final ImagePicker _picker = ImagePicker(); // Image picker instance

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'Alexandre Pereira');
    _usernameController = TextEditingController(text: 'alexP123');
    _phoneController = TextEditingController(text: '+44 1632 960860');
    _emailController = TextEditingController(text: 'alex@example.com');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // --- Function to handle image picking ---
  Future<void> _pickImage() async {
    // --- Add Image Picking Logic Here ---
    // Example using image_picker (uncomment imports and add package)
    /*
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
    */
    print("Edit profile image tapped!");
    // You can show a bottom sheet or dialog to choose camera/gallery
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image editing not implemented yet.')),
    );
  }


  // Helper method to build styled labels
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: labelColor,
        ),
      ),
    );
  }

  // Helper method for common InputDecoration
  InputDecoration _buildInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: hintTextColor),
      filled: true,
      fillColor: textFieldBackgroundColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none, // No border line
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: primaryColor, width: 1.5), // Highlight focus
      ),
    );
  }

  // --- Widget for Profile Image ---
  Widget _buildProfileImage() {
    return Center( // Center the profile image section horizontally
      child: Stack(
        children: <Widget>[
          CircleAvatar(
            radius: 60, // Adjust size as needed
            backgroundColor: Colors.grey[300], // Placeholder background
            // --- Uncomment to display selected image ---
            // backgroundImage: _profileImage != null
            //     ? FileImage(_profileImage!) // Display selected image
            //     : null, // Or a default asset image: AssetImage('assets/default_avatar.png'),
            child: _profileImage == null
                ? Icon(
              Icons.person, // Placeholder icon
              size: 60,
              color: Colors.grey[600],
            )
                : null, // Don't show icon if image is present
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector( // Make the icon tappable as well
              onTap: _pickImage,
              child: Container(
                padding: const EdgeInsets.all(6), // Padding inside the small circle
                decoration: const BoxDecoration(
                  color: primaryColor, // Use the primary color for the background
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.edit, // Edit icon (pencil)
                  // Icons.camera_alt, // Alternative: camera icon
                  color: Colors.white,
                  size: 20, // Adjust icon size
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Color(0xFFF3F4F6),
        elevation: 0,
        foregroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: const Color(0xFF328E6E),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // --- Profile Image Section ---
              _buildProfileImage(), // Add the profile image widget here
              const SizedBox(height: 30), // Space between image and first field

              // --- Name Field ---
              CustomInputField(
                label: 'Name',
          //      hintText: '',
                controller: _nameController,
                keyboardType: TextInputType.text,
          //      icon: Icons.person,
              ),
              const SizedBox(height: 16),

              // --- Username Field ---
              CustomInputField(
                label: 'Username',
         //      hintText: '',
                controller: _usernameController,
                keyboardType: TextInputType.text,
         //       icon: Icons.person,
              ),
              const SizedBox(height: 16),


              // --- Phone Number Field ---
              CustomInputField(
                label: 'Phone Number',
          //      hintText: '',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
          //      icon: Icons.phone,
              ),
              const SizedBox(height: 16),

              // --- Email Field ---
              CustomInputField(
                label: 'Email',
        //        hintText: '',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
        //        icon: Icons.email_outlined,
              ),
              const SizedBox(height: 125),

              // --- Save Button ---
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final name = _nameController.text;
                    final username = _usernameController.text;
                    final phone = _phoneController.text;
                    final email = _emailController.text;
                    // Include image saving logic if _profileImage is used

                    print('Saving Profile:');
                    print('Name: $name');
                    print('Username: $username');
                    print('Phone: $phone');
                    print('Email: $email');
                    // print('Image Path: ${_profileImage?.path}'); // If using image

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile Saved!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF328E6E), // Primary color
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text('Save'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Placeholder for the image state variable (needed if uncommenting image logic)
  dynamic _profileImage; // Use 'File?' if using dart:io
}