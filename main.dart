import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WeatherHomePage(),
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  final List<String> _cities = ['Ajloun', 'Irbid', 'Amman', 'Zarqa'];
  String _selectedCity = 'Ajloun';
  WeatherModel? _weather;
  List<String> _favoriteCities = [];
  int _currentTabIndex = 0;

  final WeatherService _weatherService = WeatherService();

  void _fetchWeather() async {
    final weather = await _weatherService.getWeather(_selectedCity);
    setState(() {
      _weather = weather;
    });
  }

  void _clearWeather() {
    setState(() {
      _weather = null;
    });
  }

  void _addToFavorites() {
    if (_weather != null &&
        !_favoriteCities.contains(_selectedCity)) {
      setState(() {
        _favoriteCities.add(_selectedCity);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$_selectedCity added to favorites')),
      );
    }
  }

  void _removeFromFavorites(String city) {
    setState(() {
      _favoriteCities.remove(city);
    });
  }

  Widget _buildHomePage() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select a City:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          DropdownButton<String>(
            value: _selectedCity,
            isExpanded: true,
            items: _cities.map((String city) {
              return DropdownMenuItem<String>(
                value: city,
                child: Text(city),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedCity = value!;
              });
            },
          ),
          const SizedBox(height: 30),
          Center(
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: _fetchWeather,
                  child: const Text('Fetch Weather'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _clearWeather,
                  child: const Text('Clear Weather'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _addToFavorites,
                  child: const Text('Add to Favorites'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          if (_weather != null)
            Column(
              children: [
                Text(
                  'Weather in $_selectedCity',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  '${_weather!.temperature.toStringAsFixed(1)} °C',
                  style: const TextStyle(fontSize: 18),
                ),
                Text(_weather!.description),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildFavoritesPage() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Favorite Cities:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          if (_favoriteCities.isEmpty)
            const Text('No favorite cities added.'),
          for (var city in _favoriteCities)
            ListTile(
              leading: const Icon(Icons.location_city),
              title: Text(city),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _removeFromFavorites(city),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProfilePage() {
    return const Center(
      child: Text(
        'Profile Page',
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  Widget _buildCurrentTab() {
    switch (_currentTabIndex) {
      case 0:
        return _buildHomePage();
      case 1:
        return _buildFavoritesPage();
      case 2:
        return _buildProfilePage();
      default:
        return _buildHomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🌤️ Weather Application'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: _buildCurrentTab(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        onTap: (index) {
          setState(() {
            _currentTabIndex = index;
          });
        },
        selectedItemColor: Colors.blue,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class WeatherModel {
  final double temperature;
  final String description;

  WeatherModel({required this.temperature, required this.description});

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
    );
  }
}

class WeatherService {
  final String apiKey = '9a0bfd0734b981f82cbb6fe21af005ee';

  Future<WeatherModel?> getWeather(String city) async {
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return WeatherModel.fromJson(data);
    } else {
      return null;
    }
  }

  Future<void> postExample() async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts');
    final response = await http.post(
      url,
      body: jsonEncode({'title': 'foo', 'body': 'bar', 'userId': 1}),
      headers: {'Content-Type': 'application/json'},
    );
    print('POST status: ${response.statusCode}');
    print('POST body: ${response.body}');
  }

  Future<void> putExample() async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts/1');
    final response = await http.put(
      url,
      body: jsonEncode({'id': 1, 'title': 'updated', 'body': 'content', 'userId': 1}),
      headers: {'Content-Type': 'application/json'},
    );
    print('PUT status: ${response.statusCode}');
    print('PUT body: ${response.body}');
  }

  Future<void> patchExample() async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts/1');
    final response = await http.patch(
      url,
      body: jsonEncode({'title': 'patched title'}),
      headers: {'Content-Type': 'application/json'},
    );
    print('PATCH status: ${response.statusCode}');
    print('PATCH body: ${response.body}');
  }

  Future<void> deleteExample() async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts/1');
    final response = await http.delete(url);
    print('DELETE status: ${response.statusCode}');
    print('DELETE body: ${response.body}');
  }
}
