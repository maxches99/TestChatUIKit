//
//  ViewController.swift
//  TestChatUIKit
//
//  Created by Максим Чесников on 28.06.2022.
//

import UIKit

protocol MessageListViewInput: AnyObject {
    func reloadData()
    
    func setNetworkErrorState()
    
    func reloadRows(at indexPaths: [IndexPath])
    
    func deleteRows(at indexPaths: [IndexPath])
}

class MessageListVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    var output: MessageListViewOutput?
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var keyboardHeightBottom: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareTableView()
        
        prepareTextField()
        
        output?.viewAppeared()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    func prepareTextField() {
        textField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func prepareTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(UINib(nibName: "IncomingMessageCell", bundle: nil), forCellReuseIdentifier: "IncomingMessageCell")
        tableView.register(UINib(nibName: "LoadingCell", bundle: nil), forCellReuseIdentifier: "LoadingCell")
        tableView.register(UINib(nibName: "OutgoingMessageCell", bundle: nil), forCellReuseIdentifier: "OutgoingMessageCell")
        
        tableView.transform = CGAffineTransform(rotationAngle: (-.pi))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        
        tableView.keyboardDismissMode = .onDrag
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        keyboardHeightBottom.constant = -keyboardSize.height + 20
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        keyboardHeightBottom.constant = 0
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        output?.sendMessage(text: textField.text)
        textField.text?.removeAll()
        return true
    }
}

extension MessageListVC {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return output?.numberOfRowsInSection(section: section) ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = output?.getMessage(by: indexPath)
        if indexPath.section == 0 {
            switch cellModel?.type {
            case .Outgoing:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "OutgoingMessageCell", for: indexPath) as? OutgoingMessageCell {
                    cell.configure(messageModel: cellModel!)
                    cell.transform = CGAffineTransform(rotationAngle: (-.pi))
                    return cell
                } else {
                    return UITableViewCell()
                }
            default:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "IncomingMessageCell", for: indexPath) as? IncomingMessageCell {
                    cell.configure(messageModel: cellModel!)
                    cell.transform = CGAffineTransform(rotationAngle: (-.pi))
                    return cell
                } else {
                    return UITableViewCell()
                }
            }
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath) as! LoadingCell
            switch output?.state {
            case .loading:
                cell.activityIndicator.startAnimating()
            default:
                cell.activityIndicator.stopAnimating()
            }
            return cell
        }
        
    }
}
extension MessageListVC {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        output?.willDisplay(forRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        output?.tapOnMessage(by: indexPath)
    }
    
}

extension MessageListVC: MessageListViewInput {
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func setNetworkErrorState() {
        
    }
    
    func reloadRows(at indexPaths: [IndexPath]) {
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    func deleteRows(at indexPaths: [IndexPath]) {
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
}
