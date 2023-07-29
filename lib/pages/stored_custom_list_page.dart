import 'package:custom_pc/config/size_config.dart';
import 'package:custom_pc/widgets/stored_custom_list/new_custom_bottom_bar.dart';
import 'package:custom_pc/widgets/stored_custom_list/sort_icon_button.dart';
import 'package:custom_pc/widgets/stored_custom_list/stored_customs_table_widget.dart';
import 'package:flutter/material.dart';

class StoredCustomListPage extends StatelessWidget {
  const StoredCustomListPage({super.key});

  @override
  Widget build(BuildContext context) {
    const mainColor = Color.fromRGBO(60, 130, 80, 1);
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'ライブラリ',
              style: TextStyle(
                fontSize: 24,
                color: mainColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '保存済みカスタム',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
        centerTitle: true,
        elevation: 0,
        leading: SortIconButton(),
      ),
      body: const Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: StoredCustomsListWidget(),
      ),
      bottomNavigationBar: const NewCustomBottomBar(),
    );
  }
}
