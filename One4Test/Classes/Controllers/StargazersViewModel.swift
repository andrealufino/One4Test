//
//  StargazersViewModel.swift
//  One4Test
//
//  Created by Andrea Mario Lufino on 06/12/20.
//

import Foundation


protocol StargazersViewModelDelegate {
    func stargazersViewModelDidStartFetching(_ viewModel: StargazersViewModel)
    func stargazersViewModelDidFinishFetching(_ viewModel: StargazersViewModel, isLastPage: Bool)
    func stargazersViewModel(_ viewModel: StargazersViewModel, didFinishFetchWithSuccess users: [User], isLastPage: Bool)
    func stargazersViewModel(_ viewModel: StargazersViewModel, didFinishFetchWithError message: String, isLastPage: Bool)
    func stargazersViewModelNoMoreUsersToFetch(_ viewModel: StargazersViewModel)
}

class StargazersViewModel {
    
    var delegate: StargazersViewModelDelegate?
    
    private var currentPage: Int?
    private var resultsPerPage: Int?
    private var latestNumberOfElementsFetched: Int?
    private var isLastPage: Bool?
    private(set) var users: [User]?
    
    init() {
        setup()
    }
    
    init(withDelegate delegate: StargazersViewModelDelegate) {
        setup()
        self.delegate = delegate
    }
    
    private func setup() {
        currentPage = 1
        resultsPerPage = 100
        latestNumberOfElementsFetched = 0
        isLastPage = false
        
        users = [User]()
    }
    
    func fetchStargazers(startingFromFirstPage: Bool? = false) {
        
        if isLastPage! && !startingFromFirstPage! {
            delegate?.stargazersViewModelNoMoreUsersToFetch(self)
            return
        }
        
        delegate?.stargazersViewModelDidStartFetching(self)
        
        if startingFromFirstPage! {
            users?.removeAll()
            isLastPage = false
            currentPage = 1
        }
        
        APIManager.Github.getStargazers(
            forRepo: "Luminous",
            resultsPerPage: resultsPerPage!,
            page: currentPage!) { (result) in
            
            self.delegate?.stargazersViewModelDidFinishFetching(self, isLastPage: self.isLastPage!)
            
            switch result {
            case .success(let users):
                if startingFromFirstPage! {
                    self.users?.removeAll()
                }
                self.users?.append(contentsOf: users)
                self.delegate?.stargazersViewModel(self, didFinishFetchWithSuccess: users, isLastPage: self.isLastPage!)
                self.latestNumberOfElementsFetched = users.count
                self.isLastPage = self.latestNumberOfElementsFetched! < self.resultsPerPage!
                self.currentPage! += 1
            case .failure(let error):
                self.delegate?.stargazersViewModel(self, didFinishFetchWithError: error.userMessage, isLastPage: self.isLastPage!)
            }
        }
    }
}
