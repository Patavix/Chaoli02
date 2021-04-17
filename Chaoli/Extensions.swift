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

