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
      home: WeatherHome(),
    );
  }
}

class WeatherHome extends StatefulWidget {
  const WeatherHome({super.key});

  @override
  State<WeatherHome> createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {
  final List<String> _cities = ['Ajloun', 'Irbid', 'Amman', 'Zarqa'];
  String _selectedCity = 'Ajloun';
  String _weatherDescription = '';
  double? _temperature;
  String _city = '';
  List<String> _favoriteCities = [];
  int _selectedIndex = 0;

  final String apiKey = '9a0bfd0734b981f82cbb6fe21af005ee';

  Future<void> fetchWeather(String city) async {
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _city = city;
        _temperature = data['main']['temp'].toDouble();
        _weatherDescription = data['weather'][0]['description'];
      });
    } else {
      setState(() {
        _weatherDescription = 'City not found';
        _temperature = null;
        _city = '';
      });
    }
  }

  void _createTemperature() {
    fetchWeather(_selectedCity);
  }

  void _updateWeather() {
    fetchWeather(_selectedCity);
  }

  void _deleteWeather() {
    setState(() {
      _city = '';
      _temperature = null;
      _weatherDescription = '';
    });
  }

  void _onBottomNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _addToFavorites() {
    if (_city.isNotEmpty && !_favoriteCities.contains(_city)) {
      setState(() {
        _favoriteCities.add(_city);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$_city added to favorites')),
      );
    }
  }

  void _removeFromFavorites(String city) {
    setState(() {
      _favoriteCities.remove(city);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_selectedIndex == 0) {
      content = SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Select a City:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
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
              const SizedBox(height: 40),
              Center(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: _createTemperature,
                      child: const Text('Create Temperature'),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _updateWeather,
                      child: const Text('Update City Weather'),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _deleteWeather,
                      child: const Text('Delete City Weather'),
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
              if (_city.isNotEmpty)
                Column(
                  children: [
                    Text(
                      'Weather in $_city',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _temperature != null
                          ? '${_temperature!.toStringAsFixed(1)} °C'
                          : '',
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(_weatherDescription),
                  ],
                ),
            ],
          ),
        ),
      );
    } else if (_selectedIndex == 1) {
      content = Padding(
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
    } else {
      content = const Center(
        child: Text(
          'Profile Page',
          style: TextStyle(fontSize: 20),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('🌤️ Weather Application'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: content,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTapped,
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




