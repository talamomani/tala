import 'package:flutter/material.dart';
import 'package:weather_app/models/weather.dart';

class Favorite extends StatefulWidget {
  final List<WeatherInfo> favorite;
  final Function(WeatherInfo) onRemoveFavorite;

  const Favorite({
    Key? key,
    required this.favorite,
    required this.onRemoveFavorite,
  }) : super(key: key);

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Cities'),
        backgroundColor: Colors.blue,
      ),
      body: widget.favorite.isEmpty
          ? const Center(child: Text("No favorite cities added."))
          : ListView.builder(
              itemCount: widget.favorite.length,
              itemBuilder: (context, index) {
                final item = widget.favorite[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(
                      item.cityName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Text('${item.description} - ${item.temperatureC}°C'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        widget.onRemoveFavorite(item);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}

