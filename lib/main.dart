import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kanban_board/adapters/BriefTicketModelAdapter.dart';

import 'package:kanban_board/screens/create_ticket.dart';
import 'package:kanban_board/utils/utils.dart';
import 'package:kanban_board/screens/view_ticket.dart';
import 'package:kanban_board/widgets/ticket_holder_footer.dart';
import 'package:kanban_board/widgets/ticket_holder_header.dart';

import 'models/brief_ticket_model.dart';
import 'widgets/brief_ticket.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(BriefTicketModelAdapter());
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
      routes: {
        BriefTicket.routeName: (ctx) => const Ticket(),
        CreateTicket.routeName: (ctx) => const CreateTicket(),
      },
    ),
  );
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  Future<Map<String, List<BriefTicketModel>>> getData() async {
    var todoBox = await Hive.openBox<BriefTicketModel>(Utils.statusToDo);
    var inProgressBox =
        await Hive.openBox<BriefTicketModel>(Utils.statusInProgress);
    var doneBox = await Hive.openBox<BriefTicketModel>(Utils.statusDone);

    List<BriefTicketModel> todoTickets = todoBox.values.toList();
    List<BriefTicketModel> inProgressTickets = inProgressBox.values.toList();
    List<BriefTicketModel> doneTickets = doneBox.values.toList();

    return {
      Utils.statusToDo: todoTickets,
      Utils.statusInProgress: inProgressTickets,
      Utils.statusDone: doneTickets
    };
  }

  Widget feedbackView(Widget child) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 3,
          color: Colors.blueAccent,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<Map<String, List<BriefTicketModel>>>(
          future: getData(),
          builder: (ctx, snapShot) {
            List<DragAndDropItem> todoItems = [];
            List<DragAndDropItem> inProgressItems = [];
            List<DragAndDropItem> doneItems = [];
            snapShot.data?.forEach((key, value) {
              switch (key) {
                case Utils.statusToDo:
                  for (var val in value) {
                    todoItems.add(
                      DragAndDropItem(
                        child: BriefTicket(val, key: UniqueKey()),
                        feedbackWidget: feedbackView(BriefTicket(val)),
                      ),
                    );
                  }
                  break;
                case Utils.statusInProgress:
                  for (var val in value) {
                    inProgressItems.add(
                      DragAndDropItem(
                        child: BriefTicket(val, key: UniqueKey()),
                        feedbackWidget: feedbackView(BriefTicket(val)),
                      ),
                    );
                  }
                  break;
                case Utils.statusDone:
                  for (var val in value) {
                    doneItems.add(
                      DragAndDropItem(
                        child: BriefTicket(val, key: UniqueKey()),
                        feedbackWidget: feedbackView(BriefTicket(val)),
                      ),
                    );
                  }
                  break;
              }
            });
            return Visibility(
              visible: snapShot.connectionState == ConnectionState.done,
              child: MyApp(
                todoItems: todoItems,
                inProgressItems: inProgressItems,
                doneItems: doneItems,
              ),
              replacement: const CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  final List<DragAndDropItem> todoItems;
  final List<DragAndDropItem> inProgressItems;
  final List<DragAndDropItem> doneItems;

  const MyApp({
    required this.todoItems,
    required this.inProgressItems,
    required this.doneItems,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  List<DragAndDropList> contents = [];

  void addTicket(List<dynamic> value) {
    int index = 0;
    if (value.first == Utils.statusInProgress) {
      index = 1;
    } else if (value.first == Utils.statusDone) {
      index = 2;
    }
    setState(
      () => contents[index]
          .children
          .add(DragAndDropItem(child: BriefTicket(value.last))),
    );
  }

  @override
  void initState() {
    super.initState();
    contents = [
      DragAndDropList(
        canDrag: false,
        header: const TicketHolderHeader("To Do"),
        footer: TicketHolderFooter(
          () => Navigator.pushNamed(
            context,
            CreateTicket.routeName,
            arguments: Utils.statusToDo,
          ).then(
            (value) {
              if (value != null) {
                addTicket(value as List<dynamic>);
              }
            },
          ),
        ),
        contentsWhenEmpty: const SizedBox.shrink(),
        children: widget.todoItems,
      ),
      DragAndDropList(
        canDrag: false,
        header: const TicketHolderHeader("In Progress"),
        footer: TicketHolderFooter(
          () => Navigator.pushNamed(
            context,
            CreateTicket.routeName,
            arguments: Utils.statusInProgress,
          ).then(
            (value) {
              if (value != null) {
                addTicket(value as List<dynamic>);
              }
            },
          ),
        ),
        contentsWhenEmpty: const SizedBox.shrink(),
        children: widget.inProgressItems,
      ),
      DragAndDropList(
        canDrag: false,
        header: const TicketHolderHeader("Done"),
        footer: TicketHolderFooter(
          () => Navigator.pushNamed(
            context,
            CreateTicket.routeName,
            arguments: Utils.statusDone,
          ).then(
            (value) {
              if (value != null) {
                addTicket(value as List<dynamic>);
              }
            },
          ),
        ),
        contentsWhenEmpty: const SizedBox.shrink(),
        children: widget.doneItems,
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
