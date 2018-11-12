//
//  XCGestureSettingVC.swift
//  手势密码-有箭头指示
//
//  Created by 小崔 on 2018/11/12.
//  Copyright © 2018年 小崔. All rights reserved.
//

import UIKit

class XCGestureSettingVC: UIViewController {

    let infoView = XCGesturesInfoView()
    let lockView = XCGesturesLockView()
    var firstSelectedValue = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weak var weakSelf = self
        lockView.gestureBlock = {(seletedArray, selectedValue) in
            weakSelf?.handleGesture(selectedArray: seletedArray, selectedValue: selectedValue)
        }
        self.view.backgroundColor = MybackgroundColor
        self.infoView.frame = CGRect(x: self.view.bounds.size.width/2-50, y: 30, width: 100, height: 100)
        self.lockView.frame = CGRect(x:0, y: 150, width: self.view.bounds.width, height: self.view.bounds.height - 150)
        
        self.view.addSubview(self.infoView)
        self.view.addSubview(self.lockView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    func handleGesture(selectedArray:[XCTheCircleView],selectedValue:String) ->(){
        print("selectedValue->\(selectedValue)")
        if selectedValue.count < circleLeastNumber{
            print("输入点数过少")
        }else if self.firstSelectedValue.count < circleLeastNumber{
            self.firstSelectedValue = selectedValue
            self.infoView.changeCirclesWithSelectedArray(selectedArray: selectedArray)
        }else if selectedValue == self.firstSelectedValue {
            
        }else {
            self.firstSelectedValue = ""
            self.infoView .changeCirclesWithSelectedArray(selectedArray: [XCTheCircleView]())
        }
    }

   

}
