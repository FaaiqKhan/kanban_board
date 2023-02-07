import 'package:flutter/material.dart';
import 'package:kanban_board/models/brief_ticket_model.dart';
import 'package:kanban_board/utils/utils.dart';

class BriefTicket extends StatelessWidget {
  final BriefTicketModel model;

  const BriefTicket(this.model, {Key? key}) : super(key: key);

  static const String routeName = "brief_ticket_route";

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Utils.ticketWidth,
      height: Utils.ticketHeight,
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(
          context,
          BriefTicket.routeName,
          arguments: {
            "ticket_number": model.ticketNumber,
            "title": model.title,
            "subtitle": model.subtitle,
            "status": model.status
          },
        ),
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
                    child: Text(model.title),
                  ),
                  subtitle: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.topLeft,
                    child: Container(
                      color: Colors.grey.shade50,
                      child: Text(model.subtitle),
                    ),
                  ),
                ),
                Text(model.ticketNumber)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
