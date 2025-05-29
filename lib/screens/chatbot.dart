import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:litra/.env.dart';

// Singleton for chat history
class ChatHistory {
  static final ChatHistory _instance = ChatHistory._internal();
  factory ChatHistory() => _instance;
  ChatHistory._internal();

  final List<ChatMessage> messages = [];
}

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  // Use the singleton's messages list
  List<ChatMessage> get _messages => ChatHistory().messages;
  bool _isLoading = false;

  static const String endpoint = 'https://joyce-may4biqn-eastus2.openai.azure.com/openai/deployments/gpt-4o-mini/chat/completions?api-version=2024-02-15-preview';
  static const String apiKey = AZURE_GPT_API_KEY;

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(ChatMessage(text, true));
      _isLoading = true;
      _controller.clear();
    });

    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'api-key': apiKey,
        },
        body: jsonEncode({
          "messages": [
            {
              "role": "system",
              "content": "You are an AI assistant that helps people find information."
            },
            ..._messages.map((m) => {
              "role": m.isUser ? "user" : "assistant",
              "content": m.text,
            }),
          ],
          "past_messages": 10,
          "temperature": 0.7,
          "top_p": 0.95,
          "frequency_penalty": 0,
          "presence_penalty": 0,
          "max_tokens": 800,
          "stop": null,
          "azureSearchEndpoint": "https://ultratehmanisbooksearch.search.windows.net",
          "azureSearchKey": AZURE_SEARCH_API_KEY,
          "azureSearchIndexName": "chapter1",
          "data_sources": [
            {
              "type": "azure_search",
              "parameters": {
                "endpoint": "https://ultratehmanisbooksearch.search.windows.net",
                "index_name": "chapter1",
                "semantic_configuration": "default",
                "query_type": "semantic",
                "fields_mapping": {},
                "in_scope": true,
                "role_information": "You are an AI assistant that helps people find information. Do not include citations, references, or source tags like [doc[n]] in your answers.",
                "filter": null,
                "strictness": 3,
                "top_n_documents": 5,
                "authentication": {
                  "type": "api_key",
                  "key": AZURE_SEARCH_API_KEY
                },
                "key": AZURE_SEARCH_API_KEY,
                "indexName": "chapter1"
              }
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['choices'][0]['message']['content'] ?? '';
        final cleanedReply = reply
            .replaceAll(RegExp(r'\s*\[doc[^\]]*\]', caseSensitive: false), '')
            .replaceAll(RegExp(r'\s+([.,;:!?])'), r'.');
        setState(() {
          _messages.add(ChatMessage(cleanedReply, false));
        });
      } else {
        setState(() {
          _messages.add(ChatMessage('Error: ${response.statusCode}', false));
        });
      }
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage('Error: $e', false));
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Chatbot 🤖'),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: theme.colorScheme.surfaceContainerHighest.withAlpha(30),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              itemCount: _isLoading ? _messages.length + 1 : _messages.length,
              separatorBuilder: (_, __) => const SizedBox(height: 6),
              itemBuilder: (context, idx) {
                if (_isLoading && idx == _messages.length) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          constraints: const BoxConstraints(maxWidth: 340),
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(16).copyWith(
                              bottomLeft: const Radius.circular(4),
                            ),
                            boxShadow: [BoxShadow(color: theme.colorScheme.primary.withAlpha(30), blurRadius: 6, offset: const Offset(0,2))],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                width: 28,
                                child: const Text('🤖', style: TextStyle(fontSize: 20)),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                '...',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final msg = _messages[idx];
                if (msg.isUser) {
                  return Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 320),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withAlpha(40),
                        borderRadius: BorderRadius.circular(16).copyWith(
                          bottomRight: const Radius.circular(4),
                        ),
                      ),
                      child: Text(
                        msg.text,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  );
                } else {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          constraints: const BoxConstraints(maxWidth: 340),
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(16).copyWith(
                              bottomLeft: const Radius.circular(4),
                            ),
                            boxShadow: [BoxShadow(color: theme.colorScheme.primary.withAlpha(30), blurRadius: 6, offset: const Offset(0,2))],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start, // align everything to the top/start
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                width: 28,
                                child: const Text('🤖', style: TextStyle(fontSize: 20)),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  msg.text,
                                  style: theme.textTheme.bodyMedium,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withAlpha(30),
                  blurRadius: 6,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (_) => _sendMessage(),
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                      filled: true,
                      fillColor: theme.colorScheme.surfaceContainerHighest.withAlpha(60),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: theme.colorScheme.primary,
                  onPressed: _isLoading ? null : _sendMessage,
                  tooltip: 'Send',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  ChatMessage(this.text, this.isUser);
}