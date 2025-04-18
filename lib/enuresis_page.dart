import 'package:flutter/material.dart';

import 'home_page.dart';

class EnuresisPage extends StatelessWidget {
  const EnuresisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enürezis Nokturna Nedir?"),
      ),
      drawer: HomePage(title: 'Ürünlerimiz').buildDrawer(context),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            color: Color(0xFFD5CE9D), // Açık mavi arka plan rengi
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Başlık
              const Text(
                "Enürezis Nokturna Nedir?",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),

              // Görsel
              Image.asset(
                'assets/images/ensuresis.png',
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),

              // Açıklama yazısı
              const Text(
                "Enürezis Nokturna (Uykuda işeme, altını ıslatma ya da gece işemesi); 5 yaşından büyük çocukların, uyku sırasında, tekrarlayıcı nitelikte, istemsiz idrar kaçırması, bu davranışın üç ay süre ile en az haftada iki kez ortaya çıkması olarak tanımlanır.\n\n"
                    "Enürezis nokturna, sorunun başlangıç biçimi ve seyrine göre primer (birincil) ve sekonder (ikincil) olarak iki gruba ayrılır. En az bir yıllık idrar tutma periyodunun olmadığı durumlarda enürezis primer olarak adlandırılır. Primer enürezis için, en az 3 veya 6 aylık kuruluk periyodunun olmadığı durumları koşul kabul edenler de vardır. Tüm enuretiklerin %80-90’ını oluşturan bu grupta daha çok genetik yatkınlık, biyolojik ve gelişimsel etmenler sorumlu tutulmuştur. Sekonder enürezis ise en az 1 yıl süren kuru bir periyoddan sonra tekrarlamanın olmasıdır. Sekonder enürezis nokturna en sık 5-8 yaşlar arasında görülür ve bu grupta daha çok psikolojik etmenlerin sorunu başlattığı ileri sürülmektedir.\n\n"
                    "Yapılan araştırmalarda erkek çocuklarda Uykuda işeme yüzdesi kız çocuklarına oranla daha yüksek olarak saptanmıştır. Bu çocuklarda yaşıtlarına göre gelişimsel gecikmeler de saptanmıştır. 5 yaş sonrasında tedavisiz kendiliğinden iyileşme oranı %5-10 arasında bulunmuştur. Ancak zamanı ve kesinliği bilinmeyen bu iyileşmeyi beklemek yanlış bir tutum olur çünkü, bu süre beklenirken rahatsızlık devam edeceğinden çocuk yabancı bir mekanda kalmak istemeyebilecek hatta arkadaşlarını misafir edemeyebilecektir v.b. bu da hem sosyal hem de psikolojik sorunlar yaşamasına sebep olacaktır.\n\n"
                    "Enürezis nokturna’ın nedenlerini belirlemek güçtür, birçok varsayım ileri sürülmektedir.\n\n"
                    "Yapılan araştırmalar enüreziste ailesel bir yatkınlık olduğu görüşünde birleşmektedir. Eğer anne-babanın her ikisinde de geçmişte ya da devam etmekte olan enürezis var ise çocukta bu durumun ortaya çıkma oranı %70-75, sadece birinde var ise bu risk %40-45’e düşmektedir. Ailesel bir bağ yoksa %15’e kadar azalmaktadır.\n\n"
                    "5 yaşındaki bir çocuğun, uykusunda idrarını tutması mümkündür. Enuretik çocukların ise işlevsel mesane kapasitelerinin daha düşük olması nedeniyle istemli idrar yapma ve tutma yeteneğini daha geç kazandığı bildirilmektedir.\n\n"
                    "Uyku evreleri ve enürezis arasındaki ilişkiyi araştıran ilk çalışmalarda, enürezisin derin uykuda ortaya çıktığı ve rüya eşdeğeri olduğu ileri sürülmüştür. Ancak son yıllarda yapılan daha kapsamlı ve ileri çalışmalar işemenin uykunun her döneminde olabildiğini göstermiştir. Enürezisin bir uyanabilme sorunu olduğunu kabul eden birçok araştırmacı vardır.\n\n"
                    "Enürezisli hastaların önemli bir bölümünde sosyal uyum sorunları ve bazı davranış bozuklukları olduğu gözlenmiştir. Ancak son yıllardaki bazı çalışmalarda psikolojik sorunların enürezise değil, enürezisin bazı davranış bozukluklarına veya uyumsuzluğa yol açtığı ileri sürülmektedir. Nitekim enürezisi tedavi edilen çocuklarda olumlu yönde psikolojik etki gözlenir.",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              const SizedBox(height: 20),

              // Başlık 2
              const Text(
                "Tedavi",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),

              // Yazı 2
              const Text(
                "Gece yatağını ıslatan çocuklar için alınacak ilk tedbir: bu çocukları bu alanda uzman bir hekime göstermektir. Enürezis birçok nedenle ortaya çıkan bir hastalık olduğu için, tedavisinde değişik yöntemler kullanılmaktadır.\n\n"
                    "Çocuğa mesane kapasitesini arttırıcı çalışmalar yaptırılır, gündüz sıvı alımını arttırarak idrarı geldiğinde tuvalete gitme süresi uzatılır. Kapasitenin gerçekten arttırılabildiği çocukların bir kısmında enürezis ortadan kalksa da bunu başarabilenlerin oranı düşüktür. Bu nedenle pratikte fazla yarar sağlamaz.\n\n"
                    "Alarm ile tedavide çocuklarda %75-100 oranında iyileşme sağlanmaktadır. Alarm tedavisi sonunda tekrarlama riski %10 dolayındadır. Çocuk uyurken ilk birkaç damla idrarla birlikte alarm çalışmaya başlar ve çocuğu uyandırır. Uyanan çocuğun mesanesi kasılarak idrarın tamamının salınışını engeller. 2-4 hafta içinde çocuk uykusunda çişi geldiğinde alarm çalmadan uyanmaya başlar ve böylece kuru kalır. Bu konudaki yeni bir çalışma alarm cihazının hastaların uykudaki fonksiyonel mesane kapasitelerini arttırdığını bildirmektedir. Alarm yöntemi ile tedavi edilen hastaların bir süre sonra uykuda işemedikleri gibi gece çişe de kalkmadıkları bildirilmektedir. İlk günlerde anne babanın yakın ilgisi sonuca daha kolay ulaşma konusunda önemlidir.\n\n"
                    "Uykuda işeme tedavisinde imipramin, oxybutynin, dezmopressin gibi ilaçlar kullanılmaktadır. İlaç tedavisi ile %10-60 arasında iyileşme sağlanmakta, fakat tedavi kesildikten sonra %90’a varan oranda tekrar riski bulunmaktadır. Bu nedenle son yıllarda alarm ve ilaç tedavisinin birlikte kullanılması önerilmektedir.",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
