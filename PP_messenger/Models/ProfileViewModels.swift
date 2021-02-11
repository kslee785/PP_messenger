//
//  ProfileViewModels.swift
//  PP_messenger
//
//  Created by Kevin Lee on 2/10/21.
//

import Foundation

enum ProfileViewModelType {
    case info, logout
}

struct ProfileViewModel {
    let viewModelType: ProfileViewModelType
    let title: String
    let handler: (() -> Void)?
}
