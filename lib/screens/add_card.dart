import 'package:flutter/material.dart';

class AddCardPopup extends StatelessWidget {
  const AddCardPopup({super.key});


  InputDecoration customUnderlineInput(String hint) {
    return InputDecoration(
      hintText: hint,
      border: const UnderlineInputBorder(),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF328E6E)),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF328E6E), width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title and Scan Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Add your card',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF328E6E)),
                ),
                IconButton(
                  icon: const Icon(Icons.photo_camera),
                  onPressed: () {
                    // implement scan card logic
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Card preview mockup
            Container(
              height: 180,
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: AssetImage('assets/card.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),

            // CARD NUMBER
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'CARD NUMBER',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 4),
            TextField(
              decoration: customUnderlineInput('4829 - 0921 - 8293 - 2837'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),

            // CARD HOLDER
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'CARD HOLDER NAME',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 4),
            TextField(
              decoration: customUnderlineInput('JOSEPH SMITH'),
            ),
            const SizedBox(height: 15),

            // EXPIRY & CVV
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'EXPIRES ON',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      SizedBox(height: 4),
                      TextField(
                        decoration: customUnderlineInput('02/28'),
                        keyboardType: TextInputType.datetime,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '3-DIGIT CVV',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      SizedBox(height: 4),
                      TextField(
                        decoration: customUnderlineInput('433'),
                        keyboardType: TextInputType.number,
                        obscureText: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // PIN Field
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'CARD PIN',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 4),
            TextField(
              decoration: customUnderlineInput('****'),
              keyboardType: TextInputType.number,
              obscureText: true,
            ),
            const SizedBox(height: 30),

            // Add Card Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close sheet after saving
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF328E6E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Add card',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}