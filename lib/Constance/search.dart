import 'package:booklub/Constance/app_color.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  final String text;
  final ValueChanged<String> onChanged;
  final String hintText;

  const SearchWidget({
    Key? key,
    required this.text,
    required this.onChanged,
    required this.hintText,
  }) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const styleActive = TextStyle(color: Colors.black);
    const styleHint = TextStyle(color: Colors.black54);
    final style = widget.text.isEmpty ? styleHint : styleActive;
    return Padding(
      padding: const EdgeInsets.only(top: 23, left: 30, right: 30),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 52),
          hintText: "Search Books, Authors, or ISBN",
          hintStyle: const TextStyle(color: AppColor.lightGreyColor),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
          focusColor: AppColor.lightGreyColor.withOpacity(0.1),
          fillColor: AppColor.lightGreyColor.withOpacity(0.1),
          filled: true,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(100)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(100)),
        ),
        style: style,
        onChanged: widget.onChanged,
      ),
    );
  }
}
