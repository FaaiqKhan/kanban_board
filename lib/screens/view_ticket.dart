import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kanban_board/models/brief_ticket_model.dart';
import 'package:kanban_board/utils/utils.dart';

class Ticket extends StatefulWidget {
  static const String routeName = "ticket_route";

  const Ticket({Key? key}) : super(key: key);

  @override
  State<Ticket> createState() => _TicketState();
}

class _TicketState extends State<Ticket> {
  bool editing = false;
  String? actualStatus, parentStatus;

  BriefTicketModel? data;

  final _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    data ??= ModalRoute.of(context)!.settings.arguments as BriefTicketModel;
    actualStatus ??= data!.status;
    parentStatus ??= data!.status;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom:
                          BorderSide(width: 2.0, color: Colors.grey.shade200),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Visibility(
                        visible: !editing,
                        child: IconButton(
                          onPressed: () => Navigator.pop(context, [data, parentStatus]),
                          icon: const Icon(Icons.arrow_back),
                        ),
                      ),
                      Visibility(
                        visible: editing,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () async {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }
                                _formKey.currentState!.save();

                                Box<BriefTicketModel> box;
                                if (data!.status != actualStatus) {
                                  if (Hive.isBoxOpen(actualStatus!)) {
                                    box = Hive.box(actualStatus!);
                                  } else {
                                    box = await Hive.openBox(actualStatus!);
                                  }

                                  box = Hive.box(actualStatus!);
                                  await box.delete(data!.ticketNumber);
                                  await box.close();
                                }

                                if (Hive.isBoxOpen(data!.status)) {
                                  box = Hive.box(data!.status);
                                } else {
                                  box = await Hive.openBox(data!.status);
                                }

                                box.put(data!.ticketNumber, data!);

                                setState(() {
                                  editing = false;
                                  actualStatus = data!.status;
                                });
                              },
                              icon: const Icon(Icons.check),
                            ),
                            IconButton(
                              onPressed: () => setState(() => editing = false),
                              icon: const Icon(Icons.close),
                            ),
                          ],
                        ),
                        replacement: IconButton(
                          onPressed: () => setState(() => editing = true),
                          icon: const Icon(Icons.edit),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Utils.screenPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      Text(data!.ticketNumber),
                      const SizedBox(height: Utils.spaceBetweenTextField),
                      const Text("Status"),
                      const SizedBox(height: Utils.spaceBetweenTextField),
                      SizedBox(
                        width: 130,
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
                          value: data!.status,
                          disabledHint: Text(data!.status),
                          items: !editing ? null : Utils.statusItems,
                          onChanged: !editing
                              ? null
                              : (value) =>
                                  setState(() => data!.status = value!),
                        ),
                      ),
                      const SizedBox(height: Utils.spaceBetweenTextField),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              enabled: editing,
                              initialValue: data!.title,
                              onSaved: (value) => data!.title = value!,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text("Title"),
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return "Title cannot be empty";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: Utils.spaceBetweenTextField),
                            TextFormField(
                              enabled: editing,
                              initialValue: data!.subtitle,
                              onSaved: (value) => data!.subtitle = value!,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text("Description"),
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return "Description cannot be empty";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
