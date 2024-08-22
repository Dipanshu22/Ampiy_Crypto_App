# Ampiy Crypto App

Ampiy Crypto App is a mobile application designed to provide real-time updates on cryptocurrency prices, market trends, and investment opportunities. The app offers a user-friendly interface with features like hot coin tracking, market variation spectrum, and detailed views of individual cryptocurrencies.

## Features

- **Real-Time Cryptocurrency Prices:** Stay updated with the latest cryptocurrency prices.
- **Market Variation Spectrum:** Visual representation of market changes to help track performance across different ranges.
- **Hot Coins:** Get quick insights into the most popular and trending cryptocurrencies.
- **SIP Calculator:** Calculate potential returns on your investments with our SIP calculator.
- **Easy Transactions:** Quickly buy and sell cryptocurrencies directly from the app.
- **Referral System:** Earn rewards by referring friends to use the app.

## Requirements

- Flutter 3.x
- Dart 2.17+
- VS Code or Android Studio

## Installation

### Clone the repository:

```bash
git clone https://github.com/your_username/Ampiy_Crypto_App.git
cd Ampiy_Crypto_App
```

## Install Flutter dependencies:
```bash
flutter pub get
```

## Set up your project directory structure:
Ensure that your directory structure resembles the following:
```bash
Ampiy_Crypto_App/
├── assets/
│   ├── Bitcoin.png
│   ├── Ethereum.jpg
│   ├── ampiy.png
│   └── ...
├── lib/
│   ├── main.dart
│   ├── pages/
│   │   ├── home_page.dart
│   │   ├── coins_page.dart
│   │   └── ...
├── pubspec.yaml
└── ...
```

## Running the App
Run the app on your device or emulator:
```bash
flutter run
```

## Hot Reload:
Use the hot reload feature in Flutter to see changes instantly:
```bash
r
```

## Usage

- **Home Page:** View a summary of the market with quick links to buy, sell, or refer friends.
- **Coins Page:** Get detailed information about various cryptocurrencies, including their price changes.
- **Hot Coins:** Swipe left and right to view different trending cryptocurrencies.
- **Market Variation Spectrum:** Analyze the market performance through an easy-to-understand visual spectrum.


## Notes

- **Images:** Make sure all images are correctly referenced in the pubspec.yaml file under the assets section.
- **WebSocket:** The app uses WebSocket for real-time updates on cryptocurrency prices. Ensure the WebSocket connection is correctly configured in the main.dart file.
