import 'package:hive/hive.dart';
import 'package:kanban_board/models/brief_ticket_model.dart';

class BriefTicketModelAdapter extends TypeAdapter<BriefTicketModel> {
  @override
  BriefTicketModel read(BinaryReader reader) {
    return BriefTicketModel(
      id: reader.readInt(),
      ticketNumber: reader.readString(),
      title: reader.readString(),
      subtitle: reader.readString(),
      status : reader.readString(),
    );
  }

  @override
  int get typeId => 1;

  @override
  void write(BinaryWriter writer, BriefTicketModel obj) {
    writer.writeInt(obj.id);
    writer.writeString(obj.ticketNumber);
    writer.writeString(obj.title);
    writer.writeString(obj.subtitle);
    writer.writeString(obj.status);
  }
}
