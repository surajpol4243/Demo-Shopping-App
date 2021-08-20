import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled/data/fixtures.dart';
import 'package:untitled/products/product_details.dart';

class CartPage extends StatefulWidget {
  final String userid;
  const CartPage({Key? key, required this.userid}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(widget.userid)
                .collection('cart')
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                    body: Center(child: CircularProgressIndicator()));
              } else if (snapshot.connectionState == ConnectionState.done) {
                print(snapshot);
                QuerySnapshot<Object?>? documents = snapshot.data;
                List<DocumentSnapshot> docs = documents!.docs;
                print(docs);
                return Scaffold(
                  appBar: AppBar(
                    title: Text('Cart'),
                  ),
                  body: GridView.builder(
                      itemCount: docs.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductDetails(
                                          product: products[index],
                                          userid: widget.userid,
                                        )));
                          },
                          child: Container(
                            height: 220.0,
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 120.0,
                                  child: Image.network(
                                    docs[index]['img_path'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Text('${docs[index]['pname']}'),
                                Text('Quantity : ${docs[index]['quantity']}'),
                                Text(
                                    'Total price : ₹ ${docs[index]['price']} /-'),
                              ],
                            ),
                          ),
                        );
                      }),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}
