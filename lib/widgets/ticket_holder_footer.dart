import 'package:flutter/material.dart';

import '../utils/utils.dart';

class TicketHolderFooter extends StatelessWidget {
  final Function onTap;

  const TicketHolderFooter(this.onTap, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: Utils.screenPadding),
      title: Text(
        "Create ticket",
        style: Theme.of(context).textTheme.titleMedium,
      ),
      leading: const Icon(Icons.add, color: Colors.black),
      horizontalTitleGap: 0,
      onTap: () => onTap(),
    );
  }
}
