//
//  Extensions.swift
//  Chaoli
//
//  Created by 潘涛 on 2021/4/17.
//

import UIKit

extension UITextField{
    var unwrappedText: String{ text ?? ""}
}

extension UIView{
    @IBInspectable
    var radius: CGFloat{
        get{
            self.layer.cornerRadius
        }
        set{
            self.layer.cornerRadius = newValue
        }
    }
}

//extension UIColor {
//    public convenience init?(hex: String) {
//        let r, g, b, a: CGFloat
//
//        if hex.hasPrefix("#") {
//            let start = hex.index(hex.startIndex, offsetBy: 1)
//            let hexColor = String(hex[start...])
//
//            if hexColor.count == 8 {
//                let scanner = Scanner(string: hexColor)
//                var hexNumber: UInt64 = 0
//
//                if scanner.scanHexInt64(&hexNumber) {
//                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
//                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
//                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
//                    a = CGFloat(hexNumber & 0x000000ff) / 255
//
//                    self.init(red: r, green: g, blue: b, alpha: a)
//                    return
//                }
//            }
//        }
//
//        return nil
//    }
//}

extension UIViewController{
    //提示框，自动消失
    func showTextHud(_ title: String, _ subtitle: String? = nil){
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .text
        hud.label.text = title
        hud.detailsLabel.text = subtitle
        hud.hide(animated: true, afterDelay: 2)
    }
    
    //点击空白处收起键盘
    func hideKeyboardWhenTappingAround(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false //!!!不要覆盖其它控件的交互！
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard( ){
        view.endEditing(true)
    }
}

