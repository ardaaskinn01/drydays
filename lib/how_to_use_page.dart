import 'package:flutter/material.dart';

import 'home_page.dart';

class HowToUsePage extends StatelessWidget {
  const HowToUsePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dry Days Nasıl Kullanılır")),
      drawer: HomePage(
        title: 'Dry Days Nasıl Kullanılır',
      ).buildDrawer(context), // buildDrawer'ı ekliyoruz
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          color: Color(0xFFD5CE9D), // Açık mavi arka plan rengi
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Başlık
              const Text(
                "Dry Days Nasıl Kullanılır?",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),

              // Açıklama yazısı
              const Text(
                "Dry Days Enürezis Alarm Cihazının seti içinde verilen duyarganın içine konulmasına yarayacak olan üç adet duyarga kılıfı külotlara dikilir.\n\n"
                "Alarm cihazı pijamanın omuz kısmına tutturulur ve ara kablo pijamanın içinden geçirilip külota dikilmiş olan kılıfın içine duyarga yerleştirilir.\n\n"
                "İdrarın ilk salınımıyla birlikte devreye giren alarm çalışmaya başlar ve hastayı uyandırır.\n\n"
                "İlk bir kaç hafta hastaya yardımcı olmak amacıyla (hasta küçük yaşta ise) aile bireylerinden biri kalkar ve idrarın devamının tuvalette sonlandırılmasını sağlar.\n\n"
                "İlerleyen günlerde oluşacak şartlı refleks sayesinde mesane kasılması hissiyle kalkıp tuvalete gidecek duruma gelecektir.\n\n"
                "Alarm cihazı ile birlikte verilen takvim üzerinde işaretlemeler yapılıp, doktor kontrolüne gidildiğinde takvim de götürülür böylece sürecinin daha rahat izlenmesi sağlanır.\n\n"
                "Cihazla verilen kullanım kılavuzunda daha geniş anlatılmaktadır.",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
