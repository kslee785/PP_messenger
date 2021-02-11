//
//  2ProfileViewController.swift
//  PP_messenger
//
//  Created by Kevin Lee on 2/10/21.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn
import SDWebImage

class ProfileViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let nameLabel: UILabel = {
        let name = UILabel()
        name.text = "Name: \(UserDefaults.standard.value(forKey: "name") as? String ?? "No Name")"
        name.font = .systemFont(ofSize: 23, weight: .medium)
        name.textAlignment = .left
        name.textColor = .secondarySystemFill
        return name
    }()
    
    private let emailLabel: UILabel = {
        let email = UILabel()
        email.text = "Email: \(UserDefaults.standard.value(forKey: "email") as? String ?? "No Email")"
        email.font = .systemFont(ofSize: 23, weight: .medium)
        email.textAlignment = .left
        email.textColor = .secondarySystemFill
        return email
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log Out", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        return button
    }()
    
    private var profilePic: UIView! {
        self.createTableHeader()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        logoutButton.addTarget(self,
                               action: #selector(didTapLogout),
                               for: .touchUpInside)
        
        view.addSubview(scrollView)
        scrollView.addSubview(profilePic)
        scrollView.addSubview(nameLabel)
        scrollView.addSubview(emailLabel)
        scrollView.addSubview(logoutButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        
        nameLabel.frame = CGRect(x: 10,
                                 y: profilePic.bottom,
                                 width: view.width * 0.7,
                                 height: 30)
        emailLabel.frame = CGRect(x: 10,
                                  y: nameLabel.bottom + 10,
                                 width: view.width * 0.7,
                                 height: 30)
        logoutButton.frame = CGRect(x: 0,
                                    y: view.bottom - emailLabel.bottom,
                                    width: view.width,
                                    height: 30)
    }
    
    func createTableHeader() -> UIView? {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        let fileName =  safeEmail + "_profile_picture.png"
        let path = "images/" + fileName
        
        let headerView = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: self.view.width,
                                              height: 300))
        
        headerView.backgroundColor = .systemBackground
        
        let imageView = UIImageView(frame: CGRect(x: (headerView.width - 150) / 2,
                                                  y: 75,
                                                  width: 150,
                                                  height: 150))
        
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemBackground
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.width / 2
        headerView.addSubview(imageView)
        StorageManager.shared.downloadUrl(for: path, completion: { result in
            switch result {
            case .success(let url):
                imageView.sd_setImage(with: url, completed: nil)
            case .failure(let error):
                print("error to download url: \(error)")
            }
        })
        
        return headerView
    }
    
    @objc private func didTapLogout() {
        let strongSelf = self
        
        let actionSheet = UIAlertController(title: "",
                                            message: "",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Log Out",
                                            style: .destructive,
                                            handler: { [weak self] _ in
                                                
                                                guard let strongSelf = self else {
                                                    return
                                                }
                                                
                                                UserDefaults.standard.setValue(nil, forKey: "email")
                                                UserDefaults.standard.setValue(nil, forKey: "name")
                                                
                                                // Log Out facebook
                                                FBSDKLoginKit.LoginManager().logOut()
                                                
                                                // Google Log out
                                                GIDSignIn.sharedInstance()?.signOut()
                                                
                                                do {
                                                    try FirebaseAuth.Auth.auth().signOut()
                                                    
                                                    let vc = LoginViewController()
                                                    let nav = UINavigationController(rootViewController: vc)
                                                    nav.modalPresentationStyle = .fullScreen
                                                    strongSelf.present(nav, animated: true)
                                                }
                                                catch {
                                                    print("Failed to log out")
                                                }
                                                
                                            }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        
        strongSelf.present(actionSheet, animated: true)
    }
    
}
