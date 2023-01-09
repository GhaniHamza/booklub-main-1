import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final double rating;
  StarRating({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          Icons.star,
          color: rating >= 1
              ? Color.fromARGB(255, 64, 165, 76)
              : Color(0xffBDC3C7),
          size: 18,
        ),
        Icon(
          Icons.star,
          color: rating >= 2
              ? Color.fromARGB(255, 64, 165, 76)
              : Color(0xffBDC3C7),
          size: 18,
        ),
        Icon(
          Icons.star,
          color: rating >= 3
              ? Color.fromARGB(255, 64, 165, 76)
              : Color(0xffBDC3C7),
          size: 18,
        ),
        Icon(
          Icons.star,
          color: rating >= 4
              ? Color.fromARGB(255, 64, 165, 76)
              : Color(0xffBDC3C7),
          size: 18,
        ),
        Icon(
          Icons.star,
          color: rating == 5
              ? Color.fromARGB(255, 64, 165, 76)
              : Color(0xffBDC3C7),
          size: 18,
        )
      ],
    );
  }
}
