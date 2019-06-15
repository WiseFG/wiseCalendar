//
//  MouthView.swift
//  persianCalendar
//
//  Created by Farzaneh on 6/12/19.
//  Copyright © 2019 Farzaneh. All rights reserved.
//

import UIKit

protocol MonthViewDelegate: class {
    func didChangeMonth(monthIndex: Int, year: Int)
}

var monthsArr = ["فروردین", "اردیبهشت", "خرداد", "تیر", "مرداد", "شهریور", "مهر", "آبان", "آذر", "دی", "بهمن", "اسفند"]

class MonthView: UIView {
    
    let lblName: UILabel = {
        let lbl=UILabel()
        lbl.textColor = Style.monthViewLblColor
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    
    let btnRight: UIButton = {
        let btn=UIButton()
        let img = UIImage(named: "right-arrow")?.withRenderingMode(.alwaysTemplate)
        btn.tintColor =  #colorLiteral(red: 0.1960784314, green: 0.6666666667, blue: 0.7843137255, alpha: 1)
        btn.setImage(img, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints=false
        btn.addTarget(self, action: #selector(btnLeftRightAction(sender:)), for: .touchUpInside)
        return btn
    }()
    
    let btnLeft: UIButton = {
        let btn=UIButton()
        let img = UIImage(named: "left-arrow")?.withRenderingMode(.alwaysTemplate)
        btn.tintColor =  #colorLiteral(red: 0.1960784314, green: 0.6666666667, blue: 0.7843137255, alpha: 1)
        btn.setImage(img, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints=false
        btn.addTarget(self, action: #selector(btnLeftRightAction(sender:)), for: .touchUpInside)
        return btn
    }()
    
    var currentMonthIndex = 0
    var currentYear: Int = 0
    var delegate: MonthViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor=UIColor.clear
        
        var cal = Calendar(identifier: .persian)
        cal.locale = Locale(identifier: "fa_IR")
        currentMonthIndex = cal.component(.month, from: Date()) - 1
        currentYear = cal.component(.year, from: Date())
        
        setupViews()
        
        btnRight.isEnabled=false
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleSwip(_:)), name:NSNotification.Name(rawValue: "swip"), object: nil)
    }
    
    func setupViews() {
        self.addSubview(lblName)
        lblName.topAnchor.constraint(equalTo: topAnchor).isActive=true
        lblName.centerXAnchor.constraint(equalTo: centerXAnchor).isActive=true
        lblName.widthAnchor.constraint(equalToConstant: 150).isActive=true
        lblName.heightAnchor.constraint(equalTo: heightAnchor).isActive=true
        lblName.text="\(monthsArr[currentMonthIndex]) \(currentYear)"
        
        self.addSubview(btnRight)
        btnRight.topAnchor.constraint(equalTo: topAnchor).isActive=true
        btnRight.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive=true
        btnRight.widthAnchor.constraint(equalToConstant: 30).isActive=true
        btnRight.heightAnchor.constraint(equalToConstant: 30).isActive=true
        
        self.addSubview(btnLeft)
        btnLeft.topAnchor.constraint(equalTo: topAnchor).isActive=true
        btnLeft.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive=true
        btnLeft.widthAnchor.constraint(equalToConstant: 30).isActive=true
        btnLeft.heightAnchor.constraint(equalToConstant: 30).isActive=true
    }
    
    @objc func handleSwip(_ notification: NSNotification) {
        
        switch notification.userInfo?["direction"] as! String {
        case "right":
            currentMonthIndex += 1
            if currentMonthIndex > 11 {
                currentMonthIndex = 0
                currentYear += 1
            }
        case "left":
            currentMonthIndex -= 1
            if currentMonthIndex < 0 {
                currentMonthIndex = 11
                currentYear -= 1
            }
        default:
            break
        }
        lblName.text="\(monthsArr[currentMonthIndex]) \(currentYear)"
        delegate?.didChangeMonth(monthIndex: currentMonthIndex, year: currentYear)
    }
    
    @objc func btnLeftRightAction(sender: UIButton) {
        if sender == btnLeft {
            currentMonthIndex += 1
            if currentMonthIndex > 11 {
                currentMonthIndex = 0
                currentYear += 1
            }
        } else {
            currentMonthIndex -= 1
            if currentMonthIndex < 0 {
                currentMonthIndex = 11
                currentYear -= 1
            }
        }
        lblName.text="\(monthsArr[currentMonthIndex]) \(currentYear)"
        delegate?.didChangeMonth(monthIndex: currentMonthIndex, year: currentYear)
    }
}

