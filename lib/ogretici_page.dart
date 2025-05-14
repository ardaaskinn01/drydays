import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'language_provider.dart';

class TutorialDialog extends StatefulWidget {
  const TutorialDialog({Key? key}) : super(key: key);

  @override
  State<TutorialDialog> createState() => _TutorialDialogState();
}

class _TutorialDialogState extends State<TutorialDialog> {
  int currentPage = 0;

  final List<Map<String, String>> tutorialPages = [
    {"emoji": "👋", "key": "tutorial_1"},
    {"emoji": "📚", "key": "tutorial_2"},
    {"emoji": "🌙", "key": "tutorial_3"},
    {"emoji": "📅", "key": "tutorial_4"},
    {"emoji": "🔒", "key": "tutorial_5"},
    {"emoji": "🔔📱", "key": "tutorial_6"},
    {"emoji": "✅", "key": "tutorial_7"},
  ];

  void _nextPage() {
    if (currentPage < tutorialPages.length - 1) {
      setState(() {
        currentPage++;
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  void _prevPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = tutorialPages[currentPage];

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        height: 400,
        child: Column(
          children: [
            Text(
              "${LanguageProvider.translate(context, 'tutorial')} (${currentPage + 1}/${tutorialPages.length})",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Text(
              current["emoji"]!,
              style: const TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Center(
                child: Text(
                  LanguageProvider.translate(context, current["key"]!),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (currentPage > 0)
                  TextButton(
                    onPressed: _prevPage,
                    child: Text(LanguageProvider.translate(context, 'back')),
                  ),
                TextButton(
                  onPressed: _nextPage,
                  child: Text(
                    LanguageProvider.translate(
                      context,
                      currentPage < tutorialPages.length - 1 ? 'next' : 'done',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
