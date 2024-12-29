
import 'dart:convert';

Review reviewFromJson(String str) => Review.fromJson(json.decode(str));

String reviewToJson(Review data) => json.encode(data.toJson());

class Review {
    List<ReviewDatum> data;
    String message;

    Review({
        required this.data,
        required this.message,
    });

    factory Review.fromJson(Map<String, dynamic> json) => Review(
        data: List<ReviewDatum>.from(json["data"].map((x) => ReviewDatum.fromJson(x))),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
    };
}

class ReviewDatum {
    String id;
    int productId;
    ReviewClass review;

    ReviewDatum({
        required this.id,
        required this.productId,
        required this.review,
    });

    factory ReviewDatum.fromJson(Map<String, dynamic> json) => ReviewDatum(
        id: json["_id"],
        productId: json["product_id"],
        review: ReviewClass.fromJson(json["review"]),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "product_id": productId,
        "review": review.toJson(),
    };
}

class ReviewClass {
    String comment;
    int ratings;

    ReviewClass({
        required this.comment,
        required this.ratings,
    });

    factory ReviewClass.fromJson(Map<String, dynamic> json) => ReviewClass(
        comment: json["comment"],
        ratings: json["ratings"],
    );

    Map<String, dynamic> toJson() => {
        "comment": comment,
        "ratings": ratings,
    };
}