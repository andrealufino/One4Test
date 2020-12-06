//
//  ViewController.swift
//  One4Test
//
//  Created by Andrea Mario Lufino on 06/12/20.
//

import UIKit


class StargazersViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var users: [User]?
    var viewModel: StargazersViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        viewModel = StargazersViewModel.init(withDelegate: self)
        
        viewModel?.fetchStargazers()
    }
}


// MARK: - UITableView - Delegate

extension StargazersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
}


// MARK: - UITableView - Data Source

extension StargazersViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = Config.CellIdentifiers.stargazer
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! StargazerTableViewCell
        
        let user = users![indexPath.row]
        
        cell.lblLoginName.text = user.username
        cell.profilePicture.roundCorners(UIRectCorner.allCorners, radius: cell.profilePicture.width / 2)
        cell.profilePicture?.download(
            from: URL.init(string: user.avatarURL)!,
            contentMode: UIView.ContentMode.scaleAspectFill,
            placeholder: UIImage.init(named: "User"),
            completionHandler: { (image) in
                
            })
        
        return cell
    }
}


// MARK: - Stargazers View Model - Delegate

extension StargazersViewController: StargazersViewModelDelegate {
    
    func stargazersViewModelDidStartFetching(_ viewModel: StargazersViewModel) {
        
        view.showBlurredActivityIndicator(withBlurEffect: .dark)
    }
    
    func stargazersViewModelDidFinishFetching(_ viewModel: StargazersViewModel) {
        
        view.hideBlurredActivityIndicator()
    }
    
    func stargazersViewModel(_ viewModel: StargazersViewModel, didFinishFetchWithSuccess users: [User]) {
        
        self.users = users
        
        tableView.reloadData()
    }
    
    func stargazersViewModel(_ viewModel: StargazersViewModel, didFinishFetchWithError message: String) {
        
        showAlert(title: "Error", message: message)
    }
    
    
    
}
