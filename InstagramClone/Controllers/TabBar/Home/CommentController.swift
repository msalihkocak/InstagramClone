//
//  CommentController.swift
//  InstagramClone
//
//  Created by BTK Apple on 26.11.2018.
//  Copyright © 2018 msalihkocak. All rights reserved.
//

import UIKit

class CommentController: UITableViewController {
    
    var post:Post?
    var comments = [Comment]()
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .white
        tableView.keyboardDismissMode = .interactive
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        navigationController?.navigationBar.tintColor = .black
        self.navigationItem.title = "Comments"
        
        tableView.register(CommentCell.self, forCellReuseIdentifier: cellId)
        
        fetchComments()
    }
    
    func fetchComments(){
        guard let post = self.post else{ return }
        Service.fetchComments(of: post) { (comments) in
            self.comments.removeAll(keepingCapacity: false)
            self.comments.append(contentsOf: comments)
            self.comments.sort(by: {$0.timestamp < $1.timestamp})
            DispatchQueue.main.async {
                self.tableView.reloadData()
                let lastIndexPath = IndexPath(row: self.comments.count - 1, section: 0)
                self.tableView.scrollToRow(at: lastIndexPath, at: .top, animated: true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.hideTabBarAnimated(hide: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.hideTabBarAnimated(hide: false)
    }
    
    lazy var containerView:UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        view.backgroundColor = .white
        
        let sendButton = UIButton(type: .system)
        sendButton.tintColor = .buttonBlue
        sendButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        sendButton.setTitle("Submit", for: .normal)
        sendButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        view.addSubview(sendButton)
        sendButton.anchor(top: view.topAnchor, left: nil, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        sendButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15).isActive = true
        
        
        view.addSubview(commentTextField)
        commentTextField.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: sendButton.leftAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        
        return view
    }()
    
    let commentTextField:UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter comment.."
        return textField
    }()
    
    override var inputAccessoryView: UIView?{
        get{
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CommentCell
        cell.comment = comments[indexPath.row]
        return cell
    }
    
    @objc func handleSubmit(){
        guard let post = self.post else{ return }
        Utility.validate([commentTextField]) { (isValid) in
            if isValid{
                guard let text = self.commentTextField.text else{ return }
                Service.makeComment(withText: text, to: post, completionBlock: {
                    self.fetchComments()
                })
                self.resetUI()
            }
        }
    }
    
    func resetUI(){
        commentTextField.text = ""
        commentTextField.resignFirstResponder()
    }
    
    @objc func handleBack(){
        navigationController?.popViewController(animated: true)
    }
}
