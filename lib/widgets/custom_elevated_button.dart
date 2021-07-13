import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  final bool disabled;

  const CustomElevatedButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.disabled = false
    
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: disabled ? Colors.grey : Colors.blue, 
          onPrimary: Colors.white, 
          elevation: 2, 
          shape: StadiumBorder(),
        ),
        onPressed: disabled ? (){} : this.onPressed,
        child: Container(
          width: double.infinity,
          height: 55,
          child: Center(
            child: Text(
              this.text,
              style: TextStyle(color: Colors.white, fontSize: 17),
            ),
          ),
        )
      ),
    );
  }
}
