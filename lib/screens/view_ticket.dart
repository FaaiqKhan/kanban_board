import 'package:flutter/material.dart';
import 'package:kanban_board/utils/utils.dart';

class Ticket extends StatefulWidget {
  const Ticket({Key? key}) : super(key: key);

  @override
  State<Ticket> createState() => _TicketState();
}

class _TicketState extends State<Ticket> {
  bool editing = false;

  Map<String, String>? data;

  @override
  void didChangeDependencies() {
    data ??= ModalRoute
        .of(context)!
        .settings
        .arguments as Map<String, String>;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 2.0, color: Colors.grey.shade200),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                      visible: !editing,
                      child: IconButton(
                        onPressed: Navigator
                            .of(context)
                            .pop,
                        icon: const Icon(Icons.arrow_back),
                      ),
                    ),
                    Visibility(
                      visible: editing,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => setState(() => editing = false),
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
                    Text(data!['ticket_number'] as String),
                    const SizedBox(height: Utils.screenPadding),
                    const Text("Status"),
                    const SizedBox(height: Utils.screenPadding),
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
                        value: data!['status'] as String,
                        disabledHint: Text(data!['status'] as String),
                        items: !editing ? null : Utils.statusItems,
                        onChanged: !editing ? null : (value) =>
                            setState(() => data!['status'] = value as String),
                      ),
                    ),
                    const SizedBox(height: Utils.screenPadding),
                    Text(data!['title'] as String),
                    const SizedBox(height: Utils.screenPadding),
                    const Text("Description"),
                    const SizedBox(height: 5),
                    Text(data!['subtitle'] as String),
                    const SizedBox(height: 20),
                    const Text("Reporter"),
                    const SizedBox(height: 5),
                    const Text("Faiq Ali Khan")
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
