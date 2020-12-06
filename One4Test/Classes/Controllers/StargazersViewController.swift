//
//  ViewController.swift
//  One4Test
//
//  Created by Andrea Mario Lufino on 06/12/20.
//

import UIKit


class StargazersViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel: StargazersViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Luminous 🌟"
        
        viewModel = StargazersViewModel.init(withDelegate: self)
        viewModel?.fetchStargazers()
    }
}


// MARK: - Actions

extension StargazersViewController {
    
    @IBAction func refresh() {
        
        viewModel?.fetchStargazers(startingFromFirstPage: true)
    }
}


// MARK: - UITableView - Delegate

extension StargazersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
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
        
        return viewModel?.users?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = Config.CellIdentifiers.stargazer
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! StargazerTableViewCell
        
        let user = viewModel!.users![indexPath.row]
        
        cell.lblLoginName.text = user.username
        cell.profilePicture.roundCorners(UIRectCorner.allCorners, radius: cell.profilePicture.width / 2)
        cell.profilePicture?.download(
            from: URL.init(string: user.avatarURL)!,
            contentMode: UIView.ContentMode.scaleAspectFill,
            placeholder: UIImage.init(named: "User"),
            completionHandler: { (image) in
                
            })
        
        if indexPath.row == (viewModel!.users!.count - 5) {
            // Start fetching next page
            viewModel?.fetchStargazers()
        }
        
        return cell
    }
}


// MARK: - Stargazers View Model - Delegate

extension StargazersViewController: StargazersViewModelDelegate {
    
    func stargazersViewModelDidStartFetching(_ viewModel: StargazersViewModel) {
        
        print("Did started fetching")
        
        navigationController?.view.showBlurredActivityIndicator(withBlurEffect: .dark)
    }
    
    func stargazersViewModelDidFinishFetching(_ viewModel: StargazersViewModel, isLastPage: Bool) {
        
        navigationController?.view.hideBlurredActivityIndicator()
    }
    
    func stargazersViewModel(_ viewModel: StargazersViewModel, didFinishFetchWithSuccess users: [User], isLastPage: Bool) {
        
        tableView.reloadData()
        
        print("There are \(viewModel.users!.count) users now.")
    }
    
    func stargazersViewModel(_ viewModel: StargazersViewModel, didFinishFetchWithError message: String, isLastPage: Bool) {
        
        showAlert(title: "Error", message: message)
    }
    
    func stargazersViewModelNoMoreUsersToFetch(_ viewModel: StargazersViewModel) {
        
        print("No more users to fetch. Current count is \(viewModel.users!.count)")
    }
}
