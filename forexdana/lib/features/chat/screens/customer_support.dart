import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

const String geminiApiKey = 'AIzaSyA5GPciGlBck2Zasil0P3wrDNsED3V0STc';
const String geminiApiUrl =
    'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

class ForexDanaChatbot extends StatefulWidget {
  const ForexDanaChatbot({super.key});

  @override
  State<ForexDanaChatbot> createState() => _ForexDanaChatbotState();
}

class _ForexDanaChatbotState extends State<ForexDanaChatbot>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  bool _isConnected = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animationController.repeat();
    _initializeChat();
  }

  void _initializeChat() {
    // Add initial bot message
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _messages.add(
          ChatMessage(
            message:
                "Hey there!\nNeed a hand? Choose a topic from the options below and we'll assist you right away!",
            isBot: true,
            timestamp: DateTime.now(),
            showTopics: true,
            messageType: MessageType.welcome,
          ),
        );
        _isConnected = true;
      });
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage(String message) {
    if (message.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          message: message,
          isBot: false,
          timestamp: DateTime.now(),
          messageType: MessageType.user,
        ),
      );
    });

    _messageController.clear();
    _scrollToBottom();

    // Show typing indicator
    _showTypingIndicator();

    // Simulate bot response
    _simulateBotResponse(message);
  }

  void _showTypingIndicator() {
    setState(() {
      _isTyping = true;
    });
    _scrollToBottom();
  }

  void _hideTypingIndicator() {
    setState(() {
      _isTyping = false;
    });
  }

  void _handleTopicSelection(String topic) {
    _sendMessage(topic);
  }

  void _simulateBotResponse(String userMessage) async {
    try {
      final geminiResponse = await _fetchGeminiResponse(userMessage);
      _hideTypingIndicator();
      setState(() {
        _messages.add(
          ChatMessage(
            message: geminiResponse ?? _getBotResponse(userMessage),
            isBot: true,
            timestamp: DateTime.now(),
            messageType: MessageType.bot,
            // Only show topics if the Gemini API didn't provide a response
            // and the user message triggers a topic, or if it's the welcome message.
            showTopics:
                geminiResponse == null ? _shouldShowTopics(userMessage) : false,
          ),
        );
      });
      _scrollToBottom();
    } catch (e) {
      _hideTypingIndicator();
      setState(() {
        _messages.add(
          ChatMessage(
            message:
                'Sorry, I could not get a response from AI. Please try again later. ($e)', // Added error for debugging
            isBot: true,
            timestamp: DateTime.now(),
            messageType: MessageType.bot,
            showTopics: _shouldShowTopics(userMessage),
          ),
        );
      });
      _scrollToBottom();
    }
  }

  Future<String?> _fetchGeminiResponse(String prompt) async {
    // Only attempt to call Gemini if an API key is provided
    if (geminiApiKey == 'YOUR_GEMINI_API_KEY' || geminiApiKey.isEmpty) {
      debugPrint("Gemini API Key is not set. Skipping API call.");
      return null; // Return null to fall back to _getBotResponse
    }

    try {
      final response = await http.post(
        Uri.parse('$geminiApiUrl?key=$geminiApiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final candidates = data['candidates'];
        if (candidates != null && candidates.isNotEmpty) {
          final parts = candidates[0]['content']['parts'];
          if (parts != null && parts.isNotEmpty) {
            return parts[0]['text'] as String?;
          }
        }
      } else {
        debugPrint(
            'Gemini API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('Error fetching Gemini response: $e');
    }
    return null;
  }

  bool _shouldShowTopics(String userMessage) {
    String lowerMessage = userMessage.toLowerCase();
    // Show topics if the message contains any of these keywords
    // or if it's the initial welcome message from the bot
    return lowerMessage.contains('beginner') ||
        lowerMessage.contains('verification') ||
        lowerMessage.contains('withdrawal') ||
        lowerMessage.contains('bdc events') ||
        lowerMessage.contains('forex trading') ||
        lowerMessage.contains('what is forex') ||
        lowerMessage.contains('stock trading') ||
        lowerMessage.contains('what are stocks') ||
        lowerMessage.contains('leverage') ||
        lowerMessage.contains('currency pairs') ||
        lowerMessage.contains('market analysis') ||
        lowerMessage.contains('technical analysis') ||
        lowerMessage.contains('deposit methods') ||
        lowerMessage.contains('trading platform') ||
        lowerMessage.contains('risk management');
  }

  String _getBotResponse(String message) {
    String lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('beginner')) {
      return "Start with demo, modules, small trades, and stop losses. Need help with setup or concepts?";
    } else if (lowerMessage.contains('verification')) {
      return "You'll need ID, proof of address, and bank details. Takes 1-2 days. Upload help or questions?";
    } else if (lowerMessage.contains('withdrawal')) {
      return "Min \$50, 1-3 business days. Bank/e-wallets, no fees for verified. Specific issue?";
    } else if (lowerMessage.contains('bdc events')) {
      return "Weekly analysis, workshops, webinars. Next: 'Forex Fundamentals' Fri, 2 PM GMT. Register/details?";
    } else if (lowerMessage.contains('live agent') ||
        lowerMessage.contains('agen manusia')) {
      return "Connecting to live agent (2-3 min wait). Email support@forexdana.com or call +1-800-FOREX-DANA.";
    } else if (lowerMessage.contains('forex trading') ||
        lowerMessage.contains('what is forex')) {
      return "Forex: exchanging currencies for profit. Largest market. Terms: Pips, Lots, Leverage, Margin. Specific pairs/strategies?";
    } else if (lowerMessage.contains('stock trading') ||
        lowerMessage.contains('what are stocks')) {
      return "Stock trading: buying/selling company shares. Terms: Dividends, Market Cap, IPO. Stock analysis or account setup?";
    } else if (lowerMessage.contains('leverage')) {
      return "Leverage: control large sums with small capital (e.g., 1:100 means \$10k with \$100). Magnifies profits/losses. Risk management with leverage?";
    } else if (lowerMessage.contains('currency pairs')) {
      return "Majors: EUR/USD, GBP/USD. Minors: EUR/GBP. Exotics: USD/SGD. Which pair or how to read?";
    } else if (lowerMessage.contains('market analysis') ||
        lowerMessage.contains('technical analysis')) {
      return "Market analysis: Technical (charts, indicators) & Fundamental (economics, news). Specific indicators/reports?";
    } else if (lowerMessage.contains('deposit methods')) {
      return "Bank, cards, e-wallets, crypto. Min \$100. Which method?";
    } else if (lowerMessage.contains('trading platform')) {
      return "Our platform has real-time quotes, charts, tools, one-click trading. Web, mobile, or desktop?";
    } else if (lowerMessage.contains('risk management')) {
      return "Crucial for trading. Use Stop-Loss, risk 1-2% per trade, diversify. Learn about setting stop-loss/take-profit?";
    } else {
      return "Thanks for asking about: \"$message\". I can help with account, trading, withdrawals, platform, education. More details or choose a topic?";
    }
  }

  void _endChat() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('End Chat'),
          content: const Text(
            'Are you sure you want to end this chat session?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back from chat screen
              },
              child: const Text('End Chat'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C5F5D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text(
                  'FD',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C5F5D),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'ForexDana Support',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call_end, color: Colors.white),
            onPressed: _endChat,
            tooltip: 'End Chat',
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              _showMoreOptions();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Connection status bar
          if (!_isConnected)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: Colors.orange,
              child: const Center(
                child: Text(
                  'Connecting to support...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return _buildTypingIndicator();
                }
                return ChatBubble(
                  message: _messages[index],
                  onTopicSelected: _handleTopicSelection,
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                'FD',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C5F5D),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(0),
                const SizedBox(width: 4),
                _buildDot(1),
                const SizedBox(width: 4),
                _buildDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    // This part of the typing indicator is currently static.
    // To make it animate, you'd need to use a TweenSequenceAnimation
    // or similar for opacity/size changes for each dot.
    // For now, it will just show three grey dots.
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: Colors.grey[400],
        shape: BoxShape.circle,
      ),
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text('Email Support'),
                onTap: () {
                  Navigator.of(context).pop();
                  // TODO: Implement email support (e.g., launch email client)
                },
              ),
              ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('Call Support'),
                onTap: () {
                  Navigator.of(context).pop();
                  // TODO: Implement call support (e.g., launch dialer)
                },
              ),
              ListTile(
                leading: const Icon(Icons.help),
                title: const Text('Help Center'),
                onTap: () {
                  Navigator.of(context).pop();
                  // TODO: Navigate to help center (e.g., launch web view)
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file, color: Colors.grey),
            onPressed: () {
              // TODO: Implement file attachment
            },
            tooltip: 'Attach File',
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: TextStyle(color: Colors.grey[500]),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              onSubmitted: _sendMessage,
              textInputAction: TextInputAction.send,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF2C5F5D),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white, size: 20),
              onPressed: () => _sendMessage(_messageController.text),
              tooltip: 'Send Message',
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String message;
  final bool isBot;
  final DateTime timestamp;
  final bool showTopics;
  final MessageType messageType;

  ChatMessage({
    required this.message,
    required this.isBot,
    required this.timestamp,
    this.showTopics = false,
    this.messageType = MessageType.user,
  });
}

enum MessageType { user, bot, welcome }

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final Function(String) onTopicSelected;

  const ChatBubble({
    super.key,
    required this.message,
    required this.onTopicSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Determine alignment based on whether it's a bot or user message
    final alignment =
        message.isBot ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    final rowAlignment =
        message.isBot ? MainAxisAlignment.start : MainAxisAlignment.end;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: rowAlignment,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.isBot) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  'FD',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C5F5D),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: alignment,
              children: [
                if (!message.isBot) ...[
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                ],
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        message.isBot ? Colors.white : const Color(0xFF2C5F5D),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message.message,
                    style: TextStyle(
                      color: message.isBot ? Colors.black87 : Colors.white,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                ),
                if (message.isBot) ...[
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
                if (message.showTopics &&
                    message.messageType == MessageType.welcome) ...[
                  // Only show topic buttons for the initial welcome message from the bot
                  const SizedBox(height: 12),
                  _buildTopicButtons(),
                ],
              ],
            ),
          ),
          if (!message.isBot) ...[
            const SizedBox(width: 12),
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(0xFF2C5F5D),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 18),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTopicButtons() {
    final topics = [
      'Beginner',
      'Verification',
      'Withdrawal',
      'BDC Events',
      'Forex Trading', // New topic
      'Stock Trading', // New topic
      'Leverage', // New topic
      'Currency Pairs', // New topic
      'Market Analysis', // New topic
      'Deposit Methods', // New topic
      'Trading Platform', // New topic
      'Risk Management', // New topic
      'Live Agent/Agen manusia',
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: topics.map((topic) {
        return InkWell(
          onTap: () => onTopicSelected(topic),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF4A7C59)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              topic,
              style: const TextStyle(
                color: Color(0xFF4A7C59),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
