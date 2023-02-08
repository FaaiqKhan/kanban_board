import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kanban_board/adapters/brief_ticket_model_adapter.dart';

import 'package:kanban_board/screens/create_ticket.dart';
import 'package:kanban_board/states/ticket_states.dart';
import 'package:kanban_board/utils/utils.dart';
import 'package:kanban_board/screens/view_ticket.dart';
import 'package:provider/provider.dart';

import 'models/brief_ticket_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(BriefTicketModelAdapter());
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontFamily: 'Lato-Bold',
            color: Colors.black,
            overflow: TextOverflow.ellipsis,
            fontSize: 24,
          ),
          titleMedium: TextStyle(
            fontFamily: 'Lato-Bold',
            color: Colors.black,
            overflow: TextOverflow.ellipsis,
            fontSize: 18,
          ),
          titleSmall: TextStyle(
            fontFamily: 'Lato-Bold',
            color: Colors.black,
            overflow: TextOverflow.ellipsis,
            fontSize: 16,
          ),
          bodyLarge: TextStyle(
            fontFamily: 'Lato-Bold',
            color: Colors.black,
            overflow: TextOverflow.ellipsis,
            fontSize: 14,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Lato-Regular',
            color: Colors.black,
            overflow: TextOverflow.ellipsis,
            fontSize: 14,
          ),
        ),
      ),
      home: ChangeNotifierProvider(
        create: (context) => TicketStates(context),
        child: const Home(),
      ),
      routes: {
        Ticket.routeName: (ctx) => const Ticket(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<Map<String, List<BriefTicketModel>>>(
          future: getData(),
          builder: (ctx, snapShot) {
            // To mimic the api call to show loader
            Future.delayed(const Duration(seconds: 2), () {
              Provider.of<TicketStates>(
                context,
                listen: false,
              ).createContentAndUpdate(
                snapShot.data?[Utils.statusToDo],
                snapShot.data?[Utils.statusInProgress],
                snapShot.data?[Utils.statusDone],
              );
            });
            return Visibility(
              visible: snapShot.connectionState == ConnectionState.done,
              child: const MyApp(),
              replacement: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<TicketStates>(
          builder: (_, state, child) {
            return Visibility(
              visible: state.isLoading,
              child: child!,
              replacement: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(Utils.screenPadding),
                    child: Row(
                      children: [
                        const SizedBox(width: Utils.screenPadding * 2),
                        Text("Kanban", style: Theme.of(context).textTheme.titleLarge),
                        // const SizedBox(width: Utils.screenPadding * 2),
                        // Text("Project name", style: Theme.of(context).textTheme.titleMedium)
                      ],
                    ),
                  ),
                  Expanded(
                    child: DragAndDropLists(
                      children: state.contents,
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
                      listPadding: const EdgeInsets.only(left: 8.0, top: Utils.screenPadding),
                      lastListTargetSize: 0.0,
                      lastItemTargetHeight: 0.0,
                      verticalAlignment: CrossAxisAlignment.center,
                      onItemReorder: state.onItemReorder,
                      onListReorder: state.onListReorder,
                    ),
                  )
                ],
              ),
            );
          },
          child: const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
