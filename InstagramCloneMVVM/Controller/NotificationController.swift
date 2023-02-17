//
//  NotificationController.swift
//  InstagramCloneMVVM
//
//  Created by M. Can Devecioğlu on 20.11.2022.
//

import UIKit

private let reuseIdentifier = "NotificationCell"

class NotificationController: UITableViewController {
    
    // MARK: - Properties
    
    private var notifications = [Notification]() {
        didSet { tableView.reloadData() }
    }
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        fetchNotifications()
        
    }
    
    // MARK: - API
    
    func fetchNotifications() {
        NotificationService.fetchNotification { notifications in
            self.notifications = notifications
            print("DEBUG: \(notifications)")
        }
    }
    
    // MARK: - Helpers
    
    func configureTableView() {
        view.backgroundColor = .white
        navigationItem.title = "Notifications"
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 70
        tableView.separatorStyle = .none
    }
}

extension NotificationController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell
        cell.viewModel = NotificationViewModel(notification: notifications[indexPath.row])
        return cell
    }
    
}
