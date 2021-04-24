//
//  TabBarC.swift
//  Chaoli
//
//  Created by 潘涛 on 2021/4/16.
//

import UIKit
import YPImagePicker

class TabBarC: UITabBarController, UITabBarControllerDelegate{
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    //给tabbaritem设置动画
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let barButtonView = item.value(forKey: "view") as? UIView else { return }
        
        let animationLength: TimeInterval = 0.4
        let propertyAnimator = UIViewPropertyAnimator(duration: animationLength, dampingRatio: 0.5) {
            barButtonView.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
        }
        propertyAnimator.addAnimations({ barButtonView.transform = .identity }, delayFactor: CGFloat(animationLength))
        propertyAnimator.startAnimation()
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is PostVC{
            //待做：判断用户是否登陆
            let sb = UIStoryboard(name: "Main", bundle:nil)
            let vc = sb.instantiateViewController(withIdentifier: "NoteVCID") as! NoteVC
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            return false
        }
        return true
    }

}
