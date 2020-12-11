//
//  ViewController.swift
//  BreakingBadCharacterExplorer
//
//  Created by Sharaf Nazaar on 12/10/20.
//

import UIKit
import Foundation
import SDWebImage

class SearchViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchB: UISearchBar!
    @IBOutlet weak var charactersTableView: UITableView!
    var allCharacters: [Character] = []
    var allCharactersFiltered: [Character] = []
    var maxSeasons = 0
    var currentScope = 0
    var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showMessage("")
        self.title = "Breaking Bad Character Explorer"
        charactersTableView.register(UINib(nibName: "CharacterCell", bundle: nil), forCellReuseIdentifier: "characterCell")
        charactersTableView.separatorStyle = .singleLine
        
        self.navigationItem.backButtonTitle = "Back"
        searchB.placeholder = "Search by Name or filter by Seasons"
        searchB.scopeButtonTitles = ["All","1", "2","3","4","5"]
        searchB.delegate = self

        let api = APIClient()
        api.getCharacters(completionHandler: { (response, error) in
            if let response = response {
                self.allCharacters = response
                self.allCharactersFiltered = self.allCharacters
                DispatchQueue.main.async {
                    if self.allCharacters.count == 0 {
                       self.messageLabel.text = "No Results. Try Again"
                    }
                    else {
                       self.messageLabel.text = ""
                    }
                    self.charactersTableView.reloadData()
                    self.updateSearchScope()
                }
            }
            else {
                DispatchQueue.main.async {
                    self.messageLabel.text = "An error occured. Please try Again"
                }
            }
        })
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
       
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
        if searchText == "" {
            if(currentScope > 0){
                self.allCharactersFiltered = self.allCharacters.filter {($0.appearance?.contains(currentScope)) ?? true}
            }
            else {
                self.allCharactersFiltered = self.allCharacters
            }
        }
        else {
            if (currentScope == 0) {
                self.allCharactersFiltered = self.allCharacters.filter { $0.name.localizedCaseInsensitiveContains(searchText)}
            }
            else {
                self.allCharactersFiltered = self.allCharacters.filter { $0.name.localizedCaseInsensitiveContains(searchText) && ($0.appearance?.contains(currentScope)) ?? true}
            }
        }
        self.charactersTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar,
          selectedScopeButtonIndexDidChange selectedScope: Int) {
        searchBar.text = ""

        currentScope = selectedScope
        switch searchBar.scopeButtonTitles![selectedScope] {
            case "All":
                self.allCharactersFiltered = self.allCharacters
            default:
                self.allCharactersFiltered = allCharacters.filter({($0.appearance?.contains(selectedScope)) ?? true})
        }
        self.charactersTableView.reloadData()
    }

    func updateSearchScope () {
        for character in self.allCharacters {
            if let appearance = character.appearance {
                if self.maxSeasons < appearance.max()! {
                    self.maxSeasons = appearance.max()!
                }
            }
        }
    
        var scopeButtonTitles = ["All"]
        for i in 1...maxSeasons {
            scopeButtonTitles.append("\(i)")
        }
        searchB.scopeButtonTitles = scopeButtonTitles
    }

    func showMessage (_ message : String) {
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        messageLabel = UILabel(frame: rect)
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        self.charactersTableView.backgroundView = messageLabel
    }
}
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCharactersFiltered.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "characterCell", for: indexPath) as! CharacterCell
        cell.nameLabel.text = allCharactersFiltered[indexPath.row].name
        let sizeTransformer = SDImageResizingTransformer(size: CGSize(width: 300, height: 400),scaleMode: .aspectFill)
        let roundCornerTransformer = SDImageRoundCornerTransformer(radius: 40, corners: .allCorners, borderWidth: 2.0, borderColor: UIColor.clear)
        let pipeLineTransformer = SDImagePipelineTransformer(transformers: [sizeTransformer, roundCornerTransformer])

        cell.charImageView.sd_setImage(with: URL(string: allCharactersFiltered[indexPath.row].img), placeholderImage: UIImage(named: "placeholder"), context: [.imageTransformer : pipeLineTransformer])
        
        return cell
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedCharacter = allCharactersFiltered[indexPath.row]
            if let viewController = storyboard?.instantiateViewController(identifier: "charDetailVC") as? CharacterDetailViewController {
                viewController.selectedCharacter = selectedCharacter
                navigationController?.pushViewController(viewController, animated: true)
            }
        tableView.deselectRow(at: indexPath, animated: true)
    }    
}


