
import 'package:flutter/material.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/screens/favorite.dart';
import 'package:weather_app/screens/home.dart'; // تأكد من مسار home الصحيح

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _currentIndex = 0;

  // قائمة المدن المفضلة
  final List<WeatherInfo> _favoriteCities = [];

  // دالة لإضافة مدينة إلى المفضلة
  void _addToFavorites(WeatherInfo weatherInfo) {
    if (!_favoriteCities.any((w) => w.cityName == weatherInfo.cityName)) {
      setState(() {
        _favoriteCities.add(weatherInfo);
      });
    }
  }

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      Home(onAddToFavorites: _addToFavorites),
     
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
