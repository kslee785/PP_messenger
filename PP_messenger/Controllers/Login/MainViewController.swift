//
//  LoginViewController.swift
//  PP_messenger
//
//  Created by Kevin Lee on 1/30/21.
//

import UIKit

final class MainViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let signinButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign up", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        signinButton.addTarget(self,
                              action: #selector(signinButtonTapped),
                              for: .touchUpInside)
        signUpButton.addTarget(self,
                              action: #selector(didTapSignup),
                              for: .touchUpInside)
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(signinButton)
        scrollView.addSubview(signUpButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = scrollView.width / 3
        imageView.frame = CGRect(x: (scrollView.width - size) / 4,
                                 y: scrollView.height / 7,
                                 width: size * 2,
                                 height: size * 2)
        signinButton.frame = CGRect(x: 30,
                                   y: imageView.bottom + 130,
                                   width: scrollView.width - 60,
                                   height: 52)
        signUpButton.frame = CGRect(x: 30,
                                   y: signinButton.bottom + 20,
                                   width: scrollView.width - 60,
                                   height: 52)
    }
    
    @objc private func signinButtonTapped() {
        let vc = LoginViewController()
//        vc.title = "Sign In"
//        navigationController?.pushViewController(vc, animated: true)
        vc.title = "Sign In"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapSignup() {
        let vc = RegisterViewController()
        vc.title = "Sign Up"
        navigationController?.pushViewController(vc, animated: true)
    }
}
