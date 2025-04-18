import 'package:flutter/material.dart';

import 'home_page.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hakkımızda"),
        elevation: 0,
      ),
      drawer: HomePage(title: 'Hakkımızda').buildDrawer(context), // HomePage'deki drawer'ı kullanıyoruz
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          color: Color(0xFFD5CE9D), // Açık mavi renk
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Hakkımızda',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Kardelen Tıbbi Cihazlar olarak 1997 yılında İzmir’de kurulmuş önce müşteri memnuniyeti ve kaliteli ürün ilkesi ile yola çıkarak, istikrarlı adımlarla yükselmek inancıyla hizmetlerini sürdürmektedir.",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              SizedBox(height: 10),
              Text(
                "Kardelen Tıbbi Cihazlar kurulduğu yıldan bu yana elektronik, medikal sektöründe imalat satış ve pazarlama alanında hizmet vermektedir.",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              SizedBox(height: 10),
              Text(
                "Marka yaratmanın, ürün geliştirmenin ve bunları pazarda tutundurarak kalıcı olmanın değerine ilk günden beri inandığımız için, tasarım ve patenti kendi üzerimize ait olan ürünlerimizi yurt içi ve yurt dışı pazarlarda tüketicilerin beğenisine sunduk.",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              SizedBox(height: 10),
              Text(
                "Ürünlerimizin pazarlarda aranılan ve beğenilen ürünler olması bize gurur veriyor.",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              SizedBox(height: 10),
              Text(
                "Dry Days adıyla başarıyla üretmekte olduğumuz cihazımız, birçok ilimizin üniversite ve özel hastahanelerinde değerli hekimlerimiz tarafından güvenle tavsiye edilip reçetelendirilmektedir.",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              SizedBox(height: 10),
              Text(
                "Günümüz teknolojisini yakından takip eden ve çalışmalarına her geçen gün yenisini ekleyen uzman kadrosu ve Ar-Ge çalışmaları ile, yurt içi ve yurt dışında her geçen gün artan müşteri memnuniyeti ile adından söz ettirmiş; ve medikal sektöründe saygın bir yer edinmiştir.",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              SizedBox(height: 10),
              Text(
                "Müşterilerimize en iyi hizmeti suna bilmemiz için firma politikası olarak yurt içi ve yurt dışında bayilerimizin ve tüketicilerin ürünlerimiz üzerindeki olumlu yorumlarını ve göstermiş oldukları beğenilerini sarsacak her türlü girişimcilere karşı Türk Patent Enstitüsü tarafından marka ve patent belgesi tescili yapılmış olup siz değerli müşterilerimize böyle bir hizmet ve ürünü sunmaktan gurur duymaktayız.",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
