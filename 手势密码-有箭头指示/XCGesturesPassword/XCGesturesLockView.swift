//
//  XCGesturesLockView.swift
//  手势密码-有箭头指示
//
//  Created by 小崔 on 2018/11/9.
//  Copyright © 2018年 小崔. All rights reserved.
//

import UIKit
enum XCLockViewType:NSInteger {
    case XCLockViewTypeSetting = 1 // 设置手势密码
    case XCLockViewTypeLogin   = 2 // 登录手势密码
    case XCLockViewTypeVerify  = 3 // 验证手势密码
}
enum XCLockViewState:NSInteger {
    case XCLockViewStateLess         = 1   // 连线个数少于最小值(设置)
    case XCLockViewStateFirstFinish  = 2   // 提示再次绘制以确认(设置)
    case XCLockViewStateSecondFinish = 3   // 两次绘制一致可保存(设置)
    case XCLockViewStateSecondError  = 4   // 两次绘制路径不一致(设置)
    case XCLockViewStateLoginFinish  = 5   // 手势密码登录成功(登录)
    case XCLockViewStateLoginError   = 6   // 手势密码登录失败(登录)
    case XCLockViewStateVerifyFinish = 7   // 修改密码验证成功(验证)
    case XCLockViewStateVerifyError  = 8   // 修改密码验证失败(验证)
    
}
typealias GestureBlock = (_ seletedArray:[XCTheCircleView],_ selectedValue:String) -> ()

protocol XCLockViewDelegate {
    func lockView(lockView:XCGesturesLockView,state:XCLockViewState)
}

class XCGesturesLockView: UIView {

    var clip = true//是否剪辑
    var arrow = isArrow//是否有箭头
    var type:XCLockViewType?
    var delegate:XCLockViewDelegate?
    var currentPoint:CGPoint?
    var selectedArray = [XCTheCircleView]()
    let selectedCircleArray=[XCTheCircleView]()
    var iscleaned:Bool?
    var gestureBlock:GestureBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.lockViewPrepare()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initWithType(type:XCLockViewType,clip:Bool,arrow:Bool) {
//    [self lockViewPrepare];
//    self.type  = type;
//    self.clip  = clip;
//    self.arrow = arrow;
    }
    override func draw(_ rect: CGRect) {
       //没有任何选中则return
        if self.selectedArray.count > 0{
            let tempState = self.selectedArray.first?.state
            let linColor = tempState == XCTheCircleViewState.XCTheCircleViewStateError ? lineErrorColor:lineSelectedColor
            let ctx = UIGraphicsGetCurrentContext()
            ctx?.addRect(rect)
            for (_,circle) in self.subviews.enumerated(){
                ctx?.addEllipse(in: circle.frame)
            }
            ctx?.clip()
            for i in 0..<self.selectedArray.count{
                let circle = self.selectedArray[i]
                i==0 ? ctx?.move(to: CGPoint(x:circle.center.x,y:circle.center.y)) : ctx?.addLine(to: CGPoint(x:circle.center.x,y:circle.center.y))
            }
            // 连接最后一个按钮到手指当前触摸点
            if !(self.currentPoint?.equalTo(CGPoint.zero))!{
                for (_,_) in self.subviews.enumerated(){
                    if tempState == XCTheCircleViewState.XCTheCircleViewStateError{
                        //错误状态下不连接当前点
                    }else{
                        ctx?.addLine(to: CGPoint(x:(self.currentPoint?.x)!,y:(self.currentPoint?.y)!))
                    }
                }
            }
            ctx?.setLineCap(CGLineCap.round)
            ctx?.setLineJoin(CGLineJoin.round)
            ctx?.setLineWidth(lineWidth)
            linColor.set()
            ctx?.strokePath()
        }
    }
    func lockViewPrepare(){
        self.backgroundColor = MybackgroundColor
        for i in 0..<9{
            let circle = XCTheCircleView()
            circle.tag = i + 1;
            self.addSubview(circle)
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let itemViewWH = circleOutRadius * 2
        let itemMargin = (self.bounds.size.width - 3*itemViewWH)/3
        for (index,circle) in self.subviews.enumerated(){
            let row:CGFloat = CGFloat(index % 3)
            let col:CGFloat = CGFloat(index / 3);
            let x = itemMargin * row + row*itemViewWH + itemMargin/2
            let y = itemMargin*col + col*itemViewWH + itemMargin/2
            circle.tag = index + 1
            circle.frame = CGRect(x: x, y: y, width: itemViewWH, height: itemViewWH)
        }
    }
    
    //MARK:- touch began / touch moved / touch end
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.resetGesture()//清空手势
        self.currentPoint = CGPoint.zero
        let touch:UITouch = (((touches as NSSet).anyObject() as AnyObject) as! UITouch)
        let point = touch.location(in: self)
        for (_,circle) in self.subviews.enumerated() {
            if (circle.frame.contains(point)){
                (circle as! XCTheCircleView).state = XCTheCircleViewState.XCTheCircleViewStateSelected
                self.selectedArray.append(circle as! XCTheCircleView)
            }
        }
        self.selectedArray.last?.state = XCTheCircleViewState.XCTheCircleViewStateLastOneSelected
        self.setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.currentPoint = CGPoint.zero
        let touch = (((touches as NSSet).anyObject() as AnyObject) as! UITouch)
        let point = touch.location(in: self)
        for (_,circle) in self.subviews.enumerated() {
            if circle.frame.contains(point){
                if !(self.selectedArray.contains(circle as! XCTheCircleView)) {
                    (circle as! XCTheCircleView).state = XCTheCircleViewState.XCTheCircleViewStateSelected
                    self.selectedArray.append(circle as! XCTheCircleView)
                    //move过程中连线（包含跳跃连线的处理）
                    self.calculateAngleAndConnectJumpedCircle()
                }
            }else{
                self.currentPoint = point
            }
        }
        for (_,circle) in self.selectedArray.enumerated() {
            circle.state = XCTheCircleViewState.XCTheCircleViewStateSelected
        }
        self.selectedArray.last?.state = XCTheCircleViewState.XCTheCircleViewStateLastOneSelected
        self.setNeedsDisplay()
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.selectedArray.count>0 && self.gestureBlock != nil{
            var  gestureStr = ""
            for circle in self.selectedArray{
                gestureStr = gestureStr+"\(circle.tag)"
            }
            self.gestureBlock!(self.selectedArray,gestureStr)
        }
        //重置
        if self.selectedArray.first?.state == XCTheCircleViewState.XCTheCircleViewStateError{
            DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                self.resetGesture()
            })
        }else{
            self.resetGesture()
        }
    }
    
    //MARK:- 手势清空重置操作
    func resetGesture(){
         objc_sync_enter(self)
         self.changeCirclesWithSate(state: XCTheCircleViewState.XCTheCircleViewStateNormal)
         self.selectedArray.removeAll()
         objc_sync_exit(self)
    }
    //MARK:- 改变选中数组子控件状态
    func changeCirclesWithSate(state:XCTheCircleViewState){
        for (_,circle) in (self.selectedArray.enumerated()){
            circle.state = state
            if state == .XCTheCircleViewStateNormal{
                circle.angle = 0//角度清空
            }
        }
        self.setNeedsDisplay()
    }
    
    //MARK:- 每添加一个圆计算一次方向,同时处理跳跃连线
    func calculateAngleAndConnectJumpedCircle(){
        print("self.selectedArray->\(self.selectedArray.count)")
        if (self.selectedArray.count > 1){
            // 最后一个对象
            let last1:XCTheCircleView = self.selectedArray.last!
            // 倒数第二个对象
            let last2:XCTheCircleView = self.selectedArray[self.selectedArray.count-2]
            // 计算角度(反正切)
            last2.angle = CGFloat(atan2(Float(last1.center.y-last2.center.y), Float(last1.center.x-last2.center.x)))+CGFloat(Double.pi/2)
            // 跳跃连线问题
             let jumpedCircle = self.selectedCircleContainPoint(point: self.centerPointWithPoint1(point1: last1.center, point2: last2.center))
            if !self.selectedArray.contains(jumpedCircle) && jumpedCircle.tag != 1000{
            // 把跳跃的圆添加到已选择圆的数组(插入到倒数第二个)
                self.selectedArray.insert(jumpedCircle, at: self.selectedArray.count - 1)
            }
        }
    }
    
    //MARK:-  提供两个点返回他们中点
    func centerPointWithPoint1(point1:CGPoint,point2:CGPoint)->CGPoint{
        let x1 = fmax(point1.x, point2.x)
        let x2 = fmin(point1.x, point2.x)
        let y1 = fmax(point1.y, point2.y)
        let y2 = fmin(point1.y, point2.y)
        return CGPoint(x:(x1+x2)/2, y:(y1+y2)/2)
    }
    //MARK:- 判断点是否被圆包含(包含返回圆否则返回nil)
    func selectedCircleContainPoint(point:CGPoint) -> XCTheCircleView{
        var centerCircle = XCTheCircleView()
        centerCircle.tag = 1000
        for (_,circle) in self.subviews.enumerated() {
            if circle.frame.contains(point){
                centerCircle = (circle as? XCTheCircleView)!
                centerCircle.tag = 10
            }
        }
        if !self.selectedArray.contains(centerCircle){
            // 跳跃的点角度和已选择的倒数第二个角度一致
            centerCircle.angle = self.selectedArray[self.selectedArray.count-2].angle
        }
        return centerCircle
    }
    
}






































