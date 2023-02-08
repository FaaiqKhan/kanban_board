class BriefTicketModel {
  int id, index;
  String ticketNumber, title, subtitle, status, time;
  String startedAt, completedAt;

  BriefTicketModel({
    required this.id,
    required this.ticketNumber,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.index,
    required this.time,
    this.startedAt = "",
    this.completedAt = "",
  });
}
