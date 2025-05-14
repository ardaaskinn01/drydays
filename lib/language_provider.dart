import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  Locale _currentLocale = const Locale('tr');

  final Map<String, Map<String, String>> _localizedStrings = {
    'tr': {
      'aboutTitle': 'Hakkımızda',
      'aboutP1':
          'Kardelen Tıbbi Cihazlar olarak 1997 yılında İzmir’de kurulmuş önce müşteri memnuniyeti ve kaliteli ürün ilkesi ile yola çıkarak, istikrarlı adımlarla yükselmek inancıyla hizmetlerini sürdürmektedir.',
      'aboutP2':
          'Kardelen Tıbbi Cihazlar kurulduğu yıldan bu yana elektronik, medikal sektöründe imalat satış ve pazarlama alanında hizmet vermektedir.',
      'aboutP3':
          'Marka yaratmanın, ürün geliştirmenin ve bunları pazarda tutundurarak kalıcı olmanın değerine ilk günden beri inandığımız için, tasarım ve patenti kendi üzerimize ait olan ürünlerimizi yurt içi ve yurt dışı pazarlarda tüketicilerin beğenisine sunduk.',
      'aboutP4':
          'Ürünlerimizin pazarlarda aranılan ve beğenilen ürünler olması bize gurur veriyor.',
      'aboutP5':
          'Dry Days adıyla başarıyla üretmekte olduğumuz cihazımız, birçok ilimizin üniversite ve özel hastahanelerinde değerli hekimlerimiz tarafından güvenle tavsiye edilip reçetelendirilmektedir.',
      'aboutP6':
          'Günümüz teknolojisini yakından takip eden ve çalışmalarına her geçen gün yenisini ekleyen uzman kadrosu ve Ar-Ge çalışmaları ile, yurt içi ve yurt dışında her geçen gün artan müşteri memnuniyeti ile adından söz ettirmiş; ve medikal sektöründe saygın bir yer edinmiştir.',
      'aboutP7':
          'Müşterilerimize en iyi hizmeti suna bilmemiz için firma politikası olarak yurt içi ve yurt dışında bayilerimizin ve tüketicilerin ürünlerimiz üzerindeki olumlu yorumlarını ve göstermiş oldukları beğenilerini sarsacak her türlü girişimcilere karşı Türk Patent Enstitüsü tarafından marka ve patent belgesi tescili yapılmış olup siz değerli müşterilerimize böyle bir hizmet ve ürünü sunmaktan gurur duymaktayız.',
      'blogTitle': 'Blog',
      'blog1Title': 'Cerrah Gözüyle Enzürezis',
      'blog1Date': '9 Eylül 2018',
      'blog1Summary':
          'Enürezis çocukluk çağının en önemli ve en sık görülen işeme bozukluğudur. Uyku sırasında mesanenin fonksiyonel kapasitesi dolduğunda ortaya çıkan kendini boşaltma ihtiyacı çocuk uyanır ve gece tuvalete işerse (nokturi), uyanamaz ve yatağına işerse (enürezis) olarak adlandırılır.',
      'tag1': 'distal üreteral stenoz',
      'tag2': 'epidemiyoloji',
      'tag3': 'etiyoloji',
      'tag4': 'hinman sendromu',
      'tag5': 'tembel mesane',
      'enuresisTitle': 'Enürezis Nokturna (Uykuda İşeme) ve Enürezis Alarm',
      'tagEnuresis': 'enürezis',
      'tagBedwetting': 'uykuda işeme',
      'enuresisSummary':
          'Genelenürezis, uykuda işeme. Enürezis nokturna (uykuda işeme) günümüzde sağlıklı okul çocuklarının %15-30’unu etkileyebilen...'
          ' Gece işemesi bilimsel olarak, 5 yaşından sonra –haftada 2 defadan fazla olmak üzere- mesanenin yanlış yer ve zamanda...',
      'otherInfo': 'Diğer bilgilendirmeler:',
      'pleaseSelectAlarm': 'Lütfen önce bir alarm seçin.',
      'turnOnBluetooth':
          'Cihazınızda Bluetooth kapalı. Lütfen açıp tekrar deneyin.',
      'passwordTitle': 'Giriş Şifresi',
      'passwordHint':
          'Kullanım Kılavuzunda size verilen şifreyi girerek bu ekrana giriş yapabilirsiniz.',
      'passwordLabel': 'Şifre',
      'wrongPassword': 'Hatalı şifre, lütfen tekrar deneyin.',
      'loginButton': 'Giriş Yap',
      'bluetoothSettings': 'Bluetooth',
      'startBluetooth': "Bluetooth'u Başlat",
      'stopBluetooth': "Bluetooth'u Durdur",
      'foundDevices': 'Bulunan Cihazlar',
      'bluetoothNotStarted': 'Bluetooth henüz başlatılmadı',
      'alarmSettings': '🔔 Alarm Ayarları',
      'selectAlarm': 'Alarm Seç',
      'selected': 'Seçili',
      'noAlarmSelected': 'Alarm seçilmedi',
      'alarmActive': '🔔 ALARM!',
      'stopAlarm': 'Alarmı Kapat',
      'volume': '🔊 Ses Seviyesi',
      'selectingAlarm': 'Alarm Seçin',
      'alarm': 'Alarm',
      'tamKuru': 'Tam Kuru',
      'normal': 'Normal',
      'saveSuccess': 'Bilgiler kaydedildi',
      'alarmCount': 'Alarm çalma sayısı',
      'selectTime': 'Saat seçin',
      'diaperWetness': 'Bez Islaklığı',
      'outsideUrine': 'Tuvalette Sonlandırma Miktarı',
      'less': 'Az',
      'medium': 'Orta',
      'much': 'Çok',
      'dailyRecord': 'Günlük Kayıt',
      'selectBedTime': 'Gece yatma saati seçin',
      'bedTime': 'Yatma Saati',
      'selectWakeTime': 'Uyanma saati seçin',
      'wakeTime': 'Uyanma Saati',
      'morningStatus': 'Sabah Durumu',
      'completelyDry': 'Tam Kuru',
      'withAlarm': 'Alarmlı',
      'wet': 'Islak',
      'mood': 'Ruh Hali',
      'happy': 'Mutlu',
      'unhappy': 'Mutsuz',
      'save': 'Kaydet',
      'pleaseSelect': 'Lütfen seçiniz',
      'calendar': 'Takvim',
      'contact': 'İletişim',
      'address': '847/1 Sokak No:8 303 Sağlık İş Merkezi\nKonak / İzmir',
      'phone': '0232 484 17 04',
      'email': 'info@drydays.net',
      'treatment': 'Tedavi',
      'treatmentDetail':
          'Gece yatağını ıslatan çocuklar için alınacak ilk tedbir: bu çocukları bu alanda uzman bir hekime göstermektir. Enürezis birçok nedenle ortaya çıkan bir hastalık olduğu için, tedavisinde değişik yöntemler kullanılmaktadır. Çocuğun yaşına, gelişim düzeyine, enürezisin primer ya da sekonder oluşuna göre uygun tedavi yöntemleri seçilmelidir. Uygulanacak tedavi yöntemi konusunda aile ve çocuk bilgilendirilmelidir. Öncelikle altta yatan tıbbi ya da psikolojik bir neden olup olmadığı belirlenmeli ve varsa bu neden ortadan kaldırılmalıdır.\n\n'
          'Tedavi, motivasyon tedavisi, davranış tedavisi, alarm tedavisi ve ilaç tedavisi şeklinde planlanabilir. Motivasyon tedavisinde çocuğun bu konuda bilinçlendirilmesi, suçlanmaması, cezalandırılmaması, olumlu desteklenmesi esastır. Davranış tedavisinde ise çocuğun sıvı alımı düzenlenir, yatmadan önce tuvalete gitmesi sağlanır, gece uyandırılarak tuvalete gitmesi teşvik edilir. Ayrıca çocuğun kuru kalktığı her sabah ödüllendirilmesi gibi yöntemler kullanılır.\n\n'
          'Alarm ile tedavide çocuklarda %75-100 oranında iyileşme sağlanmaktadır. Alarm cihazı, çocuğun iç çamaşırına ya da yatağa yerleştirilen bir sensörle çalışır. Islaklık hissedildiğinde alarm çalar ve çocuk uyanır. Bu şekilde çocukta mesane doluluğunu algılama ve tuvalete gitme alışkanlığı kazandırılır.\n\n'
          'Uykuda işeme tedavisinde imipramin, oxybutynin, dezmopressin gibi ilaçlar kullanılmaktadır. Bu ilaçlar doktor kontrolünde ve belirli bir süre kullanılmalı, tedaviye yanıt alındığında ise aşamalı olarak kesilmelidir. Enürezisin tedavisinde başarı oranı yüksektir. Tedavi edilen çocuklarda özgüven artışı, okul ve sosyal yaşamda düzelmeler gözlemlenmektedir.',
      'whatIsEnuresis': 'Enurezis Nokturna nedir?',
      'whatIsEnuresisDetail':
          "Enürezis Nokturna (Uykuda işeme, altını ıslatma ya da gece işemesi); 5 yaşından büyük çocukların, uyku sırasında, tekrarlayıcı nitelikte, istemsiz idrar kaçırması, bu davranışın üç ay süre ile en az haftada iki kez ortaya çıkması olarak tanımlanır.\n\n"
          "Enürezis nokturna, sorunun başlangıç biçimi ve seyrine göre primer (birincil) ve sekonder (ikincil) olarak iki gruba ayrılır. En az bir yıllık idrar tutma periyodunun olmadığı durumlarda enürezis primer olarak adlandırılır. Primer enürezis için, en az 3 veya 6 aylık kuruluk periyodunun olmadığı durumları koşul kabul edenler de vardır. Tüm enuretiklerin %80-90’ını oluşturan bu grupta daha çok genetik yatkınlık, biyolojik ve gelişimsel etmenler sorumlu tutulmuştur. Sekonder enürezis ise en az 1 yıl süren kuru bir periyoddan sonra tekrarlamanın olmasıdır. Sekonder enürezis nokturna en sık 5-8 yaşlar arasında görülür ve bu grupta daha çok psikolojik etmenlerin sorunu başlattığı ileri sürülmektedir.\n\n"
          "Yapılan araştırmalarda erkek çocuklarda Uykuda işeme yüzdesi kız çocuklarına oranla daha yüksek olarak saptanmıştır. Bu çocuklarda yaşıtlarına göre gelişimsel gecikmeler de saptanmıştır. 5 yaş sonrasında tedavisiz kendiliğinden iyileşme oranı %5-10 arasında bulunmuştur. Ancak zamanı ve kesinliği bilinmeyen bu iyileşmeyi beklemek yanlış bir tutum olur çünkü, bu süre beklenirken rahatsızlık devam edeceğinden çocuk yabancı bir mekanda kalmak istemeyebilecek hatta arkadaşlarını misafir edemeyebilecektir v.b. bu da hem sosyal hem de psikolojik sorunlar yaşamasına sebep olacaktır.\n\n"
          "Enürezis nokturna’ın nedenlerini belirlemek güçtür, birçok varsayım ileri sürülmektedir.\n\n"
          "Yapılan araştırmalar enüreziste ailesel bir yatkınlık olduğu görüşünde birleşmektedir. Eğer anne-babanın her ikisinde de geçmişte ya da devam etmekte olan enürezis var ise çocukta bu durumun ortaya çıkma oranı %70-75, sadece birinde var ise bu risk %40-45’e düşmektedir. Ailesel bir bağ yoksa %15’e kadar azalmaktadır.\n\n"
          "5 yaşındaki bir çocuğun, uykusunda idrarını tutması mümkündür. Enuretik çocukların ise işlevsel mesane kapasitelerinin daha düşük olması nedeniyle istemli idrar yapma ve tutma yeteneğini daha geç kazandığı bildirilmektedir.\n\n"
          "Uyku evreleri ve enürezis arasındaki ilişkiyi araştıran ilk çalışmalarda, enürezisin derin uykuda ortaya çıktığı ve rüya eşdeğeri olduğu ileri sürülmüştür. Ancak son yıllarda yapılan daha kapsamlı ve ileri çalışmalar işemenin uykunun her döneminde olabildiğini göstermiştir. Enürezisin bir uyanabilme sorunu olduğunu kabul eden birçok araştırmacı vardır.\n\n"
          "Enürezisli hastaların önemli bir bölümünde sosyal uyum sorunları ve bazı davranış bozuklukları olduğu gözlenmiştir. Ancak son yıllardaki bazı çalışmalarda psikolojik sorunların enürezise değil, enürezisin bazı davranış bozukluklarına veya uyumsuzluğa yol açtığı ileri sürülmektedir. Nitekim enürezisi tedavi edilen çocuklarda olumlu yönde psikolojik etki gözlenir.",
      'how_to_use': 'Dry Days Nasıl Kullanılır',
      'instruction':
          'Dry Days Enürezis Alarm Cihazının seti içinde verilen duyarganın içine konulmasına yarayacak olan üç adet duyarga kılıfı külotlara dikilir.\n\n'
          'Alarm cihazı pijamanın omuz kısmına tutturulur ve ara kablo pijamanın içinden geçirilip külota dikilmiş olan kılıfın içine duyarga yerleştirilir.\n\n'
          'İdrarın ilk salınımıyla birlikte devreye giren alarm çalışmaya başlar ve hastayı uyandırır.\n\n'
          'İlk bir kaç hafta hastaya yardımcı olmak amacıyla (hasta küçük yaşta ise) aile bireylerinden biri kalkar ve idrarın devamının tuvalette sonlandırılmasını sağlar.\n\n'
          'İlerleyen günlerde oluşacak şartlı refleks sayesinde mesane kasılması hissiyle kalkıp tuvalete gidecek duruma gelecektir.\n\n'
          'Alarm cihazı ile birlikte verilen takvim üzerinde işaretlemeler yapılıp, doktor kontrolüne gidildiğinde takvim de götürülür böylece sürecinin daha rahat izlenmesi sağlanır.',
      'download_guide': 'Kullanım Kılavuzunu İndir',
      'download_success': 'Kılavuz indirildi: Downloads klasörüne kaydedildi.',
      'download_failure': 'İzin verilmedi. PDF indirilemedi.',
      'loadingApp': 'Uygulama Yükleniyor...',
      'home': 'Ana Sayfa',
      'howToUse': 'Nasıl Kullanılır?',
      'downloadGuide': 'Kılavuz İndir',
      'guideDownloaded': 'Kılavuz indirildi: Downloads klasörüne kaydedildi.',
      'permissionDenied': 'İzin verilmedi. PDF indirilemedi.',
      'noSubUsersFound': 'Kayıtlı alt kullanıcı bulunamadı',
      'noName': 'İsim Yok',
      'noRole': 'Rol Yok',
      'addSubUser': 'Alt Kullanıcı Ekle',
      'subUser': 'Alt Kullanıcı',
      'user': 'Kullanıcı',
      'language': 'Dil',
      'settings': 'Ayarlar',
      'login': 'Giriş Yap',
      'logout': 'Çıkış Yap',
      'changePassword': 'Şifre Değiştir',
      'forgotPassword': 'Şifremi Unuttum',
      'resetPassword': 'Şifreyi Sıfırla',
      'welcome': 'Hoşgeldiniz',
      'profile': 'Profil',
      'notifications': 'Bildirimler',
      'editProfile': 'Profili Düzenle',
      'updateProfile': 'Profili Güncelle',
      'cancel': 'İptal',
      'search': 'Ara',
      'confirm': 'Onayla',
      'delete': 'Sil',
      'back': 'Geri',
      'next': 'İleri',
      'previous': 'Önceki',
      'finish': 'Bitir',
      'submit': 'Gönder',
      'error': 'Hata',
      'success': 'Başarılı',
      'noData': 'Veri Yok',
      'loading': 'Yükleniyor...',
      'welcomeMessage': 'Uygulama Yükleniyor...',
      'tutorialTitle': 'Öğretici',
      'welcomeEmoji': '👋',
      'welcomeText':
          'HOŞ GELDİNİZ! Uygulamayı ilk kez kullanacaksınız. Başlamadan önce sizi bilgilendireceğiz.',
      'bookEmoji': '📚',
      'bookText':
          'Bu uygulamada enürezis hakkında bilgilendirmeler yapıyoruz. Aynı zamanda gecelik uyanma kaydınızı tutmanıza imkan verip istediğiniz zaman çıktı alabilmenize olanak tanıyoruz.',
      'moonEmoji': '🌙',
      'moonText':
          'Gecelik kayıt tutmak için sabah uyanışın ardından ana sayfadaki bilgileri girmeniz yeterli.',
      'calendarEmoji': '📅',
      'calendarText':
          'Eğer önceki günleri de doldurmak isterseniz takvim sayfamızdan gün seçip bilgileri girebilirsiniz.',
      'lockEmoji': '🔒',
      'lockText':
          'Girdiğiniz bilgilere kimse erişmez. İsminize özel kayıtlı tutulur.',
      'bellEmoji': '🔔📱',
      'bellText':
          'Eğer Bluetooth destekli Dry Days cihazınız varsa uygulamadaki Bluetooth ekranında Bluetooth\'u başlatıp geceleri telefonunuzu açık tutarak alarm çaldırabilirsiniz!',
      'checkEmoji': '✅',
      'checkText': 'Bilgilendirme bu kadardı! İyi kullanımlar dileriz.',
      'preview': 'Önizleme',
      'ourProducts': 'Ürünlerimiz',
      'viewOnTrendyol': 'Trendyol\'da Görüntüle',
      'buyOnTrendyol': 'Trendyol\'da Satın Al',
      'productDescription':
          'Dry Days Enürezis Alarmlarımızın ölçüleri: Uzunluk 6 cm, Genişlik 4,5 cm, Derinlik 3 cm’dir. Ürünlerimiz; kişinin en kısa sürede uyarılması için ve her yaşta enüretik hastanın güvenle kullanması için tasarlanmıştır.\n\nDry Days adıyla başarıyla üretmekte olduğumuz cihazımız birçok ilimizin üniversite ve hastanelerinde, değerli hekimlerimiz tarafından güvenle tavsiye edilip, reçetelendirilmektedir.',
      'dryDaysSound': 'Dry Days Sesli Uyarı',
      'dryDaysVibration': 'Dry Days Titreşimli Uyarı',
      'dryDaysPlus': 'Dry Days Plus (Sesli+Titreşimli)',
      'reportDate': 'Rapor Tarihi',
      'sleepTime': 'Uyku Saati',
      'moodStatus': 'Ruh Hali',
      'alarmDetails': 'Alarm Detayları',
      'alarmTime': 'Alarm Saati',
      'shareReport': 'Raporu Paylaş',
      'generateReport': 'Rapor Oluşturma',
      'selectYear': 'Yıl Seçin',
      'selectMonth': 'Ay Seçin',
      'selectedYear': 'Seçilen Yıl',
      'month': 'Ay',
      'createReport': 'Rapor Oluştur',
      'pdfNotGenerated': 'PDF oluşturulamadı!',
      'viewPdf': 'PDF\'i İncele',
      'about': 'Hakkımızda',
      'products': 'Ürünler & Aksesuarlar',
      'enuresis': 'Enürezis Nokturna Nedir',
      'blog': 'Blog',
      'bluetooth': 'Bluetooth',
      'tutorial': '📘 Öğretici',
      'languageSelect': 'Dil Seçimi',
      'turkish': '🇹🇷 Türkçe',
      'azerbaijani': '🇦🇿 Azərbaycan',
      'english': '🇬🇧 English',
      'privacyNoticeTitle': 'Gizlilik Bilgilendirmesi',
      'privacyNoticeContent':
          'Bu uygulama, kullanıcıdan gelen verileri saklar. Geliştirici bu verilere erişmez ve işlemez. Uygulamanın amacı yalnızca kullanıcıların kendi süreçlerini takip etmelerini kolaylaştırmaktır.',
      'ok': 'Tamam',
      'enterName': 'İsim Giriniz',
      'nameHint': 'İsim Soyisim',
      'nameExists':
          'Bu isim daha önce alınmış. Lütfen farklı bir isim giriniz.',
      'pageTitle': 'İşlem Girişi',
      'nameSurname': 'İsim Soyisim',
      'day': 'Gün',
      'done': 'Tamamla',
      'tutorial_1':
          'HOŞ GELDİNİZ! Uygulamayı ilk kez kullanacaksınız. Başlamadan önce sizi bilgilendireceğiz.',
      'tutorial_2':
          'Bu uygulamada enürezis hakkında bilgilendirmeler yapıyoruz. Aynı zamanda gecelik uyanma kaydınızı tutmanıza imkan verip istediğiniz zaman çıktı alabilmenize olanak tanıyoruz.',
      'tutorial_3':
          'Gecelik kayıt tutmak için sabah uyanışın ardından ana sayfadaki bilgileri girmeniz yeterli.',
      'tutorial_4':
          'Eğer önceki günleri de doldurmak isterseniz takvim sayfamızdan gün seçip bilgileri girebilirsiniz.',
      'tutorial_5':
          'Girdiğiniz bilgilere kimse erişmez. İsminize özel kayıtlı tutulur.',
      'tutorial_6':
          'Eğer Bluetooth destekli Dry Days cihazınız varsa uygulamadaki Bluetooth ekranında Bluetooth\'u başlatıp geceleri telefonunuzu açık tutarak alarm çaldırabilirsiniz!',
      'tutorial_7': 'Bilgilendirme bu kadardı! İyi kullanımlar dileriz.',
      'alarmRecords': 'Kayıtlar',
      'tap_to_open': 'Açmak için tıklayın.',
    },
    'az': {
      'aboutTitle': 'Haqqımızda',
      'aboutP1':
          'Kardelen Tibbi Cihazlar 1997-ci ildə İzmir şəhərində müştəri məmnuniyyəti və keyfiyyətli məhsul prinsipi ilə qurulmuş və inkişaf etmək inamı ilə xidmətlərini davam etdirməkdədir.',
      'aboutP2':
          'Kardelen Tibbi Cihazlar, qurulduğu gündən etibarən elektron və tibbi sahədə istehsal, satış və marketinq sahələrində fəaliyyət göstərir.',
      'aboutP3':
          'Marka yaratmağın, məhsul inkişaf etdirməyin və onları bazarda möhkəmləndirməyin dəyərinə ilk gündən inandığımız üçün, dizaynı və patenti özümüzə aid olan məhsullarımızı daxili və xarici bazarlarda istifadəçilərə təqdim etdik.',
      'aboutP4':
          'Məhsullarımızın bazarda axtarılan və bəyənilən olması bizə qürur verir.',
      'aboutP5':
          'Dry Days adı ilə uğurla istehsal etdiyimiz cihazımız bir çox şəhərin universitet və özəl xəstəxanalarında həkimlər tərəfindən tövsiyə edilir.',
      'aboutP6':
          'Texnologiyanı yaxından izləyən və hər keçən gün yeni layihələr əlavə edən mütəxəssis heyəti və Ar-Ge çalışmaları ilə şirkətimiz daxildə və xaricdə müştəri məmnuniyyətini artırmaqdadır.',
      'aboutP7':
          'Məhsullarımıza olan marağı və bəyənini zəiflədə biləcək hər cür girişimə qarşı Türk Patent İnstitutu tərəfindən marka və patent qeydiyyatı edilmişdir və sizə belə bir xidmət təqdim etməkdən qürur duyuruq.',
      'blogTitle': 'Bloq',
      'blog1Title': 'Cərrah Baxışından Enürezis',
      'blog1Date': '9 Sentyabr 2018',
      'blog1Summary':
          'Enürezis uşaqlıq dövrünün ən vacib və ən çox rast gəlinən sidik ifrazı pozğunluğudur. Yuxu zamanı sidik kisəsinin funksional tutumu dolduqda uşaq ya oyanır və tualetə gedir (nokturiya), ya da oyanmadan yatağını isladır (enürezis).',
      'tag1': 'distal ureteral stenoz',
      'tag2': 'epidemiologiya',
      'tag3': 'etiyologiya',
      'tag4': 'hinman sindromu',
      'tag5': 'tənbəl sidik kisəsi',
      'enuresisTitle':
          'Enürezis Nokturna (Yuxuda Sidiyə Getmə) və Enürezis Alarm',
      'tagEnuresis': 'enürezis',
      'tagBedwetting': 'yuxuda sidiyə getmə',
      'enuresisSummary':
          'Genel enürezis, yuxuda sidik qaçırma. Enürezis nokturna bu gün sağlam məktəb uşaqlarının %15-30-nu təsir edə bilər...'
          ' Gecə sidik qaçırma elmi olaraq, 5 yaşdan sonra – həftədə 2 dəfə və daha çox hallarda – sidik kisəsinin yanlış zaman və yerdə boşalması ilə...',
      'otherInfo': 'Digər məlumatlar:',
      'pleaseSelectAlarm': 'Zəhmət olmasa əvvəlcə bir siqnal seçin.',
      'turnOnBluetooth':
          'Cihazınızda Bluetooth söndürülüb. Zəhmət olmasa aktiv edin və yenidən cəhd edin.',
      'passwordTitle': 'Giriş Şifrəsi',
      'passwordHint':
          'İstifadəçi təlimatında verilən şifrəni daxil edərək bu ekrana keçid edə bilərsiniz.',
      'passwordLabel': 'Şifrə',
      'wrongPassword': 'Yanlış şifrə, zəhmət olmasa yenidən cəhd edin.',
      'loginButton': 'Daxil ol',
      'bluetoothSettings': 'Bluetooth',
      'startBluetooth': "Bluetooth-u Başlat",
      'stopBluetooth': "Bluetooth-u Dayandır",
      'foundDevices': 'Tapılan Cihazlar',
      'bluetoothNotStarted': 'Bluetooth hələ işə salınmayıb',
      'alarmSettings': '🔔 Siqnal Ayarları',
      'selectAlarm': 'Siqnal Seç',
      'selected': 'Seçilmiş',
      'noAlarmSelected': 'Siqnal seçilməyib',
      'alarmActive': '🔔 SİQNAL!',
      'stopAlarm': 'Siqnalı Dayandır',
      'volume': '🔊 Səs Səviyyəsi',
      'selectingAlarm': 'Alarm Seçin',
      'alarm': 'Alarm',
      'tamKuru': 'Tam Quru',
      'normal': 'Normal',
      'saveSuccess': 'Məlumatlar yadda saxlanıldı',
      'alarmCount': 'Alarm sayı',
      'selectTime': 'Vaxt seçin',
      'diaperWetness': 'Bez nəmliliyi',
      'outsideUrine': 'Tualetdə sidik miqdarı',
      'less': 'Az',
      'medium': 'Orta',
      'much': 'Çox',
      'dailyRecord': 'Gündəlik Qeyd',
      'selectBedTime': 'Gecə yatma vaxtını seçin',
      'bedTime': 'Yatma Vaxtı',
      'selectWakeTime': 'Oyanma vaxtını seçin',
      'wakeTime': 'Oyanma Vaxtı',
      'morningStatus': 'Səhər Vəziyyəti',
      'completelyDry': 'Tam Quru',
      'withAlarm': 'Alarm ilə',
      'wet': 'Islaq',
      'mood': 'Əhval',
      'happy': 'Xoşbəxt',
      'unhappy': 'Narazı',
      'save': 'Yadda saxla',
      'pleaseSelect': 'Lütfen seçin',
      'calendar': 'Təqvim',
      'contact': 'Əlaqə',
      'address': '847/1 Sokak No:8 303 Sağlık İş Merkezi\nKonak / İzmir',
      'phone': '0232 484 17 04',
      'email': 'info@drydays.net',
      'treatmentDetail':
          'Gecə yatağını isladan uşaqlar üçün ilk tədbir, onları bu sahədə ixtisaslaşmış bir həkimə göstərməkdir. Enurezis bir çox səbəbdən qaynaqlana bilən bir vəziyyət olduğundan, müalicəsində müxtəlif üsullardan istifadə olunur. Müvafiq müalicə üsulu uşağın yaşı, inkişaf səviyyəsi və enurezisin ilkin (primer) və ya ikincili (sekonder) olmasına görə seçilməlidir. Ailə və uşağa müalicə prosesi haqqında məlumat verilməlidir. Əvvəlcə altda yatan tibbi və ya psixoloji bir səbəb olub-olmadığı müəyyən edilməli və varsa, bu səbəb aradan qaldırılmalıdır.\n\n'
          'Müalicə motivasiya terapiyası, davranış terapiyası, alarm terapiyası və dərman müalicəsi kimi planlaşdırıla bilər. Motivasiya terapiyasında uşağın bu barədə maarifləndirilməsi, günahlandırılmaması, cəzalandırılmaması və müsbət dəstəklənməsi əsasdır. Davranış terapiyasında uşağın maye qəbulu tənzimlənir, yatmazdan əvvəl tualetə getməsi təmin olunur və gecə oyadılaraq tualetə getməsi təşviq edilir. Uşaq səhər quru oyandıqda mükafatlandırılması kimi üsullardan istifadə olunur.\n\n'
          'Alarm müalicəsində uşaqlarda 75-100% arasında yaxşılaşma əldə olunur. Alarm cihazı uşağın alt paltarına və ya yatağına yerləşdirilən sensorla işləyir. Nəmlik hiss edildikdə cihaz siqnal verir və uşaq oyanır. Bu şəkildə uşaq sidik kisəsinin dolduğunu hiss etməyi və tualetə getmə vərdişi qazanır.\n\n'
          'Yatarkən sidik saxlaya bilməmənin müalicəsində imipramin, oksibutinin və desmopressin kimi dərmanlardan istifadə olunur. Bu dərmanlar həkim nəzarətində və müəyyən bir müddət ərzində istifadə edilməli, müalicəyə cavab alındıqdan sonra tədricən dayandırılmalıdır. Enurezisin müalicəsində uğur nisbəti yüksəkdir. Müalicə olunan uşaqlarda özünəinam artır və məktəb və sosial həyatda irəliləyişlər müşahidə olunur.',
      'treatment': 'Müalicə',
      'whatIsEnuresis': 'Enurezis Nokturna nədir?',
      'whatIsEnuresisDetail':
          "Enurezis Nokturna (uykuda işəmə, altını ıslatma və ya gecə işəməsi); 5 yaşından böyük uşaqların, yuxu zamanı, üç ay ərzində ən azı həftədə iki dəfə təkrarlanan, istəmədən sidik qaçırması ilə təyin olunur.\n\n"
          "Enurezis nokturna, problemin başlanğıcı və inkişafına görə iki qrupa bölünür: primer (ilk) və sekonder (ikincil). Birincili enurezis, bir il müddətində sidik saxlama periyodunun olmaması ilə təyin olunur. Birincili enurezis üçün ən az 3 və ya 6 aylıq quru periyodunun olmaması halları da qəbul edilir. Bu qrup, bütün enuretik uşaqların 80-90%-ını təşkil edir və burada daha çox genetik meyl, bioloji və inkişaf amillərinin təsirli olduğu düşünülür. Sekonder enurezis isə ən az bir il davam edən quru bir dövrdən sonra təkrarlanmasıdır. Sekonder enurezis nokturna ən çox 5-8 yaşlarında görülür və bu qrupda əsasən psixoloji amillərin problemi başlatdığı iddia edilir.\n\n"
          "Tədqiqatlarda oğlan uşaqlarında uykuda işəmə faizi qız uşaqlarına nisbətən daha yüksək olduğu müəyyən edilmişdir. Bu uşaqlarda həmçinin yaşdaşlarına nisbətən inkişaf gerilikləri də aşkar edilmişdir. 5 yaşdan sonra müalicə olmadan özbaşına yaxşılaşma nisbəti 5-10% arasında tapılmışdır. Lakin, vaxtı və dəqiqliyi məlum olmayan bu yaxşılaşmanı gözləmək düzgün bir yanaşma olmaz, çünki bu müddət ərzində narahatlıq davam edəcək və uşaq yad bir məkanda qalmaq istəməyə bilər və ya dostlarını qonaq qəbul edə bilməyəcək və s. Bu da həm sosial, həm də psixoloji problemlərə səbəb ola bilər.\n\n"
          "Enurezis nokturnanın səbəblərini müəyyən etmək çətindir, bir çox fərziyyələr irəli sürülür.\n\n"
          "Tədqiqatlar enurezisdə ailəvi meyilin olduğu fikrində birləşir. Əgər valideynlərin hər ikisində keçmişdə və ya davam etməkdə olan enurezis varsa, uşaqda bu vəziyyətin yaranma ehtimalı 70-75%, yalnız birində varsa, bu risk 40-45%-ə düşür. Ailəvi əlaqə yoxdursa, risk 15%-ə qədər azalır.\n\n"
          "5 yaşında bir uşaq, yuxusunda sidiyini tutmağı bacara bilər. Enuretik uşaqların isə funksional sidik kisəsi kapasitesinin daha aşağı olması səbəbindən istəmli sidik etmə və tutma bacarıqlarını daha gec qazandığı bildirilir.\n\n"
          "Yuxu mərhələləri ilə enurezis arasındakı əlaqəni araşdıran ilk tədqiqatlarda, enurezisin dərindən yuxuda meydana gəldiyi və yuxunun ekvivalenti olduğu irəli sürülmüşdür. Lakin son illərdə aparılmış daha geniş və inkişaf etmiş tədqiqatlar sidik etmənin yuxunun hər mərhələsində baş verə biləcəyini göstərmişdir. Bir çox araşdırıcı, enurezisi bir oyanma problemi olaraq qəbul edir.\n\n"
          "Enurezisli xəstələrin əhəmiyyətli bir hissəsində sosial uyğunlaşma problemləri və bəzi davranış pozğunluqları olduğu müşahidə olunmuşdur. Lakin son illərdə bəzi tədqiqatlarda psixoloji problemlərin enurezisə deyil, enurezisin bəzi davranış pozğunluqlarına və ya uyğunlaşmazlığa səbəb olduğu irəli sürülür. Əslində enurezisi müalicə edilmiş uşaqlarda müsbət psixoloji təsirlər müşahidə olunur.",
      'how_to_use': 'Dry Days cihazını necə istifadə etmək olar',
      'instruction':
          'Dry Days cihazı, içərisində sensor olan üç sensor örtüyünü alt paltara tikmək üçün istifadə edilir.\n\n'
          'Alarm cihazı pijamanın çiyin hissəsinə bağlanır və kablo pijamanın içindən keçirilib alt paltara tikilmiş sensor örtüyünə yerləşdirilir.\n\n'
          'İlk sidik ifrazı ilə birlikdə alarm işə düşər və xəstəni oyandırar.\n\n'
          'İlk bir neçə həftə, xəstə uşaqlarsa, bir ailə üzvü onu tuvaletə yönləndirər.\n\n'
          'Sonraki günlərdə, şərti refleks nəticəsində xəstə, sidik kisəsi sancısını hiss edərək tuvaletə getməyi öyrənəcəkdir.\n\n'
          'Cihazla verilən təqvimə işarələr qoyulur və həkimə gedərkən bu təqvim də götürülür.',
      'download_guide': 'İstifadə Təlimatını Yüklə',
      'download_success': 'Təlimat yükləndi: Yükləmə qovluğuna saxlanıldı.',
      'download_failure': 'İcazə verilmədi. PDF yüklənə bilmədi.',
      'loadingApp': 'Tətbiq yüklənir...',
      'home': 'Ana Səhifə',
      'howToUse': 'Necə İstifadə Edilir?',
      'downloadGuide': 'Təlimatı Endir',
      'guideDownloaded': 'Təlimat endirildi: Yükləmələr qovluğuna saxlanıldı.',
      'permissionDenied': 'İcazə verilmədi. PDF endirilmədi.',
      'noSubUsersFound': 'Alt istifadəçilər tapılmadı',
      'noName': 'Ad yoxdur',
      'noRole': 'Vəzifə yoxdur',
      'addSubUser': 'Alt İstifadəçi Əlavə Et',
      'subUser': 'Alt İstifadəçi',
      'user': 'İstifadəçi',
      'language': 'Dil',
      'settings': 'Ayarlar',
      'login': 'Daxil Ol',
      'logout': 'Çıxış Et',
      'changePassword': 'Şifrəni Dəyişdir',
      'forgotPassword': 'Şifrəni Unutdum',
      'resetPassword': 'Şifrəni Sıfırla',
      'welcome': 'Xoş Gəlmisiniz',
      'profile': 'Profil',
      'notifications': 'Bildirişlər',
      'editProfile': 'Profili Düzəlt',
      'updateProfile': 'Profili Yenilə',
      'cancel': 'Ləğv Et',
      'search': 'Axtar',
      'confirm': 'Təsdiq Et',
      'delete': 'Sil',
      'back': 'Geri',
      'next': 'Növbəti',
      'previous': 'Əvvəlki',
      'finish': 'Bitir',
      'submit': 'Göndər',
      'error': 'Xəta',
      'success': 'Uğurlu',
      'noData': 'Veri yoxdur',
      'loading': 'Yüklənir...',
      'welcomeMessage': 'Tətbiq yüklənir...',
      'tutorialTitle': 'Təlimat',
      'welcomeEmoji': '👋',
      'welcomeText':
          'Xoş Gəldiniz! Tətbiqi ilk dəfə istifadə edirsiniz. Başlamadan əvvəl sizi məlumatlandıracağıq.',
      'bookEmoji': '📚',
      'bookText':
          'Bu tətbiqdən enurezis barədə məlumat veririk. Həmçinin gecə oyandıqda qeydlərinizi saxlamağınıza və istədiyiniz vaxt çap etməyinizə imkan yaradırıq.',
      'moonEmoji': '🌙',
      'moonText':
          'Gecəlik qeyd saxlamaq üçün səhər oyanandan sonra ana səhifədəki məlumatları daxil etməniz kifayətdir.',
      'calendarEmoji': '📅',
      'calendarText':
          'Əgər əvvəlki günləri də doldurmaq istəyirsinizsə, təqvim səhifəmizdən gün seçib məlumatları daxil edə bilərsiniz.',
      'lockEmoji': '🔒',
      'lockText':
          'Daxil etdiyiniz məlumatlara heç kim daxil ola bilməz. Şəxsi olaraq adınıza qeyd olunur.',
      'bellEmoji': '🔔📱',
      'bellText':
          'Əgər Bluetooth dəstəyi olan Dry Days cihazınız varsa, tətbiqin Bluetooth ekranında Bluetooth-u aktivləşdirərək gecələri telefonunuzu açıq saxlayıb zəngli siqnal çaldıra bilərsiniz!',
      'checkEmoji': '✅',
      'checkText': 'Təlimat bu qədər idi! Yaxşı istifadə etməyinizi diləyirik.',
      'preview': 'Əvvəlcədən baxış',
      'ourProducts': 'Məhsullarımız',
      'viewOnTrendyol': 'Trendyol-da Bax',
      'buyOnTrendyol': 'Trendyol-da Al',
      'productDescription':
          'Dry Days Enurezis Alarmlarımızın ölçüləri: Uzunluq 6 sm, En 4.5 sm, Dərinlik 3 sm-dir. Məhsullarımız insanın qısa müddətdə xəbərdar edilməsi və hər yaşda enuretik xəstənin etibarlı istifadə etməsi üçün hazırlanmışdır.\n\nDry Days adı ilə istehsal etdiyimiz cihaz bir çox şəhərin universitet və xəstəxanalarında həkimlərimiz tərəfindən tövsiyə olunur və reseptlə verilir.',
      'dryDaysSound': 'Dry Days Səsli Xəbərdarlıq',
      'dryDaysVibration': 'Dry Days Titrəmə Xəbərdarlıq',
      'dryDaysPlus': 'Dry Days Plus (Səsli+Titrəmə)',
      'reportDate': 'Hesabat Tarixi',
      'sleepTime': 'Yatma Vaxtı',
      'moodStatus': 'Əhval',
      'alarmDetails': 'Alarm Məlumatları',
      'alarmTime': 'Alarm Vaxtı',
      'shareReport': 'Hesabatı Paylaş',
      'generateReport': 'Hesabat Yarat',
      'selectYear': 'İli Seçin',
      'selectMonth': 'Ayı Seçin',
      'selectedYear': 'Seçilmiş İl',
      'month': 'Ay',
      'createReport': 'Hesabat Yarat',
      'pdfNotGenerated': 'PDF yaradılmadı!',
      'viewPdf': 'PDF\'ə Bax',
      'about': 'Haqqımızda',
      'products': 'Məhsullar & Aksesuarlar',
      'enuresis': 'Enurezis Nokturna Nədir',
      'blog': 'Bloq',
      'bluetooth': 'Bluetooth',
      'tutorial': '📘 Təlimat',
      'languageSelect': 'Dil Seçimi',
      'turkish': '🇹🇷 Türk dili',
      'azerbaijani': '🇦🇿 Azərbaycan dili',
      'english': '🇬🇧 İngilis dili',
      'privacyNoticeTitle': 'Məxfilik Məlumatı',
      'privacyNoticeContent':
          'Bu tətbiq istifadəçi məlumatlarını saxlayır. Tərtibatçı bu məlumatlara daxil olmur və onları işlətmir. Tətbiqin məqsədi istifadəçilərin öz proseslərini izləmələrini asanlaşdırmaqdır.',
      'ok': 'Təsdiq',
      'enterName': 'Adınızı daxil edin',
      'nameHint': 'Ad Soyad',
      'nameExists':
          'Bu ad artıq istifadə olunub. Zəhmət olmasa başqa bir ad seçin.',
      'pageTitle': 'Əməliyyat Girişi',
      'nameSurname': 'Ad Soyad',
      'day': 'Gün',
      'dry': 'Tam Quru',
      'sad': 'Kədərli',
      'done': 'Tamamla',
      'tutorial_1':
          'XOŞ GƏLMİSİNİZ! Tətbiqi ilk dəfə istifadə edirsiniz. Başlamadan əvvəl sizi məlumatlandıracağıq.',
      'tutorial_2':
          'Bu tətbiqdə enurezis haqqında məlumatlar təqdim olunur. Gecə oyandığınız zamanları qeyd edə və istədiyiniz zaman bu məlumatları çıxara bilərsiniz.',
      'tutorial_3':
          'Gecə qeyd aparmaq üçün səhər oyandıqdan sonra ana səhifədəki məlumatları doldurmanız kifayətdir.',
      'tutorial_4':
          'Əvvəlki günlərə də məlumat əlavə etmək istəsəniz, təqvim səhifəmizdən gün seçərək məlumat əlavə edə bilərsiniz.',
      'tutorial_5':
          'Daxil etdiyiniz məlumatlara heç kim daxil ola bilməz. Məlumatlar adınıza xüsusi saxlanılır.',
      'tutorial_6':
          'Əgər Bluetooth dəstəkləyən Dry Days cihazınız varsa, tətbiqdəki Bluetooth ekranında funksiyanı aktiv edib, telefonu açıq saxlayaraq gecələr zəngi çaldıra bilərsiniz!',
      'tutorial_7': 'Məlumatlandırma bu qədər! Uğurlar!',
      'alarmRecords': 'Qeydlər',
      'tap_to_open': 'Açmaq üçün toxunun.',
    },
    'en': {
      'aboutTitle': 'About Us',
      'aboutP1':
          'Founded in 1997 in İzmir, Kardelen Medical Devices continues its services with the principle of customer satisfaction and quality products.',
      'aboutP2':
          'Since its establishment, Kardelen Medical Devices has been serving in manufacturing, sales, and marketing in the electronics and medical sectors.',
      'aboutP3':
          'Believing in the value of branding and product development since day one, we offer our patented designs to both domestic and international markets.',
      'aboutP4':
          'We are proud that our products are in demand and appreciated in the markets.',
      'aboutP5':
          'Our device, successfully produced under the name Dry Days, is safely recommended and prescribed by physicians in many universities and hospitals.',
      'aboutP6':
          'With a team that follows technology closely and constantly adds new work, we have earned a reputable place in the medical sector with increasing customer satisfaction.',
      'aboutP7':
          'To protect customer trust, our products are trademarked and patented by the Turkish Patent Institute against any unauthorized use.',
      'blogTitle': 'Blog',
      'blog1Title': 'Enuresis Through a Surgeon’s Eye',
      'blog1Date': 'September 9, 2018',
      'blog1Summary':
          'Enuresis is one of the most important and common voiding disorders in childhood. When the functional capacity of the bladder is exceeded during sleep, the child either wakes up to urinate (nocturia) or wets the bed (enuresis).',
      'tag1': 'distal ureteral stenosis',
      'tag2': 'epidemiology',
      'tag3': 'etiology',
      'tag4': 'hinman syndrome',
      'tag5': 'lazy bladder',
      'enuresisTitle': 'Nocturnal Enuresis (Bedwetting) and Enuresis Alarm',
      'tagEnuresis': 'enuresis',
      'tagBedwetting': 'bedwetting',
      'enuresisSummary':
          'General enuresis, bedwetting. Nocturnal enuresis (bedwetting) can affect 15–30% of healthy school children today...'
          ' Scientifically, bedwetting is defined as involuntary urination occurring more than twice a week after age 5, at the wrong time and place...',
      'otherInfo': 'More information:',
      'pleaseSelectAlarm': 'Please select an alarm first.',
      'turnOnBluetooth':
          "Bluetooth is closed on your device. Please turn it on and try again.",
      'passwordTitle': 'Password',
      'passwordHint': 'Enter the password provided in the user manual.',
      'passwordLabel': 'Password',
      'wrongPassword': 'Wrong password, please try again.',
      'loginButton': 'Login',
      'bluetoothSettings': 'Bluetooth',
      'startBluetooth': 'Start Bluetooth',
      'stopBluetooth': 'Stop Bluetooth',
      'foundDevices': 'Found Devices',
      'bluetoothNotStarted': 'Bluetooth is not started yet',
      'alarmSettings': '🔔 Alarm Settings',
      'selectAlarm': 'Select Alarm',
      'selected': 'Selected',
      'noAlarmSelected': 'No alarm selected',
      'alarmActive': '🔔 ALARM!',
      'stopAlarm': 'Stop Alarm',
      'volume': '🔊 Volume',
      'selectingAlarm': 'Select an Alarm',
      'alarm': 'Alarm',
      'tamKuru': 'Completely Dry',
      'normal': 'Normal',
      'saveSuccess': 'Information saved',
      'alarmCount': 'Number of alarms',
      'selectTime': 'Select time',
      'diaperWetness': 'Diaper Wetness',
      'outsideUrine': 'Toilet Urine Amount',
      'less': 'Low',
      'medium': 'Medium',
      'much': 'High',
      'dailyRecord': 'Daily Record',
      'selectBedTime': 'Select bedtime',
      'bedTime': 'Bed Time',
      'selectWakeTime': 'Select wake time',
      'wakeTime': 'Wake Time',
      'morningStatus': 'Morning Status',
      'completelyDry': 'Completely Dry',
      'withAlarm': 'With Alarm',
      'wet': 'Wet',
      'mood': 'Mood',
      'happy': 'Happy',
      'unhappy': 'Unhappy',
      'save': 'Save',
      'pleaseSelect': 'Please select',
      'calendar': 'Calendar',
      'contact': 'Contact',
      'address': '847/1 Sokak No:8 303 Sağlık İş Merkezi\nKonak / İzmir',
      'phone': '0232 484 17 04',
      'email': 'info@drydays.net',
      'treatmentDetail':
          'The first step in treating children who wet the bed at night is to take them to a physician specialized in this field. Since enuresis is a condition that may result from multiple causes, various treatment methods are applied. The appropriate treatment method should be selected based on the child’s age, developmental level, and whether the enuresis is primary or secondary. Families and children must be informed about the treatment plan. First, it should be determined whether there is an underlying medical or psychological cause, and if present, this cause should be treated.\n\n'
          'Treatment can be planned in the form of motivational therapy, behavioral therapy, alarm therapy, and medication. In motivational therapy, the child is educated about the condition, not blamed or punished, and is positively supported. Behavioral therapy involves regulating the child’s fluid intake, encouraging them to use the toilet before bedtime, and waking them up during the night to urinate. Methods such as rewarding the child each morning they wake up dry are also used.\n\n'
          'With alarm therapy, improvement rates between 75% and 100% are observed in children. The alarm device works with a sensor placed on the child’s underwear or bed. When moisture is detected, the alarm sounds and wakes the child. In this way, the child learns to sense bladder fullness and develops a habit of going to the toilet.\n\n'
          'In the treatment of bedwetting, medications such as imipramine, oxybutynin, and desmopressin are used. These medications should be used under medical supervision for a specified period and gradually discontinued once a response to treatment is achieved. The success rate in treating enuresis is high. Treated children show increased self-confidence and improvements in school and social life.',

      'treatment': 'Treatment',
      'whatIsEnuresis': 'What is Enuresis?',
      'whatIsEnuresisDetail':
          "Enuresis Nocturna (bedwetting, nocturnal urination, or nighttime urination); it is defined as involuntary urination during sleep in children over 5 years old, occurring at least twice a week for a period of three months.\n\n"
          "Enuresis Nocturna is classified into two groups based on the onset and course of the problem: primary (initial) and secondary (secondary). Primary enuresis is defined in the absence of a one-year period of urinary retention. For primary enuresis, there are those who accept cases with no dry period for at least 3 or 6 months. This group, which constitutes 80-90% of all enuretic children, is believed to be primarily influenced by genetic predisposition, biological, and developmental factors. Secondary enuresis is the recurrence of enuresis after at least one year of dryness. Secondary enuresis nocturna is most commonly observed between the ages of 5-8, and it is suggested that psychological factors are primarily responsible for the onset of the issue in this group.\n\n"
          "Studies have shown that the percentage of bedwetting is higher in boys than in girls. Developmental delays have also been identified in these children compared to their peers. After the age of 5, the spontaneous improvement rate without treatment is found to be between 5-10%. However, waiting for this improvement, whose timing and certainty are unknown, would be a wrong approach because during this waiting period, the discomfort continues, and the child may not want to stay in unfamiliar places or host friends, etc. This could lead to both social and psychological problems.\n\n"
          "It is difficult to determine the causes of enuresis nocturna, and many hypotheses have been put forward.\n\n"
          "Studies agree that there is a familial predisposition to enuresis. If both parents have a history of enuresis or ongoing enuresis, the likelihood of the child experiencing enuresis is 70-75%. If only one parent is affected, this risk drops to 40-45%. If there is no familial connection, the risk decreases to 15%.\n\n"
          "A 5-year-old child can hold their urine during sleep. Enuretic children are reported to acquire voluntary urination and retention abilities later due to having lower functional bladder capacities.\n\n"
          "In early studies investigating the relationship between sleep stages and enuresis, it was suggested that enuresis occurs during deep sleep and is equivalent to dreaming. However, more recent and advanced studies have shown that urination can occur during every stage of sleep. Many researchers accept enuresis as a problem related to the ability to wake up.\n\n"
          "A significant portion of enuretic patients has been observed to have social adjustment problems and some behavioral disorders. However, some recent studies suggest that psychological issues are not the cause of enuresis but rather enuresis leads to some behavioral disorders or maladjustment. Indeed, positive psychological effects are observed in children whose enuresis is treated.",
      'how_to_use': 'How to Use the Dry Days Device',
      'instruction':
          'Dry Days device is used by placing the sensor inside the three sensor covers sewn onto the underwear.\n\n'
          'The alarm device is attached to the shoulder of the pajamas, and the sensor is placed into the cover sewn onto the underwear.\n\n'
          'The alarm goes off as soon as the first urine is released, waking up the patient.\n\n'
          'For the first few weeks, a family member (if the patient is a young child) helps by guiding the child to finish urination in the bathroom.\n\n'
          'In the following days, with conditioned reflex, the patient will feel bladder contraction and go to the bathroom.\n\n'
          'The calendar provided with the device is marked and taken to the doctor for easier tracking of the process.',
      'download_guide': 'Download User Guide',
      'download_success': 'Guide downloaded: Saved to Downloads folder.',
      'download_failure': 'Permission denied. PDF could not be downloaded.',
      'loadingApp': 'App is loading...',
      'home': 'Home Page',
      'howToUse': 'How to Use?',
      'downloadGuide': 'Download Guide',
      'guideDownloaded': 'Guide downloaded: Saved to the Downloads folder.',
      'permissionDenied': 'Permission denied. PDF could not be downloaded.',
      'noSubUsersFound': 'No subusers found',
      'noName': 'No Name',
      'noRole': 'No Role',
      'addSubUser': 'Add Sub User',
      'subUser': 'Sub User',
      'user': 'User',
      'language': 'Language',
      'settings': 'Settings',
      'login': 'Login',
      'logout': 'Logout',
      'changePassword': 'Change Password',
      'forgotPassword': 'Forgot Password',
      'resetPassword': 'Reset Password',
      'welcome': 'Welcome',
      'profile': 'Profile',
      'notifications': 'Notifications',
      'editProfile': 'Edit Profile',
      'updateProfile': 'Update Profile',
      'cancel': 'Cancel',
      'search': 'Search',
      'confirm': 'Confirm',
      'delete': 'Delete',
      'back': 'Back',
      'next': 'Next',
      'previous': 'Previous',
      'finish': 'Finish',
      'submit': 'Submit',
      'error': 'Error',
      'success': 'Success',
      'noData': 'No Data',
      'loading': 'Loading...',
      'welcomeMessage': 'App is loading...',
      'tutorialTitle': 'Tutorial',
      'welcomeEmoji': '👋',
      'welcomeText':
          'WELCOME! You are using the app for the first time. We will inform you before we start.',
      'bookEmoji': '📚',
      'bookText':
          'In this app, we provide information about enuresis. We also allow you to keep track of your nightly waking records and print them whenever you want.',
      'moonEmoji': '🌙',
      'moonText':
          'To keep a nightly record, simply enter the information on the homepage after waking up in the morning.',
      'calendarEmoji': '📅',
      'calendarText':
          'If you want to fill in previous days, you can select a day from the calendar page and enter the information.',
      'lockEmoji': '🔒',
      'lockText':
          'No one has access to the information you enter. It is stored privately under your name.',
      'bellEmoji': '🔔📱',
      'bellText':
          'If you have a Bluetooth-enabled Dry Days device, you can activate Bluetooth on the app’s Bluetooth screen and keep your phone on at night to trigger the alarm!',
      'checkEmoji': '✅',
      'checkText': 'That\'s all for the tutorial! We wish you good use.',
      'preview': 'Preview',
      'ourProducts': 'Our Products',
      'viewOnTrendyol': 'View on Trendyol',
      'buyOnTrendyol': 'Buy on Trendyol',
      'productDescription':
          'Dry Days Enuresis Alarm dimensions: Length 6 cm, Width 4.5 cm, Depth 3 cm. Our products are designed for immediate alert and for safe use by enuretic patients of all ages.\n\nOur Dry Days device is widely recommended and prescribed by doctors in universities and hospitals across many cities.',
      'dryDaysSound': 'Dry Days Sound Alert',
      'dryDaysVibration': 'Dry Days Vibration Alert',
      'dryDaysPlus': 'Dry Days Plus (Sound + Vibration)',
      'reportDate': 'Report Date',
      'sleepTime': 'Bed Time',
      'moodStatus': 'Mood Status',
      'alarmDetails': 'Alarm Details',
      'alarmTime': 'Alarm Time',
      'shareReport': 'Share Report',
      'generateReport': 'Generate Report',
      'selectYear': 'Select Year',
      'selectMonth': 'Select Month',
      'selectedYear': 'Selected Year',
      'month': 'Month',
      'createReport': 'Create Report',
      'pdfNotGenerated': 'PDF could not be generated!',
      'viewPdf': 'View PDF',
      'about': 'About',
      'products': 'Products & Accessories',
      'enuresis': 'What is Enuresis Nocturna',
      'blog': 'Blog',
      'bluetooth': 'Bluetooth',
      'tutorial': '📘 Tutorial',
      'languageSelect': 'Select Language',
      'turkish': '🇹🇷 Turkish',
      'azerbaijani': '🇦🇿 Azerbaijani',
      'english': '🇬🇧 English',
      'privacyNoticeTitle': 'Privacy Notice',
      'privacyNoticeContent':
          'This app stores user data locally. The developer does not access or process this data. The purpose of the app is to help users track their own progress.',
      'ok': 'OK',
      'enterName': 'Enter Name',
      'nameHint': 'Full Name',
      'nameExists':
          'This name is already taken. Please choose a different one.',
      'pageTitle': 'Action Entry',
      'nameSurname': 'Name Surname',
      'day': 'Day',
      'dry': 'Completely Dry',
      'sad': 'Sad',
      'done': 'Finish',
      'tutorial_1':
          'WELCOME! You are using the app for the first time. We will inform you before you start.',
      'tutorial_2':
          'In this app, we provide information about enuresis. You can also log night awakenings and export your records at any time.',
      'tutorial_3':
          'To log night data, simply enter the information on the home screen after waking up in the morning.',
      'tutorial_4':
          'If you want to fill in previous days, you can select a day from the calendar page and enter the information.',
      'tutorial_5':
          'No one can access the information you enter. It is stored securely under your name.',
      'tutorial_6':
          'If you have a Bluetooth-supported Dry Days device, you can activate Bluetooth from the app and keep your phone on at night to trigger the alarm!',
      'tutorial_7': 'That’s all for the tutorial! Enjoy using the app.',
      'alarmRecords': 'Records',
      'tap_to_open': 'Tap to open.',
    },
  };

  Locale get currentLocale => _currentLocale;

  LanguageProvider() {
    _loadLanguage(); // Uygulama başladığında dil bilgisini yükle
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString('languageCode') ?? 'tr';
    _currentLocale = Locale(langCode);
    notifyListeners();
  }

  Future<void> changeLanguage(String languageCode) async {
    _currentLocale = Locale(languageCode);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode);
  }

  static String translate(BuildContext context, String key) {
    final provider = Provider.of<LanguageProvider>(context, listen: false);
    return provider._localizedStrings[provider
            ._currentLocale
            .languageCode]?[key] ??
        key;
  }
}
