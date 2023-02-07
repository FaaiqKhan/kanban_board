import 'package:flutter/material.dart';

import '../utils/utils.dart';

class TicketHolderHeader extends StatelessWidget {
  final String header;
  const TicketHolderHeader(this.header, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Utils.screenPadding),
      child: Text(header),
    );
  }
}