import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Shops extends StatefulWidget {
  const Shops({super.key});

  @override
  State<Shops> createState() => _ShopsState();
}

class _ShopsState extends State<Shops> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController posController = TextEditingController();
    final TextEditingController nameController = TextEditingController();
    final firestore =
        FirebaseFirestore.instance.collection('Vendors').snapshots();
    CollectionReference ref = FirebaseFirestore.instance.collection('Vendors');
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: const Text("Your Nearby Shops"),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('Vendors').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      subtitle: Text('Bindal Juice'),
                      title: Text(snapshot.data!.docs[index]['company']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.favorite,color: Colors.red,),
                            onPressed: (){
                            },
                          ),
                          Text(snapshot.data!.docs[index]['like'].length.toString())
                        ],
                      ),
                    );
                  });
            }));
  }
}
