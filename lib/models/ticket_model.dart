import 'package:kanban_board/models/brief_ticket_model.dart';

class TicketModel extends BriefTicketModel {
  String startTime, endTime;

  TicketModel(
    int id,
    String ticketNumber,
    String title,
    String subtitle,
    String status,
    this.startTime,
    this.endTime,
  ) : super(
          id: id,
          ticketNumber: ticketNumber,
          title: title,
          subtitle: subtitle,
          status: status,
        );
}
