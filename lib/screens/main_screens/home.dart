import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:password_manager/screens/login_items/add_card.dart';
import 'package:password_manager/screens/login_items/add_note.dart';
import 'package:password_manager/screens/profile/profile_page.dart';
import '../../widgets/custom_bottom_nav_bar.dart';
import '../login_items/add_login.dart';
import '../login_items/login_item_details.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedChip = 'All'; // Track which chip is selected


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
    final filteredItems = items
        .where((item) =>
    item['title'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
        item['email'].toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

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
              height: 250, // Adjust height as needed
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.elliptical(300, 100),
                ),
                color: Color(0xFF328E6E),
              ),
            ),
          ),
          // Column for the search bar and the list
          Column(
            children: [
              // Search Bar
              // Search Bar + Filter Chips
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search any items',
                        hintStyle: const TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 36,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          FilterChip(
                            label: Text(
                              'All',
                              style: TextStyle(color: _selectedChip == 'All' ? Colors.white : Colors.grey),
                            ),
                            selected: _selectedChip == 'All',
                            onSelected: (_) {
                              setState(() {
                                _selectedChip = 'All';
                              });
                            },
                            selectedColor: const Color(0xFF328E6E),
                            backgroundColor: Colors.grey[100],
                            shape: const StadiumBorder(),
                          ),
                          const SizedBox(width: 8),
                          FilterChip(
                            label: Text(
                              'Login',
                              style: TextStyle(color: _selectedChip == 'Login' ? Colors.white : Colors.grey),
                            ),
                            selected: _selectedChip == 'Login',
                            onSelected: (_) {
                              setState(() {
                                _selectedChip = 'Login';
                              });
                            },
                            selectedColor: const Color(0xFF328E6E),
                            backgroundColor: Colors.grey[100],
                            shape: const StadiumBorder(),
                          ),
                          const SizedBox(width: 8),
                          FilterChip(
                            label: Text(
                              'Secure Note',
                              style: TextStyle(color: _selectedChip == 'Secure Note' ? Colors.white : Colors.grey),
                            ),
                            selected: _selectedChip == 'Secure Note',
                            onSelected: (_) {
                              setState(() {
                                _selectedChip = 'Secure Note';
                              });
                            },
                            selectedColor: const Color(0xFF328E6E),
                            backgroundColor: Colors.grey[100],
                            shape: const StadiumBorder(),
                          ),
                          const SizedBox(width: 8),
                          FilterChip(
                            label: Text(
                              'Card',
                              style: TextStyle(color: _selectedChip == 'Card' ? Colors.white : Colors.grey),
                            ),
                            selected: _selectedChip == 'Card',
                            onSelected: (_) {
                              setState(() {
                                _selectedChip = 'Card';
                              });
                            },
                            selectedColor: const Color(0xFF328E6E),
                            backgroundColor: Colors.grey[100],
                            shape: const StadiumBorder(),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
              // Login Cards
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];
                    return Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 1,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => LoginDetailsBottomSheet(
                              serviceName: item['title'],
                              email: item['email'],
                              password: "superSecret123", // You can replace this dynamically if needed
                              sharedWith: item['shared']
                                  ? ["Diego Morata", "Salem Ahmed"] // Dummy data for now
                                  : [],
                              isPasswordWeak: true, // You can make this dynamic as well if needed
                            ),
                          );
                        },

                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        title: Text(
                          item['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF90C67C),
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['email'],
                              style: const TextStyle(color: Colors.grey),
                            ),
                            if (item['shared']) ...[
                              const SizedBox(height: 4),
                              Row(
                                children: const [
                                  Text("Shared by", style: TextStyle(fontSize: 12, color: Colors.grey)),
                                  SizedBox(width: 6),
                                  CircleAvatar(radius: 10, backgroundImage: AssetImage('assets/user1.jpg')),
                                  SizedBox(width: 4),
                                  CircleAvatar(radius: 10, backgroundImage: AssetImage('assets/user2.jpg')),
                                ],
                              ),
                            ]
                          ],
                        ),
                        trailing: const Icon(Icons.more_horiz, size: 28),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onTabTapped,
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: const Color(0xFF328E6E),
        foregroundColor: Colors.white,
        spacing: 8,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.key),
            backgroundColor: const Color(0xFF67AE6E),
            foregroundColor: Colors.white,
            label: 'Add Login',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddLoginPopup()),
              );
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.note_add_outlined),
            backgroundColor: const Color(0xFF67AE6E),
            foregroundColor: Colors.white,
            label: 'Add Note',
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
            backgroundColor: const Color(0xFF67AE6E),
            label: 'Add Card',
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
}