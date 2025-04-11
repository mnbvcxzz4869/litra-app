import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

// Displays a summary of the book using Gemini AI

class AiRecap extends StatefulWidget {
  final dynamic book;
  final int chapterProgress;

  const AiRecap({super.key, required this.book, required this.chapterProgress});

  @override
  State<AiRecap> createState() => _AiRecapState();
}

class _AiRecapState extends State<AiRecap> {
  final Gemini gemini = Gemini.instance;
  String? summary;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _getRecap();
  }

  Future<void> _getRecap() async {
    setState(() {
      isLoading = true;
    });

    try {
      if (widget.chapterProgress <= 0 ||
          widget.chapterProgress > widget.book.chapters.length) {
        setState(() {
          summary = "Invalid chapter progress.";
          isLoading = false;
        });
        return;
      }

      // Combine all chapters' content up to the current progress
      final combinedContent = widget.book.chapters
          .take(widget.chapterProgress)
          .map(
            (chapter) => chapter.chapterContent.join("\n\n"),
          ) // Join the list of strings
          .join("\n\n");

      if (combinedContent.isEmpty) {
        setState(() {
          summary = "No content to summarize.";
          isLoading = false;
        });
        return;
      }

      final promptText = "Summarize the book content in 5 paragraph:\n\n$combinedContent";

      final response = await Gemini.instance.prompt(
        parts: [Part.text(promptText)],
      );

      setState(() {
        summary = response?.output ?? "No summary generated.";
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        summary = "Failed to generate summary. Please try again later.";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Recap'), centerTitle: true),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child:
              isLoading
                  ? Center(child: const CircularProgressIndicator())
                  : Text(
                    summary ?? "No summary available.",
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium!.copyWith(fontSize: 16),
                  ),
        ),
      ),
    );
  }
}
