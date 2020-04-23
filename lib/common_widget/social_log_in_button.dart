import 'package:flutter/material.dart';

class SocailLoginButton extends StatelessWidget {
  final String butonText;
  final Color butonColor;
  final Color textColor;
  final double radius;
  final double yukseklik;
  final Widget butonIcon;
  final VoidCallback onPressed;

  const SocailLoginButton(
      {Key key,
      @required this.butonText,
      this.butonColor : Colors.purple,
      this.textColor : Colors.white,
      this.radius : 16, //bu şekilde varsayılan değer atıyorsun kullanıcı da değer girebilir
      this.yukseklik : 40,
      this.butonIcon,
      @required this.onPressed})
      : assert(butonText != null, onPressed != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: SizedBox(
        height: yukseklik,
        child: RaisedButton(
          onPressed: onPressed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              if(butonIcon != null) ...[
                butonIcon,
                Text(
                  butonText,
                  style: TextStyle(color: textColor),
                ),
                Opacity(opacity:0, child: butonIcon),
              ],
              if(butonIcon == null)...[
                Container(),
                Text(
                  butonText,
                  style: TextStyle(color: textColor),
                ),
                Container(),
              ],
            ],
          ),
          color: butonColor,
        ),
      ),
    );
  }
}

/*
              butonIcon != null ? butonIcon : Container(),
              Text(
                butonText,
                style: TextStyle(color: textColor),
              ),
              butonIcon != null ? Opacity(opacity:0, child: butonIcon) : Container(),
*/