import 'package:flutter/material.dart';

import '../utils/utils.dart';

class TicketHolderHeader extends StatelessWidget {
  final String header;
  final Icon? icon;

  const TicketHolderHeader(this.header, {this.icon, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Utils.screenPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(right: Utils.screenPadding),
              child: icon,
            ),
          Text(header, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
