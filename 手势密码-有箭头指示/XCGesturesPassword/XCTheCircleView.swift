//
//  XCTheCircleView.swift
//  手势密码-有箭头指示
//
//  Created by 小崔 on 2018/11/8.
//  Copyright © 2018年 小崔. All rights reserved.
//

import UIKit
/** 圆的状态 */
enum XCTheCircleViewState:Int {
   case XCTheCircleViewStateNormal               = 1
   case XCTheCircleViewStateSelected           = 2
   case XCTheCircleViewStateError              = 3
   case XCTheCircleViewStateLastOneSelected    = 4
   case XCTheCircleViewStateLastOneError       = 5
}

/** 圆的用途 */
enum XCTheCircleViewType:Int {
   case XCTheCircleViewTypeInfo                = 1
   case XCTheCircleViewTypeGesture             = 2
}
class XCTheCircleView: UIView {
    /** 所处状态 */
    var _state:XCTheCircleViewState?
    
    var state:XCTheCircleViewState?
    {
        get{
            return _state
        }
        set{
            _state = newValue
            self.setNeedsDisplay()
        }
    }
    /** 类型 */
    var _type:XCTheCircleViewType?
    var type:XCTheCircleViewType?{
        get{
            return _type
        }
        set{
            _type = newValue
            self.setNeedsDisplay()
        }
    }
    /** 是否有箭头 默认YES */
    var arrow:Bool = isArrow
    /** 角度 */
    var _angle:CGFloat = 0
    
    var angle:CGFloat?
    {
        get{
            return _angle
        }
        set{
            _angle = (newValue)!
            self.setNeedsDisplay()
        }
    }
    /** 初始化 */
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = circleOutNormalBackColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let  ctx = UIGraphicsGetCurrentContext()
        // 上下文旋转
        self.tansformCtx(ctx: ctx!, rect: rect)
        // 画外空心圆
        self.drawOutCircleWithCtx(ctx: ctx!, rect:rect)
        // 画内实心圆
        self.drawInCircleWithCtx(ctx:ctx!,rect:rect)
        // 画三角形
        if _type != XCTheCircleViewType.XCTheCircleViewTypeInfo{
            self.drawTrangleWithCtx(ctx: ctx! , rect:rect)   
        }
      
    }
    
}
//MARK:- 绘制界面的方法
extension XCTheCircleView{
    //MARK:- 上下文旋转
    func tansformCtx(ctx:CGContext,rect:CGRect){
        let translateXY = rect.size.width * 0.5
        ctx.translateBy(x: translateXY, y: translateXY)
        ctx.rotate(by: self._angle)
        ctx.translateBy(x: -translateXY, y: -translateXY)
    }
    //MARK:- 画外空心圆
    func drawOutCircleWithCtx(ctx:CGContext,rect:CGRect){
        let borderW = circleOutBorderWidth
        let circleRect:CGRect = CGRect(x: borderW, y: borderW, width: rect.size.width-borderW*2, height:  rect.size.height-borderW*2)
        let circlePath:CGMutablePath = CGMutablePath()
        circlePath.addEllipse(in: circleRect)
        ctx.addPath(circlePath)
        self.outCircleColor().set()
        ctx.setLineWidth(borderW)
        ctx.strokePath()
    }
    
    //MARK:- 画内实心圆
    func drawInCircleWithCtx(ctx:CGContext,rect:CGRect){
        let  radio:CGFloat = circleInRadio
        let  circleX:CGFloat = rect.size.width/2 * (1-radio) + circleOutBorderWidth;
        let  circleY:CGFloat = rect.size.height/2 * (1-radio) + circleOutBorderWidth;
        let  circleW:CGFloat = rect.size.width*radio - circleOutBorderWidth*2;
        let  circleH:CGFloat = rect.size.height*radio - circleOutBorderWidth*2;
        let  circlePath:CGMutablePath = CGMutablePath();
        circlePath.addEllipse(in: CGRect(x:circleX, y:circleY, width:circleW, height:circleH))
        self.inCircleColor().set()
        ctx.addPath(circlePath)
        ctx.fillPath()
    }
    
    //MARK:- 画三角形
    func drawTrangleWithCtx(ctx:CGContext,rect:CGRect){
        if (self.arrow) {
            let topPoint:CGPoint = CGPoint(x: rect.size.width/2, y: 10)
            let trianglePath:CGMutablePath = CGMutablePath();
            trianglePath.move(to: topPoint)
            trianglePath.addLine(to: CGPoint(x: topPoint.x - trangleLength/2, y: topPoint.y + trangleLength/2))
             trianglePath.addLine(to: CGPoint(x: topPoint.x + trangleLength/2, y: topPoint.y + trangleLength/2))
            ctx.addPath(trianglePath)
            self.trangleColor().set()
            ctx.fillPath()
        }
        
    }
    
    
    
    
    
    //MARK:- 外圆颜色
    func outCircleColor()->UIColor{
        var color:UIColor?
        switch _state {
        case .XCTheCircleViewStateNormal?:
            if _type == XCTheCircleViewType.XCTheCircleViewTypeInfo{
                color = UIColor.lightGray //信息指示的外圈
            }else{
                color = circleOutNormalBorderColor;
            }
            break;
        case .XCTheCircleViewStateSelected?:
             if _type == XCTheCircleViewType.XCTheCircleViewTypeInfo{
                  color = UIColor.lightGray //信息指示的外圈
             }else{
                  color = circleOutSelectedBorderColor
             }
            break;
        case .XCTheCircleViewStateError?:
            color = circleOutErrorBorderColor;
            break;
        case .XCTheCircleViewStateLastOneSelected?:
            color = circleOutSelectedBorderColor;
            break;
        case .XCTheCircleViewStateLastOneError?:
            color = circleOutErrorBorderColor;
            break;
        default:
            color = circleOutNormalBorderColor;
            break;
        }
        return color!
    }
  
    
    //MARK:- 内圆颜色
    func inCircleColor()->UIColor{
        var color:UIColor?
        switch _state {
        case .XCTheCircleViewStateNormal?:
            color = circleInNormalColor;
            break;
        case .XCTheCircleViewStateSelected?:
            color = circleInSelectedColor;
            break;
        case .XCTheCircleViewStateError?:
            color = circleInErrorColor;
            break;
        case .XCTheCircleViewStateLastOneSelected?:
            color = circleInSelectedColor;
            break;
        case .XCTheCircleViewStateLastOneError?:
            color = circleInErrorColor;
            break;
        default:
            color = circleInNormalColor;
            break;
        }
        return color!
    }
    
    //MARK:- 三角形颜色
    func trangleColor()->UIColor{
        var color:UIColor?
        switch _state {
        case .XCTheCircleViewStateNormal?:
            color = trangleNormalColor;
            break;
        case .XCTheCircleViewStateSelected?:
            color = trangleSelectedColor;
            break;
        case .XCTheCircleViewStateError?:
            color = trangleErrorColor;
            break;
        case .XCTheCircleViewStateLastOneSelected?:
            color = trangleNormalColor;
            break;
        case .XCTheCircleViewStateLastOneError?:
            color = trangleErrorColor;
            break;
        default:
            color = trangleNormalColor;
            break;
        }
        return color!
    }
}



































