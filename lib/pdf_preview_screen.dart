import 'package:drydays/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:io';

class PdfPreviewScreen extends StatefulWidget {
  final File pdfFile;

  const PdfPreviewScreen({Key? key, required this.pdfFile}) : super(key: key);

  @override
  State<PdfPreviewScreen> createState() => _PdfPreviewScreenState();
}

class _PdfPreviewScreenState extends State<PdfPreviewScreen> {
  late PdfViewerController _pdfController;

  @override
  void initState() {
    super.initState();
    _pdfController = PdfViewerController();
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LanguageProvider.translate(context, 'preview')),
        backgroundColor: Colors.green,
      ),
      body: SfPdfViewer.file(
        widget.pdfFile,
        controller: _pdfController,
      ),
    );
  }
}