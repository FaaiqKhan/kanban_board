import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:kanban_board/screens/create_ticket.dart';
import 'package:kanban_board/utils/utils.dart';
import 'package:kanban_board/screens/view_ticket.dart';

import 'models/brief_ticket_model.dart';
import 'widgets/brief_ticket.dart';

void main() {
  Hive.initFlutter();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyApp(),
      routes: {
        BriefTicket.routeName: (ctx) => const Ticket(),
        CreateTicket.routeName: (ctx) => const CreateTicket(),
      },
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  late List<DragAndDropList> contents;

  List<BriefTicketModel> briefTicketsTodo = [
    BriefTicketModel(1, "AR-1", "Research on drag ui", "Test", "To Do"),
    BriefTicketModel(2, "AR-2", "Research on List", "Test", "To Do"),
    BriefTicketModel(3, "AR-3", "Research on Array", "Test", "To Do")
  ];

  List<BriefTicketModel> briefTicketsInProgress = [
    BriefTicketModel(1, "AR-1", "Research on drag ui", "Test", "In Progress"),
    BriefTicketModel(2, "AR-2", "Research on List", "Test", "In Progress"),
    BriefTicketModel(3, "AR-3", "Research on Array", "Test", "In Progress")
  ];

  List<BriefTicketModel> briefTicketsCompleted = [
    BriefTicketModel(1, "AR-1", "Research on drag ui", "Test", "Done"),
    BriefTicketModel(2, "AR-2", "Research on List", "Test", "Done"),
    BriefTicketModel(3, "AR-3", "Research on Array", "Test", "Done")
  ];

  @override
  void initState() {
    super.initState();
    contents = [
      DragAndDropList(
        header: const Padding(
          padding: EdgeInsets.all(Utils.screenPadding),
          child: Text("To Do"),
        ),
        footer: ListTile(
          contentPadding: const EdgeInsets.only(left: Utils.screenPadding),
          title: const Text("Create ticket"),
          leading: const Icon(Icons.add, color: Colors.black),
          horizontalTitleGap: 0,
          onTap: () => Navigator.pushNamed(
            context,
            CreateTicket.routeName,
            arguments: "To Do",
          ),
        ),
        children: <DragAndDropItem>[
          DragAndDropItem(child: BriefTicket(briefTicketsTodo.elementAt(0))),
          DragAndDropItem(child: BriefTicket(briefTicketsTodo.elementAt(1))),
          DragAndDropItem(child: BriefTicket(briefTicketsTodo.elementAt(2))),
        ],
      ),
      DragAndDropList(
        header: const Padding(
          padding: EdgeInsets.all(Utils.screenPadding),
          child: Text("In Progress"),
        ),
        footer: ListTile(
          contentPadding: const EdgeInsets.only(left: Utils.screenPadding),
          title: const Text("Create ticket"),
          leading: const Icon(Icons.add, color: Colors.black),
          horizontalTitleGap: 0,
          onTap: () => Navigator.pushNamed(
            context,
            CreateTicket.routeName,
            arguments: "In Progress",
          ),
        ),
        children: <DragAndDropItem>[
          DragAndDropItem(
              child: BriefTicket(briefTicketsInProgress.elementAt(0))),
          DragAndDropItem(
              child: BriefTicket(briefTicketsInProgress.elementAt(1))),
          DragAndDropItem(
              child: BriefTicket(briefTicketsInProgress.elementAt(2))),
        ],
      ),
      DragAndDropList(
        header: const Padding(
          padding: EdgeInsets.all(Utils.screenPadding),
          child: Text("Done"),
        ),
        footer: ListTile(
          contentPadding: const EdgeInsets.only(left: Utils.screenPadding),
          title: const Text("Create ticket"),
          leading: const Icon(Icons.add, color: Colors.black),
          horizontalTitleGap: 0,
          onTap: () => Navigator.pushNamed(
            context,
            CreateTicket.routeName,
            arguments: "Done",
          ),
        ),
        children: <DragAndDropItem>[
          DragAndDropItem(
              child: BriefTicket(briefTicketsCompleted.elementAt(0))),
          DragAndDropItem(
              child: BriefTicket(briefTicketsCompleted.elementAt(1))),
          DragAndDropItem(
              child: BriefTicket(briefTicketsCompleted.elementAt(2))),
        ],
      ),
    ];
  }

  void onItemReorder(
    int oldItemIndex,
    int oldListIndex,
    int newItemIndex,
    int newListIndex,
  ) {
    setState(() {
      var movedItem = contents[oldListIndex].children.removeAt(oldItemIndex);
      contents[newListIndex].children.insert(newItemIndex, movedItem);
    });
  }

  void onListReorder(int oldListIndex, int newListIndex) {
    setState(() {
      var movedList = contents.removeAt(oldListIndex);
      contents.insert(newListIndex, movedList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: DragAndDropLists(
          children: contents,
          axis: Axis.horizontal,
          listWidth: Utils.ticketWidth + 10,
          listDecoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: const BorderRadius.all(Radius.circular(7.0)),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Colors.black45,
                spreadRadius: 3.0,
                blurRadius: 6.0,
                offset: Offset(2, 3),
              ),
            ],
          ),
          listPadding: const EdgeInsets.only(left: 8.0),
          lastListTargetSize: 0.0,
          lastItemTargetHeight: 0.0,
          verticalAlignment: CrossAxisAlignment.center,
          onItemReorder: onItemReorder,
          onListReorder: onListReorder,
        ),
      ),
    );
  }
}
