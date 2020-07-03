import '../service/injectable.dart';

abstract class SevnResource with SevnInjectable {

  Future<Map<String, dynamic>> $delete(String id);

  Future<Map<String, dynamic>> $get(
          [String id = '', Map<String, dynamic> params]);

  Future<List<Map<String, dynamic>>> $list(
      [Map<String, dynamic> params]);

  Future<Map<String, dynamic>> $save(Map<String, dynamic> body,
      [Map<String, dynamic> params]);

  Future<Map<String, dynamic>> $update(String id, Map<String, dynamic> body,
      [Map<String, dynamic> params]);
}
 