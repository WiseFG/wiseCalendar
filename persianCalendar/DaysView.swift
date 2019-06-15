//
//  DaysView.swift
//  persianCalendar
//
//  Created by Farzaneh on 6/12/19.
//  Copyright © 2019 Farzaneh. All rights reserved.
//

import Foundation
import UIKit

class WeekdaysView: UIView {
    let myStackView: UIStackView = {
        let stackView=UIStackView()
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints=false
        return stackView
    }()
    var daysArr = ["شنبه", "یکشنبه", "دوشنبه", "سه شنبه", "چهارشنبه", "پنج شنبه", "جمعه"]
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor=UIColor.clear
        
        setupViews()
    }
    
    func setupViews() {
        addSubview(myStackView)
        myStackView.topAnchor.constraint(equalTo: topAnchor).isActive=true
        myStackView.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        myStackView.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        myStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
        myStackView.semanticContentAttribute = .forceRightToLeft
        
        for i in 0..<7 {
            let lbl=UILabel()
            lbl.text=daysArr[i]
            lbl.font = UIFont.systemFont(ofSize: 11)
            lbl.textAlignment = .center
            lbl.textColor = Style.weekdaysLblColor
            myStackView.addArrangedSubview(lbl)
        }
    }
}
