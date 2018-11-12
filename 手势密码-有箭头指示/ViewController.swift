//
//  ViewController.swift
//  手势密码-有箭头指示
//
//  Created by 小崔 on 2018/11/8.
//  Copyright © 2018年 小崔. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var btn:UIButton = {
        let abtn = UIButton()
        abtn.backgroundColor = UIColor.yellow
        abtn.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
        abtn.setTitleColor(UIColor.blue, for: .normal)
        abtn.setTitle("设置手势密码", for: .normal)
        abtn.addTarget(self, action: #selector(ViewController.gotoSettingGesture), for: .touchUpInside)
        return abtn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(btn)
    }
    
    @objc func gotoSettingGesture(){
        self.present(XCGestureSettingVC(), animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

