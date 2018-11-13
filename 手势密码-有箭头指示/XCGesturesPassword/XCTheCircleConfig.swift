//
//  XCTheCircleConfig.swift
//  手势密码-有箭头指示
//
//  Created by 小崔 on 2018/11/8.
//  Copyright © 2018年 小崔. All rights reserved.
//

import UIKit
func XCRGBA(r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat) -> UIColor{
    return UIColor.init(red: r/255.0, green: g/255/0, blue: b/255/0, alpha: a)
}
let MybackgroundColor = UIColor.white
/** 外空心圆普通状态背景颜色  */
let circleOutNormalBackColor = UIColor.clear
/** 外空心圆选中状态背景颜色  */
let circleOutSelectedBackColor = XCRGBA(r: 35, g: 180, b: 250, a: 0.5)
/** 外空心圆错误状态背景颜色  */
let circleOutErrorBackColor = XCRGBA(r: 250, g: 80, b: 90, a: 0.5)
/** 外空心圆普通状态颜色 */
let circleOutNormalBorderColor = XCRGBA(r: 35, g: 180, b: 250, a: 1)
/** 外空心圆选中状态颜色 */
let circleOutSelectedBorderColor = XCRGBA(r: 35, g: 180, b: 250, a: 1)
/** 外空心圆错误状态颜色 */
let circleOutErrorBorderColor = XCRGBA(r: 250, g: 0, b: 0, a: 1)
/** 内实心圆普通状态颜色 */
let circleInNormalColor = UIColor.clear
/** 内实心圆选中状态颜色 */
let circleInSelectedColor = XCRGBA(r: 35, g: 180, b: 250, a: 1)
/** 内实心圆错误状态颜色 */
let circleInErrorColor = XCRGBA(r: 255, g: 0, b: 0, a: 1)

/** 指示三角形普通状态颜色 */
let trangleNormalColor = UIColor.clear
/** 指示三角形选中状态颜色 */
let trangleSelectedColor = XCRGBA(r: 35, g: 180, b: 250, a: 1)
/** 指示三角形错误状态颜色 */
let trangleErrorColor = XCRGBA(r: 255, g: 0, b: 0, a: 1)
//let trangleErrorColor = UIColor.clear

/** 连线选中状态颜色 */
let lineSelectedColor = XCRGBA(r: 35, g: 180, b: 250, a: 1)
/** 连线错误状态颜色 */
let lineErrorColor = XCRGBA(r: 250, g: 80, b: 90, a: 1)

/** 提示文字普通状态颜色 */
let textNormalColor = XCRGBA(r: 150, g: 150, b: 150, a: 1)
/** 提示文字错误状态颜色 */
let textErrorColor = XCRGBA(r: 250, g: 80, b: 90, a: 1)

/** 外空心圆半径 默认30 */
let circleOutRadius:CGFloat = 40
/** 外空心圆边宽 默认1 */
let circleOutBorderWidth:CGFloat = 1
/** 内实心圆占比 默认0.4 */
let circleInRadio:CGFloat = 0.4
/** 指示三角形边长 默认10 */
let trangleLength:CGFloat = 20
/** 连线宽度 默认1.5 */
let lineWidth:CGFloat = 1.5
/** 最少连接圆的个数 默认4 */
let circleLeastNumber:NSInteger = 4
/** 错误状态回显时间 默认1s */
let displayTime:CGFloat = 1
/** 头部信息视图圆半径 默认5 */
let circleInfoRadius:CGFloat = 10
/** 解锁界面左右边距 默认30 */
let lockViewMargin:CGFloat = 30
/** 是否带有箭头 默认有 */
let isArrow = true

/** 保存手势密码到本地 */
let KEYUSERDEFAULTVALUE = "KEYUSERDEFAULTVALUE"



class XCTheCircleConfig: NSObject {

 
    
}
