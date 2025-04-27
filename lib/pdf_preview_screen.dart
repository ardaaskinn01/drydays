import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfPreviewScreen extends StatefulWidget {
  final File pdfFile;

  const PdfPreviewScreen({Key? key, required this.pdfFile}) : super(key: key);

  @override
  _PdfPreviewScreenState createState() => _PdfPreviewScreenState();
}

class _PdfPreviewScreenState extends State<PdfPreviewScreen> {
  late PDFViewController _pdfViewController;
  bool _isLoading = true;
  int _totalPages = 0;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    // PDF dosyasını okuma
    setState(() {
      _isLoading = false;
    });
  }

  void _onPageChanged(int page, int total) {
    setState(() {
      _currentPage = page;
      _totalPages = total;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Önizleme'),
        backgroundColor: Colors.green,
        actions: [
          // Sayfa bilgisi göstergesi
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Sayfa ${_currentPage + 1}/$_totalPages',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                children: [
                  PDFView(
                    filePath: widget.pdfFile.path,
                    onViewCreated: (PDFViewController pdfViewController) {
                      _pdfViewController = pdfViewController;
                    },
                    onPageChanged: (int? page, int? total) {
                      // Nullable parametreler
                      if (page != null && total != null) {
                        _onPageChanged(page, total);
                      }
                    },
                    onError: (error) {
                      print('PDF Hatası: $error');
                    },
                  ),
                  // Sayfa geçiş butonları
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed:
                                _currentPage > 0
                                    ? () {
                                      _pdfViewController.setPage(
                                        _currentPage - 1,
                                      );
                                    }
                                    : null,
                          ),
                          IconButton(
                            icon: Icon(Icons.arrow_forward),
                            onPressed:
                                _currentPage < _totalPages - 1
                                    ? () {
                                      _pdfViewController.setPage(
                                        _currentPage + 1,
                                      );
                                    }
                                    : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
