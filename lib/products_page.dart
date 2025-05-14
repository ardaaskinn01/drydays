import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';
import 'language_provider.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  final String trendyolUrl =
      'https://www.trendyol.com/magaza/kardelen-tibbi-cihazlar-m-434131?sst=0';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LanguageProvider.translate(context, 'ourProducts')),
        actions: [
          IconButton(
            icon: Image.asset('assets/images/trendyol_logo.png'),
            tooltip: LanguageProvider.translate(context, 'viewOnTrendyol'),
            onPressed: () => _launchURL(),
          ),
        ],
      ),
      drawer: HomePage(title: LanguageProvider.translate(context, 'ourProducts')).buildDrawer(context),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(color: Color(0xFFD5CE9D)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LanguageProvider.translate(context, 'ourProducts'),
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                LanguageProvider.translate(context, 'productDescription'),
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              const SizedBox(height: 20),
              _buildProductCard(context, 'assets/images/product.png', 'dryDaysSound'),
              _buildProductCard(context, 'assets/images/product2.png', 'dryDaysVibration'),
              _buildProductCard(context, 'assets/images/product3.png', 'dryDaysPlus'),
              const SizedBox(height: 30),
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
                  label: Text(
                    LanguageProvider.translate(context, 'buyOnTrendyol'),
                    style: const TextStyle(fontSize: 16, color: Colors.white),
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

  Widget _buildProductCard(BuildContext context, String imagePath, String productKey) {
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
              LanguageProvider.translate(context, productKey),
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
        'https://www.trendyol.com/magaza/kardelen-tibbi-cihazlar-m-434131?sst=0');

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint("Link açılamadı: $url");
      throw 'Link açılamıyor: $url';
    }
  }
}