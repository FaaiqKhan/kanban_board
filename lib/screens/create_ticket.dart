import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kanban_board/models/brief_ticket_model.dart';
import 'package:kanban_board/utils/utils.dart';

class CreateTicket extends StatefulWidget {
  const CreateTicket({Key? key}) : super(key: key);

  static const String routeName = "create_ticket_route";

  @override
  State<StatefulWidget> createState() => _CreateTicketState();
}

class _CreateTicketState extends State<CreateTicket> {
  final _formKey = GlobalKey<FormState>();

  String? summary, description, status;

  @override
  void didChangeDependencies() {
    status ??= ModalRoute.of(context)!.settings.arguments as String;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GridTile(
          header: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Utils.screenPadding,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Create Ticket"),
                IconButton(
                  onPressed: Navigator.of(context).pop,
                  icon: const Icon(Icons.close),
                )
              ],
            ),
          ),
          footer: FittedBox(
            fit: BoxFit.scaleDown,
            child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  Box<BriefTicketModel> box;
                  if (Hive.isBoxOpen(status!)) {
                    box = Hive.box(status!);
                  } else {
                    box = await Hive.openBox(status!);
                  }

                  var counterBox = await Hive.openBox(Utils.ticketCounterKey);
                  int count = counterBox.get(Utils.countKey, defaultValue: 0);
                  count++;
                  BriefTicketModel model = BriefTicketModel(
                    id: count,
                    ticketNumber: "AR-$count",
                    title: summary!,
                    subtitle: description!,
                    status: status!,
                    index: box.length
                  );

                  await box.put("AR-$count", model);
                  await counterBox.put(Utils.countKey, count);
                  await counterBox.close();

                  Navigator.pop(context, model);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please fill all required fields"),
                    ),
                  );
                }
              },
              child: const Text("Create"),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(Utils.screenPadding),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),
                    const Text("Status"),
                    SizedBox(
                      width: 130,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade300,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                          ),
                          value: status,
                          items: Utils.statusItems,
                          onChanged: (value) => setState(() => status = value!),
                        ),
                      ),
                    ),
                    const Text(
                      "This is a ticket's initial status upon creation",
                    ),
                    const SizedBox(height: Utils.spaceBetweenTextField),
                    TextFormField(
                      onSaved: (value) => summary = value,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(borderSide: BorderSide()),
                        label: Text("Summary"),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Please fill ticket summary";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: Utils.spaceBetweenTextField),
                    TextFormField(
                      onSaved: (value) => description = value,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Description"),
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLength: 100,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Please fill description ticket";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: Utils.spaceBetweenTextField),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
