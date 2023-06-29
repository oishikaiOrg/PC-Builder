import 'package:clippy_flutter/arc.dart';
import 'package:custom_pc/config/size_config.dart';
import 'package:custom_pc/models/pc_parts.dart';
import 'package:custom_pc/providers/create_custom.dart';
import 'package:custom_pc/providers/searching_category.dart';
import 'package:custom_pc/widgets/parts_detail/shops_widget.dart';
import 'package:custom_pc/widgets/parts_detail/specs_widget.dart';
import 'package:custom_pc/widgets/parts_detail/star_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_segmented_control/material_segmented_control.dart';

import '../widgets/parts_detail/full_scale_image_slider.dart';

// 販売店 or 詳細スペック の表示状態 (デフォルトは 0)
final detailPageProvider = StateProvider<int>((ref) {
  return 0;
});

class PartsDetailPage extends ConsumerWidget {
  PartsDetailPage(this.parts, this.isEditing, {super.key});
  final PcParts parts;
  final bool isEditing;
  final Map<int, Widget> _children = {
    0: const Text('販売店'),
    1: const Text("　詳細スペック  　"),
  };

  final mainColor = const Color.fromRGBO(60, 130, 80, 1);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFEDECF2),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    size: 40,
                    color: mainColor,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: FullScaleImageSlider(parts.fullScaleImages!),
          ),
          Arc(
            edge: Edge.TOP,
            arcType: ArcType.CONVEY,
            height: 30,
            child: Container(
              width: double.infinity,
              color: const Color(0xFFEDECF2),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 50),
                      child: Text(
                        parts.maker,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: mainColor),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 16),
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              parts.title,
                              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: mainColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: StarWidget(45),
                        ),
                        const Expanded(child: SizedBox()),
                        Text(
                          parts.price.replaceFirst(' ～', ''),
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    SpecsWidgets(parts.specs!).generalSpecs(),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      alignment: Alignment.center,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEDECF2),
                      ),
                      child: MaterialSegmentedControl(
                        children: _children,
                        selectionIndex: ref.watch(detailPageProvider),
                        selectedColor: mainColor,
                        borderColor: mainColor,
                        borderWidth: 2,
                        selectedTextStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        unselectedTextStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        unselectedColor: Colors.grey,
                        onSegmentChosen: (index) {
                          ref.read(detailPageProvider.notifier).update((state) => index);
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    if (ref.watch(detailPageProvider) == 0) ShopsWidget(parts.shops!),
                    if (ref.watch(detailPageProvider) == 1) SpecsWidgets(parts.specs!),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: const EdgeInsets.only(top: 8, right: 20, left: 20),
          height: isEditing ? SizeConfig.blockSizeVertical * 8 : 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () async {
                  //await PcPartsRepository.insertPcParts(parts, 'custom');
                  final category = ref.read(searchingCategoryProvider);
                  ref.read(createCustomNotifierProvider.notifier).setParts(category, parts);
                  int count = 0;
                  ref.read(createCustomNotifierProvider.notifier).updateCompatibilities();
                  Navigator.popUntil(context, (_) => count++ >= 2);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  primary: const Color.fromRGBO(60, 130, 80, 1),
                ),
                child: Row(
                  children: const [
                    Spacer(),
                    Text(
                      "このパーツを選択する",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
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
