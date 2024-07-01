import 'package:flutter/material.dart';

class DrawerItemBuilder extends StatelessWidget {
  const DrawerItemBuilder({
    super.key, required this.title, required this.icon,required this.onPressed
  });

  final String title ;
  final IconData icon ;
  final VoidCallback ? onPressed ;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: onPressed ,
            child:  Text(
              title,
              style:
              const TextStyle(fontWeight: FontWeight.w700, fontSize: 20,color: Colors.black),
            ),
          ),
          Icon(icon,size: 30,color: Colors.brown.shade600,),
        ],
      ),
    );
  }
}
