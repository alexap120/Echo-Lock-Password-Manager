import 'package:animated_expandable_fab/expandable_fab/action_button.dart';
import 'package:animated_expandable_fab/expandable_fab/expandable_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:password_manager/screens/profile_page.dart';
import '../widgets/custom_bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> items = [
    {'title': 'Login A', 'email': 'someEmail@gmail.com', 'shared': false},
    {'title': 'Login B', 'email': 'someEmail@gmail.com', 'shared': false},
    {'title': 'Login C', 'email': 'someEmail@gmail.com', 'shared': true},
    {'title': 'Login D', 'email': 'someEmail@gmail.com', 'shared': false},
    {'title': 'Login E', 'email': 'someEmail@gmail.com', 'shared': false},
    {'title': 'Login F', 'email': 'someEmail@gmail.com', 'shared': true},
    {'title': 'Login G', 'email': 'someEmail@gmail.com', 'shared': false},
    {'title': 'Login H', 'email': 'someEmail@gmail.com', 'shared': false},
  ];

  void _onTabTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Add this line
      backgroundColor: Colors.grey[100],
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
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 1,
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.05),
                    spreadRadius: -1,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Text(
                  item['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF90C67C), // <-- set title color
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['email'],
                      style: const TextStyle(
                        color: Colors.grey, // <-- set email color
                      ),
                    ),
                    if (item['shared']) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: const [
                          Text("Shared by", style: TextStyle(fontSize: 12, color: Colors.grey)),
                          SizedBox(width: 6),
                          CircleAvatar(
                            radius: 10,
                            backgroundImage: AssetImage('assets/user1.jpg'),
                          ),
                          SizedBox(width: 4),
                          CircleAvatar(
                            radius: 10,
                            backgroundImage: AssetImage('assets/user2.jpg'),
                          ),
                        ],
                      ),
                    ]
                  ],
                ),
                trailing: const Icon(
                  Icons.more_horiz,
                  size: 28, // <- increase size to make it look bolder
                ),
              ),
            ),
          );
        },
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
              // Add your action here
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
              // Add your action here
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
              // Add your action here
            },
          ),
        ],
      ),
    );
  }
}