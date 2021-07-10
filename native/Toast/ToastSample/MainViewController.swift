//
//  MainViewController.swift
//
//  Created by Rakesha Shastri on 10/01/18.
//

import UIKit
import Toast

var i = 0

class MainViewController: UIViewController {
    
    var toastView: ToastView!
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(ButtonTableViewCell.self, forCellReuseIdentifier: "ButtonCell")
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    var timer: CountdownTimer!
    
    @objc func dismissLoadingToast() {
        toastView.animationConfig.action(action: .exit)
        timer.remove()
    }
    
    @objc func demoAllColors() {
        UIView.animate(withDuration: 1, delay: 0, animations: {
            self.toastView.backgroundColor = ToastUtilities.getUIColorWithRGBA(red: 255, green: 227, blue: 121)
            self.toastView.label.textColor = ToastUtilities.getUIColorWithRGBA(red: 54, green: 54, blue: 54)
            self.toastView.layoutIfNeeded()
        }, completion: { (true) in
            UIView.animate(withDuration: 1, delay: 4, animations: {
                self.toastView.backgroundColor = ToastUtilities.getUIColorWithRGBA(red: 184, green: 233, blue: 134)
                self.toastView.label.textColor = ToastUtilities.getUIColorWithRGBA(red: 54, green: 54, blue: 54)
                self.toastView.layoutIfNeeded()
            }, completion: nil)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Toast"
        addTableView()
    }
    
    func addTableView() {
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tableView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        debugPrint("View Deinitialized")
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonTableViewCell
        configure(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func configure(cell: ButtonTableViewCell, indexPath: IndexPath) {
        cell.indexPath = indexPath
        cell.tableView = tableView
        switch indexPath.row {
        case 0:
            cell.button.setTitle("Normal Toast", for: .normal)
        case 1:
            cell.button.setTitle("Toast with Action", for: .normal)
        case 2:
            cell.button.setTitle("Banner Toast", for: .normal)
        case 3:
            cell.button.setTitle("Banner toast templates)", for: .normal)
        default:
            cell.button.setTitle("Cell not configured!", for: .normal)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.bounds.height/4
    }
}
