import 'package:hive/hive.dart';
part 'member.g.dart';

@HiveType(typeId: 1)
class Member {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;

  Member({required this.id, required this.name});
}
