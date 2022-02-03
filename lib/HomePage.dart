import 'package:flutter/material.dart';


class ToDo {
  const ToDo({required this.name});

  final String name;
}

typedef ToDoListChangedCallback = Function(ToDo toDo, bool inList);

class ToDoListItem extends StatelessWidget {
  ToDoListItem({
    required this.toDo,
    required this.inList,
    required this.onListChanged,
  }) : super(key: ObjectKey(toDo));

  final ToDo toDo;
  final bool inList;
  final ToDoListChangedCallback onListChanged;

  Color _getColor(BuildContext context) {
    // The theme depends on the BuildContext because different
    // parts of the tree can have different themes.
    // The BuildContext indicates where the build is
    // taking place and therefore which theme to use.

    return inList //
        ? Colors.black54
        : Theme
        .of(context)
        .primaryColor;
  }

  TextStyle? _getTextStyle(BuildContext context) {
    if (!inList) return null;

    return const TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onListChanged(toDo, inList);
      },
      leading: CircleAvatar(
        backgroundColor: _getColor(context),
        child: Text(toDo.name[0]),

      ),
      title: Text(toDo.name, style: _getTextStyle(context)),
    );
  }
}

class HomePage extends StatelessWidget {


    @override
  Widget build(BuildContext context) {
      return Scaffold(
          appBar : AppBar(
            title: Text ("To Do List"),
            backgroundColor: Colors.green[700],
            centerTitle: true,
          ),
          body: Container (
            child : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children:[
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                        itemCount: 10,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => Container(
                          height: 100,
                          width: 100,
                          margin: EdgeInsets.all(10),
                          child: Center(
                            child: Text("Column $index"),
                          ),
                          color: Colors.green[100],
                        ),
                    ),
                  ),
                  Flexible(
                    child: ListView.builder(
                      itemCount: 15,
                      physics : NeverScrollableScrollPhysics(),
                      shrinkWrap : true,
                      itemBuilder: (context, index)=> ListTile(
                        title : Text("Row $index"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      );
  }
}



class ToDoList extends StatefulWidget {
  const ToDoList({required this.toDos, Key? key}) : super(key: key);

  final List<ToDo> toDos;

  // The framework calls createState the first time
  // a widget appears at a given location in the tree.
  // If the parent rebuilds and uses the same type of
  // widget (with the same key), the framework re-uses
  // the State object instead of creating a new State object.

  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  final _toDoList = <ToDo>{};

  void _handleCartChanged(ToDo todo, bool inCart) {
    setState(() {
      // When a user changes what's in the cart, you need
      // to change _shoppingCart inside a setState call to
      // trigger a rebuild.
      // The framework then calls build, below,
      // which updates the visual appearance of the app.

      if (!inCart) {
        _toDoList.add(todo);
      } else {
        _toDoList.remove(todo);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        children: widget.toDos.map((ToDo toDo) {
          return ToDoListItem(
            toDo: toDo,
            inList: _toDoList.contains(toDo),
            onListChanged: _handleCartChanged,
          );
        }).toList(),
      ),
    );
  }
}