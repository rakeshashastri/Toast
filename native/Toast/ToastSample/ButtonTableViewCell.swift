//
//  ButtonTableViewCell.swift
//
//  Created by Rakesha Shastri on 17/04/18.
//

import UIKit
import Toast

class ButtonTableViewCell: UITableViewCell {
    
    lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(showToast), for: .touchUpInside)
        return button
    }()
    
    var indexPath: IndexPath!
    var toastView: ToastView!
    var tableView: UITableView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
    }
    
    @objc func showToast() {
        switch indexPath.row {
        case 0:
            toastView = ToastProfiles.getToast(titleStrings: ["Hey there!"], type: .normal, view: nil, target: self, selector: #selector(changeColor))
        case 1:
            toastView = ToastProfiles.getToast(titleStrings: ["Click the button to change color."], buttonTitle: "YELLOW", type: .action, view: nil, target: self, selector: #selector(changeColor))
        case 2:
            toastView = ToastProfiles.getToast(titleStrings: ["Well this seems to be a banner. :o", "Here is some mandatory banner messsage. Have a nice day. :D"], type: .banner, view: tableView.superview)
        case 3:
            toastView = ToastProfiles.getToast(titleStrings: ["Hmm... something's loading apparently. :#"], type: .progressIndicator, view: tableView.superview)
            toastView.animationConfig.persist = false
            toastView.animationConfig.displayDuration = 3
        case 4:
            toastView = ToastProfiles.getToast(titleStrings: ["Well these are all the colors the banner toast comes with."], type: .banner, color: .red, view: tableView.superview, target: self)
        default:
            debugPrint("Default didSelect")
        }
        toastView.showToast()
        if indexPath.row == 4 {
            let timer = CountdownTimer(duration: 2, selector: #selector(demoAllColors), target: self)
            timer.start()
        }
    }
    
    @objc func demoAllColors() {
        UIView.animate(withDuration: 1, delay: 0, animations: {
            self.toastView.actionButton.tintColor = .black
            self.toastView.backgroundColor = ToastUtilities.getUIColorWithRGBA(red: 255, green: 227, blue: 121)
            self.toastView.label.textColor = ToastUtilities.getUIColorWithRGBA(red: 54, green: 54, blue: 54)
            self.toastView.layoutIfNeeded()
        }, completion: { (true) in
            UIView.animate(withDuration: 1, delay: 2, animations: {
                self.toastView.backgroundColor = ToastUtilities.getUIColorWithRGBA(red: 184, green: 233, blue: 134)
                self.toastView.label.textColor = ToastUtilities.getUIColorWithRGBA(red: 54, green: 54, blue: 54)
                self.toastView.layoutIfNeeded()
            }, completion: nil)
        })
    }
    
    @objc func changeColor() {
        tableView.backgroundColor = .yellow
        toastView = ToastProfiles.getToast(titleStrings: ["Regret it? :'D"], buttonTitle: "UNDO", type: .action, view: nil, target: self, selector: #selector(changeColorBack))
        toastView.showToast()
    }
    
    @objc func changeColorBack() {
        tableView.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
