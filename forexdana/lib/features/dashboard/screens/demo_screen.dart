import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DemoScreen extends StatefulWidget {
  const DemoScreen({super.key});

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final size = MediaQuery.of(context).size;

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
              // TODO: Add customer support functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.mail_outline, color: Colors.white),
            onPressed: () {
              // TODO: Add mail functionality
            },
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
                      color: Colors.black.withValues(alpha: 0.1),
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
                              // TODO: Add account activation functionality
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
                    Container(
                      width: 80,
                      height: 100,
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
            color: Colors.black.withValues(alpha: 0.05),
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

// Data for different pages
final List<TradingInstrument> cryptoInstruments1 = [
  TradingInstrument(
    symbol: 'ATOM/USDT',
    price: '4.468',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFF2D3748),
    iconUrl: 'https://cryptologos.cc/logos/cosmos-atom-logo.png',
  ),
  TradingInstrument(
    symbol: 'ALGO/USDT',
    price: '0.2540',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFF000000),
    iconUrl: 'https://cryptologos.cc/logos/algorand-algo-logo.png',
  ),
  TradingInstrument(
    symbol: 'AAVE/USDT',
    price: '289.85',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFF2B6CB0),
    iconUrl: 'https://cryptologos.cc/logos/aave-aave-logo.png',
  ),
  TradingInstrument(
    symbol: 'ZEC/USDT',
    price: '35.95',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFFED8936),
    iconUrl: 'https://cryptologos.cc/logos/zcash-zec-logo.png',
  ),
  TradingInstrument(
    symbol: 'UNI/USDT',
    price: '10.613',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFFED64A6),
    iconUrl: 'https://cryptologos.cc/logos/uniswap-uni-logo.png',
  ),
  TradingInstrument(
    symbol: 'LRC/USDT',
    price: '0.0886',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFF3182CE),
    iconUrl: 'https://cryptologos.cc/logos/loopring-lrc-logo.png',
  ),
  TradingInstrument(
    symbol: 'ICP/USDT',
    price: '5.314',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFF38A169),
    iconUrl: 'https://cryptologos.cc/logos/internet-computer-icp-logo.png',
  ),
  TradingInstrument(
    symbol: 'GRT/USDT',
    price: '0.09117',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFF2B6CB0),
    iconUrl: 'https://cryptologos.cc/logos/the-graph-grt-logo.png',
  ),
  TradingInstrument(
    symbol: 'XLM/USDT',
    price: '0.41023',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFF2D3748),
    iconUrl: 'https://cryptologos.cc/logos/stellar-xlm-logo.png',
  ),
];

final List<TradingInstrument> forexInstruments1 = [
  TradingInstrument(
    symbol: 'GBPJPY',
    price: '199.923',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFFE53E3E),
    iconUrl: 'https://flagcdn.com/w40/gb.png',
  ),
  TradingInstrument(
    symbol: 'NZDUSD',
    price: '0.59319',
    priceColor: const Color(0xFFE53E3E),
    backgroundColor: const Color(0xFF3182CE),
    iconUrl: 'https://flagcdn.com/w40/nz.png',
  ),
  TradingInstrument(
    symbol: 'USDCAD',
    price: '1.38032',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFF3182CE),
    iconUrl: 'https://flagcdn.com/w40/us.png',
  ),
  TradingInstrument(
    symbol: 'USDCHF',
    price: '0.80616',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFFE53E3E),
    iconUrl: 'https://flagcdn.com/w40/us.png',
  ),
  TradingInstrument(
    symbol: 'EURAUD',
    price: '1.79545',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFF3182CE),
    iconUrl: 'https://flagcdn.com/w40/eu.png',
  ),
  TradingInstrument(
    symbol: 'EURCAD',
    price: '1.61534',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFF3182CE),
    iconUrl: 'https://flagcdn.com/w40/eu.png',
  ),
  TradingInstrument(
    symbol: 'AUDNZD',
    price: '1.09878',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFF3182CE),
    iconUrl: 'https://flagcdn.com/w40/au.png',
  ),
  TradingInstrument(
    symbol: 'GBPCAD',
    price: '1.87108',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFF3182CE),
    iconUrl: 'https://flagcdn.com/w40/gb.png',
  ),
  TradingInstrument(
    symbol: 'XAGUSD',
    price: '38.116',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFF718096),
    iconUrl: '',
  ),
];

final List<TradingInstrument> forexInstruments2 = [
  TradingInstrument(
    symbol: 'NZDJPY',
    price: '87.484',
    priceColor: const Color(0xFFE53E3E),
    backgroundColor: const Color(0xFF38A169),
    iconUrl: 'https://flagcdn.com/w40/nz.png',
  ),
  TradingInstrument(
    symbol: 'CADCHF',
    price: '0.58405',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFFE53E3E),
    iconUrl: 'https://flagcdn.com/w40/ca.png',
  ),
  TradingInstrument(
    symbol: 'EURNZD',
    price: '1.97289',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFF3182CE),
    iconUrl: 'https://flagcdn.com/w40/eu.png',
  ),
  TradingInstrument(
    symbol: 'NZDCHF',
    price: '0.47821',
    priceColor: const Color(0xFFE53E3E),
    backgroundColor: const Color(0xFF3182CE),
    iconUrl: 'https://flagcdn.com/w40/nz.png',
  ),
  TradingInstrument(
    symbol: 'NZDCAD',
    price: '0.81876',
    priceColor: const Color(0xFFE53E3E),
    backgroundColor: const Color(0xFF3182CE),
    iconUrl: 'https://flagcdn.com/w40/nz.png',
  ),
  TradingInstrument(
    symbol: 'GBPNZD',
    price: '2.28521',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFF3182CE),
    iconUrl: 'https://flagcdn.com/w40/gb.png',
  ),
  TradingInstrument(
    symbol: 'GBPAUD',
    price: '2.07968',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFF3182CE),
    iconUrl: 'https://flagcdn.com/w40/gb.png',
  ),
  TradingInstrument(
    symbol: 'DOGE/USDT',
    price: '0.22386',
    priceColor: const Color(0xFFE53E3E),
    backgroundColor: const Color(0xFFECC94B),
    iconUrl: 'https://cryptologos.cc/logos/dogecoin-doge-logo.png',
  ),
  TradingInstrument(
    symbol: 'EURJPY',
    price: '172.602',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFF3182CE),
    iconUrl: 'https://flagcdn.com/w40/eu.png',
  ),
];

final List<TradingInstrument> cryptoInstruments2 = [
  TradingInstrument(
    symbol: 'SOL/USDT',
    price: '182.260',
    priceColor: const Color(0xFFE53E3E),
    backgroundColor: const Color(0xFF9F7AEA),
    iconUrl: 'https://cryptologos.cc/logos/solana-sol-logo.png',
  ),
  TradingInstrument(
    symbol: 'TRX/USDT',
    price: '0.34810',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFFED8936),
    iconUrl: 'https://cryptologos.cc/logos/tron-trx-logo.png',
  ),
  TradingInstrument(
    symbol: 'HBAR/USDT',
    price: '0.24405',
    priceColor: const Color(0xFFE53E3E),
    backgroundColor: const Color(0xFF2D3748),
    iconUrl: 'https://cryptologos.cc/logos/hedera-hbar-logo.png',
  ),
  TradingInstrument(
    symbol: 'AUDUSD',
    price: '0.65184',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFF38A169),
    iconUrl: 'https://flagcdn.com/w40/au.png',
  ),
  TradingInstrument(
    symbol: 'DOGE/USDT Max',
    price: '0.22370',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFFECC94B),
    iconUrl: 'https://cryptologos.cc/logos/dogecoin-doge-logo.png',
  ),
  TradingInstrument(
    symbol: 'XRP/USDT',
    price: '2.98550',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFF3182CE),
    iconUrl: 'https://cryptologos.cc/logos/xrp-xrp-logo.png',
  ),
  TradingInstrument(
    symbol: 'BTC/USDT Max',
    price: '115223.20',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFFED8936),
    iconUrl: 'https://cryptologos.cc/logos/bitcoin-btc-logo.png',
  ),
  TradingInstrument(
    symbol: 'ETH/USDT Max',
    price: '4317.36',
    priceColor: const Color(0xFFE53E3E),
    backgroundColor: const Color(0xFF718096),
    iconUrl: 'https://cryptologos.cc/logos/ethereum-eth-logo.png',
  ),
  TradingInstrument(
    symbol: 'BNB/USDT',
    price: '834.68',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFFECC94B),
    iconUrl: 'https://cryptologos.cc/logos/bnb-bnb-logo.png',
  ),
];

final List<TradingInstrument> stocksAndCrypto = [
  TradingInstrument(
    symbol: 'USOIL',
    price: '62.921',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFF2D3748),
    iconUrl: '',
  ),
  TradingInstrument(
    symbol: 'EURUSD',
    price: '1.17034',
    priceColor: const Color(0xFFE53E3E),
    backgroundColor: const Color(0xFF3182CE),
    iconUrl: 'https://flagcdn.com/w40/eu.png',
  ),
  TradingInstrument(
    symbol: 'TRX/USDT Max',
    price: '0.34813',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFFE53E3E),
    iconUrl: 'https://cryptologos.cc/logos/tron-trx-logo.png',
  ),
  TradingInstrument(
    symbol: 'USDJPY',
    price: '147.482',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFF3182CE),
    iconUrl: 'https://flagcdn.com/w40/us.png',
  ),
  TradingInstrument(
    symbol: 'Amazon.com, Inc',
    price: '231.00',
    priceColor: const Color(0xFF718096),
    backgroundColor: const Color(0xFF2D3748),
    iconUrl: '',
  ),
  TradingInstrument(
    symbol: 'Tesla Inc',
    price: '330.51',
    priceColor: const Color(0xFF718096),
    backgroundColor: const Color(0xFFE53E3E),
    iconUrl: '',
  ),
  TradingInstrument(
    symbol: 'Apple Inc',
    price: '231.60',
    priceColor: const Color(0xFF718096),
    backgroundColor: const Color(0xFF2D3748),
    iconUrl: '',
  ),
  TradingInstrument(
    symbol: 'FIL/USDT',
    price: '2.466',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFF3182CE),
    iconUrl: 'https://cryptologos.cc/logos/filecoin-fil-logo.png',
  ),
  TradingInstrument(
    symbol: 'NIFTY 50',
    price: '25008.20',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFF9F7AEA),
    iconUrl: '',
  ),
];

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
  ),
  TradingInstrument(
    symbol: 'SUI/USDT',
    price: '3.6164',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFF3182CE),
    iconUrl: 'https://cryptologos.cc/logos/sui-sui-logo.png',
  ),
  // Additional Forex Pairs
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
  TradingInstrument(
    symbol: 'AUDUSD',
    price: '0.65184',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFF38A169),
    iconUrl: 'https://flagcdn.com/w40/au.png',
  ),
  TradingInstrument(
    symbol: 'USDCAD',
    price: '1.38032',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFF3182CE),
    iconUrl: 'https://flagcdn.com/w40/us.png',
  ),
  TradingInstrument(
    symbol: 'NZDUSD',
    price: '0.59319',
    priceColor: const Color(0xFFE53E3E),
    backgroundColor: const Color(0xFF3182CE),
    iconUrl: 'https://flagcdn.com/w40/nz.png',
  ),
  // Additional Crypto
  TradingInstrument(
    symbol: 'SOL/USDT',
    price: '182.260',
    priceColor: const Color(0xFFE53E3E),
    backgroundColor: const Color(0xFF9F7AEA),
    iconUrl: 'https://cryptologos.cc/logos/solana-sol-logo.png',
  ),
  TradingInstrument(
    symbol: 'XRP/USDT',
    price: '2.98550',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFF3182CE),
    iconUrl: 'https://cryptologos.cc/logos/xrp-xrp-logo.png',
  ),
  TradingInstrument(
    symbol: 'ADA/USDT',
    price: '0.456',
    priceColor: const Color(0xFFE53E3E),
    backgroundColor: const Color(0xFF2B6CB0),
    iconUrl: 'https://cryptologos.cc/logos/cardano-ada-logo.png',
  ),
  TradingInstrument(
    symbol: 'DOT/USDT',
    price: '7.23',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFFE53E3E),
    iconUrl: 'https://cryptologos.cc/logos/polkadot-new-dot-logo.png',
  ),
  TradingInstrument(
    symbol: 'LINK/USDT',
    price: '15.67',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFF2B6CB0),
    iconUrl: 'https://cryptologos.cc/logos/chainlink-link-logo.png',
  ),
  TradingInstrument(
    symbol: 'MATIC/USDT',
    price: '0.89',
    priceColor: const Color(0xFFE53E3E),
    backgroundColor: const Color(0xFF9F7AEA),
    iconUrl: 'https://cryptologos.cc/logos/polygon-matic-logo.png',
  ),
  // Commodities
  TradingInstrument(
    symbol: 'USOIL',
    price: '62.921',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFF2D3748),
    iconUrl: '',
  ),
  TradingInstrument(
    symbol: 'XAUUSD Max',
    price: '3350.63',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFFECC94B),
    iconUrl: '',
  ),
  TradingInstrument(
    symbol: 'XAGUSD',
    price: '38.116',
    priceColor: const Color(0xFFE53E3E),
    backgroundColor: const Color(0xFF718096),
    iconUrl: '',
  ),
  TradingInstrument(
    symbol: 'COPPER',
    price: '3.45',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFFED8936),
    iconUrl: '',
  ),
  // Stocks
  TradingInstrument(
    symbol: 'AAPL',
    price: '231.60',
    priceColor: const Color(0xFF718096),
    backgroundColor: const Color(0xFF2D3748),
    iconUrl: '',
  ),
  TradingInstrument(
    symbol: 'TSLA',
    price: '330.51',
    priceColor: const Color(0xFF718096),
    backgroundColor: const Color(0xFFE53E3E),
    iconUrl: '',
  ),
  TradingInstrument(
    symbol: 'AMZN',
    price: '231.00',
    priceColor: const Color(0xFF718096),
    backgroundColor: const Color(0xFF2D3748),
    iconUrl: '',
  ),
  TradingInstrument(
    symbol: 'GOOGL',
    price: '145.23',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFF3182CE),
    iconUrl: '',
  ),
  TradingInstrument(
    symbol: 'MSFT',
    price: '456.78',
    priceColor: const Color(0xFFE53E3E),
    backgroundColor: const Color(0xFF718096),
    iconUrl: '',
  ),
  TradingInstrument(
    symbol: 'META',
    price: '298.45',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFF2B6CB0),
    iconUrl: '',
  ),
  // Indices
  TradingInstrument(
    symbol: 'NIFTY 50',
    price: '25008.20',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFF9F7AEA),
    iconUrl: '',
  ),
  TradingInstrument(
    symbol: 'SENSEX',
    price: '82345.67',
    priceColor: const Color(0xFFE53E3E),
    backgroundColor: const Color(0xFFED8936),
    iconUrl: '',
  ),
  TradingInstrument(
    symbol: 'DOW',
    price: '38789.12',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFF3182CE),
    iconUrl: '',
  ),
  TradingInstrument(
    symbol: 'S&P 500',
    price: '5123.45',
    priceColor: const Color(0xFFE53E3E),
    backgroundColor: const Color(0xFF2D3748),
    iconUrl: '',
  ),
  TradingInstrument(
    symbol: 'NASDAQ',
    price: '16234.56',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFF718096),
    iconUrl: '',
  ),
  // More Crypto
  TradingInstrument(
    symbol: 'AVAX/USDT',
    price: '45.67',
    priceColor: const Color(0xFFE53E3E),
    backgroundColor: const Color(0xFFE53E3E),
    iconUrl: 'https://cryptologos.cc/logos/avalanche-avax-logo.png',
  ),
  TradingInstrument(
    symbol: 'UNI/USDT',
    price: '10.613',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFFED64A6),
    iconUrl: 'https://cryptologos.cc/logos/uniswap-uni-logo.png',
  ),
  TradingInstrument(
    symbol: 'ATOM/USDT',
    price: '4.468',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFF2D3748),
    iconUrl: 'https://cryptologos.cc/logos/cosmos-atom-logo.png',
  ),
  TradingInstrument(
    symbol: 'LTC/USDT',
    price: '89.45',
    priceColor: const Color(0xFFE53E3E),
    backgroundColor: const Color(0xFF718096),
    iconUrl: 'https://cryptologos.cc/logos/litecoin-ltc-logo.png',
  ),
  TradingInstrument(
    symbol: 'BCH/USDT',
    price: '234.56',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFFED8936),
    iconUrl: 'https://cryptologos.cc/logos/bitcoin-cash-bch-logo.png',
  ),
  // More Forex
  TradingInstrument(
    symbol: 'EURGBP',
    price: '0.8567',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFF3182CE),
    iconUrl: 'https://flagcdn.com/w40/eu.png',
  ),
  TradingInstrument(
    symbol: 'GBPCHF',
    price: '1.2345',
    priceColor: const Color(0xFFE53E3E),
    backgroundColor: const Color(0xFFE53E3E),
    iconUrl: 'https://flagcdn.com/w40/gb.png',
  ),
  TradingInstrument(
    symbol: 'AUDJPY',
    price: '98.76',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFF38A169),
    iconUrl: 'https://flagcdn.com/w40/au.png',
  ),
  TradingInstrument(
    symbol: 'CADJPY',
    price: '106.89',
    priceColor: const Color(0xFFE53E3E),
    backgroundColor: const Color(0xFF3182CE),
    iconUrl: 'https://flagcdn.com/w40/ca.png',
  ),
  TradingInstrument(
    symbol: 'CHFJPY',
    price: '183.45',
    priceColor: const Color(0xFF38A169),
    backgroundColor: const Color(0xFFE53E3E),
    iconUrl: 'https://flagcdn.com/w40/ch.png',
  ),
];
