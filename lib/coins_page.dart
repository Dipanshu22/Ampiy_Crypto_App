import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CoinsPage extends StatefulWidget {
  final List<dynamic> tickerData; // List of cryptocurrency data
  final Map<String, String> cryptoImageMap; // Map linking cryptocurrency symbols to image assets
  final VoidCallback onReturn; // Callback function to handle returning to the previous page

  const CoinsPage({Key? key, required this.tickerData, required this.cryptoImageMap, required this.onReturn}) : super(key: key);

  @override
  _CoinsPageState createState() => _CoinsPageState();
}

class _CoinsPageState extends State<CoinsPage> {
  String searchQuery = ""; // Variable to store the user's search query

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // Center the title of the AppBar
        title: const Text('Coins'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            widget.onReturn(); // Call the onReturn callback when back is pressed
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toUpperCase(); // Update search query and convert to uppercase
                });
              },
              decoration: InputDecoration(
                hintText: 'Search coins...', // Placeholder text
                prefixIcon: const Icon(Icons.search), // Search icon
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0), // Rounded corners for the input field
                ),
                filled: true,
                fillColor: Colors.grey[850], // Background color of the input field
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Price',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Change',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_downward,
                        color: Colors.white,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.grey), // Separator line

          Expanded(
            child: ListView.builder(
              itemCount: widget.tickerData.length, // Number of items to display
              itemBuilder: (context, index) {
                final ticker = widget.tickerData[index]; // Get the ticker data at the current index
                String symbol = ticker['s'].split('INR').first; // Extract the symbol from the ticker data

                // Check if the search query matches the ticker symbol
                if (searchQuery.isEmpty || ticker['s'].contains(searchQuery)) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20), // Make the image circular
                                child: Image.asset(
                                  widget.cryptoImageMap[symbol]!, // Load the image asset based on the symbol
                                  height: 40,
                                  width: 40,
                                  fit: BoxFit.cover, // Ensure the image covers the container without distortion
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                symbol, // Display the cryptocurrency symbol
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            '₹${ticker['c']}', // Display the current price of the cryptocurrency
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            '${ticker['P']}%', // Display the percentage change in price
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: double.parse(ticker['P']) >= 0 ? Colors.green : Colors.red, // Color based on positive or negative change
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox.shrink(); // If the search query doesn't match, return an empty widget
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).primaryColor, // Color of the selected item
        unselectedItemColor: Colors.grey, // Color of the unselected items
        currentIndex: 1, // Ensure Coins is selected
        onTap: (index) {
          if (index == 0) {
            widget.onReturn(); // Call the onReturn callback when the Home icon is tapped
            Navigator.pop(context); // Navigate back to the previous screen
          }
        },
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
                color: Theme.of(context).primaryColor, // Match the button color to the primary color
              ),
              child: const Icon(Icons.swap_horiz, color: Colors.white), // Swap icon in the middle
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
}
