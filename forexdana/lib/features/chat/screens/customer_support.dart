import 'package:flutter/material.dart';

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

  void _simulateBotResponse(String userMessage) {
    Future.delayed(const Duration(milliseconds: 1500), () {
      _hideTypingIndicator();

      String response = _getBotResponse(userMessage);
      setState(() {
        _messages.add(
          ChatMessage(
            message: response,
            isBot: true,
            timestamp: DateTime.now(),
            messageType: MessageType.bot,
            showTopics: _shouldShowTopics(userMessage),
          ),
        );
      });
      _scrollToBottom();
    });
  }

  bool _shouldShowTopics(String userMessage) {
    String lowerMessage = userMessage.toLowerCase();
    return lowerMessage.contains('beginner') ||
        lowerMessage.contains('verification') ||
        lowerMessage.contains('withdrawal') ||
        lowerMessage.contains('bdc events');
  }

  String _getBotResponse(String message) {
    String lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('beginner')) {
      return "Great! I'd be happy to help you get started with ForexDana. 🚀\n\nAs a beginner, here are some key things to know:\n\n• Start with our demo account to practice\n• Complete our educational modules\n• Begin with small trades\n• Always use stop losses\n\nWould you like me to guide you through account setup or explain any of these concepts in detail?";
    } else if (lowerMessage.contains('verification')) {
      return "I can help you with account verification! 📋\n\nYou'll need:\n• Government-issued ID (passport/license)\n• Proof of address (utility bill/bank statement)\n• Bank account details\n\nThe verification process typically takes 1-2 business days.\n\nWould you like help uploading your documents or have questions about the verification process?";
    } else if (lowerMessage.contains('withdrawal')) {
      return "I can assist with withdrawal queries! 💰\n\nWithdrawal info:\n• Minimum withdrawal: \$50\n• Processing time: 1-3 business days\n• Available methods: Bank transfer, e-wallets\n• No withdrawal fees for verified accounts\n\nWhat specific withdrawal issue can I help with?";
    } else if (lowerMessage.contains('bdc events')) {
      return "BDC Events information! 🎯\n\n• Weekly market analysis sessions\n• Live trading workshops\n• Educational webinars\n• Q&A with trading experts\n\nNext event: 'Forex Fundamentals Workshop'\nDate: This Friday, 2:00 PM GMT\n\nWould you like to register for upcoming events or get more details?";
    } else if (lowerMessage.contains('live agent') ||
        lowerMessage.contains('agen manusia')) {
      return "I'm connecting you with a live agent now... 🔄\n\nPlease hold on while I transfer your chat. Our average wait time is 2-3 minutes.\n\nIn the meantime, you can also:\n• Email us at support@forexdana.com\n• Call +1-800-FOREX-DANA\n• WhatsApp: +1-234-567-8900\n\nIs there anything else I can help you with while you wait?";
    } else {
      return "Thank you for your message! I understand you're asking about: \"$message\"\n\nI'm here to help with:\n• Account setup and verification\n• Trading questions\n• Withdrawal/deposit issues\n• Platform navigation\n• Educational resources\n\nCould you please provide more specific details about your question, or choose from the topics below?";
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
                Navigator.of(context).pop();
                Navigator.of(context).pop();
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
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey[400],
            shape: BoxShape.circle,
          ),
        );
      },
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
                  // TODO: Implement email support
                },
              ),
              ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('Call Support'),
                onTap: () {
                  Navigator.of(context).pop();
                  // TODO: Implement call support
                },
              ),
              ListTile(
                leading: const Icon(Icons.help),
                title: const Text('Help Center'),
                onTap: () {
                  Navigator.of(context).pop();
                  // TODO: Navigate to help center
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
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
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
          Expanded(
            child: Column(
              crossAxisAlignment: message.isBot
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
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
                    color: message.isBot
                        ? Colors.white
                        : const Color(0xFF2C5F5D),
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
                if (message.showTopics) ...[
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
