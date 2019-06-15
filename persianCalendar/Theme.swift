//
//  Theme.swift
//  persianCalendar
//
//  Created by Farzaneh on 6/12/19.
//  Copyright © 2019 Farzaneh. All rights reserved.
//

import Foundation
import UIKit

struct Style {
    static var bgColor = UIColor.white
    static var monthViewLblColor = UIColor.white
    static var monthViewBtnRightColor = UIColor.white
    static var monthViewBtnLeftColor = UIColor.white
    static var activeCellLblColor = UIColor.white
    static var activeCellLblColorHighlighted = UIColor.black
    static var weekdaysLblColor = UIColor.white
    static var selectedBgColor = UIColor.white
    static var selectedColor = UIColor.white
    static var labelColor = UIColor.darkGray
    
    static func themeDark(){
        bgColor = #colorLiteral(red: 0.1019607843, green: 0.3333333333, blue: 0.3921568627, alpha: 1)
        monthViewLblColor = UIColor.white
        monthViewBtnRightColor = UIColor.white
        monthViewBtnLeftColor = UIColor.white
        activeCellLblColor = #colorLiteral(red: 0.6745098039, green: 0.8666666667, blue: 0.9176470588, alpha: 1)
        activeCellLblColorHighlighted = UIColor.black
        weekdaysLblColor = UIColor.white
        selectedBgColor = #colorLiteral(red: 0.5098039216, green: 0.8, blue: 0.8745098039, alpha: 1)
        selectedColor = #colorLiteral(red: 0.1102318093, green: 0.3704591393, blue: 0.4381931126, alpha: 0.8)
        labelColor = #colorLiteral(red: 0.421790719, green: 0.5567498803, blue: 0.5908944011, alpha: 0.8)
    }
    
    static func themeLight(){
        bgColor = #colorLiteral(red: 0.6745098039, green: 0.8666666667, blue: 0.9176470588, alpha: 1)
        monthViewLblColor = UIColor.black
        monthViewBtnRightColor = UIColor.black
        monthViewBtnLeftColor = UIColor.black
        activeCellLblColor = #colorLiteral(red: 0.1019607843, green: 0.3333333333, blue: 0.3921568627, alpha: 1)
        activeCellLblColorHighlighted = UIColor.white
        weekdaysLblColor = UIColor.black
        selectedBgColor = #colorLiteral(red: 0.1960784314, green: 0.6666666667, blue: 0.7843137255, alpha: 1)
        selectedColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        labelColor = #colorLiteral(red: 0.1019607843, green: 0.3333333333, blue: 0.3921568627, alpha: 0.5)
    }
}
