import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop/views/screens/edit_product_screen.dart';
import 'package:shop/models/providers/products.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String urlImage;

  // ignore: use_key_in_widget_constructors
  const UserProductItem(this.id, this.title, this.urlImage);

  @override
  Widget build(BuildContext context) {
    var snackBar = ScaffoldMessenger.of(context);

    return ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(urlImage),
        ),
        title: Text(title),
        trailing: SizedBox(
          width: 100,
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, EditProductScreen.routeName,
                      arguments: id);
                },
                icon: const Icon(Icons.edit),
              ),
              IconButton(
                onPressed: () async {
                  try {
                    await Provider.of<Products>(context, listen: false)
                        .deleteProduct(id);
                    snackBar.showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.lightBlueAccent,
                        content: Text('Item Deletion Successull'),
                      ),
                    );
                  } catch (error) {
                    snackBar.showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.redAccent,
                        content: Text('Item Deletion Failed!'),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
        ));
  }
}
