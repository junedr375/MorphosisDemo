import 'dart:convert';

import 'package:hive/hive.dart';
part 'photo.g.dart';

List<Photo> photoFromJson(String str) =>
    List<Photo>.from(json.decode(str)['photos'].map((x) => Photo.fromJson(x)));

String photoToJson(List<Photo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@HiveType(typeId: 0)
class Photo {
  Photo({
    this.id,
    this.width,
    this.height,
    this.url,
    this.photographer,
    this.photographerUrl,
    this.photographerId,
    this.avgColor,
    this.src,
    this.liked,
  });
  @HiveField(0)
  int id;
  @HiveField(1)
  int width;
  @HiveField(2)
  int height;
  @HiveField(3)
  String url;
  @HiveField(4)
  String photographer;
  @HiveField(5)
  String photographerUrl;
  @HiveField(6)
  int photographerId;
  @HiveField(7)
  String avgColor;
  @HiveField(8)
  Src src;
  @HiveField(9)
  bool liked;

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
        id: json["id"],
        width: json["width"],
        height: json["height"],
        url: json["url"],
        photographer: json["photographer"],
        photographerUrl: json["photographer_url"],
        photographerId: json["photographer_id"],
        avgColor: json["avg_color"],
        src: Src.fromJson(json["src"]),
        liked: json["liked"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "width": width,
        "height": height,
        "url": url,
        "photographer": photographer,
        "photographer_url": photographerUrl,
        "photographer_id": photographerId,
        "avg_color": avgColor,
        "src": src?.toJson(),
        "liked": liked,
      };
}

@HiveType(typeId: 2)
class Src {
  Src({
    this.original,
    this.large2X,
    this.large,
    this.medium,
    this.small,
    this.portrait,
    this.landscape,
    this.tiny,
  });

  @HiveField(0)
  String original;
  @HiveField(1)
  String large2X;
  @HiveField(2)
  String large;
  @HiveField(3)
  String medium;
  @HiveField(4)
  String small;
  @HiveField(5)
  String portrait;
  @HiveField(6)
  String landscape;
  @HiveField(7)
  String tiny;

  factory Src.fromJson(Map<String, dynamic> json) => Src(
        original: json["original"],
        large2X: json["large2x"],
        large: json["large"],
        medium: json["medium"],
        small: json["small"],
        portrait: json["portrait"],
        landscape: json["landscape"],
        tiny: json["tiny"],
      );

  Map<String, dynamic> toJson() => {
        "original": original,
        "large2x": large2X,
        "large": large,
        "medium": medium,
        "small": small,
        "portrait": portrait,
        "landscape": landscape,
        "tiny": tiny,
      };
}
