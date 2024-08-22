import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'dart:convert';
import 'coins_page.dart';

final Map<String, String> cryptoImageMap = {
  'BTC': 'lib/assets/Bitcoin.png',
  'ETH': 'lib/assets/Ethereum.jpg',
  'AMPYC': 'lib/assets/ampiy.png',
  'DOGE': 'lib/assets/Dogecoin.jpeg',
  'ADA': 'lib/assets/cardano.png',
  'SOL': 'lib/assets/Solana.png',
  'XRP': 'lib/assets/XRP.png',
  'TRX': 'lib/assets/tron.png',
  'MATIC': 'lib/assets/polygon.jpeg',
  'LTC': 'lib/assets/Litecoin.png',
  'ALGO': 'lib/assets/algorand.png',
  'FIL': 'lib/assets/Filecoin.png',
  'NEO': 'lib/assets/NEO.png',
  'FTM': 'lib/assets/fantom.png',
  'AXS': 'lib/assets/axie Infinity.jpeg',
  'MANA': 'lib/assets/decentraland.jpeg',
  'SAND': 'lib/assets/the sandbox.jpeg',
  'GALA': 'lib/assets/Gala.png',
  'INJ': 'lib/assets/Injective Protocol.jpeg',
  'LDO': 'lib/assets/Lido DAO.jpeg',
  'OCEAN': 'lib/assets/Ocean Protocol.jpeg',
  '1INCH': 'lib/assets/1Inch.png',
  'ENS': 'lib/assets/Ethereum Name Service.jpeg',
  'HFT': 'lib/assets/hashflow.jpeg',
  'IMX': 'lib/assets/immutable x.jpeg',
  'MASK': 'lib/assets/Mask Network.png',
  'LIT': 'lib/assets/litentry.png',
  'OASIS': 'lib/assets/Oasis Network.png',
  'QTUM': 'lib/assets/Qtum.png',
  'FRAX': 'lib/assets/frax.png',
  'IDEX': 'lib/assets/idex.png',
};

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late WebSocketChannel channel;
  List<dynamic> tickerData = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    connectWebSocket();
  }

  void connectWebSocket() {
    channel = WebSocketChannel.connect(
      Uri.parse('ws://prereg.ex.api.ampiy.com/prices'),
    );

    channel.sink.add(jsonEncode({
      "method": "SUBSCRIBE",
      "params": ["all@ticker"],
      "cid": 1
    }));

    channel.stream.listen(
      (data) {
        final decodedData = jsonDecode(data);
        setState(() {
          tickerData = (decodedData['data'] as List<dynamic>)
              .where((ticker) => cryptoImageMap.containsKey(ticker['s'].split('INR').first))
              .toList();
        });
      },
      onError: (error) {
        print('WebSocket error: $error');
      },
      onDone: () {
        print('WebSocket closed');
      },
    );
  }

  @override
  void dispose() {
    channel.sink.close(status.goingAway);
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                CoinsPage(tickerData: tickerData, cryptoImageMap: cryptoImageMap, onReturn: () {
                  setState(() {
                    _selectedIndex = 0;
                  });
                })),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ampiy',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTopButton(Icons.add, "Buy", Colors.green),
                  _buildTopButton(Icons.remove, "Sell", Colors.red),
                  _buildTopButton(Icons.person_add, "Referral", Colors.blue),
                  _buildTopButton(Icons.video_library, "Tutorial", Colors.orange),
                ],
              ),
              const SizedBox(height: 16),
              _buildBanner(context),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildFeatureCard(
                      context: context,
                      icon: Icons.calculate,
                      title: 'SIP Calculator',
                      subtitle: 'Calculate Interests and Returns',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildFeatureCard(
                      context: context,
                      icon: Icons.account_balance,
                      title: 'Deposit INR',
                      subtitle: 'Use UPI or Bank Account to trade or buy SIP',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Coins Section (Top 10)
              Text(
                'Coins',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 16),

              tickerData.isNotEmpty
                  ? Column(
                      children: tickerData.take(10).map((ticker) {
                        return _buildCoinCard(
                          ticker['s'], // Symbol
                          '₹${ticker['c']}', // Current Price (c in the data)
                          ticker['p'], // Increment or Decrement Value (p in the data)
                          '${ticker['P']}%', // Percent Change (P in the data)
                          double.parse(ticker['P']) >= 0, // Determine if positive or negative change
                        );
                      }).toList(),
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),

              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () => _onItemTapped(1), // Trigger navigation to CoinsPage
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: const Text('View all'),
                ),
              ),
              const SizedBox(height: 16),

              // Market Variation Spectrum
              Text(
                'Market Variation Spectrum',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              _buildMarketVariationSpectrum(),
              const SizedBox(height: 16),

              // Hot Coins Section
              Text(
                'Hot Coins',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 16),

              // Hot Coins Banners
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: tickerData.take(4).map((ticker) {
                    return Container(
                      width: MediaQuery.of(context).size.width / 3 - 20, // 3 cards in view, 10 for margin
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: _buildHotCoinCard(
                        ticker['s'],
                        '₹${ticker['c']}',
                        ticker['p'],
                        double.parse(ticker['P']) >= 0,
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              // Zones
              Text(
                'Zones',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 2.2,
                children: [
                  _buildZoneCard('Platform', '18 Coins', '+7.67%', Colors.blue),
                  _buildZoneCard('NFT', '9 Coins', '+3.49%', Colors.orange),
                  _buildZoneCard('DeFi', '9 Coins', '+5.95%', Colors.purple),
                  _buildZoneCard('PoS', '8 Coins', '+4.20%', Colors.green),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex, // Set current index
        onTap: _onItemTapped, // Handle navigation
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.coins),
            label: 'Coins',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor,
              ),
              child: const Icon(Icons.swap_horiz, color: Colors.white),
            ),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'You',
          ),
        ],
      ),
    );
  }

  Widget _buildTopButton(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.2),
          ),
          child: Icon(icon, color: color, size: 30),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(color: Colors.grey[400])),
      ],
    );
  }

  Widget _buildBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.deepPurple, Colors.indigo],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create Wealth with SIP',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Invest. Grow. Repeat. Grow your money with SIP now.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Start a SIP"),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: Theme.of(context).primaryColor, size: 40),
              const Icon(Icons.arrow_forward, color: Colors.white),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCoinCard(String name, String price, String changeValue, String changePercent, bool isPositive) {
    String symbol = name.split('INR').first;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20), // Make the image circular
            child: Image.asset(
              cryptoImageMap[symbol]!,
              height: 40,
              width: 40,
              fit: BoxFit.cover, // Ensure the image covers the container without distortion
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                symbol,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isPositive ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  changePercent,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHotCoinCard(String name, String price, String changeValue, bool isPositive) {
    String symbol = name.split('INR').first;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20), // Make the image circular
            child: Image.asset(
              cryptoImageMap[symbol]!,
              height: 40,
              width: 40,
              fit: BoxFit.cover, // Ensure the image covers the container without distortion
            ),
          ),
          const SizedBox(height: 8),
          Text(
            price,
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            changeValue,
            style: TextStyle(
              color: isPositive ? Colors.green : Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildZoneCard(String name, String coins, String change, Color color) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                coins,
                style: const TextStyle(color: Colors.white, fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              change,
              style: TextStyle(color: color, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketVariationSpectrum() {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:  [
            Text('>10%', style: TextStyle(color: Colors.green)),
            Text('7-10%', style: TextStyle(color: Colors.green)),
            Text('5-7%', style: TextStyle(color: Colors.green)),
            Text('3-5%', style: TextStyle(color: Colors.green)),
            Text('0-3%', style: TextStyle(color: Colors.green)),
            Text('0%', style: TextStyle(color: Colors.grey)),
            Text('3-5%', style: TextStyle(color: Colors.red)),
            Text('5-7%', style: TextStyle(color: Colors.red)),
            Text('7-10%', style: TextStyle(color: Colors.red)),
            Text('>10%', style: TextStyle(color: Colors.red)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildBar(7, Colors.green),
            _buildBar(10, Colors.green),
            _buildBar(19, Colors.green),
            _buildBar(42, Colors.green),
            _buildBar(28, Colors.green),
            _buildBar(80, Colors.grey),
            _buildBar(3, Colors.red),
            _buildBar(0, Colors.red),
            _buildBar(1, Colors.red),
            _buildBar(0, Colors.red),
          ],
        ),
        const SizedBox(height: 8),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:  [
            Text('Up: 106', style: TextStyle(color: Colors.green)),
            Text('Down: 4', style: TextStyle(color: Colors.red)),
          ],
        ),
      ],
    );
  }

  Widget _buildBar(int heightFactor, Color color) {
    return Container(
      height: (heightFactor * 2).toDouble(),
      width: 10,
      color: color,
    );
  }
}
