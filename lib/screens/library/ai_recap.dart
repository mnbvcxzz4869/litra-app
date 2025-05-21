import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:litra/.env.dart';

// Displays a summary of the book using Azure OpenAI

class AiRecap extends StatefulWidget {
  final dynamic book;
  final int chapterProgress;

  const AiRecap({super.key, required this.book, required this.chapterProgress});

  @override
  State<AiRecap> createState() => _AiRecapState();
}

class _AiRecapState extends State<AiRecap> {
  String? summary;
  bool isLoading = false;

  final String azureEndpoint = 'https://joyce-may4biqn-eastus2.cognitiveservices.azure.com/openai/deployments/gpt-4o-mini/chat/completions?api-version=2025-01-01-preview';
  final String azureApiKey = AZURE_GPT_API_KEY;

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

      final combinedContent = widget.book.chapters
          .take(widget.chapterProgress)
          .map(
            (chapter) => chapter.chapterContent.join("\n\n"),
          )
          .join("\n\n");

      if (combinedContent.isEmpty) {
        setState(() {
          summary = "No content to summarize.";
          isLoading = false;
        });
        return;
      }

      final promptText = "Summarize the book content in 5 paragraphs:\n\n$combinedContent";

      final response = await http.post(
        Uri.parse(azureEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'api-key': azureApiKey,
        },
        body: jsonEncode({
          "messages": [
            {"role": "system", "content": "You are a helpful assistant."},
            {"role": "user", "content": promptText}
          ],
          "max_tokens": 1024,
          "temperature": 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final output = data['choices']?[0]?['message']?['content'];
        setState(() {
          summary = output ?? "No summary generated.";
          isLoading = false;
        });
      } else {
        setState(() {
          summary = "Failed to generate summary. Please try again later.";
          isLoading = false;
        });
      }
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  summary ?? "No summary available.",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16),
                ),
              ),
            ),
    );
  }
}