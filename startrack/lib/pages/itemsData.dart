import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          scaffoldBackgroundColor: Color.fromARGB(217, 180, 206, 233)),
      home: ItemsData(),
    );
  }
}

class ItemsData extends StatelessWidget {
  ItemsData({Key? key}) : super(key: key);

  // Sample data
  final List<Product> products = [
    Product(
        name: "Hertarium",
        description:
            "The cryptocurrency circulating internally in the Herta Space Station. Can be used to purchase goods in Special Stores.",
        rarity: "Epic",
        image: "Hertareum.webp"),
    Product(
        name: "Undying Starlight",
        description:
            "Splendid gems formed when a shooting star fell from the sky.",
        rarity: "Exotic",
        image: "star.png"),
    Product(
        name: "Trash",
        description: "Worthless trash Better carry some with you.",
        rarity: "Common",
        image: "Trash.webp"),
    Product(
        name: "Lifeless Blade",
        description: "Legendary Sword",
        rarity: "Exotic",
        image: "sword.webp"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Items"),
        backgroundColor: Color.fromARGB(255, 2, 250, 230),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: MySearchDelegate(products: products),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(2.0, 10.0, 2.0, 10.0),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Navigate to the item information page and pass the selected product
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ItemInformationPage(product: products[index]),
                ),
              );
            },
            child: ProductBox(
              name: products[index].name,
              description: products[index].description,
              rarity: products[index].rarity,
              image: products[index].image,
            ),
          );
        },
      ),
    );
  }
}

class MySearchDelegate extends SearchDelegate {
  final List<Product> products;

  MySearchDelegate({required this.products});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Product> matchQuery = [];
    for (var product in products) {
      if (product.name.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(product);
      }
    }
    return buildResultListView(matchQuery);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Product> matchQuery = [];
    for (var product in products) {
      if (product.name.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(product);
      }
    }
    return buildResultListView(matchQuery);
  }

  Widget buildResultListView(List<Product> matchQuery) {
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result.name),
          // You can add onTap functionality here if needed
        );
      },
    );
  }
}

class ProductBox extends StatelessWidget {
  const ProductBox(
      {Key? key,
      required this.name,
      required this.description,
      required this.rarity,
      required this.image})
      : super(key: key);
  final String name;
  final String description;
  final String rarity;
  final String image;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;

    // Assign background color based on rarity
    switch (rarity.toLowerCase()) {
      case "common":
        backgroundColor = Colors.grey;
        break;
      case "uncommon":
        backgroundColor = Colors.green;
        break;
      case "exotic":
        backgroundColor = Colors.yellow;
        break;
      case "rare":
        backgroundColor = Colors.blue;
        break;
      case "epic":
        backgroundColor = Colors.purple;
        break;
      default:
        backgroundColor = Colors.white;
    }

    return Container(
      padding: const EdgeInsets.all(2),
      height: 120,
      color: const Color.fromARGB(255, 247, 4, 93),
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Image.asset("assets/images/$image"),
            Expanded(
              child: Container(
                color: backgroundColor,
                padding: const EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(name,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(description),
                    Text("Rarity: $rarity"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemInformationPage extends StatelessWidget {
  final Product product;

  const ItemInformationPage({Key? key, required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset("assets/images/${product.image}"),
            const SizedBox(height: 16),
            Text("Description: ${product.description}"),
            const SizedBox(height: 8),
            Text("Rarity: ${product.rarity}"),
          ],
        ),
      ),
    );
  }
}

class Product {
  final String name;
  final String description;
  final String rarity;
  final String image;

  Product(
      {required this.name,
      required this.description,
      required this.rarity,
      required this.image});
}
