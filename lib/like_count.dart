import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'like_count.g.dart';

@HiveType(typeId: 1)
class LikeCount {
  @HiveField(0)
  int likeCount;
  LikeCount({required this.likeCount});
}