//
//  XCGesturesInfoView.swift
//  手势密码-有箭头指示
//
//  Created by 小崔 on 2018/11/9.
//  Copyright © 2018年 小崔. All rights reserved.
//

import UIKit

class XCGesturesInfoView: UIView {
  
    
   
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = MybackgroundColor
        for i in 0..<9 {
            let  circle:XCTheCircleView  = XCTheCircleView()
            circle.type = XCTheCircleViewType.XCTheCircleViewTypeInfo
            circle.tag = i+1;
            self.addSubview(circle)
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let itemViewWH:CGFloat = circleInfoRadius * 2
        let itemMargin:CGFloat = (self.bounds.size.width - 3*itemViewWH) / 3
        //九宫格
        for (index,circle) in self.subviews.enumerated() {
            let row:CGFloat = CGFloat(index % 3)
            let col:CGFloat = CGFloat(index / 3)
            let x = itemMargin*row + row*itemViewWH + itemMargin/2
            let y = itemMargin*col + col*itemViewWH + itemMargin/2
            circle.tag = index + 1
            circle.frame = CGRect(x: x, y: y, width: itemViewWH, height: itemViewWH)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func changeCirclesWithSelectedArray(selectedArray:[XCTheCircleView])->(){
        if selectedArray.count > 0 {
            for (_,circle) in self.subviews.enumerated(){
                (circle as! XCTheCircleView).state = XCTheCircleViewState.XCTheCircleViewStateNormal
            }
        }
        for selectedCircle in selectedArray {
            for infoCircle in self.subviews {
                if infoCircle.tag == selectedCircle.tag{
                    (infoCircle as! XCTheCircleView).state = XCTheCircleViewState.XCTheCircleViewStateSelected
                }
            }
        }
    }

}












