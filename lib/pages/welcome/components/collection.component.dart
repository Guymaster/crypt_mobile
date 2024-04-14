import 'package:crypt_mobile/models/collection.model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../common/values.dart';

class CollectionComponent extends StatefulWidget {
  final Collection collection;
  const CollectionComponent({super.key, required this.collection});

  @override
  CollectionComponentState createState() {
    return CollectionComponentState();
  }
}

class CollectionComponentState extends State<CollectionComponent> {
  ItemMode mode = ItemMode.VIEW;

  handleDelete() {
    //
  }

  handleUpdate() {
    //
  }

  @override
  Widget build(BuildContext context) {
    return Card();
  }
}