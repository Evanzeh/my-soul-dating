import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Fake profiles for now - we'll connect Firestore next
  final List<Map<String, dynamic>> _profiles = [
    {
      'name': 'Aisha, 24',
      'location': 'Nairobi',
      'bio': 'Love hiking Karura & nyama choma',
      'image': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
    },
    {
      'name': 'Brian, 27',
      'location': 'Mombasa', 
      'bio': 'Software dev. Beach weekends',
      'image': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d',
    },
    {
      'name': 'Faith, 22',
      'location': 'Kisumu',
      'bio': 'Lake vibes + chapati Sundays',
      'image': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Soul'),
        backgroundColor: Colors.pink,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => authService.signOut(),
          ),
        ],
      ),
      body: _profiles.isEmpty
          ? Center(child: Text('No more profiles. Check back later!'))
          : Stack(
              children: [
                Dismissible(
                  key: Key(_profiles[_currentIndex]['name']),
                  onDismissed: (direction) {
                    setState(() {
                      if (direction == DismissDirection.endToStart) {
                        print('Noped ${_profiles[_currentIndex]['name']}');
                      } else {
                        print('Liked ${_profiles[_currentIndex]['name']}');
                      }
                      _profiles.removeAt(_currentIndex);
                    });
                  },
                  child: Card(
                    margin: EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                            child: Image.network(
                              _profiles[_currentIndex]['image'],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (c, e, s) => Container(color: Colors.grey),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _profiles[_currentIndex]['name'],
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              Text(_profiles[_currentIndex]['location']),
                              SizedBox(height: 8),
                              Text(_profiles[_currentIndex]['bio']),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FloatingActionButton(
                        heroTag: 'nope',
                        backgroundColor: Colors.white,
                        child: Icon(Icons.close, color: Colors.red, size: 32),
                        onPressed: () {
                          setState(() => _profiles.removeAt(_currentIndex));
                        },
                      ),
                      FloatingActionButton(
                        heroTag: 'like',
                        backgroundColor: Colors.pink,
                        child: Icon(Icons.favorite, color: Colors.white, size: 32),
                        onPressed: () {
                          setState(() => _profiles.removeAt(_currentIndex));
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
