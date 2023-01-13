//
//  SearchController.swift
//  InstagramCloneMVVM
//
//  Created by M. Can Devecioğlu on 20.11.2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

private let reuseIdentifier = "UserCell"

class SearchController: UITableViewController {
    
    // MARK: - Properties
    
    private var users = [User]()
    private let searchController = UISearchController(searchResultsController: nil)
    private var filteredUsers = [User]()
    
    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        fetchUsers()
        configureSearchController ()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogOut))
        
        navigationItem.title = "Search"
        
    }
    
    // MARK: - API
    
    func fetchUsers () {
        
        UserService.fetchUsers { users in
            self.users = users
            self.tableView.reloadData()
        }
        
    }
    
    // MARK: - Helpers
    
    @objc func handleLogOut () {
        do {
            try Auth.auth().signOut()
            let controller = LoginController()
            controller.delegate = self.tabBarController as? MainTabController
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        } catch {
            print("DEBUG: Failed to sign out")
        }
    }
    
    func configureTableView() {
        
        view.backgroundColor = .white
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 64
    }
    
    func configureSearchController () {
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = false
        searchController.searchResultsUpdater = self
        
    }
    
}

// MARK: - UITableViewDataSource

extension SearchController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredUsers.count : users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        
        let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        
        cell.viewModel = UserCellViewModel(user: user)
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension SearchController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
}

// MARK: - UISearchResultsUpdating

extension SearchController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        filteredUsers = users.filter({ $0.username.contains(searchText) || $0.fullname.lowercased().contains(searchText) })
        
        self.tableView.reloadData()
    }
    
}
