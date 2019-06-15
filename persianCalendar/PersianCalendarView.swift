//
//  PersianCalendarView.swift
//  persianCalendar
//
//  Created by Farzaneh on 6/12/19.
//  Copyright © 2019 Farzaneh. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

protocol SwipeToMonthViewDelegate: class {
    func didSwipeMonth(direction: String)
}

struct calendarData {
    var text: String?
    var date: Date?
}

class CalenderView: UIView, MonthViewDelegate {
    
    lazy var persianCal: Calendar = {
        var cal = Calendar(identifier: .persian)
        cal.locale = Locale(identifier: "fa_IR")
        cal.timeZone = TimeZone(abbreviation: "UTC")!
        return cal
    }()
    
    let monthView: MonthView = {
        let v=MonthView()
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    let weekdaysView: WeekdaysView = {
        let v=WeekdaysView()
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    let myCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let myCollectionView=UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        myCollectionView.showsHorizontalScrollIndicator = false
        myCollectionView.translatesAutoresizingMaskIntoConstraints=false
        myCollectionView.backgroundColor=UIColor.clear
        myCollectionView.allowsMultipleSelection=false
        return myCollectionView
    }()
    
    var numOfDaysInMonth = [31,31,31,31,31,31,30,30,30,30,30,29]
    var currentMonthIndex: Int = 0
    var currentYear: Int = 0
    var presentMonthIndex = 0
    var presentYear = 0
    var todaysDate = 0
    var firstWeekDayOfMonth = 0   //(Sunday-Saturday 1-7)
    var delegate: SwipeToMonthViewDelegate?
    var swipeRight:  UISwipeGestureRecognizer!
    var swipeLeft: UISwipeGestureRecognizer!
    var dateSelectedObserver = PublishSubject<calendarData>()
    var expireDay: Int = 30
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initializeView()
    }
    
    convenience init(theme: MyTheme) {
        self.init()
        
        if theme == .dark {
            Style.themeDark()
        } else {
            Style.themeLight()
        }
        
        initializeView()
    }
    
    func initializeView() {
        
        swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.addGestureRecognizer(swipeRight)
        
        swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        
        currentMonthIndex = persianCal.component(.month, from: Date())
        currentYear = persianCal.component(.year, from: Date())
        todaysDate = persianCal.component(.day, from: Date())
        firstWeekDayOfMonth=getFirstWeekDay()
        
        //for leap years, make Esfand month of 30 days
        if currentMonthIndex == 12 && currentYear % 4 == 0 {
            numOfDaysInMonth[currentMonthIndex-1] = 30
        }
        //end
        
        presentMonthIndex=currentMonthIndex
        presentYear=currentYear
        
        setupViews()
        
        myCollectionView.delegate=self
        myCollectionView.dataSource=self
        myCollectionView.register(DateCalendarViewCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    func changeTheme() {
        myCollectionView.reloadData()
        
        monthView.lblName.textColor = Style.monthViewLblColor
        monthView.btnRight.setTitleColor(Style.monthViewBtnRightColor, for: .normal)
        monthView.btnLeft.setTitleColor(Style.monthViewBtnLeftColor, for: .normal)
        
        for i in 0..<7 {
            (weekdaysView.myStackView.subviews[i] as! UILabel).textColor = Style.weekdaysLblColor
        }
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                NotificationCenter.default.post(NSNotification.init(name: NSNotification.Name(rawValue: "swip"), object: nil, userInfo: ["direction": "right"]) as Notification)
            case UISwipeGestureRecognizer.Direction.left:
                
                NotificationCenter.default.post(NSNotification.init(name: NSNotification.Name(rawValue: "swip"), object: nil, userInfo: ["direction": "left"]) as Notification)
            default:
                break
            }
            
            //for leap year, make Esfand month of 30 days
            if currentMonthIndex == 12 {
                if currentYear % 4 == 0 {
                    numOfDaysInMonth[currentMonthIndex-1] = 30
                }
            }
            //end
            firstWeekDayOfMonth=getFirstWeekDay()
            myCollectionView.reloadData()
        }
    }
    
    func setExpireDate(numberOfDays: Int) {
        expireDay = numberOfDays
    }
    
    func getFirstWeekDay() -> Int {
        let day = ("\(currentYear)-\(currentMonthIndex)-01".date?.firstDayOfTheMonth.weekday)!
        //return day == 7 ? 1 : day
        return day+1
    }
    
    func didChangeMonth(monthIndex: Int, year: Int) {
        currentMonthIndex=monthIndex+1
        currentYear = year
        
        //for leap year, make Esfand month of 30 days
        if monthIndex == 12 {
            if currentYear % 4 == 0 {
                numOfDaysInMonth[monthIndex] = 30
            }
        }
        //end
        
        firstWeekDayOfMonth=getFirstWeekDay()
        myCollectionView.reloadData()
        
        monthView.btnRight.isEnabled = !(currentMonthIndex == presentMonthIndex && currentYear == presentYear)
        
        if monthView.btnRight.isEnabled {
            self.addGestureRecognizer(swipeLeft)
        } else {
            self.removeGestureRecognizer(swipeLeft)
        }
    }
    
    func setupViews() {
        addSubview(monthView)
        monthView.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive=true
        monthView.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        monthView.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        monthView.heightAnchor.constraint(equalToConstant: 35).isActive=true
        monthView.delegate=self
        
        addSubview(weekdaysView)
        weekdaysView.topAnchor.constraint(equalTo: monthView.bottomAnchor, constant: 20).isActive=true
        weekdaysView.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        weekdaysView.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        weekdaysView.heightAnchor.constraint(equalToConstant: 30).isActive=true
        
        addSubview(myCollectionView)
        myCollectionView.topAnchor.constraint(equalTo: weekdaysView.bottomAnchor, constant: 20).isActive=true
        myCollectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive=true
        myCollectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive=true
        myCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
        myCollectionView.semanticContentAttribute = .forceRightToLeft
    }
 
}

extension CalenderView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/7 - 8
        let height: CGFloat = 40
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numOfDaysInMonth[currentMonthIndex-1] + firstWeekDayOfMonth - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! DateCalendarViewCell
        cell.backgroundColor=UIColor.clear
        if indexPath.item <= firstWeekDayOfMonth - 2 {
            cell.isHidden=true
        } else {
            let calcDate = indexPath.row-firstWeekDayOfMonth+2
            cell.isHidden=false
            cell.lbl.text="\(calcDate)"
            
            var dateComponents   = DateComponents()
            dateComponents.year  = currentYear
            dateComponents.month = currentMonthIndex
            dateComponents.day   = calcDate
           
            let currentDate = persianCal.date(from: dateComponents)!
            
            var expireDateComponents   = DateComponents()
            expireDateComponents.day  = expireDay
            let expireDate = persianCal.date(byAdding: expireDateComponents, to: Date())!
            
            if calcDate < todaysDate && currentYear == presentYear && currentMonthIndex == presentMonthIndex ||  currentDate > expireDate { //for expire time
                cell.isUserInteractionEnabled=false
                cell.lbl.textColor = Style.labelColor
                
            } else {
                cell.isUserInteractionEnabled=true
                cell.lbl.textColor = Style.activeCellLblColor
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell=collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor=Style.selectedBgColor
        let lbl = cell?.subviews[1] as! UILabel
        lbl.textColor=Style.selectedColor
        
        let calcDate = indexPath.row-firstWeekDayOfMonth+2
        
        var dateComponents   = DateComponents()
        dateComponents.year  = currentYear
        dateComponents.month = currentMonthIndex
        dateComponents.day   = calcDate

        let curDate = persianCal.date(from: dateComponents)!
        let text = curDate.convertToPersianDate()
        
        dateSelectedObserver.onNext(calendarData(text: text, date: curDate))
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell=collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor=UIColor.clear
        let lbl = cell?.subviews[1] as! UILabel
        lbl.textColor = Style.activeCellLblColor
    }
}

