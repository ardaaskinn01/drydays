import 'package:flutter/material.dart';
import 'home_page.dart';

class BlogPage extends StatelessWidget {
  const BlogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Blog")),
      drawer: HomePage(title: 'Dry Days Blog').buildDrawer(context),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          color: Color(0xFFD5CE9D), // Açık mavi arka plan rengi
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // İlk Blog Kartı
            Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: InkWell(
                onTap: () {
                  // İlk kart tıklama işleminde yeni sayfaya yönlendir
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BlogDetailPage1(),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Cerrah Gözüyle Enzürezis",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "9 Eylül 2018",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 10),

                      // Etiketler
                      Wrap(
                        spacing: 8.0,
                        children: const [
                          Chip(label: Text("distal üreteral stenoz")),
                          Chip(label: Text("epidemiyoloji")),
                          Chip(label: Text("etiyoloji")),
                          Chip(label: Text("hinman sendromu")),
                          Chip(label: Text("tembel mesane")),
                        ],
                      ),

                      const SizedBox(height: 10),
                      const Text(
                        "Enürezis çocukluk çağının en önemli ve en sık görülen işeme bozukluğudur. Uyku sırasında mesanenin fonksiyonel kapasitesi dolduğunda ortaya çıkan kendini boşaltma ihtiyacı çocuk uyanır ve gece tuvalete işerse (nokturi), uyanamaz ve yatağına işerse (enürezis) olarak adlandırılır.",
                        maxLines: 3, // Yazı sadece 3 satır gösterilecek
                        overflow: TextOverflow.ellipsis, // Fazla yazıyı keser
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // İkinci Blog Kartı
            Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: InkWell(
                onTap: () {
                  // İkinci kart tıklama işleminde yeni sayfaya yönlendir
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BlogDetailPage2(),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Enürezis Nokturna (Uykuda İşeme) ve Enürezis Alarm",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "9 Eylül 2018",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 10),

                      // Etiketler
                      Wrap(
                        spacing: 8.0,
                        children: const [
                          Chip(label: Text("enürezis")),
                          Chip(label: Text("uykuda işeme")),
                        ],
                      ),

                      const SizedBox(height: 10),
                      const Text(
                        "Genelenürezis, uykuda işeme. Enürezis nokturna (uykuda işeme) günümüzde sağlıklı okul çocuklarının %15-30’unu etkileyebilen ve çoğunlukla monosemptomatik tipte (sadece gece işemeleri şeklinde) seyreden bir rahatsızlıktır. Gece işemesi bilimsel olarak, 5 yaşından sonra –haftada 2 defadan fazla olmak üzere- mesanenin yalnış yer ve zamanda...",
                        maxLines: 3, // Yazı sadece 3 satır gösterilecek
                        overflow: TextOverflow.ellipsis, // Fazla yazıyı keser
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BlogDetailPage1 extends StatelessWidget {
  const BlogDetailPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cerrah Gözüyle Enürezis")),
      body: Container(
        color: const Color(0xFF81D4FA), // Arka plan rengi
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Cerrah Gözüyle Enürezis",
                style: TextStyle(
                  fontSize: 20,
                  height: 1.5,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 24),
              Text(
                "Enürezis çocukluk çağının en önemli ve en sık görülen işeme bozukluğudur. Uyku sırasında mesanenin fonksiyonel kapasitesi dolduğunda ortaya çıkan kendini boşaltma ihtiyacı çocuk uyanır ve gece tuvalete işerse (nokturi), uyanamaz ve yatağına işerse (enürezis) olarak adlandırılır. Enürezis ve inkontinans deyimleri sıklıkla birbirinin yerine ve yanlış olarak kullanılmaktadır. Enürezis uygunsuz yer ve zamanda gerçekleşen fizyolojik(normal)bir işemedir. İnkontrinansta normal bir işeme yoktur, çocuk bilinçli olarak engellemeye çalıştığı halde idrar kaçırma önlenemez. Enürezisin farklı etiyolojik nedenlerle ortaya çıkabilen bir semptom olması, enürezisi farklı disiplinleri ilgilendiren bir sorun haline getirmiştir. Bu yakınma çocukların büyük bir çoğunluğunda komplikasyonsuzdur ve önemli bir sorun oluşturmaz. Benzer yakınmaları olan küçük bir grupta ise ciddi sorunlara neden olabilecek fonksiyonel üriner sistem hastalıkları vardır. Bir cerrah’ın değerlendirmesine ihtiyaç duyan bu az sayıdaki hastayı bu büyük grup içinden ayırmak son derece önemlidir. Enürezis ile ilgilenen her branş problemi kendi açısından değerlendirmekte ve tedaviyi yönlendirmektedir. İyileşemeyen hastalar da her seferinde farklı bir branşta(Çocuk sağlığı ve hastalıkları, çocuk cerrahisi, üroloji, psikiyatri) kendilerine çözüm aramaktadır. Enürezis mutlaka multidisipliner olarak ele alınıp tedavi edilmesi gereken bir sorundur. Bu makalede enürezise çocuk cerrahının bakış açısı ve klinik yaklaşımı tartışılacaktır.",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 16),
              Text(
                "Enürezisin tanımı",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 4),
              Text(
                "Enürezis idrar kontrolünün beklendiği yaştan sonra(4-5 yaş) gece yada gündüz, yatağına yada giysilerine istemli yada istemsiz olarak yenileyen(haftada en az 2 kez) idrar kaçırması olarak tanımlanır. Enürezis başlangıcı ve seyrine göre primer veya sekonder olabilir. Uykuda işeme bazı çocuklarda doğuştan beri arada hiç kuru kalma dönemi olmadan sürer gider buna birincil tip(primer enürezis) denir; bazılarında ise bir süre(en az 6 ay) tuvalet eğitimi sağlanmış sonra herhangi bir yaşta birdenbire uykuda işeme başlamıştır. Buna da ikincil tip (sekonder enürezis) adı verilir. Enürezis nokturnal ve diurnal olabilir. Gece uykuda işeme durumuna (nokturnal enurezis) gündüz uyanıkken işeme (diurnal enürezis )olarak isimlendirilmektedir. Gece veya gündüz yalnızca uykuda işeyen çocuklarda bundan başka bir yakınma yoksa buna tek semptomlu uykuda işeme (monosemptomatik enürezis nokturna) denilmektedir. Nokturnal enürezis için yatak ıslatma veya uykuda altını ıslatma şeklindeki ifadeler suçlayıcı bir tanımlamlar olduğu için kullanılmamalı bunların yerine için uykuda işeme terimi tercih edilmelidir.",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 16),
              Text(
                "Mesane kontrolünün kazanılması",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 4),
              Text(
                "Yeni doğanda işeme, bir işeme refleksi şeklinde ve günde ortalama 20 kez gerçekleşmektedir. Bebek 6 aylık olduktan sonra işeme hacimleri artmaya, işeme sıklığı azalmaya başlar. Bu azalma işeme refleksinin istemsiz inhibisyonuna yada yaşla mesane hacmi büyürken idrar miktarının artmaması ile açıklanmaktadır. Mesane dolma duyusu 1-2 yaş arasında gelişir. Dört yaşında çocukların çoğu erişkinlerdeki işeme kontrolüne sahip olurlar.",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 16),
              Text(
                "Epidemiyoloji",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 4),
              Text(
                "Beş yaşındaki çocukların %15-20’sinin her zaman veya arada kuru uyanamadıkları bildirilmektedir. Yedi yaşındakilerin %5-10’u uykuda işerken, her yıl bunların %10-15 kadarı gece kontrolünü elde eder ve 15 yaşında %1-2 kadarı kuru uyanmayı başaramamış olarak kalır. Uykuda işeme yalnızca çocukluk hastalığı değildir. 18 yaşındaki erişkinlerin bile %1-2 si bu sorunu yaşamaktadır. Yetişkinlerin %1 lik bölümünde sorun sürekli bir hal alarak devam edebilir. Diurnal enürezis kızlarda daha sık görülürken, nokturnal enürezis ise erkeklerde daha sıktır.",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 16),
              Text(
                "Etiyoloji",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 4),
              Text(
                "Uykuda işemeden sorumlu veya etkisi olduğu düşünülen birçok faktör bildirilmiştir. Uykuda işemeyi bir hastalık değil bir semptom olarak algılamak daha doğru bir yaklaşımdır. Bu semptoma yol açan birden çok etiyolojik faktör saptanabilir. Çocuklarda uykuda işeme sadece psikojenik bir bozukluk değildir. Etiyolojide hem biyolojik etkenlerin hem de psikososyal etkenlerin rolü olduğu düşünülmektedir. Uykuda işeme tedavisinde düzeltilmesi gereken enürezis semptomu değildir. Bu klinik semptoma neden olan asıl sorunun tanınıp düzeltilmesi amaçlanmalıdır.",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 16),
              Text(
                "Psikojenik faktörler",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 4),
              Text(
                "Etiyolojide sık olarak suçlanan ve yanlış olarak en önemli neden olduğuna inanılan faktör emosyonel veya psikojenik bozukluklardır. Uykuda işeyen hastaların bir kısmında davranış bozuklukları ve uyumsuzluklar gözlenmektedir, ancak uykuda işemeye eşlik ettiği düşünülen spesifik bir psikopatoloji bildirilmemiştir. Psikopatoloji enürezise değil, enürezis davranış bozukluğu ve uyumsuzluğa yol açmaktadır. Yani psikolojik etki sebep değil sonuçtur. Tedavi edilen çocuklarda çoğu zaman olumlu bir psikolojik etki gözlenir. Uykuda işemeden kaynaklanan özsaygı ve güven eksikliğinin psikolojik hastalıklar için bir risk oluşturabileceği ve uygun bir tedavi ile bu tür psikolojik problemlerin önlenebileceği belirtilmektedir. Hastanın öyküsünde zorlu yaşam olayları, aile düzenindeki ani değişiklikler, ölümler, yeni bir kardeşin doğumu, ailede sürekli bir çatışma olması araştırılmalıdır.",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 16),
              Text(
                "Genetik Faktörler",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 4),
              Text(
                "Uykuda işeyen çocukların ailelerinde(anne ve babalarında) işeme öyküsüne sık rastlanmaktadır. Anne ve babanın her ikisinde işeme öyküsü varken çocuklarda görülme oranı %77,. sadece anne veya babadan birinde bu sorun varsa %44, hiçbirinde işeme öyküsü yoksa çocukların yanlızca %15 inde uykuda işeme görülmektedir. İkiz çalışmalarında , enürezisin monozigot ikizlerde erkeklerde %70, kızlarda %65 oranında, dizigot ikizlerde erkeklerde %31, kızlarda %44 birlikteliği gösterilmiştir. Enüreziste genetik geçiş olduğu bilinmekle birlikte, geçiş ve genotipik özellikler hakkında kesin bilgiler yoktur. Aile öyküsü bulunması çocukta uykuda işemenin kendiliğinden geçme veya tedaviye cevap verme/vermeme durumunu etkilememektedir. Ailede uykuda işeme öyküsü varsa çocuklardaki uykuda işeme önemsenmemekte ve başvuru yaşı gecikebilmektedir.",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 16),
              Text(
                "Uyku bozuklukları",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 4),
              Text(
                "Uykuda işeyen hastaların uyku paternleri hakkında pek çok çalışma vardır. Uykuda işeyen çocukların aileleri çocuklarının uykularının çok ağır olduğunu ve güçlükle uyandırılabildikleri belirtirler. Ancak tüm zor uyanan çocukların enüretik olmadığı da bir gerçektir. Uykuda işemenin uykunun derin safhalarında olduğu düşünülmüşse de yapılan ayrıntılı çalışmalarla uykunun her döneminde olabildiği gösterilmiştir.",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 16),
              Text(
                "Gelişmede gecikme",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 4),
              Text(
                "Uykuda işeyen çocuklarda hem motor, hem de dil gelişiminde gecikme vardır. Enüretik çocuklarda kronolojik yaşa göre kemik yaşında gecikme saptanmıştır. Uykuda işeyen hastalarda barsak kontrolü, yürüme ve konuşma gibi bazı gelişme parametrelerinin hatta pubertenin de geciktiği bildirilmiştir.",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 16),
              Text(
                "Hormonal etkenler",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 4),
              Text(
                "Uyluda işeme etiyolojisinde antidiüretik hormonun salınımının nokturnal eksikliğinin rolü olduğu düşünülmektedir. Erişkinler geceleri 2-3 kat daha az idrar üretirler ki bu antidiüretik hormon düzeylerinin geceleri artan salınımı ile ilişkilidir. Yenidoğanda tespit edilemeyen bu farklılık 3 yaş civarında gösterilebilmiştir. Uykuda işeyen çocuklarda bu değişimin tamamlanmadığı düşünülmektedir. Enüretik çocuklarda nokturnal antidiüretik hormon düzeylerinin belirgin olarak daha düşük olduğu ayrıca gece idrar ozmolaritesinin düşük ve miktarının daha fazla olduğu gösterilmiştir. Böylece gece uykusunda üretilen bu seyreltik ve fazla miktardaki idrarın mesane kapasitesini aştığı ve uykuda işemeye neden olduğu düşünülmektedir.",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 16),
              Text(
                "İdrar yolu enfeksiyonu",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 4),
              Text(
                "İdrar yolu enfeksiyonu tedavisinden sonra hastaların üçte birinde uykuda işeme yakınması kaybolmuştur. Enürezis diurna ve sekonder enürezisli hastalarda da idrar yolu enfeksiyonu sık görülmektedir.",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 16),
              Text(
                "Üriner sistem patolojisi (mesane- üretra fonksiyon bozuklukları)",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 4),
              Text(
                "Tek semptomlu uykuda işeme (monosemptomatik nokturnal enürezis) olgularında yapılan ürodinamik çalışmalar sonucunda bu çocuklarda önemli bir mesane-işeme fonksiyon bozukluğu olmadığı gösterilmiştir. Mesanenin inhibe edilemeyen kontraksiyonları (detrusor instabilitesi) uykuda işeyen çocukların önemli bir kısmında görülmektedir. Ancak mesane instabilitesi görülen enüretik hastaların çoğunda ayrıntılı bir anamnez alındığında enürezise eşlik eden gündüz işeme, gündüz sık idrara çıkma, sıkışma hissi(urge) gibi semptomların bulunduğu saptanabilecektir. Mesane kapasitesinin enüretik çocuklarda daha düşük olduğunu iddia eden çalışmalar olmasına rağmen, tek semptomlu uykuda işeme olgularında mesane kapasitesinin normal sınırlar içinde olduğu gösterilmiştir. Uyku sırasında detrusor kasının inhibe edilemeyen kontraksiyonları ve gevşeyememesi nedeniyle mesane kapasitesi normal gevşemiş mesaneninkinden daha küçük bulunmaktadır. Gerçekte enürezis bu çocuklarda primer bir sorun olmaktan çok genel bir mesane-işeme bozukluğunun(disfonksiyon) bir parçasıdır. Birçok üriner sistem hastalığında eşlik eden semptomlardan biri hatta çoğu zaman ilki enürezis olabilir. Tek semptomlu uykuda işeme (monosemptomatik enürezis nokturna) olgularıyla komplike enürezis olgularının ayrımının yapılması çok önemlidir. Bizim çocuk cerrahı olarak ilgilendiğimiz enürezis hastaları işeme–mesane fonksiyon bozukluklarının veya üriner sistem anomalilerinin eşlik ettiği bu hastalardır. Çocuk cerrahisi kliniklerindeki enürezis polikliniklerine başvuran çocukların büyük çoğunluğunu literatürün aksine komplike enürezis olguları oluşturmaktadır. Tek semptomlu uykuda işeme olgularının büyük çoğunluğu çocuk sağlığı ve hastalıkları polikliniklerinde hatta bazen birinci basamakta tedavi verilerek iyileşmektedir.",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 16),
              Text(
                "Enürezisli hastaya yaklaşım ve değerlendirme",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 4),
              Text(
                "Enürezisli hastalar sağlıklı görünümlü çocuklardır. Hastanın değerlendirilmesi ayrıntılı bir öykü ve fizik bakı ile başlar. İyi bir anamnez birçok gereksiz incelemenin istenmesini engelleyebilir. Fizik bakıda genel değerlendirme dışında genital ve nörolojik bakı özenle yapılmalıdır. Her hastadan en az 2 gün (tercihen hafta sonunda) ayrıntılı bir işeme-hacim çizelgesi doldurması istenir. İşeme hacim çizelgesine sabah uyandıktan gece yatıncaya kadar aldığı bütün sıvıların ve çıkardığı idrarın sayısı ve miktarı ölçülerek kaydedilir. Tam idrar ve idrar kültürü mutlaka istenmelidir. Bu sayılan incelemelerle enürezisin komplike olup olmadığına karar verilebilir. Ender olarak lumbosakral vertebra grafisi bazen de renal ultrason ve uroflowmetri gerekir. Komplike enürezislerde ise altta yatan nedeni ortaya koyacak ileri incelemeler gerekir.",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 16),
              Text(
                "Tedavi",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 4),
              Text(
                "Tedaviye başlama zamanı genellikle 5 yaş cıvarındadır. Tedaviye başlamak için ideal zanmanlama çocuğun enürezisten rahatsız olmaya başladığı zamandır. Enürezis tedavisinde başarılı olmak için hekim, hasta ve ailesinin birlikte çalışması ve kooperasyonu çok önemlidir. Bu ilişkinin kurulabilmesi için her seferinde aynı hekim tarafından görülmesi çok önemlidir. Sürekli nöbet değişen hekimlerle yürütülen enürezis polikliniklerinde başarı oranları doğal olarak daha düşüktür. Hekim, anne baba ve çocuğa değerlendirme sonuçları ve uygulanacak tedavi, ilaçların yan etkileri konusunda anlayabilecekleri düzeyde ve olabildiğince ayrıntılı bilgi verilmelidir. Çocuğa bu sorunun onun elinde olmadan ortaya çıktığı, bu durumun düzeltilebilen bir rahatsızlık olduğu, isterse bu konuda ona yardım edilebileceği ve uykuda işememenin öğretilebileceği söylenmelidir. Hekim ve hastanın ilk görüşmesinden sonra henüz tedaviye başlamadan anlamlı sayıda hastada uykuda işemede düzelme görülmektedir. Seçilecek tedavi yöntemi belirlenirken altta yatan patoloji dışında çocuğun yaşı, sorunun sıklığı, tedavinin acilliği, hatta hastanın yöntemlerle ilgili kendi tercihi dikkate alınmalıdır. En yararlı olacağı düşünülen yöntemle tedaviye başlamak ve tedavinin yarım bırakılmaması gerektiği vurgulamak önemlidir. Her başarısız tedavi girişimi hastada olumsuz etkiler bırakır ve daha sonra uygulanacak yöntemlerin başarısını azaltır. Başlıca iki grup tedavi yöntemi vardır. Bunlar davranış modifikasyonu (motivasyon tedavisi, kondüsyon-alarm tedavisi, mesane retansiyonu eğitimi) ve ilaç tedavisi(antikolinerjikler, trisiklik antidepresanlar, vasopressin) yöntemleridir.",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 16),
              Text(
                "Davranış modifikasyonu yöntemleri",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 16),
              Text(
                "Motivasyon tedavisi",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 4),
              Text(
                "Anne baba, çocuk kuru uyandığında onu değişik şekillerde ödüllendirir. Duygusal içerikli ödüller somut ödüllere(para, hediye vs.) göre daha etkili bulunmuştur. Çocuğun tedaviye aktif katılımı ve sorumluluk alması sağlanmalıdır. En sık kullanılan yöntem kayıt tutmadır. Sabah uyanınca ilk iş olarak işeme takvimi doldurulur. Takvimdeki boşlukların çocuğun kendisi tarafından doldurulması çok önemlidir. Takvimdeki kuru günlerin sayısı için bir hedef belirlenerek bu hedefe ulaşınca ödül verilir. Motivasyon tedavisi tek başına yeterli bir yöntem olarak görülmemekle birlikte, diğer tedavi yöntemleri ile birlikte uygulandığında başarıyı arttırdığı ispatlanmıştır.",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 16),
              Text(
                "Kondüsyon–alarm tedavisi",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 4),
              Text(
                "Çocuk uykusunda işediğinde elektrotları ıslanan ve devresi kapanan bir zil sisteminin çalmaya başlaması ve çocuğu uyandırması temeline dayanır. Başlangıçta hasta mesane tamamen boşaldıktan sonra uyanır. Bir süre sonra daha erken uyanmaya ve ortalama 3-4 hafta sonra uykusunda çişi geldiğinde alarm zili çalmadan uyanmaya başlar. Tedavi sonunda hastalar çoğu zaman bütün geceyi uyanmadan ve işemeden tamamlarlar. Etki mekanizması tam olarak bilinmemektedir. Alarm tedavisinin gece ve gündüz fonksiyonel mesane kapasitesini arttırdığı düşünülmektedir.. Alarm tedavisinin 7 yaşından küçük çocuklarda, tek başına uyuduğu özel odası olmayan çocuklarda uygulanma zorlukları vardır. Diğer bütün yöntemler içinde en yüksek başarı oranları(%65-%100) ve en düşük relaps oranları(%20-%30) bu yöntemle elde edilmiştir. Tek semptomlu uykuda işemede ilk seçilmesi gereken tedavi yöntemidir. Önceleri 6 haftalık tedavi yeterli görülürken son yıllarda 2-3 aylık tedavi önerilmektedir. Yabancı kaynaklı alarm sistemlerinin pahalı olması yöntemin yaygınlaşmasını engellemektedir. Ancak son yıllarda çok çeşitli model ve özellikte(sesli, titreşimli, kablolu, kablosuz ) alarm sistemleri daha uygun fiyatlarla yerli olarak üretilmektedir. Bizim tek semptomlu uykuda işeme olgularında alarm sistemi ile(2 ay) elde ettiğimiz sonuçlar yüz güldürücüdür.",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 16),
              Text(
                "Mesane retansiyon eğitimi",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 4),
              Text(
                "Bu yöntemde çocuğa gün boyunca fazla miktarda sıvı içirilir ve idrarını uzun süre tutması istenir. Enürezisli hastaların mesane kapasitelerinin normalden az olması bu tedavinin dayanağıdır.",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 16),
              Text(
                "İlaç tedavisi",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 4),
              Text(
                "İlaç tedavisi uygulama kolaylığı nedeniyle gerek hekimler gerek de hastalar tarafından en çok tercih edilen yöntemdir. Enüeaziste kullanılan ilaçlar başlıca 3 gruptur.\nUyku paternine etkili ilaçlar(trisiklik antidepresanlar)\nİdrar çıkışını azaltan ilaçlar(Desmopressin)\nMesane üzerine etkili ilaçlar(antikolinerjikler)",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 16),
              Text(
                "Uyku paternine etkili ilaçlar( trisiklik antidepresanlar)",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 4),
              Text(
                "Uykuda işeme tedavisinde en yaygın olarak kullanılan ilaçlardır. Uyku ve uyanma paterni üzerine etkilidir. Ayrıca antidepresan etkisi, antikolinerjik-antispazmotik etkisi ve hatta antidiüretik etkisi olduğu da bildirilmiştir. Bu grup içinde en etkili ilaç imipramindir(Tofranil®). Yatmadan 1-2 saat önce 25 mg tek doz olarak verilir.Büyük çocuklarda doz 75 mg kadar çıkılabilir. Etki 1-2 hafta içinde başlar. Önemli bir yan etkisi yoktur. Tedaviye 3-6 ay devam edilmelidir. Daha sonra azaltılarak kesilir. Aşırı dozda alınması entoksikasyona neden olur. İmipramin entoksikasyonunun mortalitesi çok yüksektir. İlaçlar tek tek çıkarılıp içirildikten sonra çocukların ulaşamayacakları bir yerde saklanmalıdır. Yaşı büyük çocuklarda ve sekonder enürezis nokturna da daha etkili bulunmuştur.",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 16),
              Text(
                "İdrar çıkışını azaltan ilaçlar (Desmopressin)",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 4),
              Text(
                "Sentetik bir antidiüretik hormon türevidir. DDAVP yapısındadır. Etki mekanizması gece çıkarılan idrar miktarını fonksiyonel mesane kapasitesinin altına düşürmektir. Normal diurnal antidiüretik hormon salınımı bozuk olan çocuklarda başarılı sonuçlar alınmaktadır. İdrar ozmolaritesi düşük fakat mesane kapasitesi çok küçük olmayan hasta grubunda daha yararlıdır. Desmopressin (Minirin®) nazal sprey, ve oral formu bulunmaktadır Başlangıç dozu 20 mikrogramdır. (her bir burun deliğine 10 mikrogramlık sprey şeklinde ). Klinik yanıta göre 40 mikrograma kadar doz arttırılabilir. Etki hemen başlar. Tedaviye cevap %80 nin üzerindedir. Yan etki olarak hipervolemi ve hiponatremi bildirilmişsede sık görülmez. Tedavi süresi 3-6 aydır. Doz azaltılarak tedavi kesilmelidir.Bizim hasta grubumuzda oral formu nazal formuna göre daha az etkili bulunmuştur. Oral form nazal formun uygulanmasında sorun yaşandığında tercih edilebilir. Doz 100-400 mikrogram /gün . Günde tek doz şeklinde uygulanır. Desmopressin verilenlerde tedavi kesildikten sonra diğer ilaçlara göre daha yüksek nüks oranları bildirilmiştir. Tedaviye hızlı yanıt alınması gereken durumlarda etkisinin hemen başlaması, uygulama kolaylığı ve düşük yan etkisi nedeniyle tercih edilen bir ilaçtır.",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 16),
              Text(
                "Antikolinerjik ilaçlar",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 4),
              Text(
                "İşeme bozukluğu ve mesane instabilitesi olan komplike enürezis olgularının tedavisinde lullanılır. Etki mekanizmaları mesane kapasitesini arttırmak ve detrusor kasının istenmeyen kasılmalarını azaltmak şeklindedir. Gündüz sık işeme urge yakınmaları olan enürezis hastalarında iyi sonuç alınmaktadır. En sık kullanılan ilaç Oksibutinin hidroklorür’dür. (Üropan®) 5mg tablet ve şurup formu vardır. Dozu 0.3-0.4 mg/kg/gün dür. Bu doz 2 yada 3 eşit dozda verilir. Trospiyum klorür (Spasmex®) 15 mg tabletleri vardır. 45 mg/gün 3 eşit doza bölünerek kullanılır. Tolteradine (Detrustol®) 1mg ve 2mg tabletleri vardır. Antikolinerjiklerin ağız kuruluğu, yüz kızarması, idrar yapmada güçlük, taşikardi, midriyazis, uyuklama, kusma konstipasyon gibi yan etkileri görülür. Bu yan etkilerle ilgili aile mutlaka önceden bilgilendirilmeli ve tedaviye uyumu sağlanmalıdır. Tedavi süresi 6 aydır. Dirençli olgularda 1 yıla kadar uzayabilir.",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 16),
              Text(
                "Komplike enürezis tedavisi",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 4),
              Text(
                "Tedaviye dirençli enürezis olgularında ayrıca mesane-işeme-bozuklukları(sık işeme, acili yet hissi (urge), seyrek idrar yapma, idrar kaçırmayı engellemek için bacaklarını yakınlaştırarak çömelme(vincent curtsy)) saptanan olguların bazılarında özellikle de gündüz işeyen çocukların tümünde ürodinamik inceleme gereklidir. Ürodinamik inceleme sonuçlarına göre işeme bozuklukları başlıca 4 gruba ayrılabilir.\n1. İnstabilite\n2. Boşaltma bozukluğu(Hinman Sendromu)\n3. Tembel mesane\n4. Distal üretral stenoz",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 16),
              Text(
                "İnstab il mesane",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 4),
              Text(
                "Detrusor kasının istemsiz kasılmaları söz konusudur. Bu hastalarda sık tekrarlayan enfeksiyonlar, sık idrara gitme ihtiyacı, disüri, gündüz idrar kaçırma gibi belirtiler vardır. İdrar kesesini kasılmalara rağmen tam olarak boşaltabilenlerde üst üriner sistem bu durumdan çok etkilenmez. Bazı çocuklar engelleyemedikleri bu kasılmaların idrar kaçırmalarına neden olmasını engellemek için eksternal sfinkterlerini istemli olarak kasarlar. Detrusor sfinkter dissinerjisi idrar yaparken eksternal sfinkterin gevşetilmesi gerekirken kasılması durumudur.",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 16),
              Text(
                "Hinman Sendromu",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 4),
              Text(
                "Mesane instabiliteli çocukların idrar kaçırmaya engel olmak için eksternal sfinkterlerini kasması sonucu çıkış direnci artar. Detrusor kasının boşalmayı sağlaması için daha yüksek basınç oluşturması ve daha kuvvetli kasılması gerekir bu da hipertrofiye uğramasına neden olur. Hipertofik detrusor inhibe edilemeyen kasılmaların artmasına neden olarak yine çocuğun eksternal sfinkterini kasmasına yol açar. Kısır bir döngünün oluştuğu bu durum Hinman tarafından tanımlanmıştır. Bu olgularda üst üriner sistem de etkilenir ve ciddi vezikoüreteral reflü, hidronefroz, parankim kaybı görülebilir.",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 16),
              Text(
                "Tembel mesane",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 4),
              Text(
                "Seyrek idrara gitme nedeniyle mesanede fazla miktarda idrarın depolanması, mesane kapasitesinin artması ve mesanenin kolay boşalamaz hale gelmesidir. Mesanede idrarın fazla beklemesi ve rezidüel idrar, tekrarlayan idrar yolu enfeksiyonu ve vezikoüreteral reflüye neden olabilir.",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 16),
              Text(
                "Distal üreteral stenoz",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 4),
              Text(
                "Erkek çocuklarında meatal stenoz ender görülen bir durumdur. Meatoplasti ile tedavi edilir. Kız çocuklarında görülen distal üreteral stenozun aslında anatomik bir darlık olmadığı işeme sırasında eksternal sfinkterin istemsiz olarak kasılması sonucu görüldüğü düşünülmektedir.Kız çocuklarında labial frenulumun öne yer değiştirmesi veya labial füzyon nedeniyle vajinal göllenme(vaginal pooling) ve işeme sonrasında idrar kaçağı görülebilir.Konstipasyon işeme bozukluklarına eşlik eden bir durumdur. Hergün aynı saate tuvalete oturtulmalı, çocuğun tuvalette normalden daha uzun kalmasını sağlayıcı önlemler alınmalıdır. Posa bırakan besinlerle beslenme, oral laksatif ve gerekirse lavmanlarla boşaltma sağlanmalıdır.İşeme bozukluğu görülen komplike enürezislerin tedavisinde antikolinerjik ilaçlar, antibiotik proflaksisi, işeme eğitimi(ikili işeme, saatli işeme) ve gerektiğinde temiz aralıklı kateterizasyon(TAK), biofeedback tedavisi, transkutanöz elektrostimülasyon(TENS) yöntemleri endikasyonuna göre kullanılmaktadır.",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 16),
              Text(
                "Klinik Çocuk Forumu Dergisi Pediatrik Cerrahi Özel Sayısı (Cilt 3 Sayı 5 Ekim-Kasım-Aralık 2003)\nCelal Bayar Üniversitesi, Tıp Fakültesi, Çocuk Cerrahisi Ana bilim Dalı Manisa\nDoç. Dr. Can TANELİ",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 16),
              Text(
                "Kaynaklar",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 8),
              Text(
                "• Rushton HG. Enuresis. In: Clinical Pediatric Urology, Kelalis PP, King LR Belman AB, editors. 3rd edition, Philadelphia, W.B. Saunders, 1992. p.365-83.\n• R JM Nijman, R Butler, J Van Gool, CK Yeung,W Bower, K Hjalmas. Conservative management of urinary incontinence. In: Incontinence, Abrams P, Cardozo L, Khoury S, Wein A, editors. 2nd edition. Plymouth, United Kingdom: Health Publication Ltd; 2002, p. 514-51.\n• orsythe WI, Butler RJ. Fifty years of enuresis alarms. Arch Dis Child 1989; 64:879-85.\n• Doleys DM. Behavioural treatments for nocturnal enuresis in children: a review of the recent literature. Psychol Bull 1977;84: 30-4.\n• Wille S. Comparison of desmopressin and enuresis alarm for nocturnal enuresis. Arch Dis Child 1986;61: 30-3.\n• Monda JM, Husmann A. Primary nocturnal enuresis: a comparison among observation, imipramine, desmopressin acetate and bed-wetting alarm systems. J Urol 1995;154: 745-8.\n• Wolfish N. Sleep arousal function in enuretic males. Scand J Urol Nephrol 1999; 202:24-6.\n• Butler RJ, Redfern EJ, Holland P. Children’s notions about enuresis and the implications for treatment. Scand J Urol Nephrol 1994;163:39-47.\n• Azrin NH, Sneed TJ, Foxx RM. Dry-bed-training: rapid elimination of childhood enuresis. Beh Res Ther 1974;12:147-156.\n• Houts AC. Behavioural treatment for enuresis. Scand J Urol and Nephrol 1995;Suppl 173: 83-8.\n• Fly Hansen A, Jorgensen TM. Treatment of nocturnal enuresis with the bell and pad system. Scand J Urol Nephrol 1995;Suppl 173: 101-2.\n• Oredsson AF, Jorgensen TM. Changes in nocturnal bladder capacity during treatment with the bell and pad for monosymptomatic nocturnal enuresis. J Urol 1998;160: 166-9.\n• Bower WF, Moore KH, Adams RD, Shepherd R. Frequency volume chart data from 3222 incontinent children. BJ U Int 1997;80:658-62.\n• Mattson S. Voiding frequency, volumes and intervals in healthy school children. Scand J Urol Nephrol 1994;28:1-11.\n• Berg I, Forsythe I, McGuire R. Response of bedwetting to the enuresis alarm. Influence of psyhiatric disturbance and maximum functional bladder capacity. Arch Dis Child 1982;59:394.\n• Fielding D. The response of day and night wetting chidren and children who wet only at night to retention control training and the enuresis alarm. Behav Res Ther 1980;18:305.\n• Koff SA,Non-neuropathic vesicouretral dysfunction in children In: Paediatric Urology O’Donnell B, Koff SA, editors 3rd edition, Butterworth Heinemann Oxford 1997, p. 220-222.\n• Schulman SL, Duckett JW, Disorders of bladder function In: Paediatric Surgery O’Neil JA, Rowe MI, Grosfeld JL, Fonkalsrud EW, Coran AG, editors, 5th edition, Mosby-year book Inc 1998, p.1671-1683",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// BlogDetailPage2: İkinci blog içeriği
class BlogDetailPage2 extends StatelessWidget {
  const BlogDetailPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enürezis Nokturna ve Enürezis Alarm")),
      body: Container(
        color: const Color(0xFF81D4FA), // Arka plan rengi
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Enürezis Nokturna (Uykuda İşeme) ve Enürezis Alarm",
                style: TextStyle(
                  fontSize: 20,
                  height: 1.5,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 24),
              const Text(
                "Enürezis nokturna (uykuda işeme) günümüzde sağlıklı okul çocuklarının %15-30’unu etkileyebilen ve çoğunlukla monosemptomatik tipte (sadece gece işemeleri şeklinde) seyreden bir rahatsızlıktır 1,2. Gece işemesi bilimsel olarak, 5 yaşından sonra –haftada 2 defadan fazla olmak üzere- mesanenin yalnış yer ve zamanda tam olarak boşalması olarak ifade edilmektedir. Bu problem 5 yaş civarındakilerin yaklaşık %10’ unu, 10 yaş civarındakilerin yaklaşık %5’ ini ve daha üst yaştakilerin yaklaşık olarak %2’ sini etkileyebilmektedir. Bunun yanısıra bu sorun %1 oranında 18 yaş ve üzerinde devam etmektedir. Amerika’da gece işemesi sorunu olan 7 milyon çocuk vardır. Gece işemesi (Enürezis nokturna) çok yaygın fakat aynı zamanda bir o kadar gizli bir problemdir.",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 8),
              const Text(
                "Primer nokturnal enürezisin (uykuda işeme) etiyolojisinde çelişkiler olmasına karşın genetik faktörler (örneğin ebeveynlerden birisi çocukken bu rahatsızlığı yaşamışsa çocuğunun aynı sorunla karşılaşma olasılığı %40’tır. Eğer hem anne hem baba aynı sorunla karşı karşıya kalmışlarsa çocukta bu oran %75’e yükselmektedir), fonksiyonel mesane kapasitenin azlığı, geceleri artan diürez, uyku rahatsızlıkları, antidiüretik hormon salınımında anormallikler, ruhsal rahatsızlıklar, diet ve bakteriürinin rol oynayabileceği düşünülmektedir. Buna karşılık gece işemesi, bir tembellik sorunu, aile terbiyesinin eksikliğinden kaynaklanan bir problem, anti-diüretik hormonların azlığından kaynaklanan bir sorun veya özel diet eksikliği sorunu değildir. Ayrıca pahalı bir tedavi gerektiren bir sorun da değildir.",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 8),
              const Text(
                "Gece işemesi bir uyku hastalığıdır (parasomniadır). Hasta, derin uykuda olduğundan normal olarak oluşan mesane kasılmalarını algılayamaz ve mesane basıncındaki artışını hissedemez sonuç olarak yatağı ıslatır. Grafikte görülebileceği gibi normal bir insanın (kesikli çizgi) başını yastığa koymasını takiben uykuya dalması 1. Basamağı oluşturur. Uyku devresi buradan 2. 3. ve son olarak 4. Basamağa kadar ilerler. 4. Basamak en derin uyku devresidir. Yaklaşık 20 dakika sürer. Süre bitiminde tekrar 3. , 2. Ve 1. basamaklara geri dönülür. 2. Basamaktan 1. Basamağa geçiş R.E.M. (rapid eye movement (hızlı göz hareketleri)) uykusu olarak adlandırılır. Bu devre uykunun rüya görülen devresidir. Bu devre insanın gün içinde çevreden aldığı, depoladığı veya attığı tüm bilgilerin nerede tutulacağı bakımından önemlidir. Bu dönem ayrıca mesaneden beyine giden sinyallerin değerlendirildiği ve bu sinyallere cevap olarak, tuvalete mi gidileceğinin yoksa uykuya mı devam edileceğinin kararının verildiği dönemdir. R.E.M. uykusu yaklaşık 20 dakika sürmektedir. Bu devrenin bitiminde uyku siklusu devam eder. Bir gecelik uykuda normal insan bu siklusu ortalama 4-6 defa yaşar.",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              Image.asset(
                'assets/images/blog.png',
                width: double.infinity,
                height: 250,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 8),
              const Text(
                "Yine grafikte görüleceği üzere gece işemesi sorunu olan kişiler derin uykuya çok çabuk dalarak direkt olarak uykunun 4. devresine girerler ve burada kalırlar (düz çizgi ile gösterilmiştir). Bir süre sonra (zamanı tam olarak bilinmemektedir, yarım saat veya saatler sonra olabilir) mesane, beyine tuvalete gitmesi için mesaj gönderir. Bundan sonra uykuda R.E.M. dönemi yükselir. Bu sadece 20-90 saniye sürer. Buna karşılık hasta derin uykuda olduğundan bu sinyale cevap veremez. Tüm bu sebeplerden hastaların geceden içecek almalarını önlemek, gece vakti onları tuvalete kaldırmak faydasızdır. Zira bu sebepler gece işemesinde rol oynamazlar. Gece işemesi basitçe uykuda kontrolün yitirilmesidir. Bu sorun 4 yaşındakilerde de, 30 yaşındakilerde de aynıdır.",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 8),
              const Text(
                "5 – 6 yaşından sonra çocukların yataklarını ıslatmaları normal değildir. Bu nedenle oluşabilecek sosyal ve psikolojik bozukluklar sebebiyle tedavisi zorunlu bir sorundur.",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 8),
              const Text(
                "Enürezis alarmı, gece işemesi sorununun ekonomik yönden pahalı ve yan etkileri olan ilaçlarla tedavisi yerine ekonomik olarak ucuz, kalıcı, güvenli ve maximum başarı oranıyla çözümünü sağlamak amacıyla üretilmiştir. Enürezis alarm ilk olarak 1904 yılında bildirilmiş olmasına karşın, rutin kullanıma ancak 1930’ larda geçilmiştir",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 8),
              const Text(
                "Enürezis alarm gece elbisesinin yakasına rahatlıkla tutturulabilecek şekilde yapılmış olan hafif plastik kutu içerisindeki güvenli elektronik devreden ibarettir. Alarm, ince, sökülüp-takılabilir, sterilize edilebilir, paslanmaz, neme duyarlı bir sensöre (duyarga) bağlıdır. Bu sensör, iç çamaşırın dışına yerleştirilir. İdrar geldiğinde duyarga nemlenir ve alarm çalışır ve uyarı aktive olur. Uyaran çocuğu uyandırır ve daha önemlisi external sfinkter kasının aniden kasılmasına neden olarak idrarın mesaneden akmasını önler. Uyarı ses şeklindedir. İdrar gelmesini takiben alarmın çalışmasıyla tekrar tekrar uyandırılma beyni, mesane üzerindeki otomatik kontrolü sağlaması konusunda eğitir. Nihayetinde, hasta ya idrar gelmeden uyanacaktır veya mesaneyi boşaltmaya ihtiyaç duymadan bütün gece uyuyacaktır. Enürezis nokturnanın (uykuda işeme) tedavisi geceleri hastanın kendi kendine uyanarak tuvalete gitmesidir. Enürezis alarm hastaya bu yeteneği kazandırdığı için daha kalıcı ve nüksetme olasılığı çok daha az bir tedavi olanağı sağlar. Ayrıca enürezis alarmın fonksiyonel mesane kapasitesini artırdığı yapılan çalışmalarda gösterilmiştir. Enürezis alarmın bu etkisinin de sağladığı tedavide rolü olduğu düşünülmektedir. Bunun yanısıra alarmın fiyatı, sadece 2 haftalık desmopressin uygulamasının hastaya maliyetine eşittir",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 8),
              const Text(
                "Bu tedavi şekli; güvenli ve ekonomik bir şekilde (1), yan etkisiz (2) birkaç hafta içinde %80’nin üzerinde başarıyla gece işemesi sorununu gidermektedir. Ürolog Dr. Bruce L. Dunn, M.D., 1978-79 yıllarında yaptığı çalışmada, gece işeme problemi olan 125 çocukta alarm kullanarak yaptığı tedavide %76 başarı sağladığını bildirmiştir.",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 8),
              const Text(
                "Faraj ve arkadaşları tarafından 1999’da yapılan çalışmada, enürezis nokturna tedavisinde sıkça kullanılan 40 mikrogram intranazal desmopressin uygulamasının (n=33) kısa dönemde etkili olduğu ancak 3 aydan sonra etkisinin azalmaya başladığı (kuru geçen gece oranı, ilaç tedavisinden 15 gün sonra %80, 3 ay sonra %85, 6 ay sonra %78) buna karşılık enürezis alarm ile tedavide (n=43) zamanla tedavi oranında artış olduğu (kuru geçen gece oranı, tedavi başlangıcından 15 gün sonra %50, 3 ay sonra %90, 6 ay sonra %94) gösterilmiştir",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 8),
              const Text(
                "1991’de yayınlanan bir makalede, 6 ile 19 yaş arasındaki 326 hastanın 76’sının (%23) kendi kendilerine tedavi oldukları, geri kalan 250 hastanın (161 erkek, 89 bayan) 211’inin (%84) alarm ile tedavi oldukları, geri kalan 39 hastanın (%16) tedavi olamadıkları bildirilmiştir",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 8),
              const Text(
                "Yachiku ve ark. tarafından 1989’ da yapılan çalışmada; alarm tedavisiyle 3 ay içerisinde 50 hastanın 28 ‘inde (%56) tam, 12’sinde (%24) tatminkar, 9’ unda (%18) hafif tedavi cevabı alındığını buna karşılık 1 hastada (%2) hiç cevap alınmadığını bildirmişler böylece alarm ile tedavinin %80 başarı sağladığını, bu nedenle alarm ile tedavinin trisiklik antidepresanlar ile tedaviden çok daha etkili olduğunu göstermişlerdir",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 8),
              const Text(
                "Bartolozzi ve ark. yaptıkları çalışmada 6-15 yaş arasındaki 130 hastada (primer ve sekonder enürezisli) enürezis alarmı denemişler ve çoğu hastanın (%77) 12 hafta içerisinde tedavi olduğunu göstermişlerdir",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 8),
              const Text(
                "Monda ve arkadaşları tarafından 1995 yılında yapılan çalışmada hastalar, kontrol (n=50), İmipramin (n=44), desmopressin (n=88) ve alarm (n=79) grubu olmak üzere 4 gruba ayrılmış ve tedavilerine başlanmıştır. Gözlemler tedavinin 6. ve 12. Ayında yapılmış ve tedavi olanların yüzdesi hesaplanmıştır. Kontrol grubunda sırası ile %6, % 16; İmipramin grubunda %36, %16; Desmopressin grubunda %68, %10; alarm grubunda ise %63, %56 tedavi sağlanmıştır. Bu sonuçlar ile alarm ile tedavinin en kalıcı ve en etkili yöntem olduğu gösterilmiştir",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 8),
              const Text(
                "Bu çalışmaların yanısıra Enürezis alarm tedavisinin 40 mikrogram intranazal Desmopressin tedavisi ile desteklenmesinin sorunu daha kısa sürede ve kalıcı olarak ortadan kaldırdığını gösteren çalışmalar da vardır.",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 8),
              const Text(
                "Bradbury 1995 ve 1997 ‘ de yaptığı ayrı çalışmalarda da Alarm ile tedavinin 40 mikrogram intarnazal desmopressin ile desteklenmesinin (n=35), alarm ile tek başına tedaviden daha etkili olduğunu göstermiştir (alarm ve desmopressinin birlikte uygulandığı grupta 1 haftada kuru geçen gece ortalaması 6.1 iken, sadece alarm tedavisi gören grupta bu oran 4.8’dir).Ayrıca 4 hafta süren kuru döneme ulaşabilen çocukların sayısı, kombine tedavi gören grupta 27 (%75) iken diğer grupta 16 (%46)’ dır",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 8),
              const Text(
                "Bunun yanısıra Hjalmas ve ark. Tarafından İsveç’te yapılan çalışmada da kombine tedavinin daha etkili olduğu sonucuna varılmıştır",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 8),
              const Text(
                "Sukhai ve ark. Yaptıkları çalışmada, 2 hafta içerisinde, Alarm tedavisi ile birlikte 20 mikrogram intranazal desmopressin uygulanması sonucunda bir haftadaki kuru gece sayısı ortalamasının 5.1’e (kuru gece/hafta) yükseldiğini buna karşılık sadece alarm tedavisi gören hastalarda ortalamanın 4.1 olduğunu göstermişlerdir",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 8),
              const Text(
                ")1994’ te Danimarka’ da yapılan araştırmada, ülke genelinde Desmopressin tedavisinin 1 yıllık giderinin 44.8 milyon DKK olduğu, buna karşılık alarm ile tedavi giderinin 19.2 milyon DKK olduğu gösterilmiştir",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 8),
              const Text(
                "Daha önce alarm tedavisi görmüş 7-14 yaşındaki çocuklarda yapılan araştırmada, psikosomatik semptomlarda dahil olmak üzere hiçbir mental yan etkiye rastlanmadığı, herhangi bir artık etkininde görülmediği bunun yanısıra tedavi gören hastalarının çoğunun gördükleri tedaviyi olumlu ve etkili bulduklarını bildirilmiştir",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 8),
              const Text(
                "Uzm. Ecz. Riyad Akpınar tarafından tercüme, sadeleştirme ve düzenlemesi yapılmıştır.",
                style: TextStyle(fontSize: 16, height: 1.5,  fontWeight: FontWeight.bold),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
