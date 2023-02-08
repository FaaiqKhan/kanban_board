import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kanban_board/models/brief_ticket_model.dart';
import 'package:kanban_board/screens/create_ticket.dart';
import 'package:kanban_board/utils/utils.dart';
import 'package:kanban_board/widgets/brief_ticket.dart';
import 'package:kanban_board/widgets/feedback.dart';
import 'package:kanban_board/widgets/ticket_holder_footer.dart';
import 'package:kanban_board/widgets/ticket_holder_header.dart';

class TicketStates extends ChangeNotifier {
  bool isLoading = true;

  List<DragAndDropList> contents = [];

  final Map<String, List<BriefTicketModel>> _map = {
    Utils.statusToDo: [],
    Utils.statusInProgress: [],
    Utils.statusDone: []
  };

  final BuildContext _context;

  TicketStates(this._context);

  void createContentAndUpdate(
    List<BriefTicketModel>? todo,
    List<BriefTicketModel>? inProgress,
    List<BriefTicketModel>? done,
  ) {
    _updateAll(todo, inProgress, done);
    _createContentData();

    isLoading = false;
    notifyListeners();
  }

  void _updateAll(
    List<BriefTicketModel>? todo,
    List<BriefTicketModel>? inProgress,
    List<BriefTicketModel>? done,
  ) {
    if (todo != null) _map[Utils.statusToDo] = List.from(todo);
    if (inProgress != null) {
      _map[Utils.statusInProgress] = List.from(inProgress);
    }
    if (done != null) _map[Utils.statusDone] = List.from(done);
  }

  void _createContentData({bool notify = false}) {
    List<DragAndDropItem> todoItems = [];
    List<DragAndDropItem> inProgressItems = [];
    List<DragAndDropItem> doneItems = [];

    var todo = _map[Utils.statusToDo]!;
    var inProgress = _map[Utils.statusInProgress]!;
    var done = _map[Utils.statusDone]!;

    for (var element in todo) {
      todoItems.add(
        DragAndDropItem(
          child: BriefTicket(element, key: UniqueKey()),
          feedbackWidget: FeedBack(BriefTicket(element, key: UniqueKey())),
        ),
      );
    }
    for (var element in inProgress) {
      inProgressItems.add(
        DragAndDropItem(
          child: BriefTicket(element, key: UniqueKey()),
          feedbackWidget: FeedBack(BriefTicket(element, key: UniqueKey())),
        ),
      );
    }
    for (var element in done) {
      doneItems.add(
        DragAndDropItem(
          child: BriefTicket(element, key: UniqueKey()),
          feedbackWidget: FeedBack(BriefTicket(element, key: UniqueKey())),
        ),
      );
    }

    _populateContent(todoItems, inProgressItems, doneItems);

    if (notify) notifyListeners();
  }

  void _populateContent(
    List<DragAndDropItem> todo,
    List<DragAndDropItem> inProgress,
    List<DragAndDropItem> done,
  ) {
    contents = [
      DragAndDropList(
        canDrag: false,
        header: const TicketHolderHeader(
          "To Do",
          icon: Icon(Icons.calendar_today_rounded),
        ),
        footer: TicketHolderFooter(() {
          Navigator.pushNamed(
            _context,
            CreateTicket.routeName,
            arguments: Utils.statusToDo,
          ).then((value) {
            if (value == null) return;
            _addTicket(value as BriefTicketModel);
          });
        }),
        contentsWhenEmpty: const SizedBox.shrink(),
        children: todo,
      ),
      DragAndDropList(
        canDrag: false,
        header: const TicketHolderHeader(
          "In Progress",
          icon: Icon(Icons.timer),
        ),
        footer: TicketHolderFooter(() {
          Navigator.pushNamed(
            _context,
            CreateTicket.routeName,
            arguments: Utils.statusInProgress,
          ).then((value) {
            if (value == null) return;
            _addTicket(value as BriefTicketModel);
          });
        }),
        contentsWhenEmpty: const SizedBox.shrink(),
        children: inProgress,
      ),
      DragAndDropList(
        canDrag: false,
        header: const TicketHolderHeader("Done", icon: Icon(Icons.done)),
        footer: TicketHolderFooter(() {
          Navigator.pushNamed(
            _context,
            CreateTicket.routeName,
            arguments: Utils.statusDone,
          ).then((value) {
            if (value == null) return;
            _addTicket(value as BriefTicketModel);
          });
        }),
        contentsWhenEmpty: const SizedBox.shrink(),
        children: done,
      ),
    ];
  }

  String _getStatusByIndex(int index) {
    if (index == 0) {
      return Utils.statusToDo;
    } else if (index == 1) {
      return Utils.statusInProgress;
    } else {
      return Utils.statusDone;
    }
  }

  void onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    var movedItem = contents[oldListIndex].children.removeAt(oldItemIndex);
    String oldStatus = _getStatusByIndex(oldListIndex);
    String newStatus = _getStatusByIndex(newListIndex);
    var ele = _map[oldStatus]!.removeAt(oldItemIndex);
    _map[newStatus]!.insert(newItemIndex, ele);
    contents[newListIndex].children.insert(newItemIndex, movedItem);
    notifyListeners();
  }

  void onListReorder(int oldListIndex, int newListIndex) {
    var movedList = contents.removeAt(oldListIndex);
    contents.insert(newListIndex, movedList);
    notifyListeners();
  }

  void _addTicket(BriefTicketModel model) {
    int index = 0;
    if (model.status == Utils.statusInProgress) {
      index = 1;
    } else if (model.status == Utils.statusDone) {
      index = 2;
    }
    _map[model.status]!.add(model);
    contents[index]
        .children
        .add(DragAndDropItem(child: BriefTicket(model, key: UniqueKey())));
    notifyListeners();
  }

  int _getIndex(String status) {
    int parentIndex = 0;
    if (status == Utils.statusInProgress) {
      parentIndex = 1;
    } else if (status == Utils.statusDone) {
      parentIndex = 2;
    }
    return parentIndex;
  }

  void updateTicket(BriefTicketModel model, String parentStatus) async {
    Box<BriefTicketModel> box;
    int currentIndex = _getIndex(model.status);

    if (Hive.isBoxOpen(parentStatus)) {
      box = Hive.box<BriefTicketModel>(parentStatus);
    } else {
      box = await Hive.openBox<BriefTicketModel>(parentStatus);
    }

    if (model.status == parentStatus) {
      await box.putAt(model.index, model);
      _map[parentStatus]![model.index] = model;
      contents[currentIndex].children[model.index] = DragAndDropItem(
        child: BriefTicket(model, key: UniqueKey()),
      );
      notifyListeners();
    } else {
      _map[parentStatus]!.removeAt(model.index);
      model = model..index = _map[model.status]!.length;
      _map[model.status]!.add(model);
      _createContentData(notify: true);
    }
  }
}
