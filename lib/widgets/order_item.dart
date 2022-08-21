// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/utils/dimensions.dart';
import 'package:shop_app/widgets/my_text.dart';
import '../provider/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  const OrderItem({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = true;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(Dimensions.height10),
      child: Column(
        children: [
          ListTile(
            title: MyText(
              text: '\$${widget.order.amount}',
              size: Dimensions.font20,
              isBold: true,
            ),
            subtitle: MyText(
              text:
                  DateFormat('EEE, MMM, h:mm a').format(widget.order.dateTime),
              size: Dimensions.font18,
              color: Colors.grey.shade700,
            ),
            trailing: IconButton(
              icon: Icon(
                _expanded == true
                    ? Icons.expand_less_sharp
                    : Icons.expand_more_sharp,
              ),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.width15,
                vertical: Dimensions.height5,
              ),
              height: min(
                widget.order.products.length * Dimensions.height25 +
                    Dimensions.height10,
                Dimensions.height100 + Dimensions.height80,
              ),
              child: ListView.builder(
                itemCount: widget.order.products.length,
                itemBuilder: (context, i) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(
                      text: widget.order.products[i].title,
                      size: Dimensions.font18,
                      isBold: true,
                    ),
                    MyText(
                      text:
                          '${widget.order.products[i].quantity}x ${widget.order.products[i].price} \$',
                      size: Dimensions.font18,
                      color: Colors.grey.shade600,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
