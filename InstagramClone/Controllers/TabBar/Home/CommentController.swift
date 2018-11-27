//
//  CommentController.swift
//  InstagramClone
//
//  Created by BTK Apple on 26.11.2018.
//  Copyright © 2018 msalihkocak. All rights reserved.
//

import UIKit

class CommentController: UITableViewController, SKInputContainerViewDelegate {
    
    var post:Post?
    var comments = [Comment]()
    
    let cellId = "cellId"
    
    lazy var containerView: SKInputContainerView = {
        let view = SKInputContainerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        view.backgroundColor = .white
        view.delegate = self
        return view
    }()
    
    override var inputAccessoryView: UIView?{
        get{
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "Comments"
        
        setupTableView()
        
        fetchComments()
    }
    
    func setupTableView(){
        tableView.backgroundColor = .white
        tableView.keyboardDismissMode = .interactive
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.register(CommentCell.self, forCellReuseIdentifier: cellId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.hideTabBarAnimated(hide: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.hideTabBarAnimated(hide: false)
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CommentCell
        cell.comment = comments[indexPath.row]
        return cell
    }
    
    func didTapSubmit(with text: String) {
        guard let post = self.post else{ return }
        Service.makeComment(withText: text, to: post, completionBlock: {
            self.fetchComments()
        })
    }
    
    @objc func handleBack(){
        navigationController?.popViewController(animated: true)
    }
}
