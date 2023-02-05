//
//  MainTabController.swift
//  InstagramCloneMVVM
//
//  Created by M. Can Devecioğlu on 20.11.2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import YPImagePicker

class MainTabController: UITabBarController {
    
    var user: User? {
        didSet {
            guard let user = user else { return }
            configureViewControllers(withUser: user)
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfUserLoggedIn()
        fetchUser()
        
    }
    
    // MARK: - API
    
    func fetchUser () {
        guard let uid = Auth.auth().currentUser?.uid else { return }
                UserService.fetchUser(withUID: uid) { user in
            self.user = user
        }
    }
    
    func checkIfUserLoggedIn() {
        if Auth.auth().currentUser == nil {
            
            DispatchQueue.main.async {
                let controller = LoginController()
                controller.delegate = self
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }

        }
    }
    
    
    // MARK: - Helpers
    
    func didFinishPickingMedia(_ picker: YPImagePicker) {
        picker.didFinishPicking { items, _ in
            picker.dismiss(animated: false) {
                guard let selectedImage = items.singlePhoto?.image else { return }
                
                let controller = UploadPostController()
                controller.selectedImage = selectedImage
                controller.delegate = self
                controller.currentUser = self.user
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: false, completion: nil)
            }
        }
    }
    
    func configureViewControllers (withUser user: User) {
        
        self.delegate = self
        
        view.backgroundColor = .white
        
        let layout = UICollectionViewFlowLayout()
        
        let feed          = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: FeedController(collectionViewLayout: layout))
        let search        = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"), rootViewController: SearchController())
        let imageSelector = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected-1"), rootViewController: ImageSelectorController())
        let notification  = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"), rootViewController: NotificationController())
        let profileController       = ProfileController(user: user)
        let profile       = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_selected"), rootViewController: profileController)
        
        viewControllers  = [feed, search, imageSelector, notification, profile]
        tabBar.tintColor = .black
        
    }
    
    func templateNavigationController (unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController {
        
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image         = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor  = .black
        
        return nav
        
    }
}

// MARK: - AuthenticationDelegate

extension MainTabController: AuthenticationDelegate {
    func authenticationDidComplete() {
        fetchUser()
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

extension MainTabController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        
        if index == 2 {
            var config = YPImagePickerConfiguration()
            config.library.mediaType = .photo
            config.shouldSaveNewPicturesToAlbum = false
            config.startOnScreen = .library
            config.screens = [.library]
            config.hidesStatusBar = false
            config.hidesBottomBar = false
            config.library.maxNumberOfItems = 1
            
            let picker = YPImagePicker(configuration: config)
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: true, completion: nil)
            
            didFinishPickingMedia(picker)
        }
        
        return true
    }
    
}

// MARK: - UploadPostControllerDelegate

extension MainTabController: UploadPostControllerDelegate {
    func controllerDidFinishUploadPost(_ controller: UploadPostController) {
        selectedIndex = 0
        controller.dismiss(animated: true, completion: nil)
        
        guard let feedNav = viewControllers?.first as? UINavigationController else { return }
        guard let feed = feedNav.viewControllers.first as? FeedController else { return }
        feed.handleRefresh()
    }
    
    
    
    
}
