import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:untitled/authentication/login.dart';
import 'package:untitled/data/fixtures.dart';
import 'package:untitled/products/cart.dart';
import 'package:untitled/products/product_details.dart';

class ProductsPage extends StatefulWidget {
  final String user;
  const ProductsPage({Key? key, required this.user}) : super(key: key);

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: [
          IconButton(
              onPressed: () {
                if (widget.user.compareTo("null") == 0) {
                  Fluttertoast.showToast(msg: 'Please login to view cart!!');
                  Navigator.push(context,
                      MaterialPageRoute(builder: (ctx) => LoginPage()));
                  // return;
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CartPage(
                                userid: widget.user,
                              )));
                }
              },
              icon: Icon(Icons.shopping_bag))
        ],
      ),
      body: GridView.builder(
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 2.0),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductDetails(
                              product: products[index],
                              userid: widget.user,
                            )));
              },
              child: Container(
                height: 210.0,
                margin: EdgeInsets.only(top: 2.0),
                width: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                    border: Border.all(width: 2.0, color: Colors.black)),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 140.0,
                      child: Image.network(
                        products[index]['img_path'],
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text('${products[index]['pname']}'),
                    Text('₹ ${products[index]['price']} /-'),
                  ],
                ),
              ),
            );
          }),
    ));
  }
}
