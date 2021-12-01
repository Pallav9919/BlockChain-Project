// ignore_for_file: file_names, no_logic_in_create_state

import 'package:flutter/material.dart';
import 'main.dart';

Product product = const Product();

class Product extends StatefulWidget {
  const Product({Key? key}) : super(key: key);

  @override
  _ProductState createState() => _ProductState();
}

class ProductDetails {
  late BigInt productId;
  late String productName;
  late String productDescription;
  late BigInt maxTemprature;
  ProductDetails(this.productId, this.productName, this.productDescription,
      this.maxTemprature);
}

class _ProductState extends State<Product> {
  bool isLoading = true;
  List<ProductDetails> products = [];

  Future<void> getProductDetails() async {
    products = (await milkFactoryState.getProductDetails())[0].map((e)=>ProductDetails(BigInt.parse(e[0].toString()),e[1].toString(),e[2].toString(),BigInt.parse(e[3].toString()))).toList();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(isLoading) {
      getProductDetails();
    }
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : const Text('Product');
  }
}
