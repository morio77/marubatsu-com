import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marubatsu_com/view_models/home_page_model.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  static const rootName = '/home';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomePageModel>(
      create: (_) => HomePageModel(),
      child: Consumer<HomePageModel>(
        builder: (context, model, _) {
          return Scaffold(
            appBar: AppBar(
              title: Text('マルバツ対戦（COM）'),
              centerTitle: true,
            ),
            body: Center(
              child: Text(model.ownCellType.toString()),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => model.reverseOwnCellType(),
              child: Icon(Icons.swap_calls),
            ),
          );
        },
      ),
    );
  }
}