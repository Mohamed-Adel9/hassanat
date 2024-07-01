import 'package:flutter/material.dart';

class MySeparator extends StatelessWidget {
  const MySeparator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade400,
    );
  }
}
