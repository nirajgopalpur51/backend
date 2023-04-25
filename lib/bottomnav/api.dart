
import 'package:cloud_firestore/cloud_firestore.dart';

class Api{

  FirebaseFirestore firestore =FirebaseFirestore.instance;
  Future<void>likePost(String com )async {
    try{

        await firestore.collection('Vendors').doc(com).update({
          'like': FieldValue.arrayUnion('a' as List)
        });


    }catch(err){

    }

}}