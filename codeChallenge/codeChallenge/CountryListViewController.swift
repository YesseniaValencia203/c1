//
//  ViewController.swift
//  codeChallenge
//
//  Created by Consultant on 9/12/23.
//

import UIKit

class CountryListViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    var search = UISearchController(searchResultsController: nil)
    var countries = [Country]()
    var filteredList = [Country]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        getCountries()
        setupSearchBar()
    }
    
    func getCountries() {
        let path = URL(string: CountriesEndpoints.countriesAPI)
        URLSession.shared.getRequest(url: path, decoding: Countries.self) { [weak self] result in
            switch result {
            case .success(let info):
                DispatchQueue.main.async {
                    self?.countries = info
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print("Getting countries: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func setupSearchBar() {
        search.searchBar.placeholder = "Search countries"
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = search
        definesPresentationContext = true
    }

}

extension CountryListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !(search.searchBar.text?.isEmpty ?? true) && search.isActive {
            return filteredList.count
        }
        return countries.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CountryTableViewCell
        var country: Country
        if !(search.searchBar.text?.isEmpty ?? true) && search.isActive {
            country = filteredList[indexPath.row]
        } else {
            country = countries[indexPath.row]
        }
        cell.countryName.text = "\(country.name), \(country.region)  \(country.code)"
        cell.countryCapital.text = "\(country.capital)"
        return cell
    }
}

extension CountryListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        filterContent(for: searchText)
    }
    
    private func filterContent(for searchText: String) {
        filteredList = countries.filter { country in
            let searchString = searchText.lowercased()
            return country.name.lowercased().contains(searchString) || country.capital.lowercased().contains(searchString)
        }
        tableView.reloadData()
    }
    
}
