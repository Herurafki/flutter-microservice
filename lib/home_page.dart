import 'package:flutter/material.dart';
import 'dart:convert'; // Untuk mengelola JSON
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.43.98:3000/products'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          products = data['data'] ?? [];
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load products. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching products: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: AppBar(
        title: Text("Daftar Produk"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  elevation: 8.0,
                  margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  child: ListTile(
                    title: Text(
                      product['name'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Rp ${product['price']}"),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailPage(
                            productId: product['id'],
                            productName: product['name'],
                            productPrice: product['price'],
                            productDescription: product['description'],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

class ProductDetailPage extends StatefulWidget {
  final String productId;
  final String productName;
  final int productPrice; // Tipe int
  final String productDescription;

  ProductDetailPage({
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productDescription,
  });

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  List<dynamic> reviews = [];
  bool isLoadingReviews = true;

  @override
  void initState() {
    super.initState();
    fetchReviews();
  }

  Future<void> fetchReviews() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.43.98:3003/products/${widget.productId}/reviews'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          reviews = data['data'] ?? [];
          isLoadingReviews = false;
        });
      } else {
        throw Exception("Failed to load reviews. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching reviews: $e");
      setState(() {
        isLoadingReviews = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Produk"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.productName,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "Rp ${widget.productPrice.toString()}",
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
              SizedBox(height: 16),
              Text(
                widget.productDescription,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 24),
              Text(
                'Reviews:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              isLoadingReviews
                  ? Center(child: CircularProgressIndicator())
                  : reviews.isEmpty
                      ? Text("Belum ada review.")
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: reviews
                              .map(
                                (review) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    "${review['review']} - Rating: ${review['rating']?.toString() ?? 'N/A'}/5",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Produk berhasil ditambahkan ke keranjang!"),
                    ));
                  },
                  child: Text("Add to Cart"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
