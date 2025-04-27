import 'dart:io';
import 'package:drydays/pdf_preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class RaporOlusturmaPage extends StatefulWidget {
  const RaporOlusturmaPage({super.key});

  @override
  _RaporOlusturmaPageState createState() => _RaporOlusturmaPageState();
}

class _RaporOlusturmaPageState extends State<RaporOlusturmaPage> {
  String? savedName;
  List<Map<String, dynamic>> documents = [];
  List<String> selectedDocuments = [];
  int? selectedYear;
  int? selectedMonth;
  bool allSelected = false;
  bool isLoading = false;
  File? pdfFile = null;

  @override
  void initState() {
    super.initState();
    _loadSavedName();
  }

  Future<void> _loadSavedName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('username');
    if (name != null) {
      setState(() {
        savedName = name;
      });
    }
  }

  Future<void> _fetchDocuments() async {
    if (savedName == null) return;

    setState(() {
      isLoading = true;
    });

    // Firestore koleksiyonuna erişim
    final querySnapshot = await FirebaseFirestore.instance
        .collection(savedName!)
        .get();

    setState(() {
      isLoading = false;
      if (querySnapshot.docs.isNotEmpty) {
        documents = querySnapshot.docs.map((doc) {
          var data = doc.data() as Map<String, dynamic>;

          // 'createdAt' tarihini string olarak alıyoruz
          if (data.containsKey('createdAt') && data['createdAt'] is String) {
            final createdAtString = data['createdAt'] as String;
            // Tarihi string formatından DateTime'a dönüştürme
            final createdAt = DateFormat('dd.MM.yyyy').parse(createdAtString);
            data['createdAt'] = createdAt;
          }

          // 'createdAt' tarihine göre filtreleme
          if (data['createdAt'] is DateTime) {
            final createdAt = data['createdAt'] as DateTime;
            if (createdAt.year == selectedYear && createdAt.month == selectedMonth) {
              return data;
            }
          }

          return null; // Filtrelenmiş verileri döndür
        }).whereType<Map<String, dynamic>>().toList(); // null değerleri dışla
      } else {
        documents = [];
      }
    });
  }

  Future<void> _createPdf() async {
    if (selectedYear == null || selectedMonth == null) return;

    setState(() {
      isLoading = true;
    });

    final pdf = pw.Document();
    final ttf = await rootBundle.load("assets/fonts/DejaVuSans.ttf");
    final font = pw.Font.ttf(ttf);

    final selectedDocs = documents.where((doc) {
      var createdAt = doc['createdAt'];
      if (createdAt is Timestamp) createdAt = createdAt.toDate();
      if (createdAt is DateTime) {
        return createdAt.year == selectedYear && createdAt.month == selectedMonth;
      }
      return false;
    }).toList();

    for (var doc in selectedDocs) {
      final docDate = doc['createdAt'];
      final formattedDate = docDate != null ? DateFormat('dd.MM.yyyy').format(docDate) : 'Veri Yok';

      final bedTime = doc['bedTime'] ?? 'Veri Yok';
      final wakeTime = doc['wakeTime'] ?? 'Veri Yok';
      final morningStatus = doc['morningStatus'] ?? 'Veri Yok';
      final moodStatus = doc['moodStatus'] ?? 'Veri Yok';

      final alarmCount = doc['alarmCount'] ?? 0;
      final List<dynamic> alarmTimes = List<dynamic>.from(doc['alarmTimes'] ?? []);
      final List<dynamic> diaperWetness = List<dynamic>.from(doc['diaperWetness'] ?? []);
      final List<dynamic> outsideUrine = List<dynamic>.from(doc['outsideUrine'] ?? []);

      pdf.addPage(pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Rapor Tarihi: $formattedDate', style: pw.TextStyle(font: font, fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 40),

              _buildInfo(font, 'Uyku Saati', bedTime),
              _buildInfo(font, 'Uyanma Saati', wakeTime),
              _buildInfo(font, 'Sabah Durumu', morningStatus),
              _buildInfo(font, 'Ruh Hali', moodStatus),

              pw.SizedBox(height: 25),
              pw.Text('Alarm Detayları (Toplam $alarmCount adet)', style: pw.TextStyle(font: font, fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),

              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: const pw.FlexColumnWidth(1),
                  1: const pw.FlexColumnWidth(2),
                  2: const pw.FlexColumnWidth(2),
                  3: const pw.FlexColumnWidth(2),
                },
                children: [
                  // Başlık satırı
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('No', style: pw.TextStyle(font: font, fontSize: 18, fontWeight: pw.FontWeight.bold))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Alarm Saati', style: pw.TextStyle(font: font, fontSize: 18, fontWeight: pw.FontWeight.bold))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Bez Islaklığı', style: pw.TextStyle(font: font, fontSize: 18, fontWeight: pw.FontWeight.bold))),
                      pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Dışarı İşeme', style: pw.TextStyle(font: font, fontSize: 18, fontWeight: pw.FontWeight.bold))),
                    ],
                  ),

                  // Veriler
                  for (int i = 0; i < alarmCount && i < 10; i++) // Maksimum 6 satır
                    pw.TableRow(
                      children: [
                        pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('${i + 1}', style: pw.TextStyle(font: font, fontSize: 18))),
                        pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(alarmTimes.length > i ? alarmTimes[i] ?? 'Veri Yok' : 'Veri Yok', style: pw.TextStyle(font: font, fontSize: 18))),
                        pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(diaperWetness.length > i ? diaperWetness[i] ?? 'Veri Yok' : 'Veri Yok', style: pw.TextStyle(font: font, fontSize: 18))),
                        pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(outsideUrine.length > i ? outsideUrine[i]?.toString() ?? 'Veri Yok' : 'Veri Yok', style: pw.TextStyle(font: font, fontSize: 18))),
                      ],
                    ),
                ],
              ),
            ],
          );
        },
      ));
    }

    final output = await getApplicationDocumentsDirectory();
    final file = File('${output.path}/drydays_${selectedMonth}_${selectedYear}.pdf');
    await file.writeAsBytes(await pdf.save());

// Dosyanın varlığını kontrol edin
    if (await file.exists()) {
      print("PDF başarıyla oluşturuldu: ${file.path}");
      setState(() {
        isLoading = false;
        pdfFile = file;
      });
    } else {
      print("PDF oluşturulamadı!");
      setState(() {
        isLoading = false;
      });
    }
  }

  pw.Widget _buildInfo(pw.Font font, String label, String value) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('$label:', style: pw.TextStyle(font: font, fontSize: 18, fontWeight: pw.FontWeight.bold)),
        pw.Text(value, style: pw.TextStyle(font: font, fontSize: 18)),
        pw.SizedBox(height: 10),
      ],
    );
  }

  void _sharePdf(File file) {
    final xFile = XFile(file.path);
    Share.shareXFiles([xFile], text: 'Raporu Paylaş');
  }

  List<int> getYearsList() {
    Set<int> years = Set();
    years.addAll([2025, 2026, 2027, 2028, 2029, 2030]);

    for (var document in documents) {
      var createdAt = document['createdAt'];
      // Eğer createdAt Timestamp ise DateTime'a dönüştür
      if (createdAt is Timestamp) {
        createdAt = createdAt.toDate();
      }
      // Eğer createdAt zaten DateTime ise, bir şey yapmaya gerek yok
      if (createdAt is DateTime) {
        final year = createdAt.year;
        years.add(year);
      }
    }

    return years.toList()..sort();
  }

  List<int> getMonthsList(int year) {
    Set<int> months = Set();
    months.addAll([01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 12]); // Ayları sıfırdan başlamayan şekilde ekliyoruz

    for (var document in documents) {
      var createdAt = document['createdAt'];

      // Eğer createdAt bir Timestamp ise DateTime'a dönüştür
      if (createdAt is Timestamp) {
        createdAt = createdAt.toDate();
      }

      // Eğer createdAt bir DateTime ise, yılı ve ayı al
      if (createdAt is DateTime) {
        final docYear = createdAt.year;
        final month = createdAt.month;

        // Yıl eşleşiyorsa, ayı ekle
        if (docYear == year) {
          months.add(month);
        }
      }
    }

    return months.toList()..sort();
  }

  void _filterByMonth() {
    if (selectedYear == null || selectedMonth == null) return;

    setState(() {
      selectedDocuments = documents.where((doc) {
        final createdAt = (doc['createdAt'] as Timestamp).toDate();
        return createdAt.year == selectedYear && createdAt.month == selectedMonth;
      }).map((doc) => doc['createdAt'].toDate().toString()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rapor Oluşturma'),
        backgroundColor: Colors.green,
        elevation: 4,
      ),
      backgroundColor: Color(0xFFD5CE9D), // Arkaplan rengini buraya ekliyoruz
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (savedName != null) ...[
                  // Yıl seçimi
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: DropdownButton<int>(
                      hint: Text('Yıl Seçin', style: TextStyle(color: Colors.green[700])),
                      value: selectedYear,
                      items: getYearsList().map((year) {
                        return DropdownMenuItem<int>(
                          value: year,
                          child: Text('$year', style: TextStyle(color: Colors.green[800])),
                        );
                      }).toList(),
                      onChanged: (year) {
                        setState(() {
                          selectedYear = year;
                          selectedMonth = null;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Ay seçimi
                  if (selectedYear != null)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: DropdownButton<int>(
                        hint: Text('Ay Seçin', style: TextStyle(color: Colors.green[700])),
                        value: selectedMonth,
                        items: getMonthsList(selectedYear!).map((month) {
                          return DropdownMenuItem<int>(
                            value: month,
                            child: Text(
                              DateFormat.MMMM('tr_TR').format(DateTime(0, month)),
                              style: TextStyle(color: Colors.green[800]),
                            ),
                          );
                        }).toList(),
                        onChanged: (month) {
                          setState(() {
                            selectedMonth = month;
                          });
                          _filterByMonth(); // Ay seçildiğinde filtrele
                        },
                      ),
                    ),
                  const SizedBox(height: 20),
                ],
                if (selectedYear != null && selectedMonth != null) ...[
                  Text(
                    'Seçilen Yıl: $selectedYear, Ay: ${DateFormat.MMMM('tr_TR').format(DateTime(0, selectedMonth!))}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green[700]),
                  ),
                  const SizedBox(height: 20),
                ],
                ElevatedButton(
                  onPressed: () async {
                    await _fetchDocuments(); // Veriler tamamen geldikten sonra
                    await _createPdf();      // PDF oluştur
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 5,
                  ),
                  child: Text(
                    'Rapor Oluştur',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                if (isLoading)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                if (!isLoading && pdfFile != null) ...[
                  ElevatedButton(
                    onPressed: () {
                      // PDF'i görüntüleme işlemi
                      if (pdfFile != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PdfPreviewScreen(pdfFile: pdfFile!),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("PDF oluşturulamadı!")),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 5,
                    ),
                    child: Text(
                      'PDF\'i İncele',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (pdfFile != null) {
                        _sharePdf(pdfFile!);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 5,
                    ),
                    child: Text(
                      'Raporu Paylaş',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
