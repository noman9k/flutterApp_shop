import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/providers/cart.dart';
import 'package:shop/models/providers/orders.dart';
import 'package:shop/views/widgets/app_drawer.dart';
import 'package:shop/views/widgets/cart_item.dart' as ci;

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);
  static const routeName = '/cart-screen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Carts>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      drawer: const MyAppDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const Spacer(),
                    Chip(
                      label: Text('\$ ${cart.totalPrice.toStringAsFixed(2)}'),
                      backgroundColor: Colors.lightBlue,
                    ),
                    OrderButton(cart: cart)
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<Carts>(
              builder: (context, cart, child) => ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (context, index) => ci.CartItem(
                  cart.items.values.toList()[index].id,
                  cart.items.keys.toList()[index],
                  cart.items.values.toList()[index].title,
                  cart.items.values.toList()[index].quantity,
                  cart.items.values.toList()[index].price,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Carts cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: _isLoading
          ? const CircularProgressIndicator()
          : const Text('Order Now'),
      onPressed: widget.cart.items.isEmpty
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                  widget.cart.items.values.toList(), widget.cart.totalPrice);
              setState(() {
                _isLoading = false;
              });
              widget.cart.placeOrder();

              // Navigator.of(context).pushNamed(OrdersScreen.routeName);
            },
    );
  }
}
