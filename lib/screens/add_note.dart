import 'package:flutter/material.dart';
import '../widgets/custom_input_field.dart';

class AddNotePopup extends StatefulWidget {
  @override
  State<AddNotePopup> createState() => _AddNotePopupState();
}

class _AddNotePopupState extends State<AddNotePopup> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF328E6E),
        elevation: 0,
        title: const Text("Add Note", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Positioned background container
            Positioned(
              top: -150,
              left: -100,
              right: -100,
              child: Container(
                height: 250, // Adjust height as needed
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.elliptical(300, 100),
                  ),
                  color: Color(0xFF328E6E),
                ),
              ),
            ),
            // Main content
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const SizedBox(height: 32),
                        CustomInputField(
                          label: 'Title',
                          controller: titleController,
                        ),
                        const SizedBox(height: 24),
                        CustomInputField(
                          label: 'Note',
                          controller: noteController,
                          minLines: 10,
                          maxLines: 15,
                        ),
                      ],
                    ),
                  ),
                ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF328E6E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () {
                          // Save logic here
                        },
                        child: const Text(
                          "Save",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
        ),
    );
  }
}
