//
//  StargazersViewModel.swift
//  One4Test
//
//  Created by Andrea Mario Lufino on 06/12/20.
//

import Foundation


protocol StargazersViewModelDelegate {
    func stargazersViewModelDidStartFetching(_ viewModel: StargazersViewModel)
    func stargazersViewModelDidFinishFetching(_ viewModel: StargazersViewModel)
    func stargazersViewModel(_ viewModel: StargazersViewModel, didFinishFetchWithSuccess users: [User])
    func stargazersViewModel(_ viewModel: StargazersViewModel, didFinishFetchWithError message: String)
}

class StargazersViewModel {
    
    var delegate: StargazersViewModelDelegate?
    
    init() { }
    
    init(withDelegate delegate: StargazersViewModelDelegate) {
        self.delegate = delegate
    }
    
    func fetchStargazers() {
        
        delegate?.stargazersViewModelDidStartFetching(self)
        
        APIManager.Github.getStargazers(
            forRepo: "Luminous",
            resultsPerPage: 50,
            page: 1) { (result) in
            
            self.delegate?.stargazersViewModelDidFinishFetching(self)
            
            Notifier.post(Notification.Name.Stargazers.didFinishFetch)
            
            switch result {
            case .success(let users):
                self.delegate?.stargazersViewModel(self, didFinishFetchWithSuccess: users)
                Notifier.post(Notification.Name.Stargazers.didFinishFetchWithSuccess)
            case .failure(let error):
                self.delegate?.stargazersViewModel(self, didFinishFetchWithError: error.userMessage)
                Notifier.post(Notification.Name.Stargazers.didFinishFetchWithError)
            }
        }
    }
}
