import 'package:custom_pc/providers/search_parameter.dart';
import 'package:custom_pc/providers/searching_category.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/parts_detail_parser.dart';
import '../domain/parts_list_parser.dart';
import '../domain/url_builder.dart';
import '../models/pc_parts.dart';
import '../widgets/parts_list_page/parts_search_app_bar.dart';

part 'gen/parts_list.g.dart';

@Riverpod(keepAlive: true)
class PartsList extends _$PartsList {
  @override
  Future<List<PcParts>> build() {
    final searchingCategory = ref.watch(searchingCategoryProvider);
    final searchParameter = ref.watch(searchParameterNotifierProvider);
    final searchText = ref.watch(searchTextProvider);

    final selectedParams = searchParameter![searchingCategory]!.selectedParameters();
    final url = UrlBuilder.createURLWithParameters(
      searchingCategory.basePartsListUrl(),
      selectedParams,
    );

    if (searchText == '') return PartsListParser.fetch(url);
    if (selectedParams.isNotEmpty) {
      return PartsListParser.fetch('$url&pdf_kw=$searchText');
    } else {
      return PartsListParser.fetch('$url?pdf_kw=$searchText');
    }
  }

  Future<void> updateDetailPartsInfo(int index, PcParts parts) async {
    if (parts.fullScaleImages != null) return;
    final updatedParts = await PartsDetailParser.fetch(parts);

    state.when(
      data: (data) async {
        data[index] = updatedParts;
        state = AsyncValue.data(data);
      },
      error: (e, t) {},
      loading: () {},
    );
  }
}
