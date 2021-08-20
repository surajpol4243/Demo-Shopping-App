import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:untitled/authentication/login.dart';
import 'package:untitled/data/fixtures.dart';

class ProductDetails extends StatefulWidget {
  final String userid;
  final Map<String, dynamic> product;

  const ProductDetails({Key? key, required this.product, required this.userid})
      : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int quantity = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 140.0,
              child: Image.network(
                widget.product['img_path'],
                fit: BoxFit.cover,
              ),
            ),
            Text('${widget.product['pname']}'),
            Text('₹ ${widget.product['price']} /-'),
            Text('${widget.product['ratings']} '),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      quantity++;
                    });
                  },
                  icon: Icon(Icons.add),
                  color: Colors.blue,
                ),
                Text('${(quantity < 0) ? 1 : quantity}'),
                IconButton(
                  onPressed: () {
                    if (quantity <= 1) {
                      return;
                    }
                    setState(() {
                      quantity--;
                    });
                  },
                  icon: Icon(Icons.remove),
                  color: Colors.blue,
                ),
              ],
            ),
            MaterialButton(
              onPressed: () {
                if (widget.userid.compareTo("null") == 0) {
                  Fluttertoast.showToast(msg: 'Please login to view cart!!');
                  Navigator.push(context,
                      MaterialPageRoute(builder: (ctx) => LoginPage()));
                  // return;
                } else {
                  showDialog(
                      context: context,
                      builder: (bc) {
                        return AlertDialog(
                          title: Text('Adding to cart...'),
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                            ],
                          ),
                        );
                      });

                  var temp = {
                    'pid': widget.product['pid'],
                    'pname': widget.product['pname'],
                    'price': widget.product['price'] * quantity,
                    'img_path': widget.product['img_path'],
                    'desc': widget.product['desc'],
                    'ratings': widget.product['ratings'],
                    'quantity': quantity,
                  };
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.userid)
                      .collection('cart')
                      .add(temp)
                      .then((value) {
                    Fluttertoast.showToast(msg: 'Added to cart');
                    Navigator.pop(context);
                  });
                }
              },
              color: Colors.blue,
              child: Text(
                'Add to cart',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
