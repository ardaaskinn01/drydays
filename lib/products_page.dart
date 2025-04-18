import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'home_page.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  final String trendyolUrl =
      'https://www.trendyol.com/drydays/yatak-islatma-idrar-alarm-cihazi-dry-days-enurezis-sesli-uyari-p-101147068?boutiqueId=61&merchantId=572701';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ürünlerimiz"),
        actions: [
          IconButton(
            icon: Image.asset('assets/images/trendyol_logo.png'),
            tooltip: "Trendyol'da Görüntüle",
            onPressed: () => _launchURL(),
          ),
        ],
      ),
      drawer: HomePage(title: 'Ürünlerimiz').buildDrawer(context),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(color: Color(0xFFD5CE9D)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ürünlerimiz',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Dry Days Enürezis Alarmlarımızın ölçüleri: Uzunluk 6 cm, Genişlik 4,5 cm, Derinlik 3 cm’dir. Ürünlerimiz; kişinin en kısa sürede uyarılması için ve her yaşta enüretik hastanın güvenle kullanması için tasarlanmıştır.\n\n"
                    "Dry Days adıyla başarıyla üretmekte olduğumuz cihazımız birçok ilimizin üniversite ve hastanelerinde, değerli hekimlerimiz tarafından güvenle tavsiye edilip, reçetelendirilmektedir.",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              const SizedBox(height: 20),
              _buildProductCard('assets/images/product.png', 'Dry Days Sesli Uyarı'),
              _buildProductCard('assets/images/product2.png', 'Dry Days Titreşimli Uyarı'),
              _buildProductCard('assets/images/product3.png', 'Dry Days Plus (Sesli+Titreşimli)'),
              const SizedBox(height: 30),

              // Trendyol Butonu
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => _launchURL(),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    backgroundColor: Colors.orangeAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: Image.asset(
                    'assets/images/trendyol_logo.png',
                    width: 24,
                    height: 24,
                  ),
                  label: const Text(
                    "Trendyol'da Satın Al",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(String imagePath, String productName) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imagePath,
                width: double.infinity,
                height: 180,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              productName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL() async {
    final Uri url = Uri.parse(
        'https://www.trendyol.com/drydays/yatak-islatma-idrar-alarm-cihazi-dry-days-enurezis-sesli-uyari-p-101147068?boutiqueId=61&merchantId=572701');

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint("Link açılamadı: $url");
      throw 'Link açılamıyor: $url';
    }
  }
}
