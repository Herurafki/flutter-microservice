import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:herurafki_ecom/model/review.dart';
import 'package:herurafki_ecom/model/product.dart';

class DetailProduct extends StatefulWidget {
  final ProductDatum product;

  const DetailProduct({super.key, required this.product});

  @override
  State<DetailProduct> createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
  List<ReviewDatum> reviews = [];

  @override
  void initState() {
    super.initState();
    fetchReviews(widget.product.id);
  }

  Future<void> fetchReviews(int productId) async {
    try {
      final response = await http.get(
          Uri.parse('http://192.168.82.98:3003/products/$productId/reviews'));
      if (response.statusCode == 200) {
        final review = reviewFromJson(response.body);
        setState(() {
          reviews = review.data; 
        });
      } else {
        print('Error fetching reviews: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E3B4E),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Detail Produk"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/product_image.png', 
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              Text(
                widget.product.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Rp ${widget.product.price}',
                style: const TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                widget.product.description,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xFF2E3B4E)),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                    child: const Text('Add to Cart'),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Review:',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              reviews.isEmpty
                  ? const Text(
                      '-',
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: reviews.length,
                      itemBuilder: (context, index) {
                        final review = reviews[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween, 
                                children: [
                                  Expanded(
                                    child: Text(
                                      review.review
                                          .comment, 
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: List.generate(5, (starIndex) {
                                      
                                      return Icon(
                                        starIndex < review.review.ratings
                                            ? Icons.star
                                            : Icons
                                                .star_border, 
                                        color: Colors.orange, 
                                        size: 16, 
                                      );
                                    }),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                  height:
                                      8),
                            ],
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}