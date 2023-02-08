import 'package:flutter/material.dart';
import 'package:kanban_board/models/brief_ticket_model.dart';
import 'package:kanban_board/states/ticket_states.dart';
import 'package:kanban_board/utils/utils.dart';
import 'package:provider/provider.dart';

import '../screens/view_ticket.dart';

class BriefTicket extends StatelessWidget {
  final BriefTicketModel model;

  const BriefTicket(this.model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Utils.ticketWidth,
      height: Utils.ticketHeight,
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(
          context,
          Ticket.routeName,
          arguments: model,
        ).then((value) {
          if (value == null) return;
          Provider.of<TicketStates>(
            context,
            listen: false,
          ).updateTicket((value as List<dynamic>)[0], value[1]);
        }),
        child: Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      model.title,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  subtitle: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.topLeft,
                    child: Container(
                      color: Colors.grey.shade50,
                      child: Text(
                        model.subtitle,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                ),
                Text(
                  model.ticketNumber,
                  style: Theme.of(context).textTheme.bodyMedium,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
