import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Assuming the existence of these files from your original code
// import 'package:forexdana/features/chat/screens/customer_support.dart';
// import 'package:forexdana/features/dashboard/screens/square_screen.dart';

// Dummy ForexDanaChatbot for demonstration purposes
class ForexDanaChatbot extends StatelessWidget {
  const ForexDanaChatbot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Customer Support'),
      content: const Text('Chatbot functionality would be here.'),
      actions: <Widget>[
        TextButton(
          child: const Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class DemoScreen extends StatefulWidget {
  final Function(int)? onGoToSquare;

  const DemoScreen({super.key, this.onGoToSquare});

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A5568),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A5568),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Demo',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.headset, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const ForexDanaChatbot(),
              );
            },
          ),
          // Implemented Stack for notification dot from the first code snippet
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.mail_outline, color: Colors.white),
                onPressed: () {
                  // Implemented onGoToSquare callback from the first code snippet
                  if (widget.onGoToSquare != null) {
                    widget.onGoToSquare!(2); // Go to Messages tab (index 2)
                  }
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF5F5F5),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(0),
            topRight: Radius.circular(0),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Account expired banner (always visible at top)
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Your account has expired, click to activate',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Get Demo Coins by activating it',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF718096),
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Account activation feature coming soon!'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF007AFF),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              'Activate ▶',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 80,
                      height: 100,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            Positioned(
                              top: 10,
                              child: Container(
                                width: 30,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF007AFF),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Icon(
                                  Icons.lock,
                                  color: Colors.yellow,
                                  size: 16,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 15,
                              right: 8,
                              child: Container(
                                width: 16,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: Colors.grey[600],
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: const Icon(
                                  Icons.mail,
                                  color: Colors.white,
                                  size: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Popular instruments header
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.trending_up, color: Colors.red, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Popular instruments',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              // Trading instruments grid
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: popularInstruments.length,
                      itemBuilder: (context, index) {
                        return _buildInstrumentCard(popularInstruments[index]);
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstrumentCard(TradingInstrument instrument) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: instrument.backgroundColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: instrument.iconUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.network(
                      instrument.iconUrl,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.currency_bitcoin,
                          color: Colors.white,
                          size: 24,
                        );
                      },
                    ),
                  )
                : Icon(
                    instrument.icon,
                    color: Colors.white,
                    size: 24,
                  ),
          ),
          const SizedBox(height: 8),
          // Symbol
          Text(
            instrument.symbol,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          // Price
          Text(
            instrument.price,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: instrument.priceColor,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class TradingInstrument {
  final String symbol;
  final String price;
  final Color priceColor;
  final Color backgroundColor;
  final IconData icon;
  final String iconUrl;

  TradingInstrument({
    required this.symbol,
    required this.price,
    required this.priceColor,
    required this.backgroundColor,
    this.icon = Icons.currency_bitcoin,
    this.iconUrl = '',
  });
}

// Data for popular instruments
final List<TradingInstrument> popularInstruments = [
  TradingInstrument(
    symbol: 'BTC/USDT',
    price: '115223.20',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFFED8936),
    iconUrl: 'https://cryptologos.cc/logos/bitcoin-btc-logo.png',
  ),
  TradingInstrument(
    symbol: 'ETC/USDT',
    price: '21.451',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFF38A169),
    iconUrl: 'https://cryptologos.cc/logos/ethereum-classic-etc-logo.png',
  ),
  TradingInstrument(
    symbol: 'ETH/USDT',
    price: '4317.71',
    priceColor: const Color(0xFFE53E3E),
    backgroundColor: const Color(0xFF718096),
    iconUrl: 'https://cryptologos.cc/logos/ethereum-eth-logo.png',
  ),
  TradingInstrument(
    symbol: 'XAUUSD',
    price: '3350.63',
    priceColor: const Color(0xFFE53E3E),
    backgroundColor: const Color(0xFFECC94B),
    iconUrl: '',
    icon: Icons.monetization_on,
  ),
  TradingInstrument(
    symbol: 'BNB/USDT Max',
    price: '834.68',
    priceColor: const Color(0xFFE53E3E),
    backgroundColor: const Color(0xFFECC94B),
    iconUrl: 'https://cryptologos.cc/logos/bnb-bnb-logo.png',
  ),
  TradingInstrument(
    symbol: 'XAGUSD Max',
    price: '38.116',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFF718096),
    iconUrl: '',
    icon: Icons.ac_unit,
  ),
  TradingInstrument(
    symbol: 'SHIB/USDT',
    price: '0.012613',
    priceColor: const Color(0xFFE53E3E),
    backgroundColor: const Color(0xFFE53E3E),
    iconUrl: 'https://cryptologos.cc/logos/shiba-inu-shib-logo.png',
  ),
  TradingInstrument(
    symbol: 'TRUMP/USDT',
    price: '8.987',
    priceColor: const Color(0xFFE53E3E),
    backgroundColor: const Color(0xFF2D3748),
    iconUrl: '',
    icon: Icons.person,
  ),
  TradingInstrument(
    symbol: 'SUI/USDT',
    price: '3.6164',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFF3182CE),
    iconUrl: 'https://cryptologos.cc/logos/sui-sui-logo.png',
  ),
  TradingInstrument(
    symbol: 'EURUSD',
    price: '1.17034',
    priceColor: const Color(0xFFE53E3E),
    backgroundColor: const Color(0xFF3182CE),
    iconUrl: 'https://flagcdn.com/w40/eu.png',
  ),
  TradingInstrument(
    symbol: 'GBPJPY',
    price: '199.923',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFFE53E3E),
    iconUrl: 'https://flagcdn.com/w40/gb.png',
  ),
  TradingInstrument(
    symbol: 'USDJPY',
    price: '147.482',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFF3182CE),
    iconUrl: 'https://flagcdn.com/w40/us.png',
  ),
];
