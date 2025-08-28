import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cashback Card Demo',
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 100,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildSearchField(),
                const SizedBox(width: 12),
                _buildIconButton(Icons.notifications_none),
                _buildIconButton(Icons.shopping_cart_outlined),
              ],
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 16),
        children: const [
          CashbackCard(),
          SizedBox(height: 20),
          ShortcutIconsRow(),
          SizedBox(height: 20),
          SpecialHeaderRow(),
          SizedBox(height: 16),
          ImageRow(),
          SizedBox(height: 16),
          SectionHeaderRow(),
          SizedBox(height: 16),
          AdditionalImagesRow(),
          SizedBox(height: 16),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.message_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Expanded(
      child: Container(
        height: 45,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          children: [
            Icon(Icons.search, color: Colors.grey),
            SizedBox(width: 10),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                    hintText: "Search Product", border: InputBorder.none),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon) =>
      IconButton(icon: Icon(icon), onPressed: () {});
}

class CashbackCard extends StatelessWidget {
  const CashbackCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.deepPurpleAccent,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text("A Summer Surprise",
              style: TextStyle(color: Colors.white70, fontSize: 14)),
          SizedBox(height: 10),
          Text("Cashback 20%",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class ShortcutIconsRow extends StatelessWidget {
  const ShortcutIconsRow({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
        ShortcutItem(icon: Icons.flash_on, label: "Flash Deal"),
        ShortcutItem(icon: Icons.receipt_long, label: "Bill"),
        ShortcutItem(icon: Icons.videogame_asset, label: "Game"),
        ShortcutItem(icon: Icons.card_giftcard, label: "Daily Gift"),
        ShortcutItem(icon: Icons.more_horiz, label: "More"),
      ]),
    );
  }
}

class ShortcutItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const ShortcutItem({super.key, required this.icon, required this.label});
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
            color: Colors.deepPurple, shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
      const SizedBox(height: 8),
      Text(label, style: const TextStyle(fontSize: 12)),
    ]);
  }
}

class SpecialHeaderRow extends StatelessWidget {
  const SpecialHeaderRow({super.key});
  @override
  Widget build(BuildContext context) =>
      const _SectionHeader(leftText: "Special for you", rightText: "See More");
}

class SectionHeaderRow extends StatelessWidget {
  const SectionHeaderRow({super.key});
  @override
  Widget build(BuildContext context) =>
      const _SectionHeader(leftText: "Popular Product", rightText: "See More");
}

class _SectionHeader extends StatelessWidget {
  final String leftText;
  final String rightText;
  const _SectionHeader(
      {required this.leftText, required this.rightText, super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(leftText,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(rightText,
                style: const TextStyle(fontSize: 14, color: Colors.deepPurple)),
          ]),
    );
  }
}

class ImageRow extends StatelessWidget {
  const ImageRow({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(children: [
        _buildImageItem('assets/images/Image Banner 2.png'),
        const SizedBox(width: 8),
        _buildImageItem('assets/images/Image Banner 3.png'),
      ]),
    );
  }

  Widget _buildImageItem(String path) {
    return Expanded(
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image:
              DecorationImage(image: AssetImage(path.trim()), fit: BoxFit.cover),
        ),
      ),
    );
  }
}

class AdditionalImagesRow extends StatelessWidget {
  const AdditionalImagesRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Expanded(
            child: ProductItem(
              assetPath: 'assets/images/Image_Popular_Product_1.png',
              title: 'Wireless Controller',
              subtitle: 'for PS4 \$64.99',
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: ProductItem(
              assetPath: 'assets/images/Image_Popular_Product_2.png',
              title: 'Nike Sport White‑Man Pant \$50.0',
              subtitle: '',
            ),
          ),
        ],
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  final String assetPath;
  final String title;
  final String subtitle;

  const ProductItem({
    super.key,
    required this.assetPath,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            assetPath.trim(),
            height: 120,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 6),
        if (title.isNotEmpty)
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        if (subtitle.isNotEmpty)
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
      ],
    );
  }
}
