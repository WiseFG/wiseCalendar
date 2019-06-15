//
//  ViewController.swift
//  persianCalendar
//
//  Created by Farzaneh on 6/12/19.
//  Copyright © 2019 Farzaneh. All rights reserved.
//

import UIKit
import RxSwift

enum MyTheme {
    case light
    case dark
}

class ViewController: UIViewController {
    
    let calenderView: CalenderView = {
        let v=CalenderView(theme: MyTheme.dark)
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    let dateLabel: UILabel = {
        let l=UILabel(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 100, height: 30)))
        l.translatesAutoresizingMaskIntoConstraints=false
        return l
    }()
    
    var dateTimestamp: TimeInterval?
    var theme = MyTheme.dark
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "تقویم فارسی"
        self.navigationController?.navigationBar.isTranslucent=false
        self.view.backgroundColor=Style.bgColor
        
        view.addSubview(calenderView)
        calenderView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive=true
        calenderView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive=true
        calenderView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive=true
        calenderView.heightAnchor.constraint(equalToConstant: 440).isActive=true
        
        calenderView.dateSelectedObserver.subscribe({date in
            self.dateTimestamp =  date.event.element?.date?.timeIntervalSince1970
            let text = date.event.element?.text!
            self.dateLabel.text = "تاریخ انقضا: \(text!)"
            self.dateLabel.textColor =  Style.activeCellLblColor
        }).disposed(by: self.disposeBag)
        
        view.addSubview(dateLabel)
        dateLabel.topAnchor.constraint(equalTo: calenderView.bottomAnchor, constant: 10).isActive=true
        dateLabel.rightAnchor.constraint(equalTo: calenderView.rightAnchor, constant: -10).isActive=true

        let img = UIImage(named: "theme")?.withRenderingMode(.alwaysTemplate)
        let rightBarBtn = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(rightBarBtnAction))
        rightBarBtn.tintColor = Style.bgColor
        self.navigationItem.rightBarButtonItem = rightBarBtn
    }
    
    override func viewWillLayoutSubviews() {

        super.viewWillLayoutSubviews()
        calenderView.myCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    @objc func rightBarBtnAction(sender: UIBarButtonItem) {
        if theme == .dark {
            theme = .light
            Style.themeLight()
        } else {
            theme = .dark
            Style.themeDark()
        }
        self.view.backgroundColor=Style.bgColor
        calenderView.changeTheme()
    }

}

