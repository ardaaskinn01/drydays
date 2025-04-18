import 'package:flutter/material.dart';
import 'about_page.dart';
import 'products_page.dart';
import 'enuresis_page.dart';
import 'how_to_use_page.dart';
import 'blog_page.dart';
import 'contact_page.dart';
import 'islem_giris_page.dart';
import 'bluetooth_page.dart';
import 'rapor_olusturma_page.dart';


class HomePage extends StatelessWidget {
  final String title;
  const HomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: buildDrawer(context),  // Drawer burada tanımlanıyor
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFBABD66),
              Color(0xFFE3E4D6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4DB6AC), // Mavi-yeşil tonu
                  minimumSize: const Size(240, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.input, color: Colors.white),
                label: const Text(
                  'İşlem Girişi',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const IslemGirisPage()),
                  );
                },
              ),
              const SizedBox(height: 100),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF26C6DA),
                  minimumSize: const Size(240, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.bluetooth, color: Colors.white),
                label: const Text(
                  'Bluetooth',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const BluetoothPage()),
                  );
                },
              ),
              const SizedBox(height: 100),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF81C784),
                  minimumSize: const Size(240, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.insert_chart, color: Colors.white),
                label: const Text(
                  'Rapor Oluşturma',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RaporOlusturmaPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Drawer'ı tanımladık ve bir fonksiyon haline getirdik
  Widget buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFD8C980), // Hafif sarı ton
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 240, // Görselin yüksekliği
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF61A4BB), Color(0xFFFFFFFF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: Image.asset(
                'assets/images/drydays.png',
                width: double.infinity, // Genişlik Drawer'ın tamamı
                height: double.infinity, // Yükseklik de container'a uyacak şekilde
                fit: BoxFit.contain, // Görseli alanı dolduracak şekilde ayarlıyoruz
              ),
            ),
          ),
          _buildDrawerItem(Icons.home, 'Ana Sayfa', context, const HomePage(title: "Ana Sayfa")),
          _buildDrawerItem(Icons.info, 'Hakkımızda', context, const AboutPage()),
          _buildDrawerItem(Icons.shopping_bag, 'Ürünler & Aksesuarlar', context, const ProductsPage()),
          _buildDrawerItem(Icons.question_answer, 'Enürezis Nokturna Nedir', context, const EnuresisPage()),
          _buildDrawerItem(Icons.play_circle, 'Dry Days Nasıl Kullanılır', context, const HowToUsePage()),
          _buildDrawerItem(Icons.article, 'Blog', context, const BlogPage()),
          _buildDrawerItem(Icons.contact_mail, 'İletişim', context, const ContactPage()),
        ],
      ),
    );
  }

  // Drawer itemlarını oluşturduğumuz fonksiyon
  Widget _buildDrawerItem(IconData icon, String title, BuildContext context, Widget page) {
    return ListTile(
      leading: Icon(icon, color: Colors.brown[800]),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      onTap: () {
        Navigator.pop(context); // Drawer'ı kapat
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page), // Sayfaya geçiş yapıyoruz
        );
      },
    );
  }
}

