import 'package:custom_pc/models/category_search_parameter.dart';

class PowerUnitSearchParameter extends CategorySearchParameter {
  final List<PartsSearchParameter> supportTypes;
  final List<PartsSearchParameter> powerSupplyCapacitys;

  PowerUnitSearchParameter(this.supportTypes, this.powerSupplyCapacitys);

  @override
  List<Map<String, List<PartsSearchParameter>>> alignParameters() {
    return [
      {'対応\n規格': supportTypes},
      {'電源\n容量': powerSupplyCapacitys},
    ];
  }

  @override
  CategorySearchParameter clearSelectedParameter() {
    final List<PartsSearchParameter> clearSupportTypes = [];
    for (var element in supportTypes) {
      element.isSelect = false;
      clearSupportTypes.add(element);
    }
    final List<PartsSearchParameter> clearPowerSupplyCapacitys = [];
    for (var element in powerSupplyCapacitys) {
      element.isSelect = false;
      clearPowerSupplyCapacitys.add(element);
    }

    return PowerUnitSearchParameter(clearSupportTypes, clearPowerSupplyCapacitys);
  }

  @override
  List<String> selectedParameters() {
    List<String> params = [];
    for (var element in supportTypes) {
      if (element.isSelect) {
        params.add(element.parameter);
      }
    }
    for (var element in powerSupplyCapacitys) {
      if (element.isSelect) {
        params.add(element.parameter);
      }
    }
    return params;
  }

  @override
  String standardPage() {
    return 'https://kakaku.com/pc/power-supply/itemlist.aspx';
  }

  @override
  CategorySearchParameter toggleParameterSelect(String paramName, int index) {
    switch (paramName) {
      case '対応\n規格':
        var toggleSupportTypes = supportTypes;
        toggleSupportTypes[index].isSelect = !toggleSupportTypes[index].isSelect;
        return PowerUnitSearchParameter(toggleSupportTypes, powerSupplyCapacitys);
      case '電源\n容量':
        var togglePowerSupplyCapacitys = powerSupplyCapacitys;
        togglePowerSupplyCapacitys[index].isSelect = !togglePowerSupplyCapacitys[index].isSelect;
        return PowerUnitSearchParameter(supportTypes, togglePowerSupplyCapacitys);
      default:
        return this;
    }
  }
}